### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 27456042-f00a-11ec-3ffc-0b298d4b25ea
using Random, PlutoUI;

# ╔═╡ 469032ca-003f-4e82-b03a-b4401f79e971
md"""
# Replacement ciphers (part 2)

This notebook is about _replacement ciphers_: a type of code where you replace each character in your message with another, like replacing every _A_ with an _F_, every _B_ with a _Q_, et cetera.

In part 1 of this notebook, we introduced replacement ciphers and considered what it takes to find the key for an encoded message. We did this by looking at a simpler version of the problem, namely ceasar ciphers.

In this notebook, we will write a program designed to solve replacement ciphers. The notebook is less linear than part 1: we will set up a basic algorithm, and then you are invited to try and improve it.

Let's get into it!
"""

# ╔═╡ 5d1bbe9a-1ad0-4e4e-9cec-8bda66ecb342
md"""
## Defining ciphers

First, we need some definitions of our alphabet, and what it means to encrypt or decrypt a message. These definitions come from part 1 of the notebook, so I won't explain them here.

(If you skipped ahead to part 2, I encourage you to try out the functions defined here, and make sure you understand what they do.)
"""

# ╔═╡ 39a88179-e01b-4fec-821c-99714bac2fcf
alphabet = collect('A':'Z')

# ╔═╡ d6a05df7-2243-4d62-b0ef-182df747de74
function randomkey()
	# shuffle alphabet to get replacements for each character
	replacements = shuffle(alphabet)

	# combine alphabet and replacements
	(collect ∘ zip)(alphabet, replacements)
end

# ╔═╡ fb170781-e2ae-49d5-a65b-ab56b4fd42f8
function prepare(message)
	uppercase(message)
end

# ╔═╡ 803b6284-e969-4c97-8ac1-c416db4361b0
function encrypt(message, key)
	# make a dictionary from the key for easy retrieval
	replacement_dict = Dict(key)

	# prepare the message and make an array of characters
	characters = (collect ∘ prepare)(message)

	# replace each character
	newcharacters = map(characters) do character
		if character in alphabet
			# replace using the key
			replacement_dict[character]
		else
			# for characters not in the alphabet, return them unchanged
			character
		end
	end

	# convert the replaced characters into a string
	String(newcharacters)
end

# ╔═╡ 70d67bad-3e57-4b49-a204-70c265a14afe
function decrypt(message, key)
	reverse_key = map(key) do (character, replacement)
		(replacement, character)
	end

	encrypt(message, reverse_key)
end

# ╔═╡ ce0ba751-c2d0-4e06-aeb4-2c68c5006766
md"""
## Our first metric: character frequencies

In part 1, we found that we could comparing character frequencies between a possible solution and a reference text was a pretty reliable way to find the right solution.

Sadly, this will not be sufficient for replacement ciphers, but it's a start. We'll include it here.

(The code below is slightly adapted from part 1, mostly to streamline it a bit, since we won't be going over the reasoning steps.)
"""

# ╔═╡ 7b6d08fb-1ba9-45f0-bb5e-45e52fb8c7c6
function countcharacters(message)
	# prepare the message and make an array of characters
	characters = (collect ∘ prepare)(message)
	
	# for each character in the alphabet, see how often it occurred
	counts = map(alphabet) do character
		count(characters) do char
			char == character
		end
	end
end

# ╔═╡ 3e1fdfeb-caa2-43c0-a614-c9cc53e1afd5
reference_text = """
To be, or not to be, that is the question: Whether ’tis nobler
in the mind to suffer The slings and arrows of outrageous fortune, Or
to take arms against a sea of troubles, And by opposing end them? To
die—to sleep, No more; and by a sleep to say we end The heart-ache, and
the thousand natural shocks That flesh is heir to: ’tis a consummation
Devoutly to be wish’d. To die, to sleep. To sleep, perchance to
dream—ay, there’s the rub, For in that sleep of death what dreams may
come, When we have shuffled off this mortal coil, Must give us pause.
There’s the respect That makes calamity of so long life. For who would
bear the whips and scorns of time, The oppressor’s wrong, the proud
man’s contumely, The pangs of dispriz’d love, the law’s delay, The
insolence of office, and the spurns That patient merit of the unworthy
takes, When he himself might his quietus make With a bare bodkin? Who
would these fardels bear, To grunt and sweat under a weary life, But
that the dread of something after death, The undiscover’d country, from
whose bourn No traveller returns, puzzles the will, And makes us rather
bear those ills we have Than fly to others that we know not of? Thus
conscience does make cowards of us all, And thus the native hue of
resolution Is sicklied o’er with the pale cast of thought, And
enterprises of great pith and moment, With this regard their currents
turn awry And lose the name of action. Soft you now, The fair Ophelia!
Nymph, in thy orisons Be all my sins remember’d.
"""

