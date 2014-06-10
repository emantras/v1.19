package com.learning.atoz.storycreation.controller
{
	import com.learning.atoz.storycreation.StoryCreationApp;
	import com.learning.atoz.storycreation.model.BGClipartProxy;
	import com.learning.atoz.storycreation.model.CHRClipartProxy;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.model.LoadAssignmentProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookViewerProxy;
	import com.learning.atoz.storycreation.model.LoadStoryStartersProxy;
	import com.learning.atoz.storycreation.model.LoadWritingPlannerProxy;
	import com.learning.atoz.storycreation.model.OBJClipartProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.SaveWritingPlannerProxy;
	import com.learning.atoz.storycreation.model.SearchProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.view.StoryCreationMediator;
	import com.learning.atoz.storycreation.model.SubmitBookProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.learning.atoz.storycreation.model.BookViewDataProxy;
	
	/*
	import com.learning.atoz.storycreation.StoryCreationApp;
	import com.learning.atoz.storycreation.model.BGClipartProxy;
	import com.learning.atoz.storycreation.model.CHRClipartProxy;
	import com.learning.atoz.storycreation.model.ClipartProxy;
	import com.learning.atoz.storycreation.model.DataProxy;
	import com.learning.atoz.storycreation.model.LoadAssignmentProxy;
	import com.learning.atoz.storycreation.model.LoadBookProxy;
	import com.learning.atoz.storycreation.model.LoadBookViewerProxy;
	import com.learning.atoz.storycreation.model.LoadStoryStartersProxy;
	import com.learning.atoz.storycreation.model.LoadWritingPlannerProxy;
	import com.learning.atoz.storycreation.model.SaveBookProxy;
	import com.learning.atoz.storycreation.model.SaveWritingPlannerProxy;
	import com.learning.atoz.storycreation.model.ThemeProxy;
	import com.learning.atoz.storycreation.view.StoryCreationMediator;
	import com.learning.atoz.storycreation.model.SubmitBookProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.learning.atoz.storycreation.model.OBJClipartProxy;
	*/

	public class StartUpCommand extends SimpleCommand implements ICommand
	{
		
		
		override public function execute(notification:INotification):void
		{
			// Create and register proxy
			
			//facade.registerProxy(new ConfigProxy());
			facade.registerProxy(new LoadAssignmentProxy());
			facade.registerProxy(new ThemeProxy());
			facade.registerProxy(new ClipartProxy());
			facade.registerProxy(new DataProxy());
			facade.registerProxy(new SaveBookProxy());
			facade.registerProxy(new LoadBookProxy());
			facade.registerProxy(new LoadBookViewerProxy());
			facade.registerProxy(new LoadStoryStartersProxy());
			facade.registerProxy(new LoadWritingPlannerProxy());
			facade.registerProxy(new SaveWritingPlannerProxy());
			facade.registerProxy(new BGClipartProxy());
			facade.registerProxy(new CHRClipartProxy());
			facade.registerProxy(new OBJClipartProxy());
			facade.registerProxy(new SearchProxy() );
			facade.registerProxy(new SubmitBookProxy() );
			facade.registerProxy(new BookViewDataProxy());
			
			    
			// Create and register the mediator, stage passed as the viewcomponent of the Mediator
			//var stage:Stage = notification.getBody() as Stage;
			var app:StoryCreationApp=notification.getBody() as StoryCreationApp;
					
			facade.registerMediator(new StoryCreationMediator(app));
			
		}
		
		
	}
}