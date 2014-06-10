package com.learning.atoz.storycreation.view.components.clipart
{
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.learning.atoz.storycreation.view.components.clipart.caCatRecord;
	import com.learning.atoz.storycreation.view.components.clipart.caSubCatRecord;
	import com.learning.atoz.storycreation.view.components.clipart.caBgChrObjRecord;
	import com.learning.atoz.storycreation.view.components.clipart.SwfThumbComponent;
	import com.learning.atoz.storycreation.view.components.clipart.events.ClipartEvent;
	import gs.TweenLite;
	import fl.containers.ScrollPane;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	
	/*
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.learning.atoz.storycreation.view.components.clipart.caCatRecord;
	import com.learning.atoz.storycreation.view.components.clipart.caSubCatRecord;
	import com.learning.atoz.storycreation.view.components.clipart.caBgChrObjRecord;
	import com.learning.atoz.storycreation.view.components.clipart.SwfThumbComponent;
	import com.learning.atoz.storycreation.view.components.clipart.events.ClipartEvent;
	import gs.TweenLite;
	*/

	public class clipartView extends Sprite
	{
		private var themeXml:XML;
		private var clipartType:String="BG";
		private var catContent:MovieClip;
		private var subcatContent:MovieClip;		
		private var bgchrobjContent:MovieClip;
		private var isDown:Boolean=false;
		private var isUp:Boolean=false;
		private var scrollspeed:int=345;//115;
		private var scrollspeed2:int=150;
		private var catThumbList:Array;
		private var subcatThumbList:Array;
		private var dataXml:XML;
		private var bgchrobjThumbList:Array;
		
		private var selectedCatId:Number=-1;
		private var selectedSubCatId:Number=-1;
		private var selectedCatSubCat:Object={cliparttype:"BG",catid:0,subcatid:0};
		private var blankSprite:Sprite;
		public function clipartView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,OnInit);
		}
		
		public function setThemeXml(_themexml:XML):void
		{
			themeXml=_themexml;
			//trace("clipartView=>setThemeXml");
			LoadSubCategoryList();
		}
		
		public function setClipartType(_ct:String,_selectedCatSubCat:Object):void
		{
			clipartType=_ct;
			selectedCatSubCat.cliparttye=_selectedCatSubCat.cliparttype;
			selectedCatSubCat.catid=_selectedCatSubCat.catid;
			selectedCatSubCat.subcatid=_selectedCatSubCat.subcatid;
			
					
			
			selectedCatId=_selectedCatSubCat.catid;
			selectedSubCatId=_selectedCatSubCat.subcatid;
			
			lblStatus.visible=false;
			lblStatus.text="";
			lblSearchText.text="";
			
			if(clipartType=="BG")
			{
				m_themetitle.text="Backgrounds";
			}
			else if(clipartType=="CHR")
			{
				m_themetitle.text="Characters";
			}
			else if(clipartType=="OBJ")
			{
				m_themetitle.text="Characters & Objects";
			}
			
			//trace("setClipartType=>"+selectedCatSubCat.cliparttype+","+selectedCatSubCat.catid+","+selectedCatSubCat.subcatid);
		}
		
		public function setClipartData(cd:XML):void
		{
			dataXml=cd;
			LoadBgChrObjThumbList();
			//trace("dataXml=>"+dataXml)
			//trace("clipartView=>bg cnt=>"+dataXml..Background.length()+",chr len="+dataXml..Character.length()+",obj len="+dataXml..Object.length());
		}
		
		public function Reset()
		{
			subcatThumbList=new Array();
			subcatContent=new MovieClip();
			scpSubCat.source=null;
			
			bgchrobjThumbList=new Array();
			bgchrobjContent=new MovieClip();
			scpContent.source=null;
			
			
			catContent=new MovieClip();
			//scpCat.source=null;
			catThumbList=new Array();
			
			deselectallcat();
			deselectall();
			selectedCatId=-1;
			selectedSubCatId=-1;
			lblStatus.visible=false;
			lblStatus.text="";
			lblSearchText.text="";
		}
		private function OnInit(evt:Event):void
		{
			//trace("clipartView=>OnInit");
			
			//LoadCategoryList();
			//LoadSubCategoryList();
			
			lblSearchText.restrict="[a-zA-Z0-9 ]";
			
			
			BtnSubCatUp.addEventListener(MouseEvent.MOUSE_DOWN,OnBtnSubCatUp);
			BtnSubCatDown.addEventListener(MouseEvent.MOUSE_DOWN,OnBtnSubCatDown);
			
						
			BtnBgChrObjUp.addEventListener(MouseEvent.MOUSE_DOWN,OnBtnBgChrObjUp);
			BtnBgChrObjDown.addEventListener(MouseEvent.MOUSE_DOWN,OnBtnBgChrObjDown);
			//BtnMore.addEventListener(MouseEvent.MOUSE_DOWN,OnBtnMoreClicked);
			
			
			if(clipartType=="BG")
			{
				m_themetitle.text="Backgrounds";
			}
			else if(clipartType=="CHR")
			{
				m_themetitle.text="Characters";
			}
			else if(clipartType=="OBJ")
			{
				m_themetitle.text="Characters & Objects";
			}
			
			updateScroll();			
			subcatUpdateScroll();
			
		}		
		
		/*private function OnBtnMoreClicked(evt:MouseEvent)
		{			
			showMore(false);
			startLoad(2);//all records
		}*/
		
		private function updateScroll():void
		{
			//trace("updateScroll");
			BtnBgChrObjUp.alpha=0.3;
			BtnBgChrObjDown.alpha=0.3;
			
			BtnBgChrObjUp.enabled=false;
			BtnBgChrObjDown.enabled=false;
			//BtnMore.visible=false;
			
			if(clipartType=="BG" && dataXml!=null)
			{
				if(dataXml..Background.length()>6)
				{
					BtnBgChrObjUp.alpha=1.0;
					BtnBgChrObjDown.alpha=1.0;
			
					BtnBgChrObjUp.enabled=true;
					BtnBgChrObjDown.enabled=true;
					
					if(scpContent.verticalScrollPosition<=0)
					{
						BtnBgChrObjUp.alpha=0.3;
						BtnBgChrObjDown.alpha=1.0;
			
						BtnBgChrObjUp.enabled=false;
						BtnBgChrObjDown.enabled=true;
					}
					else if(scpContent.verticalScrollPosition>=scpContent.maxVerticalScrollPosition)
					{
						BtnBgChrObjUp.alpha=1.0;
						BtnBgChrObjDown.alpha=0.3;
			
						BtnBgChrObjUp.enabled=true;
						BtnBgChrObjDown.enabled=false;
					}
					else
					{
						BtnBgChrObjUp.alpha=1.0;
						BtnBgChrObjDown.alpha=1.0;
			
						BtnBgChrObjUp.enabled=true;
						BtnBgChrObjDown.enabled=true;
					}
				}
				else
				{
					BtnBgChrObjUp.alpha=0.3;
					BtnBgChrObjDown.alpha=0.3;
			
					BtnBgChrObjUp.enabled=false;
					BtnBgChrObjDown.enabled=false;		
				}
			}
			else if(clipartType=="CHR" && dataXml!=null)
			{
				if(dataXml..Character.length()>6)
				{
					BtnBgChrObjUp.alpha=1.0;
					BtnBgChrObjDown.alpha=1.0;
			
					BtnBgChrObjUp.enabled=true;
					BtnBgChrObjDown.enabled=true;
					
					if(scpContent.verticalScrollPosition<=0)
					{
						BtnBgChrObjUp.alpha=0.3;
						BtnBgChrObjDown.alpha=1.0;
			
						BtnBgChrObjUp.enabled=false;
						BtnBgChrObjDown.enabled=true;
					}
					else if(scpContent.verticalScrollPosition>=scpContent.maxVerticalScrollPosition)
					{
						BtnBgChrObjUp.alpha=1.0;
						BtnBgChrObjDown.alpha=0.3;
			
						BtnBgChrObjUp.enabled=true;
						BtnBgChrObjDown.enabled=false;
					}
					else
					{
						BtnBgChrObjUp.alpha=1.0;
						BtnBgChrObjDown.alpha=1.0;
			
						BtnBgChrObjUp.enabled=true;
						BtnBgChrObjDown.enabled=true;
					}
				}
				else
				{
					BtnBgChrObjUp.alpha=0.3;
					BtnBgChrObjDown.alpha=0.3;
			
					BtnBgChrObjUp.enabled=false;
					BtnBgChrObjDown.enabled=false;		
				}
			}
			else if(clipartType=="OBJ" && dataXml!=null)
			{
				if(dataXml..Object.length()>6)
				{
					BtnBgChrObjUp.alpha=1.0;
					BtnBgChrObjDown.alpha=1.0;
			
					BtnBgChrObjUp.enabled=true;
					BtnBgChrObjDown.enabled=true;
					
					if(scpContent.verticalScrollPosition<=0)
					{
						BtnBgChrObjUp.alpha=0.3;
						BtnBgChrObjDown.alpha=1.0;
			
						BtnBgChrObjUp.enabled=false;
						BtnBgChrObjDown.enabled=true;
					}
					else if(scpContent.verticalScrollPosition>=scpContent.maxVerticalScrollPosition)
					{
						BtnBgChrObjUp.alpha=1.0;
						BtnBgChrObjDown.alpha=0.3;
			
						BtnBgChrObjUp.enabled=true;
						BtnBgChrObjDown.enabled=false;
					}
					else
					{
						BtnBgChrObjUp.alpha=1.0;
						BtnBgChrObjDown.alpha=1.0;
			
						BtnBgChrObjUp.enabled=true;
						BtnBgChrObjDown.enabled=true;
					}
				}
				else
				{
					BtnBgChrObjUp.alpha=0.3;
					BtnBgChrObjDown.alpha=0.3;
			
					BtnBgChrObjUp.enabled=false;
					BtnBgChrObjDown.enabled=false;		
				}
			}
			
			
			
		}
		
		
		private function subcatUpdateScroll():void
		{
			BtnSubCatUp.alpha=0.3;
			BtnSubCatDown.alpha=0.3;
			
			BtnSubCatUp.enabled=false;
			BtnSubCatDown.enabled=false;
			//BtnMore.visible=false;
			
			
			//trace("subcatUpdateScroll"+scpSubCat.verticalScrollPosition+" of "+scpSubCat.maxVerticalScrollPosition)
			if(scpSubCat.verticalScrollPosition<=0)
			{
				BtnSubCatUp.alpha=0.3;
				BtnSubCatDown.alpha=1.0;
	
				BtnSubCatUp.enabled=false;
				BtnSubCatDown.enabled=true;
			}
			else if(scpSubCat.verticalScrollPosition>=scpSubCat.maxVerticalScrollPosition)
			{
				BtnSubCatUp.alpha=1.0;
				BtnSubCatDown.alpha=0.3;
	
				BtnSubCatUp.enabled=true;
				BtnSubCatDown.enabled=false;
			}
			else
			{
				BtnSubCatUp.alpha=1.0;
				BtnSubCatDown.alpha=1.0;
	
				BtnSubCatUp.enabled=true;
				BtnSubCatDown.enabled=true;
			}
				
			
			
		}
		
		
		
		private function OnBtnSubCatUp(evt:MouseEvent):void
		{
			//scpSubCat.verticalScrollPosition-=10;
			isUp=true;
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnStageUp);
			TweenLite.to(scpSubCat, 0.7, { verticalScrollPosition:(scpSubCat.verticalScrollPosition-scrollspeed),onComplete:onfinishscrollTween } );
		}
		
		private function onfinishscrollTween()
		{
			subcatUpdateScroll();
			//trace("onfinishscrollTween=>"+isDown)
			/*if(isDown)
			{
				TweenLite.to(scpSubCat, 0.3, { verticalScrollPosition:(scpSubCat.verticalScrollPosition+scrollspeed),onComplete:onfinishscrollTween } );
			}
			
			if(isUp)
			{
				TweenLite.to(scpSubCat, 0.3, { verticalScrollPosition:(scpSubCat.verticalScrollPosition-scrollspeed),onComplete:onfinishscrollTween } );
			}*/
		}
		private function OnBtnSubCatDown(evt:MouseEvent):void
		{
			//scpSubCat.verticalScrollPosition+=10;
			isDown=true;
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnStageUp);
			TweenLite.to(scpSubCat, 0.7, { verticalScrollPosition:(scpSubCat.verticalScrollPosition+scrollspeed),onComplete:onfinishscrollTween } );
		}
		
		private function OnStageUp(evt:MouseEvent)
		{
			isDown=false;
			isUp=false;
		}		
		//------------------------------------------------------------------		
		private function LoadCategoryList()
		{
			trace("LoadCategoryList=>catlen="+themeXml..Category.length());
			if(themeXml..Category.length()>0)
			{
				catThumbList=new Array();
				
				for(var dv:int=0;dv<themeXml..Category.length();dv++)
				{
					trace(themeXml..Category[dv].@name);
					var catrec:caCatRecord=new caCatRecord();
					catrec.catid=Number(themeXml..Category[dv].@CatId);
					catrec.lblText.text=themeXml..Category[dv].@name;
					catrec.lblText.selectable=false;					
					
					catThumbList.push({CatId:Number(themeXml..Category[dv].@CatId),CatName:themeXml..Category[dv].@name,target:catrec});					
									
				}
			}
			updateCatDisplay();
		}
		//------------------------------------------------------------------
		
		private function updateCatDisplay()
		{
			catContent=new MovieClip();
			//scpCat.source=null;
			var xp:int=5;
			var yp:int=0;
			var yoffset:int=12;
			catThumbList.sortOn("CatName",Array.CASEINSENSITIVE);
			for(var dv:int=0;dv<catThumbList.length;dv++)
			{
				catContent.addChild(catThumbList[dv].target);
				catThumbList[dv].target.x=xp;
				catThumbList[dv].target.y=yp;
				
				yp+=catThumbList[dv].target.height+yoffset;
			}
			
			//scpCat.horizontalScrollPolicy="off";
			//scpCat.verticalScrollPolicy="off";				
			//scpCat.source=catContent;
			//scpCat.update();
			//scpCat.verticalScrollBar.visible=false;
			//scpCat.scrollDrag=true;
			
		}
		//------------------------------------------------------------------
		private function deselectallcat()
		{
			//titlearrow.visible=false;
			//m_cattitle1.text="";
			m_cattitle2.text="";
			/*for(var dv:int=0;dv<catThumbList.length;dv++)
			{
				catThumbList[dv].target.gotoAndStop(1);
			}*/
		}
		private function highlightCurrentCategory(catid:int)
		{
			//m_cattitle1.text="";
			m_cattitle2.text="";
			/*if(themeXml..Category.length()>0)
			{
				for(var dv:int=0;dv<themeXml..Category.length();dv++)
				{
					if(catid==Number(themeXml..Category[dv].@CatId))
					{
						//m_cattitle1.text=themeXml..Category[dv].@name;
					}					
				}
			}*/
			
			
			
			/*for(var dv:int=0;dv<catThumbList.length;dv++)
			{
				if(selectedCatId!=catThumbList[dv].target.catid)
				{
					catThumbList[dv].target.gotoAndStop(1);
				}
				
				if(catThumbList[dv].target.catid==catid)
				{
					catThumbList[dv].target.gotoAndStop(2);
				}
			}*/
		}
		//------------------------------------------------------------------
		private function selectCurrentCategory(catid:int,subcatname:String)
		{
			//m_cattitle1.text="";
			m_cattitle2.text="";
			var arr:String=" → ";
			if(themeXml..Category.length()>0)
			{
				for(var dv:int=0;dv<themeXml..Category.length();dv++)
				{
					if(catid==Number(themeXml..Category[dv].@CatId))
					{						
						//m_cattitle1.text=themeXml..Category[dv].@name;
						m_cattitle2.text=subcatname;
					}					
				}
			}
			/*if(m_cattitle1.text.length>0 || m_cattitle2.text.length>0)
			{
				//titlearrow.visible=true;
			}
			else
			{
				//titlearrow.visible=false;
			}*/
			
			
			/*for(var dv:int=0;dv<catThumbList.length;dv++)
			{
				if(selectedCatId!=catThumbList[dv].target.catid)
				{
					catThumbList[dv].target.gotoAndStop(1);
				}
				
				if(catThumbList[dv].target.catid==catid)
				{
					catThumbList[dv].target.gotoAndStop(3);
				}
			}*/
		}
		//------------------------------------------------------------------
		//------------------------------------------------------------------
		//------------------------------------------------------------------
		
		
		//------------------------------------------------------------------
		public function LoadSubCategoryList()
		{
			trace("LoadCategoryList=>catlen="+themeXml..Category.length());
			if(themeXml..Category.length()>0)
			{
				subcatThumbList=new Array();
				
				for(var dv:int=0;dv<themeXml..Category.length();dv++)
				{
					trace("Cat=>"+themeXml..Category[dv].@name);
					for(var su:int=0;su<themeXml..Category[dv].SubCategory.length();su++)
					{
						if(clipartType=="BG" && Number(themeXml..Category[dv].SubCategory[su].@backgrounds)>0)
						{
							trace("SubCat==>"+themeXml..Category[dv].SubCategory[su]);
							var subcatrec:caSubCatRecord=new caSubCatRecord();
							subcatrec.catid=Number(themeXml..Category[dv].@CatId);
							subcatrec.subcatid=Number(themeXml..Category[dv].SubCategory[su].@SubCatId);
							subcatrec.subcatname=themeXml..Category[dv].SubCategory[su];
							subcatrec.ThumbUrl=themeXml..Category[dv].SubCategory[su].@ThumbUrl;
							subcatrec.lblText.text=themeXml..Category[dv].SubCategory[su];
							subcatrec.lblText.selectable=false;
							subcatrec.addEventListener(MouseEvent.ROLL_OVER,OnsubcatThumbOver);
							//subcatrec.addEventListener(MouseEvent.ROLL_OUT,OnsubcatThumbOut);
							subcatrec.addEventListener(MouseEvent.CLICK,OnsubcatThumbClicked);
							subcatrec.buttonMode=true;
							subcatrec.loadBG();
							//-------------------------						
							subcatThumbList.push({CatId:Number(themeXml..Category[dv].@CatId),CatName:themeXml..Category[dv].@name,SubCatId:Number(themeXml..Category[dv].SubCategory[su].@SubCatId),SubCatName:themeXml..Category[dv].SubCategory[su],target:subcatrec});
							//-------------------------
						}									
						else if(clipartType=="OBJ" && Number(themeXml..Category[dv].SubCategory[su].@objects)>0)
						{
							trace("SubCat==>"+themeXml..Category[dv].SubCategory[su]);
							var subcatrec2:caSubCatRecord=new caSubCatRecord();
							subcatrec2.catid=Number(themeXml..Category[dv].@CatId);
							subcatrec2.subcatid=Number(themeXml..Category[dv].SubCategory[su].@SubCatId);
							subcatrec2.subcatname=themeXml..Category[dv].SubCategory[su];
							subcatrec2.ThumbUrl=themeXml..Category[dv].SubCategory[su].@ThumbUrl;
							subcatrec2.lblText.text=themeXml..Category[dv].SubCategory[su];
							subcatrec2.lblText.selectable=false;
							subcatrec2.addEventListener(MouseEvent.ROLL_OVER,OnsubcatThumbOver);
							//subcatrec2.addEventListener(MouseEvent.ROLL_OUT,OnsubcatThumbOut);
							subcatrec2.addEventListener(MouseEvent.CLICK,OnsubcatThumbClicked);
							subcatrec2.buttonMode=true;
							subcatrec2.loadBG();
							//-------------------------						
							subcatThumbList.push({CatId:Number(themeXml..Category[dv].@CatId),CatName:themeXml..Category[dv].@name,SubCatId:Number(themeXml..Category[dv].SubCategory[su].@SubCatId),SubCatName:themeXml..Category[dv].SubCategory[su],target:subcatrec2});
							//-------------------------
						}
						else
						{
							/*trace("*****************subCategory Not Included****************");
							trace("clipartType=>"+clipartType);
							trace("title=>"+themeXml..Category[dv].SubCategory[su]);
							trace("Obj=>"+themeXml..Category[dv].SubCategory[su].@objects)
							trace("Bg=>"+themeXml..Category[dv].SubCategory[su].@backgrounds)
							trace("---------------------------------------------------------");*/
						}
						
								
					}
				}
				
			}
			
			updateSubCatDisplay();
			
			
		}
		//------------------------------------------------------------------
		private function RestoreLastVisited():void
		{
			trace("RestoreLastVisited1=>"+selectedCatSubCat.cliparttype+","+selectedCatSubCat.catid+","+selectedCatSubCat.subcatid);
			bgchrobjThumbList=new Array();
			bgchrobjContent=new MovieClip();
			scpContent.source=null;
			
			if(Number(selectedCatSubCat.catid)>0 && Number(selectedCatSubCat.subcatid)>0)
			{				
				lblStatus.visible=true;
				lblStatus.text="Loading...";
				deselectallcat();
				deselectall();
				
				selectedCatId=selectedCatSubCat.catid;
				selectedSubCatId=selectedCatSubCat.subcatid;
				
				SelectSubCat(selectedSubCatId);				
				var subcatname:String;
				for(var dv:int=0;dv<themeXml..Category.length();dv++)
				{
					trace("=>"+themeXml..Category[dv].@name);
					for(var su:int=0;su<themeXml..Category[dv].SubCategory.length();su++)
					{
						if(Number(themeXml..Category[dv].SubCategory[su].@SubCatId)==selectedSubCatId)
						{
							subcatname=themeXml..Category[dv].SubCategory[su];
							break;
						}
					}
				}
				selectCurrentCategory(selectedCatSubCat.catid,subcatname);
				
				dispatchEvent(new ObjectEvent("SUBCAT_THUMB_CLICKED",{ClipartType:clipartType,CatId:selectedCatSubCat.catid,SubCatId:selectedCatSubCat.subcatid},false,true));
				
			}
		}
		
		private function updateSubCatDisplay()
		{
			if(subcatContent!=null)
			{
				while(subcatContent.numChildren>0)
				{
					subcatContent.removeChildAt(0);
				}
			}
			
			subcatContent=new MovieClip();
			scpSubCat.source=null;
			var xp:int=10;
			var yp:int=10;
			var yoffset:int=15;
			var w:int=0;
			//subcatThumbList.sortOn("SubCatName",Array.CASEINSENSITIVE);
			
			for(var dv:int=0;dv<subcatThumbList.length;dv++)
			{				
				subcatContent.addChild(subcatThumbList[dv].target);
				subcatThumbList[dv].target.x=xp;
				subcatThumbList[dv].target.y=yp;						
				w=subcatThumbList[dv].target.width;
				yp+=subcatThumbList[dv].target.height+yoffset;
			}
			
			subcatContent.graphics.beginFill(0xffffff,0.0);
			subcatContent.graphics.drawRect(0,0,120,subcatContent.height+25);
			subcatContent.graphics.endFill();
			
			scpSubCat.horizontalScrollPolicy="off";
			scpSubCat.verticalScrollPolicy="off";				
			scpSubCat.source=subcatContent;
			scpSubCat.update();
			scpSubCat.verticalScrollBar.visible=false;
			//scpSubCat.scrollDrag=true;
			
			updateScroll();
			
			RestoreLastVisited();
		}
		private function deselectall()
		{
			for(var dv:int=0;dv<subcatThumbList.length;dv++)
			{
				subcatThumbList[dv].target.gotoAndStop(1);
			}
		}
		
		
		private function SelectSubCat(subcatid:int)
		{
			trace("SelectSubCat=>"+subcatid);
			for(var dv:int=0;dv<subcatThumbList.length;dv++)
			{								
				if(selectedSubCatId!=subcatThumbList[dv].target.subcatid)
				{
					subcatThumbList[dv].target.gotoAndStop(1);
										
					var subcattitle:*=themeXml..SubCategory.(@SubCatId==selectedSubCatId);
					m_cattitle2.text=subcattitle;
				}
				
				if(subcatid==subcatThumbList[dv].target.subcatid)
				{
					subcatThumbList[dv].target.gotoAndStop(3);										
				}				
			}
			
			scrollToSelectedItem(subcatid);
		}
		
		private function scrollToSelectedItem(subcatid:int)
		{
			trace("scrollToSelectedItem1=>"+subcatid+",scpSubCat.verticalScrollPosition=>"+scpSubCat.verticalScrollPosition);
			var newht:int=0;
			for(var dv:int=0;dv<subcatContent.numChildren;dv++)
			{								
				if(subcatContent.getChildAt(dv) is caSubCatRecord)
				{
					var sub:caSubCatRecord=(subcatContent.getChildAt(dv) as caSubCatRecord);
					if(sub.subcatid==subcatid)
					{
						newht=sub.y;
						scpSubCat.verticalScrollPosition=newht;
						break;
					}
				}
				
			}
			trace("scrollToSelectedItem2=>"+subcatid+",scpSubCat.verticalScrollPosition=>"+scpSubCat.verticalScrollPosition);
		}
		//------------------------------------------------------------------		
		private function OnsubcatThumbOver(evt:MouseEvent):void
		{
			evt.currentTarget.addEventListener(MouseEvent.ROLL_OUT,OnsubcatThumbOut);
			if(selectedSubCatId!=evt.currentTarget.subcatid)
			{
				evt.currentTarget.gotoAndStop(2);
				//highlightCurrentCategory(evt.currentTarget.catid);
			}
		}
		//------------------------------------------------------------------
		private function OnsubcatThumbOut(evt:MouseEvent):void
		{
			evt.currentTarget.removeEventListener(MouseEvent.ROLL_OUT,OnsubcatThumbOut);
			if(selectedSubCatId!=evt.currentTarget.subcatid)
			{
				evt.currentTarget.gotoAndStop(1);
				//highlightCurrentCategory(selectedCatId);
			}
			else
			{
				evt.currentTarget.gotoAndStop(3);
			}
		}
		//------------------------------------------------------------------
		private function OnsubcatThumbClicked(evt:MouseEvent):void
		{
			BtnBgChrObjUp.visible=true;
			BtnBgChrObjDown.visible=true;
			
			bgchrobjThumbList=new Array();
			bgchrobjContent=new MovieClip();
			scpContent.source=null;
			lblStatus.visible=true;
			lblStatus.text="Loading...";
			deselectallcat();
			deselectall();
			selectedCatSubCat.cliparttype=clipartType;
			selectedCatSubCat.catid=evt.currentTarget.catid;
			selectedCatSubCat.subcatid=evt.currentTarget.subcatid;
			
			selectedCatId=evt.currentTarget.catid;
			selectedSubCatId=evt.currentTarget.subcatid;
			evt.currentTarget.gotoAndStop(3);	
			selectCurrentCategory(evt.currentTarget.catid,evt.currentTarget.subcatname);
			dispatchEvent(new ObjectEvent("SUBCAT_THUMB_CLICKED",{ClipartType:clipartType,CatId:evt.currentTarget.catid,SubCatId:evt.currentTarget.subcatid},false,true));
			dispatchEvent(new ClipartEvent("SAVE_SELECTED_CAT_SUBCAT_ID_FROM_CLIPARTVIEW",{cliparttype:clipartType,catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid},false,true));
						
		}
		//------------------------------------------------------------------
		//------------------------------------------------------------------
		//------------------------------------------------------------------
		
		private function LoadBgChrObjThumbList()
		{
			trace("LoadBgChrObjThumbList");
			
			//for debug
			//var blankthumbids:Array=[10057,10058,10059,10060];//,10041,10044,10051
			//trace("LoadBgChrObjThumbList1=>catlen="+dataXml..Background.length()+",chr len="+dataXml..Character.length()+",obj len="+dataXml..Object.length());
			//showMore(true);
			lblStatus.visible=false;
			updateScroll();
			bgchrobjThumbList=new Array();
			if(clipartType=="BG")
			{				
				lblStatus.text=""+dataXml..Background.length()+" Backgrounds";
				if(dataXml..Background.length()>0)
				{				
				
					bgchrobjThumbList=new Array();
						
					for(var bv:int=0;bv<dataXml..Background.length();bv++)
					{
						//for(var bi:int=0;bi<blankthumbids.length;bi++)
						//{
							//if(Number(dataXml..Background[bv].BgId)==blankthumbids[bi])
							//{
								var bgThumb:caBgChrObjRecord=new caBgChrObjRecord();
								var burl:String=dataXml..Background[bv].Url;
								var bturl:String=dataXml..Background[bv].ThumbUrl;
								
								trace("url:"+dataXml..Background[bv].Url+","+bturl);
								if(burl.length<=0)
								{
									burl=bturl;
									var cexp:RegExp =/thumb.swf/gi;					        
									burl=bturl.replace(cexp,"1.swf");
								}
								//trace("url2:"+dataXml..Background[bv].Url);
								
								bgThumb.catid=Number(dataXml..Background[bv].CatId);
								
								bgThumb.subcatid=Number(dataXml..Background[bv].SubCatId);
								
								bgThumb.id=Number(dataXml..Background[bv].BgId);
								
								bgThumb.rtype="BG";
								bgThumb.url=burl;
								
								bgThumb.thumburl=dataXml..Background[bv].ThumbUrl;
								
								bgThumb.Name=dataXml..Background[bv].BgName;
								
								//bgThumb.lblText.text=""+bgThumb.id;
								var bgswfComp:SwfThumbComponent=new SwfThumbComponent();
								bgswfComp.resizeType="FIXED";
								//bgswfComp.addEventListener("CATHUMB_CLICKED",OnThumbnailClicked);
								
								bgswfComp.loadSWF(dataXml..Background[bv].BgId,"BG",dataXml..Background[bv].ThumbUrl,dataXml..Background[bv].Url,150,150,null);
								
								
								bgThumb.addChild(bgswfComp);							
								bgswfComp.x=60;
								bgswfComp.y=55;
								
								bgchrobjThumbList.push({name:dataXml..Background[bv].BgName,target:bgThumb,subtarget:bgswfComp});
								
								bgThumb.addEventListener(MouseEvent.CLICK,OnBGThumbnailClicked);
								
								//imgthumb.addEventListener("BG_THUMB_CLICKED",OnBackgroundThumbnailClicked);
								bgThumb.addEventListener(MouseEvent.MOUSE_DOWN,OnBGThumbnailDown);	
								bgThumb.addEventListener(MouseEvent.MOUSE_UP,OnBGThumbnailUp);
								bgThumb.addEventListener(MouseEvent.MOUSE_OUT,OnBGThumbnailOut);
							//}//bi
							
						//}//bi
						
					}
				}
			}
			else if(clipartType=="CHR")
			{
				lblStatus.text=""+dataXml..Character.length()+" Characters";
				if(dataXml..Character.length()>0)
				{
					bgchrobjThumbList=new Array();
					
					for(var bv2:int=0;bv2<dataXml..Character.length();bv2++)
					{							
							
							var chrThumb:caBgChrObjRecord=new caBgChrObjRecord();
							
							var curl:String=dataXml..Character[bv2].Url;
							var cturl:String=dataXml..Character[bv2].ThumbUrl;
							
							trace("url:"+dataXml..Character[bv2].Url);
							if(curl.length<=0)
							{
								curl=cturl;
								var cexp2:RegExp =/thumb.swf/gi;					        
								curl=cturl.replace(cexp2,"1.swf");
							}
							/*trace("url2:"+dataXml..Character[bv2].Url);
							trace("CatId:"+dataXml..Character[bv2].CatId);
							trace("SubCatId:"+dataXml..Character[bv2].SubCatId);
							trace("ChrId:"+dataXml..Character[bv2].ChrId);
							trace("ThumbUrl:"+dataXml..Character[bv2].ThumbUrl);
							trace("ChrName:"+dataXml..Character[bv2].ChrName);*/
							
							chrThumb.catid=Number(dataXml..Character[bv2].CatId);
							
							chrThumb.subcatid=Number(dataXml..Character[bv2].SubCatId);
							
							chrThumb.id=Number(dataXml..Character[bv2].ChrId);
							
							chrThumb.rtype="CHR";
							
							
							chrThumb.url=curl;
							
							chrThumb.thumburl=dataXml..Character[bv2].ThumbUrl;
							
							chrThumb.Name=dataXml..Character[bv2].ChrName;
							
							//chrThumb.lblText.text=""+chrThumb.id;
							
							var chrswfComp:SwfThumbComponent=new SwfThumbComponent();
							chrswfComp.resizeType="FIXED";
							//chrswfComp.addEventListener("CATHUMB_CLICKED",OnThumbnailClicked);
							
							chrswfComp.loadSWF(dataXml..Character[bv2].ChrId,"CHR",dataXml..Character[bv2].ThumbUrl,dataXml..Character[bv2].Url,150,150,null);
							
							
							chrThumb.addChild(chrswfComp);							
							chrswfComp.x=60;
							chrswfComp.y=55;
							
							bgchrobjThumbList.push({name:dataXml..Character[bv2].ChrName,target:chrThumb,subtarget:chrswfComp});
							
							chrThumb.addEventListener(MouseEvent.CLICK,OnCHRThumbnailClicked);
							
							
							
						
					}
				}
			}
			else if(clipartType=="OBJ")
			{
				lblStatus.text=""+dataXml..Object.length()+" Objects";
				if(dataXml..Object.length()>0)
				{
					bgchrobjThumbList=new Array();
					
					for(var bv3:int=0;bv3<dataXml..Object.length();bv3++)
					{		
							var objThumb:caBgChrObjRecord=new caBgChrObjRecord();
							
							var ourl:String=dataXml..Object[bv3].Url;
							var oturl:String=dataXml..Object[bv3].ThumbUrl;
							
							//trace("url:"+dataXml..Object[bv3].Url);
							if(ourl.length<=0)
							{
								ourl=oturl;
								var cexp3:RegExp =/thumb.swf/gi;					        
								ourl=oturl.replace(cexp3,"1.swf");
							}
							//trace("url2:"+dataXml..Object[bv3].Url);
							
							objThumb.catid=Number(dataXml..Object[bv3].CatId);
							
							objThumb.subcatid=Number(dataXml..Object[bv3].SubCatId);
							
							objThumb.id=Number(dataXml..Object[bv3].ObjId);
							
							objThumb.rtype="OBJ";
							objThumb.url=ourl;
							
							objThumb.thumburl=dataXml..Object[bv3].ThumbUrl;
							
							objThumb.Name=dataXml..Object[bv3].ObjName;
							
							//objThumb.lblText.text=""+objThumb.id;
							
							var objswfComp:SwfThumbComponent=new SwfThumbComponent();
							objswfComp.resizeType="FIXED";
							//objswfComp.addEventListener("CATHUMB_CLICKED",OnThumbnailClicked);
							
							objswfComp.loadSWF(dataXml..Object[bv3].ObjId,"OBJ",dataXml..Object[bv3].ThumbUrl,dataXml..Object[bv3].Url,150,150,null);
							
							
							objThumb.addChild(objswfComp);							
							objswfComp.x=60;
							objswfComp.y=55;
							
							bgchrobjThumbList.push({name:dataXml..Object[bv3].ObjName,target:objThumb,subtarget:objswfComp});
							
							objThumb.addEventListener(MouseEvent.CLICK,OnOBJThumbnailClicked);
							
							
							objThumb.addEventListener(MouseEvent.MOUSE_DOWN,OnOBJThumbnailDown);	
							objThumb.addEventListener(MouseEvent.MOUSE_UP,OnOBJThumbnailUp);
							objThumb.addEventListener(MouseEvent.MOUSE_OUT,OnOBJThumbnailOut);
						
					}
				}
			}
			scpContent.verticalScrollPosition=0;			
			updateBgChrObjThumbList();
			
		}
		
		//------------------------------------------------------------------
		private function updateBgChrObjThumbList()
		{
			bgchrobjContent=new MovieClip();
			scpContent.source=null;
			var xp:int=40;//50;
			var yp:int=45;//60;//75;
			var xoffset:int=90;//30;
			var yoffset:int=100;
			var w:int=0;
			var col:int=0;
			bgchrobjThumbList.sortOn("name",Array.CASEINSENSITIVE);
			
			for(var dv:int=0;dv<bgchrobjThumbList.length;dv++)
			{			
				col++;
				bgchrobjContent.addChild(bgchrobjThumbList[dv].target);
				bgchrobjThumbList[dv].target.x=xp;
				bgchrobjThumbList[dv].target.y=yp;				
				xp+=bgchrobjThumbList[dv].target.width+xoffset;
				
				if(col==3)
				{
					//trace("updateBgChrObjThumbList1=>"+yp);
					col=0;
					xp=40;//50;
					yp+=bgchrobjThumbList[dv].target.height+yoffset;
					//trace("updateBgChrObjThumbList2=>"+yp);
				}
				
			}			
			
			//---------------------------------------------
			//to adjust bottom scroll at last page
			//---------------------------------------------
			xp=40;//50;
			yp+=yoffset;
			
			blankSprite=new Sprite();
			blankSprite.graphics.beginFill(0x00ff00,0.0);
			blankSprite.graphics.drawRect(0,0,100,100);
			blankSprite.graphics.endFill();
			bgchrobjContent.addChild(blankSprite);
			blankSprite.x=xp;
			blankSprite.y=yp;
			//---------------------------------------------
			
			
			startLoad(2);//1
			bgchrobjContent.graphics.beginFill(0xffffff,0.0);
			bgchrobjContent.graphics.drawRect(0,0,120,bgchrobjContent.height+100);
			bgchrobjContent.graphics.endFill();
			
			//debug
			//scpContent.horizontalScrollPolicy="on";
			//scpContent.verticalScrollPolicy="on";	
			//scpContent.verticalScrollBar.visible=true;
			
			
			scpContent.horizontalScrollPolicy="off";
			scpContent.verticalScrollPolicy="off";				
			scpContent.source=bgchrobjContent;
			scpContent.update();
			scpContent.verticalScrollBar.visible=false;
						
			updateScroll();
			
			SelectSubCat(selectedCatSubCat.subcatid);
			//scpContent.scrollDrag=true;
			//trace("bgchrobjContent.height=>"+bgchrobjContent.height);
			//trace("maxVerticalScrollPosition=>"+scpContent.maxVerticalScrollPosition);
		}
		
		private function OnBGThumbnailClicked(evt:MouseEvent)
		{
			//trace("OnBGThumbnailClicked=>"+evt.currentTarget.rtype+","+evt.currentTarget.id);
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("BGTHUMB_CLICKED",obj,false,true));
		}
		
		private function OnBGThumbnailDown(evt:MouseEvent)
		{
			//trace("OnBGThumbnailDown=>"+evt.currentTarget.rtype+","+evt.currentTarget.id);
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("BGTHUMB_DOWN",obj,false,true));
		}
		
		private function OnBGThumbnailUp(evt:MouseEvent)
		{
			//trace("OnBGThumbnailUp=>"+evt.currentTarget.rtype+","+evt.currentTarget.id);
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("BGTHUMB_UP",obj,false,true));
		}
		
		private function OnBGThumbnailOut(evt:MouseEvent)
		{
			//trace("OnBGThumbnailOut=>"+evt.currentTarget.rtype+","+evt.currentTarget.id);
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("BGTHUMB_OUT",obj,false,true));
		}
		
		private function OnCHRThumbnailClicked(evt:MouseEvent)
		{
			//trace("OnCHRThumbnailClicked=>"+evt.currentTarget.rtype+","+evt.currentTarget.id)
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("CHRTHUMB_CLICKED",obj,false,true));
		}
		
		private function OnOBJThumbnailClicked(evt:MouseEvent)
		{
			//trace("OnOBJThumbnailClicked=>"+evt.currentTarget.rtype+","+evt.currentTarget.id)
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("OBJTHUMB_CLICKED",obj,false,true));
		}
		
		private function OnOBJThumbnailDown(evt:MouseEvent)
		{
			//trace("OnOBJThumbnailDown=>"+evt.currentTarget.rtype+","+evt.currentTarget.id)
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("OBJTHUMB_DOWN",obj,false,true));
		}
		
		private function OnOBJThumbnailUp(evt:MouseEvent)
		{
			//trace("OnOBJThumbnailUp=>"+evt.currentTarget.rtype+","+evt.currentTarget.id)
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("OBJTHUMB_UP",obj,false,true));
		}
		
		private function OnOBJThumbnailOut(evt:MouseEvent)
		{
			//trace("OnOBJThumbnailOut=>"+evt.currentTarget.rtype+","+evt.currentTarget.id)
			var obj:Object={catid:evt.currentTarget.catid,subcatid:evt.currentTarget.subcatid,id:evt.currentTarget.id,Name:evt.currentTarget.Name,type:evt.currentTarget.rtype,url:evt.currentTarget.url,thumburl:evt.currentTarget.thumburl};
			dispatchEvent(new ClipartEvent("OBJTHUMB_OUT",obj,false,true));
		}
		
		
		
		
		
		private function startLoad(pno:int):void
		{
			//if page 1 show load first 9 only
			for(var dv:int=0;dv<bgchrobjThumbList.length;dv++)
			{
				bgchrobjThumbList[dv].subtarget.startLoad();
				if(pno==1 && dv==8)
				{
					break;
				}
			}
			
		}
					
			
					
					
		private function onfinishscrollTween2()
		{
			if(scpContent.verticalScrollPosition<=0)
			{
				BtnBgChrObjUp.alpha=0.3;
				BtnBgChrObjDown.alpha=1.0;
					
				BtnBgChrObjUp.enabled=false;
				BtnBgChrObjDown.enabled=true;
			}
			else if(scpContent.verticalScrollPosition>=scpContent.maxVerticalScrollPosition)
			{
				BtnBgChrObjUp.alpha=1.0;
				BtnBgChrObjDown.alpha=0.3;
					
				BtnBgChrObjUp.enabled=true;
				BtnBgChrObjDown.enabled=false;
			}
			else
			{
				BtnBgChrObjUp.alpha=1.0;
				BtnBgChrObjDown.alpha=1.0;
					
				BtnBgChrObjUp.enabled=true;
				BtnBgChrObjDown.enabled=true;
			}
		}
		//------------------------------------------------------------------
		private function OnBtnBgChrObjUp(evt:MouseEvent):void
		{	
			this.addEventListener(Event.ENTER_FRAME,OnBtnBgChrObjUpLoop);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnBtnBgChrObjUpMouseUp);
			//scrollspeed2=250;
			//TweenLite.to(scpContent, 0.3, { verticalScrollPosition:(scpContent.verticalScrollPosition-scrollspeed2),onComplete:onfinishscrollTween2 } );
		}
		
		private function OnBtnBgChrObjUpLoop(evt:Event)
		{
			scrollspeed2=(scrollspeed2<25)?(scrollspeed2+0.5):25;
			scpContent.verticalScrollPosition-=scrollspeed2;
		}
		
		private function OnBtnBgChrObjUpMouseUp(evt:Event)
		{
			this.removeEventListener(Event.ENTER_FRAME,OnBtnBgChrObjUpLoop);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnBtnBgChrObjUpMouseUp);
			
			if(scpContent.verticalScrollPosition<=0)
			{
				BtnBgChrObjUp.alpha=0.3;
				BtnBgChrObjDown.alpha=1.0;
					
				BtnBgChrObjUp.enabled=false;
				BtnBgChrObjDown.enabled=true;
			}
			else if(scpContent.verticalScrollPosition>=scpContent.maxVerticalScrollPosition)
			{
				BtnBgChrObjUp.alpha=1.0;
				BtnBgChrObjDown.alpha=0.3;
					
				BtnBgChrObjUp.enabled=true;
				BtnBgChrObjDown.enabled=false;
			}
			else
			{
				BtnBgChrObjUp.alpha=1.0;
				BtnBgChrObjDown.alpha=1.0;
					
				BtnBgChrObjUp.enabled=true;
				BtnBgChrObjDown.enabled=true;
			}
		}
		
		private function OnBtnBgChrObjDown(evt:MouseEvent):void
		{		
			this.addEventListener(Event.ENTER_FRAME,OnBtnBgChrObjDownLoop);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,OnBtnBgChrObjDownMouseUp);
			//scrollspeed2=250;
			//TweenLite.to(scpContent, 0.3, { verticalScrollPosition:(scpContent.verticalScrollPosition+scrollspeed2),onComplete:onfinishscrollTween2 } );
		}
		
		private function OnBtnBgChrObjDownLoop(evt:Event)
		{
			scrollspeed2=(scrollspeed2<25)?(scrollspeed2+0.5):25;
			scpContent.verticalScrollPosition+=scrollspeed2;
		}
		
		private function OnBtnBgChrObjDownMouseUp(evt:Event)
		{
			this.removeEventListener(Event.ENTER_FRAME,OnBtnBgChrObjDownLoop);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,OnBtnBgChrObjDownMouseUp);
			
			if(scpContent.verticalScrollPosition<=0)
			{
				BtnBgChrObjUp.alpha=0.3;
				BtnBgChrObjDown.alpha=1.0;
					
				BtnBgChrObjUp.enabled=false;
				BtnBgChrObjDown.enabled=true;
			}
			else if(scpContent.verticalScrollPosition>=scpContent.maxVerticalScrollPosition)
			{
				BtnBgChrObjUp.alpha=1.0;
				BtnBgChrObjDown.alpha=0.3;
					
				BtnBgChrObjUp.enabled=true;
				BtnBgChrObjDown.enabled=false;
			}
			else
			{
				BtnBgChrObjUp.alpha=1.0;
				BtnBgChrObjDown.alpha=1.0;
					
				BtnBgChrObjUp.enabled=true;
				BtnBgChrObjDown.enabled=true;
			}
		}
		
		
	}
}