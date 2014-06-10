package com.learning.atoz.storycreation.view
{
	import com.learning.atoz.audio.audioLib;
	import com.learning.atoz.menu.MenuComponent;
	import com.learning.atoz.menu.events.MenuEvent;
	import com.learning.atoz.storycreation.ApplicationConstants;
	import com.learning.atoz.storycreation.view.components.BackgroundMenuView;
	import com.learning.atoz.storycreation.view.components.CharacterMenuView;
	import com.learning.atoz.storycreation.view.components.LayoutMenuView;
	import com.learning.atoz.storycreation.view.components.MenuView;
	import com.learning.atoz.storycreation.view.components.ObjectMenuView;
	import com.learning.atoz.storycreation.view.components.TextCalloutMenuView;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/*
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import com.learning.atoz.storycreation.ApplicationConstants;
	
	import com.learning.atoz.audio.audioLib;
	import com.learning.atoz.menu.events.MenuEvent;
	import com.learning.atoz.storycreation.view.components.events.BgThumbEvent;
	import com.learning.atoz.storycreation.view.components.MenuView;
	import com.learning.atoz.menu.MenuComponent;
	import com.learning.atoz.storycreation.view.components.BackgroundMenuView;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	*/
	
	public class MenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MenuMediator";
		
		public static const CREATE_BGMENUVIEW:String = "CreateBGMenuView";
		public static const CREATE_CHRMENUVIEW:String = "CreateCHRMenuView";
		public static const CREATE_OBJMENUVIEW:String = "CreateOBJMenuView";
		public static const CREATE_LAYOUTMENUVIEW:String = "CreateLAYOUTMenuView";
		public static const CREATE_TEXTCALLOUTMENUVIEW:String = "CreateTEXTCALLOUTMenuView";
		
		private var menucomp:MenuComponent;
		private var backgroundview:BackgroundMenuView;
		private var characterview:CharacterMenuView;
		private var objectview:ObjectMenuView;
		private var layoutview:LayoutMenuView;
		private var textcalloutview:TextCalloutMenuView;
		
		//-----------------------------------------------------		
		public function MenuMediator(viewComponent:Object)
		{			
			super(NAME,viewComponent);			
		}
		//-----------------------------------------------------		
		override public function onRegister():void
		{			
			backgroundview=new BackgroundMenuView();
			backgroundview.name="backgroundMenuView";
			checkForMediator(CREATE_BGMENUVIEW, backgroundview);
			
			characterview=new CharacterMenuView();
			characterview.name="characterMenuView";
			checkForMediator(CREATE_CHRMENUVIEW, characterview);
			
			objectview=new ObjectMenuView();
			objectview.name="objectMenuView";
			checkForMediator(CREATE_OBJMENUVIEW, objectview);
			
			/*layoutview=new LayoutMenuView();
			layoutview.name="layoutMenuView";
			checkForMediator(CREATE_LAYOUTMENUVIEW, layoutview);*/
			
			textcalloutview=new TextCalloutMenuView();
			textcalloutview.name="textcalloutview";
			checkForMediator(CREATE_TEXTCALLOUTMENUVIEW, textcalloutview);
		}
		
		protected function checkForMediator( childSelector:String, child:Object ):void
		{
			switch (childSelector)
			{				
				case CREATE_BGMENUVIEW:
					if (!facade.hasMediator(BackgroundMenuViewMediator.NAME))
					{
						facade.registerMediator(new BackgroundMenuViewMediator(child));
					}					
					break;
				
				case CREATE_CHRMENUVIEW:
					if (!facade.hasMediator(CharacterMenuViewMediator.NAME))
					{
						facade.registerMediator(new CharacterMenuViewMediator(child));
					}					
					break;
				
				case CREATE_OBJMENUVIEW:
					if (!facade.hasMediator(ObjectMenuViewMediator.NAME))
					{
						facade.registerMediator(new ObjectMenuViewMediator(child));
					}					
					break;
				
				case CREATE_LAYOUTMENUVIEW:
					if (!facade.hasMediator(LayoutMenuViewMediator.NAME))
					{
						facade.registerMediator(new LayoutMenuViewMediator(child));
					}					
					break;
				
				case CREATE_TEXTCALLOUTMENUVIEW:
					if (!facade.hasMediator(TextCalloutMenuViewMediator.NAME))
					{
						facade.registerMediator(new TextCalloutMenuViewMediator(child));
					}					
					break;
			}
		}
		//-----------------------------------------------------		
		// a PureMVC override
		//-----------------------------------------------------		
		override public function getMediatorName():String
		{
			return NAME;// passes name to access this in the app
		}
		//-----------------------------------------------------		
		
		
		//-----------------------------------------------------		
		// a PureMVC override
		//-----------------------------------------------------		
		override public function getViewComponent():Object
		{
			return viewComponent; 
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		// what this mediator is listening for
		//-----------------------------------------------------		
		override public function listNotificationInterests():Array
		{
			return [ApplicationConstants.SHOW_MENU];
		}
		//-----------------------------------------------------		
		
		
		//-----------------------------------------------------		
		//Notification event
		//-----------------------------------------------------		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())// like Event.CHANGE
			{
				case ApplicationConstants.SHOW_MENU:					
					initMenu();					
				break;
				
				
				
			}
		}
		//-----------------------------------------------------		
		
		//-----------------------------------------------------		
		//Initiating and adding menu component 
		//-----------------------------------------------------		
		private function initMenu():void
		{
			menucomp=new MenuComponent();			
			menucomp.x=0;//25;
			menucomp.y=0;//60;
			menucomp.addEventListener("MENU_CLICKED",onMenuClick);
			DisplayObjectContainer(viewComponent).addChild(menucomp);
			menucomp.showDefaultMenu("mnuLayout");			
		}
		//-----------------------------------------------------		
		
		
		//-----------------------------------------------------		
		//This event triggered when the user clickes the menu tab
		//-----------------------------------------------------		
		private function onMenuClick(evt:MenuEvent)
		{
			
			if(evt._data=="mnuBackground")
			{		
				//audioLib.getInstance().playAudio(audioLib.BTN_BACKGROUND);
				audioLib.getInstance().playSound("BACKGROUND_AUDIO");
				var bv:*=evt.__target.getChildByName("backgroundView");
				if(bv==null)
				{
					//Adding backgrund thumbnail container
					if(backgroundview!=null)
					{
						evt.__target.addChild(backgroundview);
					}
				}
				
			}
			else if(evt._data=="mnuLayout")
			{
				//audioLib.getInstance().playAudio(audioLib.BTN_LAYOUT);
				audioLib.getInstance().playSound("LAYOUT_AUDIO");
				var ly:*=evt.__target.getChildByName("layoutView");
				if(ly==null)
				{
					//Adding backgrund thumbnail container
					if(layoutview!=null)
					{
						evt.__target.addChild(layoutview);
					}
				}
			}
			else if(evt._data=="mnuObjects")
			{
				//audioLib.getInstance().playAudio(audioLib.BTN_OBJECTS);
				audioLib.getInstance().playSound("OBJECTS_AUDIO");
				var obv:*=evt.__target.getChildByName("objectView");
				if(obv==null)
				{
					//Adding backgrund thumbnail container
					if(objectview!=null)
					{
						evt.__target.addChild(objectview);
					}
				}
			}
			else if(evt._data=="mnuCharacters")
			{
				//audioLib.getInstance().playAudio(audioLib.BTN_CHARACTERS);
				audioLib.getInstance().playSound("CHARACTERS_AUDIO");
				var cv:*=evt.__target.getChildByName("characterView");
				if(cv==null)
				{
					//Adding backgrund thumbnail container
					if(characterview!=null)
					{
						evt.__target.addChild(characterview);
					}
				}
				
			}
			else if(evt._data=="mnuText")
			{
				//audioLib.getInstance().playAudio(audioLib.BTN_TEXT);
				audioLib.getInstance().playSound("TEXT_AUDIO");
				var tc:*=evt.__target.getChildByName("textcalloutview");
				if(tc==null)
				{
					//Adding backgrund thumbnail container
					if(textcalloutview!=null)
					{
						evt.__target.addChild(textcalloutview);
					}
				}
			}
		}
		//-----------------------------------------------------		
		
			
		
		public function get menuView():MenuView
		{
			return viewComponent as MenuView;
		}
	}
}
