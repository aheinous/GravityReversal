extends Node2D

export var lineTexture : Texture = null
export var endCapTexture : Texture = null
export var jointTexture : Texture = null
export var textureFlipDegrees : int = 65
export var textureScale := 1.0


func drawSegment(ctx, start, end, drawStartCap, drawEndCap):
	var rot = end.angle_to_point(start) #+ PI/2

	if rot > deg2rad(textureFlipDegrees) or rot < deg2rad(textureFlipDegrees-180):
		var tmp = end
		end = start
		start = tmp

		tmp = drawEndCap
		drawEndCap = drawStartCap
		drawStartCap = tmp
		rot = end.angle_to_point(start)


	var dist = start.distance_to(end)

#	print('start: %s, end: %s, rot: %s, dist: %s' % [start, end, rad2deg(rot), dist])

	ctx.draw_set_transform(start, rot, Vector2.ONE)

	ctx.draw_texture_rect(
		lineTexture,
		Rect2(
			0,
			-lineTexture.get_height()/2 * textureScale,
			dist,
			lineTexture.get_height() * textureScale
		),
		false)

	if drawStartCap:
		ctx.draw_texture_rect(
			endCapTexture,
			Rect2(
				-endCapTexture.get_width()*textureScale+1,
				-endCapTexture.get_height()*textureScale/2,
				endCapTexture.get_width()*textureScale,
				endCapTexture.get_height()*textureScale
			),
			false)

	if drawEndCap:
		ctx.draw_texture_rect(
			endCapTexture,
			Rect2(
				dist - 1,
				-endCapTexture.get_height()*textureScale/2,
				endCapTexture.get_width()*textureScale,
				endCapTexture.get_height()*textureScale
			),
			false)



func drawJoint(ctx, pos):
	ctx.draw_texture_rect(
		jointTexture,
		Rect2(
			pos - jointTexture.get_size()*textureScale/2,
			jointTexture.get_size()*textureScale
		),
		false
	)


func drawCurve(ctx, curve):
#	print('drawing')
	var pts = curve.tessellate()

	for n in range(pts.size()-1):
		drawSegment(ctx, pts[n], pts[n+1], n==0, n==pts.size()-2)
		ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

	for n in range(1, pts.size()-1):
		drawJoint(ctx, pts[n])

#	ctx.draw_polyline(pts, Color(0,1,1), 1, true)
