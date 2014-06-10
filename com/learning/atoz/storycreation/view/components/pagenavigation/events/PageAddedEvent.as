package com.learning.atoz.storycreation.view.components.pagenavigation.events
{
	import flash.events.Event;
	
	public class PageAddedEvent extends Event
	{		
		public var _id:String;
		public var _type:String;
		public var _ptype:String;
		public var _pageno:int;
		public function PageAddedEvent(type:String,id:String,ptype:String,pageno:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_id=id;
			_type=type;
			_ptype=ptype;
			_pageno=pageno;
			super(type, bubbles, cancelable);
		}
		
		

	}
	
}
