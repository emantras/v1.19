package  com.learning.atoz.storycreation.view.components.textcallout
{
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class _TextCallout2 extends MovieClip
	{
		public var data:Object;
		private var curpos:Object={x:10,y:10};
		
		public function _TextCallout2(obj:Object)
		{			
			data=obj;
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		private function OnInit(evt:Event):void
		{			
			BtnDragger.addEventListener(MouseEvent.MOUSE_DOWN,OnDragDown);
			BtnDragger.buttonMode=true;
			
			BtnResizer.addEventListener(MouseEvent.MOUSE_DOWN,OnResizeDown);
			BtnResizer.buttonMode=true;
			
			BtnClose.addEventListener(MouseEvent.CLICK,OnDelete);
			BtnClose.buttonMode=true;
			
			textbox.addEventListener(MouseEvent.CLICK,OnTextBoxClicked);
		}
		
		private function OnTextBoxClicked(evt:MouseEvent):void
		{			
			dispatchEvent(new ObjectEvent("SHOW_TEXTTOOL_FROMCALLOUTTEXT",{target:textbox,xp:this.x,yp:this.y},false,true));
		}
		
		private function OnDelete(evt:MouseEvent):void
		{		
			dispatchEvent(new ObjectEvent("DELETE_CALLOUT_TEXT",data,false,true));
		}
		
		private function OnResizeDown(evt:MouseEvent):void
		{
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
			
			
			callouttext2_directionclip.x=25;
			callouttext2_directionclip.y=txtCalloutBG1.y+txtCalloutBG1.height-3;
		}
		
		private function OnResizerMouseUp(evt:MouseEvent):void
		{			
			BtnResizer.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,OnResizerEnterFrame);
		}
		//---------------
		
		private function OnDragDown(evt:MouseEvent):void
		{
			dispatchEvent(new ObjectEvent("CLOSE_TEXTTOOL_FROM_CALLOUT_TEXT",null,false,true));
			curpos.x=this.x;
			curpos.y=this.y;
			this.startDrag();
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnDragMouseUp);
		}
		
		private function OnDragMouseUp(evt:MouseEvent):void
		{			
			this.stopDrag();
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnDragMouseUp);
			
			if(this.x<0 || this.y<0 || this.x>=data.stagew || this.y>=data.stageh)
			{
				this.x=curpos.x;
				this.y=curpos.y;
			}
			
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
			
			callouttext2_directionclip.x=25;
			callouttext2_directionclip.y=txtCalloutBG1.y+txtCalloutBG1.height;
			
		}



	}
	
}
