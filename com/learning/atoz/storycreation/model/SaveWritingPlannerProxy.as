package com.learning.atoz.storycreation.model
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.vo.DataVo;
	
	import flash.events.Event;
	import flash.net.*;
	
	import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;	
	import org.puremvc.as3.patterns.observer.Notification;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	
	/*
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.vo.DataVo;
	
	import flash.events.Event;
	import flash.net.*;
	
	import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;	
	import org.puremvc.as3.patterns.observer.Notification;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	*/
	/*
		ThemeProxy is used to load theme xml
	*/
	public class SaveWritingPlannerProxy extends Proxy implements IProxy
	{		
		public static const NAME:String = "SaveWritingPlannerProxy";
		private var request:URLRequest;
		private var myLoader:URLLoader;
		private var saveurl:String='http://emantras.raz-kids.com/main/CreativeWritingSaveLoad/action/saveWritingPlanner';						
		//-----------------------------------------------------
		public function SaveWritingPlannerProxy() 
        {
            super ( NAME,this );
            
        }
        //-----------------------------------------------------
		
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		// function called to start action of ThemeProxy
		//-----------------------------------------------------
		public function SaveWritingPlanner(bookxml:String,bookid:Number):void
		{			
			facade.sendNotification(ApplicationConstants.SHOW_WAIT_POPUP,"Saving WritingPlanner.....");			
			try
			{
				if(bookid>0)
				{
					request = new URLRequest(saveurl+"/id/"+bookid);
				}
				else
				{
					request = new URLRequest(saveurl);
				}
				
				trace("SaveWritingPlannerProxy=>"+request.url);
				
				var _vars:URLVariables=new URLVariables();//"bookData="+bookxml
				
				_vars.bookData=bookxml;//new XML(bookxml);
								
				myLoader = new URLLoader();
				//myLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
				myLoader.dataFormat =URLLoaderDataFormat.TEXT;
				request.data = _vars;
				request.method = URLRequestMethod.POST;
				
				myLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				myLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerIOErrorEvent);
				myLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerSecurityErrorEvent);			
				
				////myLoader.load( request,context );
				myLoader.load( request);
				
				//trace("Save Book Temporarily Commented...");
				//facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
			}
			catch(err:Error)
			{
				trace("catcherror:"+err.message);
				facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
			}
		}
		
		public function onLoadComplete( e:Event ):void
		{	
			var loader:URLLoader = URLLoader(e.target);			
			var rawData:String=String(loader.data);			
			trace("SaveWritingPlannerProxy=>OnLoadComplete=>"+rawData);
			facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
			facade.sendNotification(ApplicationConstants.SAVE_WRITING_PLANNER_COMPLETED,rawData);
			
		}
		//-----------------------------------------------------
		public function errorHandlerIOErrorEvent( e:IOErrorEvent ):void
		{
			facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
		  	trace( 'errorHandlerIOErrorEvent ' + e.toString() );
			facade.sendNotification(ApplicationConstants.SAVE_WRITING_PLANNER_ERROR,null);
		}
		
		public function errorHandlerSecurityErrorEvent( e:SecurityErrorEvent):void
		{			
			facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
		  	trace( 'errorHandlerSecurityErrorEvent ' + e.toString() );
			facade.sendNotification(ApplicationConstants.SAVE_WRITING_PLANNER_ERROR,null);
		}		
		
		//-----------------------------------------------------
		// this is an overriden inherited function from PureMVC
		//-----------------------------------------------------
		override public function getProxyName():String
		{
			return NAME;
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
						
	
		
		
	}
}
