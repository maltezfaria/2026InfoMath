using NBodyProblem
using Test
using Printf
using LinearAlgebra
using BenchmarkTools

function bench(npts, T = Float64)
    # Now benchmark on larger system
    pos = 100 * rand(T, npts, 3)
    acc = zero(pos)
    m = ones(T, npts)
    sys = GravitationalSystem(pos, acc, m, one(T))
    compute_forces!(sys)  # warmup
    eq_err = sum(sys.acceleration) / norm(sys.acceleration)
    t = @elapsed compute_forces!(sys)
    # t = @belapsed compute_forces!($sys) # BenchmarkTools version
    gpairs = npts^2 / t / 1.0e9
    @printf "N = %d, Time = %.4f s, Checksum = %.4e, GPairs/s = %.2f\n" npts t eq_err gpairs
    return eq_err, gpairs
end

bench(10_000)
# bench(10_000, Float32)
# bench(10_000, Float16)
