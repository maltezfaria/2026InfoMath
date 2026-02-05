function compute_forces!(
        ax::Vector{Float64}, ay::Vector{Float64}, az::Vector{Float64},
        x::Vector{Float64}, y::Vector{Float64}, z::Vector{Float64},
        m::Vector{Float64}, G::Float64 = 1.0
    )
    # TODO: Implement the N-body force computation
end

# Test case: 4 particles at corners of a unit square
x4 = [0.0, 1.0, 0.0, 1.0]
y4 = [0.0, 0.0, 1.0, 1.0]
z4 = [0.0, 0.0, 0.0, 0.0]
m4 = [1.0, 1.0, 1.0, 1.0]
ax4, ay4, az4 = zeros(4), zeros(4), zeros(4)

compute_forces!(ax4, ay4, az4, x4, y4, z4, m4)
checksum = sum(sqrt(ax4[i]^2 + ay4[i]^2 + az4[i]^2) for i in 1:4)
println("Checksum: $checksum")

# Benchmark
N = 10_000
x = rand(N)
y = rand(N)
z = rand(N)
m = ones(N)
ax, ay, az = zeros(N), zeros(N), zeros(N)

compute_forces!(ax, ay, az, x, y, z, m)  # warmup
t = @elapsed compute_forces!(ax, ay, az, x, y, z, m)
println("Time: $(round(t, digits = 4)) s")

# Checksum to prevent compiler from optimizing away the computation
bench_checksum = sum(ax) + sum(ay) + sum(az)
println("Bench checksum: $bench_checksum")
