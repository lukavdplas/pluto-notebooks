### A Pluto.jl notebook ###
# v0.8.10

using Markdown

# ╔═╡ 581eef80-9687-11ea-2ee5-db08b9bb11cd
md"""
## Read the text
We import the file `austen-emma.txt`, which contains the raw text of the book _Emma_ by Jane Austen.
"""

# ╔═╡ c701a804-9685-11ea-3dc9-db40f486abd4
#all text
emma = begin
	open("austen-emma.txt") do file
		read(file, String)
	end
end

# ╔═╡ 4f094388-969a-11ea-2b9c-a198ceed6380
function splitwords(text) :: Array{String}
	#clean up whitespace
	cleantext = replace(text, r"\s+" => " ")
	
	#split on whitespace or other word boundaries
	tokens = split(cleantext, r"(\s|\b)")
end

# ╔═╡ 39970738-9686-11ea-202b-a5ea2f026df6
#split into words. this can be improved with regular expressions
words = (splitwords ∘ lowercase)(emma)

# ╔═╡ 40fd278e-9687-11ea-2625-43257cd673c2
md"""
## Simple example: number frequencies
This is a good example for creating a meaningless plot, without too much preprocessing. How often does the book mention different numbers?

For the moment, we will just look at the numbers one to twenty. Higher numbers are more difficult, since older English texts often write "one and twenty" instead of "twenty-one".
"""

# ╔═╡ c0c80fe0-9686-11ea-2f59-f1c067e6e0d2
#strings for numbers
begin
	numberstrings = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"]
	numbers = collect(1:length(numberstrings))

	nothing
end

# ╔═╡ d7f6607c-9686-11ea-2a71-61499a30af90
#count occurrences for each word
numbercounts = map(numberstrings) do word
	matches = word .== words
	count(matches)
end

# ╔═╡ 3cf335b2-9688-11ea-1327-0da67c64d06e
#plot
begin
	using Plots
	plot(numbers, numbercounts)
	plot!(xlabel = "Number", ylabel = "Frequency", legend = false)
end

# ╔═╡ fb61f128-969c-11ea-012d-63d3d552aa34
md"""
## More advanced: a bigram model

Let's do something a bit more NLP: we will make a bigram model. Given a sequence of tokens, its bigrams are all the pairs of tokens that occur next to each other. For example, for the sentence

"Emma Woodhouse, handsome, clever, and rich"

the bigrams would be 

`[("Emma", "Woodhouse"), ("Woodhouse", "handsome"), ("handsome", "clever"), ("clever", and"), ("and", "rich")]`

Bigrams are fairly easy to collect, but can give us a lot of information.
"""

# ╔═╡ 6226083a-969e-11ea-2887-21cc1342d39a
function bigrams(text) :: Array
	#split on words and remove punctuation
	tokens = splitwords(text)
	words = filter(token -> occursin(r"\w", token), tokens)
	
	#get bigrams
	return [(words[i], words[i + 1]) for i in 1:length(words)-1]
end

# ╔═╡ 8b4f47ea-96a0-11ea-1561-b7ae258ab24a
md"""
We can collect bigrams with `bigrams(emma)`. However, our bigram function consideres the text to be a continuous stream of words, which is a bit of a simplification. Let's only look at bigrams that don't go over paragraph breaks.
"""

# ╔═╡ 713dba40-969e-11ea-2340-79ca27c5dfb0
emma_bigrams = begin
	#split on paragraphs
	paragraphs = split(emma, "\n")
	#collect all bigrams
	[bigram for par in paragraphs for bigram in bigrams(par)]
end

# ╔═╡ 79a1460a-96a1-11ea-18a5-2f5b2d6bceca
function count_tokens(tokens) :: Dict{Any, Integer}
	#create a dict of counts for a list of tokens
	
	frequencies = Dict()
		
	for token in tokens
		frequencies[token]= get(frequencies, token, 0) + 1
	end
	
	frequencies
end

# ╔═╡ a5f2143e-9aa7-11ea-333a-ebdb5f78b796
md"""
## Using bigrams to count characters
"""

# ╔═╡ f9aa39d0-96a1-11ea-0763-db7525966290
bigram_counts = count_tokens(emma_bigrams)

# ╔═╡ 84d3e73a-96a3-11ea-3758-1f577eccc4bf
function character(bigram)
	#if a bigram mentions a character, return that character's name
	
	#Emma
	if bigram[1] == "Emma" || bigram == ("Miss", "Woodhouse")
		return "Emma"
	end
	
	#Mr Woodhouse
	if bigram[2] == "Woodhouse"
		return "Mr Woodhouse"
	end
	
	#Harriet
	if bigram[1] == "Harriet" || bigram == ("Miss", "Smith")
		return "Harriet Smith"
	end
	
	#Mr Knightley
	if bigram[1] == "John" || (bigram[1] != "Mrs" && bigram[2] == "Knightley")
		return "Mr Knightley"
	end
	
	#Frank churchill
	if bigram[1] == "Frank" || bigram[2] == "Churchill"
		return "Frank Churchill"
	end
	
	#Mr Elton
	if bigram == ("Mr", "Elton") || bigram == ("Mr", "E")
		return "Mr Elton"
	end
	
	return nothing
end

# ╔═╡ 8ac9957a-96a5-11ea-123c-e95b895a8819
character_counts = begin
	println()
	character_mentions = map(character, emma_bigrams)
	character_mentions = filter(x -> x != nothing, character_mentions)
	character_counts = count_tokens(character_mentions)
end

# ╔═╡ 6385d598-96a8-11ea-36c3-835b3afbe2d2
begin
	characters = collect(keys(character_counts))
	
	freq = name -> character_counts[name]
	sorted_characters = sort(characters, by = freq, rev = true)
	frequencies = map(freq, sorted_characters)
	
	bar(sorted_characters, frequencies, legend = false)
	plot!(xlabel = "Character", ylabel = "Mentions")
end

# ╔═╡ Cell order:
# ╟─581eef80-9687-11ea-2ee5-db08b9bb11cd
# ╠═c701a804-9685-11ea-3dc9-db40f486abd4
# ╠═39970738-9686-11ea-202b-a5ea2f026df6
# ╠═4f094388-969a-11ea-2b9c-a198ceed6380
# ╟─40fd278e-9687-11ea-2625-43257cd673c2
# ╠═c0c80fe0-9686-11ea-2f59-f1c067e6e0d2
# ╠═d7f6607c-9686-11ea-2a71-61499a30af90
# ╠═3cf335b2-9688-11ea-1327-0da67c64d06e
# ╟─fb61f128-969c-11ea-012d-63d3d552aa34
# ╠═6226083a-969e-11ea-2887-21cc1342d39a
# ╟─8b4f47ea-96a0-11ea-1561-b7ae258ab24a
# ╠═713dba40-969e-11ea-2340-79ca27c5dfb0
# ╠═79a1460a-96a1-11ea-18a5-2f5b2d6bceca
# ╟─a5f2143e-9aa7-11ea-333a-ebdb5f78b796
# ╠═f9aa39d0-96a1-11ea-0763-db7525966290
# ╠═84d3e73a-96a3-11ea-3758-1f577eccc4bf
# ╠═8ac9957a-96a5-11ea-123c-e95b895a8819
# ╠═6385d598-96a8-11ea-36c3-835b3afbe2d2
