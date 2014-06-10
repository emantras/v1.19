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
	import flash.text.TextField;
	import com.learning.atoz.storycreation.UID;
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
	import flash.text.TextField;
	import com.learning.atoz.storycreation.UID;
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	*/

	/*
		SwfBGComponent is used to load and display backgorund swf of the page
	*/
	
	public class SwfCHRComponent extends Sprite
	{
		private var swfLoader:Loader;
		private var swfContent:Sprite;
		private var defWidth:int = 0;
		private var defHeight:int = 0;		
		private var loadingclipObj:* = null;
		public var itemData:Object={unqid:"",id:0,name:"",catid:0,subcatid:0,url:"",thumburl:"",type:"",xpos:0,ypos:0,width:0,height:0,rotation:0,scalex:1,scaley:1};
		public var orgWidth:Number = 0;
		public var orgHeight:Number = 0;
		//private var loadText:TextField;
		private var loadingClip:chrLoadingClip;
		//-----------------------------------------------------
		public function SwfCHRComponent(_data:Object)
		{
			itemData=_data;
			itemData.unqid="CHR_"+itemData.id+"_"+UID.createUID();
			
			loadingClip=new chrLoadingClip();
			loadingClip.name="loadingClip";
			loadingClip.chrloadingClip.mask=loadingClip.chrloadingMask;
			loadingClip.chrloadingMask.scaleY=0;		
			
			
			
			/*loadText=new TextField();
			loadText.type="dynamic";
			loadText.selectable=false;
			loadText.text="Loading...";
			loadText.visible=true;*/
			
		}
		//-----------------------------------------------------
		//-----------------------------------------------------
		public function loadSWF(path:String,defw:int=0,defh:int=0,_loadingclipObj:*=null):void
		{			
			//itemData.unqid=this.name;
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
			//this.addChild(loadText);
			this.addChild(loadingClip);
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		private function initializeEventListeners(_dispatcher:IEventDispatcher):void
		{
			_dispatcher.addEventListener(Event.COMPLETE,onSwfCHRComponentComplete);
			_dispatcher.addEventListener(ProgressEvent.PROGRESS,onSWFProgress);
			_dispatcher.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		private function onIOError(evt:IOErrorEvent):void
		{
			trace("onIOError:" + evt.text);
			//this.removeChild(loadText);
			this.removeChild(loadingClip);
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		private function onSwfCHRComponentComplete(event:Event):void
		{
			
			event.target.removeEventListener(Event.COMPLETE,onSwfCHRComponentComplete);
			event.target.removeEventListener(ProgressEvent.PROGRESS,onSWFProgress);

			swfContent = event.target.content;
			swfContent.addEventListener("close",unloadSWF);

			orgWidth = swfContent.width;
			orgHeight = swfContent.height;
								
			
			if (orgWidth > orgHeight)
			{
				var per:Number = defWidth / orgWidth * 100;
				var nw:Number = orgWidth * per / 100;
				var nh:Number = orgHeight * per / 100;
				
				swfContent.width =Number(nw.toFixed(0));
				swfContent.height = Number(nh.toFixed(0));
				
				swfContent.x -=  swfContent.width / 2;
				swfContent.y =  -  swfContent.height / 2;
				
			}
			else if (orgHeight > orgWidth)
			{
				var per2:Number = defHeight / orgHeight * 100;
				var nw2:Number = orgWidth * per2 / 100;
				var nh2:Number = orgHeight * per2 / 100;
				
				swfContent.width =Number(nw2.toFixed(0));
				swfContent.height = Number(nh2.toFixed(0));
				
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
				
			itemData.width=swfContent.width;
			itemData.height=swfContent.height;
			
			if (loadingclipObj != null)
			{
				loadingclipObj.txtStatus.text = "";
				loadingclipObj.visible = false;
			}			
			//this.removeChild(loadText);
			this.removeChild(loadingClip);
			addChild(swfContent);
			
			
			
			dispatchEvent(new ObjectEvent("CHR_LOAD_COMPLETED_UPDATE_SIZE",itemData,false,true));
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		function onSWFProgress(event:ProgressEvent):void
		{
			var percent:int = event.bytesLoaded / event.bytesTotal * 100;			
			//loadText.text="Loading ... " + percent + "%";
			loadingClip.chrloadingMask.scaleY=(percent/100);
			loadingClip.lblLoading.text="Loading " + percent + "%";
			/*if (loadingclipObj != null)
			{
				loadingclipObj.txtStatus.text = "Loading ... " + percent + "%";
			}*/
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
			if (swfLoader != null)
			{
				swfLoader.unloadAndStop();				
				if (swfContent != null)
				{
					removeChild(swfContent);					
					swfContent = null;
				}
			}
			
		}
		//-----------------------------------------------------
		
		public function get data():Object
		{
			return itemData;
		}
	}

}