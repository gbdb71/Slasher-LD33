package me.miltage.ld33;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Lib;
import openfl.display.BitmapData;

class Game extends Sprite {

	var bg:BitmapData;
	var entities:Array<Entity>;
	
	public function new(){
		super();

		bg = new BitmapData(Std.int(Lib.application.window.width/Main.scale), Std.int(Lib.application.window.height/Main.scale), false, 0x353d31);
		var b:Bitmap = new Bitmap(bg);
		addChild(b);

		entities = [];

		var e = new Entity(16, 16);
		entities.push(e);
		addChild(e);
	}
}