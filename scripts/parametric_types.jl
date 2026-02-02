## Parametric types in Julia

# many built-in types are parametric
x = Vector{Int64}(undef, 10)
y = Vector{String}(undef, 10)
A = Matrix{ComplexF64}(undef, 3, 3)

# user-defined parametric types are very useful!
struct Point{N, T}
    coords::NTuple{N, T}
end

pt2d = Point((0.1, 0.2))
pt3d = Point((0.1, 0.2, 0.3))

function Base.:+(p1::Point{N, T}, p2::Point{N, T}) where {N, T}
    coords = ntuple(i -> p1.coords[i] + p2.coords[i], N)
    return Point{N, T}(coords)
end

function Base.rand(::Type{Point{N, T}}) where {N, T}
    coords = ntuple(i -> rand(T), N)
    return Point{N, T}(coords)
end

Base.rand(::Type{Point{N, T}}, n::Int) where {N, T} = [rand(Point{N, T}) for _ in 1:n]

n = 10000
sum(rand(Point{4, Float32}, n))
