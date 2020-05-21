### A Pluto.jl notebook ###
# v0.9.0

using Markdown

# ╔═╡ a0f0ae42-9ad8-11ea-2475-a735df64aa28
using Plots

# ╔═╡ 7b93882c-9ad8-11ea-0288-0941e163f9d5
md"""
# Plotting in Pluto

Pluto is an excellent enviroment to visualise your data. This notebook shows a few examples of using plots in Pluto using the `Plots` package.

I wrote this notebook so you can understand it even if you have never used `Plots`. However, it is not intend as a complete tutorial for the package. If you want to start making your own plots, I recommend looking at the package [documentation](https://docs.juliaplots.org/latest/) for a full tutorial as well.

Let's start by importing the `Plots` package. You can just put a cell like this anywhere in your notebook.
"""

# ╔═╡ 5ae65950-9ad9-11ea-2e14-35119d369acd
md"""
## The basics
Now we can get started. We can begin by making some X and Y values. I typed out some Y values so you can alter them and see the effect. 
"""

# ╔═╡ aaa805d4-9ad8-11ea-21c2-3b20580fea0e
X = 1:10

# ╔═╡ c02bc44a-9ad8-11ea-117d-3997e1f3cab0
Y1 = [0.15, 0.25, 0.8, 0.75, 0.5, 0.3, 0.35, 0.15, 0.25, 0.35]

# ╔═╡ a405ae4c-9ad9-11ea-0008-f763e098846d
md"""
Great, let's plot them! The basic syntax of of `Plots` is very simple.
"""

# ╔═╡ 12a8c222-9ad9-11ea-2544-355bd080367f
plot(X, Y1)

# ╔═╡ 19660da0-9ada-11ea-1942-a9d4ddd7753b
md"""
You can change the properties of the plot by giving different arguments to the function call.
"""

# ╔═╡ 5410faba-9ada-11ea-2fc5-35f0bdd40d96
plot(X, Y1, legend = false, title = "A plot with a title")

# ╔═╡ 90c47cae-9ada-11ea-10da-91f4dcf0f2d6
md"""
Alternatively, you can use `plot!()`. This function takes the same arguments, but alters our existing plot.
"""

# ╔═╡ b2727d2e-9ada-11ea-23d3-bddab9ec8de1
begin
	plot(X, Y1)
	plot!(legend = false)
	plot!(title = "A plot with a title")
end

# ╔═╡ eb218bea-9adc-11ea-2f3a-298c41caf8a1
md"""
## More options

We can easily plot multiple series.
"""

# ╔═╡ bd30bdf4-9add-11ea-26d4-75ac3f0b8610
Y2 = rand(10)

# ╔═╡ dc50d480-9add-11ea-2821-018a98fab262
begin
	plot(X, Y1, label = "some data")
	plot!(X, Y2, label = "more data")
end

# ╔═╡ c9a64e98-9b67-11ea-1d6a-3b1f7548cb8d
md"""
Different plot types have their own functions.
"""

# ╔═╡ 13428812-9ade-11ea-3865-1d293993203d
scatter(Y1, Y2, legend = false)

# ╔═╡ d76fd0f6-9b67-11ea-0a73-e9ddb60ca291
md"""
You can also plot a function instead of an output array!
"""

# ╔═╡ 69fa7744-9b67-11ea-26df-3b4446dfb3ea
begin
	function myfunction(x)
		return sin(x/2)
	end
	
	plot(X, sin, label = "sine")
	plot!(X, myfunction, label = "my function")
end

# ╔═╡ af31a428-9adf-11ea-280a-45e2b891c4f9
md"""
## Naming plots

Plots are also just a type of variable, so you can give them a name.
"""

# ╔═╡ 80e5ac54-9adf-11ea-0ccf-8fba5fe52049
plot2 = scatter(Y1, Y2, legend = false)

# ╔═╡ 030c1d10-9b69-11ea-11b7-ff04c60892b9
md"""
This way, you can show them again
"""

# ╔═╡ 22992cec-9adb-11ea-078e-c7c21489c053
md"""
## Combining subplots

We can combine multiple plots in a single image using the `layout` argument. One option is to provide a matrix of values and call a single `plot`.
"""

# ╔═╡ 5d723220-9ade-11ea-37db-c110dda60a15
Y3 = rand(10)

# ╔═╡ 5ed7c444-9adf-11ea-2925-8573f018e820
plot1 = plot(X, Y3, legend = false)

# ╔═╡ d7bdab72-9b65-11ea-18c0-5353a214749d
plot1

# ╔═╡ 632cb26c-9ade-11ea-1bc7-39b8207190e2
Y4 = rand(10)

# ╔═╡ a01bf430-9ade-11ea-2ae4-23287ba11406
Y = hcat(Y1, Y2, Y3, Y4)

# ╔═╡ 69e045b0-9ade-11ea-0c55-05fa0da5893c
plot(X, Y, layout = (4,1), legend = false)

# ╔═╡ 054e0c4e-9adf-11ea-3deb-4daf2b6a2548
md"""
This works when we have a nice output matrix, but life is not always that simple!

Named plots are usually the best solution. When we have created a few plots, we can put them together in a single plot.
"""

# ╔═╡ 91b4eedc-9adf-11ea-37aa-250ceec26640
plot(plot1, plot2, layout = (2,1))

