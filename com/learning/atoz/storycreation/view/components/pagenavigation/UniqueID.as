package com.learning.atoz.storycreation.view.components.pagenavigation
{	
	public class UniqueID
	{		
        private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];
    
       	//-----------------------------------------------------		
        public static function createUniqueID():String
        {
            var uid:Array = new Array(36);
            var index:int = 0;
            
            var i:int;
            var j:int;
            
            for (i = 0; i < 8; i++)
            {
                uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
            }
    
            for (i = 0; i < 3; i++)
            {
                uid[index++] = 45;
                
                for (j = 0; j < 4; j++)
                {
                    uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
                }
            }
            
            uid[index++] = 45;
    
            var time:Number = new Date().getTime();
           
            var timeString:String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);
            
            for (i = 0; i < 8; i++)
            {
                uid[index++] = timeString.charCodeAt(i);
            }
            
            for (i = 0; i < 4; i++)
            {
                uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
            }
            
            return String.fromCharCode.apply(null, uid);
        }
		//-----------------------------------------------------		
      

	}
	
}

