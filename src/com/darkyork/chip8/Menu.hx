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
	public var description:TextField;
	
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
		title.y = 100;
		title.width = 64 * 8;
		title.text = "CHIP-8 Emulator\n===================";
		title.selectable = false;
		
		description = new TextField();
		description.defaultTextFormat = textFormatDescription;
		description.x = 96;
		description.y = 160;
		description.width = 64 * 8;
		description.text = "ESC - Show/hide this menu\n"
						 + "F1  - Show key map\n"
						 + "F2  - Show credits and specs\n"
						 + "F10 - Restart current ROM"
						 ;
		description.selectable = false;
						 
		addChild(title);
		addChild(description);
	}
	
}