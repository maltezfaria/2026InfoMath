module NBodyProblem

using Base.Threads
using LoopVectorization
using SIMD

include("gravitational_system.jl")
include("simd.jl")

export
    GravitationalSystem,
    compute_forces!

end # module NBodyProblem
