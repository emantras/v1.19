package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.LayoutMenuView;
	import com.learning.atoz.storycreation.view.components.ThumbControl;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class LayoutMenuViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LayoutMenuViewMediator";		
		private var layoutImages:Array;		
		//-----------------------------------------------------		
		public function LayoutMenuViewMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			layoutImages=new Array();
			layoutImages.push({id:1,name:"Layout1",thumburl:ApplicationConstants.ASSETS_PATH+"assets/layout/Layout_1.swf"});
			layoutImages.push({id:2,name:"Layout2",thumburl:ApplicationConstants.ASSETS_PATH+"assets/layout/Layout_2.swf"});
			layoutImages.push({id:3,name:"Layout3",thumburl:ApplicationConstants.ASSETS_PATH+"assets/layout/Layout_3.swf"});
			layoutImages.push({id:4,name:"Layout4",thumburl:ApplicationConstants.ASSETS_PATH+"assets/layout/Layout_4.swf"});
			layoutImages.push({id:5,name:"Layout5",thumburl:ApplicationConstants.ASSETS_PATH+"assets/layout/Layout_5.swf"});
			layoutImages.push({id:6,name:"Layout6",thumburl:ApplicationConstants.ASSETS_PATH+"assets/layout/Layout_6.swf"});
		}
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
			return [ApplicationConstants.PRELOAD_LAYOUT_THUMBNAIL,
				ApplicationConstants.SHOW_LAYOUT_SELECTION];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.PRELOAD_LAYOUT_THUMBNAIL:			
					GenerateLAYOUTSubMenu();					
					break;
				
				case ApplicationConstants.SHOW_LAYOUT_SELECTION:
					var layoutid:int=(notification.getBody() as int);
					selectLayout(layoutid);			
					break;
				
				
				
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Generating Background Thumbnails
		//-----------------------------------------------------		
		private function GenerateLAYOUTSubMenu()
		{			
			var layoutview:LayoutMenuView=layoutMenuView;
			
			var xoffset:int=25;
			var yoffset:int=50;
			var w:int=80;
			var h:int=80;			
			var imgcnt:int=0;
			var maximagecnt:int=12;
			var rowoffset:int=5;//15
			
			
			for(var r:int=0;r<7;r++)
			{
				for(var c:int=0;c<2;c++)
				{					
					if(imgcnt<layoutImages.length)
					{
						if(imgcnt<maximagecnt)
						{			
							var imgthumb:ThumbControl=new ThumbControl();
							imgthumb.addEventListener("BG_THUMB_CLICKED",OnLayoutThumbnailClicked);							
							
							var thumburl:String=layoutImages[imgcnt].thumburl;
							
							var itemData:Object={unqid:"",id:layoutImages[imgcnt].id,name:layoutImages[imgcnt].name,catid:0,subcatid:0,url:"",thumburl:thumburl,type:"LAYOUT",xpos:0,ypos:0,width:0,height:0,rotation:0};
							
							//imgthumb.loadswf(assetXML..Character[imgcnt].CatId,assetXML..Character[imgcnt].SubCatId,bgThumb,bgfullurl,"PROPORTIONAL");
							imgthumb.loadswf(itemData,"FIXED");
							layoutview.addChild(imgthumb);
							imgthumb.x=(c*w)+xoffset+(c*5)+(imgthumb.width/2);
							imgthumb.y=(r*h)+yoffset+(r*rowoffset)+(imgthumb.height/2);
							imgcnt++;		
							
						}
						
					}
					
				}				
			}
			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			var layoutid:int=dp.getCurrentLayoutID(dp.currentPage);
			selectLayout(layoutid);
			
		}
		//-----------------------------------------------------		
		public function selectLayout(layoutid:int):void
		{			
			if(layoutid>0)
			{
				var layoutview:LayoutMenuView=layoutMenuView;
				
				for(var r:int=0;r<layoutview.numChildren;r++)
				{
					var obj:ThumbControl=layoutview.getChildAt(r) as ThumbControl;
					obj.select(false);
				}
				
				for(var j:int=0;j<layoutview.numChildren;j++)
				{
					var tobj:ThumbControl=layoutview.getChildAt(j) as ThumbControl;
					if(tobj.data.id==layoutid)
					{
						tobj.select(true);
						break;
					}
				}
			}
		}
		//-----------------------------------------------------		
		//This event is triggered when the background thumbnail is clicked
		//-----------------------------------------------------				
		private function OnLayoutThumbnailClicked(evt:ObjectEvent):void
		{	
			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
			if(evt.objdata.id>0)
			{
				selectLayout(evt.objdata.id);
			}
			
			if(dp.currentPage>0)
			{
				if(evt.objdata.id==1)
				{
					dp.updateLayoutID(1,dp.currentPage);
					facade.sendNotification(ApplicationConstants.SHOW_LAYOUT_1);
				}
				else if(evt.objdata.id==2)
				{
					dp.updateLayoutID(2,dp.currentPage);
					facade.sendNotification(ApplicationConstants.SHOW_LAYOUT_2);
				}
				else if(evt.objdata.id==3)
				{
					dp.updateLayoutID(3,dp.currentPage);
					facade.sendNotification(ApplicationConstants.SHOW_LAYOUT_3);
				}
				else if(evt.objdata.id==4)
				{
					dp.updateLayoutID(4,dp.currentPage);
					facade.sendNotification(ApplicationConstants.SHOW_LAYOUT_4);
				}
				else if(evt.objdata.id==5)
				{
					dp.updateLayoutID(5,dp.currentPage);
					facade.sendNotification(ApplicationConstants.SHOW_LAYOUT_5);
				}
				else if(evt.objdata.id==6)
				{
					dp.updateLayoutID(6,dp.currentPage);
					facade.sendNotification(ApplicationConstants.SHOW_LAYOUT_6);
				}
			}
			
			
			
		}
		//-----------------------------------------------------	
		
		
		protected function get layoutMenuView():LayoutMenuView
		{
			return viewComponent as LayoutMenuView;
		}
		
	}
}
