package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.BtnMore;
	import com.learning.atoz.storycreation.view.components.CharacterMenuView;
	import com.learning.atoz.storycreation.view.components.ThumbControl;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.events.MouseEvent;
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class CharacterMenuViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CharacterMenuViewMediator";		
				
		//-----------------------------------------------------		
		public function CharacterMenuViewMediator(viewComponent:Object)
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
			return [ApplicationConstants.PRELOAD_CHR_THUMBNAIL];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.PRELOAD_CHR_THUMBNAIL:			
					GenerateCHRSubMenu();					
					break;
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Generating Background Thumbnails
		//-----------------------------------------------------		
		private function GenerateCHRSubMenu()
		{			
			var characterview:CharacterMenuView=chrMenuView;
			
			var xoffset:int=15;
			var yoffset:int=35;
			var w:int=90;
			var h:int=90;			
			var imgcnt:int=0;
			var maximagecnt:int=12;
			var rowoffset:int=5;//15
			var assetXML:XML=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
			var r:int=0;
			var c:int=0;
			
			while(characterview.numChildren>0)
			{
				characterview.removeChildAt(0);
			}
			
			if(assetXML..Character.length()<=0)
			{
				var bm1:BtnMore=new BtnMore();
				bm1.buttonMode=true;
				bm1.addEventListener(MouseEvent.CLICK,OnCHRImageMoreClicked);
				characterview.addChild(bm1);
				
				bm1.x=70;						
				bm1.y=10;
			}
			
			for(r=0;r<7;r++)
			{
				for(c=0;c<2;c++)
				{					
					if(imgcnt<assetXML..Character.length())
					{
						if(imgcnt<maximagecnt)
						{		
							if(r==4 && c==1)
							{
								var bm3:BtnMore=new BtnMore();
								bm3.buttonMode=true;
								bm3.addEventListener(MouseEvent.CLICK,OnCHRImageMoreClicked);
								characterview.addChild(bm3);
								
								bm3.x=(c*w)+xoffset+(c*5)-10;							
								bm3.y=(r*h)+yoffset+(r*rowoffset)-10;
							}
							else
							{
								var imgthumb:ThumbControl=new ThumbControl();
								imgthumb.addEventListener("BG_THUMB_CLICKED",OnCharacterThumbnailClicked);							
								
								var bgfullurl:String;
								var bgThumb:String;
								
								if(ApplicationConstants.ASSETS_MODE=="LOCAL")
								{
									bgfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+assetXML..Character[imgcnt].Url;
									
									bgThumb=ApplicationConstants.ASSETS_PATH+"assets/"+assetXML..Character[imgcnt].ThumbUrl;
									
								}
								else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
								{
									bgfullurl=assetXML..Character[imgcnt].Url;
									
									bgThumb=assetXML..Character[imgcnt].ThumbUrl;
									
								}
								
								var itemData:Object={unqid:"",id:assetXML..Character[imgcnt].ChrId,name:assetXML..Character[imgcnt].ChrName,catid:assetXML..Character[imgcnt].CatId,subcatid:assetXML..Character[imgcnt].SubCatId,url:bgfullurl,thumburl:bgThumb,type:"CHARACTER",xpos:0,ypos:0,width:0,height:0,rotation:0,flip:0};
								
								//imgthumb.loadswf(assetXML..Character[imgcnt].CatId,assetXML..Character[imgcnt].SubCatId,bgThumb,bgfullurl,"PROPORTIONAL");
								imgthumb.loadswf(itemData,"PROPORTIONAL");
								characterview.addChild(imgthumb);
								imgthumb.x=(c*w)+xoffset+(c*5)+(imgthumb.width/2);
								imgthumb.y=(r*h)+yoffset+(r*rowoffset)+(imgthumb.height/2);
								imgcnt++;	
							}
							
						}
						
					}
					
					//to show more btn when data less than 10
					if(imgcnt==(assetXML..Object.length()-1))
					{
						var bm2:BtnMore=new BtnMore();
						bm2.buttonMode=true;
						bm2.addEventListener(MouseEvent.CLICK,OnCHRImageMoreClicked);
						characterview.addChild(bm2);
						var col:int=1;
						var row:int=(r+1);
						bm2.x=(col*w)+xoffset+(col*5)-10;							
						bm2.y=(row*h)+yoffset+(row*rowoffset)-10;
					}
				}				
			}
			
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//This event is triggered when the background thumbnail is clicked
		//-----------------------------------------------------				
		private function OnCharacterThumbnailClicked(evt:ObjectEvent):void
		{			
			//trace("OnCharacterThumbnailClicked:"+evt.objdata.data..Url);
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
			if(dp.currentPage>=0)
			{
				var chrurl:String=evt.objdata.url;
				if(chrurl.indexOf(".swf")>0)
				{
					facade.sendNotification(ApplicationConstants.ADD_CHARACTER,evt.objdata);
				}
			}
			
			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------				
		private function OnCHRImageMoreClicked(evt:MouseEvent):void
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
			if(dp.currentPage>=0)
			{
				facade.sendNotification(ApplicationConstants.SHOW_CLIPARTVIEW,"CHR");
			}
		}
		//-----------------------------------------------------	
		
		protected function get chrMenuView():CharacterMenuView
		{
			return viewComponent as CharacterMenuView;
		}
		
	}
}
