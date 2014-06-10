package com.learning.atoz.storycreation.view
{		
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	import com.learning.atoz.storycreation.view.components.PopupPlaceHolderView;
	import com.learning.atoz.storycreation.view.components.ManageBookView;
	import com.learning.atoz.storycreation.view.components.BookViewer;
	import com.learning.atoz.storycreation.view.components.BookTitle;
	import com.learning.atoz.storycreation.view.components.Canvas;
	import com.learning.atoz.storycreation.view.components.BookTitle;
	import com.learning.atoz.storycreation.view.components.stageContentMask;
	import com.learning.atoz.storycreation.UID;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	import com.learning.atoz.storycreation.view.components.SwfCHRComponent;
	import com.learning.atoz.storycreation.view.components.SwfComponent;
	import com.learning.atoz.storycreation.view.components.SwfOBJComponent;
	import com.learning.atoz.storycreation.view.components.callout.CalloutTextView;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.text.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.BookViewDataProxy;
	
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.conversion.ConversionType;

	
	
	/*
	import com.learn.atoz.clipartcomp.atozClipartComponent;
	import com.learn.atoz.clipartcomp.events.ClipartEvent;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	import com.learning.atoz.storycreation.view.components.PopupPlaceHolderView;
	import com.learning.atoz.storycreation.view.components.ManageBookView;
	import com.learning.atoz.storycreation.view.components.BookViewer;
	import com.learning.atoz.storycreation.view.components.BookTitle;
	import com.learning.atoz.storycreation.view.components.Canvas;
	import com.learning.atoz.storycreation.view.components.BookTitle;
	import com.learning.atoz.storycreation.view.components.stageContentMask;
	import com.learning.atoz.storycreation.UID;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	import com.learning.atoz.storycreation.view.components.SwfCHRComponent;
	import com.learning.atoz.storycreation.view.components.SwfComponent;
	import com.learning.atoz.storycreation.view.components.SwfOBJComponent;
	import com.learning.atoz.storycreation.view.components.callout.CalloutTextView;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.text.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.BookViewDataProxy;
	
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.conversion.ConversionType;
	*/
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class BookViewerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BookViewerMediator";				
		private var bookviewer:BookViewer;
		private var canvas:Canvas;
		private var booktitle:BookTitle;
		private var stagecontentmask:stageContentMask;
		private var stagew:int=580;
		private var stageh:int=580;	
		
		private var curPage:Number=-1;
		private var maxPage:Number=-1;
		//public var nodataclip:NoDataClip;
		//-----------------------------------------------------		
		public function BookViewerMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{
			//nodataclip=new NoDataClip();
			//nodataclip.name="nodataclip";
			
			bookviewer=new BookViewer();			
			bookviewer.BtnClose.addEventListener(MouseEvent.CLICK,OnBookViewerClose);
			
			
			bookviewer.BtnNextPage.addEventListener(MouseEvent.CLICK,OnNextPage);
			bookviewer.BtnPrevPage.addEventListener(MouseEvent.CLICK,OnPrevPage);
			
			bookviewer.BtnNextPage.visible=false;
			bookviewer.BtnPrevPage.visible=false;
			
			initCanvas();
			
			stagecontentmask=new stageContentMask();
			stagecontentmask.name="stageContentMask";
			
		}
		
		public function Initialize()
		{
			bookviewer.statusbar.text="";
			bookviewer.pageStatus.text="";
			bookviewer.BtnNextPage.visible=false;
			bookviewer.BtnPrevPage.visible=false;
			var dp:BookViewDataProxy=BookViewDataProxy(facade.retrieveProxy(BookViewDataProxy.NAME));
			curPage=-1;			
			if(dp!=null)
			{
				maxPage=dp.getPageCount();
				nextPage();
				canvas.visible=true;
			}
			
		}
		
		private function OnNextPage(evt:MouseEvent)
		{
			nextPage();
		}
		
		
		
		private function OnPrevPage(evt:MouseEvent)
		{
			prevPage();
		}
		
		private function prevPage()
		{
			if((curPage-1)>=0)
			{
				curPage--;
				loadPage();
			}
		}
		
		private function nextPage()
		{
			if((curPage+1)<maxPage)
			{
				curPage++;
				loadPage();
			}
		}
		private function loadPage()
		{
			bookviewer.pageStatus.text="Page: "+(curPage+1)+" of "+maxPage;
			if(curPage<maxPage)
			{
				var dp:BookViewDataProxy=BookViewDataProxy(facade.retrieveProxy(BookViewDataProxy.NAME));
				dp.currentPage=curPage;
				UpdateBookViewerCanvas();				
			}
			validatePrevNextBtns();
		}
		
		private function validatePrevNextBtns()
		{
			if(maxPage==1)
			{
				bookviewer.BtnNextPage.visible=false;
				bookviewer.BtnPrevPage.visible=false;
			}
			else if(curPage==0 && maxPage>1)
			{
				bookviewer.BtnNextPage.visible=true;
				bookviewer.BtnPrevPage.visible=false;
			}
			else if(curPage==(maxPage-1) && maxPage>1)
			{
				bookviewer.BtnNextPage.visible=false;
				bookviewer.BtnPrevPage.visible=true;
			}
			else
			{
				bookviewer.BtnNextPage.visible=true;
				bookviewer.BtnPrevPage.visible=true;
			}
			
			if(curPage<maxPage)
			{
				
			}
		}
		
		private function OnBookViewerClose(evt:MouseEvent)
		{			
			facade.sendNotification(ApplicationConstants.CLOSE_BOOK_VIEWER);
			
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
			return [ApplicationConstants.SHOW_BOOK_VIEWER,
					ApplicationConstants.CLOSE_BOOK_VIEWER,
					ApplicationConstants.VIEW_BOOK
					];
		}
		//-----------------------------------------------------		
		private function ClearAll()
		{
			//--------------------------------------------------------------
			//ClearCanvas
			//--------------------------------------------------------------
			bookviewer.statusbar.text="";
			canvas.visible=false;
			ClearCanvas();
			var dp:BookViewDataProxy=BookViewDataProxy(facade.retrieveProxy(BookViewDataProxy.NAME));
			dp.ResetBook();	
			var btobj2:*=canvas.getChildByName("bookTitle")
			if(btobj2!=null)
			{
				canvas.removeChild(booktitle);
			}
			curPage=-1;
			maxPage=-1;
			bookviewer.pageStatus.text="";
			bookviewer.BtnNextPage.visible=false;
			bookviewer.BtnPrevPage.visible=false;
			//--------------------------------------------------------------
		}
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.SHOW_BOOK_VIEWER:						
					facade.sendNotification(ApplicationConstants.CLOSE_HOME_BTN);					
					ClearAll();
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					PopupPlaceHolder.addChild(bookviewer);					
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
					bookviewer.statusbar.text="Loading please wait...";
										
					break;
				case ApplicationConstants.CLOSE_BOOK_VIEWER:						
					facade.sendNotification(ApplicationConstants.SHOW_HOME_BTN);
					ClearAll();
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,0);					
					facade.sendNotification(ApplicationConstants.SHOW_BOOK_MANAGER);
					break;
				case ApplicationConstants.VIEW_BOOK:
					//load book				
					//clearBook();					
					ClearAll();
					bookviewer.statusbar.text="Loading please wait...";
					var bookdata:String=(notification.getBody() as String);
					loadBookViewerData(bookdata);
					break;
				
			}
		}
		//-----------------------------------------------------	
		private function loadBookViewerData(bookdata:String)
		{			
			var dp:BookViewDataProxy=BookViewDataProxy(facade.retrieveProxy(BookViewDataProxy.NAME));
			dp.ResetBook();			
			ClearCanvas();
			facade.sendNotification(ApplicationConstants.SHOW_WAIT_POPUP,"Loading Pages.....");			
			var bookXML:XML=new XML(bookdata);
						
			trace("bookXML..page.length()=>"+bookXML..page.length());
			if(bookXML..page.length()==0)
			{							
				bookviewer.statusbar.text="No content created for this page";
			}
			
			if(bookXML..page.length()>0)
			{				
				var cp:ClipartProxy=ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME));
				
				for(var dy:int=0;dy<bookXML..page.length();dy++)
				{				
					//pageThumbnail
					var ret:Boolean=dp.addPage(String(bookXML..page[dy].@id),String(bookXML..page[dy].@type),Number(bookXML..page[dy].@pageno));
					//facade.sendNotification(ApplicationConstants.ADD_PAGE_THUMBNAIL,String(bookXML..page[dy].@type));										
				}
				
				for(var dy2:int=0;dy2<bookXML..page.length();dy2++)
				{
					//Book Title
					//dp.setBookTitle(String(bookXML..page[dy2].booktitle),Number(bookXML..page[dy2].@pageno));
					
					dp.setBookTitle(String(bookXML..page[dy2].booktitle),Number(bookXML..page[dy2].booktitle_xpos),
									Number(bookXML..page[dy2].booktitle_ypos),Number(bookXML..page[dy2].booktitle_width),
									Number(bookXML..page[dy2].booktitle_height),Number(bookXML..page[dy2].@pageno));
					//Layout
					if(bookXML..page[dy2].layout.length()>0)
					{
						dp.updateLayoutID(Number(bookXML..page[dy2].layout[0].layoutid),Number(bookXML..page[dy2].@pageno));
						//dp.updateLayoutText(String(bookXML..page[dy2].layout[0].layouttext),Number(bookXML..page[dy2].@pageno));
					}
										
					//Background
					if(bookXML..page[dy2].background.length()>0)
					{
						var bgid:Number=Number(bookXML..page[dy2].background[0].BgId);
						
						/*var bgdata:*=cp.vo._xml..Background.(BgId==bgid);
						var bgfullurl:String;
						var bgThumb:String
						if(ApplicationConstants.ASSETS_MODE=="LOCAL")
						{
							bgfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+bgdata.Url;							
							bgThumb=ApplicationConstants.ASSETS_PATH+"assets/"+bgdata.ThumbUrl;
						}
						else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
						{
							bgfullurl=bgdata.Url;							
							bgThumb=bgdata.ThumbUrl;
						}
						
						var itemData:Object={unqid:UID.createUID(),level:0,id:bgdata.BgId,name:bgdata.BgName,catid:bgdata.CatId,subcatid:bgdata.SubCatId,url:bgfullurl,thumburl:bgThumb,type:"BACKGROUND",xpos:0,ypos:0,width:0,height:0,rotation:0};
						dp.addBGUrl(itemData,bgfullurl,Number(bookXML..page[dy2].@pageno));
						*/
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
					
					
					//Character
					if(bookXML..page[dy2].datalist.data.length()>0)
					{
						for(var ch:int=0;ch<bookXML..page[dy2].datalist.data.length();ch++)
						{
							if(bookXML..page[dy2].datalist.data[ch].type=="CHARACTER")
							{
								var chrid:Number=Number(bookXML..page[dy2].datalist.data[ch].ChrId);
						
								var chrdata:*=cp.vo._xml..Character.(ChrId==chrid);
								/*var chrfullurl:String;
								var chrThumb:String;
								if(ApplicationConstants.ASSETS_MODE=="LOCAL")
								{
									chrfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+chrdata.Url;							
									chrThumb=ApplicationConstants.ASSETS_PATH+"assets/"+chrdata.ThumbUrl;
								}
								else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
								{
									chrfullurl=chrdata.Url;							
									chrThumb=chrdata.ThumbUrl;
								}
								
								var citemData:Object={unqid:UID.createUID(),level:Number(bookXML..page[dy2].datalist.data[ch].level),id:chrdata.ChrId,name:chrdata.ChrName,catid:chrdata.CatId,
									subcatid:chrdata.SubCatId,url:chrfullurl,thumburl:chrThumb,type:"CHARACTER",xpos:bookXML..page[dy2].datalist.data[ch].xpos,
									ypos:bookXML..page[dy2].datalist.data[ch].ypos,width:bookXML..page[dy2].datalist.data[ch].width,
									height:bookXML..page[dy2].datalist.data[ch].height,rotation:bookXML..page[dy2].datalist.data[ch].rotation,flip:bookXML..page[dy2].datalist.data[ch].flip};
								dp.InsertCharacter(Number(bookXML..page[dy2].@pageno),citemData);*/
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
							}
							else if(bookXML..page[dy2].datalist.data[ch].type=="OBJECT")
							{
								var objid:Number=Number(bookXML..page[dy2].datalist.data[ch].ObjId);
						
								//var objdata:*=cp.vo._xml..Object.(ObjId==objid);
								/*var objfullurl:String;
								var objThumb:String
								if(ApplicationConstants.ASSETS_MODE=="LOCAL")
								{
									objfullurl=ApplicationConstants.ASSETS_PATH+"assets/"+objdata.Url;							
									objThumb=ApplicationConstants.ASSETS_PATH+"assets/"+objdata.ThumbUrl;
								}
								else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
								{
									objfullurl=objdata.Url;							
									objThumb=objdata.ThumbUrl;
								}
								
								//
								var oitemData:Object={unqid:UID.createUID(),level:Number(bookXML..page[dy2].datalist.data[ch].level),id:objdata.ObjId,name:objdata.ObjName,catid:objdata.CatId,
									subcatid:objdata.SubCatId,url:objfullurl,thumburl:objThumb,type:"OBJECT",
									xpos:Number(bookXML..page[dy2].datalist.data[ch].xpos),ypos:Number(bookXML..page[dy2].datalist.data[ch].ypos),
									width:Number(bookXML..page[dy2].datalist.data[ch].width),
									height:Number(bookXML..page[dy2].datalist.data[ch].height),
									rotation:bookXML..page[dy2].datalist.data[ch].rotation,
									flip:bookXML..page[dy2].datalist.data[ch].flip};
								dp.InsertObject(Number(bookXML..page[dy2].@pageno),oitemData);*/
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
								dp.InsertObject(Number(bookXML..page[dy2].@pageno),oitemData);
							}
							else if(bookXML..page[dy2].datalist.data[ch].type=="CALLOUTTEXT")
							{
								var textid:Number=Number(bookXML..page[dy2].datalist.data[ch].TextId);

								var obj:Object=new Object();							
								obj.id=bookXML..page[dy2].datalist.data[ch].TextId;
								obj.level=Number(bookXML..page[dy2].datalist.data[ch].level);
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
							}
						}
					}
					
				}
				
				//--------------------------------------------------------------
				//Default
				//--------------------------------------------------------------
				dp.currentPage=0;				
				Initialize();
				UpdateBookViewerCanvas();				
				facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
				//--------------------------------------------------------------
			}
			else
			{							
				facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
			}
			
		}		
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
			}
			}
		//-----------------------------------------------------		
		//Initializing Canvas Clip
		//-----------------------------------------------------				
		private function initCanvas():void
		{			
			canvas=new Canvas();			
			canvas.name="canvas";
			canvas.x=144.55;
			canvas.y=106.85;			
			bookviewer.addChild(canvas);
			
			booktitle=new BookTitle();
			booktitle.name="bookTitle";	
			booktitle.txtbookTitle.type="dynamic";
			booktitle.txtbookTitle.selectable=false;
			
			
			
			//initially hide loadingbgclip otherwise the char/objects going behind the loading clip
			var loadingclipObj:*= canvas.getChildByName("loadingBGClip");
			if(loadingclipObj!=null)
			{
				loadingclipObj.txtStatus.text="";
				loadingclipObj.visible=false;
			}	
			
			/*var stageContClip:*=canvas.getChildByName("stageContent");			
			if(stageContClip!=null)
			{
				facade.sendNotification(ApplicationConstants.CANVAS_CREATED,stageContClip);
			}*/
			
			
		}
		//-----------------------------------------------------
		private function clearBookAndLoad()
		{
			var dp:BookViewDataProxy=BookViewDataProxy(facade.retrieveProxy(BookViewDataProxy.NAME));
						
			var btobj2:*=canvas.getChildByName("bookTitle")
			if(btobj2!=null)
			{
				canvas.removeChild(booktitle);
			}
			
			dp.ResetBook();
			
			//----------------------------------------------------			
			
		}
		
		//-----------------------------------------------------		
		//updating canvas according to page change
		//-----------------------------------------------------		
		private function UpdateBookViewerCanvas()
		{
			var dp:BookViewDataProxy=BookViewDataProxy(facade.retrieveProxy(BookViewDataProxy.NAME));			
			
			if(dp.currentPage==0)
			{				
				var curbgurl:String=dp.getBGUrl(dp.currentPage);
								
				
				canvas.clearChrObjects();
				
				//only book title
				showLayout(4);
				
				
				if(ApplicationConstants.USER_TYPE=="FLUENT")
				{
					var btobj:*=canvas.getChildByName("bookTitle")
					if(btobj==null)
					{
						canvas.addChild(booktitle);
						
						booktitle.txtbookTitle.multiline=true;
						booktitle.txtbookTitle.border=true;
						booktitle.txtbookTitle.borderColor=0xeeeeee;
						booktitle.txtbookTitle.background=true;
						booktitle.txtbookTitle.backgroundColor=0xffffff;
						booktitle.txtbookTitle.selectable=false;
						booktitle.BtnDragger.visible=false;
						booktitle.BtnResizer.visible=false;
						booktitle.Refresh();
				
						//booktitle.x=(canvas.width/2)-(booktitle.width/2);
						//booktitle.y=(canvas.height/2)-(booktitle.height/2)-200;
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
				}
				else if(ApplicationConstants.USER_TYPE=="EMERGENT")
				{
					var btobj2:*=canvas.getChildByName("bookTitle")
					if(btobj2!=null)
					{
						btobj2.visible=false;
					}
				}
				facade.sendNotification(ApplicationConstants.SHOW_LAYOUT_SELECTION,4);
			}
			
			if(dp.currentPage>=0)
			{	
				canvas.clearChrObjects();
				var vbgcnt:int=0;
				var vobjcnt:int=0;
				
				if(dp.currentPage>0)
				{
					var btobj3:*=canvas.getChildByName("bookTitle")
					if(btobj3!=null)
					{
						canvas.removeChild(booktitle);
					}
				}
				
				//Layout
				//----------------------------------------------------
				var layoutid:int=dp.getCurrentLayoutID(dp.currentPage);
				
				if(layoutid>0)
				{
					showLayout(layoutid);										
				}
				
				//layoutText.text=dp.getCurrentLayoutText(dp.currentPage);
				//layoutText.tlfMarkup=dp.getCurrentLayoutText(dp.currentPage);
				
				
				//----------------------------------------------------
				
				
				
				//----------------------------------------------------
				//Background
				//----------------------------------------------------
				var curbgurl3:Object=dp.getBGData(dp.currentPage);				
				var curbgurl2:String=dp.getBGUrl(dp.currentPage);
				
												
				
				if(curbgurl2.indexOf(".swf")>0)
				{
					vbgcnt=1;
					//pass w/h other wise bg will clip outside working area					
					canvas.loadBGImage(curbgurl2,stagecontentmask.width,stagecontentmask.height);
					if(curbgurl2.length<=0)
					{
						canvas.loadingBGClip.visible=false;
					}
					
				}
				else
				{					
					vbgcnt=0;
					canvas.loadBGImage("assets/nobg.swf",stagecontentmask.width,stagecontentmask.height);
					
					canvas.clearStage();
				}				
				
				//----------------------------------------------------
				canvas.clearChrObjects();
				//----------------------------------------------------
				var dataarr:Array=dp.getDataList(dp.currentPage);
				if(dataarr.length>0)
				{
					vobjcnt=1;
				}
				else
				{
					vobjcnt=0;
				}
				for(var dv:int=0;dv<dataarr.length;dv++)
				{
					if(dataarr[dv].type=="CHARACTER")
					{
						RestoreCharacter(dataarr[dv]);
					}
					else if(dataarr[dv].type=="OBJECT")
					{
						RestoreObject(dataarr[dv]);
					}
					else if(dataarr[dv].type=="CALLOUTTEXT")
					{
						RestoreCalloutText(dataarr[dv]);
					}
				}
								
				bookviewer.nodataclip.nodatastatus.text="";
				if(vbgcnt>0 && vobjcnt>0)
				{
					trace("UpdateBookViewerCanvas####2=>");
					//var ndclip=bookviewer.getChildByName("nodataclip");
					//trace("UpdateBookViewerCanvas####=>"+ndclip);
					//if(ndclip!=null)
					//{
						bookviewer.nodataclip.nodatastatus.text="";
						//bookviewer.removeChild(ndclip);
					//}
					
					//nodataclip.x=246;
					//nodataclip.y=376;
					
				}
				else if(vbgcnt>0 || vobjcnt>0)
				{
					trace("UpdateBookViewerCanvas####3=>");
					//var ndclip=bookviewer.getChildByName("nodataclip");
					//trace("UpdateBookViewerCanvas####=>"+ndclip);
					//if(ndclip!=null)
					//{
						bookviewer.nodataclip.nodatastatus.text="";
						//bookviewer.removeChild(ndclip);
					//}
					
					//nodataclip.x=246;
					//nodataclip.y=376;
					
				}
				else
				{
					trace("UpdateBookViewerCanvas####4=>");
					//var ndclip=bookviewer.getChildByName("nodataclip");
					//trace("UpdateBookViewerCanvas####=>"+ndclip)
					//if(ndclip==null)
					//{
						//bookviewer.addChild(ndclip);
						//ndclip.x=246;
						//ndclip.y=376;
						bookviewer.nodataclip.nodatastatus.text="No content created for this page";
						//bookviewer.setChildIndex(ndclip,bookviewer.numChildren-1);
					//}
					
				}
				
				
			}
			else
			{
				canvas.clearStage();
			}
		}		
		//-----------------------------------------------------				
		private function RestoreObject(obj:Object):void
		{				
			
			if(obj!=null)
			{
				//----------------------------------------
				//To Fix TurnUpside Down issue
				//----------------------------------------
				/*if(Number(obj.rotation)==180)
				{
					obj.rotation=0;
				}
				
				if(Number(obj.scaley)<0)
				{
					obj.scaley=obj.scaley*-1;
				}*/
				//----------------------------------------
				
				var objswf:SwfOBJComponent=new SwfOBJComponent(obj);
				objswf.name="Object_"+obj.id+"_"+obj.unqid;				
				objswf.loadSWF(obj.url,obj.width,obj.height);
				objswf.x=obj.xpos;
				objswf.y=obj.ypos;
				objswf.rotation=obj.rotation;
				//objswf.rotation=180;				
								
								
				//The Flip Script is moved to SwfOBJComponent onComplete
				//bcos while scaling also they can flip				
				/*if(Number(obj.scalex)<0)
				{
					objswf.swfContent.scaleX=objswf.swfContent.scaleX*-1;
				}*/
				
				/*if(Number(obj.scaley)<0)
				{
					objswf.scaleY=objswf.scaleY*-1;
				}*/
				canvasContent.addChild(objswf);
			}
			
		}
		
		private function RestoreCharacter(charobj:Object):void
		{				
				
			if(charobj!=null)
			{
				var chrswf:SwfCHRComponent=new SwfCHRComponent(charobj);
				chrswf.name="Character_"+charobj.id+"_"+charobj.unqid;					
				chrswf.loadSWF(charobj.url,charobj.width,charobj.height);
				chrswf.x=charobj.xpos;
				chrswf.y=charobj.ypos;
				chrswf.rotation=charobj.rotation;
				
				//bcos while scaling also they can flip
				//if(charobj.flip==1)
				//{
					if(Number(charobj.scalex)<0)
					{
						chrswf.scaleX=chrswf.scaleX*-1;
					}
					
					if(Number(charobj.scaley)<0)
					{
						chrswf.scaleY=chrswf.scaleY*-1;
					}
				//}
				
				canvasContent.addChild(chrswf);
			}
			
		}
		
		private function RestoreCalloutText(textobj:Object):void
		{				
			var xmlobj:XML;
			var tf:TextFlow;
			
			var w:int;
			var h:int;
			var obj:Object;
			
			w=CanvasMediator(facade.retrieveMediator(CanvasMediator.NAME)).stagecontentmask.width;
			h=CanvasMediator(facade.retrieveMediator(CanvasMediator.NAME)).stagecontentmask.height;
			
			obj=new Object();
			obj=textobj;
			obj.isnew=0;
			
			var coText:CalloutTextView=new CalloutTextView(obj);
			coText.name=obj.unqid;			
			coText.x=Number(obj.xpos);
			coText.y=Number(obj.ypos);
			coText._w=Number(obj.width);
			coText._h=Number(obj.height);
			canvasContent.addChild(coText);
			//coText.addEventListener("CLOSE_TEXTTOOL_FROM_CALLOUT_TEXT",OnCloseTextToolFromCalloutText);
			//coText.addEventListener("SHOW_TEXTTOOL_FROMCALLOUTTEXT",OnShowTextToolFromCalloutText);
			//coText.addEventListener("DELETE_CALLOUT_TEXT",OnDeleteCallOutText);
			
		}
		
		
		/*private function OnShowTextToolFromCalloutText(evt:ObjectEvent):void
		{			
			DeselectAllTextCallout(evt.objdata.target);
						
		}*/
		
		
		//-----------------------------------------------------		
		//clear the canvas
		//-----------------------------------------------------		
		private function ClearCanvas():void
		{
			
			if(canvas!=null)
			{
				
				canvas.clearStage();
						
				var stageContClip:*=canvas.getChildByName("stageContent");
				
				if(stageContClip!=null)
				{
					
					while(stageContClip.numChildren>0)
					{
											
						stageContClip.removeChildAt(0);
					}
				}
				
			}
		}
		//-----------------------------------------------------
		public function get canvasContent():Object
		{
			var stageContClip:*=canvas.getChildByName("stageContent");			
			if(stageContClip!=null)
			{
				
			}
			return stageContClip;
		}
		//-----------------------------------------------------
		protected function get PopupPlaceHolder():PopupPlaceHolderView
		{
			return viewComponent as PopupPlaceHolderView;
		}
		
	}
}
