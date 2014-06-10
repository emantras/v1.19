package com.learning.atoz.storycreation.model.vo
{	
	public class PageVo
	{		
		public var ID:String;
		public var TYPE:String;
		public var PAGENO:int;
		public var BGURL:String="";
		public var BOOKTITLE:String="Book Title";
		public var booktitle_xpos:int=0;
		public var booktitle_ypos:int=0;
		public var booktitle_width:int=0;
		public var booktitle_height:int=0;
		//public var characterList:Array;
		//public var objectList:Array;
		//public var callouttextList:Array;
		public var dataList:Array;
		public var layoutid:int=4;
		public var layouttext:String;
		public var bgdata:Object={unqid:"",id:0,name:"",catid:0,subcatid:0,url:"",thumburl:"",type:"BACKGROUND",xpos:0,ypos:0,width:0,height:0,rotation:0,scalex:1,scaley:1};		
		//{unqid:"",id:0,name:"",catid:0,subcatid:0,url:"",thumburl:"",type:"BACKGROUND",xpos:0,ypos:0,width:0,height:0,rotation:0};
		//---------------------------------------------------------
		public function PageVo()
		{
			
		}
		
		//---------------------------------------------------------
		public function set Id(_id:String):void
		{
			ID=_id;
		}
		//---------------------------------------------------------
		public function get Id():String
		{
			return ID;
		}
		//---------------------------------------------------------
		
		public function getDataByControlType(type:String):Array
		{
			var obj:Object = new Object();
			obj.controltype=type;
			
			var filterFunction:Function = function(element:*, index:int, arr:Array):Boolean {
				return element.controltype==this.controltype;
			}
			
			return dataList.filter(filterFunction, obj);
		}   
		
		public function getDataByType(type:String):Array
		{
			var obj:Object = new Object();
			obj.type=type;
			
			var filterFunction:Function = function(element:*, index:int, arr:Array):Boolean {
				return element.type==this.type;
			}
			
			return dataList.filter(filterFunction, obj);
		}    
		//---------------------------------------------------------
		public function set Type(_type:String):void
		{
			TYPE=_type;
		}
		//---------------------------------------------------------
		public function get Type():String
		{
			return TYPE;
		}
		//---------------------------------------------------------
		
		
		//---------------------------------------------------------
		public function set Pageno(_pno:int):void
		{
			PAGENO=_pno;
		}		
		public function get Pageno():int
		{
			return PAGENO;
		}
		//---------------------------------------------------------
		
		
		//---------------------------------------------------------
		public function set Bgurl(burl:String):void
		{
			BGURL=burl;
		}		
		public function get Bgurl():String
		{
			return BGURL;
		}
		//---------------------------------------------------------
		
		//---------------------------------------------------------
		public function set BgData(_bgdata:Object):void
		{
			bgdata=_bgdata;
		}		
		public function get BgData():Object
		{
			return bgdata;
		}
		//---------------------------------------------------------
		
		//---------------------------------------------------------
		public function set Booktitle(btitle:String):void
		{
			BOOKTITLE=btitle;
		}		
		public function get Booktitle():String
		{
			return BOOKTITLE;
		}
		//---------------------------------------------------------

	}
	
}

