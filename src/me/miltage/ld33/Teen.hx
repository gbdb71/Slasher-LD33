package me.miltage.ld33;

import openfl.display.BitmapData;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.Font;

import me.miltage.ld33.math.Vec2;
import me.miltage.ld33.math.BB;

@:font("assets/04B_03_.ttf") class DefaultFont extends Font {}

class Teen extends Entity {

	public static var HAPPY:Int = 0;
	public static var SUSPICIOUS:Int = 1;
	public static var SCARED:Int = 2;

	public static var happyThoughts:Array<String> = ["Woohoo!", "Party time!", ":D", "Haha", "Hahaha!", "Who wants to get drunk?", "Let's let our guard down.", "Definitely nothing bad happening tonight.",
														"This weekend is going to be amazing!"];
	public static var suspiciousThoughts:Array<String> = ["What was that?", "D:", "Did you hear something?", "Did you hear that?", "Did you see that?", "???"];
	public static var scaredThoughts:Array<String> = ["WTF?!", "holy shit", "help!", "let's gtfo!", "omg", "dafuq!", "run!"];

	var wait:Int;
	var thoughtTime:Int;
	
	var sheet:BitmapData;
	var tx:TextField;

	public var thought:String;
	public var state:Int;

	public function new(game, x, y, char){
		super(game, x, y, 32, 32);
		sheet = Assets.getBitmapData("assets/"+char+".png");
		yoffset = 12;
		thought = "";
		state = HAPPY;

		wait = Std.int(Math.random()*200);
		thoughtTime = 400+Std.int(Math.random()*200);

		var format = new TextFormat ("04b03", 8, 0xffffff);
		format.align = openfl.text.TextFormatAlign.CENTER;

		tx = new TextField();
		tx.defaultTextFormat = format;
		tx.y = -10;
		tx.x = -384;
		tx.width = 800;
		tx.embedFonts = false;
		addChild(tx);
	}

	override public function update(){
		super.update();

		if(wait > 0) wait--;
		else {
			wait = 200+Std.int(Math.random()*200);
			var valid = false;
			var t = null;
			while(!valid){
				t = new Vec2(95+Math.random()*220, 70+Math.random()*130);
				var tbb = new BB(null, t.x-10, t.y-10, t.x+10, t.y+10);
				valid = true;
				var bbs = Game.instance.getBBs(tbb);
				for(bb in bbs){
					if(bb.intersectsBB(tbb))
						valid = false;
				}
			}
			findPath(t);
		}

		tx.text = thought;

		if(thoughtTime > 0) thoughtTime--;
		else {
			if(state == HAPPY) thoughtTime = 200+Std.int(Math.random()*200);
			else thoughtTime = Std.int(Math.random()*50);
			
			if(thought.length > 0) thought = "";
			else {
				if(state == HAPPY) thought = happyThoughts[Std.int(Math.random()*happyThoughts.length)];
				else if(state == SUSPICIOUS) thought = suspiciousThoughts[Std.int(Math.random()*suspiciousThoughts.length)];
				else thought = scaredThoughts[Std.int(Math.random()*scaredThoughts.length)];

				thoughtTime = 100;
			}
		}
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

	public function setState(state){
		if(this.state == state) return;

		this.state = state;

		thoughtTime = 0;
	}
}