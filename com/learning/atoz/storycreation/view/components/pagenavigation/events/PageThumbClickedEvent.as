package com.learning.atoz.storycreation.view.components.pagenavigation.events
{
	import flash.events.Event;
	
	public class PageThumbClickedEvent extends Event
	{				
		public var _pageno:int;
		public function PageThumbClickedEvent(type:String,pageno:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{			
			_pageno=pageno;
			super(type, bubbles, cancelable);
		}
		
		

	}
	
}
