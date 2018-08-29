

import mx.events.EventDispatcher;

class ToolCursor extends MovieClip{
	
	var addEventListener:Function;
    var removeEventListener:Function;
    var dispatchEvent:Function;
    var dispatchQueue:Function;
	
	var m_mode:Number;
	
	function ToolCursor(){
		mx.events.EventDispatcher.initialize(this);
	};
	
	function onMouseMove(){
		var op_mode = _global.p_mode;
		
		if((op_mode >=4 && op_mode<=9) && m_mode==4){
			dispatchCursorEvent();
		}
		if(op_mode==m_mode){
			dispatchCursorEvent();
		}
	};
	
	
	function dispatchCursorEvent(){
		this.dispatchEvent({type:"onMouseMoved"});
			updateAfterEvent();
	};
	
}

	




