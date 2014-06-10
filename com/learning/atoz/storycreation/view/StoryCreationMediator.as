package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.StoryCreationApp;
	import com.learning.atoz.storycreation.model.ConfigProxy;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.learning.atoz.storycreation.model.BGClipartProxy;
	import com.learning.atoz.storycreation.model.OBJClipartProxy;
	
	/*
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.StoryCreationApp;
	import com.learning.atoz.storycreation.model.ConfigProxy;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	*/
	
	/*
		In StoryCreationMediator initiating xml calls and loading and displaying application components like menu,canvas and page navigation bar
	*/	
	public class StoryCreationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "StoryCreationMediator";		
		private var themeXml:XML;
		private var clipartXml:XML;		
		private var configXml:XML;
		
		//-----------------------------------------------------		
		public function StoryCreationMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);
			loadXml();			
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			facade.registerMediator(new MainDisplayMediator(app));		
			
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
			return [ApplicationConstants.THEME_DATA_LOADED,
					ApplicationConstants.CLIPART_DATA_LOADED,
					ApplicationConstants.CONFIG_DATA_LOADED];
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationConstants.THEME_DATA_LOADED:
					themeXml = (notification.getBody() as XML);
					//Randomize Default Left Menu
					/*var subcatarr:Array=new Array();
					for(var dv:int=0;dv<themeXml..SubCategory.length();dv++)
					{
						trace(themeXml..SubCategory[dv].@SubCatId);
						subcatarr.push(themeXml..SubCategory[dv].@SubCatId);
					}
					var randno:int=Math.random()*subcatarr.length;
					trace("subcatarrlen="+subcatarr.length+",randno:"+randno+",randsubcatid="+subcatarr[randno-1]);
					ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).loadInfo(subcatarr[randno-1]);*/
				break;
				
				case ApplicationConstants.CLIPART_DATA_LOADED:
					//clipartXml=(notification.getBody() as XML);
					var menutype:String=(notification.getBody() as String);//BGMENULOADED/OBJMENULOADED
					trace("CLIPART_DATA_LOADED=>"+menutype);
					if(menutype=="BGMENULOADED")
					{
						facade.sendNotification(ApplicationConstants.BG_MENU_UPDATE);
					}
					else if(menutype=="OBJMENULOADED")
					{					
						facade.sendNotification(ApplicationConstants.OBJ_MENU_UPDATE);
					}
					
					//trace("CLIPART_DATA_LOADED=>"+clipartXml);
					//facade.sendNotification(ApplicationConstants.PRELOAD_BG_THUMBNAIL);
					//facade.sendNotification(ApplicationConstants.PRELOAD_CHR_THUMBNAIL);
					//facade.sendNotification(ApplicationConstants.PRELOAD_OBJ_THUMBNAIL);
					//facade.sendNotification(ApplicationConstants.PRELOAD_LAYOUT_THUMBNAIL);
					//facade.sendNotification(ApplicationConstants.PRELOAD_TEXTCALLOUT_THUMBNAIL);
				break;
				
				case ApplicationConstants.CONFIG_DATA_LOADED:
					configXml=(notification.getBody() as XML);
															
					/*if(configXml..apptype=="book")
					{			
						facade.sendNotification(ApplicationConstants.SHOW_BOOK_MANAGER);
					}
					else if(configXml..apptype=="assignment")
					{				
						facade.sendNotification(ApplicationConstants.SHOW_ASSIGNMENT_MANAGER);
					}*/
					break;
				
				
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		// loading theme & clipart xml call
		//-----------------------------------------------------		
		private function loadXml():void
		{			
			//ConfigProxy(facade.retrieveProxy(ConfigProxy.NAME)).loadInfo();			
			ThemeProxy(facade.retrieveProxy(ThemeProxy.NAME)).loadInfo();
			//default subcatid as 3 bcos to show default bg/chr/obj
			//ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).loadInfo(3);			
			//ClipartProxy(facade.retrieveProxy(ClipartProxy.NAME)).loadInfo(3);
			
			BGClipartProxy(facade.retrieveProxy(BGClipartProxy.NAME)).loadInfo(3,"MENU");
			OBJClipartProxy(facade.retrieveProxy(OBJClipartProxy.NAME)).loadInfo(3,"MENU");
			
						
			
		}
		//-----------------------------------------------------		
		
		
		
		public function get app():StoryCreationApp
		{
			return viewComponent as StoryCreationApp;
		}
		
	}
}
