package com.learning.atoz.storycreation.view.components
{
	import flash.display.Sprite;
	import flash.display.Sprite;


	/*
		Canvas sprite is used to load backgrounds,characters,objects etc
	*/
	
	public class Canvas extends Sprite
	{
		public var contentWidth:int=560;
		public var contentHeight:int=560;
		
		
		/*
		loadingBGClip
		stageContent
		maskClip
		stagebgimage
		*/
		//-----------------------------------------------------		
		public function Canvas()
		{			
			maskClip.visible=false;						
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//To clear bg from the canvas
		//-----------------------------------------------------		
		public function clearBG():void
		{			
			trace("clearBG=>1");
			var obj:MovieClip=this.getChildByName("stagebgimage") as MovieClip;						
			trace("clearBG=>2=>"+obj);
			if(obj!=null)
			{
				var obj2:MovieClip=this.parent.getChildByName("stageBG") as MovieClip;		
				trace("clearBG=>3=>"+obj2);
				if(obj2!=null)
				{
					obj2.visible=true;
				}
				obj.clearBG();
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//to clear all the objects like bg,character,objects etc
		//-----------------------------------------------------		
		public function clearStage():void
		{
			clearBG();
			/*while(stageContent.numChildren>0)
			{
				stageContent.removeChildAt(0);
			}*/
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------		
		//to clear all the objects like bg,character,objects etc
		//-----------------------------------------------------		
		public function clearChrObjects():void
		{			
			//skip maskclip at index 0
			while(stageContent.numChildren>1)
			{
				stageContent.removeChildAt(1);
			}
		}
		//-----------------------------------------------------	
		
		//-----------------------------------------------------		
		//to add bg of the current page
		//-----------------------------------------------------		
		public function loadBGImage(url:String,w:int,h:int):void
		{			
			var obj:MovieClip=this.getChildByName("stagebgimage") as MovieClip;			
			if(obj!=null)
			{
				//maskClip.visible=true;
				//maskClip.width=w;
				//maskClip.height=h;
				//obj.mask=maskClip;
				
				obj.clearBG();
				obj.loadBGImage(url,w,h);
			}		
		}
		//-----------------------------------------------------		

	}
	
}

