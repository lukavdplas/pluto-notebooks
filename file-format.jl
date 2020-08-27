### A Pluto.jl notebook ###
# v0.11.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 635498b6-cd1c-11ea-3365-4dcf058dfcf6
md"""
# The pluto file format

A short demonstration of the Pluto file format. [something of an explanation: you don't really need to deal with the raw file, but this may be interesting if

- you want to share your pluto files with other julia users (if they don't use pluto 😪)
- you want to import the code that you wrote in pluto
- you want to keep track of changes to the code

The pluto file format is simple, and works as a regular julia file.]


As a demonstration, we will do someting a bit odd: we will import the file for this notebook into the notebook itself. Here it is!
"""

# ╔═╡ c62b0418-cd1f-11ea-2a1f-ed7b7f207b26
md"""
What happens if we change the notebook? Pluto autosaves, so the file is always up to date. However, Pluto doesn't notice that the underlying file is changed with the notebook. So whenever you want to refresh the file, click the button below.
"""

# ╔═╡ 043c8b00-cd20-11ea-2f09-3b0d2b5268bc
md"""
## Fun experimentation section

Now that you can easily see the file, you can easily see what happens when you work in a notebook. Here are some cells with complicated calculations. You can see that the value of `y` is dependent on `x`. Look for these cells in the file above. Then try changing their order, refresh, and see how it affects the file.
"""

# ╔═╡ 630197b6-cd1b-11ea-2b4d-b517ee6bf6ba
@bind go html"""<button>Read file</button>"""

# ╔═╡ ea6db546-cd1a-11ea-06f3-45d52ab1a08b
text = open("file-format.jl") do file
	go
	read(file, String)
end

# ╔═╡ 1fff25d0-cd1b-11ea-2c51-6595cb61bb08
HTML("<code><pre>$(Markdown.htmlesc(text))</pre></code>")

# ╔═╡ c8b35b72-cd1a-11ea-34d7-533e3d8f73cf
x = 5

# ╔═╡ e0f8758c-cd1a-11ea-06c5-0b3cb9838a56
y = x ^2

# ╔═╡ Cell order:
# ╟─635498b6-cd1c-11ea-3365-4dcf058dfcf6
# ╟─1fff25d0-cd1b-11ea-2c51-6595cb61bb08
# ╟─c62b0418-cd1f-11ea-2a1f-ed7b7f207b26
# ╟─630197b6-cd1b-11ea-2b4d-b517ee6bf6ba
# ╟─ea6db546-cd1a-11ea-06f3-45d52ab1a08b
# ╟─043c8b00-cd20-11ea-2f09-3b0d2b5268bc
# ╠═c8b35b72-cd1a-11ea-34d7-533e3d8f73cf
# ╠═e0f8758c-cd1a-11ea-06c5-0b3cb9838a56
