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
	ClipartProxy  is used to load Clipart xml
	*/
	public class CHRClipartProxy extends Proxy implements IProxy
	{
		
		public static const NAME:String = "CHRClipartProxy";
		private var _loader:URLLoader; 
		private var _from:String;				
		//-----------------------------------------------------		
		public function CHRClipartProxy() 
        {
            super ( NAME,new DataVo() );            
            setup();            
        }
		//-----------------------------------------------------		
        
		
		//-----------------------------------------------------		
		private function setup():void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onCHRClipartLoad);			
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
		public function loadInfo(subcatid:int,from:String):void
		{
			_from=from;
			if(ApplicationConstants.ASSETS_MODE=="LOCAL")
			{
				_loader.load(new URLRequest(vo.clipartdataURL_Local));
			}
			else if(ApplicationConstants.ASSETS_MODE=="REMOTE")
			{
				_loader.load(new URLRequest(vo.clipartdataURL_Remote+subcatid));	
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
		private function onCHRClipartLoad(e:Event):void
		{			
			vo._xml = new XML(e.target.data);			
			trace("onCHRClipartLoad=>"+vo._xml);
			//send notifications
			if(_from=="CLIPART")
			{						
				facade.sendNotification(ApplicationConstants.CHR_CLIPART_CADATA_LOADED,vo._xml);
			}
			else if(_from=="MENU")
			{						
				//facade.sendNotification(ApplicationConstants.CHR_MENU_CADATA_LOADED,vo._xml);
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
