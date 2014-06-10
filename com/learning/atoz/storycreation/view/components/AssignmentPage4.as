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

	public class AssignmentPage4 extends MovieClip
	{
		public function AssignmentPage4()
		{
			// constructor code
			
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		private function OnInit(evt:Event):void
		{
			trace("AssignmentPage4->");
			m_introduction.textField.border = false;
			//m_introduction.textField.opaqueBackground = 0xeeeeee;
			m_introduction.textField.borderColor = 0xeeeeee;
			m_introduction.setStyle("upSkin",Sprite);
			m_introduction.text="";
			m_introduction.textField.mouseWheelEnabled = true;
			
			m_body.textField.border = false;
			//m_body.textField.opaqueBackground = 0xeeeeee;
			m_body.textField.borderColor = 0xeeeeee;
			m_body.setStyle("upSkin",Sprite);
			m_body.text="";
			m_body.textField.mouseWheelEnabled = true;
			
			m_conclusion.textField.border = false;
			//m_conclusion.textField.opaqueBackground = 0xeeeeee;
			m_conclusion.textField.borderColor = 0xeeeeee;
			m_conclusion.setStyle("upSkin",Sprite);
			m_conclusion.text="";
			m_conclusion.textField.mouseWheelEnabled = true;
			
			
			m_introduction.textField.background=false;
			m_body.textField.background=false;
			m_conclusion.textField.background=false;
			
			
			m_introduction.text="";
			m_body.text="";			
			m_conclusion.text="";			
			
		}
		
		public function update(assignmentXml:XML,assigndata:Object):void
		{
			if(assignmentXml..organizer_mandatory.length()>0)
			{
				if(assignmentXml..organizer_mandatory=="y")
				{
					BtnAssignPage4Skip.visible=false;
				}
				else
				{
					BtnAssignPage4Skip.visible=true;
				}
			}
			
			
			m_introduction.textField.border = false;
			//m_introduction.textField.opaqueBackground = 0xeeeeee;
			m_introduction.textField.borderColor = 0xeeeeee;
			m_introduction.setStyle("upSkin",Sprite);
			m_introduction.text="";
			
			
			m_body.textField.border = false;
			//m_body.textField.opaqueBackground = 0xeeeeee;
			m_body.textField.borderColor = 0xeeeeee;
			m_body.setStyle("upSkin",Sprite);
			m_body.text="";
			
			m_conclusion.textField.border = false;
			//m_conclusion.textField.opaqueBackground = 0xeeeeee;
			m_conclusion.textField.borderColor = 0xeeeeee;
			m_conclusion.setStyle("upSkin",Sprite);
			m_conclusion.text="";
			
			
			m_introduction.textField.background=false;
			m_body.textField.background=false;
			m_conclusion.textField.background=false;
			
			m_introduction.text=assigndata.page4_introduction;
			m_body.text=assigndata.page4_body;			
			m_conclusion.text=assigndata.page4_conclusion;
			
			
		}

	}
	
}
