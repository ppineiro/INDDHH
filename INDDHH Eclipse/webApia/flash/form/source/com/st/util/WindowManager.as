﻿

import mx.containers.Window;
import mx.managers.PopUpManager;


class com.st.util.WindowManager {
	
	public static function popUp(configuration:Object,path:MovieClip):Window {
		configuration.fontSize = 10;
		configuration._x = Math.floor((Stage.width - configuration._width)/2);
		configuration._y = Math.floor((Stage.height - configuration._height)/2);
		if(configuration._y<0){
			configuration._y=5;
		}
		trace("sdasadasdasdsa");
		/*path._x=0;
		path._y=0;*/
		//_global.style.modalTransparency = 50;
		var win = PopUpManager.createPopUp(path,Window,true,configuration);
			
			//win._visible=false;
			trace("WIN:::" + win)
		  /* 
		 var obj = new Object();
			 obj.complete = function(evtObj:Object):Void{
				//Aligner.center(win);
				//win._visible = true;
			}
		/*
		  	/*
			obj.click = function (evt:Object): Void{
				win.deletePopUp();
			}*/
		
		 //win.addEventListener("complete", obj);
		// win.addEventListener("click", obj);
		 return win;
	};


}



