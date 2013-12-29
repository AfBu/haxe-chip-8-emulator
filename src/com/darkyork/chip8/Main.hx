package com.darkyork.chip8;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.media.Sound;
import flash.text.TextField;
import openfl.Assets;
import sys.FileSystem;

/**
 * ...
 * @author Petr Kratina
 */

class Main extends Sprite 
{
	var inited:Bool;
	var cpu:Chip8;
	var display:Bitmap;
	var debugText:TextField;
	var roms:Array<String>;
	
	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;

		roms = FileSystem.readDirectory("./roms/");
		var ri:Int = 0;
		for (r in roms) {
			var rtf:TextField = new TextField();
			rtf.text = r;
			rtf.y = 256 + 4 + Math.floor(ri / 6) * 20;
			rtf.x = (ri - Math.floor(ri / 6) * 6) * 85;
			rtf.selectable = false;
			rtf.width = 85;
			rtf.height = 20;
			rtf.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) { 
				cpu.stop();
				cpu.load(rtf.text);
				cpu.start();
			} );
			rtf.addEventListener(MouseEvent.MOUSE_OVER, function (e:MouseEvent) { rtf.textColor = 0xFFFFFF; } );
			rtf.addEventListener(MouseEvent.MOUSE_OUT, function (e:MouseEvent) { rtf.textColor = 0xAAAAAA; } );
			rtf.textColor = 0xAAAAAA;
			addChild(rtf);
			ri++;
		}
		
		debugText = new TextField();
		debugText.x = 512 + 4;
		debugText.height = stage.stageHeight;
		debugText.textColor = 0xFFFFFF;
		debugText.text = "Emulator started";
		addChild(debugText);
		
		// (your code here)
		cpu = new Chip8();
		cpu.sleep = 0.001;
		cpu.load("CHIP8");
		cpu.start();
		
		display = new Bitmap(new BitmapData(64, 32, false, 0x222222));
		display.scaleX = display.scaleY = 8;
		addChild(display);
		
		addEventListener(Event.ENTER_FRAME, update);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, updateKey);
		stage.addEventListener(KeyboardEvent.KEY_UP, updateKey);
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	function updateKey(e:KeyboardEvent)
	{
		var ek:UInt = 0xFF;
		switch (e.keyCode)
		{
			case 49: ek = 0x1;
			case 50: ek = 0x2;
			case 51: ek = 0x3;
			case 52: ek = 0xC;
			case 81: ek = 0x4;
			case 87: ek = 0x5;
			case 69: ek = 0x6;
			case 82: ek = 0xD;
			case 65: ek = 0x7;
			case 83: ek = 0x8;
			case 68: ek = 0x9;
			case 70: ek = 0xE;
			case 90: ek = 0xA;
			case 88: ek = 0x0;
			case 67: ek = 0xB;
			case 86: ek = 0xF;
			default: ek = 0xFF;
		}

		if (ek == 0xFF) return;
		
		if (e.type == KeyboardEvent.KEY_DOWN) cpu.key[ek] = 0xFF;
		if (e.type == KeyboardEvent.KEY_UP) cpu.key[ek] = 0x00;
	}
	
	function update(e:Event)
	{
		cpu.render(display.bitmapData);
		
		if (cpu.beep) {
			cpu.beep = false;
			Assets.getSound("data/beep.wav").play();
		}
		
		var dbg:String = 
		"SPS: " + cpu.sps + "\n" +
		"OP: 0x" + StringTools.hex(cpu.opcode) + "\n" +
		"PC: " + cpu.pc + "\n" +
		"I: " + cpu.I + "\n" +
		"SP: " + cpu.sp + "\n\n";
		
		for (i in 0...16) dbg += "V[" + i + "] : " + cpu.V[i] + "   0x" + StringTools.hex(cpu.V[i]) + "\n";

		debugText.text = dbg;
	}
	
	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
