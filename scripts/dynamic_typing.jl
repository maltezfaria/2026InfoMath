## Types belong to values, not variables
x = 5 # x is an integer
println("x = $x, type: $(typeof(x))")

x = "hello" # x is now a string, perfectly fine
println("x = $x, type: $(typeof(x))")

## Type inference (very important!)
function add(x, y)
    z = x + y
    return z
end

@code_warntype add(2, 3)
@code_warntype add(2.0, 3.5)
@code_warntype add(2, 3.5)

## User defined types with struct (composite types)
struct Point2D
    x::Float64
    y::Float64
end
pt = Point2D(1.0, 2.0)
