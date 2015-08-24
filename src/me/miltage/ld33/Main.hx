package me.miltage.ld33;


import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Lib;
import openfl.Assets;
import openfl.events.MouseEvent;
import haxe.Timer;

import me.miltage.ld33.utils.SoundManager;


class Main extends Sprite {
	public static var instance:Main;
	public static var scale:Int = 2;
	public static var mute:Bool = false;
	
	public static var game:Game;

	public var titleScreen:Bitmap;
	public var winScreen:Bitmap;
	public var loseScreen:Bitmap;

	public var soundManager:SoundManager;
	public var soundManager2:SoundManager;

	private var thunderCounter:Int = 1;
	private var timer:Timer;

	public function new () {
		
		super ();

		instance = this;
		Lib.current.stage.quality = flash.display.StageQuality.LOW;

		soundManager = new SoundManager(1);
		soundManager.loop("assets/eerie.mp3");

		soundManager2 = new SoundManager(.5);

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
		if(m.stageX > Lib.application.window.width - 32 && m.stageY < 32)
			muteGame();
	}

	public function restart(){
		loseScreen.visible = winScreen.visible = titleScreen.visible = false;
		removeChild(game);
		game.dump();
		game = null;
		Game.started = false;
		Game.finished = false;
		Game.runCounter = 0;
		game = new Game();
		game.scaleX = game.scaleY = scale;
		addChildAt(game, 0);
		Game.started = true;		
		soundManager.loop("assets/eerie.mp3");
		timer = null;
	}

	// AC DC
	public function thunderStruck(){
		soundManager2.play("assets/thunder"+thunderCounter+".mp3");
		thunderCounter = thunderCounter==1?2:1;
	}

	public function showScreen(screen){
		if(timer != null) return;

		timer = new Timer(1000);
		trace("show screen");
		timer.run = function() {
			screen.visible = true;
			Game.finished = true;
			Game.runCounter = 0;
			timer.stop();
		}
	}

	public function muteGame(){
		mute = !mute;
		for(m in SoundManager.managers){
			m.transform(mute?0:1);
		}
	}
	
	
}