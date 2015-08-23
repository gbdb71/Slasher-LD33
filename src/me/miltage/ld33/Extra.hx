package me.miltage.ld33;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.Assets;

class Extra extends Entity {
	var sheet:BitmapData;

	private var clipx:Int;
	private var clipy:Int;

	public function new(game, x, y, w, h, a, cx=0, cy=0){
		super(game, x, y, w, h);
		sheet = Assets.getBitmapData("assets/"+a+".png");
		//yoffset = 12;

		// offset back to normal
		pos.x = x + w/2;
		pos.y = y + h/2;

		clipx = cx;
		clipy = cy;

	}

	override private function render(){
		bmd.fillRect(bmd.rect, 0x00000000);
		
		bmd.copyPixels(sheet, new openfl.geom.Rectangle(clipx, clipy, w, h), new openfl.geom.Point(0, 0));
	}
}