# ╔═╡ fcf42a7f-f42b-483f-9513-4d910a25f1ad
reference_character_counts = countcharacters(reference_text)

# ╔═╡ 10abadb0-3f7f-41c6-b565-bda55040ae0b
function compare_frequencies(message_1, message_2)
	# calculate relative frequencies
	frequencies_1 = countcharacters(message_1)
	frequencies_2 = countcharacters(message_2)

	# calculate the difference for each character
	differences = map(zip(percentages_1, percentages_2)) do (p1, p2)
		abs(p1 - p2)
	end

	# take the sum
	sum(differences)
end

# ╔═╡ cc408079-7196-4dad-9430-d3afc0d8350e
function evaluate_character_frequency(message)
	frequencies = countcharacters(message)

	differences = map(zip(frequencies, reference_character_counts)) do (f1, f2)
		abs(f1 - f2)
	end

	norm = sum(frequencies) + sum(reference_character_counts)

	sum(differences) / norm
end

# ╔═╡ d2955303-4f76-47c3-863a-c7fb9428ed49
md"""
The `evaluate_character_frequency` will tell us how much a message looks like our reference text in term of frequencies. That tells us something about how much that message looks like real English.

The function is designed so that a perfect match will give a score of `0`:
"""

# ╔═╡ 44082c03-e569-4427-8c22-482ad172d381
evaluate_character_frequency(reference_text)

# ╔═╡ 8e58c2ee-7ee0-43d5-af94-fba5ae6520f3
md"""
The worst score is when a text has no overlap at all with the reference text. In this case, the letter "x" never occured in our reference, so it is completely different. This will give us a score of `1`.

(The evaluation function in part 1 did not scale like that, but it will be useful to us here.)
"""

# ╔═╡ 945d8e42-e4e0-432f-a3f7-3f821f8be0ff
evaluate_character_frequency("x")

# ╔═╡ 50500b70-925a-4bd0-9c46-40dfb9a02df6
md"""
## Finding the optimal key

Now, we have at least one way to judge how much a solution looks like real English. That is enough is enough to start building our code for finding the key to an encrypted message.

This is a process of _optimisation_, where we start with a random key and keep tweaking it until we have something we are satisfied with.

We will use some _metrics_ to measure our satisfaction: for now, we use a single metric: our character frequency function. We will add more later. 

During the optimisation process, we will keep making small changes to our key and see how that affects the metrics. If the scores improve, we're hopefully a little bit closer to the real key!

The specific algorithm we will be using is called _simulated annealing_.
"""

# ╔═╡ 51433a39-3f2d-45a5-9640-d9a9e416c146
md"""
### Our metrics

Let's define how we evaluate our solutions. As mentioned, we have only one metric for now.
"""

# ╔═╡ 2ede1c25-509f-4c0e-9b76-091cc2bb4680
metrics = [evaluate_character_frequency]

# ╔═╡ e1a12bcf-a8e4-443b-ad0f-880661dff570
md"""
👉 In later parts of the notebook, we will be writing new metrics. When you have completed a metric, add it to the list here!
"""

# ╔═╡ 28b9b60e-2db6-4da8-a667-af0ccba358bf
md"""
### Scoring solutions

To evaluate a key for an encrypted message, we apply the key and then just take the sum of all the metrics:
"""

# ╔═╡ e8e7d80c-ac84-428d-9e7c-d9983689b04c
function evaluate(message, key)
	decrypted = decrypt(message, key)

	scores = map(metrics) do metric
		metric(decrypted)
	end

	sum(scores)
end

# ╔═╡ 97b250e3-33be-42c0-ba67-8bdc1ef47752
md"""
### Tweaking solutions

During each step of our optimisation, we will take our current best guess for the key, change it a bit, and see if we like the new version better.

To do this, we need a function that will make a small, random change to a replacement key.

In particular, we want to swap out to replacements for each other. For instance, our current key might replace _F_ with _J_ and _O_ with _G_, and our new key will replace _F_ with _G_ and _O_ with _J_.
"""

