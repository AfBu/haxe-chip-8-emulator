package com.darkyork.chip8;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.Timer;
import openfl.Assets;
import sys.FileSystem;

/**
 * ...
 * @author Petr Kratina
 */
class Television extends Sprite
{

	public var overlay:Bitmap;
	public var display:Bitmap;
	public var cpu:Chip8;
	public var debugTextField:TextField;
	public var loader:Menu;
	public var roms:Array<String>;
	public var currentRom:String = "";
	public var keymap:Bitmap;
	public var credits:Bitmap;
	public var startLoader:Float = 5;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	public function init(e:Event)
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		overlay = new Bitmap(Assets.getBitmapData("data/tv.png"));
		display = new Bitmap(new BitmapData(128, 64, false));
		display.scaleX = display.scaleY = 4;
		display.x = 96;
		display.y = 170;

		keymap = new Bitmap(Assets.getBitmapData("data/keymap.png"));
		keymap.visible = false;
		keymap.x = 877 / 2 - keymap.width / 2;
		keymap.y = 600 / 2 - keymap.height / 2;

		credits = new Bitmap(Assets.getBitmapData("data/credits.png"));
		credits.visible = false;
		credits.x = 877 / 2 - credits.width / 2;
		credits.y = 600 / 2 - credits.height / 2;

		var font:Font = Assets.getFont("data/NovaMono.ttf");

		loader = new Menu();
		loader.visible = false;
		var ldTextFormat:TextFormat = new TextFormat(font.fontName, 14, 0xEEEEEE, false, false, false, "", "", TextFormatAlign.CENTER, 0, 0, 0, 0);
		var ldTextFormatHover:TextFormat = new TextFormat(font.fontName, 14, 0xFFFFFF, true, false, false, "", "", TextFormatAlign.CENTER, 0, 0, 0, 0);
		roms = FileSystem.readDirectory("./roms/");
		var ri:Int = 0;
		for (r in roms) {
			var rtf:TextField = new TextField();
			rtf.y = 256 + 4 + Math.floor(ri / 6) * 20;
			rtf.x = 96 + (ri - Math.floor(ri / 6) * 6) * 85;
			rtf.selectable = false;
			rtf.width = 85;
			rtf.height = 20;
			rtf.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) { 
				currentRom = rtf.text;
				cpu.stop();
				cpu.load(currentRom);
				cpu.start();
				loader.visible = false;
			} );
			rtf.defaultTextFormat = ldTextFormat;
			rtf.embedFonts = true;
			rtf.text = r;
			rtf.addEventListener(MouseEvent.MOUSE_OVER, function (e:MouseEvent) { rtf.setTextFormat(ldTextFormatHover); } );
			rtf.addEventListener(MouseEvent.MOUSE_OUT, function (e:MouseEvent) { rtf.setTextFormat(ldTextFormat); } );
			loader.addChild(rtf);
			ri++;
		}
		
		//trace(font.fontName);
		debugTextField = new TextField();
		//debugTextField.type = TextFieldType.DYNAMIC;
		debugTextField.defaultTextFormat = new TextFormat(font.fontName, 14, 0xFFFFFF, true, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
		debugTextField.embedFonts = true;
		debugTextField.selectable = false;
		debugTextField.height = 600;
		debugTextField.width = 200;
		debugTextField.visible = false;
		
		addChild(display);
		addChild(overlay);
		addChild(loader);
		addChild(keymap);
		addChild(credits);
		addChild(debugTextField);
		
		cpu = new Chip8();
		//cpu.sleep = 0.1;
		cpu.load("");
		cpu.start();
		
		addEventListener(Event.ENTER_FRAME, update);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, updateKey);
		stage.addEventListener(KeyboardEvent.KEY_UP, updateKey);
	}
	
	public function update(e:Event)
	{
		if (startLoader > 0) {
			if (loader.visible) startLoader = 0;
			startLoader -= Timer.stamp();
			if (startLoader <= 0) loader.visible = true;
		}
		
		if (loader.visible && !cpu.pause) {
			cpu.pause = true;
			display.alpha = 0.25;
		}
		if (!loader.visible && cpu.pause) {
			cpu.pause = false;
			display.alpha = 1;
		}
		
		// scale display based on mode
		if (display.scaleX == 8 && cpu.extendedMode) display.scaleX = display.scaleY = 4;
		if (display.scaleX == 4 && !cpu.extendedMode) display.scaleX = display.scaleY = 8;
		
		cpu.render(display.bitmapData);
		
		if (cpu.beep) {
			cpu.beep = false;
			Assets.getSound("data/beep.wav").play();
		}
		
		if (debugTextField.visible)
		{
			var debugLines:Array<String> = new Array<String>();
			debugLines.push("MODE:     " + (cpu.extendedMode ? "ext" : "bas"));
			debugLines.push("PC:       " + cpu.pc);
			debugLines.push("I:        " + cpu.I);
			debugLines.push("Opcode: 0x" + StringTools.hex(cpu.opcode));
			for (vi in 0...cpu.V.length) 
			{
				debugLines.push("V" + vi + (vi < 10 ? " " : "") + ":    0x" + StringTools.hex(cpu.V[vi]));
			}
			debugTextField.text = debugLines.join("\n");
		}
	}
	
	function updateKey(e:KeyboardEvent)
	{
		//trace(e.keyCode, e.keyLocation, e.charCode);
		
		if (e.keyCode == 27 && e.type == KeyboardEvent.KEY_UP) {
			if (keymap.visible) { keymap.visible = false; return; }
			if (credits.visible) { credits.visible = false; return; }
			loader.visible = !loader.visible;
			return;
		}
		if (e.charCode == 0 && e.keyCode == 89 && e.type == KeyboardEvent.KEY_UP) {
			cpu.load(currentRom);
			cpu.start();
			return;
		}
		if (e.charCode == 0 && e.keyCode == 80 && e.type == KeyboardEvent.KEY_UP) {
			keymap.visible = !keymap.visible;
			if (keymap.visible) credits.visible = false;
			return;
		}
		if (e.charCode == 0 && e.keyCode == 81 && e.type == KeyboardEvent.KEY_UP) {
			credits.visible = !credits.visible;
			if (credits.visible) keymap.visible = false;
			return;
		}
		if (e.charCode == 0 && e.keyCode == 123 && e.type == KeyboardEvent.KEY_UP) {
			debugTextField.visible = !debugTextField.visible;
			return;
		}
		if (e.charCode == 0) return;
		
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
}