# ╔═╡ a7abf64e-9adb-11ea-2ae4-47886125fe60
md"""
## The Pluto way of plotting

For the most part, plotting in Pluto is not different from anywhere else. However, there are a few things to keep in mind.

The `plot!()` function alters an existing plot. In reactive programming, you are not supposed to alter the value of a variable you defined in a different cell. I strongly recommend that you only use `plot!()` to alter plots you initialised in the same cell. 

For the sake of demonstration, here is what happens if you use `plot!()` in its own cell.
"""

# ╔═╡ 2617a7b6-9ae2-11ea-1461-d914c7cfdb09
myplot = plot(X, Y3, label = "apples")

# ╔═╡ 46388876-9ae2-11ea-2c5f-073698e45d44
md"""
The cell below adds a new series to the plot. It shows the altered plot, while our original plot still looks intact. Okay, we can work with that, right?

Try changing the code so the extra series is based on `Y1` or `Y2` instead of `Y4`.
"""

# ╔═╡ 2598a29a-9ae2-11ea-02cc-21f3fa5a9472
plot!(myplot, X, Y4, label = "oranges")

# ╔═╡ a9cdba00-9ae2-11ea-3bf9-41d07e7a785f
md"""
Did you get three series? It's because the `plot` still has the `Y4` variable added to it. So the data from `Y4` are still in the plot, even though you now don't have any code doing that. This is not great for coding: it means that if you close your notebook, it might not look the same when you open it again.

Try running the cell a few times. You keep adding series! Also not great when working on a plot.
"""

# ╔═╡ f22b6fda-9ae3-11ea-3ff2-ebcf1374f595
md"""
So what if you do want to add things to a plot one at a time, instead of using a single cell? My recommendation is to define your plot in a function.
"""

# ╔═╡ 8819edf0-9ae4-11ea-15f4-f17e9e9db8ea
function apples_plot()
	myplot = plot(X, Y3, label = "apples")
	return myplot
end

# ╔═╡ 9e4d1462-9ae4-11ea-3c0f-774d68a671c3
apples_plot()

# ╔═╡ a7906786-9ae4-11ea-0175-4f860c05a8a2
begin
	a = apples_plot()
	plot!(X, Y4, label = "oranges")
end

# ╔═╡ d3cbc548-9ae4-11ea-261f-7fb956839e53
md"""
Try changing the function for the base plot and the alterations in the bottom cell. No weird effects!
"""

# ╔═╡ Cell order:
# ╟─7b93882c-9ad8-11ea-0288-0941e163f9d5
# ╠═a0f0ae42-9ad8-11ea-2475-a735df64aa28
# ╟─5ae65950-9ad9-11ea-2e14-35119d369acd
# ╠═aaa805d4-9ad8-11ea-21c2-3b20580fea0e
# ╠═c02bc44a-9ad8-11ea-117d-3997e1f3cab0
# ╟─a405ae4c-9ad9-11ea-0008-f763e098846d
# ╠═12a8c222-9ad9-11ea-2544-355bd080367f
# ╟─19660da0-9ada-11ea-1942-a9d4ddd7753b
# ╠═5410faba-9ada-11ea-2fc5-35f0bdd40d96
# ╟─90c47cae-9ada-11ea-10da-91f4dcf0f2d6
# ╠═b2727d2e-9ada-11ea-23d3-bddab9ec8de1
# ╟─eb218bea-9adc-11ea-2f3a-298c41caf8a1
# ╠═bd30bdf4-9add-11ea-26d4-75ac3f0b8610
# ╠═dc50d480-9add-11ea-2821-018a98fab262
# ╟─c9a64e98-9b67-11ea-1d6a-3b1f7548cb8d
# ╠═13428812-9ade-11ea-3865-1d293993203d
# ╟─d76fd0f6-9b67-11ea-0a73-e9ddb60ca291
# ╠═69fa7744-9b67-11ea-26df-3b4446dfb3ea
# ╟─af31a428-9adf-11ea-280a-45e2b891c4f9
# ╠═5ed7c444-9adf-11ea-2925-8573f018e820
# ╠═80e5ac54-9adf-11ea-0ccf-8fba5fe52049
# ╟─030c1d10-9b69-11ea-11b7-ff04c60892b9
# ╠═d7bdab72-9b65-11ea-18c0-5353a214749d
# ╟─22992cec-9adb-11ea-078e-c7c21489c053
# ╠═5d723220-9ade-11ea-37db-c110dda60a15
# ╠═632cb26c-9ade-11ea-1bc7-39b8207190e2
# ╠═a01bf430-9ade-11ea-2ae4-23287ba11406
# ╠═69e045b0-9ade-11ea-0c55-05fa0da5893c
# ╟─054e0c4e-9adf-11ea-3deb-4daf2b6a2548
# ╠═91b4eedc-9adf-11ea-37aa-250ceec26640
# ╟─a7abf64e-9adb-11ea-2ae4-47886125fe60
# ╠═2617a7b6-9ae2-11ea-1461-d914c7cfdb09
# ╟─46388876-9ae2-11ea-2c5f-073698e45d44
# ╠═2598a29a-9ae2-11ea-02cc-21f3fa5a9472
# ╟─a9cdba00-9ae2-11ea-3bf9-41d07e7a785f
# ╟─f22b6fda-9ae3-11ea-3ff2-ebcf1374f595
# ╠═8819edf0-9ae4-11ea-15f4-f17e9e9db8ea
# ╠═9e4d1462-9ae4-11ea-3c0f-774d68a671c3
# ╠═a7906786-9ae4-11ea-0175-4f860c05a8a2
# ╟─d3cbc548-9ae4-11ea-261f-7fb956839e53
