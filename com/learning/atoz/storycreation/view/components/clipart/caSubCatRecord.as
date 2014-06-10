package com.learning.atoz.storycreation.view.components.clipart
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;	
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	/*
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;	
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	*/

	public class caSubCatRecord extends MovieClip
	{		
		public var catid:int=0;
		public var subcatid:int=0;
		public var subcatname:String="";
		public var ThumbUrl:String="noimage.jpg";
		private var imgLoader:Loader;
		private var imgContent:Sprite;
		
		public function caSubCatRecord()
		{
			
		}	
		
		public function loadBG()
		{
			imgLoader = new Loader;			
			initializeEventListeners(imgLoader.contentLoaderInfo);
			
			var _request:URLRequest = new URLRequest;
			var arr:Array=ThumbUrl.split("/");
			var sthumb2:String=arr[arr.length-1];
			_request.url = "assets/subcat_thumb/"+sthumb2;
			
			trace(_request.url);			
			
			//imgLoader.load(_request);
			if(ApplicationConstants.SAMEDOMAIN=="YES")
			{
				imgLoader.load(_request);
			}
			else
			{
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				loaderContext.securityDomain = SecurityDomain.currentDomain;// Sets the security context to resolve Error # 2121
				imgLoader.load(_request,loaderContext);				
			}
		}
		
		private function initializeEventListeners(_dispatcher:IEventDispatcher):void
		{
			_dispatcher.addEventListener(Event.COMPLETE,onSWFComplete);
			//_dispatcher.addEventListener(ProgressEvent.PROGRESS,onSWFProgress);
			_dispatcher.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		
		private function onIOError(evt:IOErrorEvent):void
		{
			trace("error");
			ThumbUrl="noimage.jpg";
			loadBG();
		}
		
		function onSWFComplete(event:Event):void
		{
			trace("complete");
			event.target.removeEventListener(Event.COMPLETE,onSWFComplete);			
			
			event.target.content.scaleX=0.5;
			event.target.content.scaleY=0.5;
			casubcatbg.addChild(event.target.content);
			//this.addChild(event.target.content);
			
		}
		//
		
	}
}


