import mx.events.EventDispatcher;
import flash.filters.GlowFilter;

class com.st.process.view.elements.line.LineVertex extends MovieClip{
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	
	var lastElement:MovieClip;
	var nextElement:MovieClip;
	
	var lastClick=0;
	var dblClickSpeed=400;
	
	var __allowMoving:Boolean = false;
	var mouseListener:Object;
	
	public function LineVertex(){
		mx.events.EventDispatcher.initialize(this);
		this.useHandCursor = true;
	}
	
	function onPress(){
		this.swapDepths(_parent.getNextHighestDepth()-1);
		var pos = {x:_root._xmouse,y:_root._ymouse};
		//_parent.globalToLocal(pos);
		this.dispatchEvent({type:"onVertexClick"});
		
		__allowMoving=true;
		if(__allowMoving){
			this.onMouseMove = function() {
				var p = {x:_root._xmouse,y:_root._ymouse};
				_parent.globalToLocal(p);
				this._x =  Math.round(p.x);
				this._y =  Math.round(p.y);
				this.dispatchEvent({type:"onVertexMoved"});
				updateAfterEvent();
			}
		}
	}


	function onRelease() {
		this.onMouseMove = null;
		__allowMoving = false;
		var timer = getTimer();
		if((timer-this.lastClick)<this.dblClickSpeed){
			this.dispatchEvent({type:"onVertexDoubleClicked"});
		}else{
			this.dispatchEvent({type:"onVertexClicked"});
		}
		this.lastClick=timer;
		
	}
	
	function onRollOver(){
		var pos = {x:_root._xmouse,y:_root._ymouse};
		//_parent.globalToLocal(pos);
		mouseListener=new Object();
		var tmp=this; 
		mouseListener.onMouseMove=function(){
			var pos = {x:_root._xmouse,y:_root._ymouse};
			tmp.dispatchEvent({type:"onVertexRollOver"});
		}
		Mouse.addListener(mouseListener);
		this.dispatchEvent({type:"onVertexRollOver"});
		var fGlow:GlowFilter = new GlowFilter(0x7aff43,.5,2,2,5,3,false,false);
		this.filters=[fGlow];
	}
	
	function onRollOut(){
		this.filters=[];
		Mouse.removeListener(mouseListener);
		this.dispatchEvent({type:"onVertexRollOut"});
	}
	
	function remove(){
		this.dispatchEvent({type:"onVertexDeleted"});
		this.removeMovieClip();
	}
	
	function setLastElement(el:MovieClip){
		lastElement=el;
	}
	
	function setNextElement(el:MovieClip){
		nextElement=el;
	}
	
	function getLastElement(){
		return lastElement;
	}
	
	function getNextElement(){
		return nextElement;
	}
	
}