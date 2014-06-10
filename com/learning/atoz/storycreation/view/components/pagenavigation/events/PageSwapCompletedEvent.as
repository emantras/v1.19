package com.learning.atoz.storycreation.view.components.pagenavigation.events
{
	import flash.events.Event;
	
	public class PageSwapCompletedEvent extends Event
	{		
		public var _scid:String;
		public var _tcid:String;
		public var _p1:int;
		public var _p2:int;
		public var _p3:int;
		public var _p4:int;
		
		public function PageSwapCompletedEvent(type:String,scid:String,p1:int,p2:int,tcid:String,p3:int,p4:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_scid=scid;
			_p1=p1;
			_p2=p2;
			_tcid=tcid;
			_p3=p3;
			_p4=p4;			
			super(type, bubbles, cancelable);
		}
		
		

	}
	
}
