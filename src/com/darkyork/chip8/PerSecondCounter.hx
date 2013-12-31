package com.darkyork.chip8;
import haxe.Timer;

/**
 * ...
 * @author Petr Kratina
 */
class PerSecondCounter
{
	public var value:Int = 0;
	private var lastTime:Float = 0;
	private var timer:Float = 1;
	private var buffer:Int = 0;
	
	public function new() 
	{
		lastTime = Timer.stamp();
	}

	public function tick()
	{
		buffer++;
		
		var stamp:Float = Timer.stamp();
		timer -= stamp - lastTime;
		lastTime = stamp;
		if (timer <= 0) {
			value = buffer;
			buffer = 0;
			timer = 1;
		}
	}
}