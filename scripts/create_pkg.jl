using Pkg
# get current script directory
dir = @__DIR__
# move to parent directory and generate package
cd(dir * "/..")
if isdir("NBodyProblem")
    @info "Package InfoMathDemo already exists. Skipping generation."
else
    Pkg.generate("NBodyProblem")
end
