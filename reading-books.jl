### A Pluto.jl notebook ###
# v0.9.2

using Markdown

# ╔═╡ 7d345408-9b72-11ea-0a6f-1f98a5606bcc
md"""
# Reading a book

This notebook will show some simple things you can do with natural language data. With some puzzles at the end!

You don't need to now anything natural language processing to understand this notebook, but you should have some knowledge about programming in Julia and Pluto. 

Let's get started! We will import the novel _Emma_ by Jane Austen. A [txt version of the book](https://www.gutenberg.org/files/158/158-0.txt) (and many other public domain books) is available at [Project Gutenberg](www.gutenberg.org).
"""

# ╔═╡ 72061fea-9b71-11ea-030c-41b037d39a84
#all text
emma = begin
	raw_text = open("emma.txt") do file
		read(file, String)
	end
	
	#the txt file contains a lot of information about copyright and so on
	#so we filter that out first
	lines = split(raw_text, r"\n")
	relevant_lines = lines[32:end - 368]
	join(relevant_lines, "\n")
end

# ╔═╡ 07f26706-9b75-11ea-1595-136ad1d0978b
md"""
## Words
A string is a sequence of characters. However, we often want to talk about words instead of characters. We can use the `split` function in Julia to split a text on whitespace, like below.
"""

# ╔═╡ 175ea342-9c26-11ea-1927-19f53874fef4
hamlet = """To be, or not to be? That is the question."""

# ╔═╡ 952e26b4-9b75-11ea-0711-977b90743ae3
split(hamlet)

# ╔═╡ d890a402-9b75-11ea-0ee6-7326f7bbccdf
md"""
You can inspect the array of words there. It looks good, but maybe not quite what we want. If I asked you how often the word _be_ occurred in the quote, you would say twice. But if I try to count them, I get 0. In our array `hamlet_words`, we have `"be,"` and `"be?"`, but not `"be"`.
"""

# ╔═╡ 73724f36-9b76-11ea-0e84-350dda00f820
count(split(hamlet) .== "be")

# ╔═╡ cbb96922-9b76-11ea-140e-35de61d688d5
md"""
We often separate words from punctuation for this reason. The function below will split a string on not only whitespace, but also other transitions between word character and non-word characters.

(Many string functions in Julia, including `split`, use regular expresions. They are a nice way to match patterns!)
"""

# ╔═╡ d65a4a38-9b74-11ea-1b14-fb763c262d1e
function splitwords(text) ::Array{String}
	# split on
	# - one or more whitespace characters (\s+) 
	# - other word boundaries (\b)
	tokens = split(text, r"(\s+|\b)")
end

# ╔═╡ b0779dce-9c38-11ea-0251-b10881908904
count(splitwords(hamlet) .== "be")

# ╔═╡ 8b9a4e8c-9b77-11ea-1ba5-37795938fd81
md"""
That's better. Let's get the words in _Emma_!
"""

# ╔═╡ e36df6ca-9b74-11ea-1a05-4dd376884632
words = splitwords(emma)

# ╔═╡ 4df8fa58-9b75-11ea-17f1-1dde6a0c5fec
md"""
There are $(length(words)) words in the book. Wow!
"""

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
function most_frequent(counts, k = 10) ::Array
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

Word counts are especially interesting if you combine them with other features of words. In this puzzle, we will build functions that check a particular property of the word and return `true`/`false`. We will use these functions to filter our `wordcounts`.

Let's start with a function that checks if a word is very long.
"""

# ╔═╡ 55aadb38-9c18-11ea-1526-f751f1bfba25
function isverylong(word) ::Bool
	length(word) > 15
end

# ╔═╡ 6dceb3b2-9c2f-11ea-144f-adaaac220169
md"""
We can use this to filter our dictionary `wordcounts`.
"""

# ╔═╡ 43eb6534-9c18-11ea-1e4c-fd22bfee3bcf
function filter_counts(filter_func, counts) ::Dict{Any, Integer}
	filter(counts) do pair
		filter_func(pair[1])
	end
end

# ╔═╡ 8416f4c0-9c18-11ea-196d-d1a88c22f5f2
filter_counts(isverylong, wordcounts)

# ╔═╡ 87d2ef9e-9c2f-11ea-2fef-b9787b21c6d1
md"""
Let's sum all the values in the dictionary to see how many long words there are in total!
"""

# ╔═╡ 23cf9b1a-9c2e-11ea-23f9-89807306d0b4
function total_with_filter(filter_func, counts) ::Integer
	filtered = filter_counts(filter_func, counts)
	(sum ∘ values)(filtered)
end

# ╔═╡ 5ebc2572-9c2e-11ea-0a51-df46a2054a3f
total_with_filter(isverylong, wordcounts)

# ╔═╡ aa0341fe-9c2f-11ea-38f7-95c433e14173
md"""
**Your turn!** [come up with a fun function to make.]
"""

# ╔═╡ 060f2664-9c2d-11ea-0340-4732b7edc7f3
begin
	function is_female_prn(word) ::Bool
		pronouns = ["she", "her", "herself"]
		any(x -> x == lowercase(word), pronouns)
	end
end

# ╔═╡ ab3988a0-9c2d-11ea-307c-d1234cde0753
begin
	function is_male_prn(word) ::Bool
		pronouns = ["he", "him", "himself", "his"]
		any(x -> x == lowercase(word), pronouns)
	end
end

# ╔═╡ 0b0378ae-9c38-11ea-0625-9fe6d8201d2c
md"""
Remember that our tokens included punctuation as well. We can build a filter to exclude it.
"""

# ╔═╡ b5c718c0-9c17-11ea-0b93-d511640c082a
function is_real_word(word) ::Bool
	occursin(r"\w", word)
end

# ╔═╡ 6b488324-9b7c-11ea-252d-fd96ec931545
md"""
## Puzzle 2: characters

