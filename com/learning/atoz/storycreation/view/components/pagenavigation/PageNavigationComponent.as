package com.learning.atoz.storycreation.view.components.pagenavigation
{
	import com.learning.atoz.alert.AlertComponent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.ClearStageEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageAddedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageDeleteEvent;
	import com.learning.atoz.storycreation.view.components.events.PageSwapCompletedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageThumbClickedEvent;
	import com.learning.atoz.storycreation.view.components.pagenavigation.events.PageUpdateEvent;
	
	import fl.core.UIComponent;
	
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	import flash.events.Event;
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	/*
	Page navigation component
	*/
	
	public class PageNavigationComponent extends UIComponent
	{		
		private var pagecnt:int=0;
		private var hgap:Number=10;
		private var placeholdercnt:int=-1;		
		private var cid:String;		
		private var rootTarget:*;
		private var parentobj:*;
		private var pgttarget:pageThumbnail;
		private var thumbWidth:Number=52;
		
		//-----------------------------------------------------
		public function PageNavigationComponent(_parentobj:Object,_rootTarget:Object)
		{						
			rootTarget=_rootTarget;			
			parentobj=_parentobj;			
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------		
		//init event
		//-----------------------------------------------------		
		override protected function configUI():void
		{
			super.configUI();
			onInit();
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//initializing
		//-----------------------------------------------------
		private function onInit()
		{		
			var bg:pageNavBG=new pageNavBG();
			this.addChild(bg);
			this.setChildIndex(bg,0);						
			this.BtnPrev.enabled=false;			
			this.BtnPrev.visible=false;			
			this.BtnNext.enabled=false;
			this.BtnNext.visible=false;			
			
			
			pageBarContainer.mask=pageBarContainerMask;			
			//BtnAddPage.addEventListener(MouseEvent.CLICK,OnAddPage);			
			BtnPrev.addEventListener(MouseEvent.CLICK,OnPagePrev);			
			BtnNext.addEventListener(MouseEvent.CLICK,OnPageNext);
			
			loadPlaceHolders();
			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------		
		//adding place holder of page thumbnail control
		//-----------------------------------------------------
		private function loadPlaceHolders():void
		{
			placeholdercnt=-1;
			for(var r=0;r<3;r++)
			{					
				placeholdercnt++;
				var xtraspace:int=0;
				if((placeholdercnt%2)==0)
				{
					xtraspace=(hgap*placeholdercnt);//+(5);//5;
				}
				else
				{
					xtraspace=(hgap*placeholdercnt);//+(10);//15;
				}
				
				var shp:placeHolderClip=new placeHolderClip();
				shp.alpha=0.0;
				shp.pageno=placeholdercnt;
				
				
				shp.name="pageHolder"+placeholdercnt;				
				shp.x=((placeHolderContainer.numChildren-1)*shp.width)+xtraspace;
				shp.y=2;				
				placeHolderContainer.addChild(shp);
				
			}
		}
		//-----------------------------------------------------
		public function updatePageBGThumb(pageno:int,thumburl:String)
		{
			trace("updatePageBGThumb=>"+pageno+","+thumburl);
			for(var dv:int=0;dv<pageBarContainer.numChildren;dv++)
			{
				if(pageBarContainer.getChildAt(dv).name=="page")
				{					
					if((pageBarContainer.getChildAt(dv) as pageThumbnail).pageno==pageno)
					{
						(pageBarContainer.getChildAt(dv) as pageThumbnail).pageBgThumb=thumburl;
						(pageBarContainer.getChildAt(dv) as pageThumbnail).loadBG();
					}
				}
				else if(pageBarContainer.getChildAt(dv).name=="frontcover")
				{					
					if((pageBarContainer.getChildAt(dv) as FrontCoverThumbnail).pageno==pageno)
					{
						(pageBarContainer.getChildAt(dv) as FrontCoverThumbnail).pageBgThumb=thumburl;
						(pageBarContainer.getChildAt(dv) as FrontCoverThumbnail).loadBG();
					}
				}
				
			}
		}
		
		//-----------------------------------------------------
		private function addPlaceHolder()
		{			
			placeholdercnt++;
			var xtraspace:int=0;
			if((placeholdercnt%2)==0)
			{
				xtraspace=(hgap*placeholdercnt);//+(5);//5;
			}
			else
			{
				xtraspace=(hgap*placeholdercnt);//+(10);//15;
			}
			
			var shp:placeHolderClip=new placeHolderClip();
			shp.alpha=0.0;
			shp.pageno=placeholdercnt;
						
			shp.name="pageHolder"+placeholdercnt;				
			shp.x=((placeHolderContainer.numChildren-1)*shp.width)+xtraspace;
			shp.y=2;				
			placeHolderContainer.addChild(shp);
			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------		
		//page navigation prevbutton event
		//-----------------------------------------------------
		private function OnPagePrev(evt:MouseEvent):void
		{			
			//45=holder width,10=records per page,hgap=gap between thumbnails
			//var offset:Number=(45*10)+(hgap*10);//150;			
			moveprev();
			
		}
		//-----------------------------------------------------
		public function moveprev()
		{
			var offset:Number=510;
			//var offset:Number=(thumbWidth*6)+(hgap*10);//150;			
						
			if((offset+pageBarContainer.x)<pageBarContainerMask.x)
			{
				TweenLite.to(pageBarContainer, 0.5, { x:(pageBarContainer.x+offset),onComplete:onBottomNextFinishTween} );
			}
			else
			{
				var xdiff:Number=pageBarContainerMask.x-pageBarContainer.x;
				TweenLite.to(pageBarContainer, 0.4, { x:(pageBarContainer.x+xdiff),onComplete:onBottomNextFinishTween} );
			}
		}
		//-----------------------------------------------------
		//page navigation nextbutton event
		//-----------------------------------------------------	
		private function OnPageNext(evt:MouseEvent):void
		{
			movenext();	
		}
		//-----------------------------------------------------
		private function movenext()
		{			
			var wdiff:Number=pageBarContainer.width-pageBarContainerMask.width;//+pageBarContainerMask.x;			
			trace("movenext1=>wdiff:"+wdiff);
			if(wdiff>1)//wdiff>0
			{				
				//var offset:Number=(thumbWidth*10)+(hgap*10);//150;
				var offset:Number=(thumbWidth*6)+(hgap*10);//150;
				var xdiff:Number=pageBarContainerMask.x-pageBarContainer.x;
				trace("movenext2=>"+xdiff);
				if((pageBarContainer.x-offset)>(-wdiff))
				{
					trace("movenext3=>");
					TweenLite.to(pageBarContainer, 0.5, { x:(pageBarContainer.x-offset),onComplete:onBottomNextFinishTween} );
				}
				else
				{
					trace("movenext4=>");
					xdiff=(pageBarContainer.width-pageBarContainerMask.width)-pageBarContainerMask.x;										
					TweenLite.to(pageBarContainer, 0.4, { x:(-xdiff),onComplete:onBottomNextFinishTween} );
				}
				trace("movenext5=>");
			}
		}
		//-----------------------------------------------------
		//when the page clip animation complete event
		//-----------------------------------------------------
		public function onBottomNextFinishTween():void
		{
			prevnextcheck();
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//check whether the prev,next button enable/disable check
		//-----------------------------------------------------
		private function prevnextcheck()
		{			
			trace("prevnextcheck1");
			var pagecnt:int=parentobj.getMaxPageNo()+1;			
			
			if(pagecnt>ApplicationConstants.MAXIMUM_PAGE_LIMIT)			
			{
				dispatchEvent(new Event("DUPLICATE_DISABLE",false,true));
			}
			else
			{
				dispatchEvent(new Event("DUPLICATE_ENABLE",false,true));
			}
			if(pagecnt>ApplicationConstants.MAXIMUM_PAGE_LIMIT)			
			{
				//BtnAddPage.enabled=false;
				//BtnAddPage.alpha=0.5;
				
				dispatchEvent(new Event("ADDPAGE_DISABLE",false,true));
			}
			else
			{
				//BtnAddPage.enabled=true;
				//BtnAddPage.alpha=1.0;
				
				dispatchEvent(new Event("ADDPAGE_ENABLE",false,true));
			}
			
			//prevbtn check
			var pdiff:Number=(pageBarContainer.x-pageBarContainerMask.x);						
			var right:int=pageBarContainer.x+pageBarContainer.width;
			var maskright:int=pageBarContainerMask.x+pageBarContainerMask.width;		
			trace("prevnextcheck2=>pdiff:"+pdiff);
			if(pdiff<-1)//0
			{					
				
				BtnPrev.visible=true;
			}
			else
			{				
				
				BtnPrev.visible=false;
			}
			
			
			//next btn check
			trace("pdiff=>"+pdiff+",right=>"+right+",maskright=>"+maskright);
			var diff:int=right-maskright;
			//if(right>maskright)
			if(diff>1)
			{			
				
				BtnNext.visible=true;
			}
			else
			{				
				
				BtnNext.visible=false;
			}
		}
		//-----------------------------------------------------
		//
		//-----------------------------------------------------
		//on addpage button click event
		//-----------------------------------------------------
		private function OnAddPage(evt:MouseEvent):void
		{			
			addPage("PAGE");			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//addpage adds the page thumbnail control
		//-----------------------------------------------------
		public function addPage(type:String):void
		{			
			trace("addPage1");
			if(type=="FRONTCOVER")
			{				
				trace("addPage2");
				pagecnt=0;
				var obj:*=pageBarContainer.getChildByName("frontcover");
				if(obj==null)
				{
					cid=UniqueID.createUniqueID();
					var fct:FrontCoverThumbnail=new FrontCoverThumbnail(cid);
					fct.addEventListener(MouseEvent.CLICK,frontCoverClicked);
					fct.addEventListener(MouseEvent.MOUSE_OVER,pageOver);
					fct.addEventListener(MouseEvent.MOUSE_OUT,pageOut);
					fct.name="frontcover";
					fct.pageno=pagecnt;
					var objpos:*=placeHolderContainer.getChildByName("pageHolder"+pagecnt);
					if(objpos!=null)
					{
						fct.x=objpos.x;
						fct.y=objpos.y;
					}					
					pageBarContainer.addChild(fct);
					fct.gotoAndStop(2);
					
					dispatchEvent(new PageAddedEvent("PAGE_ADDED_EVENT",UniqueID.createUniqueID(),type,pagecnt,false,true));					
				}
								
			}
			else if(type=="PAGE")
			{
				trace("addPage3");
				if(parentobj!=null)
				{
					pagecnt=parentobj.getMaxPageNo()+1;										
				}								
				
				if(pagecnt>=placeholdercnt)
				{
					addPlaceHolder();
				}
				if(pagecnt<=ApplicationConstants.MAXIMUM_PAGE_LIMIT)
				{
					trace("addPage4");
					cid=UniqueID.createUniqueID();
					var pgt:pageThumbnail=new pageThumbnail(placeHolderContainer,this,cid);
					pgt.addEventListener("PAGE_SWAP_COMPLETED_EVENT",OnPAGE_SWAP_COMPLETED_EVENT);
					pgt.addEventListener(MouseEvent.CLICK,pageClicked);
					
					pgt.addEventListener(MouseEvent.MOUSE_OVER,pageOver);
					pgt.addEventListener(MouseEvent.MOUSE_OUT,pageOut);
					pgt.BtnDeletePage.visible=false;
					pgt.BtnDeletePage.addEventListener(MouseEvent.CLICK,pageDeleteClicked);
					pgt.name="page";				
					var objpos2:*=placeHolderContainer.getChildByName("pageHolder"+pagecnt);
					if(objpos2!=null)
					{					
						pgt.x=objpos2.x;
						pgt.y=objpos2.y;
						
						pgt.orgx=pgt.x;
						pgt.orgy=pgt.y;
					}
					
					pageBarContainer.addChild(pgt);				
					pgt.pageno=pagecnt;						
					trace("addPage5");
					dispatchEvent(new PageAddedEvent("PAGE_ADDED_EVENT",cid,type,pagecnt,false,true));
					trace("addPage6");
					//selectPage(pagecnt);
				}
				//auto scroll to last page
				movenext();
			}
						
			prevnextcheck();
			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//page thumbnail swap completed event
		//-----------------------------------------------------
		private function OnPAGE_SWAP_COMPLETED_EVENT(evt:PageSwapCompletedEvent)
		{
			dispatchEvent(new PageSwapCompletedEvent("PAGE_SWAP_COMPLETED_EVENT",evt._scid,evt._p1,evt._p2,evt._tcid,evt._p3,evt._p4,false,true));			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//changing the selected status of the page thumbnail control
		//-----------------------------------------------------
		public function selectPage(pno:int):void
		{
			//Deselect all pages
			for(var k:int=0;k<pageBarContainer.numChildren;k++)
			{				
				if(pageBarContainer.getChildAt(k).name=="page")
				{
					(pageBarContainer.getChildAt(k) as pageThumbnail).BtnDeletePage.visible=false;
					(pageBarContainer.getChildAt(k) as pageThumbnail).gotoAndStop(1);
					(pageBarContainer.getChildAt(k) as pageThumbnail).showBGThumb(true);
				}
				else if(pageBarContainer.getChildAt(k).name=="frontcover")
				{
					(pageBarContainer.getChildAt(k) as FrontCoverThumbnail).gotoAndStop(1);
					(pageBarContainer.getChildAt(k) as FrontCoverThumbnail).showBGThumb(true);
				}
			}
			
			//select requested page
			for(var j:int=0;j<pageBarContainer.numChildren;j++)
			{				
				if(pageBarContainer.getChildAt(j).name=="page")
				{
					if((pageBarContainer.getChildAt(j) as pageThumbnail).pageno==pno)
					{			
						(pageBarContainer.getChildAt(j) as pageThumbnail).BtnDeletePage.visible=true;
						(pageBarContainer.getChildAt(j) as pageThumbnail).gotoAndStop(2);
						(pageBarContainer.getChildAt(j) as pageThumbnail).showBGThumb(true);//false
						break;
					}
				}
				else if(pageBarContainer.getChildAt(j).name=="frontcover")
				{
					if((pageBarContainer.getChildAt(j) as FrontCoverThumbnail).pageno==pno)
					{						
						trace("frontcover selected");
						(pageBarContainer.getChildAt(j) as FrontCoverThumbnail).gotoAndStop(2);
						(pageBarContainer.getChildAt(j) as FrontCoverThumbnail).showBGThumb(true);//false
						break;
					}					
				}
			}
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//front cover thumbnail click event
		//-----------------------------------------------------
		public function frontCoverClicked(evt:MouseEvent)
		{						
			for(var j:int=0;j<pageBarContainer.numChildren;j++)
			{				
				if(pageBarContainer.getChildAt(j).name=="page")
				{
					(pageBarContainer.getChildAt(j) as pageThumbnail).BtnDeletePage.visible=false;
					(pageBarContainer.getChildAt(j) as pageThumbnail).gotoAndStop(1);
					(pageBarContainer.getChildAt(j) as pageThumbnail).showBGThumb(true);
				}
				else if(pageBarContainer.getChildAt(j).name=="frontcover")
				{
					(pageBarContainer.getChildAt(j) as FrontCoverThumbnail).gotoAndStop(1);
					(pageBarContainer.getChildAt(j) as FrontCoverThumbnail).showBGThumb(true);
				}
			}
			
			if(evt.currentTarget.name=="page")
			{
				(evt.currentTarget as pageThumbnail).gotoAndStop(2);
				(evt.currentTarget as pageThumbnail).showBGThumb(true);//false
			}
			else if(evt.currentTarget.name=="frontcover")
			{
				(evt.currentTarget as FrontCoverThumbnail).gotoAndStop(2);
				(evt.currentTarget as FrontCoverThumbnail).showBGThumb(true);//false
			}
			
			dispatchEvent(new PageThumbClickedEvent("PAGE_THUMB_CLICKED_EVENT",evt.currentTarget.pageno,false,true));
			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//page thumbnail click event
		//-----------------------------------------------------
		public function pageClicked(evt:MouseEvent)
		{
			
			for(var j:int=0;j<pageBarContainer.numChildren;j++)
			{				
				if(pageBarContainer.getChildAt(j).name=="page")
				{
					(pageBarContainer.getChildAt(j) as pageThumbnail).BtnDeletePage.visible=false;
					(pageBarContainer.getChildAt(j) as pageThumbnail).gotoAndStop(1);
					(pageBarContainer.getChildAt(j) as pageThumbnail).showBGThumb(true);
				}
				else if(pageBarContainer.getChildAt(j).name=="frontcover")
				{
					(pageBarContainer.getChildAt(j) as FrontCoverThumbnail).gotoAndStop(1);
					(pageBarContainer.getChildAt(j) as FrontCoverThumbnail).showBGThumb(true);
				}
			}
			
			if(evt.currentTarget.name=="page")
			{
				(evt.currentTarget as pageThumbnail).BtnDeletePage.visible=true;
				(evt.currentTarget as pageThumbnail).gotoAndStop(2);
				(evt.currentTarget as pageThumbnail).showBGThumb(true);//false
			}
			else if(evt.currentTarget.name=="frontcover")
			{
				(evt.currentTarget as FrontCoverThumbnail).gotoAndStop(2);
				(evt.currentTarget as FrontCoverThumbnail).showBGThumb(true);//false
			}
			
			dispatchEvent(new PageThumbClickedEvent("PAGE_THUMB_CLICKED_EVENT",evt.currentTarget.pageno,false,true));			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//page thumbnail mouse over event
		//-----------------------------------------------------
		public function pageOver(evt:MouseEvent)
		{
			if(evt.currentTarget.name=="page")
			{
				if((evt.currentTarget as pageThumbnail).currentFrame==1)
				{
					(evt.currentTarget as pageThumbnail).gotoAndStop(3);
				}
			}
			else if(evt.currentTarget.name=="frontcover")
			{
				if((evt.currentTarget as FrontCoverThumbnail).currentFrame==1)
				{
					(evt.currentTarget as FrontCoverThumbnail).gotoAndStop(3);
				}
			}
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		//page thumbnail mouse out event
		//-----------------------------------------------------
		public function pageOut(evt:MouseEvent)
		{
			if(evt.currentTarget.name=="page")
			{				
				if((evt.currentTarget as pageThumbnail).currentFrame==3)
				{
					(evt.currentTarget as pageThumbnail).gotoAndStop(1);
				}
			}
			else if(evt.currentTarget.name=="frontcover")
			{
				if((evt.currentTarget as FrontCoverThumbnail).currentFrame==3)
				{
					(evt.currentTarget as FrontCoverThumbnail).gotoAndStop(1);
				}
			}
		}
		//-----------------------------------------------------
		
		
		//-----------------------------------------------------
		//page delete event
		//-----------------------------------------------------
		public function pageDeleteClicked(evt:MouseEvent):void
		{			
			trace("pageDeleteClicked=>"+evt.currentTarget.parent+","+evt.currentTarget.parent.name);
			pgttarget=(evt.currentTarget.parent as pageThumbnail);
			
			var ac:AlertComponent=new com.learning.atoz.alert.AlertComponent();
			ac.Target=rootTarget;	
			ac.MsgBoxType="YESNO";			
			ac.addEventListener("BtnYes",deleteYesConfirm);			
			ac.showAlert("Are you sure you want to delete this page?");
			
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		//page deletion confirmation event
		//-----------------------------------------------------
		private function deleteYesConfirm(evt:*):void
		{
			if(pgttarget!=null)
			{				
				for(var j:int=0;j<pageBarContainer.numChildren;j++)
				{	
					if(pageBarContainer.getChildAt(j).name=="page")
					{
						var pgtsrc:pageThumbnail=(pageBarContainer.getChildAt(j) as pageThumbnail);						
						
						if(pgtsrc.pageno==pgttarget.pageno)
						{						
							pageBarContainer.removeChildAt(j);
							
							//BtnAddPage.enabled=true;
							//BtnAddPage.alpha=1.0;
							dispatchEvent(new Event("ADDPAGE_ENABLE",false,true));
							break;
						}
					}					
				}		
				
				//delete from database			
				dispatchEvent(new PageDeleteEvent("PAGE_DELETE_EVENT",pgttarget.pageno,false,true));
								
				//reorder page nos
				reorderPageNos(pgttarget.pageno,-1);
			}
		}
		//-----------------------------------------------------
		public function deletePageThumbnail(pno:Number):void
		{
			for(var j:int=0;j<pageBarContainer.numChildren;j++)
			{					
				if(pageBarContainer.getChildAt(j).name=="page")
				{
					var pgtsrc:pageThumbnail=(pageBarContainer.getChildAt(j) as pageThumbnail);						
					
					if(pgtsrc.pageno==pno)
					{						
						pageBarContainer.removeChildAt(j);
						break;
					}
				}
				else if(pageBarContainer.getChildAt(j).name=="frontcover")
				{
					var pgtsrc2:FrontCoverThumbnail=(pageBarContainer.getChildAt(j) as FrontCoverThumbnail);						
					
					if(pgtsrc2.pageno==pno)
					{						
						pageBarContainer.removeChildAt(j);
						break;
					}
				}
			}		
		}
		//-----------------------------------------------------
		//reorder page thumbnail controls
		//-----------------------------------------------------
		public function reorderPageNos(pgno:int,idx:int)
		{			
			if((idx+1)<pageBarContainer.numChildren)
			{
				idx++;				
				if(pageBarContainer.getChildAt(idx).name=="page")
				{
					var pgtsrc:pageThumbnail=(pageBarContainer.getChildAt(idx) as pageThumbnail);		
										
					if(pgtsrc.pageno>pgno)
					{		
						var oldpno:int=pgtsrc.pageno;
						pgtsrc.pageno-=1;						
						dispatchEvent(new PageUpdateEvent("PAGE_UPDATE_EVENT",oldpno,pgtsrc.pageno,false,true));						
					}						
					
					var objpos:*=placeHolderContainer.getChildByName("pageHolder"+pgtsrc.pageno);
					if(objpos!=null)
					{
						pgtsrc.x=objpos.x+2;
						pgtsrc.y=2;//objpos.y-2;
					}					
				}
				
				reorderPageNos(pgno,idx);	
			}
			else
			{
				dispatchEvent(new ClearStageEvent("CLEAR_STAGE_EVENT",false,true));
			}
		}
		//-----------------------------------------------------
		
		
		
	}
	
}
