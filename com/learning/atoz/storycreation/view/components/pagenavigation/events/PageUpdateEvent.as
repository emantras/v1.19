package com.learning.atoz.storycreation.view.components.pagenavigation.events
{
	import flash.events.Event;
	
	public class PageUpdateEvent extends Event
	{				
		public var _oldpageno:int;
		public var _newpageno:int;		
		public function PageUpdateEvent(type:String,oldpageno:int,pageno:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{			
			_oldpageno=oldpageno;
			_newpageno=pageno;
			super(type, bubbles, cancelable);
		}
		
		

	}
	
}
