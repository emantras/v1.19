package com.learning.atoz.storycreation.view.components.pagenavigation.events
{
	import flash.events.Event;
	
	public class PageDeleteEvent extends Event
	{				
		public var _pageno:int;
		public function PageDeleteEvent(type:String,pageno:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{			
			_pageno=pageno;
			super(type, bubbles, cancelable);
		}
		
		

	}
	
}
