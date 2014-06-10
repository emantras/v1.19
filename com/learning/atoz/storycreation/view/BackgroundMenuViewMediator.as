package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.BackgroundMenuView;
	import com.learning.atoz.storycreation.view.components.BtnMore;
	import com.learning.atoz.storycreation.view.components.ThumbControl;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.text.*;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.BGClipartProxy;
	
	
	/*
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.BackgroundMenuView;
	import com.learning.atoz.storycreation.view.components.BtnMore;
	import com.learning.atoz.storycreation.view.components.ThumbControl;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.text.*;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	*/
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class BackgroundMenuViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BackgroundMenuViewMediator";		
		private var isDown:Boolean=false;
		//-----------------------------------------------------		
		public function BackgroundMenuViewMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{
			
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
			return [ApplicationConstants.BG_MENU_UPDATE]; //ApplicationConstants.PRELOAD_BG_THUMBNAIL
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.BG_MENU_UPDATE://ApplicationConstants.PRELOAD_BG_THUMBNAIL:					
					GenerateBGSubMenu();					
					break;
					
					
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Generating Background Thumbnails
		//-----------------------------------------------------		
		private function GenerateBGSubMenu()
		{			
			var backgroundview:BackgroundMenuView=bgMenuView;
			
			var xoffset:int=15;
			var yoffset:int=35;
			var w:int=90;
			var h:int=90;			
			var imgcnt:int=0;
			var maximagecnt:int=10;
			var rowoffset:int=5;//15
			//var assetXML:XML=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
			var assetXML:XML=BGClipartProxy(facade.retrieveProxy(BGClipartProxy.NAME)).vo._xml;
						
			
			var bottomyp:int=0;
			//trace("GenerateBGSubMenu=>assetXML..Background.length()="+assetXML..Background.length());
			
			while(backgroundview.numChildren>0)
			{
				backgroundview.removeChildAt(0);
			}
			
			/*if(assetXML..Background.length()<=0)
			{
				var bm:BtnMore=new BtnMore();
				bm.buttonMode=true;
				bm.addEventListener(MouseEvent.CLICK,OnBGImageMoreClicked);
				backgroundview.addChild(bm);
				
				bm.x=70;						
				bm.y=10;
			}*/
			if(assetXML!=null)
			{
				trace("GenerateBGSubMenu=>assetXML..Background.length()=>"+assetXML..Background.length());
				
				//for(var r:int=0;r<7;r++)
				for(var r:int=0;r<5;r++)
				{
					for(var c:int=0;c<2;c++)
					{					
						if(imgcnt<assetXML..Background.length())
						{
							if(imgcnt<=maximagecnt)
							{		
								trace("BG r="+r+",c="+c+","+imgcnt+" of "+assetXML..Background.length());
								
								trace("BgId=>"+assetXML..Background[imgcnt].BgId);
							
								var imgthumb:ThumbControl=new ThumbControl();
								imgthumb.addEventListener("BG_THUMB_CLICKED",OnBackgroundThumbnailClicked);
								imgthumb.addEventListener("BG_THUMB_DOWN",OnBackgroundThumbnailDown);	
								imgthumb.addEventListener("BG_THUMB_UP",OnBackgroundThumbnailUp);
								imgthumb.addEventListener("BG_THUMB_OUT",OnBackgroundThumbnailOut);
									
								var bgfullurl:String;
								var bgThumb:String;
								if(ApplicationConstants.ASSETS_MODE=="LOCAL")
								{
									bgfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+assetXML..Background[imgcnt].Url;							
									bgThumb=ApplicationConstants.ASSETS_PATH+"assets/"+assetXML..Background[imgcnt].ThumbUrl;
								}
								else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
								{
									bgfullurl=assetXML..Background[imgcnt].Url;							
									bgThumb=assetXML..Background[imgcnt].ThumbUrl;
								}
								
								//--------------------------------------------------
								//Exception swfs
								//--------------------------------------------------
								var exceptionArr:Array=new Array(625,626,627,628,10051,10057,10058,10059,10060);
								for(var jg:int=0;jg<exceptionArr.length;jg++)
								{
									if(Number(assetXML..Background[imgcnt].BgId)==exceptionArr[jg])
									{
										bgThumb=assetXML..Background[imgcnt].Url;
										break;
									}
								}							
								trace("bgThumb:"+bgThumb);
								//--------------------------------------------------
								
								var itemData:Object={unqid:"",id:assetXML..Background[imgcnt].BgId,name:assetXML..Background[imgcnt].BgName,catid:assetXML..Background[imgcnt].CatId,subcatid:assetXML..Background[imgcnt].SubCatId,url:bgfullurl,thumburl:bgThumb,type:"BACKGROUND",xpos:0,ypos:0,width:0,height:0,rotation:0};
								//imgthumb.loadswf(assetXML..Background[imgcnt].CatId,assetXML..Background[imgcnt].SubCatId,bgThumb,bgfullurl);
								imgthumb.loadswf(itemData);
								backgroundview.addChild(imgthumb);
								imgthumb.x=(c*w)+xoffset+(c*5)+(imgthumb.width/2);
								imgthumb.y=(r*h)+yoffset+(r*rowoffset)+(imgthumb.height/2);
								imgcnt++;		
								bottomyp=imgthumb.y+imgthumb.height;
																					
								
							}
							
							
						}
						
					}				
				}
			}
			
			
			
				var bm2:BtnMore=new BtnMore();
				bm2.buttonMode=true;
				bm2.addEventListener(MouseEvent.CLICK,OnBGImageMoreClicked);
				backgroundview.addChild(bm2);
				var col:int=1;
				var row:int=(r+1);
				bm2.x=(backgroundview.width-bm2.width);//(col*w)+xoffset+(col*5)-10;							
				bm2.y=490;//bottomyp+40;//(backgroundview.height-bm2.height);//(row*h)+yoffset+(row*rowoffset)-10;
			
			
			
		}
		//-----------------------------------------------------		
		private function AddBGMore()
		{
			
		}
		//-----------------------------------------------------		
		//This event is triggered when the background thumbnail is clicked
		//-----------------------------------------------------				
		/*private function OnBackgroundThumbnailClicked(evt:ObjectEvent):void
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
			if(dp.currentPage>=0)
			{
				var bgurl:String=evt.objdata.url;
				
				dp.addBGUrl(evt.objdata,bgurl,dp.currentPage);
				facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
				facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp.currentPage,thumburl:evt.objdata.thumburl});
			}
		}*/		
		
		private function OnBackgroundThumbnailClicked(evt:ObjectEvent):void
		{			
			isDown=false;
			trace("OnBackgroundThumbnailClicked:"+evt.objdata.url);
			
			
			
		}
		//-----------------------------------------------------			
		//-----------------------------------------------------				
		private function OnBackgroundThumbnailDown(evt:ObjectEvent):void
		{			
			isDown=true;
			trace("OnBackgroundThumbnailDown:"+evt.objdata.url);
			
			
		}
		//-----------------------------------------------------				
		private function OnBackgroundThumbnailOut(evt:ObjectEvent):void
		{			
			trace("OnBackgroundThumbnailOut:"+evt.objdata.url);
			if(isDown==true)
			{
				isDown=false;
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
				if(dp.currentPage>=0)
				{
					var bgurl:String=evt.objdata.url;
					
					facade.sendNotification(ApplicationConstants.DRAG_ADD_BG,{pageno:dp.currentPage,thumburl:evt.objdata.thumburl,url:bgurl,objdata:evt.objdata});
				}
				
			}		
			
			
		}
		//-----------------------------------------------------				
		private function OnBackgroundThumbnailUp(evt:ObjectEvent):void
		{			
			trace("OnBackgroundThumbnailUp:"+evt.objdata.url);
			isDown=false;
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
			if(dp.currentPage>=0)
			{
				var bgurl:String=evt.objdata.url;
				
				dp.addBGUrl(evt.objdata,bgurl,dp.currentPage);
				facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
				facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp.currentPage,thumburl:evt.objdata.thumburl});
				//-----------------------------------------------------
				//SaveBook Timer Start
				//-----------------------------------------------------
				facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
				//-----------------------------------------------------
			}
			
		}
		//-----------------------------------------------------				
		private function OnBGImageMoreClicked(evt:MouseEvent):void
		{			
			//load default american symbol datas
			BGClipartProxy(facade.retrieveProxy(BGClipartProxy.NAME)).loadInfo(1,"CLIPART");						
			facade.sendNotification(ApplicationConstants.SHOW_CLIPARTVIEW,"BG");
		}
		//-----------------------------------------------------		
		
		protected function get bgMenuView():BackgroundMenuView
		{
			return viewComponent as BackgroundMenuView;
		}
		
	}
}
