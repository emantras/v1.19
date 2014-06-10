package com.learning.atoz.storycreation
{
	import com.learning.atoz.storycreation.controller.*;
	import com.learning.atoz.storycreation.view.components.events.ObjectEvent;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.observer.Notification;
		
	public class StoryCreationFacade extends Facade implements IFacade
	{			
		//-----------------------------------------------------
		// Singleton Method
		//-----------------------------------------------------
        public static function getInstance(): StoryCreationFacade
		{
            if (instance == null) {
				instance = new StoryCreationFacade( );
			}
            return instance as StoryCreationFacade;
        }
		//-----------------------------------------------------
		
		//-----------------------------------------------------
		// Broadcast the STARTUP Notification
		//-----------------------------------------------------
		public function startup(app:Object):void
		{				
			notifyObservers(new Notification(ApplicationConstants.STARTUP, app));
		}
		//-----------------------------------------------------
		
		//-----------------------------------------------------
        // Registering Commands with the Controller         
		//-----------------------------------------------------
        override protected function initializeController():void
		{
            super.initializeController();            
            registerCommand(ApplicationConstants.STARTUP, StartUpCommand);
        }
		//-----------------------------------------------------
		
		
	}
}