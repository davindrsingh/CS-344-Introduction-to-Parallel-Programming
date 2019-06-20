# Reduce - 
Compute a sum of large number of integers.
Have dependencies between operators.
Inputs - set of elements, reduction operator (binary, associative)

# Scan - running sum of numbers/suffix sum
Inputs - Input Array, Binary operator(associative), Identity element
Why scan is useful - we might want to generate a list of outputs given a list of inputs. Each ouput instance depends on current input and previous output and so on.
Recursively - O[i] = I[i] + O[i-1]  (O-output/I-input)

# Inclusive Vs Exclusive Scan - 
**Inclusive** - All Elements before and current element
**Exclusive** - All elements before not current element

Hillis and Steele - More Step -efficient
Blelloch - More work efficient

**Hillis Steele Scan (Inclusive)**
Starting with step i, add yourself to your 2^i left neighbor. And if neighbour is not present just copy yourself.
![alt text](/src/HSscan.PNG)
work/time - nlogn
steps - log(n)

**Blelloch Scan - Reduce/Downsweep (Exclusive)**
![alt text](/src/Bscan.PNG)
work/time - n
steps - 2log(n)

**Histograms**
Calculating CDF -> Use Exclusive Scan
Use atomicAdd(&(d_bins[myBin]), 1) for atomic increment. Thus only one thread at a time will be able to read,update,write at a location and other threads will be waiting to access that location.
Throught put gets dependent on atomic operation. Increase number of bins to get better throughput.
![alt text](/src/hist.PNG)
Use Reduce to add these local histograms.

**Sort and Reduce By Key**
Can be used to make histogram.


What is Compact?
We want the output of a compact operation to be dense.
is Diamonds - 
If solution - 52 Threads onlye 13 active
Compact - select 13 diamonds and then apply cc - only 13 threads.
When to use compact - 
Is useful when we need to compact away (delete) large number of elements and computation on each surviving element is very expensive.

Core Algorithm - 
Set of predicates - 
scatter addrases
