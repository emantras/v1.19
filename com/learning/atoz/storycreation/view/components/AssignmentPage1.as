package com.learning.atoz.storycreation.view.components  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.data.DataProvider;
	import flash.text.TextFormat;
	
	import com.learning.atoz.storycreation.model.LoadStoryStartersProxy;
	
	import fl.data.DataProvider;
	import flash.display.Sprite;
	
	/*
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.data.DataProvider;
	import flash.text.TextFormat;
	
	import com.learning.atoz.storycreation.model.LoadStoryStartersProxy;
	
	import fl.data.DataProvider;
	import flash.display.Sprite;
	*/

	public class AssignmentPage1 extends MovieClip
	{
		public function AssignmentPage1()
		{
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		private function OnInit(evt:Event):void
		{			
			trace("AssignmentPage1->");
			writeabout.textField.border = false;
			//writeabout.textField.opaqueBackground = 0xeeeeee;
			writeabout.textField.background=false;
			writeabout.textField.borderColor = 0xeeeeee;
			writeabout.setStyle("upSkin",Sprite);
			writeabout.text="";
			
			
			
			Ass_Page1_Choose.visible=true;
			cmb_typeofwriting.visible=true;
			
			Ass_Page1_Review.visible=false;			
			lblFicNonFic.visible=false;
			
			
			var dp:DataProvider=new DataProvider();
			dp.addItem({label:"Select",data:"select"});
			dp.addItem({label:"fiction",data:"fiction"});
			dp.addItem({label:"nonfiction",data:"nonfiction"});
						
			cmb_typeofwriting.dataProvider=dp;
			var myFormat : TextFormat = new TextFormat();
			myFormat.font = "Arial";
			myFormat.color = 0x000000;
			myFormat.size = 14;
			myFormat.indent = 4;
			 
			cmb_typeofwriting.textField.setStyle("textFormat", myFormat);
			//cmb_typeofwriting.textField.setStyle( "embedFonts", true);			 
			
			cmb_typeofwriting.dropdown.setRendererStyle("textFormat", myFormat);
			//cmb_typeofwriting.dropdown.setRendererStyle("embedFonts", true);
			
				
			
		}
		
		public function StoryStarterUpdate(ssdata:String,assignmentData:Object):void
		{
			var xmldata:XML=new XML(ssdata);
			
			var dp2:DataProvider=new DataProvider();
			if(xmldata..story_starter.length()>0)
			{
				for(var dv:int=0;dv<xmldata..story_starter.length();dv++)
				{
					dp2.addItem({label:xmldata..story_starter[dv],data:(dv+1)});
				}
				
			}
			
			var myFormat : TextFormat = new TextFormat();
			myFormat.font = "Arial";
			myFormat.color = 0x000000;
			myFormat.size = 14;
			myFormat.indent = 4;
			
			cmb_storystarter.dataProvider=dp2;
			cmb_storystarter.textField.setStyle("textFormat", myFormat);
			cmb_storystarter.dropdown.setRendererStyle("textFormat", myFormat);	
			cmb_storystarter.selectedIndex=Number(assignmentData.page1_storystarter_index);
			cmb_storystarter.editable=false;
		}
		
		public function update(assignmentXml:XML,assigndata:Object):void
		{			
			writeabout.textField.border = false;
			//writeabout.textField.opaqueBackground = 0xeeeeee;
			writeabout.textField.background=false;
			writeabout.textField.borderColor = 0xeeeeee;
			writeabout.setStyle("upSkin",Sprite);
			writeabout.text="";
			
			
			if(assignmentXml..instructions.length()>0)
			{
				writeabout.text=assignmentXml..instructions;
			}	
			
			if(String(assigndata.page1_writeabout).length>0)
			{
				writeabout.text=assigndata.page1_writeabout;
			}
			else
			{
				if(String(assigndata.page2_writeabout).length>0)
				{
					writeabout.text=assigndata.page2_writeabout;
				}
				else
				{
					writeabout.text="I will write about…";
				}
			}
			
			if(assignmentXml..assignment_type.length()==1)
			{
				if(assignmentXml..assignment_type=="fiction")
				{
					cmb_typeofwriting.selectedIndex=1;
					cmb_typeofwriting.enabled=false;
					
					Ass_Page1_Choose.visible=false;
					cmb_typeofwriting.visible=false;
					
					Ass_Page1_Review.visible=true;			
					lblFicNonFic.visible=true;
					lblFicNonFic.text=assignmentXml..assignment_type;
				}
				else if(assignmentXml..assignment_type=="nonfiction")
				{
					cmb_typeofwriting.selectedIndex=2;
					cmb_typeofwriting.enabled=false;
					
					Ass_Page1_Choose.visible=false;
					cmb_typeofwriting.visible=false;
					
					Ass_Page1_Review.visible=true;			
					lblFicNonFic.visible=true;
					lblFicNonFic.text=assignmentXml..assignment_type;
				}
				else if(assignmentXml..assignment_type=="student choice")
				{
					cmb_typeofwriting.selectedIndex=0;
					cmb_typeofwriting.enabled=true;
					
					Ass_Page1_Choose.visible=true;
					cmb_typeofwriting.visible=true;
					
					Ass_Page1_Review.visible=false;			
					lblFicNonFic.visible=false;
				}				
			}			
		}

	}
	
}
