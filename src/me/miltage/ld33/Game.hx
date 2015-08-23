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

	public static var instance:Game;

	public var entities:Array<Entity>;
	public var navMesh:NavMesh;

	var bg:BitmapData;
	var data:BitmapData;

	var keys:KeyObject;

	var worldBBs:Array<BB>;
	
	public function new(){
		super();
		instance = this;

		keys = new KeyObject(Lib.current.stage);

		bg = new BitmapData(Std.int(Lib.application.window.width/Main.scale), Std.int(Lib.application.window.height/Main.scale), false, 0x353d31);
		var b:Bitmap = new Bitmap(bg);
		addChild(b);

		worldBBs = new Array<BB>();
		// world boundaries
		worldBBs.push(new BB(null, 0, 0, Lib.application.window.width/Main.scale, 2));
		worldBBs.push(new BB(null, 0, 0, 2, Lib.application.window.height/Main.scale));
		worldBBs.push(new BB(null, 0, Lib.application.window.height/Main.scale-2, Lib.application.window.width/Main.scale, 2));
		worldBBs.push(new BB(null, Lib.application.window.width/Main.scale-2, 0, 2, Lib.application.window.height/Main.scale));

		// cabin walls		
		worldBBs.push(new BB(null, 91, 65, 320, 67));
		worldBBs.push(new BB(null, 190, 116, 288, 119));
		worldBBs.push(new BB(null, 306, 116, 320, 119));
		worldBBs.push(new BB(null, 92, 135, 161, 137));
		worldBBs.push(new BB(null, 92, 212, 281, 215));
		worldBBs.push(new BB(null, 299, 212, 320, 215));

		worldBBs.push(new BB(null, 91, 66, 95, 214));
		worldBBs.push(new BB(null, 160, 66, 164, 82));
		worldBBs.push(new BB(null, 160, 97, 164, 169));
		worldBBs.push(new BB(null, 160, 184, 164, 213));
		worldBBs.push(new BB(null, 186, 66, 190, 82));
		worldBBs.push(new BB(null, 186, 97, 190, 169));
		worldBBs.push(new BB(null, 186, 184, 190, 213));
		worldBBs.push(new BB(null, 241, 66, 245, 117));
		worldBBs.push(new BB(null, 320, 65, 324, 215));

		worldBBs.push(new BB(null, 260, 238, 263, 241));
		worldBBs.push(new BB(null, 319, 238, 322, 241));

		navMesh = new NavMesh();

		var bmd = Assets.getBitmapData("assets/cabin.png");
		addChild(new Bitmap(bmd));

		entities = [];

		var e = new Killer(this, 200, 200);
		entities.push(e);
		addChild(e);

		var t0 = new Teen(this, 220, 180, "token");
		entities.push(t0);
		addChild(t0);

		var t1 = new Teen(this, 220, 180, "todd");
		entities.push(t1);
		addChild(t1);

		var t2 = new Teen(this, 220, 180, "roxanne");
		entities.push(t2);
		addChild(t2);

		var t3 = new Teen(this, 220, 180, "jessica");
		entities.push(t3);
		addChild(t3);

		addEventListener(Event.ENTER_FRAME, update);

		data = new BitmapData(Std.int(Lib.application.window.width/Main.scale), Std.int(Lib.application.window.height/Main.scale), true, 0x00000000);
		b = new Bitmap(data);
		addChild(b);

		for(bb in worldBBs){
			/*GraphicsUtil.drawLine(data, bb.x0, bb.y0, bb.x1, bb.y0, 0xffff0000);
			GraphicsUtil.drawLine(data, bb.x0, bb.y0, bb.x0, bb.y1, 0xffff0000);
			GraphicsUtil.drawLine(data, bb.x0, bb.y1, bb.x1, bb.y1, 0xffff0000);
			GraphicsUtil.drawLine(data, bb.x1, bb.y0, bb.x1, bb.y1, 0xffff0000);*/
		}
		for(node in navMesh.nodes){
			/*data.setPixel32(Std.int(node.x), Std.int(node.y), 0xffff0000);
			for(n in node.neighbours)
				GraphicsUtil.drawLine(data, node.x, node.y, n.x, n.y, 0xffff0000);*/
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

		if(keys.isDown(KeyObject.RIGHT) || keys.isDown(KeyObject.D) || keys.isDown(KeyObject.LEFT) || keys.isDown(KeyObject.A)
			|| keys.isDown(KeyObject.UP) || keys.isDown(KeyObject.W) || keys.isDown(KeyObject.DOWN) || keys.isDown(KeyObject.S))
			entities[0].moveCount++;
		else
			entities[0].moveCount = 0;


		//data.fillRect(data.rect, 0x00000000);

		if(LOS.canSee(entities[0].pos, entities[1].pos, 1)){
			//GraphicsUtil.drawLine(data, entities[0].pos.x, entities[0].pos.y, entities[1].pos.x, entities[1].pos.y, 0xffff0000);
		}

	}

	public function getBBs(bounds:BB):Array<BB> {
		var list:Array<BB> = new Array<BB>();
		bounds = bounds.grow(5);		

		for(bb in worldBBs){
			if(bounds.intersectsBB(bb))
				list.push(bb);
		}

		return list;
	}
}