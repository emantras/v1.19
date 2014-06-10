package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.LayoutMenuView;
	import com.learning.atoz.storycreation.view.components.TextCalloutMenuView;
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
	public class TextCalloutMenuViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TextCalloutMenuViewMediator";		
		private var textCalloutImages:Array;		
		private var isDown:Boolean=false;
		//-----------------------------------------------------		
		public function TextCalloutMenuViewMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			textCalloutImages=new Array();
			//textCalloutImages.push({id:1,name:"Callout1_1",yoffset:50,thumburl:ApplicationConstants.ASSETS_PATH+"assets/callout/skins/CalloutSkin1_1.swf"});
			//textCalloutImages.push({id:2,name:"Callout1_2",yoffset:60,thumburl:ApplicationConstants.ASSETS_PATH+"assets/callout/skins/CalloutSkin1_2.swf"});
			//textCalloutImages.push({id:3,name:"Callout1_3",yoffset:60,thumburl:ApplicationConstants.ASSETS_PATH+"assets/callout/skins/CalloutSkin1_3.swf"});
			textCalloutImages.push({id:4,name:"Callout2_1",yoffset:60,thumburl:ApplicationConstants.ASSETS_PATH+"assets/callout/skins/CalloutSkin2_1.swf"});
			textCalloutImages.push({id:5,name:"Callout2_2",yoffset:60,thumburl:ApplicationConstants.ASSETS_PATH+"assets/callout/skins/CalloutSkin2_2.swf"});
			textCalloutImages.push({id:6,name:"Callout2_3",yoffset:60,thumburl:ApplicationConstants.ASSETS_PATH+"assets/callout/skins/CalloutSkin2_3.swf"});
			//textCalloutImages.push({id:7,name:"Callout3_1",yoffset:50,thumburl:ApplicationConstants.ASSETS_PATH+"assets/callout/skins/CalloutSkin3_1.swf"});
			facade.sendNotification(ApplicationConstants.PRELOAD_TEXTCALLOUT_THUMBNAIL);
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
			return [ApplicationConstants.PRELOAD_TEXTCALLOUT_THUMBNAIL];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.PRELOAD_TEXTCALLOUT_THUMBNAIL:			
					GenerateTextCalloutSubMenu();					
					break;
				
				/*case ApplicationConstants.SHOW_LAYOUT_SELECTION:
					var layoutid:int=(notification.getBody() as int);
					selectLayout(layoutid);			
					break;*/
				
				
				
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Generating Background Thumbnails
		//-----------------------------------------------------		
		private function GenerateTextCalloutSubMenu()
		{	
			var textcalloutview:TextCalloutMenuView=textcalloutMenuView;
			
			var xoffset:int=75;
			var yoffset:int=50;
			var w:int=200;
			var h:int=100;			
			var imgcnt:int=0;
			var maximagecnt:int=6;
			var rowoffset:int=15;
			var yp:int=0;
			
			for(var r:int=0;r<7;r++)
			{		
					if(imgcnt<textCalloutImages.length)
					{					
						if(imgcnt<maximagecnt)
						{					
							var imgthumb:ThumbControl=new ThumbControl();
							imgthumb.addEventListener("BG_THUMB_CLICKED",OnTextCalloutThumbnailClicked);
							imgthumb.addEventListener("BG_THUMB_DOWN",OnTextCalloutThumbnailDown);	
							imgthumb.addEventListener("BG_THUMB_UP",OnTextCalloutThumbnailUp);
							imgthumb.addEventListener("BG_THUMB_OUT",OnTextCalloutThumbnailOut);
														
							yoffset=Number(textCalloutImages[imgcnt].yoffset);//25;
							
							imgthumb.normalWidth=130;
							imgthumb.normalHeight=55;
							
							imgthumb.overWidth=150;
							imgthumb.overHeight=75;
							
							var thumburl:String=textCalloutImages[imgcnt].thumburl;
							
							var itemData:Object={unqid:"",id:textCalloutImages[imgcnt].id,name:textCalloutImages[imgcnt].name,catid:0,subcatid:0,url:"",thumburl:thumburl,type:textCalloutImages[imgcnt].name,xpos:0,ypos:0,width:0,height:0,rotation:0};
							
							//imgthumb.loadswf(assetXML..Character[imgcnt].CatId,assetXML..Character[imgcnt].SubCatId,bgThumb,bgfullurl,"PROPORTIONAL");
							imgthumb.loadswf(itemData,"FIXED");
							textcalloutview.addChild(imgthumb);
							imgthumb.x=xoffset+(imgthumb.width/2);
							h=imgthumb.height;
							//imgthumb.y=(r*h)+(yoffset)+(r*rowoffset)+(imgthumb.height/2);
							yp+=yoffset;
							imgthumb.y=(r*h)+(imgthumb.height/2)+(yp);//+(r*rowoffset)+(imgthumb.height/2);
							imgcnt++;		
							
							
						}
						
					}
								
			}
			
			//var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			//var layoutid:int=dp.getCurrentLayoutID(dp.currentPage);
			//selectLayout(layoutid);
			
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//This event is triggered when the background thumbnail is clicked
		//-----------------------------------------------------				
		private function OnTextCalloutThumbnailClicked(evt:ObjectEvent):void
		{	
			
			/*if(evt.objdata.id>0)
			{
				var obj:Object=new Object();
				obj.type=evt.objdata.type;
				obj.skin=evt.objdata.thumburl;
				facade.sendNotification(ApplicationConstants.ADD_CALLOUTTEXT,obj);
				
			}*/
			
			
		}
		//-----------------------------------------------------	
		private function OnTextCalloutThumbnailDown(evt:ObjectEvent):void
		{				
			isDown=true;			
			
		}
		//-----------------------------------------------------	
		private function OnTextCalloutThumbnailUp(evt:ObjectEvent):void
		{	
			isDown=false;
			if(evt.objdata.id>0)
			{
				var obj:Object=new Object();
				obj.type=evt.objdata.type;
				obj.skin=evt.objdata.thumburl;
				obj.xpos=0;
				obj.ypos=0;
				facade.sendNotification(ApplicationConstants.ADD_CALLOUTTEXT,obj);
				
				
				//-----------------------------------------------------
				//SaveBook Timer Start
				//-----------------------------------------------------
				facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
				//-----------------------------------------------------
				
			}
			
			
		}
		//-----------------------------------------------------	
		private function OnTextCalloutThumbnailOut(evt:ObjectEvent):void
		{	
			
			if(isDown==true)
			{
				isDown=false;
				var obj:Object=new Object();
				obj.type=evt.objdata.type;
				obj.skin=evt.objdata.thumburl;
				obj.xpos=0;
				obj.ypos=0;
				facade.sendNotification(ApplicationConstants.DRAG_ADD_CALLOUT,obj);
				
				
			}		
			
			
		}
		//-----------------------------------------------------	
		
		
		
		
		protected function get textcalloutMenuView():TextCalloutMenuView
		{
			return viewComponent as TextCalloutMenuView;
		}
		
	}
}
