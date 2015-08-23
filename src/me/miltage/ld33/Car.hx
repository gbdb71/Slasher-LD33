package me.miltage.ld33;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;

import me.miltage.ld33.math.BB;

class Car extends Entity {

	var lights:Bitmap;
	var chassis:Bitmap;
	var wheels:Bitmap;

	var vx:Float;
	var lightsDelay:Int = 100;
	var done:Bool = false;

	public function new(){
		super(null, 650, 270, 150, 46);

		chassis = new Bitmap(Assets.getBitmapData("assets/chassis.png"));
		addChild(chassis);
		wheels = new Bitmap(Assets.getBitmapData("assets/wheels.png"));
		addChild(wheels);
		lights = new Bitmap(Assets.getBitmapData("assets/lights.png"));
		addChild(lights);

		vx = -7;
	}

	override public function update(){
		super.update();

		if(!Game.started || done) return;

		pos.x += vx;

		if(pos.x < 150) vx *= 0.8;

		chassis.y = Math.cos(vx*3);

		if(vx < 1 && lightsDelay > 0) lightsDelay--;
		else if(vx < 1 && lights.visible){
			lights.visible = false;
			lightsDelay = 30;
		}
		else if(vx < 1){
			Game.instance.addTeens();
			done = true;
		}
	}

	override public function getBB():BB {
		return new BB(this, 144, 266, 185, 281);
	}
	
}