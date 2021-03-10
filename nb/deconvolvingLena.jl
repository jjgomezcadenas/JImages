### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 5ca81b3a-7926-11eb-38e4-37053a873b78
begin
	using Markdown
	using InteractiveUtils
	using Images
	using Plots
	using PlutoUI
end

# ╔═╡ 8d041392-7926-11eb-308b-55a47a287cea
using JImages

# ╔═╡ f590466a-7926-11eb-18d7-3109f09d4f85


# ╔═╡ cab9623c-7926-11eb-024e-0fe16e3170d6
begin
	path = string(datadir, "/", "lena.h5")
	println("path to Lena is $path")
	lena = load_h5(path, "lena")
end

# ╔═╡ 02f670b8-7927-11eb-3d2e-8bb684cc0747
kg1 = Kernel.gaussian(1)

# ╔═╡ 6ae9cd0a-7927-11eb-256d-adfecbd5f27e
@time lena_g1 = imfilter(lena, reflect(centered(kg1)), Fill(0))

# ╔═╡ 85b1ec0a-7927-11eb-0d1e-8f132863920d
Gray.(lena)

# ╔═╡ aea0934e-7927-11eb-1025-ef5ebadbfb4a
iter = 100

# ╔═╡ b27aed28-7927-11eb-3e8a-17e5edee2584
md" Running RL with $iter iterations"

# ╔═╡ 7da73da2-7928-11eb-08cd-39c737d26622
@time lena_d, DFR = richardson_lucy(lena_g1, kg1,
                                    iterations=iter,
                                    view_window =1,
                                    fom_window=64,
                                    debug_level=quiet)


# ╔═╡ b2a9fe70-7928-11eb-1e88-d9749038d9ab
DFR

# ╔═╡ 3808c506-7933-11eb-3b76-1bcc9c18b823
plot(DFR[3:end])

# ╔═╡ a11f9b24-7928-11eb-0259-53dc3facfaae
md"DFR shows the variation of the relative difference. About 50 iterations are enough"

# ╔═╡ c23a1db0-7933-11eb-19bb-e7670600f387
Gray.(lena_d)

# ╔═╡ ccc3275e-7933-11eb-3b6d-8f88a26c5390
md"Running the fast version"

# ╔═╡ fef6fd5c-7933-11eb-2c9c-977ec2ea4a55
@time lena_d2 = frichardson_lucy(lena_g1, kg1, iterations=iter)

# ╔═╡ 962d09b2-7933-11eb-0cc0-f7f5cdf38116
md"## An alternative deconvolution"

# ╔═╡ a58bf18e-7d0c-11eb-2b5b-f52987f7c47a
md"### Gaussian kernel"

# ╔═╡ f60fab46-7d0c-11eb-1fc3-05956cd1a30b
function pprint(x)
	with_terminal() do
    	println(x)
	end
end

# ╔═╡ b7b4b8d0-7d0c-11eb-257e-8d2f1c78c9bd
begin
	G(x,y, σ=0.5) = 1 / sqrt(2πσ^2) * e^(-(x^2 + y^2) / (2σ^2) )
	G(I::CartesianIndex{2}, σ=0.5) = 1 / sqrt(2πσ^2) * e^(-(x^2 + y^2) / (2σ^2) )
end

# ╔═╡ 8c12e61c-7d0d-11eb-0955-f35ae7f18e89
zz = [[10., 30.] [20.,40.] ]

# ╔═╡ 12906938-7d1a-11eb-1560-9bb1872423e5
begin
	t(x,y) = x + y  
	TT(I::CartesianIndex{2}) = t(I.I...)
end

# ╔═╡ 55d11c48-7d0f-11eb-22a3-d129c2a7e5e1
begin
	for i in CartesianIndices(zz)
          println(" cartesian index i = ", i ," value = ", zz[i])
		  println(" i.I = ", i.I... ," value = ", zz[i])
			println(" i.I = ", i.I... ," t(i.I...) = ", t(i.I...))
	end
end

# ╔═╡ 23619db8-7d1a-11eb-2144-c9766bda5ae5
begin
	for i in CartesianIndices(zz)
          println(" cartesian index i = ", i ," value = ", zz[i])
			println(" TT($i) = ", TT(i))
	end
end

# ╔═╡ cff0e784-7d27-11eb-1c8a-c73c55c769cd
l = 4 * ceil(Int, 0.5) + 1

# ╔═╡ 02791abe-7d28-11eb-00f0-a90f55eee923
w = 5÷2

# ╔═╡ 1bb6d316-7d28-11eb-18e7-fb4a5fcc031e
CartesianIndices((-w:w, -w:w))

# ╔═╡ 30c12eb4-7d28-11eb-35e0-83ae2b97ea51
bar(a,x...) = (a,b,x)

# ╔═╡ d5ba26e4-7d27-11eb-2b71-81b1385785b3


# ╔═╡ Cell order:
# ╠═5ca81b3a-7926-11eb-38e4-37053a873b78
# ╠═8d041392-7926-11eb-308b-55a47a287cea
# ╠═f590466a-7926-11eb-18d7-3109f09d4f85
# ╠═cab9623c-7926-11eb-024e-0fe16e3170d6
# ╠═02f670b8-7927-11eb-3d2e-8bb684cc0747
# ╠═6ae9cd0a-7927-11eb-256d-adfecbd5f27e
# ╠═85b1ec0a-7927-11eb-0d1e-8f132863920d
# ╠═aea0934e-7927-11eb-1025-ef5ebadbfb4a
# ╠═b27aed28-7927-11eb-3e8a-17e5edee2584
# ╠═7da73da2-7928-11eb-08cd-39c737d26622
# ╠═b2a9fe70-7928-11eb-1e88-d9749038d9ab
# ╠═3808c506-7933-11eb-3b76-1bcc9c18b823
# ╠═a11f9b24-7928-11eb-0259-53dc3facfaae
# ╠═c23a1db0-7933-11eb-19bb-e7670600f387
# ╠═ccc3275e-7933-11eb-3b6d-8f88a26c5390
# ╠═fef6fd5c-7933-11eb-2c9c-977ec2ea4a55
# ╠═962d09b2-7933-11eb-0cc0-f7f5cdf38116
# ╠═a58bf18e-7d0c-11eb-2b5b-f52987f7c47a
# ╠═f60fab46-7d0c-11eb-1fc3-05956cd1a30b
# ╠═b7b4b8d0-7d0c-11eb-257e-8d2f1c78c9bd
# ╠═8c12e61c-7d0d-11eb-0955-f35ae7f18e89
# ╠═12906938-7d1a-11eb-1560-9bb1872423e5
# ╠═55d11c48-7d0f-11eb-22a3-d129c2a7e5e1
# ╠═23619db8-7d1a-11eb-2144-c9766bda5ae5
# ╠═cff0e784-7d27-11eb-1c8a-c73c55c769cd
# ╠═02791abe-7d28-11eb-00f0-a90f55eee923
# ╠═1bb6d316-7d28-11eb-18e7-fb4a5fcc031e
# ╠═30c12eb4-7d28-11eb-35e0-83ae2b97ea51
# ╠═d5ba26e4-7d27-11eb-2b71-81b1385785b3
