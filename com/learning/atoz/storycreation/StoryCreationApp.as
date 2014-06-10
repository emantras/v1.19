package com.learning.atoz.storycreation
{
	import com.learning.atoz.audio.audioLib;
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.learning.atoz.transform.TransformTool;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	
	/*
	import com.learning.atoz.audio.audioLib;
	Application Main File
	*/	
	public class StoryCreationApp extends MovieClip
	{
		public var defaultTool:TransformTool;
		public var currTool:TransformTool;
		public var askBeforeQuitFlag:Boolean = true;
		//-----------------------------------------------------
		//Main App constructor
		//-----------------------------------------------------
		public function StoryCreationApp()
		{			
			trace("StoryCreationApp");			
			//ExternalInterface.addCallback("SaveAndResetTimer",OnSaveAndResetTimer);
			this.addEventListener(Event.ENTER_FRAME, loading);
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
			preloader.homebgscreencast.visible=true;
		}
		
		private function OnInit(evt:Event):void
		{
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			this.removeEventListener(Event.ADDED_TO_STAGE,OnInit);
			
			//System.security.allowDomain("*");
			//ExternalInterface.addCallback("SaveAndResetTimer",OnSaveAndResetTimer);
									
			//m_log1.text="available:"+ExternalInterface.available;
			
			//Btntemp1.addEventListener(MouseEvent.CLICK,t1);
			
			 log("ExternalInterface=>"+ExternalInterface.available);	
			//Set up Javascript to Actioscript
			//ExternalInterface.addCallback("sendTextFromJS", receiveTextFromJS);
			ExternalInterface.addCallback("savebeforeClose", savebeforeClose);
			//BtnSend.addEventListener(MouseEvent.CLICK, sendTextFromAS3);
			//BtnSend.buttonMode = true;
			
		}
		
		public function savebeforeClose()
		{
			var facade:StoryCreationFacade = StoryCreationFacade.getInstance();
			facade.sendNotification(ApplicationConstants.SAVE_BOOK);
		}
		
		public function log(msg:String)
		{
			//m_status.text+="\n"+msg;
		}
		
		/*public function receiveTextFromJS(t:String):void {
			m_output.text = t;
		}
		
		
		//Actionscript to Javascript
		public function sendTextFromAS3(e:MouseEvent):void {
			ExternalInterface.call("receiveTextFromAS3", m_input.text);
			m_input.text = "";
		}*/
		
		
		
		public function t1(e:*)
		{
			//m_log1.text="call flashInitialized";
			//ExternalInterface.call("flashInitialized");
		}
		
		public function OnSaveAndResetTimer()
		{
			
			//m_log1.text="OnSaveAndResetTimer Called";
			//var facade:StoryCreationFacade = StoryCreationFacade.getInstance();
			//facade.sendNotification(ApplicationConstants.SAVE_BOOK_AND_STOP_TIMER);
			//facade.sendNotification(ApplicationConstants.SAVE_BOOK_TIMER_RESTART);
		}
		
		public function BringPreloaderFront():void
		{
			//trace("BringPreloaderFront=>"+this.preloader+","+numChildren);
			//this.setChildIndex(preloader,(numChildren – 1));
		}
		
		
		
		//-----------------------------------------------------
		private function loading(e:Event):void
		{
			var total:Number = this.stage.loaderInfo.bytesTotal;
			var loaded:Number = this.stage.loaderInfo.bytesLoaded;
			var per:Number=Math.floor((loaded/total)*100);
			//log.text+=""+per+"|";
			//trace(loaded+"/"+total);
			preloader.mcBar.scaleX = loaded/total;
			preloader.txtLoading.text = ""+per+ "%";
			//trace(per+ "%");
			if (loaded>=total)
			{				
				preloader.txtLoading.text="Loading audios....";								
				this.removeEventListener(Event.ENTER_FRAME, loading);
				
				audioLib.getInstance().preloadAudio(OnPRELOAD_AUDIO_COMPLETED);
				
			}
			
		}		
		//-----------------------------------------------------
		public function OnPRELOAD_AUDIO_COMPLETED():void
		{
			trace("OnPRELOAD_AUDIO_COMPLETED");
			preloader.visible=false;
			preloader.homebgscreencast.visible=false;
			InitializeApp();				
		}
		//-----------------------------------------------------
		private function InitializeApp():void
		{
			//get facade instance
			var facade:StoryCreationFacade = StoryCreationFacade.getInstance();
			//stage will be the viewcomponent to the mediator			
			//facade.startup(this.stage);
			facade.startup(this);
		}
		
	}
}
