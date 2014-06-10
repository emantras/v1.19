package com.learning.atoz.storycreation.view
{
	//import com.learn.atoz.texttool.atozTextTool;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.view.components.ImageToolBox;
	
	import fl.text.TLFTextField;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/*
	import com.learn.atoz.texttool.atozTextTool;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.view.components.ImageToolBox;
	
	import fl.text.TLFTextField;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	*/
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class ImageToolBoxMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ImageToolBoxMediator";		
		private var imageToolBox:ImageToolBox;
		//-----------------------------------------------------		
		public function ImageToolBoxMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
					
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			imageToolBox=new ImageToolBox();
			imageToolBox.name="imageToolBox";
			
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
			return [ApplicationConstants.SHOW_IMAGE_TOOLBOX,
				ApplicationConstants.CLOSE_IMAGE_TOOLBOX];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.SHOW_IMAGE_TOOLBOX:					
					//var tlftf:TLFTextField=(notification.getBody() as TLFTextField);
					var imageobj:Object=(notification.getBody() as Object);					
					var imagetoolobj:*= DisplayObjectContainer(viewComponent).getChildByName("imageToolBox");
					
					if(imagetoolobj==null)
					{												
						DisplayObjectContainer(viewComponent).addChild(imageToolBox);
						
					}
					
					//positioning
					if(imageobj!=null)
					{	
						imageToolBox.x=imageobj.xpos;
						imageToolBox.y=imageobj.ypos;//-40;											
					}
					
									
					break;
				
				case ApplicationConstants.CLOSE_IMAGE_TOOLBOX:
					
					var imagetoolobj2:*= DisplayObjectContainer(viewComponent).getChildByName("imageToolBox");
					if(imagetoolobj2!=null)
					{						
						DisplayObjectContainer(viewComponent).removeChild(imageToolBox);
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
