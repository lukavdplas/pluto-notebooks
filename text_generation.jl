### A Pluto.jl notebook ###
# v0.8.10

using Markdown

# ╔═╡ 82c2133a-9aa2-11ea-2af0-6944df8fd507
using Random

# ╔═╡ 527f2082-9a9e-11ea-3cd5-3bd80dc638b5
md"""
# Text generation
In this notebook, I will implement some some techniques for dealing with natural language input.

We will focus on the task of text _generation_. Essentially, we will build a model that is supposed to understand what English text normally looks like. To put our model to the test, we ask it to generate some text for us. The more normal the output looks, the better the model.

Let's start by importing some text. We import the novel _Emma_ by Jane Austen. This text provides enough words to build a small model, without overloading the memory.
"""

# ╔═╡ 2b46c964-9a9d-11ea-31c5-b3bc11d9a812
#all text
emma = begin
	open("austen-emma.txt") do file
		read(file, String)
	end
end

# ╔═╡ 9b3fff4c-9a9d-11ea-05ac-97edd38fc6bd
md"""
## Words
We often want to talk about words, not characters. An easy way is to use `split` to split our text on spaces, but this is often not quite what we want.
"""

# ╔═╡ 31e0eaf8-9ab0-11ea-32ca-ad97647c732b
opening_words = """Emma Woodhouse, handsome, clever, and rich, with a comfortable home
and happy disposition, seemed to unite some of the best blessings
of existence"""

# ╔═╡ 0e8337d2-9ab0-11ea-1116-511676b415d1
words_basic = split(opening_words)

# ╔═╡ 4d398d30-9ab0-11ea-1f42-6db0845934ed
md"""
Here, `"clever,"` is counted as a word, but we may not want to include the comma. Let's make a splitwords function that also separates words and punctuation from each other.
"""

# ╔═╡ 842e1104-9a9d-11ea-007a-1177ccf83a73
function splitwords(text) :: Array{String}
	#clean up whitespace
	cleantext = replace(text, r"\s+" => " ")
	
	#split on whitespace or other word boundaries
	tokens = split(cleantext, r"(\s|\b)")
end

# ╔═╡ 864effb6-9a9d-11ea-3cf3-09ba9dbc089a
words = splitwords(emma)

# ╔═╡ d1e7f816-9ab5-11ea-0ce4-31647f30ed99
function unique(sequence)
	sort(collect(Set(sequence)))
end

# ╔═╡ fec2b9f6-9aa7-11ea-0e8d-a9fa88aeac7b
unique_words = unique(words)

# ╔═╡ fa5c3b26-9aa7-11ea-20f2-c3c415c728c2
md"""
We count $(length(words)) words in total, with $(length(unique_words)) unique words.
"""

# ╔═╡ 7fa5f0c6-9ab5-11ea-39aa-519c2e7be2a7
md"""
Our word included punctuation, which is not always interesting. We can create a filter function that only includes real words.
"""

# ╔═╡ c480790a-9ab0-11ea-311c-e386365b05ce
function filter_true_words(sequence)
	words = filter(token -> occursin(r"\w", token), sequence)
end

# ╔═╡ 6f788f7e-9ab5-11ea-060c-23d87d5eb8a8
begin
	true_words = filter_true_words(words)
	true_unique_words = unique(true_words)
	md"""
	Excluding punctuation, we count $(length(true_words)) words in total, with $(length(true_unique_words)) unique words.
	"""
end

# ╔═╡ 986abbd8-9ab4-11ea-1a3f-070fc916a94f
md"""
## Counting words

It is often useful to know how many words there are in a text. Lets count them!
"""

# ╔═╡ 7d3be7f6-9aaa-11ea-044c-8b46d90f163b
function count_tokens(tokens) :: Dict{Any, Integer}
	#create a dict of counts for a list of tokens
	
	frequencies = Dict()
		
	for token in tokens
		#julia's get function allows us to define a default value, which makes counting easy
		frequencies[token]= get(frequencies, token, 0) + 1
	end
	
	frequencies
end

# ╔═╡ de447446-9ab4-11ea-3ff9-f9d5aeca4064
wordcounts = count_tokens(words)

