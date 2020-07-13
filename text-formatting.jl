### A Pluto.jl notebook ###
# v0.10.5

using Markdown
using InteractiveUtils

# ╔═╡ c6140a90-c515-11ea-2055-13a3fe533116
md"""
# Formatting text in Pluto

This notebook is not about creating awesome julia code, but about creating nice-looking text blocks in-between.
"""

# ╔═╡ 4063ef22-c516-11ea-30ac-1744d4e53cb0
md"""
## The basics: markdown formatting

The typical way to include text blocks in notebooks is using _markdown_. (explanation of what markdown is: simple formatting. A simple syntax is used to encode aspects of formatting. Pluto handles how these things end up looking.

Pluto imports the Markdown package from julia, and these markdown pieces are actually just a special type of string.

Like all code, markdown sections can be shown or hidden. Users are encouraged to look at the code for this notebook, but in "real" notebooks, you will usually just hide the code for markdown.)
"""

# ╔═╡ f80e9ed8-c516-11ea-31b2-e7b486b87223
md"""
### Markdown syntax

(Some example of standard markdown syntax, and a link to a good reference guide.)

Includes things like **bold text** and _italics_. Also:

* bullet
* points

or

1. numbered
2. lists

And of course the header styles.
"""

# ╔═╡ 07fd4102-c51a-11ea-1167-33d036a1258b
md"""
Some special attention can go to the `literal text`. This uses a code-like font, but also means that the snippet should be printed as is, and not get further formatting. For example:
"""

# ╔═╡ 850a3682-c51a-11ea-0852-c95828d5a4fe
md"""
_When writing in italics, I can include **bold** text._

`When writing literal text, I cannot include **bold** text.`
"""

# ╔═╡ ccd5c322-c516-11ea-33dd-cd8245d6d93a
md"""
### Links and images

I think this is worth its own thing. We can show the syntax for links and images, but also explain that you can include links to local paths or urls. Maybe explain that using a url is encouraged since it means the notebook works on its own, but you could include a link to something in the same repository.
"""

# ╔═╡ 6755777c-c516-11ea-2464-bfcede7ea02f
md"""
## Making dynamic text

This is where things get fun. You can make your text blocks dependent on the code that is running. A straightforward way is to use if-else blocks.
"""

# ╔═╡ 18d178b2-c516-11ea-1f13-eb01937b4a36
x  = 10

# ╔═╡ 9ff8d7ca-c518-11ea-0243-d352ebe64630
if x > 0
	md"x is positive"
elseif x == 0
	md"x is zero"
else
	md"x is negative"
end

# ╔═╡ ca44fd68-c518-11ea-3e2e-89ee611e5e3e
md"""
### The $ operator

This allows you to insert expressions in markdown, like in the example below. When you just type `x`, is is a letter, but for `$(x)`, we look at the value of the _expression_ `x`.
"""

# ╔═╡ e66c1bb8-c518-11ea-000d-53e2f3a7fcc6
md"the value of x is $(x)"

# ╔═╡ 53854a6a-c51b-11ea-146f-1bb275b71e70
md"""
You can use the $ to include strings in your markdown blocks. Normally, strings are shown in a more technical fashion.
"""

# ╔═╡ 7784dc78-c51b-11ea-1278-b3cb477a73c8
myname = "Shakespeare"

# ╔═╡ afda9176-c51b-11ea-321c-b3cb0546e3c7
md"""
You can just include these in markdown cells.
"""

# ╔═╡ 2f4ed8e6-c51b-11ea-1dcb-3f8c7652ec6d
md"""Hello $(myname)!"""

# ╔═╡ 5f3733ae-c51c-11ea-0a54-05fe2d2dba6d
md"""
This can be useful because markdown strings are not as easy to work with as regular strings. For instance, you can't concatenate them:
"""

# ╔═╡ 7f746222-c51c-11ea-04ad-81d6f1912b43
md"this" * md" doesn't work"

# ╔═╡ f9329d5e-c51c-11ea-1c61-bb81391f04cb
md"""
Often a good solution is to do all your complicated operations on strings, and convert them to markdown when you're done.
"""

# ╔═╡ 50cec1a2-c51d-11ea-2740-6b23a010531f
sentence = "this" * " works!"

# ╔═╡ 1a8a05bc-c51d-11ea-2222-15847ab74fdc
md"""
 $(sentence)
"""

# ╔═╡ 4cb6d430-c519-11ea-38fe-f3bc528ff9cc
md"""
## Advanced options: html formatting

Markdown is nice because it is simple, but it also doesn't have that many options. If you want more, you may want to use html formatting instead.
"""

# ╔═╡ a693a904-c519-11ea-1371-e747ace3f589
html"""
Html snippets can do all the same things are markdown strings, such as <b>bold text</b>, <i>italics</i> and the like. It all looks the same.
"""

# ╔═╡ d00c0ba4-c519-11ea-28f2-432a4f216d82
html"""
However, you have all the extra options of html formatting.

<div style="margin: 2em; padding:1em; border:2px solid orange; text-align:center">
	For example, this text is in a cool block.
</div>
"""

# ╔═╡ Cell order:
# ╟─c6140a90-c515-11ea-2055-13a3fe533116
# ╟─4063ef22-c516-11ea-30ac-1744d4e53cb0
# ╟─f80e9ed8-c516-11ea-31b2-e7b486b87223
# ╟─07fd4102-c51a-11ea-1167-33d036a1258b
# ╠═850a3682-c51a-11ea-0852-c95828d5a4fe
# ╟─ccd5c322-c516-11ea-33dd-cd8245d6d93a
# ╟─6755777c-c516-11ea-2464-bfcede7ea02f
# ╠═18d178b2-c516-11ea-1f13-eb01937b4a36
# ╠═9ff8d7ca-c518-11ea-0243-d352ebe64630
# ╟─ca44fd68-c518-11ea-3e2e-89ee611e5e3e
# ╠═e66c1bb8-c518-11ea-000d-53e2f3a7fcc6
# ╟─53854a6a-c51b-11ea-146f-1bb275b71e70
# ╠═7784dc78-c51b-11ea-1278-b3cb477a73c8
# ╟─afda9176-c51b-11ea-321c-b3cb0546e3c7
# ╠═2f4ed8e6-c51b-11ea-1dcb-3f8c7652ec6d
# ╟─5f3733ae-c51c-11ea-0a54-05fe2d2dba6d
# ╠═7f746222-c51c-11ea-04ad-81d6f1912b43
# ╟─f9329d5e-c51c-11ea-1c61-bb81391f04cb
# ╟─50cec1a2-c51d-11ea-2740-6b23a010531f
# ╠═1a8a05bc-c51d-11ea-2222-15847ab74fdc
# ╟─4cb6d430-c519-11ea-38fe-f3bc528ff9cc
# ╠═a693a904-c519-11ea-1371-e747ace3f589
# ╠═d00c0ba4-c519-11ea-28f2-432a4f216d82
