package com.learning.atoz.storycreation.model
{
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.vo.DataVo;
	
	import flash.events.Event;
	import flash.net.*;
	
	import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;	
	import org.puremvc.as3.patterns.observer.Notification;
	/*
		ThemeProxy is used to load theme xml
	*/
	public class ConfigProxy extends Proxy implements IProxy
	{		
		public static const NAME:String = "ConfigProxy";
		private var _loader:URLLoader;
								
		//-----------------------------------------------------
		public function ConfigProxy() 
        {
            super ( NAME,new DataVo() );
            setup();
        }
        //-----------------------------------------------------
		
		//-----------------------------------------------------
		private function setup():void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onConfigLoad);			
		}		
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		// function called to start action of ThemeProxy
		//-----------------------------------------------------
		public function loadInfo():void
		{			
			_loader.load(new URLRequest(vo.configURL));			
			
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
		private function onConfigLoad(e:Event):void
		{			
			vo._xml = new XML(e.target.data);
						
			//send notifications
			facade.sendNotification(ApplicationConstants.CONFIG_DATA_LOADED,vo._xml);
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
