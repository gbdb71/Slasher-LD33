package me.miltage.ld33;

import me.miltage.ld33.math.Vec2;

class LOS {
	
	public static function canSee(p0:Vec2, p1:Vec2, size:Int=4):Bool {
		if(p0.dist(p1) < size) return true;
		var x0 = Std.int(p0.x);
		var x1 = Std.int(p1.x);
		var y0 = Std.int(p0.y);
		var y1 = Std.int(p1.y);
		var dx:Int = Std.int(x1-x0);
		var dy:Int = Std.int(y1-y0);
		var stepx:Int;
		var stepy:Int;
	
		if (dx<0) { dx*=-1; stepx=-1; } else { stepx=1; }
		if (dy<0) { dy*=-1; stepy=-1; } else { stepy=1; }
		
		dy <<= 1; // *= 2;
		dx <<= 1;
		
		if (dx > dy) {
			var fraction:Float = dy - (dx >> 1);
			while (x0 != x1) {
				if (fraction >= 0) {
					y0 += stepy;
					fraction -= dx;
				}
				x0 += stepx;
				fraction += dy;
				var bbs = Game.instance.getBBs(new me.miltage.ld33.math.BB(null, x0-10, y0-10, x0+10, y0+10));
				for(bb in bbs){
					if(bb.intersects(x0-size, y0-size, x0+size, y0+size))
						return false;
				}
			}
		} else {
			var fraction:Float = dx - (dy >> 1);
			while (y0 != y1) {
				if (fraction >= 0) {
					x0 += stepx;
					fraction -= dy;
				}
				y0 += stepy;
				fraction += dx;
				var bbs = Game.instance.getBBs(new me.miltage.ld33.math.BB(null, x0-10, y0-10, x0+10, y0+10));
				for(bb in bbs){
					if(bb.intersects(x0-size, y0-size, x0+size, y0+size))
						return false;
				}
			}
		}

		return true;
	}
}