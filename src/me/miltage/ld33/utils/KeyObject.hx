package me.miltage.ld33.utils;

import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class KeyObject {

	private static var stage:Stage;
	private static var keysDown:Dynamic;

	public static var UP:UInt = Keyboard.UP;
	public static var DOWN:UInt = Keyboard.DOWN;
	public static var LEFT:UInt = Keyboard.LEFT;
	public static var RIGHT:UInt = Keyboard.RIGHT;

	public function new(stage:Stage) {
		construct(stage);
	}
	
	public function construct(stage:Stage) {
		KeyObject.stage = stage;
		keysDown = new Array();
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
	}

	public function isDown(keyCode:UInt):Bool {
		return keysDown[keyCode]?keysDown[keyCode]:false;
	}

	private function keyPressed(evt:KeyboardEvent) {
		keysDown[evt.keyCode] = true;
	}
	
	private function keyReleased(evt:KeyboardEvent) {
		keysDown[evt.keyCode] = false;
	}
}