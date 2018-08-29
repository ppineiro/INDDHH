import com.qlod.LoaderClass;
import mx.events.EventDispatcher;

class com.st.util.Labels {
	
	function dispatchEvent() {}
 	function addEventListener() {}
 	function removeEventListener() {}
	
	public function Labels() {
		mx.events.EventDispatcher.initialize(this);
	}	
	
	public function getLabels(s_url:String) {
		var tmp=this;
		var labelLoader:LoadVars = new LoadVars();
		labelLoader.onLoad=function(success){
			if (success) {
				_global.labelVars = labelLoader;
			}else{
				trace("ERROR LOADING VARS");
			}
			tmp.dispatchEvent({target:this, type:'loadReady'});
		}

		trace("getLabels() >> url = " + s_url);
		labelLoader.load(s_url);
		
	}
}
