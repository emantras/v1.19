package com.learning.atoz.storycreation.view.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class BookTitle extends MovieClip
	{
		public function BookTitle()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		
		private function OnInit(evt:Event):void
		{		
			
			//BtnDragger.Target=this;
			//BtnResizer.visible=false;
			BtnDragger.addEventListener(MouseEvent.MOUSE_DOWN,OnDragDown);
			BtnDragger.buttonMode=true;
			BtnDragger.visible=false;
			
			BtnResizer.addEventListener(MouseEvent.MOUSE_DOWN,OnResizeDown);
			BtnResizer.buttonMode=true;
			BtnResizer.visible=false;
			
			txtbookTitle.mouseWheelEnabled = true;
			
		}
		
		
		private function OnResizeDown(evt:MouseEvent):void
		{			
			var pt:Point=new Point(BtnDragger.x,BtnDragger.y);
			pt=localToGlobal(pt);
			pt.x-=245;
			pt.y-=60;
			var w:int=580-(pt.x);
			var h:int=580-(pt.y+BtnResizer.height);
			//trace(BtnDragger.x+","+BtnDragger.y+","+w+","+h)
			//trace(pt.x+","+pt.y+","+w+","+h)
			BtnResizer.startDrag(false,new Rectangle(BtnDragger.x,BtnDragger.y,w,h));
			//BtnResizer.startDrag();
			this.addEventListener(Event.ENTER_FRAME,OnResizerEnterFrame);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnResizerMouseUp);
			
		}
		var xp:int=0;
		var yp:int=0;
		var w:int=0;
		var h:int=0;
		private function OnResizerEnterFrame(evt:Event):void
		{			
			w=(BtnResizer.x-booktitlebg.x);
			h=(BtnResizer.y-booktitlebg.y);
			
			booktitlebg.width=w;
			booktitlebg.height=h;
			
			txtbookTitle.x=0;
			txtbookTitle.y=0;
			txtbookTitle.width=(w);
			txtbookTitle.height=(h);	
			//trace("w="+w+",h="+h+",txtbookTitle.width="+txtbookTitle.width+",txtbookTitle.height="+txtbookTitle.height);
			
			
		}
		
		public function update(w:int,h:int)
		{
			if(w>0 && h>0)
			{
				booktitlebg.width=w;
				booktitlebg.height=h;
				
				BtnResizer.x=booktitlebg.x+booktitlebg.width;
				BtnResizer.y=booktitlebg.y+booktitlebg.height;
							
				
				txtbookTitle.x=0;
				txtbookTitle.y=0;
				txtbookTitle.width=(w);
				txtbookTitle.height=(h);	
			}
		}
		
		public function Refresh()
		{
			w=(BtnResizer.x-booktitlebg.x);
			h=(BtnResizer.y-booktitlebg.y);
			
			booktitlebg.width=w;
			booktitlebg.height=h;
			
			txtbookTitle.x=0;
			txtbookTitle.y=0;
			txtbookTitle.width=(w);
			txtbookTitle.height=(h);	
		}
		
		private function OnResizerMouseUp(evt:MouseEvent):void
		{			
			BtnResizer.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,OnResizerEnterFrame);
			
		}
		
		private function OnDragDown(evt:MouseEvent):void
		{
			trace("bookTitle=>OnDragDown=>"+this.parent.name+","+this.parent.width+","+this.parent.height)
			var w:int=580;
			var h:int=580;
			w-=this.width;
			h-=this.height;
			this.startDrag(false,new Rectangle(BtnDragger.width,0,w,h));
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnDragMouseUp);			
		}
			
		
		private function OnDragMouseUp(evt:MouseEvent):void
		{			
			this.stopDrag();			
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnDragMouseUp);
		}
	}
}