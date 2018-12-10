#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_functions.h>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>


using namespace cv;
using namespace std;
__global__ void rgba_to_greyscale(const uchar4* const rgbaImage,
	unsigned char* greyImage,
	int numRows, int numCols)
{
	int col = blockIdx.x * blockDim.x + threadIdx.x;
	int row = blockIdx.y * blockDim.y + threadIdx.y;

	__syncthreads();
	if (col >= numCols || row >= numRows) {
		return;
	}

	int offset = row * numCols + col;

	uchar4 rgba_pixel = rgbaImage[offset];
	float greyness = .299f * rgba_pixel.x + .587f * rgba_pixel.y +
		.114f * rgba_pixel.z;
	greyImage[offset] = static_cast<unsigned char>(greyness);
}

int main()
{
	Mat imageRGBA;
	Mat imageGrey;
	uchar4        *h_rgbaImage;
	uchar4 *d_rgbaImage = NULL;
	unsigned char *h_greyImage;
	unsigned char *d_greyImage = NULL;
	///////////////////////////////////
	Mat image;
	image = cv::imread("IMG.jpg");
	if (image.empty()) {
		cerr << "Couldn't open file: " << endl;
		exit(1);
	}
	imshow("input", image);
	waitKey(0);
	destroyAllWindows();
	///////////////////////////////////
	int numRows = image.rows;
	int numCols = image.cols;
	///////////////////////////////////////
	cvtColor(image, imageRGBA, COLOR_BGR2RGBA);

	//Allocate Memory for output
	imageGrey.create(image.rows, image.cols, CV_8UC1);

	//h_rgbaImage = (uchar4 *)imageRGBA.ptr<unsigned char>(0);
	//h_greyImage = imageGrey.ptr<unsigned char>(0);
	h_rgbaImage = (uchar4 *)imageRGBA.data;
	h_greyImage = (unsigned char *)imageGrey.data;

	const size_t numPixels = numRows * numCols;

	//Allocate memory on the device for both input and output

	cudaMalloc((void**)&d_rgbaImage, sizeof(uchar4) * numPixels);
	cudaMalloc((void**)&d_greyImage, sizeof(unsigned char) * numPixels);
	cudaMemset((void *)d_greyImage, 0, numPixels * sizeof(unsigned char));
	//Copy input array to the GPU

	cudaMemcpy(d_rgbaImage, h_rgbaImage, sizeof(uchar4)*numPixels, cudaMemcpyHostToDevice);

	//Calling the Kernel - 

	const dim3 blockSize(32, 16, 1);
	const dim3 gridSize(1 + (numCols / blockSize.x), 1 + (numRows / blockSize.y), 1);

	rgba_to_greyscale <<<gridSize, blockSize >>> (d_rgbaImage, d_greyImage, numRows, numCols);

	//Copy Output array to Host

	cudaMemcpy(h_greyImage, d_greyImage, sizeof(unsigned char) * numPixels, cudaMemcpyDeviceToHost);

	//Check Output
	Mat output;
	output = Mat(numRows, numCols, CV_8UC1, (void*)h_greyImage);
	imwrite("result.jpg", output);
	
}

