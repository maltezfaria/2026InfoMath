## Basic arithmetic
x = 1 + 1
y = 2 * 3
z = x^2 + y

## Built-in mathematical functions
a = sin(pi / 4)
c = log(10)
d = exp(1.0)
d = evalpoly(0.1, [1, 0, -3, 4]) # Horner's method

## Native multidimensional arrays
A = [1 2 3; 4 5 6; 7 8 9]  # 3x3 matrix
b = [1, 2, 3]              # 3-element column vector
v = A * b                  # Matrix-vector multiplication

## Rich set of standard libraries
using LinearAlgebra
eigenvalues = eigvals(A)

using Statistics
mean_b = mean(b)
std_b = std(b)

## And a very good package ecosystem for scientific computing
using Pkg
Pkg.activate(; temp = true)
Pkg.add("QuadGK") # registered package from General Registry
using QuadGK
I, E = quadgk(x -> exp(-x^2), 0, Inf) # numerical integration

## Getting help!
# In REPL, type ? to enter help mode

## Nice bonus: often it is Julia all the way down!
@edit quadgk(x -> exp(-x^2), 0, Inf)
@edit cos(0.1)
