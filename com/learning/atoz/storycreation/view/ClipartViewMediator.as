package com.learning.atoz.storycreation.view
{	
	//import com.learn.atoz.clipartcomp.atozClipartComponent;
	//import com.learn.atoz.clipartcomp.events.ClipartEvent;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.model.BGClipartProxy;
	import com.learning.atoz.storycreation.model.CHRClipartProxy;
	import com.learning.atoz.storycreation.model.OBJClipartProxy;
	import com.learning.atoz.storycreation.model.SearchProxy;
	import com.learning.atoz.storycreation.view.components.clipart.clipartView;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import com.learning.atoz.storycreation.view.components.clipart.events.ClipartEvent;
	
	import flash.text.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.PopupPlaceHolderView;
	import flash.events.KeyboardEvent;
	
	
	/*
	import com.learn.atoz.clipartcomp.atozClipartComponent;
	import com.learn.atoz.clipartcomp.events.ClipartEvent;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.model.BGClipartProxy;
	import com.learning.atoz.storycreation.model.CHRClipartProxy;
	import com.learning.atoz.storycreation.model.OBJClipartProxy;
	import com.learning.atoz.storycreation.model.SearchProxy;
	import com.learning.atoz.storycreation.view.components.clipart.clipartView;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import com.learning.atoz.storycreation.view.components.clipart.events.ClipartEvent;
	
	import flash.text.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.PopupPlaceHolderView;
	*/
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class ClipartViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ClipartViewMediator";
		private var clipartview:clipartView;
		private var cliparttype:String;
		private var isBgDown:Boolean=false;
		private var isObjDown:Boolean=false;
		//private var clipartview:atozClipartComponent;
		//-----------------------------------------------------		
		public function ClipartViewMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			clipartview=new clipartView();
			clipartview.BtnClose.addEventListener(MouseEvent.CLICK,OnClipArtClose);
			
			clipartview.addEventListener("SUBCAT_THUMB_CLICKED",OnsubCatClicked);
			clipartview.addEventListener("BGTHUMB_CLICKED",OnBGthumbClicked);
			clipartview.addEventListener("BGTHUMB_DOWN",OnBGthumbDown);
			clipartview.addEventListener("BGTHUMB_UP",OnBGthumbUp);
			clipartview.addEventListener("BGTHUMB_OUT",OnBGthumbOut);
			
			
			
			clipartview.addEventListener("CHRTHUMB_CLICKED",OnCHRthumbClicked);			
			clipartview.addEventListener("OBJTHUMB_CLICKED",OnOBJthumbClicked);
			clipartview.addEventListener("OBJTHUMB_DOWN",OnOBJthumbDown);
			clipartview.addEventListener("OBJTHUMB_UP",OnOBJthumbUp);
			clipartview.addEventListener("OBJTHUMB_OUT",OnOBJthumbOut);
			
			
			clipartview.addEventListener("SAVE_SELECTED_CAT_SUBCAT_ID_FROM_CLIPARTVIEW",OnSAVE_SELECTED_CAT_SUBCAT_ID_FROM_CLIPARTVIEW);
			
			clipartview.BtnSearch.addEventListener(MouseEvent.CLICK,OnSearch);
			clipartview.m_searchresultpopup.visible=false;
			clipartview.m_searchresultpopup.BtnOk.visible=false;
			clipartview.m_searchresultpopup.BtnOk.addEventListener(MouseEvent.CLICK,OnSearchResultOk);
			clipartview.lblSearchText.addEventListener(KeyboardEvent.KEY_DOWN,OnSearchKeyDown);
			/*clipartview=new atozClipartComponent();
			clipartview.name="clipartView";
			clipartview.setClipArtAssetPath(ApplicationConstants.ASSETS_PATH);
			clipartview.addEventListener("CLIPART_CLOSE",OnClipArtCloseBtnClicked);
			clipartview.addEventListener("PUT_ON_MYPAGE",OnPutOnMyPageClicked);
			
			
			*/
			
			
		}
		
		
		
		private function OnSearchResultOk(evt:MouseEvent):void
		{
			clipartview.m_searchresultpopup.visible=false;
			clipartview.m_searchresultpopup.BtnOk.visible=false;
		}
		
		private function OnSearchKeyDown(evt:KeyboardEvent)
		{
			//trace("OnSearchKeyDown:"+evt.keyCode);
			//trace("OnSearch=>"+clipartview.lblSearchText.text);
			if(evt.keyCode==13)
			{
				if(clipartview.lblSearchText.text.length>=2)
				{
					clipartview.m_searchresultpopup.visible=true;
					clipartview.m_searchresultpopup.m_searchstatus.text="Searching \""+clipartview.lblSearchText.text+"\" please wait...";
					facade.sendNotification(ApplicationConstants.START_SEARCH,clipartview.lblSearchText.text);
				}
			}
		}
		
		private function OnSearch(evt:MouseEvent):void
		{
			//trace("OnSearch=>"+clipartview.lblSearchText.text);
			if(clipartview.lblSearchText.text.length>=2)
			{
				clipartview.m_searchresultpopup.visible=true;
				clipartview.m_searchresultpopup.m_searchstatus.text="Searching \""+clipartview.lblSearchText.text+"\" please wait...";
				facade.sendNotification(ApplicationConstants.START_SEARCH,clipartview.lblSearchText.text);
			}
		}
		
		private function OnsubCatClicked(objevt:ObjectEvent):void
		{
			trace("OnsubCatClicked=>"+""+objevt.objdata.ClipartType+objevt.objdata.CatId+","+objevt.objdata.SubCatId);
			if(objevt.objdata.ClipartType=="BG")
			{
				BGClipartProxy(facade.retrieveProxy(BGClipartProxy.NAME)).loadInfo(objevt.objdata.SubCatId,"CLIPART");
			}
			else if(objevt.objdata.ClipartType=="CHR")
			{
				CHRClipartProxy(facade.retrieveProxy(CHRClipartProxy.NAME)).loadInfo(objevt.objdata.SubCatId,"CLIPART");
			}
			else if(objevt.objdata.ClipartType=="OBJ")
			{
				OBJClipartProxy(facade.retrieveProxy(OBJClipartProxy.NAME)).loadInfo(objevt.objdata.SubCatId,"CLIPART");
			}
		}
		
		private function OnClipArtClose(evt:MouseEvent):void
		{
			ClipartView.Reset();
			facade.sendNotification(ApplicationConstants.CLOSE_CLIPARTVIEW);
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
			return [ApplicationConstants.SHOW_CLIPARTVIEW,
					ApplicationConstants.CLOSE_CLIPARTVIEW,
					ApplicationConstants.BG_CLIPART_CADATA_LOADED,
					ApplicationConstants.CHR_CLIPART_CADATA_LOADED,
					ApplicationConstants.OBJ_CLIPART_CADATA_LOADED,
					ApplicationConstants.START_SEARCH,
					ApplicationConstants.SEARCH_RESULT];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.SHOW_CLIPARTVIEW:	
					cliparttype=(notification.getBody() as String);
					
					if(ApplicationConstants.USER_TYPE=="FLUENT")
					{
						clipartview.BtnSearch.visible=true;
						clipartview.lblSearchText.visible=true;
						clipartview.lblSearch.visible=true;
						
					}
					else if(ApplicationConstants.USER_TYPE=="EMERGENT")
					{
						clipartview.BtnSearch.visible=false;
						clipartview.lblSearchText.visible=false;
						clipartview.lblSearch.visible=false;
					}
					
					
					trace("SHOW_CLIPARTVIEW1=>"+cliparttype);
					var thm:ThemeProxy=ThemeProxy(facade.retrieveProxy(ThemeProxy.NAME));
					trace("SHOW_CLIPARTVIEW2=>"+thm.vo._xml);
					clipartview.Reset();
					
					var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					var obj:Object=dp.getAppData();
					
					//clipartview.setClipartType(cliparttype);
					
					facade.sendNotification(ApplicationConstants.CLOSE_HOME_BTN);
					
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					PopupPlaceHolder.addChild(clipartview);					
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
					//----
					if(cliparttype=="BG")
					{
						trace("SHOW_CLIPARTVIEW3=>"+obj.bg_more.catid+","+obj.bg_more.subcatid);
						
						//setting default subcat is 1 ie american symbols
						if(Number(obj.bg_more.subcatid)<=0)
						{
							obj.bg_more.subcatid=1;
						}
						clipartview.setClipartType(cliparttype,{cliparttype:"BG",catid:obj.bg_more.catid,subcatid:obj.bg_more.subcatid});						
						clipartview.setThemeXml(thm.vo._xml);
						/*var assetXML:XML=BGClipartProxy(facade.retrieveProxy(BGClipartProxy.NAME)).vo._xml;
						if(assetXML..Background.length()>0)
						{
							facade.sendNotification(ApplicationConstants.BG_CLIPART_CADATA_LOADED,assetXML);
						}*/
					}
					else if(cliparttype=="CHR")
					{
						clipartview.setClipartType(cliparttype,{cliparttype:"CHR",catid:obj.chr_more.catid,subcatid:obj.chr_more.subcatid});
						clipartview.setThemeXml(thm.vo._xml);
					}
					else if(cliparttype=="OBJ")
					{
						if(Number(obj.obj_more.subcatid)<=0)
						{
							obj.obj_more.subcatid=1;
						}
						clipartview.setClipartType(cliparttype,{cliparttype:"OBJ",catid:obj.obj_more.catid,subcatid:obj.obj_more.subcatid});
						clipartview.setThemeXml(thm.vo._xml);
						/*var assetXML:XML=OBJClipartProxy(facade.retrieveProxy(OBJClipartProxy.NAME)).vo._xml;
						if(assetXML..Object.length()>0)
						{
							facade.sendNotification(ApplicationConstants.OBJ_CLIPART_CADATA_LOADED,assetXML);
						}*/
					}
					//---
					break;
				case ApplicationConstants.CLOSE_CLIPARTVIEW:					
					facade.sendNotification(ApplicationConstants.BG_MENU_UPDATE);
					facade.sendNotification(ApplicationConstants.OBJ_MENU_UPDATE);
					facade.sendNotification(ApplicationConstants.SHOW_HOME_BTN);
					facade.sendNotification(ApplicationConstants.SHOW_COPY_PASTE);
					trace("CLOSE_CLIPARTVIEW-1");
					clipartview.Reset();
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					trace("CLOSE_CLIPARTVIEW-2");
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,0);
					trace("CLOSE_CLIPARTVIEW-3");
					break;
				
				case ApplicationConstants.BG_CLIPART_CADATA_LOADED:
					var bgclipart:XML=(notification.getBody() as XML);
					//trace("bgclipart=>"+bgclipart);
					
					if(bgclipart..Object.length()>0)
					{
						OBJClipartProxy(facade.retrieveProxy(OBJClipartProxy.NAME)).setXmlData(bgclipart);
					}
					ClipartView.setClipartData(bgclipart);
					break;
				case ApplicationConstants.CHR_CLIPART_CADATA_LOADED:
					var chrclipart:XML=(notification.getBody() as XML);
					trace("CHR=>"+chrclipart);
					ClipartView.setClipartData(chrclipart);
					break;
				case ApplicationConstants.OBJ_CLIPART_CADATA_LOADED:
					var objclipart:XML=(notification.getBody() as XML);
					//trace("OBJ=>BG_CLIPART_CADATA_LOADED=>obj len=>"+objclipart..Object.length()+",bg len=>"+objclipart..Background.length());				
					if(objclipart..Background.length()>0)
					{
						BGClipartProxy(facade.retrieveProxy(BGClipartProxy.NAME)).setXmlData(objclipart);
					}
					ClipartView.setClipartData(objclipart);
					break;
				case ApplicationConstants.START_SEARCH:
					var searchtext:String=(notification.getBody() as String);
					var searchdp:SearchProxy=SearchProxy(facade.retrieveProxy(SearchProxy.NAME));
					searchdp.Search(searchtext);
					break;
				case ApplicationConstants.SEARCH_RESULT:
					clipartview.m_cattitle2.text="";					
					var searchresult:String=(notification.getBody() as String);
					trace("SearchResult:"+searchresult);
					var dataxml:XML=new XML(searchresult);
					var cptype:String;
					if(cliparttype=="BG")
					{
						if(dataxml..Background.length()>0)
						{
							clipartview.m_searchresultpopup.BtnOk.visible=false;
							clipartview.m_searchresultpopup.visible=false;
							/*clipartview.m_searchresultpopup.visible=true;
							cptype=(dataxml..Background.length()>1)?" Backgrounds":" Background";
							clipartview.m_searchresultpopup.m_searchstatus.text="Results for \""+clipartview.lblSearchText.text+"\" is "+dataxml..Background.length()+cptype;
							clipartview.m_searchresultpopup.BtnOk.visible=true;*/
						}
						else
						{
							clipartview.m_searchresultpopup.visible=true;							
							clipartview.m_searchresultpopup.m_searchstatus.text="No results for \""+clipartview.lblSearchText.text+"\". Try a new word.";
							clipartview.m_searchresultpopup.BtnOk.visible=true;
						}
						
					}
					else if(cliparttype=="CHR")
					{
						if(dataxml..Character.length()>0)
						{
							clipartview.m_searchresultpopup.BtnOk.visible=false;
							clipartview.m_searchresultpopup.visible=false;
							/*clipartview.m_searchresultpopup.visible=true;
							cptype=(dataxml..Character.length()>1)?" Characters":" Character";
							clipartview.m_searchresultpopup.m_searchstatus.text="Results for \""+clipartview.lblSearchText.text+"\" is "+dataxml..Character.length()+cptype;
							clipartview.m_searchresultpopup.BtnOk.visible=true;*/
						}
						else
						{
							clipartview.m_searchresultpopup.visible=true;
							clipartview.m_searchresultpopup.m_searchstatus.text="No results for \""+clipartview.lblSearchText.text+"\". Try a new word.";
							clipartview.m_searchresultpopup.BtnOk.visible=true;
						}
					}
					else if(cliparttype=="OBJ")
					{
						if(dataxml..Object.length()>0)
						{
							clipartview.m_searchresultpopup.BtnOk.visible=false;
							clipartview.m_searchresultpopup.visible=false;
							/*clipartview.m_searchresultpopup.visible=true;
							cptype="Characters & Objects";//(dataxml..Object.length()>1)?" Objects":" Object";
							clipartview.m_searchresultpopup.m_searchstatus.text="Results for \""+clipartview.lblSearchText.text+"\" is "+dataxml..Object.length()+cptype;
							clipartview.m_searchresultpopup.BtnOk.visible=true;*/
						}
						else
						{
							clipartview.m_searchresultpopup.visible=true;
							clipartview.m_searchresultpopup.m_searchstatus.text="No results for \""+clipartview.lblSearchText.text+"\". Try a new word.";
							clipartview.m_searchresultpopup.BtnOk.visible=true;
						}
					}
					clipartview.lblSearchText.text="";
					ClipartView.setClipartData(dataxml);
					break;
			}
		}
		
		private function OnBGthumbClicked(evt:ClipartEvent):void
		{
			trace("OnBGthumbClicked");
			isBgDown=false;
			/*var bgfullurl:String;
			var bgThumb:String;
			var clipartxml:XML;
			trace("OnBGthumbClicked1=>"+evt.objdata.type+","+evt.objdata.id);
			if(evt.objdata.type=="BG")
			{				
				//clipartxml=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
				//var bgdata:*=clipartxml..Background.(BgId==Number(evt.objdata.id));
				
				if(ApplicationConstants.ASSETS_MODE=="LOCAL")
				{
					bgfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.url;							
					bgThumb=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.thumburl;
				}
				else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
				{
					bgfullurl=evt.objdata.url;							
					bgThumb=evt.objdata.thumburl;
				}
				
				//--------------------------------------------------
				//Exception swfs
				//--------------------------------------------------
				var exceptionArr:Array=new Array(625,626,627,628,10051,10057,10058,10059,10060);
				for(var jg:int=0;jg<exceptionArr.length;jg++)
				{
					if(Number(evt.objdata.id)==exceptionArr[jg])
					{
						evt.objdata.thumburl=evt.objdata.url;
						bgThumb=bgfullurl;
						break;
					}
				}							
				trace("bgThumb:"+bgThumb);
				//--------------------------------------------------
				
									
				trace("OnBGthumbClicked2=>bgfullurl:"+bgfullurl+",bgThumb:"+bgThumb);
				var itemData:Object={unqid:"",id:evt.objdata.id,name:evt.objdata.Name,catid:evt.objdata.catid,subcatid:evt.objdata.subcatid,url:bgfullurl,thumburl:bgThumb,type:"BACKGROUND",xpos:0,ypos:0,width:0,height:0,rotation:0};
				
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				
				if(dp.currentPage>=0)
				{
					var bgurl:String=itemData.url;					
					dp.addBGUrl(itemData,bgurl,dp.currentPage);
					facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
					facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp.currentPage,thumburl:evt.objdata.thumburl});
				}
				facade.sendNotification(ApplicationConstants.CLOSE_CLIPARTVIEW);
			}*/
			
		}
		
		private function OnBGthumbDown(evt:ClipartEvent):void
		{
			isBgDown=true;
			trace("OnBGthumbDown");
		}
		
		private function OnBGthumbUp(evt:ClipartEvent):void
		{
			trace("OnBGthumbUp");
			isBgDown=false;
			var bgfullurl:String;
			var bgThumb:String;
			var clipartxml:XML;
			trace("OnBGthumbUp1=>"+evt.objdata.type+","+evt.objdata.id);
			if(evt.objdata.type=="BG")
			{				
				//clipartxml=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
				//var bgdata:*=clipartxml..Background.(BgId==Number(evt.objdata.id));
				
				if(ApplicationConstants.ASSETS_MODE=="LOCAL")
				{
					bgfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.url;							
					bgThumb=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.thumburl;
				}
				else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
				{
					bgfullurl=evt.objdata.url;							
					bgThumb=evt.objdata.thumburl;
				}
				
				//--------------------------------------------------
				//Exception swfs
				//--------------------------------------------------
				var exceptionArr:Array=new Array(625,626,627,628,10051,10057,10058,10059,10060);
				for(var jg:int=0;jg<exceptionArr.length;jg++)
				{
					if(Number(evt.objdata.id)==exceptionArr[jg])
					{
						evt.objdata.thumburl=evt.objdata.url;
						bgThumb=bgfullurl;
						break;
					}
				}							
				trace("bgThumb:"+bgThumb);
				//--------------------------------------------------
				
									
				trace("OnBGthumbClicked2=>bgfullurl:"+bgfullurl+",bgThumb:"+bgThumb);
				var itemData:Object={unqid:"",id:evt.objdata.id,name:evt.objdata.Name,catid:evt.objdata.catid,subcatid:evt.objdata.subcatid,url:bgfullurl,thumburl:bgThumb,type:"BACKGROUND",xpos:0,ypos:0,width:0,height:0,rotation:0};
				
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				
				if(dp.currentPage>=0)
				{
					var bgurl:String=itemData.url;					
					dp.addBGUrl(itemData,bgurl,dp.currentPage);
					facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
					facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp.currentPage,thumburl:evt.objdata.thumburl});
				}
				facade.sendNotification(ApplicationConstants.CLOSE_CLIPARTVIEW);
			}
		}
		
		private function OnBGthumbOut(evt:ClipartEvent):void
		{
			trace("OnBGthumbOut1=>"+isBgDown);
			if(isBgDown==true)
			{
				isBgDown=false;
				
				var bgfullurl:String;
				var bgThumb:String;
				var clipartxml:XML;
				trace("OnBGthumbOut2=>"+evt.objdata.type+","+evt.objdata.id);
				if(evt.objdata.type=="BG")
				{				
					//clipartxml=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
					//var bgdata:*=clipartxml..Background.(BgId==Number(evt.objdata.id));
					
					if(ApplicationConstants.ASSETS_MODE=="LOCAL")
					{
						bgfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.url;							
						bgThumb=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.thumburl;
					}
					else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
					{
						bgfullurl=evt.objdata.url;							
						bgThumb=evt.objdata.thumburl;
					}
					
					//--------------------------------------------------
					//Exception swfs
					//--------------------------------------------------
					var exceptionArr:Array=new Array(625,626,627,628,10051,10057,10058,10059,10060);
					for(var jg:int=0;jg<exceptionArr.length;jg++)
					{
						if(Number(evt.objdata.id)==exceptionArr[jg])
						{
							evt.objdata.thumburl=evt.objdata.url;
							bgThumb=bgfullurl;
							break;
						}
					}							
					trace("bgThumb:"+bgThumb);
					//--------------------------------------------------
					
										
					trace("OnBGthumbClicked2=>bgfullurl:"+bgfullurl+",bgThumb:"+bgThumb);
					var itemData:Object={unqid:"",id:evt.objdata.id,name:evt.objdata.Name,catid:evt.objdata.catid,subcatid:evt.objdata.subcatid,url:bgfullurl,thumburl:bgThumb,type:"BACKGROUND",xpos:0,ypos:0,width:0,height:0,rotation:0};
					
					var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					
					if(dp.currentPage>=0)
					{
						var bgurl:String=itemData.url;
						facade.sendNotification(ApplicationConstants.DRAG_ADD_BG,{pageno:dp.currentPage,thumburl:evt.objdata.thumburl,url:bgurl,objdata:evt.objdata});
						
					}
					facade.sendNotification(ApplicationConstants.CLOSE_CLIPARTVIEW);
				}
			}
		}
		
		private function OnCHRthumbClicked(evt:ClipartEvent):void
		{
			var bgfullurl:String;
			var bgThumb:String;
			var clipartxml:XML;
			
			if(evt.objdata.type=="CHR")
			{				
				//clipartxml=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
				//var chrdata:*=clipartxml..Character.(ChrId==Number(evt.objdata.id));
				var chrfullurl:String;
				var chrThumb:String
				
				
				if(ApplicationConstants.ASSETS_MODE=="LOCAL")
				{
					chrfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.url;
					
					chrThumb=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.thumburl;
				}
				else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
				{
					chrfullurl=evt.objdata.url;
					
					chrThumb=evt.objdata.thumburl;
				}
				
				
				var citemData:Object={unqid:"",id:evt.objdata.id,name:evt.objdata.Name,catid:evt.objdata.catid,subcatid:evt.objdata.subcatid,url:chrfullurl,thumburl:chrThumb,type:"CHARACTER",xpos:0,ypos:0,width:0,height:0,rotation:0};
				
				var cdp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				
				if(cdp.currentPage>=0)
				{
					var chrurl:String=citemData.url;
					if(chrurl.indexOf(".swf")>0)
					{
						facade.sendNotification(ApplicationConstants.ADD_CHARACTER,citemData);
					}
				}
				facade.sendNotification(ApplicationConstants.CLOSE_CLIPARTVIEW);
			}
		}
		
		private function OnOBJthumbClicked(evt:ClipartEvent):void
		{
			isObjDown=false;
			
		}
		
		private function OnOBJthumbDown(evt:ClipartEvent):void
		{
			isObjDown=true;
		}
		
		private function OnOBJthumbUp(evt:ClipartEvent):void
		{
			isObjDown=false;
			var bgfullurl:String;
			var bgThumb:String;
			var clipartxml:XML;
			
			if(evt.objdata.type=="OBJ")
			{				
				//clipartxml=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
				//var objdata:*=clipartxml..Object.(ObjId==Number(evt.objdata.id));
				
				var objfullurl:String;
				var objThumb:String;
								
				if(ApplicationConstants.ASSETS_MODE=="LOCAL")
				{
					objfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.url;							
					objThumb=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.thumburl;
				}
				else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
				{
					objfullurl=evt.objdata.url;				
					objThumb=evt.objdata.thumburl;
				}
				
				
				var oitemData:Object={unqid:"",id:evt.objdata.id,name:evt.objdata.Name,catid:evt.objdata.catid,subcatid:evt.objdata.subcatid,url:objfullurl,thumburl:objThumb,type:"OBJECT",xpos:0,ypos:0,width:0,height:0,rotation:0};
				
				
				var odp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
				if(odp.currentPage>=0)
				{
					var objurl:String=oitemData.url;
					if(objurl.indexOf(".swf")>0)
					{
						facade.sendNotification(ApplicationConstants.ADD_OBJECT,oitemData);
					}
				}
				facade.sendNotification(ApplicationConstants.CLOSE_CLIPARTVIEW);
			}
		}
		
		private function OnOBJthumbOut(evt:ClipartEvent):void
		{
			if(isObjDown==true)
			{
				isObjDown=false;
				var bgfullurl:String;
				var bgThumb:String;
				var clipartxml:XML;
				
				if(evt.objdata.type=="OBJ")
				{				
					//clipartxml=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).vo._xml;
					//var objdata:*=clipartxml..Object.(ObjId==Number(evt.objdata.id));
					
					var objfullurl:String;
					var objThumb:String;
									
					if(ApplicationConstants.ASSETS_MODE=="LOCAL")
					{
						objfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.url;							
						objThumb=ApplicationConstants.ASSETS_PATH+"assets/"+evt.objdata.thumburl;
					}
					else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
					{
						objfullurl=evt.objdata.url;				
						objThumb=evt.objdata.thumburl;
					}
					
					
					var oitemData:Object={unqid:"",id:evt.objdata.id,name:evt.objdata.Name,catid:evt.objdata.catid,subcatid:evt.objdata.subcatid,url:objfullurl,thumburl:objThumb,type:"OBJECT",xpos:0,ypos:0,width:0,height:0,rotation:0};
					
					
					var odp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
					if(odp.currentPage>=0)
					{
						var objurl:String=oitemData.url;
						if(objurl.indexOf(".swf")>0)
						{
							facade.sendNotification(ApplicationConstants.DRAG_ADD_OBJECT,oitemData);
						}
					}
					facade.sendNotification(ApplicationConstants.CLOSE_CLIPARTVIEW);
				}
			}
		}
		
		private function OnSAVE_SELECTED_CAT_SUBCAT_ID_FROM_CLIPARTVIEW(evt:ClipartEvent):void
		{			
			trace("OnSAVE_SELECTED_CAT_SUBCAT_ID_FROM_CLIPARTVIEW=>"+evt.objdata.catid+","+evt.objdata.subcatid);
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			var obj:Object;
			if(evt.objdata.cliparttype=="BG")
			{
				obj=dp.getAppData();
				obj.bg_more.catid=Number(evt.objdata.catid);
				obj.bg_more.subcatid=Number(evt.objdata.subcatid);
				
				/*obj.chr_more.catid=Number(evt.objdata.catid);
				obj.chr_more.subcatid=Number(evt.objdata.subcatid);*/
				
				
				
				//check whether the selected subcat has objects otherwise set default subcatid
				var thm:ThemeProxy=ThemeProxy(facade.retrieveProxy(ThemeProxy.NAME));
				for(var s1:int=0;s1<thm.vo._xml..SubCategory.length();s1++)
				{
					if(thm.vo._xml..SubCategory[s1].@SubCatId==evt.objdata.subcatid)
					{
						if(Number(thm.vo._xml..SubCategory[s1].@objects)>0)
						{
							obj.obj_more.catid=Number(evt.objdata.catid);
							obj.obj_more.subcatid=Number(evt.objdata.subcatid);
						}
						else
						{
							obj.obj_more.subcatid=1;//Ameriacan symbols by default
						}
						break;
					}
				}				
				
								
				
				
				dp.setAppDataObject(obj);
			}
			else if(evt.objdata.cliparttype=="CHR")
			{
				obj=dp.getAppData();
				//obj.bg_more.catid=Number(evt.objdata.catid);
				//obj.bg_more.subcatid=Number(evt.objdata.subcatid);
				
				obj.chr_more.catid=Number(evt.objdata.catid);
				obj.chr_more.subcatid=Number(evt.objdata.subcatid);
				
				//obj.obj_more.catid=Number(evt.objdata.catid);
				//obj.obj_more.subcatid=Number(evt.objdata.subcatid);
				dp.setAppDataObject(obj);
			}
			else if(evt.objdata.cliparttype=="OBJ")
			{
				obj=dp.getAppData();
				
				//check whether the selected subcat has objects otherwise set default subcatid
				var thm2:ThemeProxy=ThemeProxy(facade.retrieveProxy(ThemeProxy.NAME));
				for(var s2:int=0;s2<thm2.vo._xml..SubCategory.length();s2++)
				{
					if(thm2.vo._xml..SubCategory[s2].@SubCatId==evt.objdata.subcatid)
					{
						if(Number(thm2.vo._xml..SubCategory[s2].@backgrounds)>0)
						{
							obj.bg_more.catid=Number(evt.objdata.catid);
							obj.bg_more.subcatid=Number(evt.objdata.subcatid);
						}
						else
						{
							obj.bg_more.subcatid=1;//american symbols default
						}
						break;
					}
				}
				
				/*obj.chr_more.catid=Number(evt.objdata.catid);
				obj.chr_more.subcatid=Number(evt.objdata.subcatid);*/
				
				obj.obj_more.catid=Number(evt.objdata.catid);
				obj.obj_more.subcatid=Number(evt.objdata.subcatid);
				dp.setAppDataObject(obj);
			}
		}
		
		
		//-----------------------------------------------------		
		protected function get PopupPlaceHolder():PopupPlaceHolderView
		{
			return viewComponent as PopupPlaceHolderView;
		}
		
		//-----------------------------------------------------
		protected function get ClipartView():clipartView
		{
			return clipartview as clipartView;
		}
		
	}
	
}
