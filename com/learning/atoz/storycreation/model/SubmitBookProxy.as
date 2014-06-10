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
	public class SubmitBookProxy extends Proxy implements IProxy
	{		
		public static const NAME:String = "SubmitBookProxy";
		private var request:URLRequest;
		private var myLoader:URLLoader;
		private var saveurl:String='http://emantras.raz-kids.com/main/CreativeWritingSaveLoad/action/submitBook';			
		//-----------------------------------------------------
		public function SubmitBookProxy() 
        {
            super ( NAME,this );
            
        }
        //-----------------------------------------------------
		
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		// function called to start action of ThemeProxy
		//-----------------------------------------------------
		public function submitBook(bookxml:String,bookid:Number):void
		{			
			facade.sendNotification(ApplicationConstants.SHOW_WAIT_POPUP,"Submiting Book.....");			
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
				
				
				var _vars:URLVariables=new URLVariables();//"bookData="+bookxml
				trace("savexml:"+bookxml);
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
			trace("SubmitBookProxy=>onLoadComplete=>"+rawData);
						
			//Book submited redirect to Home Page
			facade.sendNotification(ApplicationConstants.CLOSE_CHECKLIST);
			facade.sendNotification(ApplicationConstants.NEW_BOOK);		
			facade.sendNotification(ApplicationConstants.CLOSE_WAIT_POPUP);			
			facade.sendNotification(ApplicationConstants.SHOW_BOOK_MANAGER);
			
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
		
		
		//-----------------------------------------------------
						
	
		
		
	}
}
