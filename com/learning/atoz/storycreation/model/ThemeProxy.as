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
	/*
		ThemeProxy is used to load theme xml
	*/
	public class ThemeProxy extends Proxy implements IProxy
	{		
		public static const NAME:String = "ThemeDataProxy";
		private var _loader:URLLoader; 
								
		//-----------------------------------------------------
		public function ThemeProxy() 
        {
            super ( NAME,new DataVo() );
            setup();
        }
        //-----------------------------------------------------
		
		//-----------------------------------------------------
		private function setup():void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onThemeLoad);			
			_loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		//
		//-----------------------------------------------------		
		private function onIOError(evt:IOErrorEvent):void
		{			
			trace("onIOError:"+NAME+"=>" + evt.text+",");
			
		}		
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		// function called to start action of ThemeProxy
		//-----------------------------------------------------
		public function loadInfo():void
		{
			if(ApplicationConstants.ASSETS_MODE=="LOCAL")
			{
				_loader.load(new URLRequest(vo.themedataURL_Local));
			}
			else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
			{
				_loader.load(new URLRequest(vo.themedataURL_Remote));
			}
			
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		// this is an overriden inherited function from PureMVC
		//-----------------------------------------------------
		override public function getProxyName():String
		{
			return NAME;
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//when data is loaded 
		//-----------------------------------------------------
		private function onThemeLoad(e:Event):void
		{			
			var res:String=e.target.data;
			trace("onThemeLoad1=>");
			if(res.indexOf("<html")>=0 || res.indexOf("<body")>=0) //|| res.indexOf("<head")>=0
			{
				trace("onThemeLoad=>Server Communication Error");
			}
			else
			{
				trace("onThemeLoad2=>"+res);	  
				vo._xml = new XML(res);					
				
				//send notifications
				facade.sendNotification(ApplicationConstants.THEME_DATA_LOADED,vo._xml);
			}
		}
		//-----------------------------------------------------
						
		//-----------------------------------------------------
		public function get vo():DataVo
		{
			return data as DataVo;
		}
		//-----------------------------------------------------
		
	}
}
