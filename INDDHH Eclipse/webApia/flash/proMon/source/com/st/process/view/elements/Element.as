
import mx.events.EventDispatcher;

class com.st.process.view.elements.Element extends MovieClip{
		
	var att_id:Number;				
	var att_label:String; 		
	
	var __allowMoving:Boolean = false;
	var mouseListener:Object;
	
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	var element:MovieClip;

	public function Element(Void){
		mx.events.EventDispatcher.initialize(this);
		this.useHandCursor = true;
		this._x = Math.floor(this._x);
		this._y = Math.floor(this._y);
		mouseListener = new Object();
		mouseListener.onMouseMove = function(evt) {

		};
	};
	
	
	function onPress(){
		this.swapDepths(_parent.getNextHighestDepth()-1);
		var pos = {x:_root._xmouse,y:_root._ymouse};
		//_parent.globalToLocal(pos);
		if(this["__rolmc"].hitTest(pos.x, pos.y, true)){
			this.dispatchEvent({type:"onRolClicked",rolmc:this["__rolmc"]});
		}else{
			this.dispatchEvent({type:"onElementClick"});
		}
		
		__allowMoving=true;
		if(__allowMoving){
			this.onMouseMove = function() {
				var p = {x:_root._xmouse,y:_root._ymouse};
				_parent.globalToLocal(p);
				this._x =  Math.round(p.x);
				this._y =  Math.round(p.y);
				this.dispatchEvent({type:"onElementMoved"});
				updateAfterEvent();
			}
		}
	};


	function onRelease() {
		this.onMouseMove = null;
		__allowMoving = false;
		this.dispatchEvent({type:"onElementClicked"});
	};
	
	function onReleaseOutside() {
		this.onRelease();
	};
	
	function onRollOver(){
		var pos = {x:_root._xmouse,y:_root._ymouse};
		//_parent.globalToLocal(pos);
		mouseListener=new Object();
		var tmp=this; 
		mouseListener.onMouseMove=function(){
			var pos = {x:_root._xmouse,y:_root._ymouse};
			//tmp._parent.globalToLocal(pos);
			if(tmp["__rolmc"].hitTest(pos.x, pos.y, true)){
				tmp.dispatchEvent({type:"onElementRollOut"});
				tmp.dispatchEvent({type:"onRolRollOver",rolmc:tmp["__rolmc"]});
			}else{
				tmp.dispatchEvent({type:"onRolRollOut",rolmc:tmp["__rolmc"]});
				tmp.dispatchEvent({type:"onElementRollOver"});
			}
		}
		Mouse.addListener(mouseListener);
		if(this["__rolmc"].hitTest(pos.x, pos.y, true)){
			this.dispatchEvent({type:"onRolRollOver",rolmc:this["__rolmc"]});
		}else{
			this.dispatchEvent({type:"onElementRollOver"});
		}
	};
	
	function onRollOut(){
		Mouse.removeListener(mouseListener);
		this.dispatchEvent({type:"onRolRollOut",rolmc:this["__rolmc"]});
		this.dispatchEvent({type:"onElementRollOut"});
	};
	
	function remove(){
		this.dispatchEvent({type:"onElementDeleted"});
		this.removeMovieClip();
	};
	
	
	
	///////////////////////////////////////////////////
	// ELEMENT LABEL [all elements]
	/////////////////////////////////////////////////
	public function setElementLabel(targetMc:MovieClip,pos:Array,att:Array):TextField{
		targetMc.createTextField("ico_txt",targetMc.getNextHighestDepth(),pos[0],pos[1],pos[2],pos[3]);
		this["ico_txt"].type = "dynamic";
		if(!_global.utf){
			this["ico_txt"].embedFonts = true;
			this["ico_txt"].text = att_label.toLowerCase();
		}else{
			this["ico_txt"].text = att_label;
		}
		this["ico_txt"].multiline = true;
		this["ico_txt"].wordWrap = true;
		this["ico_txt"].autoSize = "center";
		var myformat = new TextFormat();
			myformat.font = att[0];
			myformat.color = att[1];
			if(!_global.utf){
				myformat.size = att[2];
			}else{
				myformat.size = 10;
			}
			myformat.align = "center" ;
		this["ico_txt"].setTextFormat(myformat);
		
		return targetMc["ico_txt"];
	};
	
	function removeMouseListener(){
		this.onRollOut();
	}
}