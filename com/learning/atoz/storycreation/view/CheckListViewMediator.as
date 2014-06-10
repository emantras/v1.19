package com.learning.atoz.storycreation.view
{	
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.model.SubmitBookProxy;
	
	import fl.text.TLFTextField;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.view.components.CheckListView;
	import com.learning.atoz.storycreation.view.components.PopupPlaceHolderView;
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class CheckListViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CheckListViewMediator";		
		private var checklistView:CheckListView;
		//-----------------------------------------------------		
		public function CheckListViewMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			trace("CheckListView->onRegister");
			checklistView=new CheckListView();
			checklistView.name="checkListView";
			checklistView.BtnCheckListClose.visible=false;
			//checklistView.BtnCheckListClose.addEventListener(MouseEvent.CLICK,OnBtnCheckListClose);
			
			
			checklistView.BtnCheckListSubmit.enabled=false;
			checklistView.BtnCheckListSubmit.alpha=0.5;
			
			checklistView.BtnCheckListSubmit.removeEventListener(MouseEvent.CLICK,OnSubmitBook);
			checklistView.BtnKeepWriting.addEventListener(MouseEvent.CLICK,OnBtnCheckListClose);
			
			checklistView.CheckList_Fluent.visible=false;
			checklistView.CheckList_Emergent.visible=false;
			
			
			checklistView.CheckList_Fluent.cb_Check1.addEventListener(Event.CHANGE,OnCheckBoxFluentChange);
			checklistView.CheckList_Fluent.cb_Check2.addEventListener(Event.CHANGE,OnCheckBoxFluentChange);
			checklistView.CheckList_Fluent.cb_Check3.addEventListener(Event.CHANGE,OnCheckBoxFluentChange);
			checklistView.CheckList_Fluent.cb_Check4.addEventListener(Event.CHANGE,OnCheckBoxFluentChange);
			checklistView.CheckList_Fluent.cb_Check5.addEventListener(Event.CHANGE,OnCheckBoxFluentChange);
			checklistView.CheckList_Fluent.cb_Check6.addEventListener(Event.CHANGE,OnCheckBoxFluentChange);
			checklistView.CheckList_Fluent.cb_Check7.addEventListener(Event.CHANGE,OnCheckBoxFluentChange);
			
			
			checklistView.CheckList_Emergent.cb_Check1.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			checklistView.CheckList_Emergent.cb_Check2.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			checklistView.CheckList_Emergent.cb_Check3.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			checklistView.CheckList_Emergent.cb_Check4.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			checklistView.CheckList_Emergent.cb_Check5.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			checklistView.CheckList_Emergent.cb_Check6.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			checklistView.CheckList_Emergent.cb_Check7.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			checklistView.CheckList_Emergent.cb_Check8.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			checklistView.CheckList_Emergent.cb_Check9.addEventListener(Event.CHANGE,OnCheckBoxEmergentChange);
			
			
			
			//facade.sendNotification(ApplicationConstants.SHOW_TEXT_TOOLBOX);			
		}
				
				
		private function OnSubmitBook(evt:MouseEvent)
		{
			checklistView.BtnCheckListSubmit.enabled=true;
			checklistView.BtnCheckListSubmit.alpha=1.0;
			
			facade.sendNotification(ApplicationConstants.SUBMIT_BOOK);
			
			
			
		}
		
		private function OnCheckBoxFluentChange(evt:Event)
		{
			trace("OnCheckBoxChange=>"+evt.currentTarget.name);
			var selcnt:int=0;
			for(var dv:int=1;dv<=7;dv++)
			{
				if(checklistView.CheckList_Fluent["cb_Check"+dv].selected)
				{
					selcnt++;
				}				
			}
			
			if(selcnt==7)			
			{
			
				checklistView.BtnCheckListSubmit.enabled=true;
				checklistView.BtnCheckListSubmit.alpha=1.0;
				checklistView.BtnCheckListSubmit.addEventListener(MouseEvent.CLICK,OnSubmitBook);
				
				
			}
			else
			{
				checklistView.BtnCheckListSubmit.enabled=false;
				checklistView.BtnCheckListSubmit.alpha=0.5;
				checklistView.BtnCheckListSubmit.removeEventListener(MouseEvent.CLICK,OnSubmitBook);
			}
		}
		
		private function OnCheckBoxEmergentChange(evt:Event)
		{
			trace("OnCheckBoxEmergentChange=>"+evt.currentTarget.name);
			var selcnt:int=0;
			for(var dv:int=1;dv<=9;dv++)
			{
				if(checklistView.CheckList_Emergent["cb_Check"+dv].selected)
				{
					selcnt++;
				}				
			}
			trace("OnCheckBoxEmergentChange=>selcnt:"+selcnt);
			if(selcnt==9)			
			{
			
				checklistView.BtnCheckListSubmit.enabled=true;
				checklistView.BtnCheckListSubmit.alpha=1.0;
				checklistView.BtnCheckListSubmit.addEventListener(MouseEvent.CLICK,OnSubmitBook);
				
			}
			else
			{
				checklistView.BtnCheckListSubmit.enabled=false;
				checklistView.BtnCheckListSubmit.alpha=0.5;
				checklistView.BtnCheckListSubmit.removeEventListener(MouseEvent.CLICK,OnSubmitBook);
			}
		}
		private function OnBtnCheckListClose(evt:MouseEvent)
		{
			facade.sendNotification(ApplicationConstants.CLOSE_CHECKLIST);
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
			return [ApplicationConstants.SHOW_CHECKLIST,
				ApplicationConstants.CLOSE_CHECKLIST];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.SHOW_CHECKLIST:	
					trace("SHOW_CHECKLIST1=>"+getTimer());
					//var tlftf:TLFTextField=(notification.getBody() as TLFTextField);
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					PopupPlaceHolder.addChild(checklistView);	
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
										
								
			
					if(ApplicationConstants.USER_TYPE=="FLUENT")
					{						
						checklistView.CheckList_Fluent.visible=true;						
						checklistView.CheckList_Emergent.visible=false;						
						//Reset CheckBoxes
						for(var dv:int=1;dv<=7;dv++)
						{							
							checklistView.CheckList_Fluent["cb_Check"+dv].selected=false;							
						}
						
						checklistView.BtnCheckListSubmit.enabled=false;
						checklistView.BtnCheckListSubmit.alpha=0.5;
						checklistView.BtnCheckListSubmit.removeEventListener(MouseEvent.CLICK,OnSubmitBook);
						
						
					}
					else if(ApplicationConstants.USER_TYPE=="EMERGENT")
					{						
						checklistView.CheckList_Fluent.visible=false;						
						checklistView.CheckList_Emergent.visible=true;
						
						//Reset CheckBoxes
						for(var dv2:int=1;dv2<=8;dv2++)
						{							
							checklistView.CheckList_Emergent["cb_Check"+dv2].selected=false;							
						}
						
						checklistView.BtnCheckListSubmit.enabled=false;
						checklistView.BtnCheckListSubmit.alpha=0.5;
						checklistView.BtnCheckListSubmit.removeEventListener(MouseEvent.CLICK,OnSubmitBook);
					}
					
					
									
									
					break;
				
				case ApplicationConstants.CLOSE_CHECKLIST:
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					break;
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Generating Background Thumbnails
		//-----------------------------------------------------		
		protected function get PopupPlaceHolder():PopupPlaceHolderView
		{
			return viewComponent as PopupPlaceHolderView;
		}
		
		
		
	}
}
