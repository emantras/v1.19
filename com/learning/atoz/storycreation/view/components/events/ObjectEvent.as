package com.learning.atoz.storycreation.view.components.events
{
	import flash.events.Event;	
	public class ObjectEvent extends Event
	{
		public var objdata:Object;
		public function ObjectEvent(type:String,_objdata:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			objdata=_objdata;
			super(type, bubbles, cancelable);
		}
		
	}
	
}
