

import mx.controls.Button;
import mx.events.EventDispatcher;

class ButtonBar extends MovieClip {
	
	var addEventListener:Function;
    var removeEventListener:Function;
    var dispatchEvent:Function;
    var dispatchQueue:Function;
	
	var BTN_COL_LEN:Number;
	
	var btn1:Button;
	var btn2:Button;
	var btn3:Button;
	var btn4:Button;
	var btn5:Button;
	var btn6:Button;
	var btn7:Button;
	var btn8:Button;
	var btn9:Button;
	
	var drag_mc:MovieClip;
	
	function ButtonBar(Void){
		BTN_COL_LEN = 9;
		mx.events.EventDispatcher.initialize(this);
		btn1.onPress = function(){_parent.dispatchButtonEvent(this);};
		btn2.onPress = function(){_parent.dispatchButtonEvent(this);};
		btn3.onPress = function(){_parent.dispatchButtonEvent(this);};
		btn4.onPress = function(){_parent.dispatchButtonEvent(this);};
		btn5.onPress = function(){_parent.dispatchButtonEvent(this);};
		btn6.onPress = function(){_parent.dispatchButtonEvent(this);};
		btn7.onPress = function(){_parent.dispatchButtonEvent(this);};
		btn8.onPress = function(){_parent.dispatchButtonEvent(this);};
		btn9.onPress = function(){_parent.dispatchButtonEvent(this);};
		
		drag_mc.onPress = function(){
			_parent.startDrag();
		};
		
		drag_mc.onRelease = drag_mc.onReleaseOutside = function(){
			_parent.stopDrag();
		};
		
	};
	
	function onLoad(){
		this.setButton(1);
	};
	
	function dispatchButtonEvent(p_btn:Button){
		for(var e=0; e < BTN_COL_LEN; e++){
			this["btn" + (e+1)].selected = false;
		}
		this[p_btn].selected = true;
		this.dispatchEvent({type:"onButtonBarClicked",target:p_btn});
	};
	
	function setButton(p_btnID:Number){
		//set p_btnID as selected
		var obtn:Button = eval(this["btn" + p_btnID.toString()]);
		this.dispatchButtonEvent(obtn);
		obtn.selected = true;
		obtn.setFocus();
	};
	
	function disable(p_btnID:Number){
		var obtn:Button = eval(this["btn" + p_btnID.toString()]);
			obtn.enabled = false;
	};
	
	function enable(p_btnID:Number){
		var obtn:Button = eval(this["btn" + p_btnID.toString()]);
			obtn.enabled = true;
	};
	
}