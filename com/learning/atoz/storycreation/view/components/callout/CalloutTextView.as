package com.learning.atoz.storycreation.view.components.callout
{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import fl.text.TLFTextField;
	import com.learning.atoz.storycreation.view.components.callout.TextTool;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.conversion.ConversionType;
	import flash.display.Stage;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	import com.learning.atoz.storycreation.view.components.SwfCHRComponent;
	import com.learning.atoz.storycreation.view.components.SwfComponent;
	import com.learning.atoz.storycreation.view.components.SwfOBJComponent;
	import flash.geom.Point;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flashx.textLayout.edit.EditManager;
	import flash.text.engine.TextLine;
	import flashx.undo.UndoManager;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.OverflowPolicy;
	import flashx.textLayout.edit.SelectionManager;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	/*
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import fl.text.TLFTextField;
	import com.learning.atoz.storycreation.view.components.callout.TextTool;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.conversion.ConversionType;
	import flash.display.Stage;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	import com.learning.atoz.storycreation.view.components.SwfCHRComponent;
	import com.learning.atoz.storycreation.view.components.SwfComponent;
	import com.learning.atoz.storycreation.view.components.SwfOBJComponent;
	import flash.geom.Point;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flashx.textLayout.edit.EditManager;
	import flash.text.engine.TextLine;
	import flashx.undo.UndoManager;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.OverflowPolicy;
	import flashx.textLayout.edit.SelectionManager;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	*/
	
	
	public class CalloutTextView extends Sprite
	{
		private var viewMode:String="TLFEDIT"; //"DRAG";//"EDIT"//"VIEW"  
		private var editor:TLFTextField;
		private var editorTool:TextTool;
		//public var editorView:TextEditor;		
		private var viewerClip:Sprite;		
		private var viewerMask:Sprite;
		public var _w:int=250;
		public var _h:int=50;
		
		private var BtnDrag:Button;
		private var BtnEdit:Button;
		private var BtnView:Button;
		
		private var dragger:BtnDragger;
		private var resizer:BtnResizer;
		private var remover:BtnDeleteCallout;
		
		private var curpos:Object={x:10,y:10};
		
		private var _textFlow:TextFlow;
		private var controller:ContainerController;
		private var tlfmarkup:String;
		private var calloutBg:MovieClip;
		private var w:int=0;
		private var h:int=0;
		public var calloutType:String="";//"Callout1_1"; //"Callout1_2";//  //"Callout1_3";//		
		private var swfBgLoader:Loader;
		public var _data:Object;
		
		public function CalloutTextView(__data:Object)
		{
			_data=__data;	
			calloutType=_data.controltype;			
			_w=_data.width;
			_h=_data.height;
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		private function OnInit(evt:Event)
		{
			//-----------------------------------------------------------				
			trace("CalloutTextView=>OnInit");
											
			
			viewerClip=new Sprite();
			viewerClip.name="viewerClip";
			viewerClip.x=0;
			viewerClip.y=0;
			
			
			viewerMask=new Sprite();
			viewerMask.name="viewerMask";
			viewerMask.x=0;
			viewerMask.y=0;
			
			_w=_data.width;
			_h=_data.height;
			
			controller=new ContainerController(viewerClip);		
			controller.setCompositionSize(_w,_h);
			controller.columnCount=1;
			var cw:Number=(_w-35);//(_w-50);
			controller.columnWidth=(cw>1)?cw:1;//10 pixel padding left +right 5 pixel textfield control border			
			controller.paddingLeft=15;
			controller.paddingRight=15;
			controller.paddingTop=10;
			controller.paddingBottom=10;
			
			controller.verticalScrollPolicy = ScrollPolicy.OFF
			controller.horizontalScrollPolicy =ScrollPolicy.OFF ;
			
			var config:Configuration = Configuration(TextFlow.defaultConfiguration).clone();
			config.overflowPolicy = OverflowPolicy.FIT_DESCENDERS; 
			
			
			
			_textFlow=new TextFlow(config);
			
			var xmlobj:XML=new XML(_data.text);
			_textFlow=TextConverter.importToFlow(xmlobj, TextConverter.TEXT_LAYOUT_FORMAT);
			//_textFlow.fontFamily="Arial";
			//_textFlow.fontSize=14;
			_textFlow.flowComposer.addController(controller);
			_textFlow.interactionManager = new EditManager(new UndoManager());
			var cw2:Number=(_w-35);//(_w-40);
			controller.columnWidth=(cw2>1)?cw2:1;
								
			controller.setCompositionSize(_w,_h);
			_textFlow.flowComposer.updateAllControllers();
			
						
			
			editorTool=new TextTool();
			editorTool.name="TextTool";
			//editorTool.setTarget(editor);
			editorTool.setTextFlow(_textFlow);
			editorTool.x=0;
			editorTool.y=0;
			//this.addChild(editorTool);
			editorTool.addEventListener("DELETE_CALLOUT_FROM_TEXT_TOOL",OnDeleteCallout);
			editorTool.addEventListener("TEXTFORMAT_COMPLETE_CALLOUT_FROM_TEXT_TOOL",OnTextFormatChanged);
			
			
			dragger=new BtnDragger();
			dragger.name="BtnDragger";
			
			resizer=new BtnResizer();
			resizer.name="BtnResizer";
			
			remover=new BtnDeleteCallout();
			remover.name="BtnDeleteCallout";			
			remover.addEventListener(MouseEvent.CLICK,OnDelete);
			remover.buttonMode=true;
			remover.visible=false;
			
			
			updateCalloutSkin();
							
			
			
			
			//this.stage.addEventListener(MouseEvent.MOUSE_DOWN,OnStageDown);
			this.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,OnStageUp);
			
			
		}
		
		private function OnTextFormatChanged(evt:Event)
		{
			dispatchEvent(new ObjectEvent("TRANSFORM_COMPLETE_CALLOUT_TEXT",_data,false,true));
		}
		
		private function OnDeleteCallout(evt:Event)
		{
			dispatchEvent(new ObjectEvent("DELETE_CALLOUT_TEXT",_data,false,true));
		}
		
		
		private function OnDelete(evt:MouseEvent):void
		{
			trace("CalloutTextView=>OnDelete");
			//this.removeEventListener(MouseEvent.MOUSE_DOWN,OnStageDown);
			//this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnStageUp);
			
			dispatchEvent(new ObjectEvent("DELETE_CALLOUT_TEXT",_data,false,true));
		}
		
		private function OnMouseDown(evt:MouseEvent)
		{
			//currentName=data.uniqid;
			//trace("CalloutTextView->OnStageDown=>"+evt.target+","+evt.target.name+",this.name="+this.name);
			if(evt.target is TextLine || (evt.target is Sprite && evt.target.name=="viewerClip"))//evt.target is Sprite && //evt.target.name=="calloutskinbg"
			{	
				changeView("TLFEDIT");//EDIT
				dispatchEvent(new ObjectEvent("SHOW_TEXTTOOL_FROMCALLOUTTEXT",{target:this.name},false,true));
			}
			else if(evt.target.name=="calloutskinbg")
			{				
				changeView("TLFEDIT");//EDIT
				dispatchEvent(new ObjectEvent("SHOW_TEXTTOOL_FROMCALLOUTTEXT",{target:this.name},false,true));
			}			
			else if(evt.target is Stage)
			{
				//changeView("VIEW");
			}
			
		}
		
		private function OnStageUp(evt:MouseEvent)
		{			
			//trace("CalloutTextView->OnStageUp=>"+evt.target+","+evt.target.name);
			
			if(evt.target is stageWhiteBG)
			{
				changeView("VIEW");
			}
			else if(evt.target is SwfBGComponent)
			{
				changeView("VIEW");
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);			
			}
			else if (evt.target is SwfCHRComponent)//Sprite
			{	
				changeView("VIEW");
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
			}
			else if (evt.target is SwfOBJComponent)//Sprite
			{			
				changeView("VIEW");
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
			}
			else if (evt.target is SwfComponent)//Sprite
			{	
				changeView("VIEW");
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);			
			}	
			else if (evt.target is Stage)//Sprite
			{	
				changeView("VIEW");
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);			
			}
			else if (evt.target is MovieClip)//Sprite
			{
				
				if(evt.target.name=="scpContentBG")
				{
					changeView("VIEW");
					//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
					
				}
				else if(evt.target.name=="BtnDeletePage")
				{
					changeView("VIEW");
					//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
					
				}
				else if(evt.target.name=="fcclip1" || evt.target.name=="fcclip2")
				{	
					changeView("VIEW");
					//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
					
				}
			}	
			else if (evt.target is SimpleButton)//Sprite
			{							
				if(evt.target.name=="pageThumbHitArea")
				{
					changeView("VIEW");
					//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
					
				}				
			}	
			
		}
		
		private function updateCalloutSkin()
		{
			trace("updateCalloutSkin=>"+_data.skin);
			calloutBg=new MovieClip();
			calloutBg.name="bg";
			//-----------------------------
			loadSWF(_data.skin);
			
			
		}
		
		private function loadSWF(url:String)
		{
			swfBgLoader=new Loader();				
			swfBgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onSWFComplete);
			swfBgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onSWFProgress);
			swfBgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			
			var _request:URLRequest= new URLRequest();
			//_request.url = "assets/callout/skins/"+url;				
			_request.url = url;
			//if(ApplicationConstants.SAMEDOMAIN=="YES")
			//{
				swfBgLoader.load(_request);
			/*}
			else
			{
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				loaderContext.securityDomain = SecurityDomain.currentDomain;// Sets the security context to resolve Error # 2121
				swfLoader.load(_request,loaderContext);				
			}*/
		}
		
		private function onIOError(evt:IOErrorEvent):void
		{
			trace("onIOError:");
		}
		
		private function onSWFComplete(event:Event):void
		{
			
			calloutBg.name="bg";
			calloutBg=event.target.content;
			
			if(_data.controltype=="Callout1_1" || _data.controltype=="Callout2_1" || _data.controltype=="Callout3_1")			
			{
				var sbgobj:*=calloutBg.getChildByName("calloutskinbg");	
				if(sbgobj!=null)
				{					
					sbgobj.width=_w;
					sbgobj.height=_h;
				}
			}
			else
			{
				var sbgobj2:*=calloutBg.getChildByName("BG_DIRPOS");				
				if(sbgobj2!=null)
				{					
					sbgobj2.width=_w;
					sbgobj2.height=_h;					
					
					var dirobj:*=calloutBg.getChildByName("direction");
					if(dirobj!=null)
					{
						var dirposobj:*=sbgobj2.getChildByName("directionPos");											
						if(dirposobj!=null)
						{			
							dirposobj.visible=false;
							var pt:Point=new Point(dirposobj.x,dirposobj.y);
							pt=sbgobj2.localToGlobal(pt);
							pt=calloutBg.globalToLocal(pt);
							dirobj.x=pt.x;
							dirobj.y=pt.y;
						}
					}
					
				}
			}
							
			if(Number(_data.isnew)==1)
			{
				changeView("TLFEDIT");//EDIT
			}
			else
			{
				changeView("VIEW");//EDIT
			}
		}
		
		private function onSWFProgress(event:ProgressEvent):void
		{
			var percent:int = event.bytesLoaded / event.bytesTotal * 100;
			//trace("onSWFProgress=>"+percent);
		}
		
		
		public function updateView()
		{
			if(viewMode=="TLFEDIT")
			{
				var bgobj:*=this.getChildByName("bg");				
				if(bgobj==null){this.addChildAt(calloutBg,0); }
				
				dragger.addEventListener(MouseEvent.MOUSE_DOWN,OnDragDown);
				dragger.buttonMode=true;
				dragger.visible=true;
				dragger.x=0;
				dragger.y=0;
				
								
				var dobj:*=this.getChildByName("BtnDragger");				
				if(dobj==null){	this.addChild(dragger); }
				
				var rsobj:*=this.getChildByName("BtnResizer");				
				if(rsobj==null)
				{
					this.addChild(resizer);
					resizer.x=_w+resizer.width;
					resizer.y=_h-resizer.height;
					
					resizer.addEventListener(MouseEvent.MOUSE_DOWN,OnResizeDown);
					resizer.buttonMode=true;
				}
				
				var dobj2:*=this.getChildByName("BtnDeleteCallout");				
				if(dobj2==null)
				{
					this.addChild(remover);
					remover.x=_w;
					remover.y=0;
				}
				
				var vobj:*=this.getChildByName("viewerClip");				
				if(vobj==null){	this.addChildAt(viewerClip,(this.numChildren-1));	}
				updateViewerClip();
				
				if(ApplicationConstants.USER_TYPE=="FLUENT")
				{
					var ttobj:*=this.getChildByName("TextTool");				
					if(ttobj==null){this.addChildAt(editorTool,(this.numChildren-1));	}
				}
				else if(ApplicationConstants.USER_TYPE=="EMERGENT")
				{
					
				}
				
				
				
				if(_textFlow.interactionManager==null)
				{
					_textFlow.interactionManager=new EditManager(new UndoManager());
				}
				
				if(_textFlow.interactionManager!=null)
				{
					(_textFlow.interactionManager as EditManager).setFocus();
				}
				_textFlow.flowComposer.updateAllControllers();
				
				
				
			}
			else if(viewMode=="VIEW")
			{			
				//-------------------
				var bgobj2:*=this.getChildByName("bg");				
				if(bgobj2==null){this.addChildAt(calloutBg,0); }
							
				
				var rsobj2:*=this.getChildByName("BtnResizer");				
				if(rsobj2==null)
				{
					this.addChild(resizer);
					resizer.x=_w+resizer.width;
					resizer.y=_h-resizer.height;
					
					resizer.addEventListener(MouseEvent.MOUSE_DOWN,OnResizeDown);
					resizer.buttonMode=true;
				}
								
				
				var vobj2:*=this.getChildByName("viewerClip");				
				if(vobj2==null){	this.addChildAt(viewerClip,(this.numChildren-1));	}
				
				//-------------------
				
				var dobj3:*=this.getChildByName("BtnDragger");				
				if(dobj3!=null){	this.removeChild(dobj3); }
				
				var robj2:*=this.getChildByName("BtnResizer");				
				if(robj2!=null){	this.removeChild(robj2); }
				
				var deobj2:*=this.getChildByName("BtnDeleteCallout");				
				if(deobj2!=null){	this.removeChild(deobj2); }
								
				dragger.removeEventListener(MouseEvent.MOUSE_DOWN,OnDragDown);
				dragger.buttonMode=false;
				dragger.visible=false;												
				
				var ttobj2:*=this.getChildByName("TextTool");				
				if(ttobj2!=null){	this.removeChild(ttobj2);	}
				updateViewerClip();
								
								
				_textFlow.interactionManager=null;
				_textFlow.flowComposer.updateAllControllers();
				
				
				//-----------
				
			}
			
		}
		
		private function OnResizeDown(evt:MouseEvent):void
		{
			var ttobj:*=this.getChildByName("TextTool");				
			if(ttobj!=null){ttobj.visible=false;}
				
			var rsobj:*=this.getChildByName("BtnResizer");				
			if(rsobj!=null)
			{
				rsobj.buttonMode=true;
				rsobj.startDrag();
			}
		
			this.addEventListener(Event.ENTER_FRAME,OnResizerEnterFrame);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnResizerMouseUp);
		}
		
		
		private function OnResizerEnterFrame(evt:Event):void
		{
			var rsobj:*=this.getChildByName("BtnResizer");		
		
			if(rsobj!=null)
			{
					if(calloutBg!=null)
					{										
						w=((rsobj.x-rsobj.width)-calloutBg.x);
						h=((rsobj.y+rsobj.height)-calloutBg.y);				
						//_w=w;
						//_h=h;
						
						if(_data.controltype=="Callout1_1" || _data.controltype=="Callout2_1" || _data.controltype=="Callout3_1")			
						{							
							var sbgobj:*=calloutBg.getChildByName("calloutskinbg");				
						
							if(sbgobj!=null)
							{			
								if(w>20 && h>27)
								{										
									_w=w;
									_h=h;
									sbgobj.width=_w;
									sbgobj.height=_h;
									
									_data.width=_w;
									_data.height=_h;
									//calloutBg.width=_w;
									//calloutBg.height=_h;
								}
								else if(w<20)
								{
									this.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
								}
								else if(h<27)
								{
									this.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
								}
							}
							
						}
						else
						{							
							var sbgobj3:*=calloutBg.getChildByName("BG_DIRPOS");				
							if(sbgobj3!=null)
							{	
								var dirobj3:*=calloutBg.getChildByName("direction");
								if(dirobj3!=null)
								{
									if(w>(dirobj3.width+25) && h>27)
									{
										_w=w;
										_h=h;
										sbgobj3.width=_w;
										sbgobj3.height=_h;					
										
										_data.width=_w;
										_data.height=_h;									
									
										
										var dirposobj3:*=sbgobj3.getChildByName("directionPos");											
										if(dirposobj3!=null)
										{													
											dirposobj3.visible=false;
											var pt:Point=new Point(dirposobj3.x,dirposobj3.y);
											pt=sbgobj3.localToGlobal(pt);
											pt=calloutBg.globalToLocal(pt);
											dirobj3.x=pt.x;
											dirobj3.y=pt.y;
											
										}
									}
									else if(w<(dirobj3.width+25))
									{
										this.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
									}
									else if(h<27)
									{
										this.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
									}
								}
								
							}
						}
						
						var dobj4:*=this.getChildByName("BtnDeleteCallout");				
						if(dobj4!=null)
						{							
							dobj4.x=_w;//(calloutBg.x+calloutBg.width);
							dobj4.y=0;
						}
						
					}
					
					
					
					//trace("w="+_w+",h="+_h+",viewerClip.width="+viewerClip.width);
					updateViewerClip();
					var cw:Number=(_w-25);//(_w-10);//(_w-40);
					controller.columnWidth=(cw>1)?cw:1;				
					controller.setCompositionSize(_w,_h);
					_textFlow.flowComposer.updateAllControllers();
					
				}
				
				_data.width=_w;
				_data.height=_h;
			
		}
		
		private function OnResizerMouseUp(evt:MouseEvent):void
		{			
			
			var ttobj:*=this.getChildByName("TextTool");				
			if(ttobj!=null){ttobj.visible=true;}			
			
					
			var rsobj:*=this.getChildByName("BtnResizer");				
			if(rsobj!=null)
			{
				//rsobj.buttonMode=false;
				rsobj.stopDrag();
				rsobj.x=_w+rsobj.width;
				rsobj.y=_h-rsobj.height;
				
			}
			
			this.removeEventListener(Event.ENTER_FRAME,OnResizerEnterFrame);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnResizerMouseUp);
			
			var dobj4:*=this.getChildByName("BtnDeleteCallout");				
			if(dobj4!=null)
			{				
				dobj4.x=_w;
				dobj4.y=0;
			}
			
			dispatchEvent(new ObjectEvent("TRANSFORM_COMPLETE_CALLOUT_TEXT",_data,false,true));
		}
		
		private function OnDragDown(evt:MouseEvent):void
		{
			//dispatchEvent(new ObjectEvent("CLOSE_TEXTTOOL_FROM_CALLOUT_TEXT",null,false,true));
		
			var ttobj:*=this.getChildByName("TextTool");				
			if(ttobj!=null){ttobj.visible=false;}
			
			curpos.x=this.x;
			curpos.y=this.y;
			this.startDrag();
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnDragMouseUp);
		}
		
		private function OnDragMouseUp(evt:MouseEvent):void
		{
			var ttobj:*=this.getChildByName("TextTool");				
			if(ttobj!=null){ttobj.visible=true;}
			
			this.stopDrag();
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnDragMouseUp);
			
			if(this.x<0 || this.y<0) // || this.x>=_data.stagew || this.y>=_data.stageh)
			{
				this.x=curpos.x;
				this.y=curpos.y;
			}
			
			dispatchEvent(new ObjectEvent("TRANSFORM_COMPLETE_CALLOUT_TEXT",_data,false,true));			
			
		}
		
		
		
		public function setTLFText(ftext:String):void
		{
			var xmlobj:XML=new XML(ftext);
			_textFlow=TextConverter.importToFlow(xmlobj, TextConverter.TEXT_LAYOUT_FORMAT);
			//controller.columnWidth=_w-40;					
			//controller.setCompositionSize(_w,_h);
			_textFlow.flowComposer.updateAllControllers();
		}
		
				
		public function getTLFText():String
		{
			var flowText:String=TextConverter.export(_textFlow,TextConverter.TEXT_LAYOUT_FORMAT,ConversionType.STRING_TYPE) as String;
			return flowText;
		}
					
					
		public function changeView(_viewmode:String)
		{
			trace("changeView=>"+_viewmode);
			viewMode=_viewmode;
			/*if(viewMode=="VIEW")
			{
				
			}
			else
			{
				var ftext:String=getTLFText();
				if(ftext.indexOf("Enter your Text")>0)
				{
					var s2:String='<TextFlow columnCount="inherit" columnGap="inherit" columnWidth="inherit" lineBreak="inherit" paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" paddingTop="inherit" verticalAlign="inherit" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008"><p fontFamily="Arial" fontSize="16" paragraphSpaceAfter="0" paragraphSpaceBefore="0" textDecoration="none"><span></span></p></TextFlow>';
					setTLFText(s2);
				}
			}*/
			updateView();
			if(viewMode=="VIEW")
			{
				dispatchEvent(new ObjectEvent("CLOSE_TEXTTOOL_FROM_CALLOUT_TEXT",null,false,true));
			}
		}
		
		private function updateViewerClip()
		{			
			viewerClip.graphics.clear();
			viewerClip.graphics.lineStyle(1,0xff0000,0.0);
			viewerClip.graphics.beginFill(0x00ff00,0.0);
			viewerClip.graphics.drawRect(0,0,_w,_h);
			viewerClip.graphics.endFill();
		}

		
		private function updateviewerMask()
		{
			viewerMask.graphics.clear();
			viewerMask.graphics.lineStyle(1,0xff0000,0.0);
			viewerMask.graphics.beginFill(0x00ff00,0.0);
			viewerMask.graphics.drawRect(0,0,_w,_h);
			viewerMask.graphics.endFill();
		}

	}
	
}
