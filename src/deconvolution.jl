include("util.jl")
using ImageFiltering

function fuck(; debug_level=verbose)
       printd("fuckyou", verbose, debug_level)
       printd("fuckyou", concise, debug_level)
       printd("fuckyou", quiet, debug_level)

end
"""
Replaces by value e (by default machine precision eps())
"""
function zero_protection(a::Array{Float64,2}, e::Float64 = eps())
	(h,w) = size(a)
    #println(" e = $e")
	for j in 1:w
		for i in 1:h
			if @inbounds a[i,j] < e
				@inbounds a[i,j] = e
			end
		end
	end
end

function richardson_lucy(image::Array{Float64,2}, psf::AbstractArray;
                         iterations::Int=10,
                         view_window::Int=1,
                         fom_window::Int=64,
                         debug_level=mute)

    # init
    image_ref  = copy(image)
    psf_mirror = flip2d(psf)
    im_deconv  = 0.5 * ones(size(image))


    printd("view of image center = $(center_view(image_ref, view_window))",
           verbose, debug_level)
    printd("view of image deconv = $(center_view(im_deconv, view_window))",
           verbose, debug_level)
    printd("view of psf center   = $(center_view(collect(psf), view_window))",
           verbose, debug_level)
    printd("view of psf* deconv  = $(center_view(collect(psf_mirror), view_window))",
           verbose, debug_level)


    dff0 = 1.
    DFR = zeros(iterations) * 1.  # Relative differences

    for i in 1:iterations
        # Using imfilter with reflect to produce a convolution (rather than a correlation),
        # psf must be centered so that final image has the same size than original image
        x = imfilter(im_deconv, reflect(centered(psf)), Fill(0) )

        printd(" iteration = $i x ($i) view = $(center_view(x, view_window)) ",
               verbose, debug_level)

        # protect against division by zero
        limit_boundaries(x, eps())

        # relative blur
        relative_blur = image ./ x

        printd(" relBlur($i) view = $(center_view(relative_blur, view_window)) ",
               verbose, debug_level)

        # deconvolution
        im_deconv = im_deconv .* imfilter(relative_blur, reflect(centered(psf_mirror)), Fill(0))

        printd("im_deconv($i) view = $(center_view(relative_blur, view_window)) ",
               verbose, debug_level)

        # Relative differences
        dff = image_fom(collect(center_view(image_ref, 64)), collect(center_view(im_deconv, 64)))
        delta = (dff0 - dff) / dff0

        printd(" iteration $i ", concise, debug_level)
        printd(" diff($i)  = $dff ", concise, debug_level)
        printd(" delta($i)  = $delta ", concise, debug_level)

        DFR[i] = delta

        dff0 = dff
        image_ref = copy(im_deconv)
    end

    # clip image ( 0 < x <= 1)
    limit_boundaries(im_deconv, 0.,1.)
    return im_deconv, DFR

end

function frichardson_lucy(image::Array{Float64,2}, psf::AbstractArray; iterations::Int=10)

    println("Running RL with $iterations iterations")
    psf_mirror = flip2d(psf)
    im_deconv  = 0.5 * ones(size(image))

    for i in 1:iterations
        # Using imfilter with reflect to produce a convolution (rather than a correlation),
        # psf must be centered so that final image has the same size than original image
        x = imfilter(im_deconv, reflect(centered(psf)), Fill(0))

        # protect against division by zero
        #zero_protection(x)

        # relative blur
        relative_blur = image ./ x

        # deconvolution
        im_deconv = im_deconv .* imfilter(relative_blur,
                                          reflect(centered(psf_mirror)), Fill(0))
    end

    # clip image ( 0 < x <= 1)
    limit_boundaries(im_deconv, 0.,1.)
    return im_deconv

end
