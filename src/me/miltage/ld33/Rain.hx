package me.miltage.ld33;

class Rain {
	public var x:Int;
	public var y:Int;
	public function new(){
		x = Std.int(Math.random()*400);
		y = Std.int(Math.random()*300);


	}

	public function update(){
		y += 8;
		x -= 3;

		if(y > 400) y = -100-Std.int(Math.random()*500);
		if(x < -50) x = Std.int(Math.random()*600);
	}
}