package me.miltage.ld33;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.Assets;

import me.miltage.ld33.math.BB;
import me.miltage.ld33.utils.KeyObject;
import me.miltage.ld33.utils.GraphicsUtil;

class Game extends Sprite {

	var bg:BitmapData;
	var data:BitmapData;
	var entities:Array<Entity>;

	var keys:KeyObject;
	
	public function new(){
		super();

		keys = new KeyObject(Lib.current.stage);

		bg = new BitmapData(Std.int(Lib.application.window.width/Main.scale), Std.int(Lib.application.window.height/Main.scale), false, 0x353d31);
		var b:Bitmap = new Bitmap(bg);
		addChild(b);

		var bmd = Assets.getBitmapData("assets/cabin.png");
		addChild(new Bitmap(bmd));

		entities = [];

		var e = new Entity(this, 8, 8);
		entities.push(e);
		addChild(e);

		addEventListener(Event.ENTER_FRAME, update);

		data = new BitmapData(Std.int(Lib.application.window.width/Main.scale), Std.int(Lib.application.window.height/Main.scale), true, 0x00000000);
		b = new Bitmap(data);
		addChild(b);

		var list = getBBs(null);
		for(bb in list){
			GraphicsUtil.drawLine(data, bb.x0, bb.y0, bb.x1, bb.y0, 0xffff0000);
			GraphicsUtil.drawLine(data, bb.x0, bb.y0, bb.x0, bb.y1, 0xffff0000);
			GraphicsUtil.drawLine(data, bb.x0, bb.y1, bb.x1, bb.y1, 0xffff0000);
			GraphicsUtil.drawLine(data, bb.x1, bb.y0, bb.x1, bb.y1, 0xffff0000);
		}

	}

	public function update(e:Event){
		for(e in entities)
			e.update();

		if(keys.isDown(KeyObject.RIGHT) || keys.isDown(KeyObject.D))
			entities[0].move(2, 0);
		if(keys.isDown(KeyObject.LEFT) || keys.isDown(KeyObject.A))
			entities[0].move(-2, 0);
		if(keys.isDown(KeyObject.UP) || keys.isDown(KeyObject.W))
			entities[0].move(0, -2);
		if(keys.isDown(KeyObject.DOWN) || keys.isDown(KeyObject.S))
			entities[0].move(0, 2);
	}

	public function getBBs(e:Entity):Array<BB> {
		var list:Array<BB> = new Array<BB>();

		// world boundaries
		list.push(new BB(null, 0, 0, Lib.application.window.width/Main.scale, 2));
		list.push(new BB(null, 0, 0, 2, Lib.application.window.height/Main.scale));
		list.push(new BB(null, 0, Lib.application.window.height/Main.scale-2, Lib.application.window.width/Main.scale, 2));
		list.push(new BB(null, Lib.application.window.width/Main.scale-2, 0, 2, Lib.application.window.height/Main.scale));

		// cabin walls		
		list.push(new BB(null, 91, 65, 320, 67));
		list.push(new BB(null, 190, 116, 288, 119));
		list.push(new BB(null, 306, 116, 320, 119));
		list.push(new BB(null, 92, 135, 161, 137));
		list.push(new BB(null, 92, 212, 281, 215));
		list.push(new BB(null, 299, 212, 320, 215));

		list.push(new BB(null, 91, 66, 94, 214));
		list.push(new BB(null, 160, 66, 163, 82));
		list.push(new BB(null, 160, 97, 163, 169));
		list.push(new BB(null, 160, 184, 163, 213));
		list.push(new BB(null, 186, 66, 189, 82));
		list.push(new BB(null, 186, 97, 189, 169));
		list.push(new BB(null, 186, 184, 189, 213));
		list.push(new BB(null, 241, 66, 244, 117));
		list.push(new BB(null, 320, 65, 323, 215));

		list.push(new BB(null, 260, 238, 263, 241));
		list.push(new BB(null, 319, 238, 322, 241));


		return list;
	}
}