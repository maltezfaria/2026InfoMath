## JIT compilation in Julia
function mean(x)
    acc = 0.0
    for v in x
        acc += v
    end
    return acc / length(x)
end

## First call: includes compilation time
x = rand(10000)
@time mean(x)

## Second call: already compiled, much faster
@time mean(x)

## If the type changes, it will be compiled again
x = rand(ComplexF64, 1000000)
@time mean(x)

## But of course only the first time for each type
@time mean(x)

methods(mean)
