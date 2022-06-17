### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 1f522768-ff6f-4f27-8f16-75bf5b5e6f9e
using Random

# ╔═╡ 0fa3c6d0-ee3d-11ec-0bb4-a944807ba0ed
md"""
# Replacement ciphers
""" 

# ╔═╡ 6917f83f-a6aa-4cbc-89da-ba0f448acaa0
md"""
## Defining ciphers

### The alphabet

First, we need to define our alphabet. This is the collection of characters that we we are going to be replacing.

The characters A-Z will be sufficient:
"""

# ╔═╡ ee221dd4-d072-4679-992f-0d3657e90cd4
alphabet = collect('A':'Z')

# ╔═╡ ed619597-5d98-49a0-b015-7d832366ef9c
md"""
Note that we are not including whitespace (space, newlines) or interpunction characters (`.`, `,`, and so on). Our encryption will leave those characters as they are.
"""

# ╔═╡ c427fa89-4e71-4afa-8358-64df1f2c737f
md"""
### Encryption keys

A one-to-one replacement cipher will replace each character in the alphabet with another. We need a _key_ to tell us which character to replace with which.

Here is a function that will make a random key.
"""

# ╔═╡ cb1e5f06-39a5-4b60-9e69-53772de4e8ce
function randomkey()
	# shuffle alphabet to get replacements for each character
	replacements = shuffle(alphabet)

	# combine alphabet and replacements
	(collect ∘ zip)(alphabet, replacements)
end

# ╔═╡ c16adf04-a392-4f41-851b-3204e96c1c46
md"""
If this function seems abstract to you, don't worry about it. Here is what our key will look like:
"""

# ╔═╡ 7ef58fdd-6853-4486-9d1d-cc8c590c2ed7
example_key = randomkey()

# ╔═╡ 669bb484-a594-4412-a96d-8a3414c0c204
let
	firstpair = first(example_key)
	firstchar = string(firstpair[1])
	secondchar = string(firstpair[2])
	
	md"""
	This gives our a list of replacements. For example, every _$firstchar_ should be replaced with a _$secondchar_.
	
	If you know the key, encrypting and decrypting messages is pretty straightforward. Trying to decrypt a message without the key is a puzzle.
	"""
end

# ╔═╡ 28378ac9-fd4a-4fe4-9a5f-1d9444427a60
md"""
### Encryption

Let's try using that key. But before we can start replacing, there is one thing we need to do. You may have noticed that our alphabet only uses uppercase characters. If we want to use the key on a message, we need to use _uppercase_ characters only.
"""

# ╔═╡ 806509f4-9bab-4bf0-a8c5-40900f337f11
function prepare(message)
	uppercase(message)
end

# ╔═╡ 5b2fef01-5a47-4f8a-bcd0-6cd75c1d0c82
md"""
For example:
"""

# ╔═╡ ccb8ccbd-37a4-4bde-8d3f-38ef76ea61a3
example_message = "To be or not to be, that is the question."

# ╔═╡ af8bf867-09c2-4ac5-910f-9de5ae5a616a
prepare(example_message)

# ╔═╡ 47851e6c-ed25-4ad4-bd5c-c1f622a8ac51
md"""
For real secret communication, you might consider doing more in this preparation, such as obscuring the interpunction a bit. But we'll leave it at this for now.

Now, let's encrypt that message. Here is a function that will apply a replacement cipher for a message and a key.
"""

# ╔═╡ a868d8db-fdab-4941-b733-ef5435ba5659
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

# ╔═╡ c2a77d46-2d79-4993-96e4-a7d4a8ee5e6e
md"""
Let's try it out!
"""

# ╔═╡ 64bef739-2aca-4423-92d9-93f0cc6bef59
example_encrypted = encrypt(example_message, example_key)

# ╔═╡ 12842e4f-420c-4531-8ab5-9353149d1c18
md"""
### Decryption

Now that we have encrypted our message, we can safely send it to all our friends. If they know the key, they can *decrypt* the message.

For one-to-one replacement cipers, decryption is just like encryption. We just need to apply encryption in reverse.
"""

# ╔═╡ 9f91b4e9-df13-4bbc-b2ee-3faf0a5e012c
function decrypt(message, key)
	reverse_key = map(key) do (character, replacement)
		(replacement, character)
	end

	encrypt(message, reverse_key)
