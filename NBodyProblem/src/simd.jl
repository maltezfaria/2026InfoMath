"""
    _simd_width()

Returns the SIMD width (in bits) used for vectorized computations.
"""
function _simd_width()
    return 128 # NEON on ARM is 128 bits
end

"""
    set_simd_width(w)

Set the SIMD width (in bits) for vectorized computations. This will trigger recompilation of
functions that depend on the SIMD width.
"""
function set_simd_width(w)
    return @eval (_simd_width() = $w)
end

"""
    get_simd_width()

Returns the current SIMD width (in bits) used for vectorized computations.
"""
function get_simd_width()
    return _simd_width()
end

"""
    simd_lanes(T::Type)

Returns the number of SIMD lanes available for type `T`.
"""
function simd_lanes(T::Type)
    return _simd_width() ÷ (8 * sizeof(T))
end

"""
    _compute_forces_manual_simd!(a::Matrix{T}, x::Matrix{T}, m::Vector{T}, G)

Like `_compute_forces!`, but uses SIMD vectorization for improved performance. This function
assumes that `N` is divisible by the SIMD width.
"""
@fastmath @inline function _compute_forces_manual_simd!(a::Matrix{T}, x::Matrix{T}, m::Vector{T}, G) where {T}
    N = length(m)
    VLen = simd_lanes(T)
    V = Vec{VLen, T}
    @assert N % VLen == 0 "N must be divisible by $VLen"

    # Column views for cleaner indexing
    xs, ys, zs = @view(x[:, 1]), @view(x[:, 2]), @view(x[:, 3])
    axs, ays, azs = @view(a[:, 1]), @view(a[:, 2]), @view(a[:, 3])

    # Vectorize over targets (outer loop)
    @threads for i in 1:VLen:N
        # Load VLen target positions at once
        xi = vload(V, xs, i)
        yi = vload(V, ys, i)
        zi = vload(V, zs, i)

        ax, ay, az = zero(V), zero(V), zero(V)

        # Loop over all sources
        for j in 1:N
            xj, yj, zj, mj = xs[j], ys[j], zs[j], m[j]

            rx = xi - xj
            ry = yi - yj
            rz = zi - zj

            d2 = rx * rx + ry * ry + rz * rz
            d = sqrt(d2)

            # Mask out i == j (where d2 == 0)
            mask = d2 != zero(V)
            c = vifelse(mask, G * mj / (d2 * d), zero(V))

            ax -= c * rx
            ay -= c * ry
            az -= c * rz
        end

        # Store results directly - no horizontal sum needed
        vstore(ax, axs, i)
        vstore(ay, ays, i)
        vstore(az, azs, i)
    end
    return a
end
