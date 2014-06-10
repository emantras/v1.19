package com.learning.atoz.storycreation.view.components  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.data.DataProvider;
	import flash.text.TextFormat;
	import fl.controls.TextArea;
	import flash.display.Sprite;
	
	/*
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.data.DataProvider;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	*/

	public class AssignmentPage3 extends MovieClip
	{
		public function AssignmentPage3()
		{
			// constructor code
			
			//this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		private function OnInit(evt:Event):void
		{			
			trace("AssignmentPage3->");
			m_characters.textField.border = false;
			//m_characters.textField.opaqueBackground = 0xeeeeee;
			m_characters.textField.borderColor = 0xeeeeee;
			m_characters.setStyle("upSkin",Sprite);
			m_characters.text="";
			m_characters.textField.mouseWheelEnabled = true;
						
			
			m_story_takeplace.textField.border = false;
			//m_story_takeplace.textField.opaqueBackground = 0xeeeeee;
			m_story_takeplace.textField.borderColor = 0xeeeeee;
			m_story_takeplace.setStyle("upSkin",Sprite);
			m_story_takeplace.text="";
			m_story_takeplace.textField.mouseWheelEnabled = true;
			
			m_problem.textField.border = false;
			//m_problem.textField.opaqueBackground = 0xeeeeee;
			m_problem.textField.borderColor = 0xeeeeee;
			m_problem.setStyle("upSkin",Sprite);
			m_problem.text="";
			m_problem.textField.mouseWheelEnabled = true;
			
			m_events.textField.border = false;
			//m_events.textField.opaqueBackground = 0xeeeeee;
			m_events.textField.borderColor = 0xeeeeee;
			m_events.setStyle("upSkin",Sprite);
			m_events.text="";
			m_events.textField.mouseWheelEnabled = true;
			
			
			m_solution.textField.border = false;
			//m_solution.textField.opaqueBackground = 0xeeeeee;
			m_solution.textField.borderColor = 0xeeeeee;
			m_solution.setStyle("upSkin",Sprite);
			m_solution.text="";
			m_solution.textField.mouseWheelEnabled = true;
			
			
			m_characters.textField.background=false;
			m_story_takeplace.textField.background=false;
			m_problem.textField.background=false;
			m_events.textField.background=false;
			m_solution.textField.background=false;
			
			
			trace("AssignmentPage3->2");
			m_characters.text="";
			m_story_takeplace.text="";
			trace("AssignmentPage3->3");
			m_problem.text="";
			m_events.text="";
			trace("AssignmentPage3->4");
			m_solution.text="";
			trace("AssignmentPage3->5");
			hline.visible=false;
			
		}
		
		public function update(assignmentXml:XML,assigndata:Object):void
		{
			if(assignmentXml..organizer_mandatory.length()>0)
			{
				if(assignmentXml..organizer_mandatory=="y")
				{
					BtnAssignPage3Skip.visible=false;
				}
				else
				{
					BtnAssignPage3Skip.visible=true;
				}
			}	
			
			
						
			m_characters.textField.border = false;
			//m_characters.textField.opaqueBackground = 0xeeeeee;
			m_characters.textField.borderColor = 0xeeeeee;
			m_characters.setStyle("upSkin",Sprite);
			m_characters.text="";
			
			m_story_takeplace.textField.border = false;
			//m_story_takeplace.textField.opaqueBackground = 0xeeeeee;
			m_story_takeplace.textField.borderColor = 0xeeeeee;
			m_story_takeplace.setStyle("upSkin",Sprite);
			m_story_takeplace.text="";
			
			
			m_problem.textField.border = false;
			//m_problem.textField.opaqueBackground = 0xeeeeee;
			m_problem.textField.borderColor = 0xeeeeee;
			m_problem.setStyle("upSkin",Sprite);
			m_problem.text="";
			
			m_events.textField.border = false;
			//m_events.textField.opaqueBackground = 0xeeeeee;
			m_events.textField.borderColor = 0xeeeeee;
			m_events.setStyle("upSkin",Sprite);
			m_events.text="";
			
			
			m_solution.textField.border = false;
			//m_solution.textField.opaqueBackground = 0xeeeeee;
			m_solution.textField.borderColor = 0xeeeeee;
			m_solution.setStyle("upSkin",Sprite);
			m_solution.text="";
			
			m_characters.textField.background=false;
			m_story_takeplace.textField.background=false;
			m_problem.textField.background=false;
			m_events.textField.background=false;
			m_solution.textField.background=false;			
			
			m_characters.text=assigndata.page3_characters;
			m_story_takeplace.text=assigndata.page3_story_takeplace;			
			m_problem.text=assigndata.page3_problem;
			m_events.text=assigndata.page3_events;			
			m_solution.text=assigndata.page3_solution;
			
			
			if(String(m_storystarter_caption.text).length<=0 && String(m_storystarter_value.text).length<=0)
			{
				hline.visible=false;
			}
			else
			{
				hline.visible=true;
			}
			
			
			
		}

	}
	
}
