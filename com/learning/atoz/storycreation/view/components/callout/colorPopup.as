package com.learning.atoz.storycreation.view.components.callout
{
	import flash.display.MovieClip;	
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class colorPopup extends MovieClip
	{
		private var colarr:Array=new Array();	
		public var selectedColor:uint;
		public function colorPopup()
		{
			
			colarr=new Array();
			colarr.push(0x000000);
			//colarr.push(0x808080);
			colarr.push(0xC0C0C0);
			//colarr.push(0xFFFFFF);
			colarr.push(0x800000);
			//colarr.push(0xFF0000);
			colarr.push(0x808000);
			//colarr.push(0xFFFF00);
			colarr.push(0x008000);
			//colarr.push(0x00FF00);
			colarr.push(0x008080);
			//colarr.push(0x00FFFF);
			colarr.push(0x000080);
			//colarr.push(0x0000FF);
			colarr.push(0x800080);
			//colarr.push(0xFF00FF);
			colarr.push(0xFFFFFF);
			colarr.push(0x0D98BA);
			colarr.push(0xCEFF1D);
			colarr.push(0xFFA343);
			colarr.push(0x714B23);
			colarr.push(0xFC2847);
			colarr.push(0x1F75FE);
			colarr.push(0xCD9575);
			
			selectedColor=colarr[0];
			this.addEventListener(Event.ADDED_TO_STAGE,onInit);			
			selectedClip.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){
										  	colorswatch.visible=!colorswatch.visible;
										  });
		}
		
		var w:int=25;
		var h:int=20;
		private function onInit(evt:Event):void
		{
			
			colorswatch.visible=false;
			var xp:int=0;
			var yp:int=0;
			var r:int=0;
			var row:int=0;
			
			updateSelected();
					
			while(r<=colarr.length-1)			
			{
				//trace("r="+r);
				for(var c:int=0;c<2;c++)
				{
					//trace("r="+r+",c="+c);
					var cc:colorClip=new colorClip();
					cc.graphics.clear();
					cc.graphics.lineStyle(1,0x000000,1.0);
					cc.graphics.beginFill(colarr[r],1.0);
					cc.graphics.drawRect(0,0,w,h);
					cc.graphics.endFill();
					colorswatch.addChild(cc);
					cc.x=xp;
					cc.y=yp;
					cc.colorvalue=colarr[r];
					cc.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){
										selectedColor=evt.currentTarget.colorvalue;colorswatch.visible=false;updateSelected();
										dispatchEvent(new Event("COLOR_SELECTED",false,true));
										});
					cc.buttonMode=true;
					xp+=w;
					r++;
				}
				row++;
				xp=0;
				yp+=h;
				
				
			}
		}
		
		public function updateSelected()
		{
			selectedClip.graphics.clear();
			selectedClip.graphics.lineStyle(1,0x000000,0.0);
			selectedClip.graphics.beginFill(selectedColor,1.0);
			selectedClip.graphics.drawRoundRect(0,0,w-2,h,5,5);
			selectedClip.graphics.endFill();
			selectedClip.buttonMode=true;
		}

	}
	
}