# ╔═╡ 570e8b26-9ab5-11ea-1306-659296350ea4
md"""
What are the most frequent words?
"""

# ╔═╡ e62d5d12-9ab4-11ea-0ae8-418893d47099
function most_frequent(counts, k)
	ranking = sort(collect(counts), by = pair -> last(pair), rev = true)
	top_k = length(ranking) > k ? ranking[1:k] : ranking
	top_k_items = map(pair -> first(pair), top_k)
end

# ╔═╡ 073b460e-9ab5-11ea-0507-6bf366c6fdf2
begin
	top10 = most_frequent(wordcounts, 10)
	md"""The 10 most frequent words are:
	$(join(top10, ", "))
	"""
end

# ╔═╡ b7015ae0-9aa8-11ea-341e-19b682aef24e
md"""
## Making an ngram model

Just using basic words is only going to tell us so much. For text generation, it doesn't really work that well. Instead, we will make an ngram model. This type of model counts the frequencies of short fragments of length _n_.
"""

# ╔═╡ 5ca175f0-9a9f-11ea-176c-77c66121bc6a
function ngrams(sequence, n)
	#return an empty array if the sequence is too short
	if length(sequence) < n
		return []
	end
	
	starting_indices = 1:length(sequence) - (n - 1)
	ngrams = map(starting_indices) do i
		sequence[i:i+(n-1)]
	end
end

# ╔═╡ 89ca765c-9aa7-11ea-15e2-2518bea008bf
bigrams = ngrams(words, 2)

# ╔═╡ 8b12a80c-9aa9-11ea-3abf-e5e84bb1fd5f
md"""
We now have a list with all our bigrams. This is cool, but not very efficient. We want to be able to look up possible continuations quickly.
"""

# ╔═╡ 791e6a82-9aa9-11ea-2c87-17884cb3be96
function ngram_frequencies(ngrams)
	
	history = ngram -> ngram[1:end - 1]
	
	frequencies = Dict()
	for ngram in ngrams
		continuation_dict = get(frequencies, history(ngram), Dict())
		continuation_dict[last(ngram)] = get(continuation_dict, last(ngram), 0) + 1
		frequencies[history(ngram)] = continuation_dict
	end
	frequencies
end

# ╔═╡ 0fa61c2e-9aab-11ea-0b8c-8129498a31e3
bigram_frequencies = ngram_frequencies(bigrams)

# ╔═╡ 9e67b43c-9ab9-11ea-2798-97c07738921d
function continuations(sequence, frequencies)
	get(frequencies, sequence, Dict())
end

# ╔═╡ 6ba7b9de-9ab9-11ea-0f15-b1d4ac313677
most_frequent(continuations(["Emma"], bigram_frequencies), 10)

# ╔═╡ 4b510664-9ac7-11ea-2ecd-7d03e3b103c5
md"""
## Using ngrams for text generation
"""

# ╔═╡ a95f550a-9abb-11ea-1a9e-ab2ff090ec10
function choose_continuation(sequence, frequencies)
	#get dictionaries
	conts = continuations(sequence, frequencies)
	
	#make an array where each value is repeated every time for its frequency
	reps = token -> repeat([token], conts[token])
	repeated_tokens = [item for token in keys(conts) for item in reps(token)]
	
	#choose one randomly
	rand(repeated_tokens)
end

# ╔═╡ 0d8c7180-9ac3-11ea-0588-d398bd50d367
function choose_start(frequencies)
	#generate a dict with history frequencies
	history_count = history -> sum(values(frequencies[history]))
	history_freqs = Dict(hist => history_count(hist) for hist in keys(frequencies))
	
	#pick a value like before
	reps = history -> repeat([history], history_freqs[history])
	repeated_histories = [item for history in keys(history_freqs) for item in reps(history)]
	rand(repeated_histories)
end

# ╔═╡ 30c4868e-9ac4-11ea-03e5-b177d8aa6103
function generate(frequencies, max_length)
	
	sequence = choose_start(frequencies)
		
	n = length(rand(keys(frequencies))) + 1
	while length(sequence) < max_length
		history = sequence[end + 2 - n : end]
		cont = choose_continuation(history, frequencies)
		sequence = vcat(sequence, [cont])
	end
	
	join(sequence, " ")
