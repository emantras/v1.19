package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.alert.AlertComponent;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.UID;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.ImageToolBox;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	import com.learning.atoz.storycreation.view.components.SwfCHRComponent;
	import com.learning.atoz.storycreation.view.components.SwfComponent;
	import com.learning.atoz.storycreation.view.components.SwfOBJComponent;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import com.learning.atoz.storycreation.view.components.callout.CalloutTextView;
	import com.learning.atoz.transform.CustomRotationControl;
	import com.learning.atoz.transform.TransformTool;
	import com.learning.atoz.storycreation.view.components.BtnDragger;
	import com.learning.atoz.storycreation.view.components.MaskTransform;
	import com.learning.atoz.storycreation.view.components.pagenavigation.FrontCoverThumbnail;
	
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;	
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.conversion.ConversionType;
	import flash.utils.getTimer;
	import flash.display.Sprite;
	
	
	/*
	import com.learning.atoz.alert.AlertComponent;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.UID;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.view.components.ImageToolBox;
	import com.learning.atoz.storycreation.view.components.SwfBGComponent;
	import com.learning.atoz.storycreation.view.components.SwfCHRComponent;
	import com.learning.atoz.storycreation.view.components.SwfComponent;
	import com.learning.atoz.storycreation.view.components.SwfOBJComponent;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import com.learning.atoz.storycreation.view.components.callout.CalloutTextView;
	import com.learning.atoz.transform.CustomRotationControl;
	import com.learning.atoz.transform.TransformTool;
	import com.learning.atoz.storycreation.view.components.BtnDragger;
	import com.learning.atoz.storycreation.view.components.MaskTransform;
	import com.learning.atoz.storycreation.view.components.pagenavigation.FrontCoverThumbnail;
	
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;	
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.conversion.ConversionType;
	import flash.utils.getTimer;
	import flash.display.Sprite;
	*/


	/*
		CanvasMediator is used to load and handle all canvas related events
	*/
	
	public class CanvasContentMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CanvasContentMediator";						
		
		private var chrCnt:int=0;
		private var objCnt:int=0;
		public var defaultTool:TransformTool;
		public var currTool:TransformTool;	
		public var curChrObjSelected:Object;
		private var imageToolBox:ImageToolBox;
		private var curTarget:*=null;
		private var curCallTextObject:*=null;
		private var maxLeft:Number=245;
		private var maxTop:Number=60;
		private var maxRight:Number=825;
		private var maxBottom:Number=600;
		private var maskTransform:MaskTransform;		
		
		private var rootobj:*;
		private var stageleft:Number=245;
		private var stagetop:Number=60;
		private var stageright:Number=825;
		private var stagebottom:Number=640;
		
		private var minVisiblePercent:Number=20;
		private var maxXoffset:Number=0;		
		private var maxYoffset:Number=0;
		//-----------------------------------------------------		
		public function CanvasContentMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			
			imageToolBox=new ImageToolBox();
			imageToolBox.name="imageToolBox";
			//canvasContent.parent.addChild(imageToolBox);
			MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME)).mainDisplay.addChild(imageToolBox);
			imageToolBox.visible=false;
			imageToolBox.BtnDelete.addEventListener(MouseEvent.CLICK,OnDeleteChrObj);
			
			imageToolBox.BtnBringFront.addEventListener(MouseEvent.CLICK,OnBringFront);
			imageToolBox.BtnSendBack.addEventListener(MouseEvent.CLICK,OnSendBack);
			imageToolBox.BtnFlip.addEventListener(MouseEvent.CLICK,OnFlip);
			
			InitTransform();
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
			return [ApplicationConstants.ADD_CHARACTER,
				ApplicationConstants.ADD_OBJECT,
				ApplicationConstants.RESTORE_CHARACTER,
				ApplicationConstants.RESTORE_OBJECT,
				ApplicationConstants.CLOSE_IMAGE_TOOLBOX,
				ApplicationConstants.ADD_CALLOUTTEXT,				
				ApplicationConstants.RESTORE_CALLOUT_TEXT,
				ApplicationConstants.COPY_PAGE,
				ApplicationConstants.PASTE_PAGE,
				ApplicationConstants.RESTORE_DATA];
		}
		//-----------------------------------------------------		
		
		
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{	
				case ApplicationConstants.ADD_CHARACTER:
					var chrdata:Object=(notification.getBody() as Object);
					AddCharacter(chrdata);
					break;
				
				case ApplicationConstants.ADD_OBJECT:
					var objdata:Object=(notification.getBody() as Object);
					AddObject(objdata);
					break;
				case ApplicationConstants.RESTORE_CHARACTER:
					var arrdata:Array=(notification.getBody() as Array);
					RestoreCharacter(arrdata);
					break;
				
				case ApplicationConstants.RESTORE_OBJECT:
					var arrdata2:Array=(notification.getBody() as Array);
					RestoreObject(arrdata2);
					break;
				
				case ApplicationConstants.CLOSE_IMAGE_TOOLBOX:
					
					closeImagePopup();
					break;
				
				case ApplicationConstants.ADD_CALLOUTTEXT:	
					var calloutobj:Object=(notification.getBody() as Object);
					AddCalloutText(calloutobj);
					break;
				
				
				
				case ApplicationConstants.RESTORE_CALLOUT_TEXT:		
					var arrdata3:Array=(notification.getBody() as Array);
					RestoreCalloutText(arrdata3);
					break;
				
				case ApplicationConstants.COPY_PAGE:					
					var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					if(dp.currentPage>=0)
					{
						dp.copyPage(dp.currentPage);
					}
					break;
				
				case ApplicationConstants.PASTE_PAGE:
					var dp2:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
					if(dp2.currentPage>=0)
					{
						dp2.pastePage(dp2.currentPage);
					}
					break;
				case ApplicationConstants.RESTORE_DATA:
					var arrdata4:Array=(notification.getBody() as Array);
					RestoreData(arrdata4);
					break;
				
			}
		}
		//-----------------------------------------------------		
		/*loadingBGClip
		stageContent
		maskClip
		stagebgimage*/			
		
		//-----------------------------------------------------
		private function InitTransform():void
		{
			//rootobj=getParent(canvasContent);
			canvasContent.addEventListener(MouseEvent.MOUSE_DOWN,OnStageClick);	
			
			MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME)).mainDisplay.stage.addEventListener(MouseEvent.CLICK,OnStageClickUp,true,0,true);
			//----------------------------------------------------------
			//Transform
			//----------------------------------------------------------
			// default tool
			defaultTool = new TransformTool();			
			defaultTool.constrainScale=true;
			canvasContent.stage.addChild(defaultTool);
			
			maskTransform=new MaskTransform();
			canvasContent.stage.addChild(maskTransform);
			defaultTool.mask=maskTransform;
			maskTransform.x=245;
			maskTransform.y=60;
			
		
					
			
			defaultTool.addControl(new CustomRotationControl());
			
			defaultTool.raiseNewTargets = false;
			defaultTool.moveNewTargets = false;
			defaultTool.moveUnderObjects = false;
			
			defaultTool.registrationEnabled = false;//true;
			defaultTool.rememberRegistration = false;//true;
			
			defaultTool.rotationEnabled = false;
			defaultTool.constrainRotation = true;
			defaultTool.constrainRotationAngle = 90/4;
			
			defaultTool.constrainScale = true;
									
			defaultTool.maxScaleX = 7;
			defaultTool.maxScaleY = 7;
			
			defaultTool.skewEnabled = false;
			
			//defaultTool.needsSoftKeyboard=true;
						
			defaultTool.setSkin(TransformTool.SCALE_TOP_LEFT, new ScaleRect());
			defaultTool.setSkin(TransformTool.SCALE_TOP_RIGHT, new ScaleRect());
			defaultTool.setSkin(TransformTool.SCALE_BOTTOM_RIGHT, new ScaleRect());
			defaultTool.setSkin(TransformTool.SCALE_BOTTOM_LEFT, new ScaleRect());
			defaultTool.setSkin(TransformTool.SCALE_TOP, new BlankRect());
			defaultTool.setSkin(TransformTool.SCALE_RIGHT, new BlankRect());
			defaultTool.setSkin(TransformTool.SCALE_BOTTOM, new BlankRect());
			defaultTool.setSkin(TransformTool.SCALE_LEFT, new BlankRect());			
			
						
			//defaultTool.addEventListener(TransformTool.TRANSFORM_TARGET,OnTransformToolTarget);
			defaultTool.addEventListener(TransformTool.NEW_TARGET,OnTransformNewTarget);
			//defaultTool.addEventListener(TransformTool.CONTROL_TRANSFORM_TOOL,function(evt:*){trace("CONTROL_TRANSFORM_TOOL="+evt)});
			//temp
			defaultTool.addEventListener(TransformTool.CONTROL_DOWN,OnTransformToolDown);
			
			
			defaultTool.addEventListener(TransformTool.CONTROL_MOVE,OnTransformToolMove);
			defaultTool.addEventListener(TransformTool.CONTROL_UP,OnTransformToolUp);
			
			
			defaultTool.addEventListener(TransformTool.CONTROL_PREFERENCE,OnControlPreferenceTransformTool);
			
			
			
			currTool = defaultTool;
			
			
			var scm:StoryCreationMediator=StoryCreationMediator(facade.retrieveMediator(StoryCreationMediator.NAME));
			maxLeft=scm.app.stageBG.x;
			maxTop=scm.app.stageBG.y;
			maxRight=scm.app.stageBG.x+scm.app.stageBG.width;
			maxBottom=scm.app.stageBG.y+scm.app.stageBG.height;
			
			//----------------------------------------------------------
		
		}
		
		private function OnControlPreferenceTransformTool(evt:*):void
		{
			trace("OnControlPreferenceTransformTool");
		}
				
				/*
				public static const SCALE_TOP_LEFT:String = "scaleTopLeft";
		public static const SCALE_TOP:String = "scaleTop";
		public static const SCALE_TOP_RIGHT:String = "scaleTopRight";
		public static const SCALE_RIGHT:String = "scaleRight";
		public static const SCALE_BOTTOM_RIGHT:String = "scaleBottomRight";
		public static const SCALE_BOTTOM:String = "scaleBottom";
		public static const SCALE_BOTTOM_LEFT:String = "scaleBottomLeft";
		public static const SCALE_LEFT:String = "scaleLeft";
		public static const ROTATION_TOP_LEFT:String = "rotationTopLeft";
		public static const ROTATION_TOP_RIGHT:String = "rotationTopRight";
		public static const ROTATION_BOTTOM_RIGHT:String = "rotationBottomRight";
		public static const ROTATION_BOTTOM_LEFT:String = "rotationBottomLeft";
				*/
				
		private function OnTransformNewTarget(evt:*):void
		{
			trace("NEW_TARGET"+",target="+evt.target+",target.target="+evt.target.target);
			
			if(evt.target.target is SwfCHRComponent)
			{
				curTarget=evt.target.target;
				curChrObjSelected={target:evt.target.target,xpos:evt.target.target.x,ypos:evt.target.target.y,width:evt.target.target.width,height:evt.target.target.height,rotation:evt.target.target.rotation};
				showImagePopup();
			}
			else if(evt.target.target is SwfOBJComponent)
			{
				curTarget=evt.target.target;
				curChrObjSelected={target:evt.target.target,xpos:evt.target.target.x,ypos:evt.target.target.y,width:evt.target.target.width,height:evt.target.target.height,rotation:evt.target.target.rotation};
				showImagePopup();
			}
			else// if(evt.target.target==null)
			{
				//curTarget=null;
				closeImagePopup();
			}
			
		}
		
		private function OnTransformToolTarget(evt:*):void
		{
			//trace("TRANSFORM_TARGET");
			//showImagePopup();
		}

		
		private function OnTransformToolDown(evt:*):void
		{						
			maxXoffset=(currTool.target.width*minVisiblePercent)/100;
			maxYoffset=(currTool.target.height*minVisiblePercent)/100;
			//trace("CONTROL_DOWN");			
		}
				
		
		private function OnTransformToolMove(evt:*):void
		{
			imageToolBox.visible=false;
			
			/*trace("OnTransformToolMove=>currentMode=>"+currTool.currentMode+",scalex=>"+currTool.target.scaleX+",scaley=>"+currTool.target.scaleY);
			
				
			if(currTool.currentMode=="SCALEXY")
			{
				if(currTool.target.scaleX<0.2 || currTool.target.scaleY<0.2)
				{
					currTool.target = null;
				}
			}*/
			
			/*if(currTool.target.scaleX<0)
			{
				if((currTool.boundsLeft.x-stageleft)<maxXoffset)
				{
					currTool.target = null;
				}
				
				if((currTool.boundsRight.x-stageright)>-maxXoffset)
				{
					currTool.target = null;
				}
			}
			else if(currTool.target.scaleX>0)
			{
				if((currTool.boundsRight.x-stageleft)<maxXoffset)
				{
					currTool.target = null;
				}
				
				if((currTool.boundsLeft.x-stageright)>-maxXoffset)
				{
					currTool.target = null;
				}
			}
			
			
			
			if((currTool.boundsBottom.y-stagetop)<maxYoffset)
			{
				currTool.target = null;
			}
			
			
			
			if((currTool.boundsTop.y-stagebottom)>-maxYoffset)
			{
				currTool.target = null;
			}*/
			
			
			
		}
		
		private function getParent(thisptr:*):Object
		{
			var parentobj:Object=null;
			
			for(var dv:int=0;dv<10;dv++)
			{
				if(thisptr!=null)
				{
					//trace("getParent1=>"+thisptr+","+thisptr.name);
					if(thisptr.parent is Stage)
					{
						parentobj=thisptr;
						break;
					}
					else
					{
						thisptr=thisptr.parent;
					}
				}
			}	
			
			return parentobj;
		}
		
		private function OnTransformToolUp(evt:*):void
		{
			//trace("OnTransformUp1=>"+currTool.target+",currentMode=>"+currTool.currentMode);			
			//Save current Target Transform information			
			if (currTool.target is SwfCHRComponent)//Sprite
			{							
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				
				(currTool.target as SwfCHRComponent).data.xpos=(currTool.target as SwfCHRComponent).x;
				(currTool.target as SwfCHRComponent).data.ypos=(currTool.target as SwfCHRComponent).y;
				
				(currTool.target as SwfCHRComponent).data.scalex=(currTool.target as SwfCHRComponent).scaleX;
				(currTool.target as SwfCHRComponent).data.scaley=(currTool.target as SwfCHRComponent).scaleY;

				if(currTool.currentMode=="SCALEXY")
				{
					var rot1:Number=(currTool.target as SwfCHRComponent).rotation;
					
					(currTool.target as SwfCHRComponent).rotation=0;

					(currTool.target as SwfCHRComponent).data.width=(currTool.target as SwfCHRComponent).width;
					(currTool.target as SwfCHRComponent).data.height=(currTool.target as SwfCHRComponent).height;

					(currTool.target as SwfCHRComponent).rotation=rot1;
					
					(currTool.target as SwfCHRComponent).data.rotation=(currTool.target as SwfCHRComponent).rotation;
					
					//MainDisplayMediator maindisp=MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME));
					//maindisp.mainDisplay.m_log.text="OnTransformUp=>SCALEXY=>scalex:"+(currTool.target as SwfOBJComponent).scaleX+",scaley:"+(currTool.target as SwfOBJComponent).scaleY+",rotation:"+(currTool.target as SwfOBJComponent).rotation;
					//trace("OnTransformUp=>SCALEXY=>scalex:"+(currTool.target as SwfCHRComponent).scaleX+",scaley:"+(currTool.target as SwfCHRComponent).scaleY+",rotation:"+(currTool.target as SwfCHRComponent).rotation);
					//trace("OnTransformUp=>SCALEXY=>w:"+(currTool.target as SwfCHRComponent).width+",h:"+(currTool.target as SwfCHRComponent).height+",rotation:"+(currTool.target as SwfCHRComponent).rotation);
					//trace("OnTransformUp=>SCALEXY=>dataw:"+(currTool.target as SwfCHRComponent).data.width+",datah:"+(currTool.target as SwfCHRComponent).data.height+",datarotation:"+(currTool.target as SwfCHRComponent).data.rotation);
					
					
				}
				else if(currTool.currentMode=="ROTATE")
				{
					(currTool.target as SwfCHRComponent).data.rotation=(currTool.target as SwfCHRComponent).rotation;
					//MainDisplayMediator maindisp=MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME));
					//maindisp.mainDisplay.m_log.text="OnTransformUp=>ROTATE=>scalex:"+(currTool.target as SwfOBJComponent).scaleX+",scaley:"+(currTool.target as SwfOBJComponent).scaleY+",rotation:"+(currTool.target as SwfOBJComponent).rotation;
					//trace("OnTransformUp3.3=>scalex:"+(currTool.target as SwfCHRComponent).scaleX+",scaley:"+(currTool.target as SwfCHRComponent).scaleY+",rotation:"+(currTool.target as SwfCHRComponent).rotation);
					//trace("OnTransformUp3=>rotation:"+(currTool.target as SwfCHRComponent).rotation);
				}
				
				//-----------------------------------------------------
				//SaveBook Timer Start
				//-----------------------------------------------------
				facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
				//-----------------------------------------------------
				DataProxy(facade.retrieveProxy(DataProxy.NAME)).UpdateCharacter(dp.currentPage,(currTool.target as SwfCHRComponent).data);
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);				
				
			}
			else if (currTool.target is SwfOBJComponent)//Sprite
			{	
				
				var dp2:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				
						
				
								
					
				if(currTool.currentMode=="SCALEXY")
				{					
					
					//var rot2:Number=(currTool.target as SwfOBJComponent).rotation;
					
					//(currTool.target as SwfOBJComponent).rotation=0;
					
					(currTool.target as SwfOBJComponent).data.width=(currTool.target as SwfOBJComponent).width;
					(currTool.target as SwfOBJComponent).data.height=(currTool.target as SwfOBJComponent).height;
					
					(currTool.target as SwfOBJComponent).data.scalex=(currTool.target as SwfOBJComponent).scaleX;
					(currTool.target as SwfOBJComponent).data.scaley=(currTool.target as SwfOBJComponent).scaleY;
					
					//(currTool.target as SwfOBJComponent).rotation=rot2;
					
					(currTool.target as SwfOBJComponent).data.rotation=(currTool.target as SwfOBJComponent).rotation;
					
					

					//MainDisplayMediator maindisp=MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME));
					//maindisp.mainDisplay.m_log.text="OnTransformUp=>SCALEXY=>scalex:"+(currTool.target as SwfOBJComponent).scaleX+",scaley:"+(currTool.target as SwfOBJComponent).scaleY+",rotation:"+(currTool.target as SwfOBJComponent).rotation;					
					//trace("OnTransformUp=>SCALEXY=>scalex:"+(currTool.target as SwfOBJComponent).scaleX+",scaley:"+(currTool.target as SwfOBJComponent).scaleY+",rotation:"+(currTool.target as SwfOBJComponent).rotation);
					
					//trace("OnTransformUp2.4=>w:"+(currTool.target as SwfOBJComponent).width+",h:"+(currTool.target as SwfOBJComponent).height+",rotation:"+(currTool.target as SwfOBJComponent).rotation);
					//trace("OnTransformUp2.5=>dataw:"+(currTool.target as SwfOBJComponent).data.width+",datah:"+(currTool.target as SwfOBJComponent).data.height+",datarotation:"+(currTool.target as SwfOBJComponent).data.rotation);
				}
				else if(currTool.currentMode=="ROTATE")
				{
					(currTool.target as SwfOBJComponent).data.rotation=(currTool.target as SwfOBJComponent).rotation;


					//MainDisplayMediator maindisp=MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME));
					//maindisp.mainDisplay.m_log.text="OnTransformUp=>ROTATE=>scalex:"+(currTool.target as SwfOBJComponent).scaleX+",scaley:"+(currTool.target as SwfOBJComponent).scaleY+",rotation:"+(currTool.target as SwfOBJComponent).rotation;
					//trace("OnTransformUp3.3=>scalex:"+(currTool.target as SwfOBJComponent).scaleX+",scaley:"+(currTool.target as SwfOBJComponent).scaleY+",rotation:"+(currTool.target as SwfOBJComponent).rotation);
					//trace("OnTransformUp3.5=>dataw:"+(currTool.target as SwfOBJComponent).data.width+",datah:"+(currTool.target as SwfOBJComponent).data.height+",datarotation:"+(currTool.target as SwfOBJComponent).data.rotation);
					
				}			
				else if(currTool.currentMode=="MOVE")
				{
					(currTool.target as SwfOBJComponent).data.xpos=(currTool.target as SwfOBJComponent).x;
					(currTool.target as SwfOBJComponent).data.ypos=(currTool.target as SwfOBJComponent).y;
				}
				
				//MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME)).mainDisplay.m_log.text="OnTransformUp=>"+currTool.currentMode+"=>scalex:"+(currTool.target as SwfOBJComponent).scaleX+",scaley:"+(currTool.target as SwfOBJComponent).scaleY+",rotation:"+(currTool.target as SwfOBJComponent).rotation;
				
				//-----------------------------------------------------
				//SaveBook Timer Start
				//-----------------------------------------------------
				facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
				//-----------------------------------------------------
				
				DataProxy(facade.retrieveProxy(DataProxy.NAME)).UpdateObject(dp2.currentPage,(currTool.target as SwfOBJComponent).data);				
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
			}
			showImagePopup();
			//facade.sendNotification(ApplicationConstants.SHOW_IMAGE_TOOLBOX);
		}
		
		private function OnDeleteChrObj(evt:MouseEvent):void
		{			
			var ac:AlertComponent=new com.learning.atoz.alert.AlertComponent();
			ac.Target=MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME)).mainDisplay;	
			ac.MsgBoxType="YESNO";			
			ac.addEventListener("BtnYes",deleteYesConfirm);			
			ac.showAlert("Are you sure you want to delete?");
		}
		
		
		private function OnBringFront(evt:MouseEvent):void
		{
			if(curTarget!=null)
			{
				
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				if(dp.currentPage>=0)
				{	
					if(curTarget is SwfCHRComponent)
					{						
						for(var r:int=0;r<canvasContent.numChildren;r++)
						{
							if(canvasContent.getChildAt(r) is SwfCHRComponent)
							{
								if((canvasContent.getChildAt(r) as SwfCHRComponent).data.unqid==curTarget.data.unqid)
								{									
									if((r+1)<=(canvasContent.numChildren-1))
									{
										canvasContent.setChildIndex(curTarget,(r+1));
									}
									else
									{
										canvasContent.setChildIndex(curTarget,(canvasContent.numChildren-1));
									}
									break;
								}
							}
						}
					}
					else if(curTarget is SwfOBJComponent)
					{						
						for(var r2:int=0;r2<canvasContent.numChildren;r2++)
						{
							if(canvasContent.getChildAt(r2) is SwfOBJComponent)
							{
								if((canvasContent.getChildAt(r2) as SwfOBJComponent).data.unqid==curTarget.data.unqid)
								{
									if((r2+1)<=(canvasContent.numChildren-1))
									{
										canvasContent.setChildIndex(curTarget,(r2+1));
									}
									else
									{
										canvasContent.setChildIndex(curTarget,(canvasContent.numChildren-1));
									}
									break;
								}
							}
						}
					}
					
					
					//update reorder
					var datalist:Array=dp.getDataList(dp.currentPage);
					
					for(var dv:int=0;dv<datalist.length;dv++)
					{
						if(canvasContent!=null)
						{					
							var tcobj:*=canvasContent.getChildByName(datalist[dv].unqid);
							
							if(tcobj!=null)
							{
								var updobj:Object=datalist[dv];
								updobj.level=canvasContent.getChildIndex(tcobj);
								dp.UpdateData(dp.currentPage,updobj);
								
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
		}
		
		private function OnSendBack(evt:MouseEvent):void
		{	
				
			if(curTarget!=null)
			{				
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				if(dp.currentPage>=0)
				{	
					if(curTarget is SwfCHRComponent)
					{	
						for(var r:int=0;r<canvasContent.numChildren;r++)
						{
							if(canvasContent.getChildAt(r) is SwfCHRComponent)
							{
								if((canvasContent.getChildAt(r) as SwfCHRComponent).data.unqid==curTarget.data.unqid)
								{
									//trace("OnSendBack=>chr=>"+(r2-1));
									//should be >1 bcos stagecontetnmask at 0
									if((r-1)>=1)
									{
										canvasContent.setChildIndex(curTarget,(r-1));
									}
									
									break;
								}
							}
						}
					}
					else if(curTarget is SwfOBJComponent)
					{
						for(var r2:int=0;r2<canvasContent.numChildren;r2++)
						{
							if(canvasContent.getChildAt(r2) is SwfOBJComponent)
							{
								if((canvasContent.getChildAt(r2) as SwfOBJComponent).data.unqid==curTarget.data.unqid)
								{
									//trace("OnSendBack=>obj=>"+(r2-1)+"obj=>"+canvasContent.getChildAt(r2).name+",obj index=>"+canvasContent.getChildIndex(canvasContent.getChildAt(r2))+",r2="+r2+",parent.name="+canvasContent.getChildAt(r2).parent.name);
									//should be >1 bcos stagecontetnmask at 0
									if((r2-1)>=1)
									{
										canvasContent.setChildIndex(curTarget,(r2-1));
									}
									
									break;
								}
							}
						}
					}
					
					
					//update reorder
					var datalist:Array=dp.getDataList(dp.currentPage);
					
					for(var dv:int=0;dv<datalist.length;dv++)
					{	
						if(canvasContent!=null)
						{							
							var tcobj:*=canvasContent.getChildByName(datalist[dv].unqid);
							
							if(tcobj!=null)
							{
								var updobj:Object=datalist[dv];
								updobj.level=canvasContent.getChildIndex(tcobj);
								dp.UpdateData(dp.currentPage,updobj);
								
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
		}
		private function OnFlip(evt:MouseEvent):void
		{
			trace("OnFlip=>1");
			if(curTarget!=null)
			{				
				trace("OnFlip=>2");
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				if(dp.currentPage>=0)
				{	
					trace("OnFlip=>3");
					if(curTarget is SwfCHRComponent)
					{						
						trace("OnFlip=>4");
						for(var r:int=0;r<canvasContent.numChildren;r++)
						{
							if(canvasContent.getChildAt(r) is SwfCHRComponent)
							{								
								trace("OnFlip=>5");
								if((canvasContent.getChildAt(r) as SwfCHRComponent).name==curTarget.name)
								{									
									trace("OnFlip=>5_2");
									/*curTarget.scaleX=curTarget.scaleX*-1;
									if(Number(curTarget.scaleX)<0)
									{										
										curTarget.data.flip=1;
									}
									else
									{
										curTarget.data.flip=0;
									}
									curTarget.data.scalex=curTarget.scaleX;
									curTarget.data.unqid=curTarget.name;
									//dp.UpdateCharacter(dp.currentPage,curTarget.data);
									dp.UpdateData(dp.currentPage,curTarget.data);
									
									//-----------------------------------------------------
									//SaveBook Timer Start
									//-----------------------------------------------------
									facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
									//-----------------------------------------------------*/
									
									break;
								}
							}
						}
				}
				else if(curTarget is SwfOBJComponent)
				{						
					trace("OnFlip=>6");
					for(var r2:int=0;r2<canvasContent.numChildren;r2++)
					{
						if(canvasContent.getChildAt(r2) is SwfOBJComponent)
						{
							
							//if((canvasContent.getChildAt(r2) as SwfOBJComponent).data.unqid==curTarget.data.unqid)								
							if((canvasContent.getChildAt(r2) as SwfOBJComponent).name==curTarget.name)								
							{									
								
								//curTarget.scaleX=curTarget.scaleX*-1;									
								curTarget.swfContent.scaleX=curTarget.swfContent.scaleX*-1;								
								
								if(Number(curTarget.swfContent.scaleX)<0)
								{
									curTarget.swfContent.x+=curTarget.swfContent.width;
									curTarget.data.flip=1;
								}
								else
								{
									curTarget.swfContent.x-=curTarget.swfContent.width;
									curTarget.data.flip=0;
								}
								
								curTarget.data.scalex=curTarget.swfContent.scaleX;
								curTarget.data.unqid=curTarget.name;
								//dp.UpdateObject(dp.currentPage,curTarget.data);
								dp.UpdateData(dp.currentPage,curTarget.data);
								
								//-----------------------------------------------------
								//SaveBook Timer Start
								//-----------------------------------------------------
								facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
								//-----------------------------------------------------
								
								
								
								//MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME)).mainDisplay.m_log.text="OnFlip=>"+currTool.currentMode+"=>scalex:"+curTarget.scaleX+",scaley:"+curTarget.scaleY+",rotation:"+curTarget.rotation+",name=>"+curTarget.name+",swfContent.scaleX:"+curTarget.swfContent.scaleX+",swfContent.scaleY:"+curTarget.swfContent.scaleY;
								break;
							}
							
						}
					}
				}
					
					
				}
			}
		}
		
		private function deleteYesConfirm(evt:*):void
		{			
			if(curTarget!=null)
			{
				var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
				if(dp.currentPage>=0)
				{	
					if(curTarget is SwfCHRComponent)
					{
						dp.RemoveCharacter(dp.currentPage,curTarget.data);	
						
						for(var r:int=0;r<canvasContent.numChildren;r++)
						{
							if(canvasContent.getChildAt(r) is SwfCHRComponent)
							{
								if((canvasContent.getChildAt(r) as SwfCHRComponent).data.unqid==curTarget.data.unqid)
								{
									canvasContent.removeChildAt(r);
									//-----------------------------------------------------
									//SaveBook Timer Start
									//-----------------------------------------------------
									facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
									//-----------------------------------------------------
									break;
								}
							}
						}
					}
					else if(curTarget is SwfOBJComponent)
					{
						dp.RemoveObject(dp.currentPage,curTarget.data);
						
						for(var r2:int=0;r2<canvasContent.numChildren;r2++)
						{
							if(canvasContent.getChildAt(r2) is SwfOBJComponent)
							{
								if((canvasContent.getChildAt(r2) as SwfOBJComponent).data.unqid==curTarget.data.unqid)
								{
									canvasContent.removeChildAt(r2);
									//-----------------------------------------------------
									//SaveBook Timer Start
									//-----------------------------------------------------
									facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
									//-----------------------------------------------------
									break;
								}
							}
						}
					}
					
					
				}
				
			}
			facade.sendNotification(ApplicationConstants.CHECK_FOR_DUPLICATE_BTN);
		}
		
		private function showImagePopup()
		{								
						
			//positioning
						
			if(curTarget!=null)
			{
			
				if(ApplicationConstants.USER_TYPE=="FLUENT")
				{
					imageToolBox.BtnDelete.visible=true;			
					imageToolBox.BtnBringFront.visible=true;
					imageToolBox.BtnSendBack.visible=true;
					imageToolBox.BtnFlip.visible=true;
					imageToolBox.imagetoolboxbg1.visible=true;
					imageToolBox.imagetoolboxbg2.visible=false;
				}
				else if(ApplicationConstants.USER_TYPE=="EMERGENT")
				{
					imageToolBox.BtnDelete.visible=true;			
					imageToolBox.BtnBringFront.visible=false;
					imageToolBox.BtnSendBack.visible=false;
					imageToolBox.BtnFlip.visible=true;
					imageToolBox.imagetoolboxbg1.visible=false;
					imageToolBox.imagetoolboxbg2.visible=true;
				}
				
				
				imageToolBox.visible=true;
								
				var pt:Point=new Point(canvasContent.x,canvasContent.y);
				canvasContent.parent.localToGlobal(pt);
				
				var canvasWidth:int=580;
				var canvasHeight:int=580;
				var stagetopleftxp:Number=canvasContent.parent.x;
				var stagetopleftyp:Number=canvasContent.parent.y;								
				
				var stagetoprightxp:Number=(canvasContent.parent.x+canvasWidth);
				var stagetoprightyp:Number=canvasContent.parent.y;
				
				var stagebottomprightxp:Number=(canvasContent.parent.x+canvasWidth);
				var stagebottomrightyp:Number=(canvasContent.parent.y+canvasHeight);
				
				var stagebottomleftxp:Number=canvasContent.parent.x;
				var stagebottomleftyp:Number=(canvasContent.parent.y+canvasHeight);
								
				var objcenterxp:Number=curTarget.x+canvasContent.parent.x+pt.x;
				var objcenteryp:Number=curTarget.y+canvasContent.parent.y+pt.y;
				
				var objtopleftxp:Number=objcenterxp-((curTarget.width/2));
				var objtopleftyp:Number=objcenteryp-((curTarget.height/2)+60);
				
				var objtoprightxp:Number=objcenterxp+((curTarget.width/2));
				var objtoprightyp:Number=objcenteryp-((curTarget.height/2)+60);
				
				var objbottomrightxp:Number=objcenterxp+((curTarget.width/2));
				var objbottomrightyp:Number=objcenteryp+((curTarget.height/2));
				
				var objbottomleftxp:Number=objcenterxp-((curTarget.width/2));
				var objbottomleftyp:Number=objcenteryp+((curTarget.height/2));
				
				
				//trace("showImagePopup=>objtoprightxp:"+objtoprightxp+",stagetoprightxp:"+stagetoprightxp+",canvasContent.width:"+canvasContent.width+",canvasContent.height:"+canvasContent.height);
				
				//-----------------------------------------------------------------------
				//TopLeft
				if(objtopleftxp>stagetopleftxp && objtoprightxp<stagetoprightxp)
				{					
					imageToolBox.x=objtopleftxp;
					
					if((imageToolBox.x+imageToolBox.width)>stagetoprightxp)
					{
						imageToolBox.x=(stagetoprightxp-imageToolBox.width);
					}
				}
				else if(objtopleftxp<stagetopleftxp && objtoprightxp>stagetoprightxp)
				{					
					imageToolBox.x=stagetopleftxp;					
				}
				else if(objtopleftxp<stagetopleftxp)
				{					
					imageToolBox.x=stagetopleftxp;	
				}
				else if(objtoprightxp>stagetoprightxp)
				{					
					imageToolBox.x=(stagetoprightxp-imageToolBox.width);	
				}
				//-----------------------------------------------------------------------
				
				//-----------------------------------------------------------------------
				if(objtopleftyp>stagetopleftyp && objbottomleftyp<stagebottomrightyp)
				{					
					imageToolBox.y=objtopleftyp;
				}
				else if(objtopleftyp<stagetopleftyp && objbottomleftyp>stagebottomrightyp)
				{					
					imageToolBox.y=stagetopleftyp;
				}
				else if(objtopleftyp<stagetopleftyp)
				{					
					imageToolBox.y=objbottomleftyp;
				}
				else if(objbottomleftyp>stagebottomleftyp)
				{					
					imageToolBox.y=objtopleftyp;
				}
				//-----------------------------------------------------------------------				
				/*var pt:Point=new Point(canvasContent.x,canvasContent.y);
				canvasContent.parent.localToGlobal(pt);
								
				var xp:Number=curTarget.x+canvasContent.parent.x+pt.x;
				var yp:Number=curTarget.y+canvasContent.parent.y+pt.y;
				
				imageToolBox.x=xp-((curTarget.width/2));//
				imageToolBox.y=yp-((curTarget.height/2)+60);*/
			}
			
		}
		
		private function closeImagePopup()
		{
			imageToolBox.visible=false;
			
		}
			
		public function OnStageClickUp(evt:MouseEvent):void
		{
			trace("OnStageClickUp:"+evt.target+","+evt.target.name);
			
			//[object TextField],txtbookTitle
			var btobj:*;
			if(evt.target is TextField && evt.target.name=="txtbookTitle")
			{
				currTool.target = null;
				trace("book title "+canvasContent.parent.name);				
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=true;
					btobj.BtnResizer.visible=true;
					btobj.txtbookTitle.selectable=true;
					btobj.txtbookTitle.type="input";
					if(btobj.txtbookTitle.text=="Book Title")
					{
						btobj.txtbookTitle.text="";
					}
				}				
				
			}
			else if(evt.target is stageWhiteBG)
			{
				currTool.target = null;
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				facade.sendNotification(ApplicationConstants.SAVE_TEXT);
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
				facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
			}
			else if(evt.target is SwfBGComponent)
			{				
				currTool.target = null;
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				facade.sendNotification(ApplicationConstants.SAVE_TEXT);
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
				facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
			}
			else if(evt.target is FrontCoverThumbnail)
			{				
				currTool.target = null;
			}			
			else if (evt.target is SwfCHRComponent)//Sprite
			{				
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);				
				
			}
			else if (evt.target is SwfOBJComponent)//Sprite
			{	
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
			}
			else if (evt.target is SwfComponent)//Sprite
			{
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				//facade.sendNotification(ApplicationConstants.SAVE_TEXT);
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
				facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
			}	
			else if (evt.target is Stage)//Sprite
			{
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				//facade.sendNotification(ApplicationConstants.SAVE_TEXT);
				//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
				facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
			}
			else if(evt.target is FrontCoverThumbnail)
			{
				currTool.target = null;	
			}
			else if (evt.target is MovieClip)//Sprite
			{
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				
				if(evt.target.name=="scpContentBG")
				{
					currTool.target = null;
					facade.sendNotification(ApplicationConstants.SAVE_TEXT);
					//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
					facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
				}
				else if(evt.target.name=="BtnDeletePage")
				{
					currTool.target = null;	
					facade.sendNotification(ApplicationConstants.SAVE_TEXT);
					//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
					facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
				}
				else if(evt.target.name=="fcclip1" || evt.target.name=="fcclip2")
				{					
					currTool.target = null;
					facade.sendNotification(ApplicationConstants.SAVE_TEXT);
					//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
					facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
				}
				else if(evt.target.name=="pagebgthumbmask" || evt.target.name=="pageBgHolder")
				{
					currTool.target = null;
				}
			}	
			else if (evt.target is SimpleButton)//Sprite
			{				
				
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				if(evt.target.name=="pageThumbHitArea")
				{					
					facade.sendNotification(ApplicationConstants.SAVE_TEXT);
					//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
					facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
				}
				
				if(evt.target.name=="BtnBringFront" || evt.target.name=="BtnSendBack" || evt.target.name=="BtnFlip")
				{
					
				}
				else
				{
					currTool.target = null;
				}
				
			}	
			else
			{
				currTool.target = null;
				btobj=canvasContent.parent.getChildByName("bookTitle")				
				if(btobj!=null)
				{
					btobj.BtnDragger.visible=false;
					btobj.BtnResizer.visible=false;
					btobj.txtbookTitle.selectable=false;
					btobj.txtbookTitle.type="dynamic";
					if(btobj.txtbookTitle.text=="")
					{
						btobj.txtbookTitle.text="Book Title";
					}
				}
				//facade.sendNotification(ApplicationConstants.CLOSE_IMAGE_TOOLBOX);
			}
		}
		
		public function OnStageClick(evt:MouseEvent):void
		{
			trace("OnStageClick:"+evt.target+","+evt.target.name+","+evt.target.parent);
			
			//----------------------------------------------------------
			//Transform
			//----------------------------------------------------------
			if(evt.target is Stage)
			{
				currTool.target = null;
			}
			else if (evt.target is SwfCHRComponent)//Sprite
			{
				//Bring to front current selected item
				//canvasContent.setChildIndex(evt.target,(canvasContent.numChildren-1));
				currTool.target = evt.target as SwfCHRComponent;//Sprite;
				
			}
			else if (evt.target is SwfOBJComponent)//Sprite
			{				
				//Bring to front current selected item
				//canvasContent.setChildIndex(evt.target,(canvasContent.numChildren-1));
				currTool.target = evt.target as SwfOBJComponent;//Sprite;				
			}
			else
			{
				currTool.target = null;
			}
			
			
			//----------------------------------------------------------
		}
		
		
		
		// for setting a new tool
		private function toolInit():void
		{
			// raise
			//currTool.parent.setChildIndex(currTool, currTool.parent.numChildren - 1);
			
			// center registration for customTool
			currTool.registration = currTool.boundsCenter;
			
		}
				
		private function AddCalloutText(calloutobj:Object):void
		{				
			trace("AddCalloutText=>"+calloutobj.type+","+calloutobj.skin);
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp.currentPage>=0)
			{	
				var w:int;
				var h:int;
				var obj:Object;
									
					w=CanvasMediator(facade.retrieveMediator(CanvasMediator.NAME)).stagecontentmask.width;
					h=CanvasMediator(facade.retrieveMediator(CanvasMediator.NAME)).stagecontentmask.height;
					
					obj=new Object();
					obj.id=getTimer();
					obj.unqid=UID.createUID();
					if(calloutobj.xpos==0 && calloutobj.ypos==0)
					{
						obj.xpos=100;//290;
						obj.ypos=200;//290;
					}
					else
					{
						obj.xpos=calloutobj.xpos;
						obj.ypos=calloutobj.ypos;
					}
					obj.text='<TextFlow columnCount="inherit" columnGap="inherit" columnWidth="inherit" lineBreak="inherit" paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" paddingTop="inherit" verticalAlign="inherit" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008"><p fontFamily="Arial" fontSize="16" paragraphSpaceAfter="0" paragraphSpaceBefore="0" textDecoration="none"><span>Enter Your Text</span></p></TextFlow>';
					//obj.text='<TextFlow columnCount="inherit" columnGap="inherit" columnWidth="inherit" lineBreak="inherit" paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" paddingTop="inherit" verticalAlign="inherit" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008"><p fontFamily="Arial" fontSize="16" paragraphSpaceAfter="0" paragraphSpaceBefore="0" textDecoration="none"><span></span></p></TextFlow>';
					obj.stagew=w;
					obj.stageh=h;
					obj.curvex=0;
					obj.curvey=0;
					obj.width=250;
					obj.height=50;
					obj.type="CALLOUTTEXT";
					obj.controltype=calloutobj.type;
					obj.skin=calloutobj.skin;
					obj.name=obj.unqid;
					obj.level=0;
					obj.isnew=1;
					
					
				
				
					var coText:CalloutTextView=new CalloutTextView(obj);
					coText.name=obj.unqid;
					coText.x=obj.xpos;
					coText.y=obj.ypos;
					canvasContent.addChild(coText);
					coText.addEventListener("CLOSE_TEXTTOOL_FROM_CALLOUT_TEXT",OnCloseTextToolFromCalloutText);
					coText.addEventListener("SHOW_TEXTTOOL_FROMCALLOUTTEXT",OnShowTextToolFromCalloutText);
					coText.addEventListener("DELETE_CALLOUT_TEXT",OnDeleteCallOutText);
					coText.addEventListener("TRANSFORM_COMPLETE_CALLOUT_TEXT",OnTransformCallOutText);					
					
					obj.level=canvasContent.getChildIndex(coText);
					
					
					
					DataProxy(facade.retrieveProxy(DataProxy.NAME)).InsertCalloutText(dp.currentPage,obj);
					
					DeselectAllTextCallout(obj.unqid);
					
				
				facade.sendNotification(ApplicationConstants.CHECK_FOR_DUPLICATE_BTN);
			}
			
		}
		
		private function OnCloseTextToolFromCalloutText(evt:ObjectEvent):void
		{			
			facade.sendNotification(ApplicationConstants.SAVE_TEXT);			
			//facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
			
		}
		private function OnShowTextToolFromCalloutText(evt:ObjectEvent):void
		{			
			DeselectAllTextCallout(evt.objdata.target);
						
		}
		
		private function DeselectAllTextCallout(uid:String)
		{
			trace("DeselectAllTextCallout1=>");
			if(uid=="ALL")
			{
				var canvasobj:*=CanvasMediator(facade.retrieveMediator(CanvasMediator.NAME)).getCanvas();
				if(canvasobj!=null)
				{
					var stageContClip:*=canvasobj.getChildByName("stageContent");			
					if(stageContClip!=null)
					{	
						for(var dv:int=0;dv<stageContClip.numChildren;dv++)
						{		
							if(stageContClip.getChildAt(dv) is CalloutTextView)
							{					
								trace("DeselectAllTextCallout2=>"+stageContClip.getChildAt(dv).name+","+uid);											
								trace("DeselectAllTextCallout3=>");
								var cot:CalloutTextView=stageContClip.getChildAt(dv) as CalloutTextView;
								cot.changeView("VIEW");
								
							}
						}
					}
				}			
			}
			else
			{
				var canvasobj2:*=CanvasMediator(facade.retrieveMediator(CanvasMediator.NAME)).getCanvas();
				if(canvasobj2!=null)
				{
					var stageContClip2:*=canvasobj2.getChildByName("stageContent");			
					if(stageContClip2!=null)
					{	
						for(var dv2:int=0;dv2<stageContClip2.numChildren;dv2++)
						{		
							if(stageContClip2.getChildAt(dv2) is CalloutTextView)
							{					
								//trace("DeselectAllTextCallout2=>"+stageContClip2.getChildAt(dv2).name+","+uid);
								if(stageContClip2.getChildAt(dv2).name!=uid)
								{			
									trace("DeselectAllTextCallout3=>");
									var cot2:CalloutTextView=stageContClip2.getChildAt(dv2) as CalloutTextView;
									cot2.changeView("VIEW");
								}
							}
						}
					}
				}	
			}
			
		}
		
		private function OnTransformCallOutText(evt:ObjectEvent):void
		{
			//-----------------------------------------------------
			//SaveBook Timer Start
			//-----------------------------------------------------
			facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
			//-----------------------------------------------------
		}
		private function OnDeleteCallOutText(evt:ObjectEvent):void
		{			
			curCallTextObject=evt.objdata;
			var ac:AlertComponent=new com.learning.atoz.alert.AlertComponent();
			ac.Target=MainDisplayMediator(facade.retrieveMediator(MainDisplayMediator.NAME)).mainDisplay;	
			ac.MsgBoxType="YESNO";			
			ac.addEventListener("BtnYes",CallOutTextdeleteYesConfirm);			
			ac.showAlert("Are you sure you want to delete?");
		}
		
		private function CallOutTextdeleteYesConfirm(evt:*):void
		{
			facade.sendNotification(ApplicationConstants.CLOSE_TEXT_TOOLBOX);
			if(curCallTextObject!=null)
			{								
					var tcobj:*=canvasContent.getChildByName(curCallTextObject.name);					
					if(tcobj!=null)
					{
						var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
						dp.RemoveCalloutText(dp.currentPage,curCallTextObject);
						canvasContent.removeChild(tcobj);
						
						//-----------------------------------------------------
						//SaveBook Timer Start
						//-----------------------------------------------------
						facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
						//-----------------------------------------------------
					}	
			}
			facade.sendNotification(ApplicationConstants.CHECK_FOR_DUPLICATE_BTN);
			
		}
		
		private function RestoreData(dataarr:Array):void
		{	
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
			
			//DeselectAllTextCallout("ALL");
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
			coText.addEventListener("CLOSE_TEXTTOOL_FROM_CALLOUT_TEXT",OnCloseTextToolFromCalloutText);
			coText.addEventListener("SHOW_TEXTTOOL_FROMCALLOUTTEXT",OnShowTextToolFromCalloutText);
			coText.addEventListener("DELETE_CALLOUT_TEXT",OnDeleteCallOutText);
			
			
			
			
			
			
		}
		//===
		private function copyObject(src:Object,dest:Object):void
		{
			for(var dv in src)
			{
				dest[dv]=src[dv];
			}	
		}
		
		private function AddCharacter(obj:Object):void
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp.currentPage>=0)
			{	
				//------------------------------------------				
				//------------------------------------------
				//copy only object values
				//------------------------------------------
				var chrobj:Object=new Object();
				copyObject(obj,chrobj);	
				//------------------------------------------
				//moved to SwfCHRComponent Constructor
				//obj.unqid=UID.createUID();
				chrobj.xpos=250+Math.random()*50;//290;
				chrobj.ypos=250+Math.random()*50;//290;
				chrobj.level=0;
				
				
				var chrswf:SwfCHRComponent=new SwfCHRComponent(chrobj);
				chrswf.name=chrobj.unqid;				
				//update chr size after it loads
				chrswf.addEventListener("CHR_LOAD_COMPLETED_UPDATE_SIZE",UpdateChrSize);
				chrswf.loadSWF(chrobj.url,200,200);
				chrswf.x=chrobj.xpos;
				chrswf.y=chrobj.ypos;				
				canvasContent.addChild(chrswf);
				
				chrobj.level=canvasContent.getChildIndex(chrswf);
				DataProxy(facade.retrieveProxy(DataProxy.NAME)).InsertCharacter(dp.currentPage,chrswf.data);
			}
			
		}
		
		private function UpdateChrSize(evt:ObjectEvent):void
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp.currentPage>=0)
			{	
				DataProxy(facade.retrieveProxy(DataProxy.NAME)).UpdateCharacter(dp.currentPage,evt.objdata);
			}
			
		}
		
		
		
		
		private function RestoreCharacter(charobj:Object):void
		{		
			//trace("RestoreCharacter=>w:"+charobj.width+",h:"+charobj.height+",rot:"+charobj.rotation);
			var chrswf:SwfCHRComponent=new SwfCHRComponent(charobj);
			chrswf.name=charobj.unqid;					
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
			
			charobj.level=canvasContent.getChildIndex(chrswf);
			
		}
		
		//-----------------------------------------------------		
		
		private function AddObject(obj:Object):void
		{			
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp.currentPage>=0)
			{
				//------------------------------------------
				//copy only object values
				//------------------------------------------
				var objobj:Object=new Object();
				copyObject(obj,objobj);	
				//------------------------------------------
				//moved to SwfOBJComponent Constructor
				//obj.unqid=UID.createUID();
				//only for click and place
				if(objobj.xpos==0 && objobj.ypos==0)
				{
					objobj.xpos=250+Math.random()*50;//290;
					objobj.ypos=250+Math.random()*50;//290;
				}
				objobj.level=0;
				var objswf:SwfOBJComponent=new SwfOBJComponent(objobj);
				objswf.name=objobj.unqid;			
				objswf.addEventListener("OBJ_LOAD_COMPLETED_UPDATE_SIZE",UpdateObjSize);
				objswf.loadSWF(objobj.url,200,200);
				objswf.x=objobj.xpos;
				objswf.y=objobj.ypos;
				canvasContent.addChild(objswf);
				
				objobj.level=canvasContent.getChildIndex(objswf);
				DataProxy(facade.retrieveProxy(DataProxy.NAME)).InsertObject(dp.currentPage,objswf.data);
				
				facade.sendNotification(ApplicationConstants.CHECK_FOR_DUPLICATE_BTN);
			}
			
		}
		
		
		private function UpdateObjSize(evt:ObjectEvent):void
		{
			var dp:DataProxy=DataProxy(facade.retrieveProxy(DataProxy.NAME));
			if(dp.currentPage>=0)
			{
				DataProxy(facade.retrieveProxy(DataProxy.NAME)).UpdateObject(dp.currentPage,evt.objdata);
			}
			
		}
		
		private function RestoreObject(obj:Object):void
		{		
			trace("RestoreObject=>url:"+obj.url+",w:"+obj.width+",h:"+obj.height+",rot:"+obj.rotation+",scalex:"+obj.scalex+",scaley:"+obj.scaley+",flip:"+obj.flip);
			var objswf:SwfOBJComponent=new SwfOBJComponent(obj);
			//objswf.addEventListener("OBJ_LOAD_COMPLETED_UPDATE_SIZE",UpdateRestoreObjSize);
			objswf.name=obj.unqid;				
			objswf.loadSWF(obj.url,obj.width,obj.height);
			//objswf.loadSWF(obj.url,200,200);
			objswf.x=obj.xpos;
			objswf.y=obj.ypos;
			objswf.rotation=obj.rotation;
			
			
			//bcos while scaling also they can flip
			if(obj.flip==1)
			{
				//The Flip Script is moved to SwfOBJComponent onComplete
				
				/*objswf.swfContent.scaleX=objswf.swfContent.scaleX*-1;								
								
				if(Number(objswf.swfContent.scaleX)<0)
				{
					objswf.swfContent.x+=objswf.swfContent.width;					
				}
				else
				{
					objswf.swfContent.x-=objswf.swfContent.width;					
				}*
				
				/*if(Number(obj.scalex)<0)
				{
					objswf.swfContent.scaleX=objswf.swfContent.scaleX*-1;
				}*/
				
				/*if(Number(obj.scaley)<0)
				{
					objswf.swfContent.scaleY=objswf.scaleY*-1;
				}*/
			}
			canvasContent.addChild(objswf);
			
			obj.level=canvasContent.getChildIndex(objswf);
			
		}		
		
		private function UpdateRestoreObjSize(evt:ObjectEvent):void
		{
			trace("UpdateRestoreObjSize=>"+evt.currentTarget);		
			evt.currentTarget.rotation=evt.objdata.rotation;
		}
		
		
		
		
		
		public function get canvasContent():Object
		{
			return viewComponent as Object;
		}
	}
}