In this puzzle, we want to know how often different characters are mentioned in the book. Let's start with the main character, Emma. I can count how often _Emma_ occurs in the book using the `wordcounts`: it's $(wordcounts["Emma"]) times.

However, Emma can also be called _Miss Woodhouse_. Let's count how often _Woodhouse_ occurs as wel: $(wordcounts["Woodhouse"]) times. If we add those together, we conclude that Emma is mentioned $(wordcounts["Emma"] + wordcounts["Woodhouse"]) times.

But there is a catch...

First, Emma is also called _Emma Woodhouse_ sometimes. I'm counting those double now. Second, Emma's father is called _Mr Woodhouse_, so I'm counting that as well. 

I could count _Emma_ and _Miss_, instead of _Emma_ and _Woodhouse_, but then I would also be counting characters like _Miss Fairfax_.
"""

# ╔═╡ dc7897c8-9c1c-11ea-0b0b-15847314249c
md"""
The problem is that character names are often two words, not one. When we look at the frequencies of single words, we loose too much context. So what's the solution?

We will be using a technique called _ngrams_, which are fragments of a given length. Specifically, we will be looking at bigrams of words: fragments of two words that appeared next to each other..
"""

# ╔═╡ 369e1d56-9c20-11ea-1135-214648c272a5
function bigrams(words)
	map(1:length(words)-1) do index
		(words[index], words[index + 1])
	end
end

# ╔═╡ a8e0e0c4-9c20-11ea-1cd0-85e32937abfb
md"""
Let's try this function on our Hamlet quote and see the results.
"""

# ╔═╡ 9c1a55e4-9c20-11ea-13a5-3d8494287e95
(bigrams ∘ splitwords)(hamlet)

# ╔═╡ df098660-9c20-11ea-19b1-e5dbc2b0f43c
md"""
For character names, it's a bit inconvenient that we are including punctuation. The book uses a period in _Mr._ and _Mrs._, so our array of words will show `["Mr", ".", "Woodhouse"]`, with the bigrams `("Mr", ".")` and `(".", "Woodhouse")`.

We can use our `is_real_word()` function as a filter to exclude punctuation.
"""

# ╔═╡ 044835e2-9c27-11ea-2633-8540fc388713
bigrams(filter(is_real_word, splitwords(hamlet)))

# ╔═╡ bcf70994-9c27-11ea-23ef-234bbce2c962
md"""
Now let's do this for the words in _Emma_!
"""

# ╔═╡ 9f3e4bd6-9c27-11ea-0abe-3bf6a96705b2
all_bigrams = bigrams(filter(is_real_word, words))

# ╔═╡ 175f46b0-9c28-11ea-32c4-1dd7d9f47916
md"""
Okay, now let's get back to our question: how often is Emma mentioned? And how often are other characters mentioned?

We will make a function `character` that will take a bigram and return which character it mentions, if any. I filled in a little bit of the function.
"""

# ╔═╡ 3650730a-9c28-11ea-2358-2982a77a9991
function character(bigram)
	if bigram[1] == "Emma" && bigram[2] == "Woodhouse"
		return "Emma Woodhouse"
	end
	
	#your code here
	
	return nothing
end

# ╔═╡ 6a6c0aa2-9c28-11ea-1e17-e5a26b103827
md"""
We will use this function to count all the characters.
"""

# ╔═╡ ffbb309a-9c28-11ea-2b93-2dd9caed5bcb
character_counts = begin
	character_mentions = map(character, all_bigrams)
	character_mentions = filter(x -> x != nothing, character_mentions)
	character_counts = count_tokens(character_mentions)
end

# ╔═╡ 9e5dcb7e-9c29-11ea-391e-e727458c269a
md"""
**Your turn!** Improve the `character` function and add a few more characters. The cell block below gives the different aliases for a few of the characters, and your final tally for each of them.

