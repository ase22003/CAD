#requires basic.jl

function tube(length::Real, inner_radius::Real, thickness::Real)::String
	difference(
		cylinder(length, inner_radius+thickness),
		translate((0,0,-1),
			cylinder(length+2, inner_radius)
		)
	)
end

function hole(depth::Real, radius::Real, chamfer::Real, upper_margin::Real=5)::String
	translate((0, 0, -depth),
		union(
			cylinder(depth, radius),
			translate((0, 0, depth-chamfer),
				cylinder(chamfer+upper_margin, radius, chamfer+radius+upper_margin)
			)
		)
	)
end

function holed_tube(length::Real, inner_radius::Real, thickness::Real, hole_radius::Real, hole_chamfer::Real, number_of_holes::Real)::String
	difference(
		tube(length, inner_radius, thickness),
		[
			rotate((0, -90, i*(360/number_of_holes)),
				translate((length/2, 0, inner_radius+thickness),
					hole(inner_radius*2, hole_radius, hole_chamfer)
				)
			)
			for i ∈ 0:number_of_holes
		]...
	)
end
