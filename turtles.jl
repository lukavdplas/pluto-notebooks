### A Pluto.jl notebook ###
# v0.9.9

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ 70160fec-b0c7-11ea-0c2a-35418346592e
@bind angle HTML("<input type='range' min='0' step='$(pi/100)' max='$(pi/2)'>")

# ╔═╡ 5f117a7a-b3dc-11ea-29d3-6b094f1a2a29
@bind star_size HTML("<input type='range' min='0' step='1' max='100'>")

# ╔═╡ 8c88639c-b3dc-11ea-2711-135dad6f2f11
@bind star_points HTML("<input type='range' min='1' step='1' max='20'>")

# ╔═╡ b3f5877c-b3e9-11ea-03fe-3f3233ee2e1b
@bind GO_mondriaan html"<button>GO!!</button>"

# ╔═╡ 4c1bcc58-b3ec-11ea-32d1-7f4cd113e43d
@bind fractal_angle HTML("<input type='range' min='0' step='0.01' max='0.5'>")

# ╔═╡ a7e725d8-b3ee-11ea-0b84-8d252979e4ef
@bind fractal_tilt HTML("<input type='range' min='0' step='0.01' max='0.5'>")

# ╔═╡ 49ce3f9c-b3ee-11ea-0bb5-ed348475ea0b
@bind fractal_base HTML("<input type='range' min='0' step='0.01' max='1'>")

# ╔═╡ 146cdee0-b3ed-11ea-23c6-13bbfae43018


# ╔═╡ ab083f08-b0c0-11ea-0c23-315c14607f1f
md"# 🐢 definition"

# ╔═╡ 310a0c52-b0bf-11ea-3e32-69d685f2f45e
Drawing = Vector{String}

# ╔═╡ 6bbb674c-b0ba-11ea-2ff7-ebcde6573d5b
mutable struct Turtle
	pos::Tuple{Number, Number}
	heading::Number
	pen_down::Bool
	color::String
	history::Drawing
end

# ╔═╡ 5560ed36-b0c0-11ea-0104-49c31d171422
md"## Turtle commands"

# ╔═╡ e6c7e5be-b0bf-11ea-1f7e-73b9aae14382
function forward!(🐢::Turtle, distance::Number)
	old_pos = 🐢.pos
	new_pos = 🐢.pos = old_pos .+ (distance .* (cos(🐢.heading), sin(🐢.heading)))
	if 🐢.pen_down
		push!(🐢.history, """<line x1="$(old_pos[1])" y1="$(old_pos[2])" x2="$(new_pos[1])" y2="$(new_pos[2])" stroke="$(🐢.color)" stroke-width="4" />""")
	end
	🐢
end

# ╔═╡ 573c11b4-b0be-11ea-0416-31de4e217320
backward!(🐢::Turtle, by::Number) = forward!(🐢, -by)

# ╔═╡ fc44503a-b0bf-11ea-0f28-510784847241
function right!(🐢::Turtle, angle::Number)
	🐢.heading += angle
end

# ╔═╡ d88440c2-b3dc-11ea-1944-0ba4a566d7c1
function draw_star(turtle, points, size)
	for i in 1:points
		right!(turtle, 2*pi / points)
		forward!(turtle, size)
		backward!(turtle, size)
	end
end

# ╔═╡ 47907302-b0c0-11ea-0b27-b5cd2b4720d8
left!(🐢::Turtle, angle::Number) = right!(🐢, -angle)

# ╔═╡ 1fb880a8-b3de-11ea-3181-478755ad354e
function penup!(🐢::Turtle)
	🐢.pen_down = false
end

# ╔═╡ 4c173318-b3de-11ea-2d4c-49dab9fa3877
function pendown!(🐢::Turtle)
	🐢.pen_down = true
end

# ╔═╡ 2e7c8462-b3e2-11ea-1e41-a7085e012bb2
function color!(🐢::Turtle, color::AbstractString)
	🐢.color = color
end

# ╔═╡ 678850cc-b3e4-11ea-3cf0-a3445a3ac15a
function draw_mondriaan(turtle, width, height)
	#propbability that we make a mondriaan split
	p = if width * height < 800
		0
	else
		((width * height) / 90000) ^ 0.5
	end
		
	if rand() < p
		#split into halves
		
		split = rand(width * 0.1 : width * 0.9)

		#draw split
		forward!(turtle, split)
		right!(turtle, pi / 2)
		color!(turtle, "black")
		pendown!(turtle)
		forward!(turtle, height)
		penup!(turtle)

		#fill in left of split
		right!(turtle, pi / 2)
		forward!(turtle, split)
		right!(turtle, pi / 2)
		draw_mondriaan(turtle, height, split)
		
		#fill in right of split
		forward!(turtle, height)
		right!(turtle, pi / 2)
		forward!(turtle, width)
		right!(turtle, pi /2)
		draw_mondriaan(turtle, height, width - split)
		
		#walk back
		right!(turtle, pi / 2)
		forward!(turtle, width)
		right!(turtle, pi)
		
	else
		#draw a colored square
		square_color = rand(["white", "white", "white", "red", "yellow", "blue"])
		color!(turtle, square_color)
		for x in (4:4:width - 4) ∪ [width - 4]
			forward!(turtle, x)
			right!(turtle, pi / 2)
			forward!(turtle, 2)
			pendown!(turtle)
			forward!(turtle, height - 4)
			penup!(turtle)
			right!(turtle, pi)
			forward!(turtle, height - 2)
			right!(turtle, pi / 2)
			backward!(turtle, x)
		end
	end
