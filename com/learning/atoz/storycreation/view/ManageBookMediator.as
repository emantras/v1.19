package com.learning.atoz.storycreation.view
{	
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	import com.learning.atoz.storycreation.view.components.PopupPlaceHolderView;
	import com.learning.atoz.storycreation.view.components.ManageBookView;
	import com.learning.atoz.storycreation.model.LoadBookViewerProxy;
	import com.learning.atoz.storycreation.model.ConfigProxy;
	
	import flash.text.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.model.BookViewDataProxy;
	import fl.data.DataProvider;

	
	
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
	import com.learning.atoz.storycreation.model.LoadBookViewerProxy;
	
	import flash.text.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.DataProxy;
	*/
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class ManageBookMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ManageBookMediator";
		private var bookmanager:ManageBookView;
		private var type:String="";
		//-----------------------------------------------------		
		public function ManageBookMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			bookmanager=new ManageBookView();
			//mainDisplay.BtnDone.addEventListener(MouseEvent.CLICK,OnDone);
			bookmanager.BtnSave.visible=false;
			bookmanager.BtnNew.addEventListener(MouseEvent.CLICK,OnNew);
			bookmanager.BtnEdit.addEventListener(MouseEvent.CLICK,OnEdit);
			bookmanager.BtnView.addEventListener(MouseEvent.CLICK,OnView);
			bookmanager.BtnAssignment.addEventListener(MouseEvent.CLICK,OnAssignment);
						
			
			bookmanager.m_bookidpopup.visible=false;
			bookmanager.m_bookidpopup.m_bookid.restrict="[0-9]";
			bookmanager.m_bookidpopup.BtnOK.addEventListener(MouseEvent.CLICK,OnBookIDOk);
			bookmanager.m_bookidpopup.BtnCANCEL.addEventListener(MouseEvent.CLICK,OnBookIDCancel);
			
			bookmanager.m_bookidstudentlevelpopup.visible=false;
			bookmanager.m_bookidstudentlevelpopup.m_bookid.restrict="[0-9]";
			bookmanager.m_bookidstudentlevelpopup.BtnOK.addEventListener(MouseEvent.CLICK,OnBookStudentLevelIDOk);
			bookmanager.m_bookidstudentlevelpopup.BtnCANCEL.addEventListener(MouseEvent.CLICK,OnBookIDCancel2);
			
			var dp:DataProvider=new DataProvider();
			dp.addItem({label:"Fluent",data:"FLUENT"});
			dp.addItem({label:"Emergent",data:"EMERGENT"});
			bookmanager.m_bookidstudentlevelpopup.m_studentlevel.dataProvider=dp;
			
			type="";
			
			//moved from MainDisplayMediator
			facade.sendNotification(ApplicationConstants.SHOW_MENU);
			facade.sendNotification(ApplicationConstants.SHOW_CANVAS);
			facade.sendNotification(ApplicationConstants.SHOW_PAGE_NAVIGATION);
			//moved to StoryCreationMediator
			facade.sendNotification(ApplicationConstants.SHOW_BOOK_MANAGER);
												
		}
		
		private function OnBookStudentLevelIDOk(evt:MouseEvent)
		{
			trace(""+bookmanager.m_bookidstudentlevelpopup.m_bookid+","+bookmanager.m_bookidstudentlevelpopup.m_studentlevel.selectedItem.data);
			if(Number(bookmanager.m_bookidstudentlevelpopup.m_bookid.text)>0 && bookmanager.m_bookidstudentlevelpopup.m_studentlevel.selectedIndex>=0)
			{
				
				if(type=="NEW")
				{
					var dataprox1:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					dataprox1.BookID=Number(bookmanager.m_bookidstudentlevelpopup.m_bookid.text);					
					dataprox1.UserType=bookmanager.m_bookidstudentlevelpopup.m_studentlevel.selectedItem.data;
					ApplicationConstants.USER_TYPE=bookmanager.m_bookidstudentlevelpopup.m_studentlevel.selectedItem.data;
					
					facade.sendNotification(ApplicationConstants.NEW_BOOK);
					facade.sendNotification(ApplicationConstants.CLOSE_BOOK_MANAGER);
					facade.sendNotification(ApplicationConstants.CLEAR_ASSIGNMENT_DATA);
					facade.sendNotification(ApplicationConstants.PASTE_TASK_COMPLETED);
					
										
					if(ApplicationConstants.USER_TYPE=="FLUENT")
					{
						facade.sendNotification(ApplicationConstants.SHOW_HIDE_ADD_COPY_PAGE,true);
					}
					else if(ApplicationConstants.USER_TYPE=="EMERGENT")
					{
						facade.sendNotification(ApplicationConstants.SHOW_HIDE_ADD_COPY_PAGE,false);
					}
										
				}				
				else if(type=="EDIT")
				{
					var dataprox2:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					dataprox2.BookID=Number(bookmanager.m_bookidpopup.m_bookid.text);
					
					var dp1:LoadBookProxy=LoadBookProxy(facade.retrieveProxy(LoadBookProxy.NAME));			
					dp1.LoadBook(dataprox2.BookID);
					facade.sendNotification(ApplicationConstants.CLOSE_BOOK_MANAGER);
					facade.sendNotification(ApplicationConstants.CLEAR_ASSIGNMENT_DATA);
					facade.sendNotification(ApplicationConstants.PASTE_TASK_COMPLETED);
				}
				else if(type=="VIEW")
				{
					var dataprox3:BookViewDataProxy=BookViewDataProxy(facade.retrieveProxy(BookViewDataProxy.NAME));
					dataprox3.BookID=Number(bookmanager.m_bookidpopup.m_bookid.text);
					
					var dp2:LoadBookViewerProxy=LoadBookViewerProxy(facade.retrieveProxy(LoadBookViewerProxy.NAME));			
					dp2.LoadBook(dataprox3.BookID);					
					facade.sendNotification(ApplicationConstants.SHOW_BOOK_VIEWER);
					facade.sendNotification(ApplicationConstants.CLEAR_ASSIGNMENT_DATA);					
				}
				else if(type=="ASSIGNMENT")
				{
					var dataprox4:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					dataprox4.BookID=Number(bookmanager.m_bookidpopup.m_bookid.text);
					facade.sendNotification(ApplicationConstants.SHOW_ASSIGNMENT_MANAGER);
					
				}
				type="";
				bookmanager.m_bookidstudentlevelpopup.m_bookid.text="";
				bookmanager.m_bookidstudentlevelpopup.visible=false;
			}
		}
		
		private function OnBookIDOk(evt:MouseEvent)
		{
			trace(""+bookmanager.m_bookidpopup.m_bookid);
			if(Number(bookmanager.m_bookidpopup.m_bookid.text)>0)
			{
				if(type=="NEW")
				{
					var dataprox1:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					dataprox1.BookID=Number(bookmanager.m_bookidpopup.m_bookid.text);
										
					facade.sendNotification(ApplicationConstants.NEW_BOOK);
					facade.sendNotification(ApplicationConstants.CLOSE_BOOK_MANAGER);
					facade.sendNotification(ApplicationConstants.CLEAR_ASSIGNMENT_DATA);
					facade.sendNotification(ApplicationConstants.PASTE_TASK_COMPLETED);
					
				}
				else if(type=="EDIT")
				{
					var dataprox2:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					dataprox2.BookID=Number(bookmanager.m_bookidpopup.m_bookid.text);
					
					var dp1:LoadBookProxy=LoadBookProxy(facade.retrieveProxy(LoadBookProxy.NAME));			
					dp1.LoadBook(dataprox2.BookID);
					facade.sendNotification(ApplicationConstants.CLOSE_BOOK_MANAGER);
					facade.sendNotification(ApplicationConstants.CLEAR_ASSIGNMENT_DATA);
					facade.sendNotification(ApplicationConstants.PASTE_TASK_COMPLETED);
				}
				else if(type=="VIEW")
				{
					var dataprox3:BookViewDataProxy=BookViewDataProxy(facade.retrieveProxy(BookViewDataProxy.NAME));
					dataprox3.BookID=Number(bookmanager.m_bookidpopup.m_bookid.text);
					
					var dp2:LoadBookViewerProxy=LoadBookViewerProxy(facade.retrieveProxy(LoadBookViewerProxy.NAME));			
					dp2.LoadBook(dataprox3.BookID);					
					facade.sendNotification(ApplicationConstants.SHOW_BOOK_VIEWER);
					facade.sendNotification(ApplicationConstants.CLEAR_ASSIGNMENT_DATA);					
				}
				else if(type=="ASSIGNMENT")
				{
					var dataprox4:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					dataprox4.BookID=Number(bookmanager.m_bookidpopup.m_bookid.text);
					facade.sendNotification(ApplicationConstants.SHOW_ASSIGNMENT_MANAGER);
					
				}
				type="";
				bookmanager.m_bookidpopup.visible=false;
			}
		}
		
		private function OnBookIDCancel(evt:MouseEvent)
		{
			bookmanager.m_bookidpopup.visible=false;
		}
		
		private function OnBookIDCancel2(evt:MouseEvent)
		{
			bookmanager.m_bookidstudentlevelpopup.visible=false;
		}
		
		private function OnAssignment(evt:MouseEvent)
		{
			bookmanager.m_bookidpopup.m_bookid.text="";
			bookmanager.m_bookidpopup.visible=true;
			type="ASSIGNMENT";
			//facade.sendNotification(ApplicationConstants.SHOW_ASSIGNMENT_MANAGER);
		}
		
		private function OnView(evt:MouseEvent)
		{
			trace("OnView");
			bookmanager.m_bookidpopup.m_bookid.text="";
			bookmanager.m_bookidpopup.visible=true;
			type="VIEW";
			
			
		}
		
		private function OnNew(evt:MouseEvent)
		{
			trace("OnNew");
			//bookmanager.m_bookidpopup.m_bookid.text="";
			//bookmanager.m_bookidpopup.visible=true;
			
			
			bookmanager.m_bookidstudentlevelpopup.m_bookid.text="";
			bookmanager.m_bookidstudentlevelpopup.visible=true;
			type="NEW";
			
			
		}
		
		private function OnEdit(evt:MouseEvent)
		{
			trace("OnEdit");
			bookmanager.m_bookidpopup.m_bookid.text="";
			bookmanager.m_bookidpopup.visible=true;
			type="EDIT";
			
			
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
			return [ApplicationConstants.SHOW_BOOK_MANAGER,
					ApplicationConstants.CLOSE_BOOK_MANAGER];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.SHOW_BOOK_MANAGER:						
					facade.sendNotification(ApplicationConstants.CLOSE_HOME_BTN);
					
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					PopupPlaceHolder.addChild(bookmanager);					
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
					break;
				case ApplicationConstants.CLOSE_BOOK_MANAGER:						
					facade.sendNotification(ApplicationConstants.SHOW_HOME_BTN);
					facade.sendNotification(ApplicationConstants.SHOW_COPY_PASTE);
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,0);
					break;
				
			}
		}
		//-----------------------------------------------------		
	
		
		//-----------------------------------------------------
		protected function get PopupPlaceHolder():PopupPlaceHolderView
		{
			return viewComponent as PopupPlaceHolderView;
		}
		
	}
}
