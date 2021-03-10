### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 72f2dc98-7923-11eb-3bf1-8d83a92ec5dc
begin
	using Markdown
	using InteractiveUtils
end

# ╔═╡ 443591a0-7925-11eb-198a-7557d7efb6b8
using Images

# ╔═╡ 75c648f4-7925-11eb-26fe-35998b00111f
using JImages

# ╔═╡ 839e25e4-7925-11eb-011c-09c7d65161de
md"reading Lena"

# ╔═╡ 92f5c24c-7925-11eb-1308-591e390d97ae
begin
	path = string(JImages.datadir, "/", "lena.h5")
	println("path to Lena is $path")
	lena = JImages.load_h5(path, "lena")
	Gray.(lena)
end

# ╔═╡ d46760b4-7925-11eb-21e4-db7c070b7c4c


# ╔═╡ b440870c-7925-11eb-3cb2-035863e491e2


# ╔═╡ Cell order:
# ╠═72f2dc98-7923-11eb-3bf1-8d83a92ec5dc
# ╠═443591a0-7925-11eb-198a-7557d7efb6b8
# ╠═75c648f4-7925-11eb-26fe-35998b00111f
# ╠═839e25e4-7925-11eb-011c-09c7d65161de
# ╠═92f5c24c-7925-11eb-1308-591e390d97ae
# ╠═d46760b4-7925-11eb-21e4-db7c070b7c4c
# ╠═b440870c-7925-11eb-3cb2-035863e491e2
