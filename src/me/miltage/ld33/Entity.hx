package me.miltage.ld33;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class Entity extends Sprite {
	
	public var w:Int;
	public var h:Int;

	public function new(w, h){
		super();

		this.w = w;
		this.h = h;
		w = h = 16;

		var bmd = new BitmapData(w, h, true, 0x353d31);
		var b = new Bitmap(bmd);
		addChild(b);

		bmd.fillRect(bmd.rect, 0xffffffff);
	}
}