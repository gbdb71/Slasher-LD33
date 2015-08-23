package me.miltage.ld33;


import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.MouseEvent;


class Main extends Sprite {

	public static var scale:Int = 2;
	
	var game:Game;

	public function new () {
		
		super ();
		Lib.current.stage.quality = flash.display.StageQuality.LOW;

		game = new Game();
		game.scaleX = game.scaleY = scale;
		addChild(game);

		addEventListener(MouseEvent.CLICK, leftClick);
		
	}

	public function leftClick(m:MouseEvent){
		trace(m.stageX/scale+", "+m.stageY/scale);
		//game.entities[1].findPath(new me.miltage.ld33.math.Vec2(m.stageX/scale, m.stageY/scale));
	}
	
	
}