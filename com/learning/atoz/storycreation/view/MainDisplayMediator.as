package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.StoryCreationApp;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	import com.learning.atoz.storycreation.view.components.SwfOBJComponent;
	import com.learning.atoz.audio.audioLib;
	
	import flash.text.*;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.view.components.CheckListView;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	
	
	/*
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.StoryCreationApp;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	
	import flash.text.*;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	*/
	
	
	/*
	In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class MainDisplayMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainDisplayMediator";		
		public static const CREATE_MENU:String = "CreateMenu";
		public static const CREATE_CANVAS:String = "CreateCanvas";
		public static const CREATE_PAGENAVBAR:String = "CreatePageNavBar";
		public static const CREATE_CANVAS_CONTENT_MEDIATOR:String = "CreateCanvasContentMediator";
		public static const CREATE_TEXT_TOOLBOX:String = "CreateTextToolBox";
		public static const CREATE_IMAGE_TOOLBOX:String = "CreateImageToolBox";
		public static const CREATE_CLIPART_VIEW:String = "CreateClipartView";
		public static const CREATE_BOOK_MANAGER:String = "CreateBookManager";
		public static const CREATE_BOOK_VIEWER:String = "CreateBookViewer";
		public static const CREATE_ASSIGNMENT_MANAGER:String = "CreateAssignmentManager";
		public static const CREATE_CHECKLIST_VIEW:String = "CreateCheckListView";
		private var booksaveTimer:Timer;
		
		public var dragobjswf:SwfOBJComponent;	
		
		//-----------------------------------------------------		
		public function MainDisplayMediator(viewComponent:Object)
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
		
		override public function onRegister():void
		{
			initSaveTimer();
						
			//initializing and showing Left Menu Panel
			checkForMediator(CREATE_MENU, mainDisplay.m_menuview);		
			
			//initializing and loading canvas
			checkForMediator(CREATE_CANVAS, mainDisplay);
			
			//initializing and showing page navigation bar
			checkForMediator(CREATE_PAGENAVBAR, mainDisplay.m_pageview);
			
			//initializing and showing TextToolBox
			//checkForMediator(CREATE_TEXT_TOOLBOX, mainDisplay);
			
			//initializing ClipArtView
			checkForMediator(CREATE_CLIPART_VIEW, mainDisplay.popupPlaceHolder);
			
			//initializing BookManager
			checkForMediator(CREATE_BOOK_MANAGER, mainDisplay.popupPlaceHolder);
			
			//initializing BookViewer
			checkForMediator(CREATE_BOOK_VIEWER, mainDisplay.popupPlaceHolder);
			
			checkForMediator(CREATE_ASSIGNMENT_MANAGER, mainDisplay.popupPlaceHolder);
			checkForMediator(CREATE_CHECKLIST_VIEW, mainDisplay.popupPlaceHolder);
			
			
			mainDisplay.BtnHome.visible=false;			
			mainDisplay.BtnHome.addEventListener(MouseEvent.CLICK,OnHome);
			
			//mainDisplay.BtnCopyPage.visible=false;			
			//mainDisplay.BtnCopyPage.addEventListener(MouseEvent.CLICK,OnCopyPage);
			
			//mainDisplay.BtnPastePage.visible=false;			
			//mainDisplay.BtnPastePage.addEventListener(MouseEvent.CLICK,OnPastePage);
			
			//mainDisplay.BtnCopyDuplicate.addEventListener(MouseEvent.ROLL_OVER,OnOverCopyDuplicate);
			//mainDisplay.BtnCopyDuplicate.addEventListener(MouseEvent.ROLL_OUT,OnOutCopyDuplicate);
			mainDisplay.BtnCopyDuplicate.addEventListener(MouseEvent.CLICK,OnCopyDuplicate);
						
			if(ApplicationConstants.USER_TYPE=="EMERGENT")
			{
				mainDisplay.BtnWritingPlanner.visible=false;
				mainDisplay.BtnWritingPlanner.removeEventListener(MouseEvent.CLICK,OnWritingPlanner);
			}
			else
			{
				mainDisplay.BtnWritingPlanner.visible=true;
				mainDisplay.BtnWritingPlanner.addEventListener(MouseEvent.CLICK,OnWritingPlanner);
			}
			
			
			mainDisplay.BtnDone.addEventListener(MouseEvent.CLICK,OnDone);
			mainDisplay.BtnAddPageNew.addEventListener(MouseEvent.CLICK,OnAddPageNew);
			
			
			//default disable copypage button
			DuplicateEnable(false);
			//mainDisplay.BtnSaveBook.visible=false;
			//mainDisplay.BtnSaveBook.addEventListener(MouseEvent.CLICK,OnSaveBook);
			
			//initializing and showing ImageToolBox
			//integrated in canvascontenemediator
			//checkForMediator(CREATE_IMAGE_TOOLBOX, mainDisplay);
		}
		//------------------------------------------------------------------
		//Timer Script
		//------------------------------------------------------------------
		var seccnt:int=0;
		private function initSaveTimer()
		{
			booksaveTimer = new Timer(ApplicationConstants.SAVE_BOOK_TIMER_INTERVAL,ApplicationConstants.SAVE_BOOK_TIMER_REPEAT_COUNT);
			booksaveTimer.addEventListener(TimerEvent.TIMER, onTimer);
			booksaveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleted);			
			//mainDisplay.BtnStartTimer.addEventListener(MouseEvent.CLICK,OnStartTimerClicked);
			//mainDisplay.BtnStopTimer.addEventListener(MouseEvent.CLICK,OnStopTimerClicked);			
		}
		/*private function OnStartTimerClicked(evt:MouseEvent)
		{
			RestartTimer();
		}
		private function OnStopTimerClicked(evt:MouseEvent)
		{
			StopTimer();			
		}*/
		private function RestartTimer():void
		{
			if(booksaveTimer.running==false)
			{
				seccnt=0;			
				booksaveTimer.reset();
				booksaveTimer.start();
				if (ExternalInterface.available)
				{				
					try
					{					
						ExternalInterface.call("AskBeforeSaveFromFlash","true");					
					}
					catch(error:Error)
					{					
						//textArea.appendText("Error: " + error);
					}
					catch(secError:SecurityError)
					{					
						//textArea.appendText("Security error: " + secError);
					}
				}
				//mainDisplay.m_timer.text="Sec:"+seccnt;
			}
		}
		private function StopTimer():void
		{
			booksaveTimer.stop();
			booksaveTimer.reset();
			
			if (ExternalInterface.available)
			{				
				try
				{					
					ExternalInterface.call("AskBeforeSaveFromFlash","false");					
				}
				catch(error:Error)
				{					
					//textArea.appendText("Error: " + error);
				}
				catch(secError:SecurityError)
				{					
					//textArea.appendText("Security error: " + secError);
				}
			}
		}
		//------------------------------------------------------------------
		private function onTimer (e:TimerEvent):void
		{
			seccnt++;
			trace("Timer is Triggered=>"+seccnt);			
			//mainDisplay.m_timer.text="Sec:"+seccnt;
		}
		//------------------------------------------------------------------
		private function onTimerCompleted(e:TimerEvent):void
		{
			trace("Timer finishing!");
			facade.sendNotification(ApplicationConstants.SAVE_BOOK);
			//mainDisplay.m_timer.text="Saving....";
			if (ExternalInterface.available)
			{				
				try
				{					
					ExternalInterface.call("AskBeforeSaveFromFlash","false");					
				}
				catch(error:Error)
				{					
					//textArea.appendText("Error: " + error);
				}
				catch(secError:SecurityError)
				{					
					//textArea.appendText("Security error: " + secError);
				}
			}
			
		}
		//------------------------------------------------------------------
		//------------------------------------------------------------------
		private function AddPageEnable(bshow:Boolean)
		{
			trace("AddPageEnable=>"+bshow);
			if(bshow)
			{
				mainDisplay.BtnAddPageNew.addEventListener(MouseEvent.CLICK,OnAddPageNew);
				mainDisplay.BtnAddPageNew.enabled=true;
				mainDisplay.BtnAddPageNew.alpha=1.0;
			}
			else
			{
				mainDisplay.BtnAddPageNew.removeEventListener(MouseEvent.CLICK,OnAddPageNew);
				mainDisplay.BtnAddPageNew.enabled=false;
				mainDisplay.BtnAddPageNew.alpha=0.5;
			}
		}
		
		private function DuplicateEnable(bshow:Boolean)
		{
			trace("DuplicateEnable=>"+bshow);
			if(bshow)
			{
				//In Emergent Copy button should not be visible
				if(ApplicationConstants.USER_TYPE=="FLUENT")
				{
					//mainDisplay.BtnCopyDuplicate.addEventListener(MouseEvent.ROLL_OVER,OnOverCopyDuplicate);
					//mainDisplay.BtnCopyDuplicate.addEventListener(MouseEvent.ROLL_OUT,OnOutCopyDuplicate);
					mainDisplay.BtnCopyDuplicate.addEventListener(MouseEvent.CLICK,OnCopyDuplicate);
					mainDisplay.BtnCopyDuplicate.enabled=true;
					mainDisplay.BtnCopyDuplicate.alpha=1.0;
					//mainDisplay.BtnCopyDuplicate.buttonMode=true;
					mainDisplay.BtnCopyDuplicate.visible=true;
				}
			}
			else
			{
				//mainDisplay.BtnCopyDuplicate.removeEventListener(MouseEvent.ROLL_OVER,OnOverCopyDuplicate);
				//mainDisplay.BtnCopyDuplicate.removeEventListener(MouseEvent.ROLL_OUT,OnOutCopyDuplicate);
				mainDisplay.BtnCopyDuplicate.removeEventListener(MouseEvent.CLICK,OnCopyDuplicate);
				mainDisplay.BtnCopyDuplicate.enabled=false;
				mainDisplay.BtnCopyDuplicate.alpha=0.5;
				//mainDisplay.BtnCopyDuplicate.buttonMode=false;
				mainDisplay.BtnCopyDuplicate.visible=false;
			}
		}
		private function OnAddPageNew(evt:MouseEvent)
		{
			facade.sendNotification(ApplicationConstants.ADD_PAGE);
			
			//-----------------------------------------------------
			//SaveBook Timer Start
			//-----------------------------------------------------
			facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
			//-----------------------------------------------------
		}
		
		private function OnDone(evt:MouseEvent)
		{
			audioLib.getInstance().playSound("BTN_CHECKLIST");
			facade.sendNotification(ApplicationConstants.SHOW_CHECKLIST);
		}
		
		private function OnWritingPlanner(evt:MouseEvent)
		{			
			facade.sendNotification(ApplicationConstants.LOAD_WRITING_PLANNER_PROXY);
			//facade.sendNotification(ApplicationConstants.SHOW_ASSIGNMENT_MANAGER);
		}		
		private function OnSaveBook(evt:MouseEvent)
		{			
			//autosave
			//facade.sendNotification(ApplicationConstants.SAVE_BOOK);
		}
		//-----------------------------------------------------
		private function OnHome(evt:MouseEvent)
		{
			//autosave
			facade.sendNotification(ApplicationConstants.SAVE_BOOK);
			
			facade.sendNotification(ApplicationConstants.NEW_BOOK);
			
			facade.sendNotification(ApplicationConstants.SHOW_BOOK_MANAGER);			
		}
		
		private function OnOverCopyDuplicate(evt:MouseEvent)
		{			
			evt.currentTarget.caption2.textColor=0xffff00;
		}
		
		private function OnOutCopyDuplicate(evt:MouseEvent)
		{			
			evt.currentTarget.caption2.textColor=0xffffff;
		}
		
		private function OnCopyDuplicate(evt:MouseEvent)
		{
			trace("OnCopyDuplicate=>");
			
			facade.sendNotification(ApplicationConstants.SAVE_TEXT);
			facade.sendNotification(ApplicationConstants.COPY_PAGE);
			
			/*if(String(evt.currentTarget.caption.text).toLowerCase().indexOf("copy")>=0)
			{
				//evt.currentTarget.caption.text="Duplicate";
				facade.sendNotification(ApplicationConstants.SAVE_TEXT);
				facade.sendNotification(ApplicationConstants.COPY_PAGE);
			}
			else if(String(evt.currentTarget.caption.text).toLowerCase().indexOf("duplicate")>=0)
			{			
				//evt.currentTarget.caption.text="Copy Page";
				//facade.sendNotification(ApplicationConstants.PASTE_PAGE);
			}*/
			
			
		}
		
		/*private function OnCopyPage(evt:MouseEvent)
		{
			facade.sendNotification(ApplicationConstants.SAVE_TEXT);
			facade.sendNotification(ApplicationConstants.COPY_PAGE);
		}
		
		private function OnPastePage(evt:MouseEvent)
		{
			facade.sendNotification(ApplicationConstants.PASTE_PAGE);
		}*/
		
		protected function checkForMediator( childSelector:String, child:Object ):void
		{
			switch (childSelector)
			{				
				case CREATE_MENU:
					if (!facade.hasMediator(MenuMediator.NAME))
					{
						facade.registerMediator(new MenuMediator(child));
					}
					//moved to ManageBookView
					//facade.sendNotification(ApplicationConstants.SHOW_MENU);
					break;
				
				case CREATE_CANVAS:					
					if (!facade.hasMediator(CanvasMediator.NAME))
					{
						facade.registerMediator(new CanvasMediator(child));
					}
					//moved to ManageBookView
					//facade.sendNotification(ApplicationConstants.SHOW_CANVAS);
					break;
				
				case CREATE_PAGENAVBAR:
					if (!facade.hasMediator(PageNavigationMediator.NAME))
					{
						facade.registerMediator(new PageNavigationMediator(child));
					}
					//moved to ManageBookView
					//facade.sendNotification(ApplicationConstants.SHOW_PAGE_NAVIGATION);
					break;				
				
				case CREATE_CANVAS_CONTENT_MEDIATOR:
					if (!facade.hasMediator(CanvasContentMediator.NAME))
					{
						facade.registerMediator(new CanvasContentMediator(child));
					}					
					break;
				
				/*case CREATE_TEXT_TOOLBOX:
					if (!facade.hasMediator(TextToolBoxMediator.NAME))
					{
						facade.registerMediator(new TextToolBoxMediator(child));
					}					
					break;*/
				
				case CREATE_IMAGE_TOOLBOX:
					if (!facade.hasMediator(ImageToolBoxMediator.NAME))
					{
						facade.registerMediator(new ImageToolBoxMediator(child));
					}					
					break;
				
				case CREATE_CLIPART_VIEW:
					if (!facade.hasMediator(ClipartViewMediator.NAME))
					{
						facade.registerMediator(new ClipartViewMediator(child));
					}					
					break;
				
				case CREATE_BOOK_MANAGER:
					if (!facade.hasMediator(ManageBookMediator.NAME))
					{
						facade.registerMediator(new ManageBookMediator(child));
					}					
					break;
				
				case CREATE_BOOK_VIEWER:
					if (!facade.hasMediator(BookViewerMediator.NAME))
					{
						facade.registerMediator(new BookViewerMediator(child));
					}					
					break;
				
				case CREATE_ASSIGNMENT_MANAGER:
					if (!facade.hasMediator(ManageAssignmentMediator.NAME))
					{
						facade.registerMediator(new ManageAssignmentMediator(child));
					}					
					break;
				case CREATE_CHECKLIST_VIEW:
					if (!facade.hasMediator(CheckListViewMediator.NAME))
					{
						facade.registerMediator(new CheckListViewMediator(child));
					}					
					break;
				
			}        
		}
		
		//-----------------------------------------------------		
		// what this mediator is listening for
		//-----------------------------------------------------		
		override public function listNotificationInterests():Array
		{			
			return [ApplicationConstants.CANVAS_CREATED,
			ApplicationConstants.SHOW_WAIT_POPUP,
			ApplicationConstants.CLOSE_WAIT_POPUP,
			ApplicationConstants.SHOW_HOME_BTN,
			ApplicationConstants.CLOSE_HOME_BTN,
			ApplicationConstants.SHOW_COPY_PASTE,
			ApplicationConstants.CLOSE_COPY_PASTE,
			ApplicationConstants.ENABLE_PASTE,
			ApplicationConstants.DISABLE_PASTE,
			ApplicationConstants.COPY_TASK_COMPLETED,
			ApplicationConstants.PASTE_TASK_COMPLETED,
			ApplicationConstants.ADDPAGE_ENABLE,
			ApplicationConstants.SHOW_HIDE_ADD_COPY_PAGE,
			ApplicationConstants.DRAG_ADD_OBJECT,
			ApplicationConstants.DRAG_ADD_BG,
			ApplicationConstants.DRAG_ADD_CALLOUT,
			ApplicationConstants.DUPLICATE_ENABLE,
			ApplicationConstants.DUPLICATE_DISABLE,
			ApplicationConstants.ADDPAGE_DISABLE,
			ApplicationConstants.SAVE_BOOK_TIMER_RESTART,
			ApplicationConstants.SAVE_BOOK_TIMER_STOP,
			ApplicationConstants.CHECK_FOR_DUPLICATE_BTN];
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.CANVAS_CREATED:
					var canvcont:Object=(notification.getBody() as Object);
					checkForMediator(CREATE_CANVAS_CONTENT_MEDIATOR, canvcont);
					break;
				
				case ApplicationConstants.SHOW_WAIT_POPUP:
					var msg:String=(notification.getBody() as String);					
					mainDisplay.BringPreloaderFront();
					mainDisplay.preloader.visible=true;
					mainDisplay.preloader.mcBar.scaleX = 0;
					mainDisplay.preloader.txtLoading.text = msg;
					break;
				
				case ApplicationConstants.CLOSE_WAIT_POPUP:					
					mainDisplay.preloader.visible=false;
					mainDisplay.preloader.mcBar.scaleX = 0;
					mainDisplay.preloader.txtLoading.text = "";
					break;
				
				case ApplicationConstants.SHOW_HOME_BTN:					
					mainDisplay.BtnHome.visible=true;					
					if(ApplicationConstants.USER_TYPE=="EMERGENT")
					{
						mainDisplay.BtnWritingPlanner.visible=false;
						mainDisplay.BtnWritingPlanner.removeEventListener(MouseEvent.CLICK,OnWritingPlanner);
					}
					else
					{
						mainDisplay.BtnWritingPlanner.visible=true;
						mainDisplay.BtnWritingPlanner.addEventListener(MouseEvent.CLICK,OnWritingPlanner);
					}
					break;
				
				case ApplicationConstants.CLOSE_HOME_BTN:					
					mainDisplay.BtnHome.visible=false;
					//mainDisplay.BtnCopyPage.visible=false;
					//mainDisplay.BtnPastePage.visible=false;
					break;
				
				case ApplicationConstants.SHOW_COPY_PASTE:
					/*mainDisplay.BtnCopyPage.visible=true;
					mainDisplay.BtnPastePage.enabled=false;
					mainDisplay.BtnPastePage.alpha=0.5;
					mainDisplay.BtnPastePage.visible=true;*/
					break;
				
				case ApplicationConstants.CLOSE_COPY_PASTE:
					//mainDisplay.BtnCopyPage.visible=false;
					//mainDisplay.BtnPastePage.visible=false;
					break;
				
				case ApplicationConstants.ENABLE_PASTE:					
					//mainDisplay.BtnPastePage.enabled=true;
					//mainDisplay.BtnPastePage.alpha=1.0;
					
					break;
				
				case ApplicationConstants.DISABLE_PASTE:					
					//mainDisplay.BtnPastePage.enabled=false;
					//mainDisplay.BtnPastePage.alpha=0.5;
					
					break;
				case ApplicationConstants.COPY_TASK_COMPLETED:
					//mainDisplay.BtnCopyDuplicate.caption.text="Duplicate";
				break;
				case ApplicationConstants.PASTE_TASK_COMPLETED:
					//mainDisplay.BtnCopyDuplicate.caption.text="Copy Page";
				break;
				case ApplicationConstants.ADDPAGE_ENABLE:
					AddPageEnable(true);
				break;
				
				case ApplicationConstants.ADDPAGE_DISABLE:
					AddPageEnable(false);
				break;
				case ApplicationConstants.DUPLICATE_ENABLE:
					DuplicateEnable(true);
				break;
				
				case ApplicationConstants.DUPLICATE_DISABLE:
					DuplicateEnable(false);
				break;
				
				case ApplicationConstants.CHECK_FOR_DUPLICATE_BTN:
					checkAndActivateDuplicate();
					break;
				
				case ApplicationConstants.SHOW_HIDE_ADD_COPY_PAGE:
					var sh:Boolean=(notification.getBody() as Boolean);		
					ShowPageCopyBtn(sh);
				break;
				
				case ApplicationConstants.DRAG_ADD_OBJECT:
					var objdata1:Object=(notification.getBody() as Object);					
					AddDragObject(objdata1);
				break;
				
				case ApplicationConstants.DRAG_ADD_BG:
					var objdata2:Object=(notification.getBody() as Object);					
					AddDragBg(objdata2);
				break;
				
				case ApplicationConstants.DRAG_ADD_CALLOUT:
					var objdata3:Object=(notification.getBody() as Object);					
					AddDragCallout(objdata3);
				break;
				
				case ApplicationConstants.SAVE_BOOK_TIMER_RESTART:				
					RestartTimer();
					break;
					
				case ApplicationConstants.SAVE_BOOK_TIMER_STOP:
					StopTimer();
					break;
				
				
				
			}
		}
		
		private function copyObject(src:Object,dest:Object):void
		{
			for(var dv in src)
			{
				dest[dv]=src[dv];
			}	
		}
		
		private function AddDragCallout(obj:Object):void
		{			
			
				//------------------------------------------
				//copy only object values
				//------------------------------------------
				var objobj:Object=new Object();
				copyObject(obj,objobj);	
				//------------------------------------------								
				dragobjswf=new SwfOBJComponent(objobj);
				dragobjswf.name="DragObjectSwf";
				dragobjswf.addEventListener(MouseEvent.MOUSE_UP,OnDragObjSwfCalloutUp);
				dragobjswf.loadSWF(objobj.skin,100,100);				
				mainDisplay.addChild(dragobjswf);
				mainDisplay.setChildIndex(dragobjswf,mainDisplay.numChildren-1);				
				dragobjswf.startDrag(true);
								
			
		}
		
				
		private function OnDragObjSwfCalloutUp(evt:MouseEvent):void
		{
			//trace("OnDragObjSwfCalloutUp1=>"+evt.currentTarget+","+evt.currentTarget.name);
			evt.currentTarget.stopDrag();			
			//trace("OnDragObjSwfCalloutUp2=>"+evt.currentTarget.dropTarget);
			//trace("OnDragObjSwfCalloutUp3=>"+evt.currentTarget.dropTarget.parent);
			//trace("OnDragObjSwfCalloutUp4=>"+evt.currentTarget.dropTarget.parent.parent);
			//trace("OnDragObjSwfCalloutUp5=>"+evt.currentTarget.dropTarget.parent.parent.parent);
			var dataObject:Object;
			var obj:*=mainDisplay.getChildByName("DragObjectSwf");
			if(obj!=null)
			{
				dataObject=(evt.currentTarget as SwfOBJComponent).data;
				trace("OnDragObjSwfCallout before:"+evt.currentTarget.x+","+evt.currentTarget.y);
				var pt:Point=new Point();
				var stageobj:*=mainDisplay.getChildByName("stageBG");
				if(stageobj!=null)
				{
					pt.x=evt.currentTarget.x-stageobj.x;
					pt.y=evt.currentTarget.y-stageobj.y;										
				}				
				
				trace("OnDragObjSwfCallout after:"+pt.x+","+pt.y);
				dataObject.xpos=pt.x-25;
				dataObject.ypos=pt.y;
				mainDisplay.removeChild(obj);
			}
			
			
			if(evt.currentTarget.dropTarget!=null)
			{
				if(evt.currentTarget.dropTarget.parent!=null)
				{
					trace("OnDragObjSwfCalloutUp6=>");
					var sdata:String=evt.currentTarget.dropTarget.parent;
					var sdata2:String=evt.currentTarget.dropTarget.parent.parent;
					trace("OnDragObjSwfCalloutUp6.1=>sdata:"+sdata+",data2:"+sdata2);
					if(sdata.indexOf("stageWhiteBG")>=0 || sdata2.indexOf("stageWhiteBG")>=0)
					{
						trace("OnDragObjSwfCalloutUp7=>");
						facade.sendNotification(ApplicationConstants.ADD_CALLOUTTEXT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
										
					}
					else if(sdata.indexOf("SwfBGComponent")>=0 || sdata2.indexOf("SwfBGComponent")>=0)
					{
						trace("OnDragObjSwfCalloutUp8=>");
						facade.sendNotification(ApplicationConstants.ADD_CALLOUTTEXT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
					else if(sdata.indexOf("SwfOBJComponent")>=0 || sdata2.indexOf("SwfOBJComponent")>=0)
					{
						trace("OnDragObjSwfCalloutUp8=>");
						facade.sendNotification(ApplicationConstants.ADD_CALLOUTTEXT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
					else if(sdata.indexOf("BookTitle")>=0 || sdata2.indexOf("BookTitle")>=0)
					{
						trace("OnDragObjSwfCalloutUp9=>");
						facade.sendNotification(ApplicationConstants.ADD_CALLOUTTEXT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
					else if(sdata.indexOf("CalloutTextView")>=0 || sdata2.indexOf("CalloutTextView")>=0)
					{
						trace("OnDragObjSwfCalloutUp10=>");
						facade.sendNotification(ApplicationConstants.ADD_CALLOUTTEXT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
					else if(sdata.indexOf("Sprite")>=0 && sdata2.indexOf("CalloutTextView")>=0)
					{
						trace("OnDragObjSwfCalloutUp11=>");
						facade.sendNotification(ApplicationConstants.ADD_CALLOUTTEXT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
				}
			}
		}
		
		private function checkAndActivateDuplicate()
		{
				//trace("checkAndActivateDuplicate=>1");
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				var maxPage:int=dp.getMaxPageNo();
				var curbgurl2:String=dp.getBGUrl(dp.currentPage);					
				
				//trace("checkAndActivateDuplicate=>1.2=>maxPage:"+maxPage+",curbgurl2=>"+curbgurl2);
				
				facade.sendNotification(ApplicationConstants.DUPLICATE_DISABLE);
				if(curbgurl2.indexOf(".swf")>0)
				{
					//trace("checkAndActivateDuplicate=>2");
					//if(dp.currentPage==0 || dp.currentPage==ApplicationConstants.MAXIMUM_PAGE_LIMIT)
					if(maxPage>=ApplicationConstants.MAXIMUM_PAGE_LIMIT)
					{
						//trace("checkAndActivateDuplicate=>3");
						facade.sendNotification(ApplicationConstants.DUPLICATE_DISABLE);
					}
					else
					{
						//trace("checkAndActivateDuplicate=>4");
						facade.sendNotification(ApplicationConstants.DUPLICATE_ENABLE);
						
					}
				}
				else
				{
					//trace("checkAndActivateDuplicate=>5");
					var datalist:Array=dp.getDataList(dp.currentPage);			
					//trace("updatecanvas4=>"+datalist);
					if(datalist!=null)
					{
						//trace("updatecanvas5=>"+datalist.length);
						if(datalist.length>0)
						{
							//if(dp.currentPage==0 || dp.currentPage==ApplicationConstants.MAXIMUM_PAGE_LIMIT)
							
							if(maxPage>=ApplicationConstants.MAXIMUM_PAGE_LIMIT)
							{
								//trace("checkAndActivateDuplicate=>6");
								facade.sendNotification(ApplicationConstants.DUPLICATE_DISABLE);
							}
							else
							{
								//trace("checkAndActivateDuplicate=>7");
								facade.sendNotification(ApplicationConstants.DUPLICATE_ENABLE);
								
							}							
						}						
					}			
				}
		}
		
		private function AddDragBg(obj:Object):void
		{			
			
				//------------------------------------------
				//copy only object values
				//------------------------------------------
				var objobj:Object=new Object();
				copyObject(obj,objobj);	
				//------------------------------------------								
				dragobjswf=new SwfOBJComponent(objobj);
				dragobjswf.name="DragObjectSwf";
				dragobjswf.addEventListener(MouseEvent.MOUSE_UP,OnDragObjSwfBgUp);
				dragobjswf.loadSWF(objobj.thumburl,100,100);				
				mainDisplay.addChild(dragobjswf);
				mainDisplay.setChildIndex(dragobjswf,mainDisplay.numChildren-1);				
				dragobjswf.startDrag(true);
								
			
		}
		
		
		private function OnDragObjSwfBgUp(evt:MouseEvent):void
		{			
			evt.currentTarget.stopDrag();			
			
			var dataObject:Object;
			var obj:*=mainDisplay.getChildByName("DragObjectSwf");
			if(obj!=null)
			{
				dataObject=(evt.currentTarget as SwfOBJComponent).data;
				mainDisplay.removeChild(obj);
			}
			
			
			if(evt.currentTarget.dropTarget!=null)
			{
				if(evt.currentTarget.dropTarget.parent!=null)
				{
					
					var sdata:String=evt.currentTarget.dropTarget.parent;
					var sdata2:String=evt.currentTarget.dropTarget.parent.parent;
					
					if(sdata.indexOf("stageWhiteBG")>=0 || sdata2.indexOf("stageWhiteBG")>=0)
					{
						
						var dp2:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
						if(dp2.currentPage>=0)
						{
							var bgurl2:String=dataObject.objdata.url;
							
							dp2.addBGUrl(dataObject.objdata,bgurl2,dp2.currentPage);
							facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
							facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp2.currentPage,thumburl:dataObject.objdata.thumburl});
							
							//-----------------------------------------------------
							//SaveBook Timer Start
							//-----------------------------------------------------
							facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
							//-----------------------------------------------------
						}
										
					}
					else if(sdata.indexOf("SwfBGComponent")>=0 || sdata2.indexOf("SwfBGComponent")>=0)
					{
						
						var dp3:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
						if(dp3.currentPage>=0)
						{
							var bgurl3:String=dataObject.objdata.url;
							
							dp3.addBGUrl(dataObject.objdata,bgurl3,dp3.currentPage);
							facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
							facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp3.currentPage,thumburl:dataObject.objdata.thumburl});
							
							//-----------------------------------------------------
							//SaveBook Timer Start
							//-----------------------------------------------------
							facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
							//-----------------------------------------------------
						}
					}
					else if(sdata.indexOf("SwfOBJComponent")>=0 || sdata2.indexOf("SwfOBJComponent")>=0)
					{
						
						var dp4:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
						if(dp4.currentPage>=0)
						{
							var bgurl4:String=dataObject.objdata.url;
							
							dp4.addBGUrl(dataObject.objdata,bgurl4,dp4.currentPage);
							facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
							facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp4.currentPage,thumburl:dataObject.objdata.thumburl});
							
							//-----------------------------------------------------
							//SaveBook Timer Start
							//-----------------------------------------------------
							facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
							//-----------------------------------------------------
						}
					}
					else if(sdata.indexOf("BookTitle")>=0 || sdata2.indexOf("BookTitle")>=0)
					{						
						var dp5:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
						if(dp5.currentPage>=0)
						{
							var bgurl5:String=dataObject.objdata.url;
							
							dp5.addBGUrl(dataObject.objdata,bgurl5,dp5.currentPage);
							facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
							facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp5.currentPage,thumburl:dataObject.objdata.thumburl});
							
							//-----------------------------------------------------
							//SaveBook Timer Start
							//-----------------------------------------------------
							facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
							//-----------------------------------------------------
						}
					}
					else if(sdata.indexOf("CalloutTextView")>=0 || sdata2.indexOf("CalloutTextView")>=0)
					{
						
						var dp6:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
						if(dp6.currentPage>=0)
						{
							var bgurl6:String=dataObject.objdata.url;
							
							dp6.addBGUrl(dataObject.objdata,bgurl6,dp6.currentPage);
							facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
							facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp6.currentPage,thumburl:dataObject.objdata.thumburl});
							
							//-----------------------------------------------------
							//SaveBook Timer Start
							//-----------------------------------------------------
							facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
							//-----------------------------------------------------
						}
					}
					else if(sdata.indexOf("Sprite")>=0 && sdata2.indexOf("CalloutTextView")>=0)
					{
						
						var dp7:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			
						if(dp7.currentPage>=0)
						{
							var bgurl7:String=dataObject.objdata.url;
							
							dp7.addBGUrl(dataObject.objdata,bgurl7,dp7.currentPage);
							facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
							facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:dp7.currentPage,thumburl:dataObject.objdata.thumburl});
							
							//-----------------------------------------------------
							//SaveBook Timer Start
							//-----------------------------------------------------
							facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
							//-----------------------------------------------------
						}
					}
				}
			}
		}
		private function AddDragObject(obj:Object):void
		{			
			
				//------------------------------------------
				//copy only object values
				//------------------------------------------
				var objobj:Object=new Object();
				copyObject(obj,objobj);	
				//------------------------------------------								
				dragobjswf=new SwfOBJComponent(objobj);
				dragobjswf.name="DragObjectSwf";
				mainDisplay.addChild(dragobjswf);
				dragobjswf.addEventListener(MouseEvent.MOUSE_UP,OnDragObjSwfUp);
				dragobjswf.loadSWF(objobj.thumburl,100,100);				
				
				mainDisplay.setChildIndex(dragobjswf,mainDisplay.numChildren-1);				
				dragobjswf.startDrag(true);
								
			
		}
				
		
		private function OnDragObjSwfUp(evt:MouseEvent):void
		{
			trace("OnDragObjSwfUp1=>"+evt.currentTarget+","+evt.currentTarget.name);
			evt.currentTarget.stopDrag();						
			var dataObject:Object;
			var obj:*=mainDisplay.getChildByName("DragObjectSwf");
			if(obj!=null)
			{
				dataObject=(evt.currentTarget as SwfOBJComponent).data;
				trace("before:"+evt.currentTarget.x+","+evt.currentTarget.y);
				var pt:Point=new Point();
				var stageobj:*=mainDisplay.getChildByName("stageBG");
				if(stageobj!=null)
				{
					pt.x=evt.currentTarget.x-stageobj.x;
					pt.y=evt.currentTarget.y-stageobj.y;										
				}				
				
				trace("after:"+pt.x+","+pt.y);
				dataObject.xpos=pt.x;
				dataObject.ypos=pt.y;
				mainDisplay.removeChild(obj);
			}
			
			var obj2:*=mainDisplay.getChildByName("DragObjectSwf");
			if(obj2!=null)
			{
				mainDisplay.removeChild(obj2);
			}
			
			if(evt.currentTarget.dropTarget!=null)
			{
				if(evt.currentTarget.dropTarget.parent!=null)
				{
					trace("OnDragObjSwfUp6=>");
					var sdata:String=evt.currentTarget.dropTarget.parent;
					var sdata2:String=evt.currentTarget.dropTarget.parent.parent;
					trace("OnDragObjSwfUp6.1=>sdata:"+sdata+",data2:"+sdata2);
					if(sdata.indexOf("stageWhiteBG")>=0 || sdata2.indexOf("stageWhiteBG")>=0)
					{
						trace("OnDragObjSwfUp7=>");
						facade.sendNotification(ApplicationConstants.ADD_OBJECT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
					else if(sdata.indexOf("SwfBGComponent")>=0 || sdata2.indexOf("SwfBGComponent")>=0)
					{
						trace("OnDragObjSwfUp8=>");
						facade.sendNotification(ApplicationConstants.ADD_OBJECT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
					else if(sdata.indexOf("BookTitle")>=0 || sdata2.indexOf("BookTitle")>=0)
					{
						trace("OnDragObjSwfUp9=>");
						facade.sendNotification(ApplicationConstants.ADD_OBJECT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
					else if(sdata.indexOf("CalloutTextView")>=0 || sdata2.indexOf("CalloutTextView")>=0)
					{
						trace("OnDragObjSwfUp10=>");
						facade.sendNotification(ApplicationConstants.ADD_OBJECT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
					else if(sdata.indexOf("Sprite")>=0 && sdata2.indexOf("CalloutTextView")>=0)
					{
						trace("OnDragObjSwfUp11=>");
						facade.sendNotification(ApplicationConstants.ADD_OBJECT,dataObject);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}
				}
			}
		}
		
		
		public function ShowPageCopyBtn(bshow:Boolean)
		{
			trace("ShowPageCopyBtn=>"+bshow);
			if(bshow)
			{
				var dp6:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));			
				if(dp6.currentPage>0 && dp6.currentPage<ApplicationConstants.MAXIMUM_PAGE_LIMIT)					
				{
					mainDisplay.BtnCopyDuplicate.addEventListener(MouseEvent.CLICK,OnOverCopyDuplicate);
					mainDisplay.BtnCopyDuplicate.visible=true;
				}
				else
				{
					mainDisplay.BtnCopyDuplicate.visible=false;
				}
				
				mainDisplay.BtnAddPageNew.addEventListener(MouseEvent.CLICK,OnAddPageNew);
				mainDisplay.BtnAddPageNew.visible=true;
				
			}
			else
			{
				mainDisplay.BtnCopyDuplicate.removeEventListener(MouseEvent.CLICK,OnOverCopyDuplicate);
				mainDisplay.BtnCopyDuplicate.visible=false;
				
				mainDisplay.BtnAddPageNew.removeEventListener(MouseEvent.CLICK,OnAddPageNew);
				mainDisplay.BtnAddPageNew.visible=false;
			}
		}
		
		public function mytrace(msg:String):void
		{
			trace(msg);			
		}
		//-----------------------------------------------------
				
		public function get mainDisplay():StoryCreationApp
		{
			return viewComponent as StoryCreationApp;
		}
		
	}
}
