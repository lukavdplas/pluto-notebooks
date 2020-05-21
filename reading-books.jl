### A Pluto.jl notebook ###
# v0.9.2

using Markdown

# ╔═╡ 7d345408-9b72-11ea-0a6f-1f98a5606bcc
md"""
# Reading a book

This notebook will show some simple things you can do with natural language data. With some puzzles at the end!

You don't need any knowledge about natural language processing to understand this notebook, but you should know the basics of programming in Julia.

We will import the novel _Emma_ by Jane Austen. A [txt version of the book](https://www.gutenberg.org/files/158/158-0.txt) (and many other public domain books) is available at [Project Gutenberg](www.gutenberg.org).
"""

# ╔═╡ 72061fea-9b71-11ea-030c-41b037d39a84
#all text
emma = begin
	raw_text = open("emma.txt") do file
		read(file, String)
	end
	
	#the txt file contains a lot of information about cop We yright and so on
	#so we filter that out first
	lines = split(raw_text, r"\n")
	relevant_lines = lines[32:end - 368]
	join(relevant_lines, "\n")
end

# ╔═╡ 07f26706-9b75-11ea-1595-136ad1d0978b
md"""
## Words
A string is a sequence of characters, but we often want to talk about words instead of characters. We can use the `split` function in Julia to split a text on whitespace, like below.
"""

# ╔═╡ 952e26b4-9b75-11ea-0711-977b90743ae3
hamlet_words = begin
	hamlet = """To be, or not to be? That is the question."""
	split(hamlet)
end

# ╔═╡ d890a402-9b75-11ea-0ee6-7326f7bbccdf
md"""
You can inspect the array of words there. It looks good, but maybe not quite what we want. If I asked you how often the word _be_ occurred in the quote, you would say twice. But if I try to count them, I get 0. In our array `hamlet_words`, we have `"be,"` and `"be?"`, but not `"be"`.
"""

# ╔═╡ 73724f36-9b76-11ea-0e84-350dda00f820
count(hamlet_words .== "be")

# ╔═╡ cbb96922-9b76-11ea-140e-35de61d688d5
md"""
We often separate words from punctuation for this reason. The function below will split a string on both whitespace and other types of word boundaries. 

(Many string functions in Julia, including `split`, use regular expresions. They are a nice way to match patterns!)
"""

# ╔═╡ d65a4a38-9b74-11ea-1b14-fb763c262d1e
function splitwords(text) ::Array{String}
	# split on
	# one or more whitespace (\s+) 
	# or other word boundaries (\b)
	tokens = split(text, r"(\s+|\b)")
end

# ╔═╡ 8b9a4e8c-9b77-11ea-1ba5-37795938fd81
md"""
You can try using this function in the definition of `hamlet_words` and see the effect.

Let's get the words in _Emma_!
"""

# ╔═╡ e36df6ca-9b74-11ea-1a05-4dd376884632
words = splitwords(emma)

# ╔═╡ 4df8fa58-9b75-11ea-17f1-1dde6a0c5fec
md"""
There are $(length(words)) words in the book. Wow!

If you want to include the punctuation tokens, you can use the function below.
"""

# ╔═╡ 49ab47e4-9b7a-11ea-0660-e7f6ea9160c9
function filter_true_words(sequence) ::Array{String}
	words = filter(token -> occursin(r"\w", token), sequence)
end

# ╔═╡ 6aac6856-9b7a-11ea-2691-edb871b049c8
md"""Excluding punctuation, there are only $(length(filter_true_words(words))) words in _Emma_."""

# ╔═╡ c1c0e6e4-9b77-11ea-231b-a9633bd92d97
md"""
## Counting

We often care about how often words occur, so counting words is a useful tool. Let's define a function that will count a list of tokens. It will return a dictionary that gives the count for each word.
"""

# ╔═╡ c1016a7a-9b78-11ea-2528-37c572305f75
function count_tokens(tokens) ::Dict{Any, Integer}
	#create a dict of counts for a list of tokens
	
	counts = Dict()
		
	for token in tokens
		#julia's get function allows us to a define a default value
		#if the token is not in the dict yet, it was counted 0 times!
		count = get(counts, token, 0)
		#add one to the count
		counts[token]= count + 1
	end
	
	counts
end

# ╔═╡ ccb60d9c-9b78-11ea-3f37-fd7d743374fe
wordcounts = count_tokens(words)

# ╔═╡ d938cf3c-9b78-11ea-3993-4d7e76df364d
begin
	size = length(wordcounts)
	freq_emma = wordcounts["Emma"]
	md"""
	The dictionary `wordcounts` contains $(size) words in total. The word _Emma_ is mentioned $(freq_emma) times.
	"""
end

# ╔═╡ 3a803dae-9b79-11ea-1a49-2552ded1efe2
md"""
What are the most frequent words?
"""

# ╔═╡ d76a9018-9b79-11ea-3d92-1bed57d6fd69
function most_frequent(counts, k) ::Array
	#create a ranking
	ranking = sort(collect(counts), by = pair -> last(pair), rev = true)
	#get top k items
	top_k = length(ranking) > k ? ranking[1:k] : ranking
	#return an array with only the keys
	top_k_items = map(pair -> first(pair), top_k)
end

# ╔═╡ fac66c12-9b79-11ea-2c50-017bba75621a
most_frequent(wordcounts, 10)

# ╔═╡ 3bf5255c-9b7a-11ea-276f-8d3fdce5c7c3
md"""
## Puzzle 1
"""

# ╔═╡ 6b488324-9b7c-11ea-252d-fd96ec931545
md"""
## Puzzle 2
"""

# ╔═╡ 8400c2a0-9b7c-11ea-257b-dfaac99932b2
md"""
## Puzzle 3
"""

# ╔═╡ Cell order:
# ╟─7d345408-9b72-11ea-0a6f-1f98a5606bcc
# ╠═72061fea-9b71-11ea-030c-41b037d39a84
# ╟─07f26706-9b75-11ea-1595-136ad1d0978b
# ╠═952e26b4-9b75-11ea-0711-977b90743ae3
# ╟─d890a402-9b75-11ea-0ee6-7326f7bbccdf
# ╠═73724f36-9b76-11ea-0e84-350dda00f820
# ╟─cbb96922-9b76-11ea-140e-35de61d688d5
# ╠═d65a4a38-9b74-11ea-1b14-fb763c262d1e
# ╟─8b9a4e8c-9b77-11ea-1ba5-37795938fd81
# ╠═e36df6ca-9b74-11ea-1a05-4dd376884632
# ╟─4df8fa58-9b75-11ea-17f1-1dde6a0c5fec
# ╠═49ab47e4-9b7a-11ea-0660-e7f6ea9160c9
# ╟─6aac6856-9b7a-11ea-2691-edb871b049c8
# ╟─c1c0e6e4-9b77-11ea-231b-a9633bd92d97
# ╠═c1016a7a-9b78-11ea-2528-37c572305f75
# ╠═ccb60d9c-9b78-11ea-3f37-fd7d743374fe
# ╟─d938cf3c-9b78-11ea-3993-4d7e76df364d
# ╟─3a803dae-9b79-11ea-1a49-2552ded1efe2
# ╠═d76a9018-9b79-11ea-3d92-1bed57d6fd69
# ╠═fac66c12-9b79-11ea-2c50-017bba75621a
# ╠═3bf5255c-9b7a-11ea-276f-8d3fdce5c7c3
# ╠═6b488324-9b7c-11ea-252d-fd96ec931545
# ╠═8400c2a0-9b7c-11ea-257b-dfaac99932b2
