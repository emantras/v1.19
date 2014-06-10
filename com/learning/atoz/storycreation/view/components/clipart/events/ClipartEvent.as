package com.learning.atoz.storycreation.view.components.clipart.events
{
	import flash.events.Event;	
	public class ClipartEvent extends Event
	{
		public var objdata:Object;
		public function ClipartEvent(type:String,_objdata:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			objdata=_objdata;
			super(type, bubbles, cancelable);
		}
		
	}
	
}
	