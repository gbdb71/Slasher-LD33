package me.miltage.ld33;

import openfl.display.BitmapData;
import openfl.Assets;

import me.miltage.ld33.math.Vec2;
import me.miltage.ld33.math.BB;

class Killer extends Entity {

	var sheet:BitmapData;
	public function new(game, x, y){
		super(game, x, y, 32, 32);
		sheet = Assets.getBitmapData("assets/killer.png");
		yoffset = 12;
	}

	override public function update(){
		super.update();

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
		bmd.copyPixels(sheet, new openfl.geom.Rectangle(0, 32*frame, 32, 32), new openfl.geom.Point(0, 0));
	}

	override public function getBB():BB {
		return new BB(this, pos.x - 4, pos.y - 4, pos.x + 4, pos.y + 4);
	}
}