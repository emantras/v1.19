package com.learning.atoz.storycreation.view.components.callout
{	
	import flash.display.Sprite;
	
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;	
	import fl.core.UIComponent;
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.MouseEvent;
	import flash.events.Event;	
	import fl.text.TLFTextField;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.TextFlow;
	import flash.text.engine.FontWeight;
	
	/*
	import flash.display.Sprite;
	
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;	
	import fl.core.UIComponent;
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.text.TLFTextField;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.edit.SelectionState;
	*/
	
	public class TextTool extends Sprite
	{
		private var cmbfontdp:DataProvider;
		private var cmbfontsizedp:DataProvider;		
		private var colorPicker:ColorPicker;
		private var cmbFont:ComboBox;
		private var cmbFontSize:ComboBox;
		private var colpopup:colorPopup;
		public var targetCtrl:TLFTextField;
		public var targetTextFlow:TextFlow;
		public function TextTool()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		private function OnInit(evt:Event)
		{
			//var bg:toolTextBg=new toolTextBg();
			//this.addChildAt(bg,0);
			
			cmbFont=new ComboBox();
			cmbFont.name="cmbFont";
			cmbFont.x=3.5;
			cmbFont.y=6;
			cmbFont.width=138;
			cmbFont.height=22;
			fontMenu.addChild(cmbFont);
			
			cmbFontSize=new ComboBox();
			cmbFontSize.name="cmbFontSize";
			cmbFontSize.x=6;
			cmbFontSize.y=6;
			cmbFontSize.width=75;
			cmbFontSize.height=22;
			sizeMenu.addChild(cmbFontSize);
			
			fontMenu.visible=false;
			sizeMenu.visible=false;
			
			//-------------------------------------------------
			cmbfontdp=new DataProvider();
			cmbfontdp.addItem({label:"Select",data:-1});
			
			/*cmbfontdp.addItem({label:"Arial",data:"Arial"});
			cmbfontdp.addItem({label:"Arial Unicode MS",data:"Arial Unicode MS"});
			cmbfontdp.addItem({label:"Arial Black",data:"Arial Black"});
			cmbfontdp.addItem({label:"Helvetica",data:"Helvetica"});
			cmbfontdp.addItem({label:"Times New Roman",data:"Times New Roman"});				
			cmbfontdp.addItem({label:"Courier",data:"Courier"});				
			cmbfontdp.addItem({label:"Verdana",data:"Verdana"});*/
			
			//cmbfontdp.addItem({label:"FS Me",data:"FS Me"});
			//cmbfontdp.addItem({label:"Sans Serif",data:"Sans Serif"});

			cmbfontdp.addItem({label:"Arial",data:"Arial"});
			cmbfontdp.addItem({label:"Courier New",data:"Courier New"});			
			cmbfontdp.addItem({label:"Times New Roman",data:"Times New Roman"});				
			cmbfontdp.addItem({label:"Trebuchet Ms",data:"Trebuchet Ms"});				
			cmbfontdp.addItem({label:"Verdana",data:"Verdana"});
						
			
			cmbFont.dataProvider=cmbfontdp;
			cmbFont.addEventListener(Event.CHANGE,OnFontChange);
			//-------------------------------------------------
			cmbfontsizedp=new DataProvider();
			cmbfontsizedp.addItem({label:"Select",data:-1});
			
			cmbfontsizedp.addItem({label:"10",data:10});
			cmbfontsizedp.addItem({label:"12",data:12});
			cmbfontsizedp.addItem({label:"14",data:14});
			cmbfontsizedp.addItem({label:"16",data:16});
			cmbfontsizedp.addItem({label:"18",data:18});
			cmbfontsizedp.addItem({label:"20",data:20});
			cmbfontsizedp.addItem({label:"24",data:24});
			cmbfontsizedp.addItem({label:"28",data:28});
			cmbfontsizedp.addItem({label:"32",data:32});
			cmbfontsizedp.addItem({label:"36",data:36});
			cmbfontsizedp.addItem({label:"38",data:38});
			cmbfontsizedp.addItem({label:"40",data:40});
			cmbfontsizedp.addItem({label:"42",data:42});
			cmbfontsizedp.addItem({label:"44",data:44});
			cmbfontsizedp.addItem({label:"46",data:46});
			cmbfontsizedp.addItem({label:"48",data:48});
			
			cmbFontSize.dataProvider=cmbfontsizedp;
			cmbFontSize.addEventListener(Event.CHANGE,OnFontSizeChange);
			
			//-------------------------------------------------
			cmbFont.selectedIndex=1;
			cmbFontSize.selectedIndex=3;
			//-------------------------------------------------
			
			//this.addEventListener(MouseEvent.MOUSE_OUT,OnTextToolOut);
			
			BtnBold.addEventListener(MouseEvent.CLICK,OnBtnBoldClick);
			BtnItalic.addEventListener(MouseEvent.CLICK,OnBtnItalicClick);
			BtnUnderline.addEventListener(MouseEvent.CLICK,OnBtnUnderlineClick);
			
						
			BtnFont.addEventListener(MouseEvent.CLICK,OnBtnFontClick);
						
			BtnFontSize.addEventListener(MouseEvent.CLICK,OnBtnFontSizeClick);
						
						
			BtnDeleteCallout.addEventListener(MouseEvent.ROLL_OVER,OnBtnDeleteCalloutOver);
			BtnDeleteCallout.addEventListener(MouseEvent.ROLL_OUT,OnBtnDeleteCalloutOut);
			BtnDeleteCallout.addEventListener(MouseEvent.CLICK,OnBtnDeleteCalloutClick);
			BtnDeleteCallout.buttonMode=true;
			
			colpopup=new colorPopup();
			colpopup.x=colorPickerBG.x+3;
			colpopup.y=colorPickerBG.y+5;
			this.addChild(colpopup);
			colpopup.addEventListener("COLOR_SELECTED",OncolorPickerClick);
									
		}
		
		public function setTextFlow(_targetTextFlow:TextFlow)
		{
			targetTextFlow=_targetTextFlow;	
			
		}
		
		
		public function setTarget(_targetCtrl:TLFTextField):void
		{
			targetCtrl=_targetCtrl;
			
			
		}
		
		private function OncolorPickerClick(evt:Event):void
		{			
			fontMenu.visible=false;
			sizeMenu.visible=false;
			
			if(targetCtrl!=null)
			{			
				var sel:SelectionState = new SelectionState(targetCtrl.textFlow, 0, targetCtrl.text.length);
				var editManager:EditManager = targetCtrl.textFlow.interactionManager as EditManager;
				var txtLayFmt:TextLayoutFormat=editManager.getCommonCharacterFormat() as TextLayoutFormat;						
				//txtLayFmt.color=evt.target.selectedColor;
				txtLayFmt.color=colpopup.selectedColor;
				editManager.applyLeafFormat(txtLayFmt,sel);	
				dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
			}
			else
			{
				if(targetTextFlow!=null)
				{					
					var editManager2:EditManager = targetTextFlow.interactionManager as EditManager;
					//trace("editManager.activePosition="+editManager2.activePosition+",anchorPosition="+editManager2.anchorPosition);
					var sel2:SelectionState = new SelectionState(targetTextFlow, editManager2.anchorPosition, editManager2.activePosition);			
					var txtLayFmt2:TextLayoutFormat=editManager2.getCommonCharacterFormat() as TextLayoutFormat;						
					//txtLayFmt2.color=evt.target.selectedColor;
					txtLayFmt2.color=colpopup.selectedColor;
					editManager2.applyLeafFormat(txtLayFmt2,sel2);
					dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
					
				}
			}
			
		}		
		
		private function OnBtnFontClick(evt:MouseEvent):void
		{
			sizeMenu.visible=false;			
			if(fontMenu.visible==true)
			{
				fontMenu.visible=false;
			}
			else
			{
				fontMenu.visible=true;
				if(targetTextFlow!=null)
				{					
					var editManager3:EditManager = targetTextFlow.interactionManager as EditManager;
					//trace("editManager.activePosition="+editManager3.activePosition+",anchorPosition="+editManager3.anchorPosition);
					var sel3:SelectionState = new SelectionState(targetTextFlow, editManager3.anchorPosition, editManager3.activePosition);			
					var txtLayFmt3:TextLayoutFormat=editManager3.getCommonCharacterFormat() as TextLayoutFormat;						
					if(txtLayFmt3!=null)
					{
						trace("Font:"+txtLayFmt3.fontFamily);
						for(var dv1:int=0;dv1<cmbfontdp.length;dv1++)
						{
							//trace(cmbfontdp.getItemAt(dv1).label);
							if(cmbfontdp.getItemAt(dv1).data==txtLayFmt3.fontFamily)
							{								
								cmbFont.selectedIndex=dv1;
								cmbFont.text=txtLayFmt3.fontFamily;
								cmbFont.prompt=txtLayFmt3.fontFamily;
								dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
								break;
							}
						}
					}
					
				}
				
				
			}
			
		}
		
		private function OnBtnFontSizeClick(evt:MouseEvent):void
		{
			fontMenu.visible=false;
						
			if(sizeMenu.visible==true)
			{
				sizeMenu.visible=false;
			}
			else
			{
				
				sizeMenu.visible=true;
				if(targetTextFlow!=null)
				{					
					var editManager3:EditManager = targetTextFlow.interactionManager as EditManager;
					//trace("editManager.activePosition="+editManager3.activePosition+",anchorPosition="+editManager3.anchorPosition);
					var sel3:SelectionState = new SelectionState(targetTextFlow, editManager3.anchorPosition, editManager3.activePosition);			
					var txtLayFmt3:TextLayoutFormat=editManager3.getCommonCharacterFormat() as TextLayoutFormat;						
					if(txtLayFmt3!=null)
					{
						trace("FontSize:"+txtLayFmt3.fontSize);
						for(var dv1:int=0;dv1<cmbFontSize.length;dv1++)
						{							
							if(cmbFontSize.getItemAt(dv1).data==txtLayFmt3.fontSize)
							{								
								cmbFontSize.selectedIndex=dv1;
								cmbFontSize.text=txtLayFmt3.fontSize;
								cmbFontSize.prompt=txtLayFmt3.fontSize;
								dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
								break;
							}
						}
					}
					
				}
			}
		}
		
		
		public function OnFontChange(evt:*):void
		{
			fontMenu.visible=false;
		
			if(targetCtrl!=null)
			{
				var sel:SelectionState = new SelectionState(targetCtrl.textFlow, 0, targetCtrl.text.length);
				var editManager:EditManager = targetCtrl.textFlow.interactionManager as EditManager;
				var txtLayFmt:TextLayoutFormat=editManager.getCommonCharacterFormat() as TextLayoutFormat;						
				txtLayFmt.fontFamily = cmbFont.selectedItem.data;				
				editManager.applyLeafFormat(txtLayFmt,sel);
				dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
			}
			else
			{
				if(targetTextFlow!=null)
				{					
					var editManager3:EditManager = targetTextFlow.interactionManager as EditManager;
					//trace("editManager.activePosition="+editManager3.activePosition+",anchorPosition="+editManager3.anchorPosition);
					var sel3:SelectionState = new SelectionState(targetTextFlow, editManager3.anchorPosition, editManager3.activePosition);			
					var txtLayFmt3:TextLayoutFormat=editManager3.getCommonCharacterFormat() as TextLayoutFormat;						
					txtLayFmt3.fontFamily = cmbFont.selectedItem.data;				
					editManager3.applyLeafFormat(txtLayFmt3,sel3);
					dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
					
					
				}
			}
						
		}
		//-------------------------------------------------
		public function OnFontSizeChange(evt:*):void
		{		
			sizeMenu.visible=false;
			if(targetCtrl!=null)
			{
				var sel:SelectionState = new SelectionState(targetCtrl.textFlow, 0, targetCtrl.text.length);
				var editManager:EditManager = targetCtrl.textFlow.interactionManager as EditManager;
				var txtLayFmt:TextLayoutFormat=editManager.getCommonCharacterFormat() as TextLayoutFormat;						
				txtLayFmt.fontSize = cmbFontSize.selectedItem.data;			
				editManager.applyLeafFormat(txtLayFmt,sel);
				dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
			}
			else
			{
				if(targetTextFlow!=null)
				{					
					var editManager4:EditManager = targetTextFlow.interactionManager as EditManager;
					//trace("editManager.activePosition="+editManager4.activePosition+",anchorPosition="+editManager4.anchorPosition);
					var sel4:SelectionState = new SelectionState(targetTextFlow, editManager4.anchorPosition, editManager4.activePosition);				
					var txtLayFmt4:TextLayoutFormat=editManager4.getCommonCharacterFormat() as TextLayoutFormat;						
					txtLayFmt4.fontSize = cmbFontSize.selectedItem.data;			
					editManager4.applyLeafFormat(txtLayFmt4,sel4);
					dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
					
				}
			}
						
		}
		
		private function OnBtnDeleteCalloutOver(evt:MouseEvent):void
		{
			BtnDeleteCallout.gotoAndStop(2);
		}
		
		private function OnBtnDeleteCalloutOut(evt:MouseEvent):void
		{
			BtnDeleteCallout.gotoAndStop(1);
		}
		
		private function OnBtnDeleteCalloutClick(evt:MouseEvent):void
		{
			dispatchEvent(new Event("DELETE_CALLOUT_FROM_TEXT_TOOL",false,true));
		}
		
		
		private function OnBtnBoldClick(evt:MouseEvent):void
		{						
			fontMenu.visible=false;
			sizeMenu.visible=false;
			
			if(targetCtrl!=null)
			{
				var sel:SelectionState = new SelectionState(targetCtrl.textFlow, 0, targetCtrl.text.length);
				var editManager:EditManager = targetCtrl.textFlow.interactionManager as EditManager;
				var txtLayFmt:TextLayoutFormat=editManager.getCommonCharacterFormat() as TextLayoutFormat;			
				
				txtLayFmt.fontWeight=(txtLayFmt.fontWeight=="normal")?"bold":"normal";						
				editManager.applyLeafFormat(txtLayFmt,sel);
				dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
			}
			else
			{
				if(targetTextFlow!=null)
				{					
					var editManager5:EditManager = targetTextFlow.interactionManager as EditManager;
					//trace("editManager.activePosition="+editManager5.activePosition+",anchorPosition="+editManager5.anchorPosition);
					var sel5:SelectionState = new SelectionState(targetTextFlow, editManager5.anchorPosition, editManager5.activePosition);
					
					var txtLayFmt5:TextLayoutFormat=editManager5.getCommonCharacterFormat() as TextLayoutFormat;			
					
					txtLayFmt5.fontWeight=(txtLayFmt5.fontWeight=="normal")?"bold":"normal";						
					editManager5.applyLeafFormat(txtLayFmt5,sel5);
					dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
					
				}
			}
			
			
			
		}
		private function OnBtnItalicClick(evt:MouseEvent):void
		{						
			fontMenu.visible=false;
			sizeMenu.visible=false;
			
			if(targetCtrl!=null)
			{
				
			}
			else
			{
				if(targetTextFlow!=null)
				{					
					var editManager:EditManager = targetTextFlow.interactionManager as EditManager;
					trace("editManager.activePosition="+editManager.activePosition+",anchorPosition="+editManager.anchorPosition);
					var sel:SelectionState = new SelectionState(targetTextFlow, editManager.anchorPosition, editManager.activePosition);	
					var txtLayFmt:TextLayoutFormat=editManager.getCommonCharacterFormat() as TextLayoutFormat;			
					txtLayFmt.fontStyle=(txtLayFmt.fontStyle=="normal")?"italic":"normal";						
					editManager.applyLeafFormat(txtLayFmt,sel);
					dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
					
				}
			}
			
		}
		private function OnBtnUnderlineClick(evt:MouseEvent):void
		{						
			fontMenu.visible=false;
			sizeMenu.visible=false;
			
			if(targetCtrl!=null)
			{
				var sel:SelectionState = new SelectionState(targetCtrl.textFlow, 0, targetCtrl.text.length);
				var editManager:EditManager = targetCtrl.textFlow.interactionManager as EditManager;
				var txtLayFmt:TextLayoutFormat=editManager.getCommonCharacterFormat() as TextLayoutFormat;			
				txtLayFmt.textDecoration=(txtLayFmt.textDecoration=="none")?"underline":"none";						
				editManager.applyLeafFormat(txtLayFmt,sel);
				dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
			}
			else
			{
				if(targetTextFlow!=null)
				{					
					var editManager6:EditManager = targetTextFlow.interactionManager as EditManager;
					trace("editManager.activePosition="+editManager6.activePosition+",anchorPosition="+editManager6.anchorPosition);
					var sel6:SelectionState = new SelectionState(targetTextFlow, editManager6.anchorPosition, editManager6.activePosition);			
					var txtLayFmt6:TextLayoutFormat=editManager6.getCommonCharacterFormat() as TextLayoutFormat;			
					txtLayFmt6.textDecoration=(txtLayFmt6.textDecoration=="none")?"underline":"none";						
					editManager6.applyLeafFormat(txtLayFmt6,sel6);
					dispatchEvent(new Event("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",false,true));
					
				}
			}
			
		}
		

	}
	
}