# ╔═╡ b212474c-8582-4a8f-a9a9-bafbedc7ba41
function tweak(key)
	pair1, pair2 = rand(key, 2)

	replace(key,
		pair1 => (pair1[1], pair2[2]),
		pair2 => (pair2[1], pair1[2])
	)
end

# ╔═╡ 546788d7-7673-4d17-a762-b93eb9a3f310
md"""
### Updating solutions

During each step of our optimisation process, we will have an encryption key that is currently our best guess, and a new key that we are considering.

If we like the new key, we can say that the new key is now our best guess. If we don't like it, we kan keep the old key as our best guess and forget about the new one. Then we move into the next step with whatever key we picked as our current best guess.

So, how do we know whether to accept or reject the new key? Well, we have our evaluation score, so we could say that we pick whichever key gets the best score.

This turns out to be a bit too rigid in cases like these. 
"""

# ╔═╡ 8bd275d4-66cf-4249-ad07-3c78a06b8f71
function random_chance(p)
	return rand() <= p
end

# ╔═╡ d37532d5-1be3-4a40-b4fe-55bd4c7624b6
function new_current_best(current_key, new_key, message, p = 0.1)
	current_score = evaluate(message, current_key)
	new_score = evaluate(message, new_key)

	if new_score > current_score
		new_score
	else
		if random_chance(p)
			new_score
		else
			current_score
		end
	end
end

# ╔═╡ bbe6f00a-d886-449f-b99f-e7e3fd7ca4f0
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));

# ╔═╡ 2032e61f-1dce-4ba6-8612-23b08a9b321f
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));

# ╔═╡ d4ed285b-fd02-4b5c-8def-d38db8a090d0
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));

# ╔═╡ 9b6d554a-2097-4687-9dc9-3812538adcb1
correct(text=md"Great! You got the right answer! Let's move on to the next section.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─469032ca-003f-4e82-b03a-b4401f79e971
# ╟─5d1bbe9a-1ad0-4e4e-9cec-8bda66ecb342
# ╠═39a88179-e01b-4fec-821c-99714bac2fcf
# ╠═d6a05df7-2243-4d62-b0ef-182df747de74
# ╠═fb170781-e2ae-49d5-a65b-ab56b4fd42f8
# ╠═803b6284-e969-4c97-8ac1-c416db4361b0
# ╠═70d67bad-3e57-4b49-a204-70c265a14afe
# ╟─ce0ba751-c2d0-4e06-aeb4-2c68c5006766
# ╠═7b6d08fb-1ba9-45f0-bb5e-45e52fb8c7c6
# ╠═3e1fdfeb-caa2-43c0-a614-c9cc53e1afd5
# ╠═fcf42a7f-f42b-483f-9513-4d910a25f1ad
# ╠═10abadb0-3f7f-41c6-b565-bda55040ae0b
# ╠═cc408079-7196-4dad-9430-d3afc0d8350e
# ╟─d2955303-4f76-47c3-863a-c7fb9428ed49
# ╠═44082c03-e569-4427-8c22-482ad172d381
# ╟─8e58c2ee-7ee0-43d5-af94-fba5ae6520f3
# ╠═945d8e42-e4e0-432f-a3f7-3f821f8be0ff
# ╟─50500b70-925a-4bd0-9c46-40dfb9a02df6
# ╟─51433a39-3f2d-45a5-9640-d9a9e416c146
# ╠═2ede1c25-509f-4c0e-9b76-091cc2bb4680
# ╟─e1a12bcf-a8e4-443b-ad0f-880661dff570
# ╟─28b9b60e-2db6-4da8-a667-af0ccba358bf
# ╠═e8e7d80c-ac84-428d-9e7c-d9983689b04c
# ╟─97b250e3-33be-42c0-ba67-8bdc1ef47752
# ╠═b212474c-8582-4a8f-a9a9-bafbedc7ba41
# ╟─546788d7-7673-4d17-a762-b93eb9a3f310
# ╠═8bd275d4-66cf-4249-ad07-3c78a06b8f71
# ╠═d37532d5-1be3-4a40-b4fe-55bd4c7624b6
# ╟─27456042-f00a-11ec-3ffc-0b298d4b25ea
# ╟─bbe6f00a-d886-449f-b99f-e7e3fd7ca4f0
# ╟─2032e61f-1dce-4ba6-8612-23b08a9b321f
# ╟─d4ed285b-fd02-4b5c-8def-d38db8a090d0
# ╟─9b6d554a-2097-4687-9dc9-3812538adcb1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
