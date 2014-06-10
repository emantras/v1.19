package  com.learning.atoz.storycreation.view.components.textcallout
{
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import com.learning.atoz.storycreation.view.components.BtnDragger;
	import com.learning.atoz.storycreation.view.components.BtnResizer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;	
	import flash.text.engine.TextLine;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	
	/*
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import com.learning.atoz.storycreation.view.components.BtnDragger;
	import com.learning.atoz.storycreation.view.components.BtnResizer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.engine.TextLine;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	*/

	public class TextCallout1 extends MovieClip
	{
		public var data:Object;
		private var curpos:Object={x:10,y:10};
		private var readOnly:Boolean;
		public function TextCallout1(obj:Object)
		{
			data=obj;			
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		public function set ReadOnly(r:Boolean):void
		{
			readOnly=r;
			if(readOnly==true)
			{
				textbox.removeEventListener(MouseEvent.CLICK,OnTextBoxClicked);
			}
			else
			{
				textbox.addEventListener(MouseEvent.CLICK,OnTextBoxClicked);
			}
		}
		
		public function get ReadOnly():Boolean
		{
			return readOnly;
		}
		
		private function OnInit(evt:Event):void
		{			
			
			//BtnDragger.Target=this;
			
			BtnDragger.addEventListener(MouseEvent.MOUSE_DOWN,OnDragDown);
			BtnDragger.buttonMode=true;
			
			BtnResizer.addEventListener(MouseEvent.MOUSE_DOWN,OnResizeDown);
			BtnResizer.buttonMode=true;
			
			BtnClose.addEventListener(MouseEvent.MOUSE_DOWN,OnDelete);
			BtnClose.buttonMode=true;
			
			
			
			textbox.border=false;
			
			ShowControls(false);
			
			
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,OnStageMouseDown);
		}
		
		
		public function ShowControls(bshow:Boolean):void
		{
			if(bshow)
			{
				BtnDragger.visible=true;
				BtnResizer.visible=true;
				BtnClose.visible=true;
				
				textbox.selectable=true;
				textbox.type="input";
				textbox.textFlow.interactionManager.setFocus();
			}
			else
			{
				BtnDragger.visible=false;
				BtnResizer.visible=false;
				BtnClose.visible=false;
				
				textbox.selectable=false;
				textbox.type="dynamic";
								
			}
		}
		
		private function OnTextBoxClicked(evt:MouseEvent):void
		{			
			ShowControls(true);
			dispatchEvent(new ObjectEvent("SHOW_TEXTTOOL_FROMCALLOUTTEXT",{target:textbox,xp:this.x,yp:this.y},false,true));
		
		}
		
		private function OnStageMouseDown(evt:MouseEvent):void
		{	
			if(evt.target is TextLine)
			{
				ShowControls(true);
				
			}
			else if(evt.target is SimpleButton)
			{
				ShowControls(true);
			}
			/*else if(evt.target is BtnDragger)
			{
				ShowControls(true);
			}
			else if(evt.target is BtnResizer)
			{
				ShowControls(true);
			}*/
			else if(evt.target is MovieClip && evt.target.name=="txtCalloutBG1")
			{
				ShowControls(true);
			}
			else if(evt.target is stageWhiteBG)
			{
				ShowControls(false);
			}
			else if(evt.target is SwfBGComponent)
			{
				ShowControls(false);
			}
			else
			{
				//ShowControls(false);
				if(evt.target.name=="BtnDragger" || evt.target.name=="BtnResizer")
				{
					ShowControls(true);
				}
			}
			
			//this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,OnStageMouseDown);
			
		}
		
		private function OnDelete(evt:MouseEvent):void
		{	
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,OnStageMouseDown);	
			ShowControls(true);
			dispatchEvent(new ObjectEvent("DELETE_CALLOUT_TEXT",data,false,true));
		}
		
		private function OnResizeDown(evt:MouseEvent):void
		{
			ShowControls(true);
			dispatchEvent(new ObjectEvent("CLOSE_TEXTTOOL_FROM_CALLOUT_TEXT",null,false,true));
			BtnResizer.startDrag();
			this.addEventListener(Event.ENTER_FRAME,OnResizerEnterFrame);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnResizerMouseUp);
			
		}
		var xp:int=0;
		var yp:int=0;
		var w:int=0;
		var h:int=0;
		private function OnResizerEnterFrame(evt:Event):void
		{
			ShowControls(true);
			w=(BtnResizer.x-txtCalloutBG1.x);
			h=(BtnResizer.y-txtCalloutBG1.y);
			
			txtCalloutBG1.width=w;
			txtCalloutBG1.height=h;
			BtnClose.x=(txtCalloutBG1.x+txtCalloutBG1.width);
			BtnClose.y=0;
			textbox.x=10;
			textbox.y=10;
			textbox.width=(w-20);
			textbox.height=(h-20);			
		}
		
		private function OnResizerMouseUp(evt:MouseEvent):void
		{			
			BtnResizer.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,OnResizerEnterFrame);
			ShowControls(false);
		}
		//---------------		
		private function OnDragDown(evt:MouseEvent):void
		{
			ShowControls(true);
			dispatchEvent(new ObjectEvent("CLOSE_TEXTTOOL_FROM_CALLOUT_TEXT",null,false,true));
			curpos.x=this.x;
			curpos.y=this.y;
			this.startDrag();
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnDragMouseUp);
			this.addEventListener(Event.ENTER_FRAME,OnDragEnterFrame);
		}
		
		private function OnDragEnterFrame(evt:Event):void
		{
			ShowControls(true);
		}
		
		private function OnDragMouseUp(evt:MouseEvent):void
		{			
			this.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,OnDragEnterFrame);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnDragMouseUp);
			
			if(this.x<0 || this.y<0 || this.x>=data.stagew || this.y>=data.stageh)
			{
				this.x=curpos.x;
				this.y=curpos.y;
			}
			
			ShowControls(false);
			
		}
		
		public function Resize(w:Number,h:Number):void
		{
			txtCalloutBG1.width=w;
			txtCalloutBG1.height=h;
			BtnClose.x=(txtCalloutBG1.x+txtCalloutBG1.width);
			BtnClose.y=0;
			textbox.x=10;
			textbox.y=10;
			textbox.width=(w-20);
			textbox.height=(h-20);
			
			BtnResizer.x=txtCalloutBG1.x+txtCalloutBG1.width;
			BtnResizer.y=txtCalloutBG1.y+txtCalloutBG1.height;
			
		}
		
		public function getWidth():Number
		{
			return txtCalloutBG1.width;
		}
		
		public function getHeight():Number
		{
			return txtCalloutBG1.height;
		}



	}
	
}
