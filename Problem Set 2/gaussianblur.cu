#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;
using namespace std;
__global__
void gaussian_blur(const unsigned char* const inputChannel,
	unsigned char* const outputChannel,
	int numRows, int numCols,
	const float* const filter, const int filterWidth)
{
	int col = blockIdx.x * blockDim.x + threadIdx.x;
	int row = blockIdx.y * blockDim.y + threadIdx.y;

	//check if the indices are out of bound
	if (col >= numCols || row >= numRows)
	{
		return;
	}
	int index = row * numCols + col;
	float pixelvalue = 0.0f;
	int filter_index = 0;
	for (int i = row - (filterWidth - 1) / 2; i <= row + (filterWidth - 1) / 2; ++i)
	{
		for (int j = row - (filterWidth - 1) / 2; j <= row + (filterWidth - 1) / 2; ++j)
		{
			if (i >= 0 && j >= 0 && i < numRows && j < numCols)
			{
				int id = i * numCols + col;
				pixelvalue += (float)inputChannel[id] * filter[filter_index];
			}
			++filter_index;
		}
	}
	outputChannel[index] = (unsigned char)pixelvalue;
}
__global__
void separateChannels(const uchar4* const inputImageRGBA,
	int numRows,
	int numCols,
	unsigned char* const redChannel,
	unsigned char* const greenChannel,
	unsigned char* const blueChannel)
{
	int col = blockIdx.x * blockDim.x + threadIdx.x;
	int row = blockIdx.y * blockDim.y + threadIdx.y;

	//check if the indices are out of bound
	if (col >= numCols || row >= numRows)
	{
		return;
	}
	int index = row * numCols + col;
	uchar4 pixel_value = inputImageRGBA[index];
	redChannel[index] = pixel_value.x;
	greenChannel[index] = pixel_value.y;
	blueChannel[index] = pixel_value.z;
}

__global__
void combineChannels(uchar4* const outputImageRGBA,
	int numRows,
	int numCols,
	const unsigned char* const redChannel,
	const unsigned char* const greenChannel,
	const unsigned char* const blueChannel)
{
	int col = blockIdx.x * blockDim.x + threadIdx.x;
	int row = blockIdx.y * blockDim.y + threadIdx.y;

	//check if the indices are out of bound
	if (col >= numCols || row >= numRows)
	{
		return;
	}
	int index = row * numCols + col;
	uchar4 pixel;
	pixel.x = redChannel[index];
	pixel.y = greenChannel[index];
	pixel.z = blueChannel[index];
	pixel.w = 255;
	outputImageRGBA[index] = pixel;
}

int main()
{
	uchar4 *h_rgbaImage, *d_rgbaImage = NULL;
	unsigned char *h_red, *h_green, *h_blue, *d_red, *d_green, *d_blue = NULL;
	unsigned char *db_red, *db_green, *db_blue = NULL;

	// Read Image
	Mat image;
	image = imread("IMG.jpg");
	if (image.empty()) {
		cerr << "Couldn't open file: " << endl;
		exit(1);
	}
	int numRows = image.rows;
	int numCols = image.cols;
	int numPixels = numCols * numRows;

	Mat imageRGBA;
	cvtColor(image, imageRGBA, COLOR_BGR2RGBA);
	//
	h_rgbaImage = (uchar4 *)imageRGBA.data;
	Mat temp;
	temp.create(image.rows, image.cols, CV_8UC1);
	h_red = (unsigned char *)temp.data;
	h_green = (unsigned char *)temp.data;
	h_blue = (unsigned char *)temp.data;
	// Allocate memory
	cudaMalloc((void**)&d_rgbaImage, sizeof(uchar4) * numPixels);
	cudaMalloc((void**)&d_red, sizeof(unsigned char)*numPixels);
	cudaMalloc((void**)&d_green, sizeof(unsigned char)*numPixels);
	cudaMalloc((void**)&d_blue, sizeof(unsigned char)*numPixels);

	cudaMemcpy(d_rgbaImage, h_rgbaImage, sizeof(uchar4)*numPixels, cudaMemcpyHostToDevice);

	//Calling the Kernel - 

	const dim3 blockSize(32, 16, 1);
	const dim3 gridSize(1 + (numCols / blockSize.x), 1 + (numRows / blockSize.y), 1);

	separateChannels << < gridSize, blockSize >> > (d_rgbaImage, numRows, numCols, d_red, d_green, d_blue);

	float kernel[9] = { float(1) / 16, float(2) / 16, float(1) / 16, float(2) / 16, float(4) / 16, float(2) / 16, float(1) / 16, float(2) / 16, float(1) / 16 };
	

	cudaMalloc((void**)&db_red, sizeof(unsigned char)*numPixels);
	cudaMalloc((void**)&db_green, sizeof(unsigned char)*numPixels);
	cudaMalloc((void**)&db_blue, sizeof(unsigned char)*numPixels);

	float *d_kernel;
	cudaMalloc((void**)&d_kernel, sizeof(float) * 9);
	cudaMemcpy(d_kernel, kernel, sizeof(float) * 9, cudaMemcpyHostToDevice);
	for (int i = 0; i < 9; ++i)
	{
		cout << kernel[i] << '\n';
	}

	gaussian_blur <<< gridSize, blockSize >>> (d_red, db_red, numRows, numCols, d_kernel, 3);
	gaussian_blur <<< gridSize, blockSize >>> (d_green, db_green, numRows, numCols, d_kernel, 3);
	gaussian_blur <<< gridSize, blockSize >>> (d_blue, db_blue, numRows, numCols, d_kernel, 3);
	
	uchar4 *h_outputImage = NULL;
	uchar4 *d_outputImage = NULL;
	Mat temp2;
	cvtColor(temp, temp2, COLOR_BGR2RGBA);
	h_outputImage = (uchar4 *)temp2.data;

	cudaMalloc((void**)&d_outputImage, sizeof(uchar4) * numPixels);

	combineChannels << <gridSize, blockSize >> > (d_outputImage, numRows, numCols, db_red, db_green, db_blue);

	cudaMemcpy(h_outputImage, d_outputImage, sizeof(uchar4)*numPixels, cudaMemcpyDeviceToHost);

	Mat output;
	output = Mat(numRows, numCols, CV_8UC4, (void*)h_outputImage);
	
	Mat imageOutputBGR;
	cvtColor(output, imageOutputBGR, COLOR_RGBA2BGR);
	imwrite("result.jpg", imageOutputBGR);
	
}
