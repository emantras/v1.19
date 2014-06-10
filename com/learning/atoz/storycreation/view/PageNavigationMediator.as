package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.StoryCreationApp;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.pagenavigation.PageNavigationComponent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.ClearStageEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageAddedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageDeleteEvent;
	import com.learning.atoz.storycreation.view.components.events.PageSwapCompletedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageThumbClickedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageUpdateEvent;
	
	import flash.text.*;
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	
	/*
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.StoryCreationApp;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.pagenavigation.PageNavigationComponent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.ClearStageEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageAddedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageDeleteEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageSwapCompletedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageThumbClickedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageUpdateEvent;
	
	import flash.text.*;
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	*/
	
	/*
		In PageNavigationMediator loading pagenavigation component and triggering the events
	*/
	public class PageNavigationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PageNavigationMediator";		
		
		private var pageNavigator:PageNavigationComponent;
		private var currentPageNo:int;
		
		//-----------------------------------------------------		
		public function PageNavigationMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);							
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		// a PureMVC override
		//-----------------------------------------------------		
		override public function getMediatorName():String
		{
			return NAME;// passes name to access this in the app
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		// a PureMVC override
		//-----------------------------------------------------		
		override public function getViewComponent():Object
		{
			return viewComponent; 
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		// what this mediator is listening for
		//-----------------------------------------------------		
		override public function listNotificationInterests():Array
		{
			return [ApplicationConstants.SHOW_PAGE_NAVIGATION,
					ApplicationConstants.DELETE_PAGE_THUMBNAIL,
			        ApplicationConstants.ADD_PAGE_THUMBNAIL,
					ApplicationConstants.UPDATE_PAGETHUMB_BG,
					ApplicationConstants.UPDATE_PAGE_THUMB_SELECTION,
					ApplicationConstants.ADD_PAGE];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Notification Event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{			
			switch (notification.getName())// like Event.CHANGE
			{
				case ApplicationConstants.SHOW_PAGE_NAVIGATION:
					initPageNavigation();					
					
					
				break;
				
				case ApplicationConstants.DELETE_PAGE_THUMBNAIL:
					var pno:Number= (notification.getBody() as Number);
					deletePageThumbnail(pno);
					break;
				
				case ApplicationConstants.ADD_PAGE_THUMBNAIL:
					//var ptype:String= (notification.getBody() as String);					
					var pagedet:Object= (notification.getBody() as Object);	
					
					trace("initPageNavigation1=>"+pageNavigator.visible);
					if(ApplicationConstants.USER_TYPE=="FLUENT")
					{
						pageNavigator.visible=true;
					}
					else if(ApplicationConstants.USER_TYPE=="EMERGENT")
					{
						pageNavigator.visible=false;
					}
					trace("initPageNavigation2=>"+pageNavigator.visible);
					
					trace("ADD_PAGE_THUMBNAIL1=>"+pageNavigator);
					pageNavigator.addPage(pagedet.type);
					trace("ADD_PAGE_THUMBNAIL2=>");
					pageNavigator.updatePageBGThumb(pagedet.pageno,pagedet.thumburl);					
					trace("ADD_PAGE_THUMBNAIL3");
					
					
					
			
					break;
					
				case ApplicationConstants.ADD_PAGE:
					//var ptype:String= (notification.getBody() as String);										
					pageNavigator.addPage("PAGE");
					break;
					
				case ApplicationConstants.UPDATE_PAGETHUMB_BG:
					var bgobj:Object= (notification.getBody() as Object);
					pageNavigator.updatePageBGThumb(bgobj.pageno,bgobj.thumburl);					
					break;
					
				case ApplicationConstants.UPDATE_PAGE_THUMB_SELECTION:					
					var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					trace("UPDATE_PAGE_THUMB_SELECTION=>dp.currentPage:"+dp.currentPage);
					pageNavigator.selectPage(dp.currentPage);
					//while edit book initially hide prev btn
					if(dp.currentPage==0)
					{
						pageNavigator.moveprev();
					}
					break;
					
			}
		}
		//-----------------------------------------------------		
				
		//-----------------------------------------------------		
		//Initializing and showing pagenavigation component with default frontcover page
		//-----------------------------------------------------				
		private function initPageNavigation():void
		{						
			//pageNavigator=new PageNavigationComponent(this,viewComponent);		
			pageNavigator=new PageNavigationComponent(this,mainDisplay);
			pageNavigator.x=0;//245;
			pageNavigator.y=0;//640;
			DisplayObjectContainer(viewComponent).addChild(pageNavigator);
			
			pageNavigator.addEventListener("PAGE_ADDED_EVENT",OnPageAdded);
			pageNavigator.addEventListener("PAGE_THUMB_CLICKED_EVENT",OnPageThumbClicked);
			pageNavigator.addEventListener("PAGE_DELETE_EVENT",OnDeletePage);
			pageNavigator.addEventListener("CLEAR_STAGE_EVENT",OnClearStage);
			pageNavigator.addEventListener("PAGE_UPDATE_EVENT",OnUpdatePage);
			pageNavigator.addEventListener("PAGE_SWAP_COMPLETED_EVENT",OnSwapCompleted);
			
			pageNavigator.addEventListener("ADDPAGE_ENABLE",OnAddPageEnabled);
			pageNavigator.addEventListener("ADDPAGE_DISABLE",OnAddPageDisabled);
			pageNavigator.addEventListener("DUPLICATE_DISABLE",OnDuplicateDisable);
			pageNavigator.addEventListener("DUPLICATE_ENABLE",OnDuplicateEnable);
			
			pageNavigator.addPage("FRONTCOVER");
			
			
			
		}
		public function OnDuplicateDisable(evt:*):void
		{
			facade.sendNotification(ApplicationConstants.DUPLICATE_DISABLE);
		}
		
		public function OnDuplicateEnable(evt:*):void
		{
			//facade.sendNotification(ApplicationConstants.DUPLICATE_ENABLE);
		}
		
		//-----------------------------------------------------				
		public function OnAddPageEnabled(evt:*):void
		{
			facade.sendNotification(ApplicationConstants.ADDPAGE_ENABLE);
		}
		
		
		public function OnAddPageDisabled(evt:*):void
		{
			facade.sendNotification(ApplicationConstants.ADDPAGE_DISABLE);
		}
		//-----------------------------------------------------		
		//Getting maximum page no
		//-----------------------------------------------------		
		public function getMaxPageNo():int
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp!=null)
			{
				return dp.getMaxPageNo();
			}
			
			return 0;
		}
		//-----------------------------------------------------		
		//var curbgurl2:String=dp.getBGUrl(dp.currentPage);
		//-----------------------------------------------------		
		//This event is triggered when the user adds new page
		//-----------------------------------------------------		
		private function OnPageAdded(evt:PageAddedEvent):void
		{						
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
			var ret:Boolean=dp.addPage(evt._id,evt._ptype,evt._pageno);
			if(ret)
			{
				
				if(evt._pageno==0 || evt._pageno==ApplicationConstants.MAXIMUM_PAGE_LIMIT)
				{
					facade.sendNotification(ApplicationConstants.DUPLICATE_DISABLE);					
				}
				else
				{
					//checked in canvasmediator.as 
					//facade.sendNotification(ApplicationConstants.DUPLICATE_ENABLE);
				}
			
				//check if default page is added and select default page 0(front cover page)
				if(evt._pageno==0)
				{
					dp.currentPage=evt._pageno;					
					
				}
				else
				{
					dp.currentPage=dp.getMaxPageNo();					
					//selection is donw in pagenavigationcomponent itself
					pageNavigator.selectPage(dp.currentPage);
					facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
				}
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//This event is triggered when the user deleted the page.
		//-----------------------------------------------------				
		private function OnDeletePage(evt:PageDeleteEvent):void
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp!=null)
			{
				dp.deletePage(evt._pageno);
				if((evt._pageno-1)>=0)
				{
					dp.currentPage=Number((evt._pageno-1));
				}
				else
				{
					dp.currentPage=0;
				}
				pageNavigator.selectPage(dp.currentPage);
				facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
				
				facade.sendNotification(ApplicationConstants.CHECK_FOR_DUPLICATE_BTN);
				
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//This event is triggered when the user changes the order of the page
		//-----------------------------------------------------		
		private function OnUpdatePage(evt:PageUpdateEvent):void		
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp!=null)
			{
				dp.updatePageNo(evt._oldpageno,evt._newpageno);
			}
		}
		//-----------------------------------------------------		
		public function deletePageThumbnail(pno:int)
		{
			pageNavigator.deletePageThumbnail(pno);
			
		}
		//-----------------------------------------------------		
		//This event is fired when the user clickes the page thumbnail 
		//-----------------------------------------------------						
		private function OnPageThumbClicked(evt:PageThumbClickedEvent):void
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
			if(evt._pageno==0)
			{
				facade.sendNotification(ApplicationConstants.DUPLICATE_DISABLE);		
			}
			else
			{
				//facade.sendNotification(ApplicationConstants.DUPLICATE_ENABLE);
			}
			
			//before redirecting to page save current page info
			if(evt._pageno>=0)
			{
				facade.sendNotification(ApplicationConstants.SAVE_BEFORE_REDIRECT_PAGE,evt._pageno);
			}
			
			//this code is moved to canvasmediator
			/*if(evt._pageno>=0)
			{
				dp.currentPage=evt._pageno;
			}
			facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);*/
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//This event is triggered when canvas clearing requested
		//-----------------------------------------------------		
		private function OnClearStage(evt:ClearStageEvent):void
		{
			facade.sendNotification(ApplicationConstants.CLEAR_CANVAS);
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//This event is triggered when the page swap completed
		//-----------------------------------------------------		
		private function OnSwapCompleted(evt:PageSwapCompletedEvent):void
		{			
		
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp!=null)
			{
				//trace("OnSwapCompleted2=>"+evt._scid+","+evt._p1+","+evt._tcid+","+evt._p2);
				dp.SwapPage(evt._scid,evt._p1,evt._tcid,evt._p2);				
				//facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
			}
			trace("OnSwapCompleted4=>");
		}
		//-----------------------------------------------------	
		
		
		public function get mainDisplay():StoryCreationApp
		{
			return MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME)).mainDisplay;
		}
	}
}
