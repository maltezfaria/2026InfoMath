## Multiple dispatch in Julia

# Define a generic function
function greet(x)
    return println("Fallback version")
end

greet(0.1)

# Specialize on String argument
function greet(name::String)
    return println("Hello, $(name)!")
end

greet("Tom")

# Add a method for vector of srings
function greet(names::Vector{String})
    for name in names
        greet(name)
    end
    return
end

greet(["Alice", "Bob", "Charlie"])

# How is this any different from operator overloading?

function dynamic_dispatch()
    msg = rand() < 0.5 ? "Aline" : ["Alice", "Bob"]
    return greet(msg)
end

# Dispatch on all argument types automatically

abstract type Animal end
struct Dog <: Animal end
struct Cat <: Animal end

interact(a::Dog, b::Dog) = "dog play with dog"
interact(a::Dog, b::Cat) = "dog chase cat"
interact(a::Cat, b::Dog) = "cat run away from dog"
interact(a::Cat, b::Cat) = "cat ignore cat"

animals = [Dog(), Cat(), Dog()]
for a in animals, b in animals
    println(interact(a, b))
end

methods(interact)
