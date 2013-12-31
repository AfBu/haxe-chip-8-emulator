package com.darkyork.chip8;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.Font;
import openfl.Assets;

/**
 * ...
 * @author Petr Kratina
 */
class Menu extends Sprite
{

	public var title:TextField;
	public var description1:TextField;
	public var description2:TextField;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	public function init(e:Event)
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		var font:Font = Assets.getFont("data/NovaMono.ttf");
		var textFormatTitle:TextFormat = new TextFormat(font.fontName, 14, 0xFFFFFF, true, false, false, "", "", TextFormatAlign.CENTER, 0, 0, 0, 0);
		var textFormatDescription:TextFormat = new TextFormat(font.fontName, 14, 0xFFFFFF, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);

		title = new TextField();
		title.defaultTextFormat = textFormatTitle;
		title.x = 96;
		title.y = 90;
		title.width = 64 * 8;
		title.text = "CHIP-8 Emulator\n===================";
		title.selectable = false;
		
		description1 = new TextField();
		description1.defaultTextFormat = textFormatDescription;
		description1.x = 96;
		description1.y = 145;
		description1.width = 64 * 8;
		description1.text = "ESC - Show/hide this menu\n"
						  + "F1  - Show key map"
						  ;
		description1.selectable = false;
						 
		description2 = new TextField();
		description2.defaultTextFormat = textFormatDescription;
		description2.x = 96 + 32 * 8;
		description2.y = 145;
		description2.width = 64 * 8;
		description2.text = "F10 - Restart current ROM\n"
						  + "F2  - Show credits and specs"
						  ;
		description2.selectable = false;
						 
		addChild(title);
		addChild(description1);
		addChild(description2);
	}
	
}