package me.miltage.ld33;

import openfl.display.BitmapData;
import openfl.Assets;

class Teen extends Entity {
	
	var sheet:BitmapData;
	public function new(game, x, y){
		super(game, x, y, 32, 32);
		sheet = Assets.getBitmapData("assets/token.png");
		yoffset = 12;
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