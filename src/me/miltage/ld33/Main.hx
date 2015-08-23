package me.miltage.ld33;


import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Lib;
import openfl.Assets;
import openfl.events.MouseEvent;


class Main extends Sprite {
	public static var instance:Main;
	public static var scale:Int = 2;
	
	var game:Game;

	public var titleScreen:Bitmap;
	public var winScreen:Bitmap;
	public var loseScreen:Bitmap;

	public function new () {
		
		super ();

		instance = this;
		Lib.current.stage.quality = flash.display.StageQuality.LOW;

		game = new Game();
		game.scaleX = game.scaleY = scale;
		addChild(game);

		titleScreen = new Bitmap(Assets.getBitmapData("assets/title.png"));
		titleScreen.scaleX = titleScreen.scaleY = scale;
		addChild(titleScreen);

		winScreen = new Bitmap(Assets.getBitmapData("assets/win_screen.png"));
		winScreen.scaleX = winScreen.scaleY = scale;
		addChild(winScreen);

		loseScreen = new Bitmap(Assets.getBitmapData("assets/lose_screen.png"));
		loseScreen.scaleX = loseScreen.scaleY = scale;
		addChild(loseScreen);
		winScreen.visible = loseScreen.visible = false;

		addEventListener(MouseEvent.CLICK, leftClick);
		
	}

	public function leftClick(m:MouseEvent){
		trace(m.stageX/scale+", "+m.stageY/scale);
		//game.entities[1].findPath(new me.miltage.ld33.math.Vec2(m.stageX/scale, m.stageY/scale));
	}

	public function restart(){
		loseScreen.visible = winScreen.visible = titleScreen.visible = false;
		removeChild(game);
		Game.started = false;
		Game.finished = false;
		game.dump();
		game = new Game();
		game.scaleX = game.scaleY = scale;
		addChildAt(game, 0);
	}
	
	
}