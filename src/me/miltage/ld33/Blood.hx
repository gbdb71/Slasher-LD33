package me.miltage.ld33;

import me.miltage.ld33.math.Vec2;

class Blood extends Entity {

	public var vx:Float;
	public var vy:Float;

	public var fz:Float;

	public var remove:Bool;

	public function new(x, y, vx){
		super(null, x, y, 0, 0);
		fz = -16;
		pos = new Vec2(x, y);
		this.graphics.beginFill(0xcc0000);
		this.graphics.drawCircle(0, 0, 1);
		vy = 0.35;
		this.vx = vx;
		remove = false;
		register = -800;
	}
	
	override public function update(){
		x = pos.x;
		y = pos.y + fz;

		vy *= 1.05;

		fz += vy;
		pos.x += vx;

		if(fz >= 0){
			remove = true;
		}
	}
}