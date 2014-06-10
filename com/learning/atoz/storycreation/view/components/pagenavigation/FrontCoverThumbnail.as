package com.learning.atoz.storycreation.view.components.pagenavigation
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import com.learning.atoz.storycreation.view.components.events.PageSwapCompletedEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.display.Sprite;			
	import flash.net.URLRequest;	
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	/*
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageSwapCompletedEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.display.Sprite;			
	import flash.net.URLRequest;	
	import flash.system.SecurityDomain;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import com.learning.atoz.storycreation.ApplicationConstants;
	*/
	/*
		Frontcover page thumbnail control
	*/
	public class FrontCoverThumbnail extends MovieClip
	{
		private var _pageno:Number=0;
		public var controlID:String;
		public var pageBgThumb:String="";//http://emantras.raz-kids.com/story_resources/background_resource/10027/thumb.swf";
		private var bgswfLoader:Loader;
		//-----------------------------------------------------
		public function FrontCoverThumbnail(cid:String)
		{
			controlID=cid;
			this.addEventListener(Event.ADDED_TO_STAGE,OnfrontcoverThumbnailInit);			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		private function OnfrontcoverThumbnailInit(evt:Event):void
		{
			this.buttonMode=true;
			loadBG();
		}
		//-----------------------------------------------------
		public function loadBG()
		{
			while(pageBgHolder.numChildren>0)
			{
				pageBgHolder.removeChildAt(0);
			}
			
			bgswfLoader = new Loader;			
			initializeEventListeners(bgswfLoader.contentLoaderInfo);
			
			var _request:URLRequest = new URLRequest;
			//var arr:Array=ThumbUrl.split("/");
			//var sthumb2:String=arr[arr.length-1];
			_request.url = pageBgThumb;//"assets/subcat_thumb/"+sthumb2;
			
			trace(_request.url);			
			
			//bgswfLoader.load(_request);
			if(ApplicationConstants.SAMEDOMAIN=="YES")
			{
				bgswfLoader.load(_request);
			}
			else
			{
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				loaderContext.securityDomain = SecurityDomain.currentDomain;// Sets the security context to resolve Error # 2121
				bgswfLoader.load(_request,loaderContext);				
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
		}
		
		function onSWFComplete(event:Event):void
		{
			trace("complete");
			event.target.removeEventListener(Event.COMPLETE,onSWFComplete);			
			
			event.target.content.x=0;
			event.target.content.y=0;
			event.target.content.width=45;
			event.target.content.height=45;
			pageBgHolder.addChild(event.target.content);
			pageBgHolder.mask=pagebgthumbmask;
			//this.addChild(event.target.content);
			
		}
		
		
		public function showBGThumb(bshow:Boolean)
		{
			var bgthumbobj:*=this.getChildByName("pageBgHolder");
			if(bgthumbobj!=null)
			{
				bgthumbobj.visible=bshow;
			}
		}
		
		//-----------------------------------------------------
		public function set pageno(pno:Number):void
		{
			_pageno=pno;
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		public function get pageno():Number
		{
			return _pageno;
		}
		//-----------------------------------------------------

	}
	
}
