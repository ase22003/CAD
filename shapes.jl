#requires basic.jl

@START_OF_DEBUG_CATEGORY "cad shapes"

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
			cylinder(depth+1, radius),
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

function screw_clamp(length::Real, inner_radius::Real, thickness::Real, hole_radius::Real, hole_chamfer::Real, gap::Real)::String
	difference(
		union(
			tube(length, inner_radius, thickness),
			[
				rotate((0,0,180*side),
					translate((-(thickness*2+gap)/2, inner_radius, 0),
						cube(thickness*2+gap, (thickness*3+hole_radius*2), length)
					)
				)
				for side ∈ (0, 1)
			]...
		),
		translate((-gap/2, -(inner_radius+thickness+(hole_radius*2+thickness*2)+1), -1),
			cube(gap, (inner_radius+thickness+(hole_radius*2+thickness*2)+1)*2, length+2)
		),
		[
		translate(((thickness*2+gap)/2, (inner_radius+thickness*2+hole_radius)*side, length/2),
				rotate((0, 90,0),
					hole(thickness*2+gap+1, hole_radius, hole_chamfer, 1)
				)
			)
			for side ∈ (1, -1)
		]...
	)
end

function screw_clamp(inner_radius::Real, thickness::Real, hole_radius::Real, hole_chamfer::Real, gap::Real)::String
	screw_clamp(hole_radius*2+thickness*2, inner_radius, thickness, hole_radius, hole_chamfer, gap)
end

function tentacle(points#=::Vector{RVect}=#, radius1::Real, radius2::Real, blend::Int=1)::String
	radius = [i*(radius2-radius1)/length(points)+radius1 for i ∈ 0:length(points)]
	union(
		[
			hull(
				[
					translate(points[j],
						sphere(radius[j])
					)
					for j ∈ i:i+blend
				]...
			)
			for i ∈ 1:length(points)-blend
		]...
	)
end

function tentacle(points#=w::Vector{RVect}=#, radius::Real, blend::Real=1)::String
	tentacle(points, radius, radius, blend)
end

@END_OF_DEBUG_CATEGORY
