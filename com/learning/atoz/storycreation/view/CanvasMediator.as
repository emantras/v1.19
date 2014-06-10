package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.BookTitle;
	import com.learning.atoz.storycreation.view.components.Canvas;
	import com.learning.atoz.storycreation.view.components.stageContentMask;
	import com.learning.atoz.storycreation.view.components.callout.CalloutTextView;
	
	import fl.text.TLFTextField;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;	
	
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.conversion.ConversionType;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;		
	import com.learning.atoz.storycreation.UID;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.SubmitBookProxy;

	
	
	/*
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.BookTitle;
	import com.learning.atoz.storycreation.view.components.Canvas;
	import com.learning.atoz.storycreation.view.components.stageContentMask;
	import com.learning.atoz.storycreation.view.components.callout.CalloutTextView;
	
	import fl.text.TLFTextField;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;	
	
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.conversion.ConversionType;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;		
	import com.learning.atoz.storycreation.UID;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	
	
	*/

	/*
		CanvasMediator is used to load and handle all canvas related events
	*/
	
	public class CanvasMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CanvasMediator";						
		private var canvas:Canvas;
		private var booktitle:BookTitle;
		private var chrCnt:int=0;
		private var objCnt:int=0;
		private var stagew:int=580;
		private var stageh:int=580;	
		private var layoutText:TLFTextField;
		public var stagecontentmask:stageContentMask;
		public var booktype:String="";//new/edit
		public var editDataCompleted:int=0;
		
		//private var undomanager:UndoManager;
		//private var editmanager:EditManager;
		//-----------------------------------------------------		
		public function CanvasMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{
			layoutText=new TLFTextField();
			layoutText.name="layoutText";
			layoutText.background=true;
			layoutText.border=true;
			layoutText.type=TextFieldType.INPUT;
			layoutText.borderColor=0xE0E0E0;
			layoutText.borderWidth=3;
			layoutText.addEventListener(MouseEvent.CLICK,OnlayoutTextClicked);
			layoutText.paddingLeft=10;
			layoutText.paddingTop=10;
			layoutText.paddingRight=10;
			layoutText.paddingBottom=10;
			layoutText.wordWrap=true;
			layoutText.multiline=true;
			//layoutText.antiAliasType=AntiAliasType.ADVANCED;
			
			var tlfFormat:TextLayoutFormat = new TextLayoutFormat();
			tlfFormat.fontFamily = "Arial";
			tlfFormat.fontSize=14;
			tlfFormat.color="#000000";
			//tlfFormat.fontLookup = FontLookup.DEVICE;//FontLookup.EMBEDDED_CFF;//
			layoutText.textFlow.hostFormat=tlfFormat;
			
			//undomanager = new UndoManager();
			//editmanager = new EditManager(undomanager);			
			//_parentObj.flowMaster.interactionManager=editmanager;//null;
			
			//default TextFormat
			//var tf:String='<TextFlow color="#FF0000" columnCount="0" columnGap="0"  paddingBottom="10" paddingLeft="10" paddingRight="10" paddingTop="10" paragraphSpaceAfter="0" paragraphSpaceBefore="0" verticalAlign="top" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008">';
			//layoutText.tlfMarkup=tf;				
			
			
			stagecontentmask=new stageContentMask();
			stagecontentmask.name="stageContentMask";
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
			return [ApplicationConstants.CLEAR_CANVAS,
				ApplicationConstants.UPDATE_CANVAS,
				ApplicationConstants.SHOW_CANVAS,
				ApplicationConstants.ADD_CANVAS_BG,
				ApplicationConstants.REMOVE_CANVAS_BG,
				ApplicationConstants.SHOW_LAYOUT_1,
				ApplicationConstants.SHOW_LAYOUT_2,
				ApplicationConstants.SHOW_LAYOUT_3,
				ApplicationConstants.SHOW_LAYOUT_4,
				ApplicationConstants.SHOW_LAYOUT_5,
				ApplicationConstants.SHOW_LAYOUT_6,
				ApplicationConstants.SAVE_BEFORE_REDIRECT_PAGE,
				ApplicationConstants.NEW_BOOK,
				ApplicationConstants.SAVE_BOOK,
				ApplicationConstants.EDIT_BOOK,
				ApplicationConstants.SUBMIT_BOOK,
				ApplicationConstants.SAVE_TEXT,
				ApplicationConstants.SAVE_BOOK_AND_STOP_TIMER
				];
		}
		//-----------------------------------------------------		
		
		
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.SHOW_CANVAS:
					initCanvas();
					UpdateCanvas();
				break;
				
				case ApplicationConstants.ADD_CANVAS_BG:
					var bgurl:String=(notification.getBody() as String);
					loadCanvasBG(bgurl);
					UpdateCanvas();
				break;
				
				case ApplicationConstants.REMOVE_CANVAS_BG:
					UpdateCanvas();
				break;
				
				case ApplicationConstants.UPDATE_CANVAS:
					UpdateCanvas();
				break;
				
				case ApplicationConstants.CLEAR_CANVAS:
					ClearCanvas();
				break;
				
				case ApplicationConstants.SHOW_LAYOUT_1:
					showLayout(1);
				break;
				
				case ApplicationConstants.SHOW_LAYOUT_2:
					showLayout(2);
					break;
				
				case ApplicationConstants.SHOW_LAYOUT_3:
					showLayout(3);
					break;
				
				case ApplicationConstants.SHOW_LAYOUT_4:
					showLayout(4);
					break;
				
				case ApplicationConstants.SHOW_LAYOUT_5:
					showLayout(5);
					break;
				
				case ApplicationConstants.SHOW_LAYOUT_6:
					showLayout(6);
					break;
				
				case ApplicationConstants.SAVE_BEFORE_REDIRECT_PAGE:
					var npageno:int=(notification.getBody() as int);
					SaveAndRedirectToNewPage(npageno);
					break;
				
				case ApplicationConstants.NEW_BOOK:					
					//clearBook();
					booktype="new";					
					ClearAll();
					AddCoverPage();
					var btobj2:*=canvas.getChildByName("bookTitle")
					if(btobj2!=null)
					{						
						booktitle.update(245,60);						
					}
					break;
				
				case ApplicationConstants.SAVE_BOOK:
					//savepage before saving book
					SavePage();
					
					break;
					
				case ApplicationConstants.SUBMIT_BOOK:
					//savepage before saving book
					SubmitBook();
					
					break;				
				
				case ApplicationConstants.EDIT_BOOK:					
					//Clear Book
					booktype="edit";
					editDataCompleted=0;
					//clearBook();
					ClearAll();
					
					//load book					
					var bookdata:String=(notification.getBody() as String);
					loadBookData(bookdata);					
					break;
				
				case ApplicationConstants.SAVE_TEXT:
					SaveText();
					break;
					
				case ApplicationConstants.SAVE_BOOK_AND_STOP_TIMER:
					SavePageAndStopTimer();				
				
			}
		}
		private function ClearAll()
		{
			//--------------------------------------------------------------
			//ClearCanvas
			//--------------------------------------------------------------
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			//----------------------------------------------------
			//Clear All Pages including cover image
			//----------------------------------------------------
			for(var da:int=0;da<dp.getDataArray().length;da++)
			{			
				facade.sendNotification(ApplicationConstants.DELETE_PAGE_THUMBNAIL,dp.getDataArray()[da].Pageno);
			}
			var btobj2:*=canvas.getChildByName("bookTitle")
			if(btobj2!=null)
			{
				booktitle.txtbookTitle.text="";
				canvas.removeChild(booktitle);
			}
			
			dp.ResetBook();
			canvas.clearStage();
			canvas.clearChrObjects();			
			//--------------------------------------------------------------
		}
		private function clearBook()
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			//----------------------------------------------------
			//Clear All Pages including cover image
			//----------------------------------------------------
			for(var da:int=0;da<dp.getDataArray().length;da++)
			{			
				facade.sendNotification(ApplicationConstants.DELETE_PAGE_THUMBNAIL,dp.getDataArray()[da].Pageno);
			}
			
			
			/*var stageContClip=canvas.getChildByName("stageContent");			
			if(stageContClip!=null)
			{
				var btobj2:*=stageContClip.getChildByName("bookTitle")
				if(btobj2!=null)
				{
					stageContClip.removeChild(booktitle);
				}
			}*/
			
			
			var btobj2:*=canvas.getChildByName("bookTitle")
			if(btobj2!=null)
			{
				booktitle.txtbookTitle.text="";
				canvas.removeChild(booktitle);
			}
			
			dp.ResetBook();
			
			//----------------------------------------------------			
			
		}
		
		private function AddCoverPage()
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			//----------------------------------------------------
			//add cover page
			//----------------------------------------------------			
			//pageThumbnail
			facade.sendNotification(ApplicationConstants.ADD_PAGE_THUMBNAIL,{type:"FRONTCOVER",pageno:0,thumburl:""});			
			
			//set current page as coverpage ie 0
			dp.currentPage=0;
			
			
			var xp=(canvas.width/2)-(booktitle.width/2);
			var yp=(canvas.height/2)-(booktitle.height/2)-200;
					
			dp.setBookTitle("",xp,yp,booktitle.booktitlebg.width,booktitle.booktitlebg.height,dp.currentPage);
			
			//facade.sendNotification(ApplicationConstants.DUPLICATE_DISABLE);
			//update canvas
			UpdateCanvas();
			//----------------------------------------------------
		}
		/*
		<page id="0">
		<booktitle>Book Title</booktitle>
		<layout>4</layout>
		<background>
		<BgId>1</BgId>
		</background>
		<characters>
		<character>
		<ChrId>159</ChrId>
		<xpos>417</xpos>
		<ypos>374</ypos>
		<width>56.35</width>
		<height>200</height>
		<rotation>0</rotation>
		</character>
		</characters>
		<objects>
		<object>
		<ObjId>189</ObjId>
		<xpos>181</xpos>
		<ypos>341</ypos>
		<width>74.25</width>
		<height>78</height>
		<rotation>0</rotation>
		</object>
		</objects>
		<texts>
		<text>
		<TextId>1</TextId>
		<text/>
		<xpos>100</xpos>
		<ypos>100</ypos>
		<width>580</width>
		<height>580</height>
		<curvex>0</curvex>
		<curvey>0</curvey>
		<rotation>undefined</rotation>
		</text>
		</texts>
		</page>
		*/
		private function loadBookData(bookdata:String)
		{
			trace("loadBookData1=>"+bookdata);
			facade.sendNotification(ApplicationConstants.SHOW_WAIT_POPUP,"Loading Pages.....");			
			var bookXML:XML=new XML(bookdata);
			trace("loadBookData2=>"+bookXML);
			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(bookXML..appdata.length()>0)
			{
				dp.setAppData(bookXML..appdata[0]);
			}
			
			trace("loadBookData3=>"+bookXML..page.length());
			if(bookXML..UserType.length()>0)
			{
				ApplicationConstants.USER_TYPE=bookXML..UserType[0];
				dp.UserType=bookXML..UserType[0];
				trace("ApplicationConstants.USER_TYPE=>"+ApplicationConstants.USER_TYPE);
			}
			
			if(bookXML..page.length()>0)
			{				
				trace("loadBookData4=>");
				var bgthumburl:String="";
				if(bookXML..page[0].background.length()>0)
				{
					bgthumburl=String(bookXML..page[0].background[0].thumburl);				
				}
				trace("loadBookData4.1=>"+bgthumburl);
				//Front Cover page bg thumbnail restore
				facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:Number(bookXML..page[0].@pageno),type:String(bookXML..page[0].@type),thumburl:bgthumburl});													
				
				
				var cp:ClipartProxy=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME));	
				trace("loadBookData5=>");
				for(var dy:int=0;dy<bookXML..page.length();dy++)
				{			
					trace("loadBookData6=>");
					//ApplicationConstants.USER_TYPE=bookXML..page[dy].UserType;
					//pageThumbnail					
					var turl:String="";
					if(bookXML..page[dy].background.length()>0)
					{
						turl=String(bookXML..page[dy].background[0].thumburl);
					}
					facade.sendNotification(ApplicationConstants.ADD_PAGE_THUMBNAIL,{pageno:Number(bookXML..page[dy].@pageno),type:String(bookXML..page[dy].@type),thumburl:turl});										
					trace("loadBookData7=>");
				}
				
				for(var dy2:int=0;dy2<bookXML..page.length();dy2++)
				{
					trace("loadBookData8=>");
					//,booktitle.x,booktitle.y,booktitle.booktitlebg.width,booktitle.booktitlebg.height
					//Book Title
					if(Number(bookXML..page[dy2].@pageno)==0)
					{
						
						dp.setBookTitle(String(bookXML..page[dy2].booktitle),Number(bookXML..page[dy2].booktitle_xpos),
										Number(bookXML..page[dy2].booktitle_ypos),Number(bookXML..page[dy2].booktitle_width),
										Number(bookXML..page[dy2].booktitle_height),Number(bookXML..page[dy2].@pageno));
					}
						trace("loadBookData9=>");
					
					
					//Background
					if(bookXML..page[dy2].background.length()>0)
					{
						trace("loadBookData10=>");
						var bgid:Number=Number(bookXML..page[dy2].background[0].BgId);
						
						//var bgdata:*=cp.vo._xml..Background.(BgId==bgid);
						var bgfullurl:String;
						var bgThumb:String;
						if(ApplicationConstants.ASSETS_MODE=="LOCAL")
						{
							bgfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+bookXML..page[dy2].background[0].url;							
							bgThumb=ApplicationConstants.ASSETS_PATH+"assets/"+bookXML..page[dy2].background[0].thumburl;
						}
						else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
						{
							bgfullurl=bookXML..page[dy2].background[0].url;							
							bgThumb=bookXML..page[dy2].background[0].thumburl;
						}
						
						var itemData:Object={unqid:UID.createUID(),level:0,id:bookXML..page[dy2].background[0].BgId,name:bookXML..page[dy2].background[0].name,catid:bookXML..page[dy2].background[0].catid,subcatid:bookXML..page[dy2].background[0].subcatid,url:bgfullurl,thumburl:bgThumb,type:"BACKGROUND",xpos:0,ypos:0,width:0,height:0,rotation:0};
						dp.addBGUrl(itemData,bgfullurl,Number(bookXML..page[dy2].@pageno));
					}
					trace("loadBookData11=>");
					//DataList
					if(bookXML..page[dy2].datalist.data.length()>0)
					{
						trace("loadBookData12=>");
						for(var ch:int=0;ch<bookXML..page[dy2].datalist.data.length();ch++)
						{
							trace("loadBookData11=>"+bookXML..page[dy2].datalist.data[ch].type);
							if(bookXML..page[dy2].datalist.data[ch].type=="CHARACTER")
							{
								var chrid:Number=Number(bookXML..page[dy2].datalist.data[ch].ChrId);
								trace("loadBookData13=>");
								//var chrdata:*=cp.vo._xml..Character.(ChrId==chrid);
								var chrfullurl:String;
								var chrThumb:String;
								if(ApplicationConstants.ASSETS_MODE=="LOCAL")
								{
									chrfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+bookXML..page[dy2].datalist.data[ch].url;							
									chrThumb=ApplicationConstants.ASSETS_PATH+"assets/"+bookXML..page[dy2].datalist.data[ch].thumburl;
								}
								else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
								{
									chrfullurl=bookXML..page[dy2].datalist.data[ch].url;							
									chrThumb=bookXML..page[dy2].datalist.data[ch].thumburl;
								}
								trace("loadBookData14=>");
								var citemData:Object={unqid:UID.createUID(),
									level:Number(bookXML..page[dy2].datalist.data[ch].level),
									id:bookXML..page[dy2].datalist.data[ch].ChrId,
									name:bookXML..page[dy2].datalist.data[ch].name,
									catid:bookXML..page[dy2].datalist.data[ch].catid,
									subcatid:bookXML..page[dy2].datalist.data[ch].subcatid,
									url:chrfullurl,
									thumburl:chrThumb,
									type:"CHARACTER",xpos:bookXML..page[dy2].datalist.data[ch].xpos,ypos:bookXML..page[dy2].datalist.data[ch].ypos,
									width:bookXML..page[dy2].datalist.data[ch].width,height:bookXML..page[dy2].datalist.data[ch].height,
									rotation:bookXML..page[dy2].datalist.data[ch].rotation,
									scalex:bookXML..page[dy2].datalist.data[ch].scalex,
									scaley:bookXML..page[dy2].datalist.data[ch].scaley,flip:bookXML..page[dy2].datalist.data[ch].flip};
								dp.InsertCharacter(Number(bookXML..page[dy2].@pageno),citemData);
								trace("loadBookData15=>");
							}
							else if(bookXML..page[dy2].datalist.data[ch].type=="OBJECT")
							{
								var objid:Number=Number(bookXML..page[dy2].datalist.data[ch].ObjId);
								trace("loadBookData16=>");
								//var objdata:*=cp.vo._xml..Object.(ObjId==objid);
								var objfullurl:String;
								var objThumb:String;
								if(ApplicationConstants.ASSETS_MODE=="LOCAL")
								{
									objfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+bookXML..page[dy2].datalist.data[ch].url;							
									objThumb=ApplicationConstants.ASSETS_PATH+"assets/"+bookXML..page[dy2].datalist.data[ch].thumburl;
								}
								else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
								{
									objfullurl=bookXML..page[dy2].datalist.data[ch].url;							
									objThumb=bookXML..page[dy2].datalist.data[ch].thumburl;
								}
								trace("loadBookData17=>");
								//
								var oitemData:Object={unqid:UID.createUID(),level:Number(bookXML..page[dy2].datalist.data[ch].level),
									id:bookXML..page[dy2].datalist.data[ch].ObjId,
									name:bookXML..page[dy2].datalist.data[ch].name,
									catid:bookXML..page[dy2].datalist.data[ch].catid,
									subcatid:bookXML..page[dy2].datalist.data[ch].subcatid,
									url:objfullurl,
									thumburl:objThumb,type:"OBJECT",
									xpos:Number(bookXML..page[dy2].datalist.data[ch].xpos),ypos:Number(bookXML..page[dy2].datalist.data[ch].ypos),
									width:Number(bookXML..page[dy2].datalist.data[ch].width),
									height:Number(bookXML..page[dy2].datalist.data[ch].height),
									rotation:bookXML..page[dy2].datalist.data[ch].rotation,
									scalex:bookXML..page[dy2].datalist.data[ch].scalex,
									scaley:bookXML..page[dy2].datalist.data[ch].scaley,
									flip:bookXML..page[dy2].datalist.data[ch].flip};
									
									trace("loadBookData17.1=>");
									//----------------------------------------
									//To Fix TurnUpside Down issue
									//----------------------------------------
									/*if(Number(oitemData.rotation)==180)
									{
										oitemData.rotation=0;
									}
									
									if(Number(oitemData.scaley)<0)
									{
										oitemData.scaley=oitemData.scaley*-1;
									}*/
									//----------------------------------------
									
								dp.InsertObject(Number(bookXML..page[dy2].@pageno),oitemData);
								trace("loadBookData18=>");
							}
							else if(bookXML..page[dy2].datalist.data[ch].type=="CALLOUTTEXT")
							{
								var textid:Number=Number(bookXML..page[dy2].datalist.data[ch].TextId);
								trace("loadBookData19=>");
								var obj:Object=new Object();
								obj.id=bookXML..page[dy2].datalist.data[ch].TextId;
								obj.level=Number(bookXML..page[dy2].datalist.data[ch].level)
								obj.unqid=UID.createUID();
								obj.xpos=Number(bookXML..page[dy2].datalist.data[ch].xpos);
								obj.ypos=Number(bookXML..page[dy2].datalist.data[ch].ypos);
								var txml:XML=new XML(bookXML..page[dy2].datalist.data[ch].text);
																
								if(txml.children().length()>0)
								{		
									var calltxt:String=txml.children();								
									var expustart:RegExp =/\\n/gi;					        
									calltxt=calltxt.replace(expustart,"");
									
									obj.text=calltxt;
								}
								else
								{
									obj.text="";
								}
								obj.stagew=Number(bookXML..page[dy2].datalist.data[ch].stagewidth);
								obj.stageh=Number(bookXML..page[dy2].datalist.data[ch].stageheight);
								obj.width=Number(bookXML..page[dy2].datalist.data[ch].width);
								obj.height=Number(bookXML..page[dy2].datalist.data[ch].height);
								obj.curvex=Number(bookXML..page[dy2].datalist.data[ch].curvex);
								obj.curvey=Number(bookXML..page[dy2].datalist.data[ch].curvey);
								obj.rotation=Number(bookXML..page[dy2].datalist.data[ch].rotation);
								obj.type=String(bookXML..page[dy2].datalist.data[ch].type);
								obj.name=String(bookXML..page[dy2].datalist.data[ch].type)+"_"+obj.unqid;						
								obj.controltype=String(bookXML..page[dy2].datalist.data[ch].controltype);
								obj.skin=String(bookXML..page[dy2].datalist.data[ch].skin);
								
								dp.InsertCalloutText(Number(bookXML..page[dy2].@pageno),obj);
								trace("loadBookData20=>");
							}
						}
					}
					
				}
				trace("loadBookData21=>");
				//--------------------------------------------------------------
				//Default
				//--------------------------------------------------------------
				dp.currentPage=0;						
				editDataCompleted=1;
				UpdateCanvas();						
				trace("loadBookData22=>");
				facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
				//facade.sendNotification(ApplicationConstants.UPDATE_PAGE_THUMB_SELECTION);
				//--------------------------------------------------------------
				trace("loadBookData23=>");
			}
			else
			{				
				facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
			}
			trace("loadBookData24=>"+bookXML..page.length());
			if(bookXML..page.length()==0)
			{
				dp.currentPage=0;								
				AddCoverPage();
			}
			trace("loadBookData25=>");
			facade.sendNotification(ApplicationConstants.UPDATE_PAGE_THUMB_SELECTION);
			trace("loadBookData26=>");
		}		
		//-----------------------------------------------------		
		/*loadingBGClip
		stageContent
		maskClip
		stagebgimage*/
		//-----------------------------------------------------		
		//ShowLayout
		/*
		1= V Image/Text
		2= V Text/Image
		3=Text
		4=Image
		5=H Image/Text
		6=H Text/Image
		*/
		//-----------------------------------------------------				
		private function showLayout(layoutid:int):void
		{	
			var layouttextClip:*=canvas.getChildByName("layoutText");			
			if(layouttextClip!=null)
			{
				canvas.removeChild(layouttextClip);
			}
			
			var stageContClip:*;
			switch(layoutid)
			{
				
				case 1:
					stageContClip=canvas.getChildByName("stageContent");			
					if(stageContClip!=null)
					{
						var stagecontmaskClip1=stageContClip.getChildByName("stageContentMask");			
						if(stagecontmaskClip1==null)
						{
							stageContClip.addChild(stagecontentmask);
						}						
						
						stageContClip.visible=true;
						stageContClip.x=0;
						stageContClip.y=0;
						stagecontentmask.width=stagew;
						stagecontentmask.height=(stageh/2);
						
						stageContClip.mask=stagecontentmask;
					}
					
					//layoutText.text="";
					layoutText.width=stagew;
					layoutText.height=(stageh/2);
					canvas.addChild(layoutText);
					layoutText.x=3;
					layoutText.y=(stageh/2);					
					
					break;
				
				case 2:
					//layoutText.text="";
					layoutText.width=stagew;
					layoutText.height=(stageh/2);
					canvas.addChild(layoutText);
					layoutText.x=3;
					layoutText.y=0;
					
					stageContClip=canvas.getChildByName("stageContent");			
					if(stageContClip!=null)
					{
						var stagecontmaskClip2=stageContClip.getChildByName("stageContentMask");			
						if(stagecontmaskClip2==null)
						{
							stageContClip.addChild(stagecontentmask);
						}	
						
						stageContClip.visible=true;
						stageContClip.x=0;
						stageContClip.y=(stageh/2);
						stagecontentmask.width=stagew;
						stagecontentmask.height=(stageh/2);
						
						stageContClip.mask=stagecontentmask;
					}
					
					break;
				
				case 3:
					stageContClip=canvas.getChildByName("stageContent");			
					if(stageContClip!=null)
					{
						stageContClip.visible=false;
					}
					
					//layoutText.text="";
					layoutText.width=stagew;
					layoutText.height=stageh;
					canvas.addChild(layoutText);
					layoutText.x=3;
					layoutText.y=0;
					
					
					break;
				
				case 4:
					stageContClip=canvas.getChildByName("stageContent");			
					if(stageContClip!=null)
					{
						var stagecontmaskClip3=stageContClip.getChildByName("stageContentMask");			
						if(stagecontmaskClip3==null)
						{
							stageContClip.addChild(stagecontentmask);
						}	
						
						stageContClip.visible=true;
						stageContClip.x=0;
						stageContClip.y=0;
						stagecontentmask.width=stagew;
						stagecontentmask.height=stageh;
						
						stageContClip.mask=stagecontentmask;
					}
					
					break;
				
				case 5:
					stageContClip=canvas.getChildByName("stageContent");			
					if(stageContClip!=null)
					{
						var stagecontmaskClip4=stageContClip.getChildByName("stageContentMask");			
						if(stagecontmaskClip4==null)
						{
							stageContClip.addChild(stagecontentmask);
						}	
						
						stageContClip.visible=true;
						stageContClip.x=0;
						stageContClip.y=0;
						stagecontentmask.width=(stagew/2);
						stagecontentmask.height=stageh;
						
						stageContClip.mask=stagecontentmask;
					}
					
					//layoutText.text="";
					layoutText.width=(stagew/2);
					layoutText.height=stageh;
					canvas.addChild(layoutText);
					layoutText.x=(stagew/2)+3;
					layoutText.y=0;
					break;
				
				case 6:
					
					//layoutText.text="";
					layoutText.width=(stagew/2);
					layoutText.height=stageh;
					canvas.addChild(layoutText);
					layoutText.x=3;
					layoutText.y=0;
					
					stageContClip=canvas.getChildByName("stageContent");			
					if(stageContClip!=null)
					{
						var stagecontmaskClip5=stageContClip.getChildByName("stageContentMask");			
						if(stagecontmaskClip5==null)
						{
							stageContClip.addChild(stagecontentmask);
						}	
						
						stageContClip.visible=true;
						stageContClip.x=(stagew/2);
						stageContClip.y=0;
						stagecontentmask.width=(stagew/2);
						stagecontentmask.height=stageh;
						
						stageContClip.mask=stagecontentmask;
					}					
					
					break;
			}
		}
		
		private function OnlayoutTextClicked(evt:MouseEvent):void
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			var layoutid:int=dp.getCurrentLayoutID(dp.currentPage);			
			if(layoutid==1 || layoutid==2 || layoutid==3 || layoutid==5 || layoutid==6 )
			{	
				var xp:Number=(layoutText.x+layoutText.parent.x);
				var yp:Number=(layoutText.y+layoutText.parent.y);
				facade.sendNotification(ApplicationConstants.SHOW_TEXT_TOOLBOX,{textobject:layoutText,xpos:xp,ypos:yp});
			}
		}
		//-----------------------------------------------------		
		//Initializing Canvas Clip
		//-----------------------------------------------------				
		private function initCanvas():void
		{			
			canvas=new Canvas();
			canvas.name="canvas";
			canvas.x=245;
			canvas.y=60;			
			DisplayObjectContainer(viewComponent).addChild(canvas);
			
			booktitle=new BookTitle();
			booktitle.name="bookTitle";
			booktitle.visible=false;
			
			booktitle.txtbookTitle.multiline=true;
			booktitle.txtbookTitle.border=true;
			booktitle.txtbookTitle.borderColor=0xeeeeee;
			booktitle.txtbookTitle.background=true;
			booktitle.txtbookTitle.backgroundColor=0xffffff;
			booktitle.Refresh();
			
						
			
			//initially hide loadingbgclip otherwise the char/objects going behind the loading clip
			var loadingclipObj:*= canvas.getChildByName("loadingBGClip");
			if(loadingclipObj!=null)
			{
				loadingclipObj.txtStatus.text="";
				loadingclipObj.visible=false;
			}	
			
			var stageContClip:*=canvas.getChildByName("stageContent");			
			if(stageContClip!=null)
			{
				/*stageContClip.graphics.beginFill(0x00ff00,0.3);
				stageContClip.graphics.drawRect(0,0,580,580);
				stageContClip.graphics.endFill();*/
				facade.sendNotification(ApplicationConstants.CANVAS_CREATED,stageContClip);
			}
			
			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------		
		//loading canvas background
		//-----------------------------------------------------		
		private function loadCanvasBG(bgurl:String)
		{
			if(canvas!=null)
			{
				canvas.clearStage();
				canvas.loadBGImage(bgurl,stagecontentmask.width,stagecontentmask.height);
			}
		}
		//-----------------------------------------------------		
		private function SaveAndRedirectToNewPage(newpageno:int):void
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
						
			SaveText();
			
			//page redirect
			if(newpageno>=0)
			{
				dp.currentPage=newpageno;
			}
			facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
			
			
		}
		
		private function SaveText()
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			//trace("SaveText1=>");
			if(dp.currentPage==0)
			{	
				//save book title	
				//booktitle.txtbookTitle.restrict="[a-zA-Z0-9]";				
				dp.setBookTitle(booktitle.txtbookTitle.text,booktitle.x,booktitle.y,booktitle.booktitlebg.width,booktitle.booktitlebg.height,dp.currentPage);
			}
			
			if(dp.currentPage>=0)
			{	
				var layoutid:int=dp.getCurrentLayoutID(dp.currentPage);				
				if(layoutid>0)
				{
					if(layoutid>=1 && layoutid<=6 && layoutid!=4)
					{
						dp.updateLayoutText(layoutText.tlfMarkup,dp.currentPage);						
					}
				}
				
				//savecallouttext
				//-----------------------
				var caltextlist:Array=dp.getCalloutTextList(dp.currentPage);
				//trace("SaveText2=>"+caltextlist);				
				if(caltextlist!=null)
				{
					//trace("SaveText3=>"+caltextlist.length);
					for(var ct:int=0;ct<caltextlist.length;ct++)
					{
						
						var stageContClip:*=canvas.getChildByName("stageContent");			
						if(stageContClip!=null)
						{							
							var tcobj:*=stageContClip.getChildByName(caltextlist[ct].unqid);
							//trace("tcobj1=>"+tcobj);
							if(tcobj!=null)
							{
								//trace("tcobj2=>"+tcobj.data.type);
								var cot:CalloutTextView=tcobj as CalloutTextView;
								var svtxtobj:Object=cot._data;
								svtxtobj.text=cot.getTLFText();
								svtxtobj.xpos=cot.x;
								svtxtobj.ypos=cot.y;
								svtxtobj.width=cot._w;
								svtxtobj.height=cot._h;
								dp.UpdateCalloutText(dp.currentPage,svtxtobj);											
								
							}
						}
					}
				}
				//-----------------------
			}
		}
		
		private function SavePage():void
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					
			SaveText();
			
			
			var sdp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
			var savedata:String=sdp.getBookData();
			//trace(savedata);
			
			var sbp:SaveBookProxy=SaveBookProxy(facade.retrieveProxy(SaveBookProxy.NAME));
			sbp.saveBook(savedata,sdp.BookID);
		}
		
		
		private function SavePageAndStopTimer():void
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					
			SaveText();
			
			
			var sdp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
			var savedata:String=sdp.getBookData();
			//trace(savedata);
			
			var sbp:SaveBookProxy=SaveBookProxy(facade.retrieveProxy(SaveBookProxy.NAME));
			sbp.saveBook(savedata,sdp.BookID);
			facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_STOP);
		}
		
		private function SubmitBook():void
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					
			SaveText();
			
			
			var sdp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
			var savedata:String=sdp.getBookData();
			//trace(savedata);
			
			var sbp:SaveBookProxy=SaveBookProxy(facade.retrieveProxy(SaveBookProxy.NAME));
			sbp.saveBook(savedata,sdp.BookID);
			
			var subbp:SubmitBookProxy=SubmitBookProxy(facade.retrieveProxy(SubmitBookProxy.NAME));
			subbp.submitBook(savedata,sdp.BookID);
			
			facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_STOP);
		}
		
		
			
								
			
			
		//-----------------------------------------------------		
		//updating canvas according to page change
		//-----------------------------------------------------		
		private function UpdateCanvas()
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));	
			trace("UpdateCanvas1=>"+booktype+"=>"+dp.currentPage);
					
								
			
			if(dp.currentPage==0)
			{				
								
				canvas.clearChrObjects();
				
				//only book title
				showLayout(4);
				
				
				
				/*var stageContClip=canvas.getChildByName("stageContent");			
				if(stageContClip!=null)
				{
					var btobj:*=stageContClip.getChildByName("bookTitle")
					if(btobj==null)
					{
						stageContClip.addChild(booktitle);
						booktitle.x=(canvas.width/2)-(booktitle.width/2);
						booktitle.y=(canvas.height/2)-(booktitle.height/2)-100;
					}
				}*/
				var btobj:*=canvas.getChildByName("bookTitle")
				if(btobj==null)
				{
					canvas.addChild(booktitle);					
					
					booktitle.x=dp.getBookTitleX(dp.currentPage);//(canvas.width/2)-(booktitle.width/2);
					booktitle.y=dp.getBookTitleY(dp.currentPage);//(canvas.height/2)-(booktitle.height/2)-200;
					var w:int=dp.getBookTitleWidth(dp.currentPage);
					var h:int=dp.getBookTitleHeight(dp.currentPage);
					booktitle.update(w,h);					
					
					
				}
				
				var btstr:String=dp.getBookTitle(dp.currentPage);
				
				if(btstr.length==0)
				{
					booktitle.txtbookTitle.text="Book Title";
				}
				else
				{
					booktitle.txtbookTitle.text=btstr;	
				}
				
				
			
				
				if(booktype=="edit")
				{
					if(editDataCompleted==1)
					{
						booktitle.visible=true;
					}
				}
				else
				{
					booktitle.visible=true;
				}
				
				if(ApplicationConstants.USER_TYPE=="EMERGENT")
				{
					booktitle.visible=false;
				}
					
				
				facade.sendNotification(ApplicationConstants.SHOW_LAYOUT_SELECTION,4);
			}
			
			if(dp.currentPage>=0)
			{	
				
				if(dp.currentPage>0)
				{
					/*var stageContClip=canvas.getChildByName("stageContent");			
					if(stageContClip!=null)
					{
						var btobj2:*=stageContClip.getChildByName("bookTitle")
						if(btobj2!=null)
						{
							stageContClip.removeChild(booktitle);
						}
					}*/
					var btobj2:*=canvas.getChildByName("bookTitle")
					if(btobj2!=null)
					{
						canvas.removeChild(booktitle);
					}
				}
				
				
				//----------------------------------------------------
								
				
				//----------------------------------------------------
				//Background
				//----------------------------------------------------
				var curbgurl2:String=dp.getBGUrl(dp.currentPage);	
				trace("updatecanvas3=>"+curbgurl2);
				if(curbgurl2.indexOf(".swf")>0)
				{
					//pass w/h other wise bg will clip outside working area
					canvas.loadBGImage(curbgurl2,stagecontentmask.width,stagecontentmask.height);
					if(curbgurl2.length<=0)
					{
						canvas.loadingBGClip.visible=false;
					}
				}
				else
				{
					canvas.clearStage();
				}				
				//----------------------------------------------------
				canvas.clearChrObjects();
				//----------------------------------------------------
				//Character
				//----------------------------------------------------
				var datalist:Array=dp.getDataList(dp.currentPage);
				trace("updatecanvas4=>"+datalist);
				if(datalist!=null)
				{
					trace("updatecanvas5=>"+datalist.length);
					if(datalist.length>0)
					{
						facade.sendNotification(ApplicationConstants.RESTORE_DATA,datalist);
					}
					
				}				
				
				//autosave
				//trace("AutoSave is commented");
				//facade.sendNotification(ApplicationConstants.SAVE_BOOK);
					
			}
			else
			{
				canvas.clearStage();
			}
			
			facade.sendNotification(ApplicationConstants.CHECK_FOR_DUPLICATE_BTN);
		}		
		//-----------------------------------------------------
		public function getCanvas():Canvas
		{
			return canvas;
		}
		//-----------------------------------------------------		
		//clear the canvas
		//-----------------------------------------------------		
		private function ClearCanvas():void
		{
			if(canvas!=null)
			{
				canvas.clearStage();
			}
		}
		//-----------------------------------------------------	
		//canvas
		/*protected function get canvasView ():Canvas
		{
			return viewComponent as Canvas;
		}*/
	}
}
