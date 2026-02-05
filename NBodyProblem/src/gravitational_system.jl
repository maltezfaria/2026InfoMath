"""
    GravitationalSystem{T <: Real}

A structure representing a gravitational N-body system.
"""
struct GravitationalSystem{T <: Real}
    positions::Matrix{T}    # N x 3 matrix of particle positions
    acceleration::Matrix{T} # N x 3 matrix of particle accelerations
    masses::Vector{T}
    G::T
end

"""
    compute_forces!(system::GravitationalSystem)

Compute the gravitational forces (accelerations) for each particle in the system. The
results are stored in the `acceleration` field of the system.
"""
function compute_forces!(system::GravitationalSystem)
    X, m, G = system.positions, system.masses, system.G
    # _compute_forces!(system.acceleration, X, m, G)
    _compute_forces_manual_simd!(system.acceleration, X, m, G)
    return system
end

function _compute_forces!(a::Matrix{T}, x::Matrix{T}, m::Vector{T}, G) where {T}
    N = length(m)
    @tturbo for i in 1:N
        ax, ay, az = zero(T), zero(T), zero(T)
        for j in 1:N
            rx = x[i, 1] - x[j, 1]
            ry = x[i, 2] - x[j, 2]
            rz = x[i, 3] - x[j, 3]
            d = sqrt(rx^2 + ry^2 + rz^2)
            c = ifelse(i == j, zero(T), (G * m[j] / d^3))
            ax -= c * rx
            ay -= c * ry
            az -= c * rz
        end
        a[i, 1] = ax
        a[i, 2] = ay
        a[i, 3] = az
    end
    return a
end