(It's not a complete list, because that would give away who marries who. Of course, you are free to add more.)
"""

# ╔═╡ cb5c9d24-9c29-11ea-28bc-43e93b1deda6
begin
	getcount = name -> get(character_counts, name, 0)
	md"""
	Emma Woodhouse is called _Emma_, _Miss Woodhouse_, or _Emma Woodhouse_. You should not confuse her with _Mr Woodhouse_.
	She is mentioned $(getcount("Emma Woodhouse")) times.
	
	Frank Churchill is called _Frank_, _Frank Churchill_ or _Mr Churchill_. You should not confuse him with _Miss Churchill_ or _Mrs Churchill_.
	He is mentioned $(getcount("Frank Churchill")) times.
	
	Mr Elton is called _Mr Elton_, _Philip Elton_, or _Mr E_. You should not confuse him with _Mrs Elton_.
	He is mentioned $(getcount("Mr Elton")) times.
	
	Mr Knightley is called _Mr Knightley_, _Knightley_, _John Knightley_, or _John_. You should not confuse him with _Mrs Knightley_.
	He is mentioned $(getcount("Mr Knightley")) times.
	"""
end

# ╔═╡ 8400c2a0-9b7c-11ea-257b-dfaac99932b2
md"""
## Puzzle 3: sentences
"""

# ╔═╡ e7dac338-9c18-11ea-146c-0b0c15573d32
function is_sentence_boundary(index, words) ::Bool
	current_token = words[index]
	prev_token = index > 1 ? words[index-1] : ""
	
	if occursin(r"[\.\?!]", current_token)
		if prev_token != "Mr" && prev_token != "Mrs"
			return true
		else
			return false
		end
	else
		return false
	end
end

# ╔═╡ 16a6e494-9c19-11ea-2fa6-5f65d7e7d551
function split_sentences(words) #::Array{Array{String}}
	#get all indices with a begin or end
	boundary_indices = filter(i -> is_sentence_boundary(i, words), 1:length(words)-1)
	
	#indices of starts and stops
	starting_indices = vcat([1], boundary_indices .+ 1)
	stopping_indices = vcat(boundary_indices, [length(words)])
	
	#create slices for each start/stop index pair
	sentences = map(1:length(starting_indices)) do i
		start = starting_indices[i]
		stop = stopping_indices[i]
		sentence = words[start:stop]
	end
end

# ╔═╡ 5de2ec7c-9c19-11ea-0948-d754d55a7889
sentences = split_sentences(words)

# ╔═╡ fc57ec12-9c1a-11ea-18d8-2b6d75486dcc
md"""
We are counting $(length(sentences)) sentences in _Emma_.
"""

# ╔═╡ a7bf6b32-9c31-11ea-0daa-0fa968acb8c6
md"""
**Your turn!** What are the most common sentences in _Emma_? 
"""

# ╔═╡ d379f2ec-9c31-11ea-2f06-2d88a3d53f75
most_common_sentences = begin
	#your code here
end

# ╔═╡ 20756c20-9c32-11ea-2efc-9d0d4646e82f
if !isa(most_common_sentences, Array) || length(most_common_sentences) < 1
	md"""
	Fill in your solution in the code block above.
	"""
elseif most_common_sentences[1] == ["“", "Oh", "!"]
	md"""
	Awesome! If you want, you can also try excluding the punctuation from each sentence before you count them.
	"""
elseif most_common_sentences[1] == ["Oh"]
	md"""
	Nice!
	"""
end

# ╔═╡ fa5af436-9c33-11ea-1e26-b94d92ec5aa5
md"""
**Your turn!** What is the longest sentence in _Emma_? How many words does it have?
"""

# ╔═╡ b67217ae-9c33-11ea-2473-8be0029c9845
longest_sentence = begin
	#your code here
end

# ╔═╡ 4a7f0646-9c34-11ea-325c-9b30baf01777
if isa(longest_sentence, Array)
	str = join((longest_sentence), " ")
	md"""
	The longest sentence in Emma:

	$(str)
	"""
elseif isa(longest_sentence, String)
	md"""
	The longest sentence in Emma:

	$(longest_sentence)
	"""
else
	md"""
	You can return an array of words, or the words joined together in a string.
	"""
end

# ╔═╡ Cell order:
# ╟─7d345408-9b72-11ea-0a6f-1f98a5606bcc
# ╠═72061fea-9b71-11ea-030c-41b037d39a84
# ╟─07f26706-9b75-11ea-1595-136ad1d0978b
# ╠═175ea342-9c26-11ea-1927-19f53874fef4
# ╠═952e26b4-9b75-11ea-0711-977b90743ae3
# ╟─d890a402-9b75-11ea-0ee6-7326f7bbccdf
# ╠═73724f36-9b76-11ea-0e84-350dda00f820
# ╟─cbb96922-9b76-11ea-140e-35de61d688d5
# ╠═d65a4a38-9b74-11ea-1b14-fb763c262d1e
# ╠═b0779dce-9c38-11ea-0251-b10881908904
# ╟─8b9a4e8c-9b77-11ea-1ba5-37795938fd81
# ╠═e36df6ca-9b74-11ea-1a05-4dd376884632
# ╟─4df8fa58-9b75-11ea-17f1-1dde6a0c5fec
# ╟─c1c0e6e4-9b77-11ea-231b-a9633bd92d97
# ╠═c1016a7a-9b78-11ea-2528-37c572305f75
# ╠═ccb60d9c-9b78-11ea-3f37-fd7d743374fe
# ╟─d938cf3c-9b78-11ea-3993-4d7e76df364d
# ╟─3a803dae-9b79-11ea-1a49-2552ded1efe2
# ╠═d76a9018-9b79-11ea-3d92-1bed57d6fd69
# ╠═fac66c12-9b79-11ea-2c50-017bba75621a
# ╟─3bf5255c-9b7a-11ea-276f-8d3fdce5c7c3
# ╠═55aadb38-9c18-11ea-1526-f751f1bfba25
# ╟─6dceb3b2-9c2f-11ea-144f-adaaac220169
# ╠═43eb6534-9c18-11ea-1e4c-fd22bfee3bcf
# ╠═8416f4c0-9c18-11ea-196d-d1a88c22f5f2
# ╟─87d2ef9e-9c2f-11ea-2fef-b9787b21c6d1
# ╠═23cf9b1a-9c2e-11ea-23f9-89807306d0b4
# ╠═5ebc2572-9c2e-11ea-0a51-df46a2054a3f
# ╟─aa0341fe-9c2f-11ea-38f7-95c433e14173
# ╠═060f2664-9c2d-11ea-0340-4732b7edc7f3
# ╠═ab3988a0-9c2d-11ea-307c-d1234cde0753
# ╟─0b0378ae-9c38-11ea-0625-9fe6d8201d2c
# ╠═b5c718c0-9c17-11ea-0b93-d511640c082a
# ╟─6b488324-9b7c-11ea-252d-fd96ec931545
# ╟─dc7897c8-9c1c-11ea-0b0b-15847314249c
# ╠═369e1d56-9c20-11ea-1135-214648c272a5
# ╟─a8e0e0c4-9c20-11ea-1cd0-85e32937abfb
# ╠═9c1a55e4-9c20-11ea-13a5-3d8494287e95
# ╟─df098660-9c20-11ea-19b1-e5dbc2b0f43c
# ╠═044835e2-9c27-11ea-2633-8540fc388713
# ╟─bcf70994-9c27-11ea-23ef-234bbce2c962
# ╠═9f3e4bd6-9c27-11ea-0abe-3bf6a96705b2
# ╟─175f46b0-9c28-11ea-32c4-1dd7d9f47916
# ╠═3650730a-9c28-11ea-2358-2982a77a9991
# ╟─6a6c0aa2-9c28-11ea-1e17-e5a26b103827
# ╠═ffbb309a-9c28-11ea-2b93-2dd9caed5bcb
# ╟─9e5dcb7e-9c29-11ea-391e-e727458c269a
# ╟─cb5c9d24-9c29-11ea-28bc-43e93b1deda6
# ╠═8400c2a0-9b7c-11ea-257b-dfaac99932b2
# ╠═e7dac338-9c18-11ea-146c-0b0c15573d32
# ╠═16a6e494-9c19-11ea-2fa6-5f65d7e7d551
# ╠═5de2ec7c-9c19-11ea-0948-d754d55a7889
# ╟─fc57ec12-9c1a-11ea-18d8-2b6d75486dcc
# ╟─a7bf6b32-9c31-11ea-0daa-0fa968acb8c6
# ╠═d379f2ec-9c31-11ea-2f06-2d88a3d53f75
# ╟─20756c20-9c32-11ea-2efc-9d0d4646e82f
# ╟─fa5af436-9c33-11ea-1e26-b94d92ec5aa5
# ╠═b67217ae-9c33-11ea-2473-8be0029c9845
# ╟─4a7f0646-9c34-11ea-325c-9b30baf01777
