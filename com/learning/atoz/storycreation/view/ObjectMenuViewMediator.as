package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.BtnMore;
	import com.learning.atoz.storycreation.view.components.ObjectMenuView;
	import com.learning.atoz.storycreation.view.components.ThumbControl;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.events.MouseEvent;
	import com.learning.atoz.storycreation.model.OBJClipartProxy;
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class ObjectMenuViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ObjectMenuViewMediator";		
		private var isDown:Boolean=false;		
		//-----------------------------------------------------		
		public function ObjectMenuViewMediator(viewComponent:Object)
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
			return [ApplicationConstants.OBJ_MENU_UPDATE]; //ApplicationConstants.PRELOAD_OBJ_THUMBNAIL
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.OBJ_MENU_UPDATE://ApplicationConstants.PRELOAD_OBJ_THUMBNAIL:			
					GenerateOBJSubMenu();					
					break;
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Generating Background Thumbnails
		//-----------------------------------------------------		
		private function GenerateOBJSubMenu()
		{			
			var objectview:ObjectMenuView=objMenuView;
			
			var xoffset:int=15;
			var yoffset:int=35;
			var w:int=90;
			var h:int=90;			
			var imgcnt:int=0;
			var maximagecnt:int=10;
			var rowoffset:int=5;//15
			//var assetXML:XML=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
			var assetXML:XML=OBJClipartProxy(facade.retrieveProxy(OBJClipartProxy.NAME)).vo._xml;
					
			
			trace("GenerateOBJSubMenu=>assetXML..Object.length()=>"+assetXML..Object.length());
			while(objectview.numChildren>0)
			{
				objectview.removeChildAt(0);
			}
			
			/*if(assetXML..Object.length()<=0)
			{
				var bm:BtnMore=new BtnMore();
				bm.buttonMode=true;
				bm.addEventListener(MouseEvent.CLICK,OnOBJImageMoreClicked);
				objectview.addChild(bm);
				
				bm.x=70;						
				bm.y=10;
			}*/
			
			for(var r:int=0;r<5;r++)
			{
				for(var c:int=0;c<2;c++)
				{					
					if(imgcnt<assetXML..Object.length())
					{
						if(imgcnt<maximagecnt)
						{			
							/*if(r==4 && c==1)
							{
								//var bm:BtnMore=new BtnMore();
								//bm.buttonMode=true;
								//bm.addEventListener(MouseEvent.CLICK,OnOBJImageMoreClicked);
								//objectview.addChild(bm);
								
								//bm.x=(c*w)+xoffset+(c*5)-10;							
								//bm.y=(r*h)+yoffset+(r*rowoffset)-10;
							}
							else
							{*/
								var imgthumb:ThumbControl=new ThumbControl();
								imgthumb.addEventListener("BG_THUMB_CLICKED",OnObjectThumbnailClicked);	
								imgthumb.addEventListener("BG_THUMB_DOWN",OnObjectThumbnailDown);	
								imgthumb.addEventListener("BG_THUMB_UP",OnObjectThumbnailUp);
								imgthumb.addEventListener("BG_THUMB_OUT",OnObjectThumbnailOut);
								var bgfullurl:String;
								var bgThumb:String;
								if(ApplicationConstants.ASSETS_MODE=="LOCAL")
								{
									bgfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+assetXML..Object[imgcnt].Url;							
									bgThumb=ApplicationConstants.ASSETS_PATH+"assets/"+assetXML..Object[imgcnt].ThumbUrl;
								}
								else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
								{
									bgfullurl=assetXML..Object[imgcnt].Url;							
									bgThumb=assetXML..Object[imgcnt].ThumbUrl;
								}
								
								
								var itemData:Object={unqid:"",id:assetXML..Object[imgcnt].ObjId,name:assetXML..Object[imgcnt].ObjName,catid:assetXML..Object[imgcnt].CatId,subcatid:assetXML..Object[imgcnt].SubCatId,url:bgfullurl,thumburl:bgThumb,type:"OBJECT",xpos:0,ypos:0,width:0,height:0,rotation:0,flip:0};
								//imgthumb.loadswf(assetXML..Object[imgcnt].CatId,assetXML..Object[imgcnt].SubCatId,bgThumb,bgfullurl,"PROPORTIONAL");
								imgthumb.loadswf(itemData,"PROPORTIONAL");
								objectview.addChild(imgthumb);
								imgthumb.x=(c*w)+xoffset+(c*5)+(imgthumb.width/2);
								imgthumb.y=(r*h)+yoffset+(r*rowoffset)+(imgthumb.height/2);
								imgcnt++;	
							//}
							
						}
						
					}			
					
					
				}				
			}
			
			//to show more btn when data less than 10
			//if(imgcnt==(assetXML..Object.length()-1))
			//{
				var bm3:BtnMore=new BtnMore();
				bm3.buttonMode=true;
				bm3.addEventListener(MouseEvent.CLICK,OnOBJImageMoreClicked);
				objectview.addChild(bm3);
				var col:int=1;
				var row:int=(r+1);
				bm3.x=(objectview.width-bm3.width);//(col*w)+xoffset+(col*5)-10;							
				bm3.y=490;//(row*h)+yoffset+(row*rowoffset)-10;
			//}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//This event is triggered when the background thumbnail is clicked
		//-----------------------------------------------------				
		private function OnObjectThumbnailClicked(evt:ObjectEvent):void
		{			
			isDown=false;
			trace("OnObjectThumbnailClicked:"+evt.objdata.url);
			
			/*var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
			if(dp.currentPage>=0)
			{
				var objurl:String=evt.objdata.url;
				if(objurl.indexOf(".swf")>0)
				{
					facade.sendNotification(ApplicationConstants.ADD_OBJECT,evt.objdata);
				}
			}*/
			
		}
		//-----------------------------------------------------			
		//-----------------------------------------------------				
		private function OnObjectThumbnailDown(evt:ObjectEvent):void
		{			
			isDown=true;
			trace("OnObjectThumbnailDown:"+evt.objdata.url);
			//facade.sendNotification(ApplicationConstants.DRAG_ADD_OBJECT,evt.objdata);
			/*var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
			if(dp.currentPage>=0)
			{
				var objurl:String=evt.objdata.url;
				if(objurl.indexOf(".swf")>0)
				{
					facade.sendNotification(ApplicationConstants.ADD_OBJECT,evt.objdata);
				}
			}*/
			
		}
		//-----------------------------------------------------				
		private function OnObjectThumbnailOut(evt:ObjectEvent):void
		{			
			trace("OnObjectThumbnailOut:"+evt.objdata.url);
			if(isDown==true)
			{
				isDown=false;
				facade.sendNotification(ApplicationConstants.DRAG_ADD_OBJECT,evt.objdata);
			}		
			
			
		}
		//-----------------------------------------------------				
		private function OnObjectThumbnailUp(evt:ObjectEvent):void
		{			
			trace("OnObjectThumbnailUp:"+evt.objdata.url);
			isDown=false;
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
			if(dp.currentPage>=0)
			{
				var objurl:String=evt.objdata.url;
				if(objurl.indexOf(".swf")>0)
				{
					facade.sendNotification(ApplicationConstants.ADD_OBJECT,evt.objdata);
					
					//-----------------------------------------------------
					//SaveBook Timer Start
					//-----------------------------------------------------
					facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
					//-----------------------------------------------------
				}
			}
			
		}
		//-----------------------------------------------------				
		private function OnOBJImageMoreClicked(evt:MouseEvent):void
		{
			trace("OnOBJImageMoreClicked");
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
			if(dp.currentPage>=0)
			{
				//load default american symbol datas
				OBJClipartProxy(facade.retrieveProxy(OBJClipartProxy.NAME)).loadInfo(1,"CLIPART");
				facade.sendNotification(ApplicationConstants.SHOW_CLIPARTVIEW,"OBJ");
			}
		}
		//-----------------------------------------------------	
		
		protected function get objMenuView():ObjectMenuView
		{
			return viewComponent as ObjectMenuView;
		}
		
	}
}
