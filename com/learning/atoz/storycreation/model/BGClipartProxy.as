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
	public class BGClipartProxy extends Proxy implements IProxy
	{
		
		public static const NAME:String = "BGClipartProxy";
		private var _loader:URLLoader; 
		private var _from:String;						
		//-----------------------------------------------------		
		public function BGClipartProxy() 
        {
            super ( NAME,new DataVo() );            
            setup();            
        }
		//-----------------------------------------------------		
        
		
		//-----------------------------------------------------		
		private function setup():void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onBGClipartLoad);		
			_loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		//import flash.events.IOErrorEvent;
		//-----------------------------------------------------		
		private function onIOError(evt:IOErrorEvent):void
		{			
			trace("onIOError:"+NAME+"=>" + evt.text+",");
			
		}
		
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
				trace("BGClipartProxy=>loadInfo=>"+vo.clipartdataURL_Remote+subcatid);
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
		//when bglist load from clipart update objlist and vice versa so that same cat will show in both bg and obj thumbnails
		public function setXmlData(xmlobj:XML)
		{
			vo._xml = xmlobj;
		}
		//-----------------------------------------------------		
		//when data is loaded 
		//-----------------------------------------------------		
		private function onBGClipartLoad(e:Event):void
		{			
			var res:String=e.target.data;
			if(res.indexOf("<html")>=0 || res.indexOf("<head")>=0 || res.indexOf("<body")>=0)
			{
				trace("onBGClipartLoad=>Server Communication Error");
			}
			else
			{
				vo._xml = new XML(res);			
				//trace("onBGClipartLoad1=>"+vo._xml);
				//trace("onBGClipartLoad2=>"+_from);
				//send notifications
				if(_from=="CLIPART")
				{											
					facade.sendNotification(ApplicationConstants.BG_CLIPART_CADATA_LOADED,vo._xml);					
				}
				else if(_from=="MENU")
				{											
					facade.sendNotification(ApplicationConstants.CLIPART_DATA_LOADED,"BGMENULOADED");					
					
				}
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
