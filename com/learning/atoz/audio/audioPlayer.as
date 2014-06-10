package com.learning.atoz.audio
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	//SoundMixer.stopAll();
	
	public class audioPlayer
	{
		private var sndObj:Sound;
		private var channel:SoundChannel;
		private var _position:Number;
		private var _volume:Number;
		private var _paused:Boolean;
		// singleton instance
		private static var _instance:audioPlayer;
		private static var _allowInstance:Boolean;
				
		public function audioPlayer()
		{
			
		}
		
		public static function getInstance():audioPlayer 
		{
			if (audioPlayer._instance == null)
			{
				audioPlayer._allowInstance = true;
				audioPlayer._instance = new audioPlayer();
				audioPlayer._allowInstance = false;
			}
			
			return audioPlayer._instance;
		}		
		
		public function loadAudio(audfile:String)
		{
			if(channel!=null)
			{
				channel.stop();
				channel=null;
			}			
			if(sndObj!=null)
			{
				//sndObj.close();
				sndObj=null;
			}
			
			sndObj = new Sound();			
			_position=0;
			_volume=1;
			sndObj.addEventListener(ProgressEvent.PROGRESS, onLoadProgress); 
			sndObj.addEventListener(Event.COMPLETE, onLoadComplete); 
			sndObj.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
			 
			var req:URLRequest = new URLRequest(audfile);
			sndObj.load(req);			
			
			
		} 
		
		public function loadSoundObject(obj:Object)
		{			
			if(channel!=null)
			{
				channel.stop();
				channel=null;
			}
			
			if(obj.soundobject!=null)
			{				
				//sndObj.close();
				sndObj = new Sound();	
				sndObj=obj.soundobject;
				_position=0;
				_volume=1;
				playSound();
			}
			else
			{
				sndObj = new Sound();			
				_position=0;
				_volume=1;
				sndObj.addEventListener(ProgressEvent.PROGRESS, onLoadProgress); 
				sndObj.addEventListener(Event.COMPLETE, onLoadComplete); 
				sndObj.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
				
				var req:URLRequest = new URLRequest(obj.url);
				sndObj.load(req);
				
			}
			
			
		} 
		
		public function playSound()
		{
			 channel = new SoundChannel();
			 channel = sndObj.play(_position);
			 channel.addEventListener(Event.SOUND_COMPLETE, ONSoundPlayComplete);			 
		}
		
		public function stopSound():void
		{
			if(channel!=null)
			{
				channel.stop();				
			}		
		}
		
		
		public function pauseSound():void
		{			
			_paused = true;
			_position = channel.position;
			channel.stop();
		}
		
		
		public function muteAllSounds():void
		{
			if(channel!=null)
			{
				var curTransform:SoundTransform = channel.soundTransform;
				curTransform.volume =0;
				channel.soundTransform = curTransform;
			}
			
			
		}
		
		
		public function unmuteAllSounds():void
		{
			if(channel!=null)
			{
				var curTransform:SoundTransform = channel.soundTransform;
				curTransform.volume =_volume;
				channel.soundTransform = curTransform;
			}
			
		}
		

 		function ONSoundPlayComplete($evt:Event):void
		{ 
			
			//sndObj.close();
			channel.removeEventListener(Event.SOUND_COMPLETE, ONSoundPlayComplete);
		   
		}
			
		function onLoadProgress(event:ProgressEvent):void 
		{ 
			var loadedPct:uint = Math.round(100 * (event.bytesLoaded / event.bytesTotal));
			
			sndObj.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		} 
		 
		function onLoadComplete(event:Event):void 
		{ 
			//var localSound:Sound = event.target as Sound; 
			//localSound.play(); 
			sndObj.removeEventListener(Event.COMPLETE, onLoadComplete); 
			playSound();
		} 
		function onIOError(event:IOErrorEvent) 
		{ 
			sndObj.removeEventListener(IOErrorEvent.IO_ERROR, onIOError); 
		}
		
		
		

	}
	
}
