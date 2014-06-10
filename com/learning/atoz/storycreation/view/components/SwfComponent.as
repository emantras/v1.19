package com.learning.atoz.storycreation.view.components
{
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	/*
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	*/

	/*
	Swfcomponent is the actual swf loading and displaying.
	*/
	public class SwfComponent extends Sprite
	{
		private var swfLoader:Loader;
		private var swfContent:Sprite;		
		public var defWidth:int = 0;
		public var defHeight:int = 0;
		public var orgWidth:Number = 0;
		public var orgHeight:Number = 0;
		public var informWhenComplete:Function = null;
		public var resizeType:String = "FIXED";//FIXED/PROPORTIONAL
		private var loadingclipObj:* = null;
		public var selectedClip:Sprite;
		//-----------------------------------------------------		
		public function SwfComponent()
		{
						
		}
		//-----------------------------------------------------		
		public function select(sel:Boolean):void
		{
			if(sel==true)
			{				
				var selclip:*=this.getChildByName("selectedClip")
				if(selclip==null)
				{
					if(selectedClip!=null)
					{
						this.addChild(selectedClip);
					}
				}
			}
			else
			{
				var selclip2:*=this.getChildByName("selectedClip")
				if(selclip2!=null)
				{
					if(selectedClip!=null)
					{
						this.removeChild(selectedClip);
					}
				}
			}
		}
		
		//-----------------------------------------------------		
		//to load swf from the server
		//-----------------------------------------------------
		public function loadSWF(path:String,defw:int=0,defh:int=0,_loadingclipObj:*=null):void
		{			
			//trace("SwfComponent=>loadSWF=>"+path);
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

			if (loadingclipObj != null)
			{
				loadingclipObj.txtStatus.text = "";
				loadingclipObj.visible = true;
			}
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------		
		//event listeners for the swf loader
		//-----------------------------------------------------		
		private function initializeEventListeners(_dispatcher:IEventDispatcher):void
		{
			_dispatcher.addEventListener(Event.COMPLETE,onSWFComplete);
			_dispatcher.addEventListener(ProgressEvent.PROGRESS,onSWFProgress);
			_dispatcher.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//error event
		//-----------------------------------------------------
		private function onIOError(evt:IOErrorEvent):void
		{
			trace("onIOError:" + evt.text);
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------		
		//swf load complete event
		//-----------------------------------------------------		
		function onSWFComplete(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE,onSWFComplete);
			event.target.removeEventListener(ProgressEvent.PROGRESS,onSWFProgress);

			swfContent = event.target.content;
			swfContent.addEventListener("close",unloadSWF);

			orgWidth = swfContent.width;
			orgHeight = swfContent.height;


			if (loadingclipObj != null)
			{
				loadingclipObj.txtStatus.text = "";
				loadingclipObj.visible = false;
			}
			
			//Fixed thumnail size
			if (resizeType == "FIXED")
			{
				if (defWidth > 0 && defHeight > 0)
				{
					swfContent.width = defWidth;
					swfContent.height = defHeight;
				}

				swfContent.x -=  swfContent.width / 2;
				swfContent.y =  -  swfContent.height / 2;
			}//proportional thubnail size
			else if (resizeType == "PROPORTIONAL")
			{
				if (orgWidth > orgHeight)
				{
					var per:Number = defWidth / orgWidth * 100;
					var nw:Number = orgWidth * per / 100;
					var nh:Number = orgHeight * per / 100;

					swfContent.width = nw;
					swfContent.height = nh;

					swfContent.x -=  swfContent.width / 2;
					swfContent.y =  -  swfContent.height / 2;

				}
				else if (orgHeight > orgWidth)
				{
					var per2:Number = defHeight / orgHeight * 100;
					var nw2:Number = orgWidth * per2 / 100;
					var nh2:Number = orgHeight * per2 / 100;

					swfContent.width = nw2;
					swfContent.height = nh2;

					swfContent.x -=  swfContent.width / 2;
					swfContent.y =  -  swfContent.height / 2;
				}
				else
				{
					if (defWidth > 0 && defHeight > 0)
					{
						swfContent.width = defWidth;
						swfContent.height = defHeight;
					}
					swfContent.x -=  swfContent.width / 2;
					swfContent.y =  -  swfContent.height / 2;
				}

			}

			addChild(swfContent);
			
			selectedClip=new Sprite();
			selectedClip.name="selectedClip";
			selectedClip.graphics.beginFill(0xffff00,0.2);
			selectedClip.graphics.drawRect(0,0,swfContent.width,swfContent.height);
			selectedClip.graphics.endFill();
			selectedClip.x-=swfContent.width / 2;
			selectedClip.y-=swfContent.height / 2;
				
			
			dispatchEvent(new ObjectEvent("THUMB_LOAD_COMPLETED",null,false,true))
		}


		//-----------------------------------------------------		
		//while the swf is loading showing loaded status 
		//--------------------------------------------------------------
		function onSWFProgress(event:ProgressEvent):void
		{
			var percent:int = event.bytesLoaded / event.bytesTotal * 100;
			if (loadingclipObj != null)
			{
				loadingclipObj.txtStatus.text = "Loading " + percent + " %";
				loadingclipObj.visible = true;
			}
		}

		//-----------------------------------------------------		
		//unloading the swf
		//-----------------------------------------------------		
		function unloadSWF(event:Event):void
		{
			swfLoader.unloadAndStop();
			removeChild(swfContent);
			swfContent = null;
		}

		//-----------------------------------------------------		
		//triggering the unloadswf
		//-----------------------------------------------------		
		public function clearSWF()
		{
			var _closeEvent:Event = new Event("close",true,false);
			dispatchEvent(_closeEvent);

		}
		//-----------------------------------------------------		

	}

}