end

# ╔═╡ 64a917a2-9ac5-11ea-1e37-ab6629ce2f79
begin
	bigram_sample = generate(bigram_frequencies, 100)
	md"""
	Let's generate some text!
	
	$(bigram_sample)
	"""
end

# ╔═╡ f30f172e-9ac7-11ea-3e8c-133817a3136e
md"""
We can compare this to a trigram and fourgram model, which should do better.
"""

# ╔═╡ 21a58050-9ac8-11ea-3650-6b9cf63b651a
trigram_frequencies = ngram_frequencies(ngrams(words, 3))

# ╔═╡ 329a79f6-9ac8-11ea-1417-1ffa794a9bea
begin
	trigram_sample = generate(trigram_frequencies, 100)
	md"""
	Generated by the trigram model:
	
	
	$(trigram_sample)
	"""
end

# ╔═╡ 9a0b173e-9ac9-11ea-3df4-dddf7b68d851
fourgram_frequencies = ngram_frequencies(ngrams(words, 4))

# ╔═╡ a7cfc162-9ac9-11ea-088d-dfb7312102ad
begin
	fourgram_sample = generate(fourgram_frequencies, 100)
	md"""
	Generated by the fourgram model:
	
	
	$(fourgram_sample)
	"""
end

# ╔═╡ 0bb862fa-9acb-11ea-2400-951f7813685c
md"""
## Sentences

We treated our text as one big list of words. You could see that in our sentence generator: it just generated a stream of words without beginning or end.

A lot of the time, it makes sense to break up the text into sentences. For our generator, this will allow us to start at words that often begin sentences, and end when the sentence should be over.
"""

# ╔═╡ b0f573fc-9acb-11ea-18e9-1bf639a24c85
function splitparagraphs(text)
	#split text on whitelines
	paragraphs = split(text, r"\n\n+")
end

# ╔═╡ b89e79e6-9acb-11ea-3e53-9100f418384d
function splitsentences(text)
	#definition of a sentence boundary: a whitespace character preceded by ., ! or ?
	#we put the punctuation in (?<=) so that is is still included in the split sentences
	boundary = r"(?<=[\.\?!])\s"
	sentences = split(text, boundary)
end

# ╔═╡ a96c8e36-9acb-11ea-0f11-8511d28802c2
sentences = begin
	paragraphs = splitparagraphs(emma)
	[sent for par in paragraphs for sent in splitsentences(par)]
end

# ╔═╡ d0c0dcbc-9acb-11ea-0142-b92d971d8689
md"""
We count $(length(sentences)) sentences.
"""

# ╔═╡ 5ca3f06a-9acd-11ea-2046-f78228f33277
function pad_sentence(sentence, n)
	start_padding = repeat(["(START)"], n - 1)
	stop_padding = ["(STOP)"]
	vcat(start_padding, sentence, stop_padding)
end

# ╔═╡ a2391abc-9acd-11ea-2043-f5bd7c256ee1
function sentence_ngrams(sentences, n)
	ngrams_by_sentence = map(sentences) do sentence
		words = splitwords(sentence)
		ngrams(pad_sentence(words, n), n)
	end
	
	[ngram for ngrams in ngrams_by_sentence for ngram in ngrams]
end

# ╔═╡ f234d0f8-9ace-11ea-213f-1d2a09db9ed7
sentence_ngram_frequencies = ngram_frequencies(sentence_ngrams(sentences, 3))

# ╔═╡ 404cbd3c-9acf-11ea-353e-67a257df259a
function generate_sentence(frequencies)
	n = length(rand(keys(frequencies))) + 1
	sentence = repeat(["(START)"], n - 1)
		
	while sentence[end] != "(STOP)"
		history = sentence[end + 2 - n : end]
		cont = choose_continuation(history, frequencies)
		sentence = vcat(sentence, [cont])
	end
	
	#remove padding
	sentence = sentence[n : end - 1]
	
	#join
	join(sentence, " ")
end

# ╔═╡ 1e469702-9ad0-11ea-0736-0bbc5614f973
generate_sentence(sentence_ngram_frequencies)

