package me.miltage.ld33;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import me.miltage.ld33.math.Vec2;
import me.miltage.ld33.math.BBOwner;
import me.miltage.ld33.math.BB;

class Entity extends Sprite implements BBOwner {
	
	public var w:Int;
	public var h:Int;

	public var pos:Vec2;
	public var facing:Vec2;
	private var target:Vec2;

	private var world:Game;
	private var bmd:BitmapData;
	private var yoffset:Int;
	private var bounce:Float;
	private var path:Array<Vec2>;
	public var moveCount:Int;

	public function new(game, x, y, w, h){
		super();
		world = game;

		this.w = w;
		this.h = h;
		pos = new Vec2(x, y);
		facing = new Vec2(0, 1);
		bounce = 0;
		moveCount = 0;
		path = new Array<Vec2>();

		bmd = new BitmapData(w, h, true, 0x353d31);
		var b = new Bitmap(bmd);
		addChild(b);

		bmd.fillRect(bmd.rect, 0xffffffff);
	}

	public function update(){
		if(path.length > 0 && target == null){
			target = path.pop();
		}

		if(target != null){
			var d = target.sub(pos);
			bounce = Math.sin(d.length()/1.2)*2;
			if(d.length()<1) target = null;
			d.normalizeSelf();
			facing = d.clone();
			pos.x += d.x;
			pos.y += d.y;
		}

		x = pos.x - w/2;
		y = pos.y - h/2 - yoffset - bounce;
		render();
	}

	public function handleCollision(entity:Entity, xa:Float, ya:Float):Bool {
		return true;
	}

	public function getBB():BB {
		return new BB(this, pos.x - w/2, pos.y - h/2, pos.x + w/2, pos.y + h/2);
	}

	public function move(xa:Float, ya:Float):Bool {
		var bbs:Array<BB> = world.getBBs(getBB().grow(5));
		var moved = false;
		moved = partMove(bbs, xa, 0);
		moved = partMove(bbs, 0, ya);
		facing.set(xa, ya);
		bounce = Math.sin(moveCount/1.5)*2;
		return moved;
	}

	private function partMove(bbs:Array<BB>, xa:Float, ya:Float):Bool {
		var oxa = xa;
		var oya = ya;
		var from:BB = getBB();

		var closest:BB = null;
		var epsilon = 0.01;
		for (i in 0...bbs.length) {
			var to:BB = bbs[i];
			if (from.intersectsBB(to))
				continue;

			if (ya == 0) {
				if (to.y0 >= from.y1 || to.y1 <= from.y0)
					continue;
				if (xa > 0) {
					var xrd = to.x0 - from.x1;
					if (xrd >= 0 && xa > xrd) {
						closest = to;
						xa = xrd - epsilon;
						if (xa < 0)
							xa = 0;
					}
				} else if (xa < 0) {
					var xld = to.x1 - from.x0;
					if (xld <= 0 && xa < xld) {
						closest = to;
						xa = xld + epsilon;
						if (xa > 0)
							xa = 0;
					}
				}
			}

			if (xa == 0) {
				if (to.x0 >= from.x1 || to.x1 <= from.x0)
					continue;
				if (ya > 0) {
					var yrd = to.y0 - from.y1;
					if (yrd >= 0 && ya > yrd) {
						closest = to;
						ya = yrd - epsilon;
						if (ya < 0)
							ya = 0;
					}
				} else if (ya < 0) {
					var yld = to.y1 - from.y0;
					if (yld <= 0 && ya < yld) {
						closest = to;
						ya = yld + epsilon;
						if (ya > 0)
							ya = 0;
					}
				}
			}
		}
		if (closest != null && closest.owner != null) {
			closest.owner.handleCollision(this, oxa, oya);
		}
		if (xa != 0 || ya != 0) {
			pos.x += xa*0.8;
			pos.y += ya*0.8;
			return true;
		}
		return false;
	}

	private function render(){

	}

	public function setTarget(t:Vec2){
		target = t;
	}

	public function findPath(p:Vec2){
		path = Game.instance.navMesh.findPath(pos, p);
	}
}