end

# ╔═╡ a3a4d43f-3b53-4d85-9721-923f2a62e9a1
md"""
Let's see it:
"""

# ╔═╡ 46dab0d5-f6dc-44b2-b30c-be534e1d04c3
decrypt(example_encrypted, example_key)

# ╔═╡ b5023561-26bc-486e-99d8-cdce6cb76a2a
md"""
## Ceasar ciphers

It's easy to decrypt a message when you know the key, but the real fun is in cracking a cipher and decrypting a message where you _don't_ know the key. And by fun, I mean that it's difficult.

We'll start with a simpler version of the puzzle, the _ceasar cipher_. Ceasar ciphers (also known as shift ciphers) are a kind of replacement cipher where the replacement for each character always has the same distance in the alphabet. For example, _A_ is replaced by _D_, then _B_ is replaced by _E_, _C_ by _F_, and so forth.

Ceasar ciphers are easier to crack because they only have 26 possible keys (in a 26-character alphabet). 
"""

# ╔═╡ 7bbc4b4d-fbff-4897-b657-befe2268adbd
md""" 
### Defining the ceasar cipher
"""

# ╔═╡ e7c4ffc0-e494-4cf0-895d-110cb7b50357
function shift_cipher(shift)
	sliceindex = mod(shift, eachindex(alphabet))

	replacements = [alphabet[sliceindex+1:end] ; alphabet[1:sliceindex]]
	(collect ∘ zip)(alphabet, replacements)
end

# ╔═╡ 767996b1-40bf-49ba-9523-3d3111c33566
shift_cipher(3)

# ╔═╡ 4e44f92f-0de9-495d-9165-376717a1df2a
function ceasar_encrypt(message, shift)
	key = shift_cipher(shift)
	encrypt(message, key)
end

# ╔═╡ 108ad7d2-8a5b-462f-9a0d-6f3302c73a9a
ceasar_encrypt(example_message, 3)

# ╔═╡ a2c829c8-17a9-4489-96da-14975f3560b2
function ceasar_decrypt(message, shift)
	ceasar_encrypt(message, -shift)
end

# ╔═╡ c746e0c8-7246-4d48-bcc0-53d75f4fcaaa
let
	shift = 3
	encrypted = ceasar_encrypt(example_message, shift)
	decrypted = ceasar_decrypt(encrypted, shift)
end

# ╔═╡ e75bed2d-6b28-4f07-955c-e9d52d2d0884
md"""
### A first attempt at cracking the cipher

So, how will we crack the cipher? Well, since there are only 26 possibilities, you could just check every single one. Let's try that. Here is a secret message:
"""

# ╔═╡ 15960689-5dd0-44e6-98ea-82612866d1e7
example_ceasar_encrypted = "U LIMY VS UHS INBYL HUGY QIOFX MGYFF UM MQYYN"

# ╔═╡ 361d9b88-e693-4654-9582-ab227dd21025
md"""
This was encrypted using a ceasar cipher, but we don't know the key! We can try all possible keys, and see if one of them makes sense.

**👉 your turn!** Write some code that will generate all possible solutions for the `example_ceasar_encrypted` message.
"""

# ╔═╡ 25372462-b52a-4ba5-b59d-df591ea35f98
# your code here...

# ╔═╡ 81aba30e-4c6e-4d6a-a165-3d9313f108df
md"""
What is the shift key that was used to encrypt the message?
"""

# ╔═╡ c428660d-3ab9-4624-8a14-7044581e6b98
example_ceasar_encrypted_key = missing # fill in your solution here

# ╔═╡ b1557342-b352-4ed0-8b3b-15d466cbef24
if ismissing(example_ceasar_encrypted_key)
	md"Keep trying!"
elseif example_ceasar_encrypted_key == 20
	md"Yay!"
elseif example_ceasar_encrypted_key == 6
	md"Almost there! You may have confused _encrypt_ and _decrypt_ in your solution. Remember, the key used to _encrypt_ a message can be given to the _decrypt_ function to get the original message back."
else
	md"Oh no, that's not right!"
end

# ╔═╡ a8871358-7e16-41e1-a8a9-99bf46a3aab7
md"""
This list of solutions only has 26 options, but with a "normal" replacement cipher, there are way too many options to go over them by hand like this.

Instead of letting the computer generate solutions and picking the right one by hand, we should let the computer find the best solution.

To do that, the computer will need some way of knowing what English text looks like. That is how you were able to pick out the right message, after all: you didn't know what it was going to say, but you can recognise English text when you see it.
"""

