# WASM with Julia

- This notebook provides the reader with a demo that uses a Julia package called WebAssembly.jl to generate a .wasm file and call it locally.
- We'll assume you've installed Julia

# Quick start

- Install LiveServer.jl via 


```console
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.5.3 (2020-11-09)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Pkg; Pkg.add("LiveServer")
```

- Run web server

```console
$ julia -q # You can omit logo with -q option.
julia> using LiveServer

julia> serve()
✓ LiveServer listening on http://localhost:8000/ ...
  (use CTRL+C to shut down)


```

- Finally open your web browser e.g. Google Chrome and access to `localhost:8000`.

# Generate your own `.wasm` by yourself.

## Install Packages

- Install WebAssembly.jl (master branch required) and IRTools.jl


```julia
$ julia
julia> ENV["PYTHON"]=Sys.which("python3")
julia> using Pkg
julia> pkg"add WebAssembly#master"
julia> Pkg.add(["IRTools", "PyCall"])
```

- Note that we've installed PyCall.jl for convenience to run wasm file locally.

## Install wasmer

To run wasm file locally, install [wasmer](https://github.com/wasmerio/python-ext-wasm) from PyPI in advance via 


```console
$ pip3 install wasmer
```

## Install jupyter/jupytext

```console
$ pip3 install jupyter jupytext
$ julia
julia> ENV["JUPYTER"]=Sys.which("jupyter")
julia> using Pkg
julia> Pkg.add("IJulia")
julia> using IJulia
julia> installkernel("Julia")
```

## run `webassembly.jl`

```console
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.5.3 (2020-11-09)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> include("webassembly.jl")
(module
 (type $0 (func (param f64) (result f64)))
 (export "twice" (func $0))
 (func $0 (; 0 ;) (type $0) (param $0 f64) (result f64)
  (f64.add
   (local.get $0)
   (local.get $0)
  )
 )
)

6.0

julia> exit()
```

- You'll see a file named `twice.wasm` at your current working directory.