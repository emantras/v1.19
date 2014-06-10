package com.learning.atoz.storycreation.view.components.callout
{
	//import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
		
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	import com.learning.atoz.storycreation.view.components.clipart.events.ClipartEvent;
	import com.learning.atoz.storycreation.view.components.clipart.caLoadingClip;
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	/*
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	import com.learning.atoz.storycreation.view.components.clipart.events.ClipartEvent;
	import com.learning.atoz.storycreation.view.components.clipart.caLoadingClip;
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	*/
	
	/*
	Swfcomponent is the actual swf loading and displaying.
	*/
	public class CalloutSwfComponent extends Sprite
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
		private var caloadclip:caLoadingClip;
		private var id:String;
		private var type:String;//"BG","CHR","OBJ"
		private var fullurl:String;
		private var thumburl:String;
		//-----------------------------------------------------		
		public function CalloutSwfComponent()
		{
			caloadclip=new caLoadingClip();
			
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
		public function getDetail():Object
		{
			return {id:id,type:type,url:fullurl};
		}
		//-----------------------------------------------------		
		//to load swf from the server
		//-----------------------------------------------------
		public function loadSWF(_id:String,_type:String,path:String,_fullurl:String,defw:int=0,defh:int=0,_loadingclipObj:*=null):void
		{						
			id=_id;
			type=_type;
			fullurl=_fullurl;
			thumburl=path;
			
			this.addChild(caloadclip);
			
			loadingclipObj = _loadingclipObj;
			defWidth = defw;
			defHeight = defh;
			
			//var _request:URLRequest = new URLRequest  ;
			//_request.url = path;
			
			swfLoader = new Loader  ;
			initializeEventListeners(swfLoader.contentLoaderInfo);
			//swfLoader.load(_request);
			
			if (loadingclipObj != null)
			{
				loadingclipObj.txtStatus.text = "";
				loadingclipObj.visible = true;
			}
			
		}
		//-----------------------------------------------------
		public function startLoad()
		{
			var _request:URLRequest = new URLRequest  ;
			_request.url = thumburl;
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
			this.removeChild(caloadclip);
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

			this.removeChild(caloadclip);
			
						
			//Fixed thumnail size
			if (resizeType == "FIXED")
			{
				if (defWidth > 0 && defHeight > 0)
				{
					//swfContent.width = defWidth;
					//swfContent.height = defHeight;
					swfContent.scaleX=0.5;
					swfContent.scaleY=0.5;
				}

				swfContent.x -=  swfContent.width / 2;
				swfContent.y =  -  swfContent.height / 2;
			}//proportional thubnail size
			

						
			this.graphics.beginFill(0xEEEEEE,1.0);
			//this.graphics.drawRect(-(swfContent.width / 2),-(swfContent.height / 2),swfContent.width,swfContent.height);
			this.graphics.drawRect(-(swfContent.width / 2),-(swfContent.height / 2),swfContent.width,swfContent.height);
			this.graphics.endFill();
			
			addChild(swfContent);
			
			//trace("w="+swfContent.width+",h="+swfContent.height);
			
			
			
			selectedClip=new Sprite();
			selectedClip.name="selectedClip";
			selectedClip.graphics.lineStyle(2,0xff0000,1.0);
			selectedClip.graphics.beginFill(0xffff00,0.2);
			selectedClip.graphics.drawRect(0,0,swfContent.width,swfContent.height);
			selectedClip.graphics.endFill();
			selectedClip.x-=swfContent.width / 2;
			selectedClip.y-=swfContent.height / 2;
				
			this.buttonMode=true;
			
			this.addEventListener(MouseEvent.CLICK,OnthumbnailClick);
			this.addEventListener(MouseEvent.MOUSE_OVER,OnthumbnailOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,OnthumbnailOut);
			
			//dispatchEvent(new ObjectEvent("THUMB_LOAD_COMPLETED",null,false,true))
		}

		
		
		//-----------------------------------------------------		
		private function OnthumbnailClick(evt:MouseEvent):void
		{
			//dispatchEvent(new Event("CATHUMB_CLICKED",false,true));
			dispatchEvent(new ClipartEvent("CATHUMB_CLICKED",{id:id,type:type,url:fullurl},false,true));
			/*var selclip:*=this.getChildByName("selectedClip")
			if(selclip!=null)
			{
				select(false);
			}
			else
			{
				select(true);
			}*/
		}
		//-----------------------------------------------------
		
		public function getSelectedStatus():Boolean
		{
			var selclip:*=this.getChildByName("selectedClip")
			if(selclip!=null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//-----------------------------------------------------		
		//when the user mouse overs the thumbnail showing effect
		//-----------------------------------------------------		
		private function OnthumbnailOver(evt:MouseEvent):void
		{
			TweenLite.to(this, 0.3, { scaleX:1.35, scaleY:1.35 } );
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//when the user mouse outs the thumbnail reverting the effect
		//-----------------------------------------------------		
		private function OnthumbnailOut(evt:MouseEvent):void
		{
			TweenLite.to(this, 0.3, { scaleX:1.0, scaleY:1.0 } );
		}
		//-----------------------------------------------------	

		//-----------------------------------------------------		
		//while the swf is loading showing loaded status 
		//--------------------------------------------------------------
		function onSWFProgress(event:ProgressEvent):void
		{
			var percent:int = event.bytesLoaded / event.bytesTotal * 100;
			if(caloadclip!=null)
			{
				caloadclip.lblLoading.text="Loading " + percent + " %";
			}
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