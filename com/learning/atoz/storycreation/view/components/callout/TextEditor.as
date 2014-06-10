package com.learning.atoz.storycreation.view.components.callout
{	
	import com.learning.atoz.storycreation.view.components.callout.TextTool;
	import flash.display.Sprite;
	import fl.text.TLFTextField;
	import flash.events.Event;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.conversion.ConversionType;
	
	/*
	import com.learning.atoz.storycreation.view.components.callout.TextTool;
	import flash.display.Sprite;
	import fl.text.TLFTextField;
	import flash.events.Event;
	*/

	public class TextEditor extends Sprite
	{
		private var editorbg:Sprite;
		private var editor:TLFTextField;
		private var editorTool:TextTool;
		private var _w:int=0;
		private var _h:int=0;
		private var bgcolor:uint=0x999999;
		private var bgalpha:Number=0.3;
		public function TextEditor(w:int=200,h:int=50)
		{
			_w=w;
			_h=h;
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		public function OnInit(evt:Event)
		{
			trace("TextEditor=>OnInit");
			editorbg=new Sprite();
			//this.addChild(editorbg);
			
			editor=new TLFTextField();
			editor.name="Editor";
			trace("TextEditor=>OnInit2=>"+editor);
			editor.width=(_w-10);
			editor.height=(_h-10);
			editor.x=5;
			editor.y=5;
			editor.type="input";
			editor.background=true;
			editor.backgroundColor=0xFFFF00;
			editor.backgroundAlpha=0.5;
			
			editor.border=false;
			editor.borderColor=0x333333;
			this.addChild(editor);
			
			
			editorTool=new TextTool();
			editorTool.name="TextTool";
			editorTool.setTarget(editor);
			editorTool.y=-10;
			this.addChild(editorTool);
						
			updateBG();
		}
		
		private function updateSize(w:int,h:int)
		{
			_w=w;
			_h=h;
			updateBG();
		}
		
		private function updateBG()
		{
			editorbg.graphics.clear();
			editorbg.graphics.beginFill(bgcolor,bgalpha);
			editorbg.graphics.drawRect(0,0,_w,_h);
			editorbg.graphics.endFill();
			
		}
		
		public function getTextTool():TextTool
		{
			var teobj:*=this.getChildByName("TextTool");	
			return teobj;
		}
		
		public function getTLFText()
		{
			//var tlftext:String=TextConverter.export(editor.textFlow,TextConverter.TEXT_LAYOUT_FORMAT,ConversionType.STRING_TYPE).toString();
			//trace(tlftext);
			var teobj:*=this.getChildByName("Editor");							
			trace("getTLFText1=>"+teobj);			
			if(teobj=null)
			{								
				trace("getTLFText2=>"+teobj.text);
				trace("getTLFText3=>"+teobj.tlfMarkup);
				
			}
			
		}
		
		

	}
	
}
