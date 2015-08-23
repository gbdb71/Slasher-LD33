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

	public static var started:Bool = false;

	public static var HAPPY:Int = 0;
	public static var SUSPICIOUS:Int = 1;
	public static var SCARED:Int = 2;

	public static var happyThoughts:Array<String> = ["Woohoo!", "Party time!", ":D", "Haha!", "Hahahah", "Good idea!", "Who wants to get drunk?", "I feel like letting my guard down.", 
														"Definitely nothing bad happening tonight.", "This weekend is going to be amazing!", "College rules!", "Who brought the beers?", 
														"I can't wait to live a long and fulfilling life.", "Just some friends hanging out...", ":)", "No one here has ever seen a horror film."];
	public static var suspiciousThoughts:Array<String> = ["What was that?", "D:", "Did you hear something?", "Did you hear that?", "Did you see that?", "???", "Guys?", "Uh...", "What the..."];
	public static var scaredThoughts:Array<String> = ["WTF?!", "are you serious?", "holy shit", "help!", "let's gtfo!", "omg", "dafuq!", "run!", "aaaaaghgh!"];
	public static var reliefThoughts:Array<String> = ["Guess it was nothing...", "Just my imagination...", "I must be hearing things...", "I must be seeing things...", "I'm being silly..."];

	var wait:Int;
	var thoughtTime:Int;
	
	var sheet:BitmapData;
	var tx:TextField;
	var frame:Int;

	public var thought:String;
	public var state:Int;
	public var suspTime:Int;
	public var health:Int;
	public var portrait:Int;

	public function new(game, x, y, char){
		super(game, x, y, 32, 32);
		sheet = Assets.getBitmapData("assets/"+char+".png");
		yoffset = 12;
		thought = "";
		state = HAPPY;
		health = 3;

		wait = Std.int(Math.random()*200);
		thoughtTime = 200+Std.int(Math.random()*200);

		var format = new TextFormat ("04b03", 8, 0xffffff);
		format.align = openfl.text.TextFormatAlign.CENTER;

		tx = new TextField();
		tx.defaultTextFormat = format;
		tx.selectable = false;
		tx.y = -10;
		tx.x = -384;
		tx.width = 800;
		tx.embedFonts = false;
		addChild(tx);
	}

	override public function update(){

		tx.text = thought;

		if(health <= 0){
			render();
			return;
		}

		super.update();

		if(wait > 0 && state == HAPPY) wait--;
		else if(state == HAPPY || state == SCARED) {
			if(state == HAPPY) wait = 200+Std.int(Math.random()*200);
			var valid = false;
			var t = null;
			while(!valid){
				t = new Vec2(95+Math.random()*220, 70+Math.random()*130);
				var tbb = new BB(null, t.x-10, t.y-10, t.x+10, t.y+10);
				valid = true;
				var bbs = Game.instance.getBBs(tbb, true);
				for(bb in bbs){
					if(bb.intersectsBB(tbb))
						valid = false;
				}
			}
			findPath(t);
		}

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

		if(state == SUSPICIOUS && suspTime > 0) suspTime--;
		else if(state == SUSPICIOUS && suspTime <= 0){
			state = HAPPY;
			thought = reliefThoughts[Std.int(Math.random()*reliefThoughts.length)];
			thoughtTime = 100;
		}

		if(state == SUSPICIOUS && suspTime > 225){
			state = SCARED;
		}

		// infectious
		for(teen in Game.instance.teens){
			if(pos.dist(teen.pos) < 40 && teen.state == SCARED)
				state = SCARED;
		}

		// bleeding hell!
		if(health == 1){
			Game.instance.addBlood(new Blood(pos.x+(frame==0||frame==3?5:0), pos.y+2-bounce, Math.random()/2-0.25));
			Game.instance.addBlood(new Blood(pos.x+(frame==0||frame==3?-5:0), pos.y+2-bounce, Math.random()/2-0.25));
		}else if(health == 2){				
			Game.instance.addBlood(new Blood(pos.x+(frame==0?-5:(frame==3?5:0)), pos.y+2-bounce, Math.random()/2-0.25));
		}
		
	}

	override public function render(){
		bmd.fillRect(bmd.rect, 0x00000000);
		var row:Int = 0;
		if(Math.abs(facing.x) > Math.abs(facing.y)){
			if(facing.x < 0) frame = 1;
			else frame = 2;
		}else{
			if(facing.y < 0) frame = 3;
			else frame = 0; // obsolete but idgaf, I like the structure
		}
		if(state == SCARED) row = 3;
		if(health < 3) row = 4+(3-health);
		if(health <= 0) frame = 0;
		bmd.copyPixels(sheet, new openfl.geom.Rectangle(32*frame, 32*row, 32, 32), new openfl.geom.Point(0, 0));
	}

	public function setState(state){
		if(this.state == state) return;

		this.state = state;
		if(state == SUSPICIOUS){
			path = [];
			target = null;
		}

		thoughtTime = 0;
	}
}