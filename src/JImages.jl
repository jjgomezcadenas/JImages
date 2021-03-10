module JImages

using Dates
using Images
using ImageFiltering

macro exported_enum(name, args...)
    esc(quote
        @enum($name, $(args...))
        export $name
        $([:(export $arg) for arg in args]...)
        end)
end

export greet
export datadir
export srcdir
export nbdir
export load_h5
export richardson_lucy
export frichardson_lucy
@exported_enum PrintL mute quiet concise verbose

include("util.jl")
include("io.jl")
include("deconvolution.jl")

wdir    = string(ENV["JDIR"],"/JImages")
srcdir  = string(wdir,"/src")
datadir = string(wdir,"/data")
nbdir   = string(wdir,"/nb")

greet() = println("what a sunny ", dayname(today()))
end
