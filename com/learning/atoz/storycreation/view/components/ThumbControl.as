package com.learning.atoz.storycreation.view.components
{
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	/*
		ThumbControl is used to show the thumbnail swf
	*/
	public class ThumbControl extends MovieClip
	{		
		private var ldr:Loader = new Loader();		
		private var url:String;
		private var thumburl:String;
		private var isLoaded:Boolean=false;
		private var swfComp:SwfComponent;
		public var normalWidth:int=65;
		public var normalHeight:int=65;
		public var overWidth:int=75;
		public var overHeight:int=75;
		private var itemData:Object={unqid:"",id:0,name:"",catid:0,subcatid:0,url:"",thumburl:"",type:"",xpos:0,ypos:0,width:0,height:0,rotation:0,scalex:1,scaley:1};
		
		private var nscalex:Number=1.0;
		private var nscaley:Number=1.0;
		private var oscalex:Number=1.0;
		private var oscaley:Number=1.0;
		
		//-----------------------------------------------------		
		public function ThumbControl()
		{			
			this.alpha=1.0;
			this.buttonMode=true;			
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//loading thumbnail swf catid:String,subcatid:String,turl:String,fullsizeurl:String
		//-----------------------------------------------------		
		public function loadswf(_itemData:Object,_resizetype:String="FIXED",loadingBGClip:*=null):void
		{
			   itemData=_itemData;
			  
			   thumburl=itemData.thumburl;
			   url=itemData.url;
			   
			   swfComp=new SwfComponent();
			   swfComp.resizeType=_resizetype;//"FIXED";
			   swfComp.addEventListener("THUMB_LOAD_COMPLETED",OnCharacterThumbnailLoadCompleted);
			   swfComp.loadSWF(thumburl,normalWidth,normalHeight,loadingBGClip);//default size			   
			   this.addChild(swfComp);
			   
			   this.addEventListener(MouseEvent.MOUSE_DOWN,OnthumbnailMouseDown);
			   this.addEventListener(MouseEvent.MOUSE_UP,OnthumbnailMouseUp);
			   this.addEventListener(MouseEvent.MOUSE_OUT,OnthumbnailMouseOut);
			   this.addEventListener(MouseEvent.CLICK,OnthumbnailClick);
			   this.addEventListener(MouseEvent.MOUSE_OVER,OnthumbnailOver);
			   this.addEventListener(MouseEvent.MOUSE_OUT,OnthumbnailOut);
		}
		//-----------------------------------------------------		
		
		public function select(sel:Boolean):void
		{
			if(swfComp!=null)
			{
				swfComp.select(sel);
			}
		}
	
		//-----------------------------------------------------				
		private function OnCharacterThumbnailLoadCompleted(evt:ObjectEvent):void
		{
			this.lblLoading.visible=false;			
			nscalex=swfComp.scaleX;
			nscaley=swfComp.scaleY;
			
			oscalex=swfComp.scaleX+0.3;
			oscaley=swfComp.scaleY+0.3;
			
		}
		//-----------------------------------------------------
		//-----------------------------------------------------		
		//dispatching event when the user clickes the thumbnail
		//-----------------------------------------------------		
		private function OnthumbnailClick(evt:MouseEvent):void
		{
			dispatchEvent(new ObjectEvent("BG_THUMB_CLICKED",itemData,false,true));
		}
		//-----------------------------------------------------		
		private function OnthumbnailMouseDown(evt:MouseEvent):void
		{
			dispatchEvent(new ObjectEvent("BG_THUMB_DOWN",itemData,false,true));
		}
		//-----------------------------------------------------		
		private function OnthumbnailMouseUp(evt:MouseEvent):void
		{
			dispatchEvent(new ObjectEvent("BG_THUMB_UP",itemData,false,true));
		}		
		//-----------------------------------------------------		
		private function OnthumbnailMouseOut(evt:MouseEvent):void
		{
			dispatchEvent(new ObjectEvent("BG_THUMB_OUT",itemData,false,true));
		}		
		//-----------------------------------------------------		
		//-----------------------------------------------------		
		//when the user mouse overs the thumbnail showing effect
		//-----------------------------------------------------		
		private function OnthumbnailOver(evt:MouseEvent):void
		{
			loadoverstate();
		}
		//-----------------------------------------------------		
				
		//-----------------------------------------------------		
		//when the user mouse outs the thumbnail reverting the effect
		//-----------------------------------------------------		
		private function OnthumbnailOut(evt:MouseEvent):void
		{
			loadnormalstate();
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//mouse over effect using tween lite
		//-----------------------------------------------------		
		private function loadnormalstate()
		{	
			//TweenLite.to(swfComp, 0.2, { width:normalWidth, height:normalHeight } );			
			TweenLite.to(swfComp, 0.2, { scaleX:nscalex, scaleY:nscaley } );
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//mouse out effect using tween lite
		//-----------------------------------------------------		
		private function loadoverstate()
		{			
			//TweenLite.to(swfComp, 0.2, { width:overWidth, height:overHeight } );			
			TweenLite.to(swfComp, 0.2, { scaleX:oscalex, scaleY:oscaley } );
		}		
		//-----------------------------------------------------		
		
		public function get data():Object
		{
			return itemData;
		}
	}
	
}
