package com.learning.atoz.storycreation.view.components
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.geom.Matrix;	
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;

	public class CanvasBG extends MovieClip
	{
		private var ldr:Loader = new Loader();		
		private var url:String;
		private var stagew:int=0;
		private var stageh:int=0;
		private var swfBG:SwfBGComponent;
		private var loadingclipObj:*=null;
		
		//-----------------------------------------------------		
		public function CanvasBG()
		{			
			swfBG=new SwfBGComponent();
			this.addChild(swfBG);
		}		
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//loading background swf
		//-----------------------------------------------------		
		public function loadBGImage(src:String,_stagew:int,_stageh:int):void
		{  
			   clearBG();			   
			   loadingclipObj= this.parent.getChildByName("loadingBGClip");
			   if(loadingclipObj!=null)
			   {
				   loadingclipObj.txtStatus.text="";
				   loadingclipObj.visible=true;
			   }			   
			   stagew=_stagew;
			   stageh=_stageh;			
			   url=src;
			   swfBG.loadSWF(url,stagew,stageh,loadingclipObj);
			  
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//clearing the background swf
		//-----------------------------------------------------		
		public function clearBG()
		{						
			trace("CanvasBG=>clearBG=>"+swfBG);
			if(swfBG!=null)
			{
				swfBG.clearSWF();
			}
		}		
		//-----------------------------------------------------		

	}
	
}
