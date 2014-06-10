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
	public class SearchProxy extends Proxy implements IProxy
	{		
		public static const NAME:String = "SearchProxy";
		private var request:URLRequest;
		private var myLoader:URLLoader;
		private var loadurl:String='http://emantras.raz-kids.com/main/StoryResources/search';
		private var _data:String;
		
		//-----------------------------------------------------
		public function SearchProxy() 
        {
            super ( NAME,this );
            
        }
        //-----------------------------------------------------	
		
		//-----------------------------------------------------
		// function called to start action of ThemeProxy
		//-----------------------------------------------------
		public function Search(searchtext:String):void
		{				
			facade.sendNotification(ApplicationConstants.SHOW_WAIT_POPUP,"Searching.....");
			try
			{
				if(searchtext.length>=2)
				{					
					request = new URLRequest(loadurl+"/"+searchtext);
					
					myLoader = new URLLoader();
					//myLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
					myLoader.dataFormat =URLLoaderDataFormat.TEXT;				
					request.method = URLRequestMethod.GET;
					
					myLoader.addEventListener(Event.COMPLETE, onLoadComplete);
					myLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerIOErrorEvent);
					myLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerSecurityErrorEvent);			
									
					myLoader.load( request);	
				}		
			}
			catch(err:Error)
			{
				trace("catcherror:"+err.message);
				facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
			}
		}
		
		public function onLoadComplete( e:Event ):void
		{
			facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
			
			var loader:URLLoader = URLLoader(e.target);			
			var rawData:String=String(loader.data);
			_data=rawData;
			
			facade.sendNotification(ApplicationConstants.SEARCH_RESULT,rawData);
		}
		//-----------------------------------------------------
		public function errorHandlerIOErrorEvent( e:IOErrorEvent ):void
		{
			facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
		 	trace( 'errorHandlerIOErrorEvent ' + e.toString() );
		}
		
		public function errorHandlerSecurityErrorEvent( e:SecurityErrorEvent):void
		{		
			facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);
		  	trace( 'errorHandlerSecurityErrorEvent ' + e.toString() );
		}		
		
		//-----------------------------------------------------
		// this is an overriden inherited function from PureMVC
		//-----------------------------------------------------
		override public function getProxyName():String
		{
			return NAME;
		}
		//-----------------------------------------------------
		public function getApiData():String
		{
			return _data;
		}
		
		//-----------------------------------------------------
						
	
		
		
	}
}
