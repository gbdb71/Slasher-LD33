package me.miltage.ld33;

import openfl.display.BitmapData;
import openfl.Assets;

import me.miltage.ld33.math.Vec2;
import me.miltage.ld33.math.BB;

class Teen extends Entity {

	var wait:Int;
	
	var sheet:BitmapData;
	public function new(game, x, y, char){
		super(game, x, y, 32, 32);
		sheet = Assets.getBitmapData("assets/"+char+".png");
		yoffset = 12;

		wait = Std.int(Math.random()*200);
	}

	override public function update(){
		super.update();

		if(wait > 0) wait--;
		else {
			wait = 200+Std.int(Math.random()*200);
			var valid = false;
			var t = null;
			while(!valid){
				t = new Vec2(95+Math.random()*220, 70+Math.random()*130);
				var tbb = new BB(null, t.x-10, t.y-10, t.x+10, t.y+10);
				valid = true;
				var bbs = Game.instance.getBBs(tbb);
				for(bb in bbs){
					if(bb.intersectsBB(tbb))
						valid = false;
				}
			}
			findPath(t);
		}
	}

	override private function render(){
		bmd.fillRect(bmd.rect, 0x00000000);
		var frame:Int = 0;
		if(Math.abs(facing.x) > Math.abs(facing.y)){
			if(facing.x < 0) frame = 1;
			else frame = 2;
		}else{
			if(facing.y < 0) frame = 3;
			else frame = 0; // obsolete but idgaf, I like the structure
		}
		bmd.copyPixels(sheet, new openfl.geom.Rectangle(32*frame, 0, 32, 32), new openfl.geom.Point(0, 0));
	}
}