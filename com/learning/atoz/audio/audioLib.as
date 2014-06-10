package com.learning.atoz.audio
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	/*
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	*/
	
	public class audioLib
	{
		//-----------------------------------------------------------------------------------------
		public static var BTN_LAYOUT=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_Layouts.mp3";
		public static var BTN_BACKGROUND=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_Backgrounds.mp3";
		public static var BTN_OBJECTS=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_CharactersObjects.mp3";
		public static var BTN_CHARACTERS=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_CharactersObjects.mp3";
		public static var BTN_TEXT=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_Text.mp3";
		//-----------------------------------------------------------------------------------------
		
		public static var BTN_WRITING_PLANNER=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_WritingPlanner.mp3";
		public static var BTN_STORY_STARTERS=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_StoryStarters.mp3";
		public static var BTN_SEND_TEACHER=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_SendTeacher.mp3";
		public static var BTN_DONE=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_buttonlabels/AT_button_Done.mp3";
		public static var BTN_CHECKLIST=ApplicationConstants.ASSETS_PATH+"assets/Audio/AT_revchlistdirections/AT_revchlistdir.mp3";
		
		//-----------------------------------------------------------------------------------------
		// singleton instance
		private static var _instance:audioLib;
		private static var _allowInstance:Boolean;
		//-----------------------------------------------------------------------------------------
		private var preloadAudioList:Array;
		private var sndobj:Sound;
		private var curVal:int=-1;
		private var req:URLRequest;		
		private var preloadComplete:Function;
		
		public function audioLib()
		{
		}		
		
		public static function getInstance():audioLib 
		{
			if (audioLib._instance == null)
			{
				audioLib._allowInstance = true;
				audioLib._instance = new audioLib();
				audioLib._allowInstance = false;
			}
			
			return audioLib._instance;
		}		
		//-----------------------------------------------------------------------------------------
		public function playAudio(audioFile:String)
		{
			audioPlayer.getInstance().loadAudio(audioFile);			
		}
		//-----------------------------------------------------------------------------------------
		public function playSound(id:String)
		{
			var _sndobj:Object;
			for(var r:int=0;r<preloadAudioList.length;r++)
			{
				if(preloadAudioList[r].id==id)
				{
					_sndobj=preloadAudioList[r];
				}
			}
						
			audioPlayer.getInstance().loadSoundObject(_sndobj);
		}
		//-----------------------------------------------------------------------------------------
		public function preloadAudio(_preloadComplete:Function)
		{
			preloadComplete=_preloadComplete;
			preloadAudioList=new Array();
			preloadAudioList.push({id:"LAYOUT_AUDIO",soundobject:null,url:BTN_LAYOUT});
			preloadAudioList.push({id:"BACKGROUND_AUDIO",soundobject:null,url:BTN_BACKGROUND});
			preloadAudioList.push({id:"OBJECTS_AUDIO",soundobject:null,url:BTN_OBJECTS});
			preloadAudioList.push({id:"CHARACTERS_AUDIO",soundobject:null,url:BTN_CHARACTERS});
			preloadAudioList.push({id:"TEXT_AUDIO",soundobject:null,url:BTN_TEXT});
			preloadAudioList.push({id:"WRITING_PLANNER_AUDIO",soundobject:null,url:BTN_WRITING_PLANNER});
			preloadAudioList.push({id:"STORY_STARTERS_AUDIO",soundobject:null,url:BTN_STORY_STARTERS});
			preloadAudioList.push({id:"SEND_TEACHER_AUDIO",soundobject:null,url:BTN_SEND_TEACHER});
			preloadAudioList.push({id:"DONE_AUDIO",soundobject:null,url:BTN_DONE});			
			preloadAudioList.push({id:"BTN_CHECKLIST",soundobject:null,url:BTN_CHECKLIST});
			
			curVal=-1;
			loadAudioRecursive();
		}		
		//-----------------------------------------------------------------------------------------
		private function loadAudioRecursive():void
		{			
			if((curVal+1)<preloadAudioList.length)
			{
				curVal++;
				sndobj = new Sound();				 
				sndobj.addEventListener(Event.COMPLETE, onLoadComplete); 
				sndobj.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				req = new URLRequest(preloadAudioList[curVal].url);
				sndobj.load(req);				
			}
			else
			{				
				if(preloadComplete!=null)
				{			   
					preloadComplete();
				}
			}
		}
		//-----------------------------------------------------------------------------------------
		private function onLoadComplete(event:Event):void 
		{ 
			preloadAudioList[curVal].soundobject=sndobj;
			sndobj.removeEventListener(Event.COMPLETE, onLoadComplete); 
			loadAudioRecursive();
		} 
		private function onIOError(event:IOErrorEvent) 
		{ 			
			sndobj.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loadAudioRecursive();
		}
		//-----------------------------------------------------------------------------------------
		
	}
}