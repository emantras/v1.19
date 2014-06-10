package com.learning.atoz.storycreation.view.components.events
{
	import flash.events.Event;	
	public class BgThumbEvent extends Event
	{
		public var bgUrl:String;
		public function BgThumbEvent(type:String,bgurl:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			bgUrl=bgurl;
			super(type, bubbles, cancelable);
		}
		
	}
	
}
