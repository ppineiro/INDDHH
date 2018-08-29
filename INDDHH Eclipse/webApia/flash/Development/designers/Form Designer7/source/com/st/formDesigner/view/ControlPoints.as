

import com.st.formDesigner.view.FormView;
import mx.events.EventDispatcher;

class com.st.formDesigner.view.ControlPoints extends MovieClip{
	
	private var view:FormView;
	
	var formObj:MovieClip;	//element to modify
	var dir:Number;		//direction 1=h, 2=v
	var minCol:Number; //default element type colSpan
	var minRow:Number; //default element type rowSpan
	
	
	var xMin:Number;
	var yMin:Number;
	var xMax:Number;
	var yMax:Number;
	
	var start_x:Number;
	var end_x:Number;
	var start_y:Number;
	var end_y:Number; 
	
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	
	function ControlPoints(){
		mx.events.EventDispatcher.initialize(this);
	};
	
	function onPress(){
		var thisClip = this;
		
		//remove obj cells from array
		view.setObjCellsFlag(formObj,false);
		
		this._alpha = 60; //cambiar color de este
		
		//set minimum spans allowed
		xMin = formObj._x + (minCol*180);
		yMin = formObj._y + (minRow*30);
		//set maximum spans allowed   //check for overlapping
		xMax = (view.getXmax(formObj))*180;
		yMax = (view.getYmax(formObj))*30;
		//trace("xMin:" + xMin  + ", yMin:" + yMin);
		
		start_x = formObj._x;
		start_y = formObj._y;
		end_x = 0;
		end_y = 0;
		
		this.onMouseMove = function() {
			if(dir==1){	//X slider
				this._x = Math.floor(_parent._xmouse);
				if(this._x < xMin)this._x = xMin;
				if(this._x > xMax)this._x = xMax;
				this._x = view.snapOnX(thisClip,formObj);
				end_x = this._x;
				reScaleX();
				
			}else{	//Y slider
				this._y = Math.floor(_parent._ymouse);
				if(this._y < yMin)this._y = yMin;
				if(this._y > yMax)this._y = yMax;
				this._y = view.snapOnY(thisClip,formObj);
				end_y = this._y;
				reScaleY();
			}
			updateAfterEvent();
		};
	};
	
	function onRelease(){
		this.onMouseMove = null;
		this._alpha = 100; //volver  color  original de este
		
		view.setObjCellsFlag(formObj,true);
	};
	
	function onReleaseOutside(){
		this.onMouseMove = null;
		this.onRelease();
	};
	
	
	function reScaleX(){
		//horizontal scale
		var h_cols:Number = ((end_x-start_x)/180);
		//trace("minCol= "  + minCol + " && current cols" + h_cols)//minimum default colspan
		if(h_cols >= minCol && h_cols <= 4){
			this.dispatchEvent({type:"onStretchMoveX",p_obj:formObj,h_cols:h_cols});
		}
	};
	
	function reScaleY(){
		//vertical scale
		var v_rows:Number = ((end_y-start_y)/30);
		if(v_rows >= minRow){
			this.dispatchEvent({type:"onStretchMoveY",p_obj:formObj,v_rows:v_rows});
		}
	};
	
	
	
	
}