# ╔═╡ Cell order:
# ╟─527f2082-9a9e-11ea-3cd5-3bd80dc638b5
# ╠═2b46c964-9a9d-11ea-31c5-b3bc11d9a812
# ╟─9b3fff4c-9a9d-11ea-05ac-97edd38fc6bd
# ╠═31e0eaf8-9ab0-11ea-32ca-ad97647c732b
# ╠═0e8337d2-9ab0-11ea-1116-511676b415d1
# ╟─4d398d30-9ab0-11ea-1f42-6db0845934ed
# ╠═842e1104-9a9d-11ea-007a-1177ccf83a73
# ╠═864effb6-9a9d-11ea-3cf3-09ba9dbc089a
# ╠═d1e7f816-9ab5-11ea-0ce4-31647f30ed99
# ╠═fec2b9f6-9aa7-11ea-0e8d-a9fa88aeac7b
# ╟─fa5c3b26-9aa7-11ea-20f2-c3c415c728c2
# ╟─7fa5f0c6-9ab5-11ea-39aa-519c2e7be2a7
# ╠═c480790a-9ab0-11ea-311c-e386365b05ce
# ╟─6f788f7e-9ab5-11ea-060c-23d87d5eb8a8
# ╟─986abbd8-9ab4-11ea-1a3f-070fc916a94f
# ╠═7d3be7f6-9aaa-11ea-044c-8b46d90f163b
# ╠═de447446-9ab4-11ea-3ff9-f9d5aeca4064
# ╟─570e8b26-9ab5-11ea-1306-659296350ea4
# ╠═e62d5d12-9ab4-11ea-0ae8-418893d47099
# ╠═073b460e-9ab5-11ea-0507-6bf366c6fdf2
# ╠═b7015ae0-9aa8-11ea-341e-19b682aef24e
# ╠═5ca175f0-9a9f-11ea-176c-77c66121bc6a
# ╠═89ca765c-9aa7-11ea-15e2-2518bea008bf
# ╟─8b12a80c-9aa9-11ea-3abf-e5e84bb1fd5f
# ╠═791e6a82-9aa9-11ea-2c87-17884cb3be96
# ╠═0fa61c2e-9aab-11ea-0b8c-8129498a31e3
# ╠═9e67b43c-9ab9-11ea-2798-97c07738921d
# ╠═6ba7b9de-9ab9-11ea-0f15-b1d4ac313677
# ╟─4b510664-9ac7-11ea-2ecd-7d03e3b103c5
# ╠═82c2133a-9aa2-11ea-2af0-6944df8fd507
# ╠═a95f550a-9abb-11ea-1a9e-ab2ff090ec10
# ╠═0d8c7180-9ac3-11ea-0588-d398bd50d367
# ╠═30c4868e-9ac4-11ea-03e5-b177d8aa6103
# ╟─64a917a2-9ac5-11ea-1e37-ab6629ce2f79
# ╟─f30f172e-9ac7-11ea-3e8c-133817a3136e
# ╠═21a58050-9ac8-11ea-3650-6b9cf63b651a
# ╟─329a79f6-9ac8-11ea-1417-1ffa794a9bea
# ╠═9a0b173e-9ac9-11ea-3df4-dddf7b68d851
# ╟─a7cfc162-9ac9-11ea-088d-dfb7312102ad
# ╟─0bb862fa-9acb-11ea-2400-951f7813685c
# ╠═b0f573fc-9acb-11ea-18e9-1bf639a24c85
# ╠═b89e79e6-9acb-11ea-3e53-9100f418384d
# ╠═a96c8e36-9acb-11ea-0f11-8511d28802c2
# ╟─d0c0dcbc-9acb-11ea-0142-b92d971d8689
# ╠═5ca3f06a-9acd-11ea-2046-f78228f33277
# ╠═a2391abc-9acd-11ea-2043-f5bd7c256ee1
# ╠═f234d0f8-9ace-11ea-213f-1d2a09db9ed7
# ╠═404cbd3c-9acf-11ea-353e-67a257df259a
# ╠═1e469702-9ad0-11ea-0736-0bbc5614f973
