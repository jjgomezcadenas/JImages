
function printd(msg::String, level::PrintL, debug_level::PrintL)
    if level <= debug_level && debug_level > mute
        println(msg)
    end
end

dxy(x,y) = abs(x-y)

"""
image_fom (imge figure of merit) computes the sum of the
differences between the pixels of two images, defined as 2-d Float64 arrays
providing a (naive) metric of the difference between both.
"""
function image_fom(img1::Array{Float64,2}, img2::Array{Float64,2})
    dff = sum(broadcast(dxy, img1, img2))
    return dff /sum(img1)
end

"""
Find the (i,j) indexes defining the center of an array
"""
function array_center_indexes(a::AbstractArray)
    is = size(a)./2     # index center
    ic = map(ceil, is)  # take the ceiling
    return map(x -> convert(Int, x), ic) # and cast to Int
end

"""
Return a view of img. The view is taken from the center
with a width hw
"""
function center_view(img::Array{Float64,2}, hw::Int)
    imc = array_center_indexes(img)
    il  = imc[1] - hw
    ir  = imc[2] + hw
    return view(img, il:ir, il:ir)
end

"""
Flips an array: Equivalent to numpy.flip
"""
function flip2d(x::AbstractArray)
    y = copy(x)
    for d in 1:2
        y = reverse(y, dims=d)
    end
    return y
end

"""
In order to avoid zero divsion, replace any element smaller than eps()
---a function that gives the small number accesible for the type with
the value of eps(). Also, one may want to clip the image (between 0 and 1)
Both tasks can be performed with the function below
"""
function limit_boundaries(a::AbstractArray, xmin::Float64 = eps(), xmax::Float64 = 1e+9)
    map!(x -> x>xmin ? x : xmin, a, a)
    map!(x -> x < xmax ? x : xmax, a, a)
end


"""
A simple 1d gaussian kernel
(yields the same result than the image package kernel)
"""
gxy((x,y)) = exp(-(x^2/2 + y^2/2))
function gaussianxy(x)
    g = gxy.(x)
    s = sum(g)
    g/s
end
