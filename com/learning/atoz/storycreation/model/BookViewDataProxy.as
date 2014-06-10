package com.learning.atoz.storycreation.model
{
	import com.adobe.serialization.json.JSON;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.model.vo.PageVo;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/*
	import com.learning.atoz.storycreation.model.vo.PageVo;
	
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.adobe.serialization.json.JSON;
	*/
	/*
	BookViewDataProxy is used to maintain each page information 
	*/
	
	public class BookViewDataProxy extends Proxy implements IProxy
	{
		
		public static const NAME:String = "BookViewDataProxy";
		private var _data:Array;
		private var _currentPage:int=0;
		private var bookID:Number=0;
		private var appData:Object={bg_more:{catid:0,subcatid:0},chr_more:{catid:0,subcatid:0},obj_more:{catid:0,subcatid:0}};
		
		private var pageClipboardData:PageVo;
		
		//-----------------------------------------------------		
		public function BookViewDataProxy() 
        {
            super ( NAME);            
			_data=new Array();            
        }
		//-----------------------------------------------------
        		
		//-----------------------------------------------------		
		// this is an overriden inherited function from PureMVC
		//-----------------------------------------------------
		override public function getProxyName():String
		{
			return NAME;
		}		
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		//to store current pageno
		//-----------------------------------------------------		
		public function set currentPage(cp:int):void
		{
			_currentPage=cp;
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//to retrieve current pageno
		//-----------------------------------------------------
		public function get currentPage():int
		{
			return _currentPage;
		}
		//-----------------------------------------------------
		
		public function set BookID(_bookid:Number):void
		{
			bookID=_bookid;
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//to retrieve current pageno
		//-----------------------------------------------------
		public function get BookID():Number
		{
			return bookID;
		}
		//-----------------------------------------------------
		
		public function copyPage(_pageno:int):void
		{	
			
			for(var r:int=0;r<_data.length;r++)
			{
				
				if(_data[r].Pageno==_pageno)
				{
					
					if(_data[r].Bgurl.length>0 || _data[r].characterList.length>0 || _data[r].objectList.length>0 || _data[r].callouttextList.length>0)
					{
					
						pageClipboardData=new PageVo();
						pageClipboardData.Id="-100";
						pageClipboardData.Type="clipboard";
						pageClipboardData.Pageno=_data[r].Pageno;
						
						//---------------------------------------------
						pageClipboardData.Bgurl=_data[r].Bgurl;
						for(var dv4 in _data[r].bgdata)
						{
							pageClipboardData.bgdata[dv4]=_data[r].bgdata[dv4];
						}					
						//---------------------------------------------						
						pageClipboardData.Booktitle=_data[r].Booktitle;				
						
						//---------------------------------------------
						pageClipboardData.dataList=new Array();
						for(var dv1:int=0;dv1<_data[r].dataList.length;dv1++)
						{
							//pageClipboardData.dataList.push(_data[r].dataList[dv1]);
							var dataobj:Object=new Object();
							for(var dv5 in _data[r].dataList[dv1])
							{								
								dataobj[dv5]=_data[r].dataList[dv1][dv5];
							}	
							pageClipboardData.dataList.push(dataobj);
						}
						//---------------------------------------------
												
						
						pageClipboardData.layoutid=_data[r].layoutid;
						pageClipboardData.layouttext=_data[r].layouttext;
						//facade.sendNotification(ApplicationConstants.ENABLE_PASTE);
						facade.sendNotification(ApplicationConstants.COPY_TASK_COMPLETED);
						
						facade.sendNotification(ApplicationConstants.ADD_PAGE);
						facade.sendNotification(ApplicationConstants.PASTE_PAGE);
					}
					break;
				}
			}
		}
		
		public function pastePage(_pageno:int):void
		{	
			
			if(pageClipboardData!=null && pageClipboardData.Pageno!=_pageno)
			{			
				
				if(pageClipboardData.Bgurl.length>0 || pageClipboardData.dataList.length>0)
				{
					
					for(var r:int=0;r<_data.length;r++)
					{
						
						if(_data[r].Pageno==_pageno)
						{
							
							//---
							
							//---------------------------------------------
							_data[r].Bgurl=pageClipboardData.Bgurl;
							for(var dv4 in pageClipboardData.bgdata)
							{
								_data[r].bgdata[dv4]=pageClipboardData.bgdata[dv4];
							}					
							//---------------------------------------------
							
							_data[r].Booktitle=pageClipboardData.Booktitle;				
							
							//---------------------------------------------
							_data[r].dataList=new Array();
							for(var dv1:int=0;dv1<pageClipboardData.dataList.length;dv1++)
							{
								//_data[r].dataList.push(pageClipboardData.dataList[dv1]);
								var dataobj:Object=new Object();
								for(var dv5 in pageClipboardData.dataList[dv1])
								{								
									dataobj[dv5]=pageClipboardData.dataList[dv1][dv5];
								}	
								_data[r].dataList.push(dataobj);
							}
							//---------------------------------------------
							_data[r].layoutid=pageClipboardData.layoutid;
							_data[r].layouttext=pageClipboardData.layouttext;
							facade.sendNotification(ApplicationConstants.UPDATE_CANVAS);
							facade.sendNotification(ApplicationConstants.UPDATE_PAGETHUMB_BG,{pageno:_data[r].Pageno,thumburl:_data[r].bgdata.thumburl});
							facade.sendNotification(ApplicationConstants.PASTE_TASK_COMPLETED);
							//---
							
						}
					}
				}
			}
		}
		//-----------------------------------------------------
		//to store newpage
		//-----------------------------------------------------
		public function addPage(Id:String,_type:String,_pageno:int):Boolean
		{
			var success:Boolean=false;
			if(checkAlreadyExists(_pageno)==false)
			{			
				success=true;
				var prec:PageVo=new PageVo();
				prec.Id=Id;
				prec.Type=_type;
				prec.Pageno=_pageno;
				prec.Bgurl="";
				prec.Booktitle="Book Title";				
								
				prec.dataList=new Array();
				prec.layoutid=4;
				prec.layouttext="";
				_data.push(prec);
				
			}			
			return success;
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		//update the swap page info
		//-----------------------------------------------------
		public function SwapPage(fromuid:String,fromPageno:int,touid:String,toPageno:int):void
		{
			var fres:int=searchUID(fromuid);
			var tres:int=searchUID(touid);			
			if(fres>=0 && tres>=0)
			{
				_data[fres].Pageno=toPageno;
				_data[tres].Pageno=fromPageno;				
			}
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		//search page by unique page id
		//-----------------------------------------------------
		private function searchUID(uid:String):int
		{
			var idx:Number=-1;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Id==uid)
				{
					idx=r;
					break;
				}
			}
			return idx;
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		//to update pageno
		//-----------------------------------------------------
		public function updatePageNo(oldpageno:int,newpageno:int):void
		{	
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==oldpageno)
				{
					_data[r].Pageno=newpageno;
					break;
				}
			}			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//to retrieve max page no
		//-----------------------------------------------------
		public function getMaxPageNo():int
		{
			var maxpageno:int=0;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno>maxpageno)
				{
					maxpageno=_data[r].Pageno;
				}
			}						
			return maxpageno;
		}
		//-----------------------------------------------------
		public function getPageCount():int
		{								
			return _data.length;
		}
		
		//-----------------------------------------------------
		//to delete page information from the collection
		//-----------------------------------------------------
		public function deletePage(_pageno:int):Boolean
		{			
			var success:Boolean=false;
			for(var r:int=0;r<_data.length;r++)
			{				
				if(_data[r].Pageno==_pageno)
				{					
					_data.splice(r,1);
					success=true;
					break;
				}
			}
			return success;
		}	
		//-----------------------------------------------------
		//-----------------------------------------------------
		//-----------------------------------------------------
		public function updateLayoutText(layouttext:String,_pageno:int):void
		{			
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					_data[r].layouttext=layouttext;
					break;
				}
			}			
		}
		//-----------------------------------------------------
		public function getCurrentLayoutText(_pageno:int):String
		{			
			var layouttext:String="";
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					layouttext=_data[r].layouttext;
					break;
				}
			}
			return layouttext;
		}
		//-----------------------------------------------------
		//-----------------------------------------------------
		public function updateLayoutID(layoutid:int,_pageno:int):void
		{			
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					_data[r].layoutid=layoutid;
					break;
				}
			}			
		}
		//-----------------------------------------------------
		public function getCurrentLayoutID(_pageno:int):int
		{			
			var layoutid:int=4;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					layoutid=_data[r].layoutid;
					break;
				}
			}
			return layoutid;
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//to store background url of the specified pageno
		//-----------------------------------------------------
		public function addBGUrl(bgdata:Object,_bgurl:String,_pageno:int):void
		{
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					_data[r].Bgurl=_bgurl;
					_data[r].BgData=bgdata;
					break;
				}
			}			
		}		
		//-----------------------------------------------------
				
		//-----------------------------------------------------
		//to retrieve background url of the specified pageno
		//-----------------------------------------------------
		public function getBGUrl(_pageno:int):String
		{			
			var url:String="";
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					url=_data[r].Bgurl;					
					break;
				}
			}
			return url;
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//to retrieve background url of the specified pageno
		//-----------------------------------------------------
		public function getBGData(_pageno:int):Object
		{			
			var url:Object=null;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					url=_data[r];					
					break;
				}
			}
			return url;
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//to store page title of the front cover
		//-----------------------------------------------------
		public function setBookTitle(_title:String,xp:int,yp:int,w:Number,h:Number,_pageno:int):void
		{	
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					if(_title.length>0)
					{
						_data[r].booktitle_xpos=xp;
						_data[r].booktitle_ypos=yp;
						_data[r].booktitle_width=w;
						_data[r].booktitle_height=h;
						_data[r].Booktitle=_title;
					}
					else
					{
						_data[r].Booktitle="Book Title";
						_data[r].booktitle_xpos=xp;
						_data[r].booktitle_ypos=yp;
						_data[r].booktitle_width=w;
						_data[r].booktitle_height=h;
					}
														
					break;
				}
			}			
		}
		
		public function getBookTitle(_pageno:int):String
		{			
			var ret:String="";
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					ret=_data[r].Booktitle;			
					break;
				}
			}
			return ret;
		}
		
		public function getBookTitleWidth(_pageno:int):int
		{			
			var ret:int=0;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					ret=_data[r].booktitle_width;		
					break;
				}
			}
			return ret;
		}
		public function getBookTitleHeight(_pageno:int):int
		{			
			var ret:int=0;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					ret=_data[r].booktitle_height;	
					break;
				}
			}
			return ret;
		}
		public function getBookTitleX(_pageno:int):int
		{			
			var ret:int=0;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					ret=_data[r].booktitle_xpos;		
					break;
				}
			}
			return ret;
		}
		public function getBookTitleY(_pageno:int):int
		{			
			var ret:int=0;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					ret=_data[r].booktitle_ypos;		
					break;
				}
			}
			return ret;
		}
		//-----------------------------------------------------
		public function getDataList(_pageno:int):Array
		{			
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					_data[r].dataList.sortOn("level", Array.NUMERIC);
					return _data[r].dataList;				
				}
			}
			
			return null;
		}
		//-----------------------------------------------------
		//to check whether the specified pageno already exists
		//-----------------------------------------------------
		public function checkAlreadyExists(_pageno:int):Boolean
		{
			var found:Boolean=false;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					found=true;
					break;
				}
			}
			return found;
		}
		//========
		//-----------------------------------------------------
		public function InsertCalloutText(_pageno:int,caltxtdata:Object)
		{
			var found:Boolean=checkCALOUTTXTAlreadyExists(_pageno,caltxtdata);
			if(found==false)
			{
				for(var r:int=0;r<_data.length;r++)
				{
					if(_data[r].Pageno==_pageno)
					{
						_data[r].dataList.push(caltxtdata);
					}
				}
			}			
		}
		//-----------------------------------------------------
		public function UpdateCalloutText(_pageno:int,caltxtdata:Object)
		{
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					for(var j:int=0;j<_data[r].dataList.length;j++)
					{
						if(_data[r].dataList[j].unqid==caltxtdata.unqid)
						{
							_data[r].dataList[j]=caltxtdata;								
							break;
						}
					}
					break;
				}
			}		
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		public function RemoveCalloutText(_pageno:int,caltxtdata:Object)
		{
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					for(var j:int=0;j<_data[r].dataList.length;j++)
					{
						if(_data[r].dataList[j].unqid==caltxtdata.unqid)
						{
							_data[r].dataList.splice(j,1);						
							break;
						}
					}
					break;
				}
			}		
		}
		public function checkCALOUTTXTAlreadyExists(_pageno:int,calltxtdata:Object):Boolean
		{			
			var found:Boolean=false;
			for(var r:int=0;r<_data.length;r++)
			{				
				if(_data[r].Pageno==_pageno)
				{					
					for(var j:int=0;j<_data[r].dataList.length;j++)
					{						
						if(_data[r].dataList[j].unqid==calltxtdata.unqid)
						{
							found=true;
							break;
						}
					}
					break;
				}
			}
			return found;
		}
		///=======
		//-----------------------------------------------------
		public function InsertCharacter(_pageno:int,chrdata:Object)
		{
			var found:Boolean=checkCHRAlreadyExists(_pageno,chrdata);		
			if(found==false)
			{
				for(var r:int=0;r<_data.length;r++)
				{
					if(_data[r].Pageno==_pageno)
					{
						_data[r].dataList.push(chrdata);
					}
				}
			}			
			
			
		}
		//-----------------------------------------------------
		public function UpdateCharacter(_pageno:int,chrdata:Object)
		{	
			//trace("UpdateCharacter=>w:"+chrdata.width+",h:"+chrdata.height+",rot:"+chrdata.rotation);
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{					
					for(var j:int=0;j<_data[r].dataList.length;j++)
					{					
						if(_data[r].dataList[j].unqid==chrdata.unqid)
						{	
							_data[r].dataList[j]=chrdata;								
							break;
						}
					}
					break;
				}
			}	
		}
		
		public function UpdateData(_pageno:int,chrdata:Object)
		{	
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{					
					for(var j:int=0;j<_data[r].dataList.length;j++)
					{					
						if(_data[r].dataList[j].unqid==chrdata.unqid)
						{	
							_data[r].dataList[j]=chrdata;								
							break;
						}
					}
					break;
				}
			}	
		}
		//-----------------------------------------------------
		/*public function getCharacterList(_pageno:int):Array
		{			
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					return _data[r].getDataByType("CHARACTER");					
				}
			}
			
			return null;
		}
		
		public function getObjectList(_pageno:int):Array
		{			
		for(var r:int=0;r<_data.length;r++)
		{
		if(_data[r].Pageno==_pageno)
		{
		return _data[r].getDataByType("OBJECT");			
		}
		}
		
		return null;
		}*/
		
		public function getCalloutTextList(_pageno:int):Array
		{			
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					return _data[r].getDataByType("CALLOUTTEXT");				
				}
			}
			
			return null;
		}
		//-----------------------------------------------------
		public function RemoveCharacter(_pageno:int,chrdata:Object)
		{
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					for(var j:int=0;j<_data[r].dataList.length;j++)
					{
						if(_data[r].dataList[j].unqid==chrdata.unqid)
						{
							_data[r].dataList.splice(j,1);						
							break;
						}
					}
					break;
				}
			}		
		}
		//-----------------------------------------------------
		//to check whether the specified pageno already exists
		//-----------------------------------------------------
		public function checkCHRAlreadyExists(_pageno:int,chrdata:Object):Boolean
		{	
			var found:Boolean=false;
			for(var r:int=0;r<_data.length;r++)
			{				
				if(_data[r].Pageno==_pageno)
				{
					for(var j:int=0;j<_data[r].dataList.length;j++)
					{
						if(_data[r].dataList[j].unqid==chrdata.unqid)
						{
							found=true;
							break;
						}
					}
					break;
				}
			}
			return found;
		}
		//-----------------------------------------------------
		public function InsertObject(_pageno:int,objdata:Object)
		{
			var found:Boolean=checkOBJAlreadyExists(_pageno,objdata);
			if(found==false)
			{
				
				for(var r:int=0;r<_data.length;r++)
				{
					if(_data[r].Pageno==_pageno)
					{
						_data[r].dataList.push(objdata);
					}
				}
			}			
		}
		//-----------------------------------------------------
		public function UpdateObject(_pageno:int,objdata:Object)
		{
			//trace("UpdateObject=>w:"+objdata.width+",h:"+objdata.height+",rot:"+objdata.rotation);
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					for(var j:int=0;j<_data[r].dataList.length;j++)
						{
							if(_data[r].dataList[j].unqid==objdata.unqid)
							{
								_data[r].dataList[j]=objdata;													
								break;
							}
						}
						break;
						}
			}		
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		public function RemoveObject(_pageno:int,objdata:Object)
		{
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					for(var j:int=0;j<_data[r].dataList.length;j++)
						{
							if(_data[r].dataList[j].unqid==objdata.unqid)
							{
								_data[r].dataList.splice(j,1);						
								break;
							}
						}
						break;
						}
			}		
		}
		//-----------------------------------------------------
		//to check whether the specified pageno already exists
		//-----------------------------------------------------
		public function checkOBJAlreadyExists(_pageno:int,objdata:Object):Boolean
		{
			var found:Boolean=false;
			for(var r:int=0;r<_data.length;r++)
			{
				if(_data[r].Pageno==_pageno)
				{
					for(var j:int=0;j<_data[r].dataList.length;j++)
						{
							if(_data[r].dataList[j].unqid==objdata.unqid)
							{
								found=true;
								break;
							}
						}
						break;
						}
			}
			return found;
		}
		//-----------------------------------------------------
		
		private function getAppDataString():String
		{			
			var appdatastr:String = JSON.encode(appData);
			return appdatastr;
		}
		
		public function getAppData():Object
		{		
			return appData;
		}
		
		public function setAppDataObject(adobj:Object):void
		{		
			appData=adobj;
		}
		
		
		public function setAppData(sappdata:String):void
		{			
			appData=JSON.decode(sappdata);			
		}
		
		//-----------------------------------------------------
		//savebookdata
		//-----------------------------------------------------
		public function getBookData():String
		{
			
			var bookdata:String="<bookdata>";
			
			
			bookdata+="<book_id>"+bookID+"</book_id>";
			
						
			bookdata+="<appdata>"+getAppDataString()+"</appdata>";
			
			for(var r:int=0;r<_data.length;r++)
			{				
				bookdata+="<page id='"+_data[r].Id+"' type='"+_data[r].Type+"' pageno='"+_data[r].Pageno+"'>";
				if(Number(_data[r].Pageno)==0)
				{
					bookdata+="<booktitle>"+_data[r].Booktitle+"</booktitle>";
					bookdata+="<booktitle_xpos>"+_data[r].booktitle_xpos+"</booktitle_xpos>";
					bookdata+="<booktitle_ypos>"+_data[r].booktitle_ypos+"</booktitle_ypos>";
					bookdata+="<booktitle_width>"+_data[r].booktitle_width+"</booktitle_width>";
					bookdata+="<booktitle_height>"+_data[r].booktitle_height+"</booktitle_height>";
				}
				
				bookdata+="<layout>";	
				bookdata+="<layoutid>"+getCurrentLayoutID(_data[r].Pageno)+"</layoutid>";
				bookdata+="<layouttext>"+getCurrentLayoutText(_data[r].Pageno)+"</layouttext>";
				bookdata+="</layout>";
				
				if(_data[r].BgData!=null)
				{
					bookdata+="<background>";				
					bookdata+="<BgId>"+_data[r].BgData.id+"</BgId>";
					bookdata+="<name>"+_data[r].BgData.name+"</name>";
					bookdata+="<catid>"+_data[r].BgData.catid+"</catid>";
					bookdata+="<subcatid>"+_data[r].BgData.subcatid+"</subcatid>";
					bookdata+="<url>"+_data[r].BgData.url+"</url>";
					bookdata+="<thumburl>"+_data[r].BgData.thumburl+"</thumburl>";					
					bookdata+="</background>";
				}
				
				
				bookdata+="<datalist>";
				
				for(var j:int=0;j<_data[r].dataList.length;j++)
				{					
					bookdata+="<data>";
					if(_data[r].dataList[j].type=="CHARACTER")
					{
						bookdata+="<ChrId>"+_data[r].dataList[j].id+"</ChrId>";
						bookdata+="<name>"+_data[r].dataList[j].name+"</name>";
						bookdata+="<catid>"+_data[r].dataList[j].catid+"</catid>";
						bookdata+="<subcatid>"+_data[r].dataList[j].subcatid+"</subcatid>";
						bookdata+="<url>"+_data[r].dataList[j].url+"</url>";
						bookdata+="<thumburl>"+_data[r].dataList[j].thumburl+"</thumburl>";
						bookdata+="<type>"+_data[r].dataList[j].type+"</type>";
						bookdata+="<xpos>"+_data[r].dataList[j].xpos+"</xpos>";
						bookdata+="<ypos>"+_data[r].dataList[j].ypos+"</ypos>";
						bookdata+="<width>"+_data[r].dataList[j].width+"</width>";
						bookdata+="<height>"+_data[r].dataList[j].height+"</height>";
						bookdata+="<rotation>"+_data[r].dataList[j].rotation+"</rotation>";
						bookdata+="<scalex>"+_data[r].dataList[j].scalex+"</scalex>";
						bookdata+="<scaley>"+_data[r].dataList[j].scaley+"</scaley>";
						bookdata+="<flip>"+_data[r].dataList[j].flip+"</flip>";
						bookdata+="<level>"+_data[r].dataList[j].level+"</level>";
					}
					else if(_data[r].dataList[j].type=="OBJECT")
					{
						bookdata+="<ObjId>"+_data[r].dataList[j].id+"</ObjId>";
						bookdata+="<name>"+_data[r].dataList[j].name+"</name>";
						bookdata+="<catid>"+_data[r].dataList[j].catid+"</catid>";
						bookdata+="<subcatid>"+_data[r].dataList[j].subcatid+"</subcatid>";
						bookdata+="<url>"+_data[r].dataList[j].url+"</url>";
						bookdata+="<thumburl>"+_data[r].dataList[j].thumburl+"</thumburl>";
						bookdata+="<type>"+_data[r].dataList[j].type+"</type>";
						bookdata+="<xpos>"+_data[r].dataList[j].xpos+"</xpos>";
						bookdata+="<ypos>"+_data[r].dataList[j].ypos+"</ypos>";
						bookdata+="<width>"+_data[r].dataList[j].width+"</width>";
						bookdata+="<height>"+_data[r].dataList[j].height+"</height>";
						bookdata+="<rotation>"+_data[r].dataList[j].rotation+"</rotation>";
						bookdata+="<scalex>"+_data[r].dataList[j].scalex+"</scalex>";
						bookdata+="<scaley>"+_data[r].dataList[j].scaley+"</scaley>";
						bookdata+="<flip>"+_data[r].dataList[j].flip+"</flip>";
						bookdata+="<level>"+_data[r].dataList[j].level+"</level>";
					}
					else if(_data[r].dataList[j].type=="CALLOUTTEXT")
					{
						bookdata+="<TextId>"+_data[r].dataList[j].id+"</TextId>";						
						bookdata+="<type>"+_data[r].dataList[j].type+"</type>";
						bookdata+="<controltype>"+_data[r].dataList[j].controltype+"</controltype>";
						bookdata+="<skin>"+_data[r].dataList[j].skin+"</skin>";
						bookdata+="<text>"+_data[r].dataList[j].text+"</text>";
						bookdata+="<xpos>"+_data[r].dataList[j].xpos+"</xpos>";
						bookdata+="<ypos>"+_data[r].dataList[j].ypos+"</ypos>";
						bookdata+="<stagewidth>"+_data[r].dataList[j].stagew+"</stagewidth>";
						bookdata+="<stageheight>"+_data[r].dataList[j].stageh+"</stageheight>";
						bookdata+="<width>"+_data[r].dataList[j].width+"</width>";
						bookdata+="<height>"+_data[r].dataList[j].height+"</height>";
						bookdata+="<curvex>"+_data[r].dataList[j].curvex+"</curvex>";
						bookdata+="<curvey>"+_data[r].dataList[j].curvey+"</curvey>";
						bookdata+="<rotation>"+_data[r].dataList[j].rotation+"</rotation>";
						bookdata+="<level>"+_data[r].dataList[j].level+"</level>";
					}
					bookdata+="</data>";
											
				}
				
				bookdata+="</datalist>";
				
				
				
				
				bookdata+="</page>";
				
				
			}			
			bookdata+="</bookdata>";				
			return bookdata;
		}
		//-----------------------------------------------------
		public function ResetBook():void
		{
						
			for(var r:int=0;r<_data.length;r++)
			{	
							
				_data[r].BgData=null
								
				_data[r].dataList.splice(0,_data[r].dataList.length);
				
			}	
			
			_data.splice(0,_data.length);
			_data=new Array();
			
			_currentPage=-1;
			//bookID=1;
		}
		
		
		public function getDataArray():Array
		{
			return _data;
		}
				
			
	}
}
