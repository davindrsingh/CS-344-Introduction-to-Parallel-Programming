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
Exclusive Scan give scatter addresses.

**Histograms**
Calculating CDF -> Use Exclusive Scan
Use atomicAdd(&(d_bins[myBin]), 1) for atomic increment. Thus only one thread at a time will be able to read,update,write at a location and other threads will be waiting to access that location.
Throught put gets dependent on atomic operation. Increase number of bins to get better throughput.
![alt text](/src/hist.PNG)
Use Reduce to add these local histograms.

**Sort and Reduce By Key**
Can be used to make histogram.


# Optimizing GPU Programs
Goal - solve problem faster
       solve bigger problems
       solve more problems

Principles efficient GPU program - 
1. Decrease time spent on memory operations.
2. Coalesce global memory accesses.
3. Avoid thread divergence. (different threads reach at milestone at different time)(we used barriers for this)

Levels of Optimization
1. Algorithms
2. Basic principles
3. Architecture Specific
4. mu-optimization at instruction level

Pick Algorithms which are fundamentally parallel.
mergesort (nlogn) - much better choice
insertion sort (n^2)
heapsort (nlogn) - update shared variable (hard to parallelize)

APOD 
![alt text](/src/apod.PNG)
Analyze - Profile whole application 
Parallelize - Pick an approach (libraries, directives)
              Pick an algorithm (fundamentally parallel)
Optimize - Profile-drive optimaztion
Deploy - make it real

**Weak Scaling** - Run a larger problem or more
**Strong Scaling** - Run a problem faster

# Parallel Computing Patterns

Some Problems - 
1. Dense N-Body
There are N bodies. Each body exerts a force on each other oject.
  All-Pairs N-Body - Calculate force between each pair of bodies and add them together.
  N^2 Complexity.

2. SmPv (Sparse Matrix Vector Multiplication)
Sparse Matrices are represented as Compressed Sparse Row.
Three Vectors represent entire matrix
Value Vector - Consiste of values
Column Vector - Column of those values
Row Vector - Rows of those values
![alt text](/src/smpv.PNG)

**SORT**
Odd-Even Sort (Brick Sort)
![alt text](/src/odd.PNG)

Merge Sort
Parallel Merge - 
![alt text](/src/merge.PNG)
One big merge - Lots of SMS remain idle.
Take one big problem and divide into smaller problems.

Radix Sort
(Most Efficient Parallel Sorting Algorithm)



What is Compact?
We want the output of a compact operation to be dense.
is Diamonds - 
If solution - 52 Threads onlye 13 active
Compact - select 13 diamonds and then apply cc - only 13 threads.
When to use compact - 
Is useful when we need to compact away (delete) large number of elements and computation on each surviving element is very expensive.

Try to convert communication between threads to communication within a thread.
Core Algorithm - 
Set of predicates - 
scatter addrases
