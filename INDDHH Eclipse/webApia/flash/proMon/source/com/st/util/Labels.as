import com.qlod.LoaderClass;

class com.st.util.Labels {
	
	public function Labels() {	}	

	public static function getLabels(s_url:String,initializer:MovieClip) {
    	var labelLoader = new LoaderClass();
		labelLoader.setMinSteps(4);
		var label_Listener = new Object();
		label_Listener.onLoadStart = function() {
			trace("START LABELS");
		};
		label_Listener.onLoadProgress = function(loaderObj) {
		};
		label_Listener.onTimeout = function(loaderObj) {
		};
		label_Listener.onLoadComplete = function(success, loaderObj) {
			trace("_global.labelVars = " + _global.labelVars.toString());
			initializer.initProcess();
		};
		trace("getLabels() >> url = " + s_url);
		_global.labelVars = new LoadVars();
		labelLoader.load(_global.labelVars, s_url, label_Listener);
	}
}
