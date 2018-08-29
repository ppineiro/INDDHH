

import mx.containers.Window;
import mx.managers.PopUpManager;


class WindowManager {
	
	public static function popUp(configuration:Object,path:MovieClip):Window {
//		t = path;
		configuration.fontSize = 10;
		configuration._x = Math.floor((Stage.width - configuration._width)/2);
		configuration._y = Math.floor((Stage.height - configuration._height)/2);
		//_global.style.modalTransparency = 50;
		
		var win = PopUpManager.createPopUp(path,Window,true,configuration);
		
	    return win;
	};


}