# ╔═╡ 7cc9612a-bbac-4cad-bc5f-3c2bdc71ee90
md"""
### What does English text look like?

There are lots of properties that distinguish real English text from random gibberish. Some of them are more useful than others.

Let's start by thinking about how you are able to recognise a solution as real text. A big part of that is that you will recognise the words.

Sadly, recognising words is a good strategy for _verifying_ a solution, but not for _finding_ one. If we are even a little bit off from the real solution, we won't recognise the words. With this method, it is very difficult to tell if we are getting close at all. Often, the only way to tell which solution is the right one is to consider every single one.

Instead, we will start by using a very different kind of knowledge: the frequency of different characters. Some characters, like 'E', are very frequent in English text, while others, like 'X', are not frequent at all.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
"""

# ╔═╡ Cell order:
# ╟─0fa3c6d0-ee3d-11ec-0bb4-a944807ba0ed
# ╟─6917f83f-a6aa-4cbc-89da-ba0f448acaa0
# ╠═ee221dd4-d072-4679-992f-0d3657e90cd4
# ╟─ed619597-5d98-49a0-b015-7d832366ef9c
# ╟─c427fa89-4e71-4afa-8358-64df1f2c737f
# ╠═cb1e5f06-39a5-4b60-9e69-53772de4e8ce
# ╟─c16adf04-a392-4f41-851b-3204e96c1c46
# ╠═7ef58fdd-6853-4486-9d1d-cc8c590c2ed7
# ╟─669bb484-a594-4412-a96d-8a3414c0c204
# ╟─28378ac9-fd4a-4fe4-9a5f-1d9444427a60
# ╠═806509f4-9bab-4bf0-a8c5-40900f337f11
# ╟─5b2fef01-5a47-4f8a-bcd0-6cd75c1d0c82
# ╠═ccb8ccbd-37a4-4bde-8d3f-38ef76ea61a3
# ╠═af8bf867-09c2-4ac5-910f-9de5ae5a616a
# ╟─47851e6c-ed25-4ad4-bd5c-c1f622a8ac51
# ╠═a868d8db-fdab-4941-b733-ef5435ba5659
# ╟─c2a77d46-2d79-4993-96e4-a7d4a8ee5e6e
# ╠═64bef739-2aca-4423-92d9-93f0cc6bef59
# ╟─12842e4f-420c-4531-8ab5-9353149d1c18
# ╠═9f91b4e9-df13-4bbc-b2ee-3faf0a5e012c
# ╟─a3a4d43f-3b53-4d85-9721-923f2a62e9a1
# ╠═46dab0d5-f6dc-44b2-b30c-be534e1d04c3
# ╟─b5023561-26bc-486e-99d8-cdce6cb76a2a
# ╟─7bbc4b4d-fbff-4897-b657-befe2268adbd
# ╠═e7c4ffc0-e494-4cf0-895d-110cb7b50357
# ╠═767996b1-40bf-49ba-9523-3d3111c33566
# ╠═4e44f92f-0de9-495d-9165-376717a1df2a
# ╠═108ad7d2-8a5b-462f-9a0d-6f3302c73a9a
# ╠═a2c829c8-17a9-4489-96da-14975f3560b2
# ╠═c746e0c8-7246-4d48-bcc0-53d75f4fcaaa
# ╟─e75bed2d-6b28-4f07-955c-e9d52d2d0884
# ╠═15960689-5dd0-44e6-98ea-82612866d1e7
# ╟─361d9b88-e693-4654-9582-ab227dd21025
# ╠═25372462-b52a-4ba5-b59d-df591ea35f98
# ╟─81aba30e-4c6e-4d6a-a165-3d9313f108df
# ╠═c428660d-3ab9-4624-8a14-7044581e6b98
# ╟─b1557342-b352-4ed0-8b3b-15d466cbef24
# ╟─a8871358-7e16-41e1-a8a9-99bf46a3aab7
# ╟─7cc9612a-bbac-4cad-bc5f-3c2bdc71ee90
# ╠═1f522768-ff6f-4f27-8f16-75bf5b5e6f9e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
