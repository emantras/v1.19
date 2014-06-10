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
	import flash.filters.DropShadowFilter;
	
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
	import flash.filters.DropShadowFilter;
	*/
	/*
		pagethumbnail component of the pagenavigation bar
	*/
	public class pageThumbnail extends MovieClip
	{
		private var _pageno:Number=0;
		private var pagenoCtrl:TextField;
		public var orgx:Number=0;
		public var orgy:Number=0;
		private var _placeHolderContainer:*;
		private var dragobjpos:*;
		private var dropobjpos:*;
		private var pno:int=0;
		private var botpanelObj:*;
		public var controlID:String="";
		public var pageBgThumb:String="";//http://emantras.raz-kids.com/story_resources/background_resource/10027/thumb.swf";
		private var bgswfLoader:Loader;
		//pageBgHolder
		//-----------------------------------------------------
		public function pageThumbnail(placeHolderContainer:*,_botpanelObj:*,cid:String)
		{
			controlID=cid;
			 botpanelObj=_botpanelObj;
			_placeHolderContainer=placeHolderContainer;
			this.addEventListener(Event.ADDED_TO_STAGE,OnpagethumbnailInit);			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		private function OnpagethumbnailInit(evt:Event):void
		{
			this.buttonMode=true;
			
			txtsno.text=""+_pageno;
			this.addEventListener(MouseEvent.MOUSE_DOWN,OnThumbDown);
			this.addEventListener(MouseEvent.MOUSE_UP,OnThumbUp);			
			loadBG();
			
			
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.distance = 0;
			dropShadow.angle = 45;
			dropShadow.color = 0x333333;
			dropShadow.alpha = 1;
			dropShadow.blurX = 10;
			dropShadow.blurY = 10;
			dropShadow.strength = 1;
			dropShadow.quality = 15;
			dropShadow.inner = false;
			dropShadow.knockout = false;
			dropShadow.hideObject = false;
			
			this.filters = new Array(dropShadow);
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
		
		private function onSWFComplete(event:Event):void
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
			pagebgthumbmask.visible=false;
			
		}
		
		public function showBGThumb(bshow:Boolean)
		{
			trace("showBGThumb1=>"+bshow);
			var bgthumbobj:*=this.getChildByName("pageBgHolder");
			trace("showBGThumb2=>"+bgthumbobj);
			if(bgthumbobj!=null)
			{
				bgthumbobj.visible=bshow;
			}
		}
		
		//-----------------------------------------------------
		private function OnThumbDown(evt:MouseEvent):void
		{
			pno=this.pageno;
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnStageUp);
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			this.startDrag();
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//When the mouse is release outside the page navigation bar
		//-----------------------------------------------------
		private function OnStageUp(evt:MouseEvent):void
		{			
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnStageUp);			
			this.stopDrag();
			
			var dragobjpos:*=_placeHolderContainer.getChildByName("pageHolder"+pno);
			if(dragobjpos!=null)
			{
				this.x=dragobjpos.x;						
				this.y=dragobjpos.y;			
			}
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		private function OnThumbUp(evt:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnStageUp);	
			this.stopDrag();					
			//trace("PageThumbnail=>OnThumbUp1=>this.dropTarget:"+this.dropTarget);
						
			if(this.dropTarget.parent!=null && this.dropTarget.parent.parent!=null)
			{
				//trace("PageThumbnail=>OnThumbUp2=>this.dropTarget.parent:"+this.dropTarget.parent+",this.dropTarget.parent.name:"+this.dropTarget.parent.name);
				if(this.dropTarget.parent.parent.name=="page" && this.dropTarget.parent.name=="pageThumbHitArea") //
				{
					//trace("PageThumbnail=>OnThumbUp3=>"+",this.dropTarget.parent.parent.name:"+this.dropTarget.parent.parent.name);
					
					if(_placeHolderContainer!=null)
					{
						
						dragobjpos=_placeHolderContainer.getChildByName("pageHolder"+this.pageno);
						dropobjpos=_placeHolderContainer.getChildByName("pageHolder"+(this.dropTarget.parent.parent as pageThumbnail).pageno);
						
						if(dragobjpos!=null && dropobjpos!=null)
						{
							
							var p1:int=0;
							var p2:int=0;
							var p3:int=0;
							var p4:int=0;
							var srccid:String="";
							var tarcid:String="";
							
							p1=this.pageno;
							srccid=this.controlID;
														
							this.x=dropobjpos.x;
							this.orgx=dropobjpos.x;
							
							this.y=dropobjpos.y;
							this.orgy=dropobjpos.y;
							this.pageno=dropobjpos.pageno;							
							p2=dropobjpos.pageno;
							
							var par:pageThumbnail=(this.dropTarget.parent.parent as pageThumbnail);
							
							par.x=dragobjpos.x;
							par.orgx=dragobjpos.x;
							
							p3=par.pageno;
							par.y=dragobjpos.y;
							par.orgy=dragobjpos.y;
							par.pageno=dragobjpos.pageno;							
							p4=dragobjpos.pageno;
							tarcid=par.controlID;
							
							if(botpanelObj!=null)							
							{			
								dispatchEvent(new PageSwapCompletedEvent("PAGE_SWAP_COMPLETED_EVENT",srccid,p1,p2,tarcid,p3,p4,false,true));																	
							}
							
						}
						else
						{
							var dragobjpos1:*=_placeHolderContainer.getChildByName("pageHolder"+this.pageno);
							if(dragobjpos1!=null)
							{
								this.x=dragobjpos1.x;						
								this.y=dragobjpos1.y;
							
							}
						}
					}
					else
					{
						var dragobjpos2:*=_placeHolderContainer.getChildByName("pageHolder"+this.pageno);
						if(dragobjpos2!=null)
						{
							this.x=dragobjpos2.x;						
							this.y=dragobjpos2.y;						
						}
					}
					
				}
				else
				{
					var dragobjpos3:*=_placeHolderContainer.getChildByName("pageHolder"+this.pageno);
					if(dragobjpos3!=null)
					{
						this.x=dragobjpos3.x;						
						this.y=dragobjpos3.y;					
					}	
				}
			}
			else
			{
				var dragobjpos4:*=_placeHolderContainer.getChildByName("pageHolder"+this.pageno);
				if(dragobjpos4!=null)
				{
					this.x=dragobjpos4.x;						
					this.y=dragobjpos4.y;				
				}
			}
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		public function set pageno2(pno:Number):void
		{
			_pageno=pno;			
		}
		//-----------------------------------------------------
				
		//-----------------------------------------------------
		public function set pageno(pno:Number):void
		{
			_pageno=pno;			
			txtsno.text=""+_pageno;
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
