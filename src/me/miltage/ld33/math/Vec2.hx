package me.miltage.ld33.math;

class Vec2 {
	
	public var x:Float;
	public var y:Float;

	public function new(x, y){
		this.x = x;
		this.y = y;
		validate();
	}

	public function floor(){
		return new Vec2(Math.floor(x), Math.floor(y));
	}

	public function equals(p:Vec2) {
		return p.x == x && p.y == y;
	}

	public function distSqr(to:Vec2) {
		var xd = x - to.x;
		var yd = y - to.y;
		return xd * xd + yd * yd;
	}

	public function dist(pos:Vec2) {
		return Math.sqrt(distSqr(pos));
	}

	public function clone() {
		return new Vec2(x, y);
	}

	public function add(p:Vec2) {
		return new Vec2(x + p.x, y + p.y);
	}

	public function set(x:Float, y:Float) {
		this.x = x;
		this.y = y;
		validate();
	}

	public function sub(p:Vec2) {
		return new Vec2(x - p.x, y - p.y);
	}

	public function toString() {
		return "[" + x + ", " + y + "]";
	}

	public function dot(v:Vec2) {
		return x * v.x + y * v.y;
	}

	public function addSelfVec2(p:Vec2) {
		x += p.x;
		y += p.y;
		validate();
	}

	public function addSelf(x:Float, y:Float) {
		x += x;
		y += y;
		validate();
	}

	public function copy(pos:Vec2) {
		this.x = pos.x;
		this.y = pos.y;
		validate();
	}

	public function lengthSqr() {
		return x * x + y * y;
	}

	public function length() {
		return Math.sqrt(lengthSqr());
	}

	public function normalizeSelf() {
		var nf = 1 / length();
		x *= nf;
		y *= nf;
		validate();
		return this;
	}

	public function rescaleSelf(newLen:Float) {
		var nf = newLen / length();
		x *= nf;
		y *= nf;
		validate();
		return this;
	}

	public function scale(s:Float) {
		return new Vec2(x * s, y * s);
	}

	public function scaleSelf(s:Float) {
		x *= s;
		y *= s;
		validate();
	}

	public function mul(v:Vec2) {
		return new Vec2(x * v.x, y * v.y);
	}

	public function validate() {
		if (!Math.isFinite(x) || !Math.isFinite(y) || Math.isNaN(x)
				|| Math.isNaN(y)) {
			trace("Gahhh: " + toString());
		}
	}
}