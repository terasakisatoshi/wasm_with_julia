# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.6.0
#   kernelspec:
#     display_name: Julia 1.5.3
#     language: julia
#     name: julia-1.5
# ---

# # WASM with Julia
#
# - This notebook provides the reader with a demo that uses a Julia package called WebAssembly.jl to generate a .wasm file and call it locally.
#

# ## Install Packages
#
# - Install WebAssembly.jl (master branch required) and IRTools.jl
#
#
# ```julia
# julia> ENV["PYTHON"]=Sys.which("python3")
# julia> using Pkg
# julia> pkg"add WebAssembly#master"
# julia> Pkg.add(["IRTools", "PyCall"])
# ```
#
# - Note that we've installed PyCall.jl for convenience to run wasm file locally.
#
# ## Install wasmer
#
# To run wasm file locally, install [wasmer](https://github.com/wasmerio/python-ext-wasm) from PyPI in advance via 
#
#
#
# ```console
# $ pip3 install wasmer
# ```

# ## Import Packages
#
# OK let's get started

using WebAssembly
using WebAssembly: f64, irfunc # i32 and so on
using IRTools.All
using PyCall

# ## generate `.wasm` for f(x) = x + x
#
# - In this notebook, we would like to implement simple function that takes one argument and return double value of the argument.

f(x) = x + x # define function
@code_ir f(3.) # check IR

# ## Construct IR for WASM
#
# - Let's generate an IR(intermediate representation) similar to the above form.

twice = let 
    ir = IR()
    x = argument!(ir, f64)
    r = push!(ir, stmt(xcall(f64.add, x, x), type=f64))
    return!(ir, r)
end

# ## Generate `.wasm` file
#
# - Here we create the wasm file so that we can call the function named `twice`.
#

# +
funcname = :twice
func = irfunc(funcname, twice)

mod = WebAssembly.Module(
    funcs=[func],
    exports=[WebAssembly.Export(funcname, funcname, :func)]
)
WebAssembly.binary(mod, "$(funcname).wasm")
# -

# # Disassemble wasm

run(`$(WebAssembly.Binaryen.wasm_dis) $(funcname).wasm`);

# # Call wasm file from Python
#
# - Let's call the program stored in the wasm file. We'll use Python as a lamp for Aladdin.

# +
pycode = """
from wasmer import Instance

def run_wasm(*args):
    wasm_bytes = open("$(funcname).wasm", 'rb').read()
    instance = Instance(wasm_bytes)
    res = instance.exports.$(funcname)(*args)
    return res
"""

pyfile = string(funcname) * ".py"
open(pyfile,"w") do f
    print(f, pycode)
end
# -

pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
pymodule = pyimport(funcname)
pymodule.run_wasm(3.) # 3. + 3. should be 6.0

# # References
#
# - [MikeInnes/WebAssembly.jl](https://github.com/MikeInnes/WebAssembly.jl)
# - [FluxML/IRTools.jl](https://github.com/FluxML/IRTools.jl)
# - [wasmerio/python-ext-wasm](https://github.com/wasmerio/python-ext-wasm)
