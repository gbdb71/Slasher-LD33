package me.miltage.ld33;


import openfl.display.Sprite;
import openfl.Lib;


class Main extends Sprite {

	public static var scale:Int = 2;
	
	var game:Game;

	public function new () {
		
		super ();
		Lib.current.stage.quality = flash.display.StageQuality.LOW;

		game = new Game();
		game.scaleX = game.scaleY = scale;
		addChild(game);
		
	}
	
	
}