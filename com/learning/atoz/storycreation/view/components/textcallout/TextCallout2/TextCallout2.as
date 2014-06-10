package com.learning.atoz.storycreation.view.components.textcallout.TextCallout2
{
	
	import com.learning.atoz.storycreation.view.components.BtnDeleteCalloutText;
	import com.learning.atoz.storycreation.view.components.BtnDragger;
	import com.learning.atoz.storycreation.view.components.BtnResizer;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import flash.display.Sprite;
	
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.edit.SelectionState;
	import flash.display.SimpleButton;	
	import flash.text.engine.TextLine;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	
	
	/*
	import com.learning.atoz.storycreation.view.components.BtnDeleteCalloutText;
	import com.learning.atoz.storycreation.view.components.BtnDragger;
	import com.learning.atoz.storycreation.view.components.BtnResizer;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import flash.display.Sprite;
	
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.edit.SelectionState;
	import flash.display.SimpleButton;	
	import flash.text.engine.TextLine;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	*/
	
	public class TextCallout2 extends Sprite
	{
		private var topLeft:BtnDragger;
		private var topRight:BtnDeleteCalloutText;
		private var bottomLeft:Dot;
		private var bottomRight:BtnResizer;
		private var curvetopLeft:Dot;
		private var curvetopRight:Dot;
		private var curveBottom:Dot;
		private var curveClip:Sprite;
		private var w:int=250;
		private var h:int=50;
		private var current:Sprite=null;
		private var curveWidth:int=30;
		private var curveHeight:int=20;
		
		
		private var borderColor:uint=0x666666;
		private var fillcolor:uint=0xffffff;
		private var prevobj:Object={x:0,y:0};
		public var textbox:TLFTextField;
		
		private var xdiff:Number;
		private var ydiff:Number;
		
		
		public var data:Object;
		private var curpos:Object={x:10,y:10};
		private var readOnly:Boolean;
		public function TextCallout2(obj:Object)
		{
			data=obj;
			
			topLeft=new BtnDragger();
			topLeft.name="topLeft";
			topLeft.buttonMode=true;
			//topLeft.Target=this;
			
			topRight=new BtnDeleteCalloutText();
			topRight.buttonMode=true;
			topRight.name="topRight";
			
			bottomLeft=new Dot();
			bottomLeft.name="bottomLeft";
			
			bottomRight=new BtnResizer();
			bottomRight.buttonMode=true;
			bottomRight.name="bottomRight";
			
			this.addChild(topLeft);
			this.addChild(topRight);
			this.addChild(bottomLeft);
			this.addChild(bottomRight);
			
			
			curveClip=new Sprite();
			curveClip.name="curveClip";			
			this.addChild(curveClip);
			
			
			curvetopLeft=new Dot();
			curvetopLeft.name="curvetopLeft";
			curveClip.addChild(curvetopLeft);
			
			curvetopRight=new Dot();
			curvetopRight.name="curvetopRight";
			curveClip.addChild(curvetopRight);
			
			curveBottom=new Dot();
			curveBottom.name="curveBottom";
			curveBottom.buttonMode=true;
			curveClip.addChild(curveBottom);
			
			
			textbox=new TLFTextField();
			textbox.background=true;
			textbox.type="input";
			textbox.multiline=true;
			textbox.wordWrap=true;			
			this.addChild(textbox);
			
			
			AddDragEvent(topLeft);
			//AddDragEvent(topRight);
			AddDragEvent(bottomLeft);
			AddDragEvent(bottomRight);
			AddDragEvent(curveBottom);
			
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
			topRight.addEventListener(MouseEvent.MOUSE_DOWN,OnDelete);
			
			textbox.text="Enter your text here";
			
			
			
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
		
		public function ShowControls(bshow:Boolean):void
		{
			if(bshow)
			{
				topLeft.visible=true;
				bottomRight.visible=true;
				curveBottom.visible=true;
				topRight.visible=true;
				
				textbox.selectable=true;
				textbox.type="input";
				textbox.textFlow.interactionManager.setFocus();				
				
			}
			else
			{
				topLeft.visible=false;
				bottomRight.visible=false;
				curveBottom.visible=false;
				topRight.visible=false;
				
				
				textbox.selectable=false;
				textbox.type="dynamic";
			}
		}
		
		
		private function OnTextBoxClicked(evt:MouseEvent):void
		{			
			ShowControls(true);
			dispatchEvent(new ObjectEvent("SHOW_TEXTTOOL_FROMCALLOUTTEXT",{target:textbox,xp:this.x,yp:this.y},false,true));
			
			//this code is moved to OnInit
			//this.stage.addEventListener(MouseEvent.MOUSE_DOWN,OnStageMouseDown);
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
			}
			//this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,OnStageMouseDown);
			
		}
		
		
		private function OnDelete(evt:MouseEvent):void
		{			
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,OnStageMouseDown);	
			ShowControls(true);
			dispatchEvent(new ObjectEvent("DELETE_CALLOUT_TEXT",data,false,true));
		}
		
		private function OnInit(evt:Event):void
		{
		
			topLeft.x=0;
			topLeft.y=0;
			
			topRight.x=(w);
			topRight.y=0;
			
			bottomLeft.x=0;
			bottomLeft.y=(h);			
			
			bottomRight.x=(w);
			bottomRight.y=(h);			
						
			curveClip.x=bottomLeft.x+25;
			curveClip.y=bottomLeft.y;			
			
			curvetopLeft.x=0;
			curvetopLeft.y=0;
			
			curvetopRight.x=curveWidth;
			curvetopRight.y=0;
			
			curveBottom.x=-(curveWidth);
			curveBottom.y=(curveHeight);
						
			
			bottomLeft.visible=false;
			//topRight.visible=false;
			curvetopLeft.visible=false;
			curvetopRight.visible=false;
						
			xdiff=(topRight.x-topLeft.x);
			ydiff=(bottomRight.y-topRight.y);
			textbox.x=topLeft.x+10;
			textbox.y=topLeft.y+10;
			textbox.width=(xdiff-20);
			textbox.height=(ydiff-20);
						
			//---------------
			var sel:SelectionState = new SelectionState(textbox.textFlow, 0, textbox.text.length);
			var editManager:EditManager = textbox.textFlow.interactionManager as EditManager;
			var txtLayFmt:TextLayoutFormat=editManager.getCommonCharacterFormat() as TextLayoutFormat;						
			txtLayFmt.fontFamily = "Arial";
			txtLayFmt.fontSize = 20;
			txtLayFmt.color=0x0000CC;
			txtLayFmt.textAlign="center";
			editManager.applyLeafFormat(txtLayFmt,sel);
			//---------------			
			ReDraw();
			
			ShowControls(false);			
									
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,OnStageMouseDown);
		}
		
		private function ReDraw():void
		{			
			var gr:Graphics=this.graphics;
			gr.clear();
			
			gr.lineStyle(2,borderColor,1.0);
			gr.beginFill(fillcolor,1.0);
			gr.moveTo(topLeft.x,topLeft.y);
			gr.lineTo(topRight.x,topRight.y);
			gr.lineTo(bottomRight.x,bottomRight.y);
			gr.lineTo(bottomLeft.x,bottomLeft.y);						
			gr.endFill();
			
			
			var gr2:Graphics=curveClip.graphics;
			gr2.clear();
			
			
			gr2.beginFill(fillcolor,1.0);
			
			gr2.lineStyle(2,fillcolor,1.0);
			gr2.moveTo(curvetopLeft.x,curvetopLeft.y);						
			gr2.lineTo(curvetopRight.x,curvetopRight.y);
			
			gr2.lineStyle(2,borderColor,1.0);
			gr2.lineTo(curveBottom.x,curveBottom.y);			
			
			gr2.endFill();
			
		}
		
		private function AddDragEvent(target:Sprite):void
		{
			if(target!=null)
			{
				target.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDown);
			}
		}
		
		private function OnMouseDown(evt:MouseEvent):void
		{
			current=evt.currentTarget as Sprite;
						
			
			if(current!=null)
			{
				prevobj.x=current.x;
				prevobj.y=current.y;
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE,OnMouseMove);
				this.stage.addEventListener(MouseEvent.MOUSE_UP,OnStageMouseUp);
			
				if(current.name=="topLeft")
				{
					this.addEventListener(Event.ENTER_FRAME,OnDragEnterFrame);
					current=this;
					current.startDrag();
				}
				else if(current.name=="topRight")
				{
					
				}
				else if(current.name=="bottomLeft")
				{
					this.addEventListener(Event.ENTER_FRAME,OnDragEnterFrame);
					current.startDrag();
				}
				else if(current.name=="bottomRight")
				{
					this.addEventListener(Event.ENTER_FRAME,OnDragEnterFrame);
					current.startDrag();
				}
				else if(current.name=="curveBottom")
				{
					this.addEventListener(Event.ENTER_FRAME,OnDragEnterFrame);
					current.startDrag();
				}
			}
			
			
		}
		
		
	
	
		private function OnDragEnterFrame(evt:Event):void
		{
			//ShowControls(true);
		}
		
		private function OnMouseMove(evt:MouseEvent):void
		{
			if(current!=null)
			{
				if(current.name=="topLeft")
				{					
					topRight.y=topLeft.y;
					bottomLeft.x=topLeft.x;
					
					curveClip.x=bottomLeft.x+25;
					curveClip.y=bottomLeft.y;
					
				}
				else if(current.name=="topRight")
				{
					/*var xp:Number=topRight.x+curveWidth;
					if(xp<(curveClip.x+curveWidth))
					{
						
					}
					else
					{
						topLeft.y=topRight.y;
						bottomRight.x=topRight.x;
						
						curveClip.x=bottomLeft.x+25;
						curveClip.y=bottomLeft.y;
					}*/
				}
				else if(current.name=="bottomLeft")
				{
					/*bottomRight.y=bottomLeft.y;
					topLeft.x=bottomLeft.x;
					
					curveClip.x=bottomLeft.x+25;
					curveClip.y=bottomLeft.y;*/
				}
				else if(current.name=="bottomRight")
				{
					
					var xp:Number=bottomRight.x+curveWidth;
					var curveright:Number=(curveClip.x+curveClip.width);
					if(xp<=curveright)
					{
						curveClip.visible=false;
					}
					else if(bottomRight.y<=topLeft.y)
					{
						curveClip.visible=false;
					}
					else
					{
						curveClip.visible=true;
					}
					
					
					
					bottomLeft.y=bottomRight.y;
					topRight.x=bottomRight.x;
					
					curveClip.x=bottomLeft.x+25;
					curveClip.y=bottomLeft.y;
					
					
					xdiff=(topRight.x-topLeft.x);
					ydiff=(bottomRight.y-topRight.y);
					textbox.x=topLeft.x+10;
					textbox.y=topLeft.y+10;
					textbox.width=(xdiff-20);
					textbox.height=(ydiff-20);
				}
				else if(current.name=="curveBottom")
				{
					
				}
				else
				{
					
				}
				
				ReDraw();
			}
			
		}
		
		private function OnStageMouseUp(evt:MouseEvent):void
		{			
			this.removeEventListener(Event.ENTER_FRAME,OnDragEnterFrame);
			if(current!=null)
			{				
				current.stopDrag();				
			}
			
			if(current!=null)
			{
				if(current.name=="topLeft")
				{
									
				}
				else if(current.name=="topRight")
				{
					
				}
				else if(current.name=="bottomLeft")
				{
					
				}
				else if(current.name=="bottomRight")
				{
					if(bottomRight.y<=topLeft.y)
					{
						current.x=prevobj.x;
						current.y=prevobj.y;	
						
						bottomLeft.y=bottomRight.y;
						topRight.x=bottomRight.x;
						
						curveClip.visible=true;
						
						curveClip.x=bottomLeft.x+25;
						curveClip.y=bottomLeft.y;
						
						
						xdiff=(topRight.x-topLeft.x);
						ydiff=(bottomRight.y-topRight.y);
						textbox.x=topLeft.x+10;
						textbox.y=topLeft.y+10;
						textbox.width=(xdiff-20);
						textbox.height=(ydiff-20);
					}
				}
				else if(current.name=="curveBottom")
				{
					if((current.y+curveClip.y)<=(bottomLeft.y+10))
					{
						current.x=prevobj.x;
						current.y=prevobj.y;						
					}
				}
			}
			ReDraw();
			current=null;
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,OnMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnStageMouseUp);
		}
		
		
		public function Resize(w:Number,h:Number,curvebottomx:Number,curvebottomy:Number):void
		{	
			
			topLeft.x=0;
			topLeft.y=0;
			
			topRight.x=(w);
			topRight.y=0;
			
			bottomLeft.x=(0);
			bottomLeft.y=(h);			
			
			bottomRight.x=(w);
			bottomRight.y=(h);
			
			curveClip.x=bottomLeft.x+25;
			curveClip.y=bottomLeft.y;			
			
			curvetopLeft.x=0;
			curvetopLeft.y=0;
			
			curvetopRight.x=curveWidth;
			curvetopRight.y=0;
			
			curveBottom.x=curvebottomx;//-(curveWidth);
			curveBottom.y=curvebottomy;//(curveHeight);		
					
			
			xdiff=(topRight.x-topLeft.x);
			ydiff=(bottomRight.y-topRight.y);
			textbox.x=topLeft.x+10;
			textbox.y=topLeft.y+10;
			textbox.width=(xdiff-20);
			textbox.height=(ydiff-20);
			ReDraw();
			
		}
		
				
		public function getWidth():Number
		{		
			return (topRight.x-topLeft.x);
		}
		
		public function getHeight():Number
		{
			return (bottomRight.y-topRight.y);
		}
		
		public function getCurveBottomX():Number
		{		
			return curveBottom.x;
		}
		
		public function getCurveBottomY():Number
		{		
			return curveBottom.y;
		}

	}
	
}
