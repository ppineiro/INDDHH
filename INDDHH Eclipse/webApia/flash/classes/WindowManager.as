

import mx.managers.PopUpManager;
import mx.containers.Window;
import Aligner;

class WindowManager {
	
	public static function popUp(configuration:Object):Window {
		configuration.fontSize = 10;
		configuration._x = Math.floor((Stage.width - configuration._width)/2);
		configuration._y = Math.floor((Stage.height - configuration._height)/2);
		
		//_global.style.modalTransparency = 50;
		
		var win = PopUpManager.createPopUp(_root,Window,true,configuration);
			win._visible=false;
		   
		 var obj = new Object();
			 obj.complete = function(evtObj:Object):Void{
				//Aligner.center(win);
				win._visible = true;
			}
		  
			obj.click = function (evt:Object): Void{
				win.deletePopUp();
			}
		
		 win.addEventListener("complete", obj);
		 win.addEventListener("click", obj);
		 return win;
	};


}



