package me.miltage.ld33;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.Assets;

import me.miltage.ld33.math.Vec2;
import me.miltage.ld33.math.BB;
import me.miltage.ld33.utils.GraphicsUtil;

class Killer extends Entity {

	var sheet:BitmapData;
	var hack:Int;
	var hackWait:Int;

	var letter:Bitmap;
	var hackCount:Int;

	public var hiding:Bool;
	public var hideDelay:Int;

	public function new(game, x, y){
		super(game, x, y, 32, 32);
		sheet = Assets.getBitmapData("assets/killer.png");
		yoffset = 12;

		hiding = false;

		var ui = Assets.getBitmapData("assets/ui.png");
		var b = new BitmapData(8, 9, false, 0x000000);
		b.copyPixels(ui, new openfl.geom.Rectangle(16, 0, 8, 9), new openfl.geom.Point());
		letter = new Bitmap(b);
		letter.x = 12;
		letter.y = -12;
		letter.visible = false;
		addChild(letter);
	}

	override public function update(){
		super.update();

		letter.visible = false;

		for(hp in Game.instance.hidingPlaces){
			if(pos.dist(hp) < 10)
				letter.visible = true;
		}

		for(w in Game.instance.windows){
			if(pos.dist(w) < 10)
				letter.visible = true;
		}


		if(hideDelay > 0) hideDelay--;

		if(hackCount > 0) hackCount--;
		else Main.instance.soundManager.loop("assets/eerie.mp3");

	}

	override public function move(xa:Float, ya:Float):Bool {
		if(hiding) return false;
		super.move(xa, ya);
		return true;
	}

	override public function render(){
		visible = !hiding;

		bmd.fillRect(bmd.rect, 0x00000000);
		var frame:Int = 0;
		if(Math.abs(facing.x) > Math.abs(facing.y)){
			if(facing.x < 0) frame = 1;
			else frame = 2;
		}else{
			if(facing.y < 0) frame = 3;
			else frame = 0; // obsolete but idgaf, I like the structure
		}

		if(hack > 0 && hack < 6) hack++;
		else hack = 0;

		if(hackWait > 0) hackWait--;

		bmd.copyPixels(sheet, new openfl.geom.Rectangle(32*(Std.int(hack/2)), 32*frame, 32, 32), new openfl.geom.Point(0, 0));
	}

	override public function getBB():BB {
		return new BB(this, pos.x - 7, pos.y - 5, pos.x + 7, pos.y + 5);
	}

	public function slash(){
		if(hackWait == 0){
			hack = 1;
			hackWait = 10;

			for(teen in Game.instance.teens){
				if(pos.dist(teen.pos) < 20 && teen.health > 0){
					teen.health--;
					teen.setState(Teen.SCARED);
					Main.instance.soundManager.loop("assets/psycho.mp3");
					hackCount = 190;
					for(i in 0...10)
					Game.instance.addBlood(new Blood(teen.pos.x, teen.pos.y, Math.random()*2-1));

					if(teen.health <= 0){
						teen.thought = "";
					}

					if(!Game.instance.checkOrder()) Main.instance.showScreen(Main.instance.loseScreen);
				}

			}
		}
	}

	public function canHide():Bool {
		for(hp in Game.instance.hidingPlaces){
			if(pos.dist(hp) < 10)
				return true;
		}
		return false;
	}

	public function canWindow():Bool {
		for(w in Game.instance.windows){
			if(pos.dist(w) < 10)
				return true;
		}
		return false;
	}
}