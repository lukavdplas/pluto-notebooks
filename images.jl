### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 7503e8ce-fe6c-11ea-38c7-5ba0cdac030f
using Images

# ╔═╡ 912b03d8-fe6d-11ea-2c07-0bc073a622fd
md"""
# Images in Pluto

This is not an introduction to working with images in Julia, but just a quick demonstration of how to display images in Pluto.

## Images in markdown

If you have a cool image that you want to show in your notebook, you can just do so in a markdown cell. For example, here are some cute pandas:

![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Giant_Pandas_having_a_snack.jpg/1280px-Giant_Pandas_having_a_snack.jpg)

(Unfold this cell if you want to see how I did that!)

Including images in markdown is simple and fast: you don't have to use any Julia packages or write special code. It works with images from the internet as well as any local path.

However, if we want to actually *do* something with the image, we need to import it in our Julia code...

"""

# ╔═╡ 6fbaa2a2-fe6e-11ea-37c5-1f90ad3cf417
md"""

## Images in Julia

To work with images in Julia, we can use the `Images` library. Let's start by importing it. If you don't have this package install, you can do so quickly by creating a new cell and running

```
begin
	using Pkg
	Pkg.add("Images")
end
```

"""

# ╔═╡ c95c2dc4-fe6e-11ea-026d-a748745d1904
md"""
Now we can import images. For this example, we will download the pandas image and save it in the same folder as the notebook. Of course, if you want to import something from your own computer, you would skip this step. 
"""

# ╔═╡ ba6065b4-fe6c-11ea-10cb-577dbd949eb4
download("https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Giant_Pandas_having_a_snack.jpg/1280px-Giant_Pandas_having_a_snack.jpg",
	"pandas.jpg")

# ╔═╡ 28ee044e-fe6f-11ea-3bf3-77e6f9ea6712
md"""
Let's load it!
"""

# ╔═╡ be81b940-fe6c-11ea-08ae-d5ea7db499c1
pandas = load("pandas.jpg")

# ╔═╡ 341ad266-fe6f-11ea-3eec-219c12df5c39
md"""
That was pretty easy. Pluto recognises that we are loading an image, and shows us the image itself, not the underlying values.

But what kind of object is this?
"""

# ╔═╡ a83869d8-fe6f-11ea-205e-ebe77070c31c
typeof(pandas)

# ╔═╡ 830c34c2-fe70-11ea-1c1a-dd4c89c45e0f
md"""
The image is a two-dimensional array of `RGB` values. All `RGB` arrays are displayed as images in your notebook.

Like with any array, you can get a single element of `pandas` with an index. This is a single `RGB` object that tells you the colour of a single pixel. Pluto will just show the colour to you.
"""

# ╔═╡ 2461f9c8-fe6d-11ea-2928-3d6fcecffbda
pixel = pandas[1,1]

# ╔═╡ 6551f452-fe71-11ea-092f-51262b503e65
md"""
Working with images in Pluto is intuitive and visually oriented: you don't need to go through any trouble to actually see the objects that you are working with.
"""

# ╔═╡ 8c23271e-fe70-11ea-1b26-d578e891af5d
md"""
## Inspecting raw values

This is all well and good, but what if you *want* to see the raw numbers? There are a few ways to do this. The short version is that you need to convert the image to something that isn't recognised as an image anymore.

As we mentioned, an image is a two-dimensional array of `RGB` values (or some other colour type). Each `RGB` value stores three numerical values, representing the red, green and blue channels. So what do we do with this?

### Channelview

One option is to use `channelview`. This will split our two-dimensional array of `RGB` values into a three-dimensional array of numerical values. Let's try it.
"""

# ╔═╡ 0b2ed1d8-fe72-11ea-2315-3bd2c188d2a5
panda_values = channelview(pandas)

# ╔═╡ f3f9c338-fe73-11ea-0cf1-69a8cb8803a1
md"""
With these big arrays, it's not very easy to see how they work. Comparing the size of `panda_values` with `pandas` may provide more insight.
"""

# ╔═╡ 1397611c-fe74-11ea-1b77-6336887b5cad
size(pandas)

# ╔═╡ fd9abf12-fe73-11ea-0c60-81a5213d6162
size(panda_values)

