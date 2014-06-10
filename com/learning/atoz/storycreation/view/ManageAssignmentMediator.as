package com.learning.atoz.storycreation.view
{	
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	import com.learning.atoz.storycreation.view.components.PopupPlaceHolderView;
	import com.learning.atoz.storycreation.view.components.ManageAssignmentView;
	import com.learning.atoz.storycreation.model.LoadBookViewerProxy;
	import com.learning.atoz.storycreation.model.ConfigProxy;
	import com.learning.atoz.storycreation.model.LoadAssignmentProxy;
	import com.learning.atoz.storycreation.view.components.AssignmentPage1;
	import com.learning.atoz.storycreation.view.components.AssignmentPage2;
	import com.learning.atoz.storycreation.view.components.AssignmentPage3;
	import com.learning.atoz.storycreation.view.components.AssignmentPage4;
	import com.adobe.serialization.json.JSON;
	import com.learning.atoz.storycreation.model.SaveWritingPlannerProxy;
	import com.learning.atoz.storycreation.model.LoadStoryStartersProxy;
	import com.learning.atoz.storycreation.model.LoadWritingPlannerProxy;
	
	import flash.text.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.DataProxy;
	

	
	
	/*
	import com.learn.atoz.clipartcomp.atozClipartComponent;
	import com.learn.atoz.clipartcomp.events.ClipartEvent;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	import com.learning.atoz.storycreation.view.components.PopupPlaceHolderView;
	import com.learning.atoz.storycreation.view.components.ManageAssignmentView;
	import com.learning.atoz.storycreation.model.LoadBookViewerProxy;
	import com.learning.atoz.storycreation.model.ConfigProxy;
	import com.learning.atoz.storycreation.model.LoadAssignmentProxy;
	import com.learning.atoz.storycreation.view.components.AssignmentPage1;
	import com.learning.atoz.storycreation.view.components.AssignmentPage2;
	import com.learning.atoz.storycreation.view.components.AssignmentPage3;
	import com.learning.atoz.storycreation.view.components.AssignmentPage4;
	import com.adobe.serialization.json.JSON;
	import com.learning.atoz.storycreation.model.SaveWritingPlannerProxy;
	import com.learning.atoz.storycreation.model.LoadStoryStartersProxy;
	import com.learning.atoz.storycreation.model.LoadWritingPlannerProxy;
	
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
	public class ManageAssignmentMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ManageAssignmentMediator";
		private var assignmentmanager:ManageAssignmentView;
		private var type:String="";
		private var assignmentXml:XML;
		private var assignmentPage1:AssignmentPage1;
		private var assignmentPage2:AssignmentPage2;
		private var assignmentPage3:AssignmentPage3;
		private var assignmentPage4:AssignmentPage4;
		private var assignmentData:Object={page1_typeofwriting:"",page1_writeabout:"",page1_storystarter:"",page1_storystarter_index:"",page2_typeofwriting:"",page2_writeabout:"",page2_storystarter:"",page2_storystarter_index:"",page3_characters:"",page3_story_takeplace:"",page3_problem:"",page3_events:"",page3_solution:"",page4_introduction:"",page4_body:"",page4_conclusion:""};
		
		
		//-----------------------------------------------------		
		public function ManageAssignmentMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			assignmentmanager=new ManageAssignmentView();
			//mainDisplay.BtnDone.addEventListener(MouseEvent.CLICK,OnDone);
			
			assignmentmanager.BtnLoadAssignment.addEventListener(MouseEvent.CLICK,OnLoadAssignment);
			assignmentmanager.BtnViewAssignment.addEventListener(MouseEvent.CLICK,OnViewAssignment);
			
			assignmentmanager.BtnViewAssignment.enabled=false;
			assignmentmanager.BtnViewAssignment.alpha=0.5;
			
			assignmentmanager.status.text="";
			assignmentmanager.m_assignmentIDPopup.visible=false;
			assignmentmanager.m_assignmentIDPopup.m_assignmentid.restrict="[0-9]";
			assignmentmanager.m_assignmentIDPopup.BtnOK.addEventListener(MouseEvent.CLICK,OnBookIDOk);
			assignmentmanager.m_assignmentIDPopup.BtnCANCEL.addEventListener(MouseEvent.CLICK,OnBookIDCancel);
			type="";
			
			
			
			assignmentPage1=new AssignmentPage1();
			assignmentPage2=new AssignmentPage2();
			assignmentPage3=new AssignmentPage3();
			assignmentPage4=new AssignmentPage4();
			
			
			assignmentPage1.BtnAssignPage1Next.addEventListener(MouseEvent.CLICK,OnAssignPage1NextClick);
			assignmentPage2.BtnAssignPage2Next.addEventListener(MouseEvent.CLICK,OnAssignPage2NextClick);
			
			
			assignmentPage3.BtnAssignPage3Prev.addEventListener(MouseEvent.CLICK,OnAssignPage3PrevClick);
			assignmentPage3.BtnAssignPage3Save.addEventListener(MouseEvent.CLICK,OnAssignPage3SaveClick);
			assignmentPage3.BtnAssignPage3Skip.addEventListener(MouseEvent.CLICK,OnAssignPage3SkipClick);
			
			assignmentPage4.BtnAssignPage4Prev.addEventListener(MouseEvent.CLICK,OnAssignPage4PrevClick);
			assignmentPage4.BtnAssignPage4Save.addEventListener(MouseEvent.CLICK,OnAssignPage4SaveClick);
			assignmentPage4.BtnAssignPage4Skip.addEventListener(MouseEvent.CLICK,OnAssignPage4SkipClick);
						
			ClearAssignmentData();
			//moved to StoryCreationMediator
			//facade.sendNotification(ApplicationConstants.SHOW_ASSIGNMENT_MANAGER);
			
		}		
		
		public function ClearAssignmentData()
		{
			assignmentData.page1_typeofwriting="";
			assignmentData.page1_writeabout="";
			assignmentData.page1_storystarter="";
			assignmentData.page1_storystarter_index="";
			
			assignmentData.page2_typeofwriting="";
			assignmentData.page2_writeabout="";	
			assignmentData.page2_storystarter="";
			assignmentData.page2_storystarter_index="";
			
			assignmentPage3.m_storystarter_caption.text="";
			assignmentPage3.m_storystarter_value.text="";
			
			assignmentPage3.m_storystarter_caption.text="";
			assignmentPage3.m_storystarter_value.text="";
			
			assignmentPage4.m_storystarter_caption.text="";
			assignmentPage4.m_storystarter_value.text="";
				
			assignmentData.page3_characters="";
			assignmentData.page3_story_takeplace="";
			assignmentData.page3_problem="";
			assignmentData.page3_events="";
			assignmentData.page3_solution="";
		}
		
		public function getAssignmentData():Object
		{
			return assignmentData;
		}
		
		public function setAssignmentData(obj:Object):void
		{
			assignmentData=obj;
		}
		
		private function DisableControls()
		{
			assignmentmanager.status.text="Loading Assignment...";
			assignmentmanager.BtnLoadAssignment.enabled=false;
			assignmentmanager.BtnLoadAssignment.alpha=0.5;
						
			assignmentmanager.BtnViewAssignment.enabled=false;
			assignmentmanager.BtnViewAssignment.alpha=0.5;
		}
		
		private function EnableControls()
		{
			assignmentmanager.BtnLoadAssignment.enabled=true;
			assignmentmanager.BtnLoadAssignment.alpha=1.0;
						
			//assignmentmanager.BtnViewAssignment.enabled=true;
			//assignmentmanager.BtnViewAssignment.alpha=1.0;
			assignmentmanager.status.text="";
		}
		
		private function OnBookIDOk(evt:MouseEvent)
		{			
			var assignid:Number=Number(assignmentmanager.m_assignmentIDPopup.m_assignmentid.text);
			if(assignid>0)
			{				
				if(type=="LOAD")
				{					
					DisableControls();
					var ap:LoadAssignmentProxy=LoadAssignmentProxy(facade.retrieveProxy(LoadAssignmentProxy.NAME));					
					ap.LoadAssignment(assignid);					
					
				}
				else if(type=="VIEW")
				{
					/*var dataprox3:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					dataprox3.BookID=Number(assignmentmanager.m_assignmentIDPopup.m_assignmentid.text);
					
					var dp2:LoadBookViewerProxy=LoadBookViewerProxy(facade.retrieveProxy(LoadBookViewerProxy.NAME));			
					dp2.LoadBook(dataprox3.BookID);
					facade.sendNotification(ApplicationConstants.SHOW_BOOK_VIEWER);
					*/
				}
				
				type="";
				assignmentmanager.m_assignmentIDPopup.visible=false;
			}			
		}
		
		private function OnBookIDCancel(evt:MouseEvent)
		{
			assignmentmanager.m_assignmentIDPopup.visible=false;
		}
		
		private function OnViewAssignment(evt:MouseEvent)
		{
			trace("OnViewAssignment");
			assignmentmanager.m_assignmentIDPopup.m_assignmentid.text="";
			assignmentmanager.m_assignmentIDPopup.visible=true;
			type="VIEW";
			
			
		}
				
		
		private function OnLoadAssignment(evt:MouseEvent)
		{
			trace("OnLoadAssignment");
			assignmentmanager.m_assignmentIDPopup.m_assignmentid.text="";
			assignmentmanager.m_assignmentIDPopup.visible=true;
			type="LOAD";
			
			
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
			return [ApplicationConstants.SHOW_ASSIGNMENT_MANAGER,
					ApplicationConstants.CLOSE_ASSIGNMENT_MANAGER,
					ApplicationConstants.LOADED_ASSIGNMENT_DATA,
					ApplicationConstants.LOADED_STORY_STARTERS_DATA,
					ApplicationConstants.SAVE_WRITING_PLANNER_COMPLETED,
					ApplicationConstants.SAVE_WRITING_PLANNER_ERROR,
					ApplicationConstants.LOAD_WRITING_PLANNER_PROXY,
					ApplicationConstants.LOADED_WRITING_PLANNER_DATA,
					ApplicationConstants.CLEAR_ASSIGNMENT_DATA];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.CLEAR_ASSIGNMENT_DATA:
					ClearAssignmentData();
					break;
				case ApplicationConstants.LOAD_WRITING_PLANNER_PROXY:					
					LoadWritingPlannerProxy(facade.retrieveProxy(LoadWritingPlannerProxy.NAME)).LoadWritingPlanner(DataProxy(facade.retrieveProxy(DataProxy.NAME)).BookID);
					
					break;
				case ApplicationConstants.LOADED_WRITING_PLANNER_DATA:
					var writingplandata:String=(notification.getBody() as String);				
					trace("LOADED_WRITING_PLANNER_DATA:"+writingplandata);
					if(writingplandata.indexOf("<error")>=0)
					{
						facade.sendNotification(ApplicationConstants.SHOW_ASSIGNMENT_MANAGER);
					}
					else
					{
						var writeplanxml:XML=new XML(writingplandata);
						trace("assignmentdata=>"+writeplanxml..assignmentdata.length());
						if(writeplanxml..assignmentdata.length()>0)
						{
							var assignxml:String="<assignment>";
							assignxml+="<assignment_type>"+writeplanxml..assignmentdata[0].assignment_type+"</assignment_type>";
							assignxml+="<organizer_mandatory>"+writeplanxml..assignmentdata[0].organizer_mandatory+"</organizer_mandatory>";
							assignxml+="<instructions>"+writeplanxml..assignmentdata[0].instructions+"</instructions>";							
							assignxml+="</assignment>";
							assignmentXml=new XML(assignxml);
						}
						trace("page1=>"+writeplanxml..page1.length());
						if(writeplanxml..page1.length()>0)
						{
							assignmentData.page1_typeofwriting=writeplanxml..page1[0].typeofwriting;
							assignmentData.page1_writeabout=writeplanxml..page1[0].writeabout;
							assignmentData.page1_storystarter=writeplanxml..page1[0].storystarter;
							assignmentData.page1_storystarter_index=writeplanxml..page1[0].storystarterindex;
						}
						trace("page2=>"+writeplanxml..page2.length());
						if(writeplanxml..page2.length()>0)
						{
							assignmentData.page2_typeofwriting=writeplanxml..page2[0].typeofwriting;
							assignmentData.page2_writeabout=writeplanxml..page2[0].writeabout;
							
							assignmentData.page2_storystarter=writeplanxml..page2[0].storystarter;
							assignmentData.page2_storystarter_index=writeplanxml..page2[0].storystarterindex;
						}
						trace("page3=>"+writeplanxml..page3.length());
						if(writeplanxml..page3.length()>0)
						{
							
							assignmentData.page3_characters=writeplanxml..page3[0].characters;
							assignmentData.page3_story_takeplace=writeplanxml..page3[0].story_takeplace;
							assignmentData.page3_problem=writeplanxml..page3[0].problem;
							assignmentData.page3_events=writeplanxml..page3[0].events;
							assignmentData.page3_solution=writeplanxml..page3[0].solution;
						}
						trace("page4=>"+writeplanxml..page4.length());
						if(writeplanxml..page4.length()>0)
						{
							
							assignmentData.page4_introduction=writeplanxml..page4[0].introduction;
							assignmentData.page4_body=writeplanxml..page4[0].body;
							assignmentData.page4_conclusion=writeplanxml..page4[0].conclusion;
							
						}
												
						var lssp2:LoadStoryStartersProxy=LoadStoryStartersProxy(facade.retrieveProxy(LoadStoryStartersProxy.NAME));
						lssp2.LoadStoryStarters();	
						/*
						if(writeplanxml..page1.length()>0)
							{
								assignxml+="<instructions>"+writeplanxml..page1[0].writeabout+"</instructions>";
							}
							else if(writeplanxml..page2.length()>0)
							{
								assignxml+="<instructions>"+writeplanxml..page2[0].writeabout+"</instructions>";
							}
						<assignment>
<assignment_type>fiction</assignment_type>
<organizer_mandatory>n</organizer_mandatory>
<instructions></instructions>
</assignment>

						assignmentXml=new XML(assigndata);
					trace("assignment.length=>"+assignmentXml..assignment_type.length());
					EnableControls();
					
					var lssp:LoadStoryStartersProxy=LoadStoryStartersProxy(facade.retrieveProxy(LoadStoryStartersProxy.NAME));
					lssp.LoadStoryStarters();	
					
						writeplandata+="<assignmentdata>";				
				writeplandata+="<assignment_id>"+assignid.toString()+"</assignment_id>";
				writeplandata+="<assignment_type>"+assignmentXml..assignment_type+"</assignment_type>";
				writeplandata+="<organizer_mandatory>"+assignmentXml..organizer_mandatory+"</organizer_mandatory>";
				writeplandata+="<instructions>"+assignmentXml..instructions+"</instructions>";
				writeplandata+="</assignmentdata>";
						writeplandata+="<writingplannerdata>";
			writeplandata+="<page1>";
			writeplandata+="<typeofwriting>"+assignmentData.page1_typeofwriting+"</typeofwriting>";
			writeplandata+="<writeabout>"+assignmentData.page1_writeabout+"</writeabout>";
			writeplandata+="<storystarter>"+assignmentData.page1_storystarter+"</storystarter>";
			writeplandata+="<storystarterindex>"+assignmentData.page1_storystarter_index+"</storystarterindex>";		
			writeplandata+="</page1>";
			
			writeplandata+="<page2>";
			writeplandata+="<typeofwriting>"+assignmentData.page2_typeofwriting+"</typeofwriting>";
			writeplandata+="<writeabout>"+assignmentData.page2_writeabout+"</writeabout>";
			writeplandata+="</page2>";
			
			writeplandata+="<page3>";
			writeplandata+="<characters>"+assignmentData.page3_characters+"</characters>";
			writeplandata+="<story_takeplace>"+assignmentData.page3_story_takeplace+"</story_takeplace>";
			writeplandata+="<problem>"+assignmentData.page3_problem+"</problem>";
			writeplandata+="<events>"+assignmentData.page3_events+"</events>";
			writeplandata+="<solution>"+assignmentData.page3_solution+"</solution>";
			writeplandata+="</page3>";
			
			
			writeplandata+="<page4>";
				writeplandata+="<introduction>"+assignmentData.page4_introduction+"</introduction>";
				writeplandata+="<body>"+assignmentData.page4_body+"</body>";
				writeplandata+="<conclusion>"+assignmentData.page4_conclusion+"</conclusion>";				
				writeplandata+="</page4>";
						*/
					}
					break;
				case ApplicationConstants.SHOW_ASSIGNMENT_MANAGER:						
					ClearAssignmentData();
					facade.sendNotification(ApplicationConstants.CLOSE_HOME_BTN);
					
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					PopupPlaceHolder.addChild(assignmentmanager);					
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
					break;
				case ApplicationConstants.CLOSE_ASSIGNMENT_MANAGER:						
					facade.sendNotification(ApplicationConstants.SHOW_HOME_BTN);
					facade.sendNotification(ApplicationConstants.SHOW_COPY_PASTE);
					while(PopupPlaceHolder.numChildren>0)
					{
						PopupPlaceHolder.removeChildAt(0);
					}
					PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,0);
					break;
				case ApplicationConstants.LOADED_ASSIGNMENT_DATA:
					var assigndata:String=(notification.getBody() as String);					
					trace("LOADED_ASSIGNMENT_DATA=>"+assigndata);
					assignmentXml=new XML(assigndata);
					trace("assignment.length=>"+assignmentXml..assignment_type.length());
					EnableControls();
					
					var lssp:LoadStoryStartersProxy=LoadStoryStartersProxy(facade.retrieveProxy(LoadStoryStartersProxy.NAME));
					lssp.LoadStoryStarters();			
					
					
					break;
				
				case ApplicationConstants.LOADED_STORY_STARTERS_DATA:
					var ssdata1:String=(notification.getBody() as String);	
					trace("LOADED_STORY_STARTERS_DATA:"+ssdata1);
					//var lwp:LoadWritingPlannerProxy=LoadWritingPlannerProxy(facade.retrieveProxy(LoadWritingPlannerProxy.NAME));
					//lwp.LoadWritingPlanner(1);					
					LoadAssignment();
					break;
				
				case ApplicationConstants.SAVE_WRITING_PLANNER_COMPLETED:
					var ssdata2:String=(notification.getBody() as String);
					trace("SAVE_WRITING_PLANNER_COMPLETED1=>"+ssdata2);
					var ssxml:XML=new XML("<root>"+ssdata2+"</root>");
					trace("SAVE_WRITING_PLANNER_COMPLETED2=>book_id.length()="+ssxml.book_id.length());
					trace("SAVE_WRITING_PLANNER_COMPLETED3=>book_id..length()="+ssxml..book_id.length());					
					trace("SAVE_WRITING_PLANNER_COMPLETED4=>book_id..length()="+ssxml..book_id);
					
					/*if(ssxml.book_id.length()==1)
					{
						var dataprox1:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
						dataprox1.BookID=Number(ssxml..book_id);
						
						facade.sendNotification(ApplicationConstants.NEW_BOOK);
					}*/
					break;
				
				case ApplicationConstants.SAVE_WRITING_PLANNER_ERROR:
					var dataprox2:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					dataprox2.BookID=1;
					
					facade.sendNotification(ApplicationConstants.NEW_BOOK);
					break;
				
			}
		}
		//-----------------------------------------------------		
		private function LoadAssignment()
		{
			var assignment_type:String;
			var organizer_mandatory:String;
			var instructions:String;
			if(assignmentXml..assignment_type.length()==1)
			{
				assignment_type=assignmentXml..assignment_type;
				organizer_mandatory=assignmentXml..organizer_mandatory;
				instructions=assignmentXml..instructions;	
				
				if(assignment_type=="fiction" || assignment_type=="nonfiction" || assignment_type=="student choice")
				{
					if(instructions.length>0)
					{
						LoadAssignmentPage2();
					}
					else
					{
						LoadAssignmentPage1();
					}
				}
				
			}			
			
		}
		
		private function LoadAssignmentPage1():void
		{			
			while(PopupPlaceHolder.numChildren>0)
			{
				PopupPlaceHolder.removeChildAt(0);
			}
			PopupPlaceHolder.addChild(assignmentPage1);					
			PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
			assignmentPage1.update(assignmentXml,assignmentData);
			
			var lssp:LoadStoryStartersProxy=LoadStoryStartersProxy(facade.retrieveProxy(LoadStoryStartersProxy.NAME));
			assignmentPage1.StoryStarterUpdate(lssp.getApiData(),assignmentData);
		}
		
		private function OnAssignPage1NextClick(evt:MouseEvent):void
		{
			assignmentData.page1_typeofwriting=assignmentPage1.cmb_typeofwriting.selectedItem.label;
			assignmentData.page1_writeabout=assignmentPage1.writeabout.text;
			assignmentData.page1_storystarter=assignmentPage1.cmb_storystarter.selectedItem.label;
			assignmentData.page1_storystarter_index=""+assignmentPage1.cmb_storystarter.selectedIndex;
			
			if(assignmentData.page1_typeofwriting=="fiction")
			{
				LoadAssignmentPage3();
			}
			else if(assignmentData.page1_typeofwriting=="nonfiction")
			{
				LoadAssignmentPage4();
			}
				
			
		}
		
		private function LoadAssignmentPage2():void
		{			
			while(PopupPlaceHolder.numChildren>0)
			{
				PopupPlaceHolder.removeChildAt(0);
			}
			PopupPlaceHolder.addChild(assignmentPage2);					
			PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
			assignmentPage2.update(assignmentXml,assignmentData);
			
			var lssp:LoadStoryStartersProxy=LoadStoryStartersProxy(facade.retrieveProxy(LoadStoryStartersProxy.NAME));
			assignmentPage2.StoryStarterUpdate(lssp.getApiData(),assignmentData);
			
		}
		
		private function OnAssignPage2NextClick(evt:MouseEvent):void
		{
			assignmentData.page2_typeofwriting=assignmentPage2.cmb_typeofwriting.selectedItem.label;
			assignmentData.page2_writeabout=assignmentPage2.writeabout.text;			
			
			assignmentData.page2_storystarter=assignmentPage2.cmb_storystarter.selectedItem.label;
			assignmentData.page2_storystarter_index=""+assignmentPage2.cmb_storystarter.selectedIndex;
			
			if(assignmentData.page2_typeofwriting=="fiction")
			{
				LoadAssignmentPage3();
			}
			else if(assignmentData.page2_typeofwriting=="nonfiction")
			{
				LoadAssignmentPage4();
			}
		}		
		
		private function LoadAssignmentPage3():void
		{			
			while(PopupPlaceHolder.numChildren>0)
			{
				PopupPlaceHolder.removeChildAt(0);
			}
			PopupPlaceHolder.addChild(assignmentPage3);					
			PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
			assignmentPage3.update(assignmentXml,assignmentData);
			
			if(String(assignmentData.page1_storystarter).length>0)
			{				
				assignmentPage3.m_storystarter_caption.text="Story Starter:";
				assignmentPage3.m_storystarter_value.text=assignmentData.page1_storystarter;
			}
			else if(String(assignmentData.page2_storystarter).length>0)
			{				
				assignmentPage3.m_storystarter_caption.text="Story Starter:";
				assignmentPage3.m_storystarter_value.text=assignmentData.page2_storystarter;
			}
			else
			{				
				assignmentPage3.m_storystarter_caption.text="";
				assignmentPage3.m_storystarter_value.text="";
			}
		}
		
		private function LoadAssignmentPage4():void
		{			
			while(PopupPlaceHolder.numChildren>0)
			{
				PopupPlaceHolder.removeChildAt(0);
			}
			PopupPlaceHolder.addChild(assignmentPage4);					
			PopupPlaceHolder.parent.setChildIndex(PopupPlaceHolder,PopupPlaceHolder.parent.numChildren-1);
			assignmentPage4.update(assignmentXml,assignmentData);
			
			if(String(assignmentData.page1_storystarter).length>0)
			{				
				assignmentPage4.m_storystarter_caption.text="Story Starter:";
				assignmentPage4.m_storystarter_value.text=assignmentData.page1_storystarter;
			}
			else if(String(assignmentData.page2_storystarter).length>0)
			{				
				assignmentPage4.m_storystarter_caption.text="Story Starter:";
				assignmentPage4.m_storystarter_value.text=assignmentData.page2_storystarter;
			}
			else
			{				
				assignmentPage4.m_storystarter_caption.text="";
				assignmentPage4.m_storystarter_value.text="";
			}
		}
		
		
		
		/*
		{page1_typeofwriting:"",page1_writeabout:"",page1_storystarter:"",
		page2_typeofwriting:"",page2_writeabout:"",
		page3_characters:"",page3_story_takeplace:"",page3_problem:"",page3_events:"",page3_solution:""};
		*/
		private function OnAssignPage3PrevClick(evt:MouseEvent):void
		{			
			trace("OnAssignPage3PrevClick=>"+assignmentXml..instructions+","+String(assignmentXml..instructions).length);
			assignmentData.page3_characters=assignmentPage3.m_characters.text;
			assignmentData.page3_story_takeplace=assignmentPage3.m_story_takeplace.text;
			assignmentData.page3_problem=assignmentPage3.m_problem.text;
			assignmentData.page3_events=assignmentPage3.m_events.text;
			assignmentData.page3_solution=assignmentPage3.m_solution.text;
			
			
			if(String(assignmentXml..instructions).length>0)
			{
				LoadAssignmentPage2();
			}
			else
			{
				LoadAssignmentPage1();
			}			
		}
		private function OnAssignPage3SaveClick(evt:MouseEvent):void
		{
			assignmentData.page3_characters=assignmentPage3.m_characters.text;
			assignmentData.page3_story_takeplace=assignmentPage3.m_story_takeplace.text;
			assignmentData.page3_problem=assignmentPage3.m_problem.text;
			assignmentData.page3_events=assignmentPage3.m_events.text;
			assignmentData.page3_solution=assignmentPage3.m_solution.text;
			facade.sendNotification(ApplicationConstants.CLOSE_ASSIGNMENT_MANAGER);
			
			/*
			var assignid:Number=Number(assignmentmanager.m_assignmentIDPopup.m_assignmentid.text);
			if(assignid>0)
			{	
			}
			assignment_type=assignmentXml..assignment_type;
				organizer_mandatory=assignmentXml..organizer_mandatory;
				instructions=assignmentXml..instructions;
			*/
			
			
			
			var writeplandata:String="<writingplanner>";
			
			if(assignmentXml..assignment_type.length()==1)
			{
				var assignid:Number=Number(assignmentmanager.m_assignmentIDPopup.m_assignmentid.text);
				writeplandata+="<assignmentdata>";				
				writeplandata+="<assignment_id>"+assignid.toString()+"</assignment_id>";
				writeplandata+="<assignment_type>"+assignmentXml..assignment_type+"</assignment_type>";
				writeplandata+="<organizer_mandatory>"+assignmentXml..organizer_mandatory+"</organizer_mandatory>";
				writeplandata+="<instructions>"+assignmentXml..instructions+"</instructions>";
				writeplandata+="</assignmentdata>";
			}
			
			writeplandata+="<writingplannerdata>";
				writeplandata+="<page1>";
				writeplandata+="<typeofwriting>"+assignmentData.page1_typeofwriting+"</typeofwriting>";
				writeplandata+="<writeabout>"+assignmentData.page1_writeabout+"</writeabout>";
				writeplandata+="<storystarter>"+assignmentData.page1_storystarter+"</storystarter>";
				writeplandata+="<storystarterindex>"+assignmentData.page1_storystarter_index+"</storystarterindex>";				
				writeplandata+="</page1>";
				
				writeplandata+="<page2>";
				writeplandata+="<typeofwriting>"+assignmentData.page2_typeofwriting+"</typeofwriting>";
				writeplandata+="<writeabout>"+assignmentData.page2_writeabout+"</writeabout>";
				writeplandata+="<storystarter>"+assignmentData.page2_storystarter+"</storystarter>";
				writeplandata+="<storystarterindex>"+assignmentData.page2_storystarter_index+"</storystarterindex>";				
				writeplandata+="</page2>";
				
				writeplandata+="<page3>";
				writeplandata+="<characters>"+assignmentData.page3_characters+"</characters>";
				writeplandata+="<story_takeplace>"+assignmentData.page3_story_takeplace+"</story_takeplace>";
				writeplandata+="<problem>"+assignmentData.page3_problem+"</problem>";
				writeplandata+="<events>"+assignmentData.page3_events+"</events>";
				writeplandata+="<solution>"+assignmentData.page3_solution+"</solution>";
				writeplandata+="</page3>";
			writeplandata+="</writingplannerdata>";
			writeplandata+="</writingplanner>";
			/*for(var dv in assignmentData)
			{
				trace(dv+":"+assignmentData[dv]);
				writeplandata+="<"+dv+">"+assignmentData[dv]+"</"+dv+">";
			}*/
			
			//var appdatastr:String = JSON.encode(assignmentData);
			//var writeplandata:String="<writingplannerdata>"+appdatastr+"</writingplannerdata>";
			
			trace("SaveWritingPlannerProxy=>"+writeplandata);
			var swp:SaveWritingPlannerProxy=SaveWritingPlannerProxy(facade.retrieveProxy(SaveWritingPlannerProxy.NAME));
			swp.SaveWritingPlanner(writeplandata,DataProxy(facade.retrieveProxy(DataProxy.NAME)).BookID);
			
		}
		private function OnAssignPage3SkipClick(evt:MouseEvent):void
		{			
			facade.sendNotification(ApplicationConstants.CLOSE_ASSIGNMENT_MANAGER);
			
			var writeplandata:String="<writingplanner>";
			
			if(assignmentXml..assignment_type.length()==1)
			{
				writeplandata+="<assignmentdata>";				
				writeplandata+="<assignment_type>"+assignmentXml..assignment_type+"</assignment_type>";
				writeplandata+="<organizer_mandatory>"+assignmentXml..organizer_mandatory+"</organizer_mandatory>";
				writeplandata+="<instructions>"+assignmentXml..instructions+"</instructions>";
				writeplandata+="</assignmentdata>";
			}
			
			writeplandata+="<writingplannerdata>";
			writeplandata+="<page1>";
			writeplandata+="<typeofwriting>"+assignmentData.page1_typeofwriting+"</typeofwriting>";
			writeplandata+="<writeabout>"+assignmentData.page1_writeabout+"</writeabout>";
			writeplandata+="<storystarter>"+assignmentData.page1_storystarter+"</storystarter>";
			writeplandata+="<storystarterindex>"+assignmentData.page1_storystarter_index+"</storystarterindex>";		
			writeplandata+="</page1>";
			
			writeplandata+="<page2>";
			writeplandata+="<typeofwriting>"+assignmentData.page2_typeofwriting+"</typeofwriting>";
			writeplandata+="<writeabout>"+assignmentData.page2_writeabout+"</writeabout>";
			writeplandata+="<storystarter>"+assignmentData.page2_storystarter+"</storystarter>";
			writeplandata+="<storystarterindex>"+assignmentData.page2_storystarter_index+"</storystarterindex>";		
			writeplandata+="</page2>";
			
			writeplandata+="<page3>";
			writeplandata+="<characters>"+assignmentData.page3_characters+"</characters>";
			writeplandata+="<story_takeplace>"+assignmentData.page3_story_takeplace+"</story_takeplace>";
			writeplandata+="<problem>"+assignmentData.page3_problem+"</problem>";
			writeplandata+="<events>"+assignmentData.page3_events+"</events>";
			writeplandata+="<solution>"+assignmentData.page3_solution+"</solution>";
			writeplandata+="</page3>";
			writeplandata+="</writingplannerdata>";
			writeplandata+="</writingplanner>";
			//var appdatastr:String = JSON.encode(assignmentData);
			//var writeplandata:String="<writingplannerdata>"+appdatastr+"</writingplannerdata>";
			trace("OnAssignPage4SaveClick=>"+writeplandata);
			var swp:SaveWritingPlannerProxy=SaveWritingPlannerProxy(facade.retrieveProxy(SaveWritingPlannerProxy.NAME));
			swp.SaveWritingPlanner(writeplandata,DataProxy(facade.retrieveProxy(DataProxy.NAME)).BookID);
			/*var dataprox1:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			dataprox1.BookID=1;
			
			facade.sendNotification(ApplicationConstants.NEW_BOOK);*/
		}
		
		private function OnAssignPage4PrevClick(evt:MouseEvent):void
		{
			assignmentData.page4_introduction=assignmentPage4.m_introduction.text;
			assignmentData.page4_body=assignmentPage4.m_body.text;
			assignmentData.page4_conclusion=assignmentPage4.m_conclusion.text;
			
			
			
			if(String(assignmentXml..instructions).length>0)
			{
				LoadAssignmentPage2();
			}
			else
			{
				LoadAssignmentPage1();
			}			
		}
		
		private function OnAssignPage4SaveClick(evt:MouseEvent):void
		{
			assignmentData.page4_introduction=assignmentPage4.m_introduction.text;
			assignmentData.page4_body=assignmentPage4.m_body.text;
			assignmentData.page4_conclusion=assignmentPage4.m_conclusion.text;
			facade.sendNotification(ApplicationConstants.CLOSE_ASSIGNMENT_MANAGER);
			
			
			var writeplandata:String="<writingplanner>";
			
			if(assignmentXml..assignment_type.length()==1)
			{
				writeplandata+="<assignmentdata>";				
				writeplandata+="<assignment_type>"+assignmentXml..assignment_type+"</assignment_type>";
				writeplandata+="<organizer_mandatory>"+assignmentXml..organizer_mandatory+"</organizer_mandatory>";
				writeplandata+="<instructions>"+assignmentXml..instructions+"</instructions>";
				writeplandata+="</assignmentdata>";
			}
			
			writeplandata+="<writingplannerdata>";
				writeplandata+="<page1>";
				writeplandata+="<typeofwriting>"+assignmentData.page1_typeofwriting+"</typeofwriting>";
				writeplandata+="<writeabout>"+assignmentData.page1_writeabout+"</writeabout>";
				writeplandata+="<storystarter>"+assignmentData.page1_storystarter+"</storystarter>";
				writeplandata+="<storystarterindex>"+assignmentData.page1_storystarter_index+"</storystarterindex>";		
				writeplandata+="</page1>";
				
				writeplandata+="<page2>";
				writeplandata+="<typeofwriting>"+assignmentData.page2_typeofwriting+"</typeofwriting>";
				writeplandata+="<writeabout>"+assignmentData.page2_writeabout+"</writeabout>";
				writeplandata+="<storystarter>"+assignmentData.page2_storystarter+"</storystarter>";				
				writeplandata+="<storystarterindex>"+assignmentData.page2_storystarter_index+"</storystarterindex>";		
				writeplandata+="</page2>";
				
				writeplandata+="<page3>";
				writeplandata+="<characters>"+assignmentData.page3_characters+"</characters>";
				writeplandata+="<story_takeplace>"+assignmentData.page3_story_takeplace+"</story_takeplace>";
				writeplandata+="<problem>"+assignmentData.page3_problem+"</problem>";
				writeplandata+="<events>"+assignmentData.page3_events+"</events>";
				writeplandata+="<solution>"+assignmentData.page3_solution+"</solution>";
				writeplandata+="</page3>";
				
				writeplandata+="<page4>";
				writeplandata+="<introduction>"+assignmentData.page4_introduction+"</introduction>";
				writeplandata+="<body>"+assignmentData.page4_body+"</body>";
				writeplandata+="<conclusion>"+assignmentData.page4_conclusion+"</conclusion>";				
				writeplandata+="</page4>";
				
			writeplandata+="</writingplannerdata>";
			writeplandata+="</writingplanner>";
			/*for(var dv in assignmentData)
			{
				trace(dv+":"+assignmentData[dv]);
				writeplandata+="<"+dv+">"+assignmentData[dv]+"</"+dv+">";
			}*/
			
			//var appdatastr:String = JSON.encode(assignmentData);
			//var writeplandata:String="<writingplannerdata>"+appdatastr+"</writingplannerdata>";
			
			trace("OnAssignPage4SaveClick=>"+writeplandata);
			var swp:SaveWritingPlannerProxy=SaveWritingPlannerProxy(facade.retrieveProxy(SaveWritingPlannerProxy.NAME));
			swp.SaveWritingPlanner(writeplandata,DataProxy(facade.retrieveProxy(DataProxy.NAME)).BookID);
		}
		private function OnAssignPage4SkipClick(evt:MouseEvent):void
		{
			facade.sendNotification(ApplicationConstants.CLOSE_ASSIGNMENT_MANAGER);
			
			var writeplandata:String="<writingplanner>";
			
			if(assignmentXml..assignment_type.length()==1)
			{
				writeplandata+="<assignmentdata>";				
				writeplandata+="<assignment_type>"+assignmentXml..assignment_type+"</assignment_type>";
				writeplandata+="<organizer_mandatory>"+assignmentXml..organizer_mandatory+"</organizer_mandatory>";
				writeplandata+="<instructions>"+assignmentXml..instructions+"</instructions>";
				writeplandata+="</assignmentdata>";
			}
			
			writeplandata+="<writingplannerdata>";
			writeplandata+="<page1>";
			writeplandata+="<typeofwriting>"+assignmentData.page1_typeofwriting+"</typeofwriting>";
			writeplandata+="<writeabout>"+assignmentData.page1_writeabout+"</writeabout>";
			writeplandata+="<storystarter>"+assignmentData.page1_storystarter+"</storystarter>";
			writeplandata+="<storystarterindex>"+assignmentData.page1_storystarter_index+"</storystarterindex>";		
			writeplandata+="</page1>";
			
			writeplandata+="<page2>";
			writeplandata+="<typeofwriting>"+assignmentData.page2_typeofwriting+"</typeofwriting>";
			writeplandata+="<writeabout>"+assignmentData.page2_writeabout+"</writeabout>";
			writeplandata+="<storystarter>"+assignmentData.page2_storystarter+"</storystarter>";
			writeplandata+="<storystarterindex>"+assignmentData.page2_storystarter_index+"</storystarterindex>";		
			writeplandata+="</page2>";
			
			writeplandata+="<page3>";
			writeplandata+="<characters>"+assignmentData.page3_characters+"</characters>";
			writeplandata+="<story_takeplace>"+assignmentData.page3_story_takeplace+"</story_takeplace>";
			writeplandata+="<problem>"+assignmentData.page3_problem+"</problem>";
			writeplandata+="<events>"+assignmentData.page3_events+"</events>";
			writeplandata+="<solution>"+assignmentData.page3_solution+"</solution>";
			writeplandata+="</page3>";
						
			writeplandata+="<page4>";
				writeplandata+="<introduction>"+assignmentData.page4_introduction+"</introduction>";
				writeplandata+="<body>"+assignmentData.page4_body+"</body>";
				writeplandata+="<conclusion>"+assignmentData.page4_conclusion+"</conclusion>";				
				writeplandata+="</page4>";
				
			writeplandata+="</writingplannerdata>";
			writeplandata+="</writingplanner>";
			//var appdatastr:String = JSON.encode(assignmentData);
			//var writeplandata:String="<writingplannerdata>"+appdatastr+"</writingplannerdata>";
			trace("OnAssignPage4SaveClick=>"+writeplandata);
			var swp:SaveWritingPlannerProxy=SaveWritingPlannerProxy(facade.retrieveProxy(SaveWritingPlannerProxy.NAME));
			swp.SaveWritingPlanner(writeplandata,DataProxy(facade.retrieveProxy(DataProxy.NAME)).BookID);
		}
		//-----------------------------------------------------
		protected function get PopupPlaceHolder():PopupPlaceHolderView
		{
			return viewComponent as PopupPlaceHolderView;
		}
		
		
	}
}
