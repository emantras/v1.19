package com.learning.atoz.storycreation.model.vo
{	
	import com.learning.atoz.storycreation.ApplicationConstants;

	public class DataVo
	{
		//Local
		public var themedataURL_Local:String = ApplicationConstants.ASSETS_PATH+'assets/Xml/Theme.xml';
		public var clipartdataURL_Local:String = ApplicationConstants.ASSETS_PATH+'assets/Xml/Clipart.xml';
		
		//Remote
		public var themedataURL_Remote:String = "http://emantras.raz-kids.com/main/StoryResources/";
		public var clipartdataURL_Remote:String = "http://emantras.raz-kids.com/main/StoryResources/subCatId/";
		
		public var configURL:String = ApplicationConstants.ASSETS_PATH+'assets/Xml/config.xml';
		
		public var _xml:XML;
		
		public function DataVo()
		{
			// constructor code
		}

	}
	
}