# ╔═╡ 23e8c5f4-fe74-11ea-1b65-ed80262f73bb
md"""
We now have an extra dimension, which represents the colour channel. The values in `panda_values` are no longer colours, but just numerical values.

(If it's not clear to you how this operation works, don't worry! The next solution may be more to your liking!)

We can invert this operation with `colorview`.
"""

# ╔═╡ e8bce54e-fe72-11ea-32e0-ad6d0cf7dcf5
colorview(RGB, panda_values)

# ╔═╡ a1d99abc-fe74-11ea-1a58-13b6096c1aa1
md"""
### A custom function

`channelview` and `colorview` are quick, but if you're not an array wizard, they're not that intuitive. They also don't work on individual pixels.

As an alternative, here is a simple function that will convert a colour to a tuple of the underlying values.
"""

# ╔═╡ 4f5594fa-fe6d-11ea-0bbd-8546c83eaa8b
function raw_values(colour)
	return (colour.r, colour.g, colour.b)
end

# ╔═╡ 86c22f66-fe6d-11ea-2285-139c4a2dc1d9
raw_values(pixel)

# ╔═╡ 4d555cc8-fe75-11ea-26a7-a336cba310cb
md"""
We can broadcast this function onto an image. The result is still a two-dimensional array, but each element is now just a tuple of numbers.
"""

# ╔═╡ 6cbf5742-fe6d-11ea-21a4-9f0528124b35
raw_values.(pandas)

# ╔═╡ 6c4cbb5a-fe75-11ea-398d-1fdf3e60c6ac
md"""
If you want to go back to colours, here is the inverse function:
"""

# ╔═╡ 804b3c10-fe75-11ea-1b1b-9327d44145b0
function colour(raw_numbers)
	return RGB(raw_numbers...)
end

# ╔═╡ a5acf7fa-fe75-11ea-080a-7d3d09edf268
colour(raw_values(pixel))

# ╔═╡ ac9eced2-fe75-11ea-1f27-f3e3e6204b8f
colour.(raw_values.(pandas))

# ╔═╡ Cell order:
# ╟─912b03d8-fe6d-11ea-2c07-0bc073a622fd
# ╟─6fbaa2a2-fe6e-11ea-37c5-1f90ad3cf417
# ╠═7503e8ce-fe6c-11ea-38c7-5ba0cdac030f
# ╟─c95c2dc4-fe6e-11ea-026d-a748745d1904
# ╠═ba6065b4-fe6c-11ea-10cb-577dbd949eb4
# ╟─28ee044e-fe6f-11ea-3bf3-77e6f9ea6712
# ╠═be81b940-fe6c-11ea-08ae-d5ea7db499c1
# ╟─341ad266-fe6f-11ea-3eec-219c12df5c39
# ╠═a83869d8-fe6f-11ea-205e-ebe77070c31c
# ╟─830c34c2-fe70-11ea-1c1a-dd4c89c45e0f
# ╠═2461f9c8-fe6d-11ea-2928-3d6fcecffbda
# ╟─6551f452-fe71-11ea-092f-51262b503e65
# ╟─8c23271e-fe70-11ea-1b26-d578e891af5d
# ╠═0b2ed1d8-fe72-11ea-2315-3bd2c188d2a5
# ╟─f3f9c338-fe73-11ea-0cf1-69a8cb8803a1
# ╠═1397611c-fe74-11ea-1b77-6336887b5cad
# ╠═fd9abf12-fe73-11ea-0c60-81a5213d6162
# ╟─23e8c5f4-fe74-11ea-1b65-ed80262f73bb
# ╠═e8bce54e-fe72-11ea-32e0-ad6d0cf7dcf5
# ╟─a1d99abc-fe74-11ea-1a58-13b6096c1aa1
# ╠═4f5594fa-fe6d-11ea-0bbd-8546c83eaa8b
# ╠═86c22f66-fe6d-11ea-2285-139c4a2dc1d9
# ╟─4d555cc8-fe75-11ea-26a7-a336cba310cb
# ╠═6cbf5742-fe6d-11ea-21a4-9f0528124b35
# ╟─6c4cbb5a-fe75-11ea-398d-1fdf3e60c6ac
# ╠═804b3c10-fe75-11ea-1b1b-9327d44145b0
# ╠═a5acf7fa-fe75-11ea-080a-7d3d09edf268
# ╠═ac9eced2-fe75-11ea-1f27-f3e3e6204b8f
