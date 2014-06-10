package com.learning.atoz.storycreation.view.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	/*
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	*/

	/*
		SwfBGComponent is used to load and display backgorund swf of the page
	*/
	
	public class SwfBGComponent extends Sprite
	{
		private var swfLoader:Loader;
		private var swfContent:Sprite;
		private var defWidth:int = 0;
		private var defHeight:int = 0;
		private var loadingclipObj:* = null;
		private var swfContentBGColor:Sprite;
		
		//-----------------------------------------------------
		public function SwfBGComponent()
		{
			
		}
		//-----------------------------------------------------
		//-----------------------------------------------------
		public function loadSWF(path:String,defw:int=0,defh:int=0,_loadingclipObj:*=null):void
		{			
			loadingclipObj = _loadingclipObj;
			defWidth = defw;
			defHeight = defh;

			var _request:URLRequest = new URLRequest  ;
			_request.url = path;

			swfLoader = new Loader  ;
			initializeEventListeners(swfLoader.contentLoaderInfo);
			//swfLoader.load(_request);
			
			
			
			
			if(ApplicationConstants.SAMEDOMAIN=="YES")
			{
				swfLoader.load(_request);
			}
			else
			{
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				loaderContext.securityDomain = SecurityDomain.currentDomain;// Sets the security context to resolve Error # 2121
				swfLoader.load(_request,loaderContext);
			}
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		private function initializeEventListeners(_dispatcher:IEventDispatcher):void
		{
			_dispatcher.addEventListener(Event.COMPLETE,onSWFComplete);
			_dispatcher.addEventListener(ProgressEvent.PROGRESS,onSWFProgress);
			_dispatcher.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		private function onIOError(evt:IOErrorEvent):void
		{
			trace("onIOError:" + evt.text);
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		function onSWFComplete(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE,onSWFComplete);
			event.target.removeEventListener(ProgressEvent.PROGRESS,onSWFProgress);

			if(this.numChildren==2)
			{
				removeChildAt(1);
			}
			
			swfContent = event.target.content;
			swfContent.addEventListener("close",unloadSWF);
						
			if (defWidth > 0 && defHeight > 0)
			{
				swfContent.width = defWidth;
				swfContent.height = defHeight;
			}
			else
			{
				swfContent.scaleX = 0.5;
				swfContent.scaleY = 0.5;
			}

			if (loadingclipObj != null)
			{
				loadingclipObj.txtStatus.text = "completed";
				loadingclipObj.visible = false;
			}			

						
			trace("SWFBGComponent=>onSWFComplete=>numChildren=>"+this.numChildren);
			var bgcolor:*=this.getChildByName("bgcolorclip");
			if(bgcolor==null)
			{
				swfContentBGColor=new Sprite();
				swfContentBGColor.name="bgcolorclip";
				addChildAt(swfContentBGColor,0);
			}			
			
			swfContentBGColor.graphics.clear();
			swfContentBGColor.graphics.beginFill(0xFFFFFF,1.0);
			swfContentBGColor.graphics.drawRect(0,0,580,580);
			swfContentBGColor.graphics.endFill();
			
			
			addChildAt(swfContent,1);
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		function onSWFProgress(event:ProgressEvent):void
		{
			var percent:int = event.bytesLoaded / event.bytesTotal * 100;
			if (loadingclipObj != null)
			{
				loadingclipObj.txtStatus.text = "Loading ... " + percent + "%";
			}
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		private function unloadSWF(event:Event):void
		{			
			swfLoader.unloadAndStop();
			removeChild(swfContent);
			swfContent = null;
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		public function clearSWF()
		{
			trace("clearSWF=>1");
			if (swfLoader != null)
			{
				trace("clearSWF=>2");
				
						
				/*var obj:*=this.getChildByName("bgholder");
				trace("clearSWF=>4=>"+obj);
				if(obj!=null)
				{
					obj.graphics.beginFill(0xffff00,0.5);
					obj.graphics.drawRect(0,0,580,580);
					obj.graphics.endFill();
				}*/
				
				if (swfContent != null)
				{
					trace("clearSWF=>4");
					removeChild(swfContent);		
					trace("clearSWF=>5");
					swfContent = null;
					//swfContent=new Sprite();
					trace("clearSWF=>6");
				}
				trace("clearSWF=>3");		
				swfLoader.unloadAndStop(true);
				
			}
					
			
		}
		//-----------------------------------------------------

	}

}