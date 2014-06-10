package com.learning.atoz.storycreation.view
{
	import com.learn.atoz.texttool.atozTextTool;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	import fl.text.TLFTextField;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class TextToolBoxMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TextToolBoxMediator";		
		private var textToolBox:atozTextTool;		
		//-----------------------------------------------------		
		public function TextToolBoxMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			textToolBox=new atozTextTool();
			textToolBox.name="textToolBox";
			
			//facade.sendNotification(ApplicationConstants.SHOW_TEXT_TOOLBOX);			
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
			return [ApplicationConstants.SHOW_TEXT_TOOLBOX,
				ApplicationConstants.CLOSE_TEXT_TOOLBOX];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.SHOW_TEXT_TOOLBOX:					
					//var tlftf:TLFTextField=(notification.getBody() as TLFTextField);
					var textobj:Object=(notification.getBody() as Object);
					var tlftf:TLFTextField=textobj.textobject;
					var texttoolobj:*= DisplayObjectContainer(viewComponent).getChildByName("textToolBox");
					//trace("SHOW_TEXT_TOOLBOX1=>"+texttoolobj+",tlftf="+tlftf);
					if(texttoolobj==null)
					{												
						DisplayObjectContainer(viewComponent).addChild(textToolBox);
						if(tlftf!=null)
						{						
							textToolBox.setTarget(tlftf);
							
						}					
					}
					
					//positioning
					if(tlftf!=null)
					{	
					
						textToolBox.x=textobj.xpos;						
						textToolBox.y=textobj.ypos-40;						
						//tlftf.textFlow.interactionManager.setFocus();
						
					}
					
									
					break;
				
				case ApplicationConstants.CLOSE_TEXT_TOOLBOX:
					trace("CLOSE_TEXT_TOOLBOX=>");
					var texttoolobj2:*= DisplayObjectContainer(viewComponent).getChildByName("textToolBox");
					if(texttoolobj2!=null)
					{
						textToolBox.setTarget(null);
						DisplayObjectContainer(viewComponent).removeChild(textToolBox);
					}
					break;
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Generating Background Thumbnails
		//-----------------------------------------------------		
		
		
		
		
	}
}
