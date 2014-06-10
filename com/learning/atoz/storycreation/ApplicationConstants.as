package com.learning.atoz.storycreation
{	
	public class ApplicationConstants
	{	
		//no to run from staging.emantras.com
		public static const SAMEDOMAIN:String="YES"; //"NO"; // 
		
		//Maximum Page Limit
		public static const MAXIMUM_PAGE_LIMIT:int=36;
		
		//-----------------------------------------------------
		public static const SAVE_BOOK_TIMER_INTERVAL:int=1000;//1sec=1000 millisecond , ex: 2 sec=30*1000=30000 30 sec
		public static const SAVE_BOOK_TIMER_REPEAT_COUNT:int=30;//30 secs
		public static const SAVE_BOOK_TIMER_RESTART:String 	= "SaveBooktimerReStart";
		public static const SAVE_BOOK_TIMER_STOP:String 	= "SaveBooktimerStop";
		//-----------------------------------------------------
		public static const STARTUP:String	 	= "Startup";	
		
		public static const ASSETS_MODE:String 	= "REMOTE";//"LOCAL"; //
		
		public static var USER_TYPE:String 	= "FLUENT";//"EMERGENT";//
		public static const SHOW_HIDE_ADD_COPY_PAGE:String 	= "ShowHideAddCopyPage";
		
		//-----------------------------------------------------
		public static const ASSETS_PATH:String 	= ""; //"../";//"../";//  
		//-----------------------------------------------------
		
		public static const THEME_DATA_LOADED:String 	= "ThemeDataLoaded";
		public static const CLIPART_DATA_LOADED:String 	= "ClipartDataLoaded";
		public static const CONFIG_DATA_LOADED:String 	= "ConfigDataLoaded";
		public static const BG_MENU_UPDATE:String 	= "BGMenuClipartUpdate";		
		public static const OBJ_MENU_UPDATE:String 	= "OBJMenuClipartUpdate";
		
		public static const BG_CLIPART_CADATA_LOADED:String 	= "BGClipartDataLoaded";
		public static const CHR_CLIPART_CADATA_LOADED:String 	= "CHRClipartDataLoaded";
		public static const OBJ_CLIPART_CADATA_LOADED:String 	= "OBJClipartDataLoaded";
		
		//-----------------------------------------------------
		public static const ADD_MENU:String 	= "AddMenu";
		public static const SHOW_MENU:String 	= "ShowMenu";
		//-----------------------------------------------------
		public static const ADD_PAGE_NAVIGATION:String 	= "AddPageNavigation";
		public static const SHOW_PAGE_NAVIGATION:String = "PageNavigationShow";		
		//-----------------------------------------------------
		
		public static const PRELOAD_BG_THUMBNAIL:String = "PreloadBgThumbnail";		
		public static const PRELOAD_CHR_THUMBNAIL:String = "PreloadChrThumbnail";
		public static const PRELOAD_OBJ_THUMBNAIL:String = "PreloadObjThumbnail";
		public static const PRELOAD_LAYOUT_THUMBNAIL:String = "PreloadLayoutThumbnail";
		public static const PRELOAD_TEXTCALLOUT_THUMBNAIL:String = "PreloadTextCalloutThumbnail";
		
		//-----------------------------------------------------
		public static const ADD_CANVAS:String = "AddCanvas";
		public static const SHOW_CANVAS:String = "ShowCanvas";
		public static const UPDATE_CANVAS:String = "UpdateCanvas";
		public static const CLEAR_CANVAS:String = "ClearCanvas";
		public static const ADD_CANVAS_BG:String 	= "AddCanvasBg";
		public static const REMOVE_CANVAS_BG:String 	= "RemoveCanvasBg";
		//-----------------------------------------------------
		
		public static const ADD_CHARACTER:String 	= "AddCharacter";
		public static const REMOVE_CHARACTER:String 	= "RemoveCharacter";		
		public static const RESTORE_CHARACTER:String 	= "RestoreCharacter";
		
		
		public static const ADD_OBJECT:String 	= "AddObject";		
		public static const REMOVE_OBJECT:String 	= "RemoveObject";
		public static const RESTORE_OBJECT:String 	= "RestoreObject";
		
		public static const CANVAS_CREATED:String 	= "CanvasCreated";
		public static const INIT_CANVAS_CONTENT:String 	= "InitCanvasContent";
		
		public static const SHOW_LAYOUT_1:String 	= "ShowLayout1";
		public static const SHOW_LAYOUT_2:String 	= "ShowLayout2";
		public static const SHOW_LAYOUT_3:String 	= "ShowLayout3";
		public static const SHOW_LAYOUT_4:String 	= "ShowLayout4";
		public static const SHOW_LAYOUT_5:String 	= "ShowLayout5";
		public static const SHOW_LAYOUT_6:String 	= "ShowLayout6";
		
		public static const SAVE_BEFORE_REDIRECT_PAGE:String 	= "SaveBeforeRedirectPage";
		
		public static const SHOW_LAYOUT_SELECTION:String 	= "ShowLayoutSelection";
		
		public static const SHOW_TEXT_TOOLBOX:String 	= "ShowTextToolBox";
		public static const CLOSE_TEXT_TOOLBOX:String 	= "CloseTextToolBox";
		
		public static const SHOW_IMAGE_TOOLBOX:String 	= "ShowImageToolBox";
		public static const CLOSE_IMAGE_TOOLBOX:String 	= "CloseImageToolBox";
		
		public static const ADD_CALLOUTTEXT:String 	= "AddCalloutText";
		//public static const ADD_CALLOUTTEXT2:String 	= "AddCalloutText2";
		
		public static const RESTORE_CALLOUT_TEXT:String 	= "RestoreCalloutText";
		
		public static const SHOW_CLIPARTVIEW:String 	= "ShowClipArtView";
		public static const CLOSE_CLIPARTVIEW:String 	= "CloseClipArtView";
		
		public static const NEW_BOOK:String 	= "NewBook";
		public static const EDIT_BOOK:String 	= "EditBook";
		public static const SAVE_BOOK:String 	= "SaveBook";
		public static const SAVE_BOOK_AND_STOP_TIMER:String 	= "SaveBookAndStopTimer";
		public static const VIEW_BOOK:String 	= "ViewBook";
		public static const DELETE_PAGE_THUMBNAIL:String 	= "DeletePageThumbnail";
		
		public static const SHOW_WAIT_POPUP:String 	= "ShowWaitPopup";
		public static const CLOSE_WAIT_POPUP:String 	= "CloseWaitPopup";
		
		public static const ADD_PAGE_THUMBNAIL:String 	= "AddPageThumbnail";
		public static const ADD_PAGE:String 	= "AddPage";
		
		public static const SHOW_BOOK_MANAGER:String 	= "ShowBookManager";
		public static const CLOSE_BOOK_MANAGER:String 	= "CloseBookManager";
		
		public static const SHOW_HOME_BTN:String 	= "ShowHomeBtn";
		public static const CLOSE_HOME_BTN:String 	= "CloseHomeBtn";
		
		public static const SHOW_BOOK_VIEWER:String 	= "ShowBookViewer";
		public static const CLOSE_BOOK_VIEWER:String 	= "CloseBookViewer";
		
		
		public static const SHOW_COPY_PASTE:String 	= "ShowCopyPaste";
		public static const CLOSE_COPY_PASTE:String 	= "HideCopyPaste";		
		public static const COPY_PAGE:String 	= "CopyPage";
		public static const PASTE_PAGE:String 	= "PastePage";
		public static const ENABLE_PASTE:String 	= "EnablePaste";
		public static const DISABLE_PASTE:String 	= "DisablePaste";
		public static const COPY_TASK_COMPLETED:String 	= "CopyTaskcompleted";
		public static const PASTE_TASK_COMPLETED:String 	= "PasteTaskcompleted";
		
		
		public static const SAVE_TEXT:String 	= "SaveText";
		
		public static const RESTORE_DATA:String 	= "RestoreData";
		
		public static const SHOW_ASSIGNMENT_MANAGER:String 	= "ShowAssignmentManager";
		public static const CLOSE_ASSIGNMENT_MANAGER:String 	= "CloseAssignmentManager";
		
		public static const LOADED_ASSIGNMENT_DATA:String 	= "LoadedAssignmentData";
		public static const LOADED_STORY_STARTERS_DATA:String 	= "LoadedStoryStartersData";
		public static const LOADED_WRITING_PLANNER_DATA:String 	= "LoadedWritingPlannerData";
		
		public static const SAVE_WRITING_PLANNER_COMPLETED:String 	= "SaveWritingPlannerCompleted";
		public static const SAVE_WRITING_PLANNER_ERROR:String 	= "SaveWritingPlannerError";
		
		public static const LOAD_WRITING_PLANNER_PROXY:String 	= "LoadWritingPlanerProxy";
		
		public static const START_SEARCH:String 	= "StartSearch";
		public static const SEARCH_RESULT:String 	= "SearchResult";
		
		public static const UPDATE_PAGETHUMB_BG:String 	= "UpdatePageThumbBg";
		
		
		public static const SHOW_CHECKLIST:String 	= "ShowCheckList";
		public static const CLOSE_CHECKLIST:String 	= "CloseCheckList";		
		
		public static const SUBMIT_BOOK:String 	= "SubmitBook";
		public static const SUBMIT_BOOK_COMPLETED:String 	= "SubmitBookCompleted";
		
		public static const CLEAR_ASSIGNMENT_DATA:String 	= "ClearAssignmentData";
		
		public static const UPDATE_PAGE_THUMB_SELECTION:String 	= "UpdatePageThumbSelection";
		
		public static const ADDPAGE_ENABLE:String 	= "AddPageEnable";
		public static const ADDPAGE_DISABLE:String 	= "AddPageDisable";
		public static const DRAG_ADD_OBJECT:String 	= "DragAddObject";
		public static const DRAG_ADD_BG:String 	= "DragAddBg";
		public static const DRAG_ADD_CALLOUT:String 	= "DragAddCallout";
		
		
		public static const DUPLICATE_ENABLE:String 	= "DuplicateEnable";
		public static const DUPLICATE_DISABLE:String 	= "DuplicateDisable";
		
		public static const CHECK_FOR_DUPLICATE_BTN:String 	= "CheckForDuplicateBtn";
		
		
	}
}