end

# ╔═╡ d1ae2696-b3eb-11ea-2fcc-07b842217994
function lindenmayer(turtle, depth, angle, tilt, base)
	if depth < 10
		old_pos = turtle.pos
		old_heading = turtle.heading

		size = base ^ (depth * 0.5)

		pendown!(turtle)
		color!(turtle, "hsl($(depth * 30), 80%, 50%)")
		forward!(turtle, size * 80)
		right!(turtle, tilt * pi / 2)
		lindenmayer(turtle, depth + 1, angle, tilt, base)
		left!(turtle, angle * pi)
		lindenmayer(turtle, depth + 1, angle, tilt, base)


		turtle.pos = old_pos
		turtle.heading = old_heading
	end
end

# ╔═╡ 5aea06d4-b0c0-11ea-19f5-054b02e17675
md"## Function to make turtle drawings with"

# ╔═╡ 6dbce38e-b0bc-11ea-1126-a13e0d575339
function turtle_drawing(f::Function; background="white")
	🐢 = Turtle((150, 150), pi*3/2, true, "black", String[])
	
	f(🐢)
	
	image = """<svg version="1.1"
     baseProfile="full"
     width="300" height="300"
	 style="background-color:$(background);"
     xmlns="http://www.w3.org/2000/svg">
	""" * join(🐢.history) * "</svg>"
	return HTML(image)
end

# ╔═╡ d30c8f2a-b0bf-11ea-0557-19bb61118644
turtle_drawing() do t
	
	for i in 1:100
		right!(t, angle)
		forward!(t, i)
	end
	
end

# ╔═╡ 9dc072fe-b3db-11ea-1568-857a664ce4d2
starry_night = turtle_drawing(background = "#000088") do t
	star_count = 100
	
	color!(t, "yellow")
	
	for i in 1:star_count
		#move
		penup!(t)
		random_angle = rand() * pi * 2
		right!(t, random_angle)
		random_distance = rand(10:80)
		forward!(t, random_distance)
		
		#draw star
		pendown!(t)
		
		draw_star(t, 5, 10)
	end
end

# ╔═╡ e04a9296-b3e3-11ea-01b5-8ff7dc0ced56
mondriaan = turtle_drawing() do t	
	GO_mondriaan
	size = 300
	
	#go to top left corner
	penup!(t)
	forward!(t, size / 2)
	left!(t, pi / 2)
	forward!(t, size / 2)
	right!(t, pi)
		
	#draw painting
	draw_mondriaan(t, size, size)
	
	#white border around painting
	color!(t, "white")
	pendown!(t)
	for i in 1:4
		forward!(t, size)
		right!(t, pi /2)
	end
end

# ╔═╡ 60b52a52-b3eb-11ea-2e3c-9d185f4fbc2b
fractal = turtle_drawing() do t
	penup!(t)
	backward!(t, 150)
	pendown!(t)
	lindenmayer(t, 0, fractal_angle, fractal_tilt, fractal_base)
end

# ╔═╡ Cell order:
# ╠═70160fec-b0c7-11ea-0c2a-35418346592e
# ╠═d30c8f2a-b0bf-11ea-0557-19bb61118644
# ╠═5f117a7a-b3dc-11ea-29d3-6b094f1a2a29
# ╠═8c88639c-b3dc-11ea-2711-135dad6f2f11
# ╠═d88440c2-b3dc-11ea-1944-0ba4a566d7c1
# ╠═9dc072fe-b3db-11ea-1568-857a664ce4d2
# ╠═678850cc-b3e4-11ea-3cf0-a3445a3ac15a
# ╟─b3f5877c-b3e9-11ea-03fe-3f3233ee2e1b
# ╠═e04a9296-b3e3-11ea-01b5-8ff7dc0ced56
# ╠═4c1bcc58-b3ec-11ea-32d1-7f4cd113e43d
# ╠═a7e725d8-b3ee-11ea-0b84-8d252979e4ef
# ╠═49ce3f9c-b3ee-11ea-0bb5-ed348475ea0b
# ╠═60b52a52-b3eb-11ea-2e3c-9d185f4fbc2b
# ╠═d1ae2696-b3eb-11ea-2fcc-07b842217994
# ╠═146cdee0-b3ed-11ea-23c6-13bbfae43018
# ╟─ab083f08-b0c0-11ea-0c23-315c14607f1f
# ╠═6bbb674c-b0ba-11ea-2ff7-ebcde6573d5b
# ╠═310a0c52-b0bf-11ea-3e32-69d685f2f45e
# ╟─5560ed36-b0c0-11ea-0104-49c31d171422
# ╠═e6c7e5be-b0bf-11ea-1f7e-73b9aae14382
# ╠═573c11b4-b0be-11ea-0416-31de4e217320
# ╠═fc44503a-b0bf-11ea-0f28-510784847241
# ╠═47907302-b0c0-11ea-0b27-b5cd2b4720d8
# ╠═1fb880a8-b3de-11ea-3181-478755ad354e
# ╠═4c173318-b3de-11ea-2d4c-49dab9fa3877
# ╠═2e7c8462-b3e2-11ea-1e41-a7085e012bb2
# ╟─5aea06d4-b0c0-11ea-19f5-054b02e17675
# ╠═6dbce38e-b0bc-11ea-1126-a13e0d575339
