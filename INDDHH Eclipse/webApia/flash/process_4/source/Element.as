

import mx.events.EventDispatcher;

class Element extends MovieClip{
	
		var m_id:Number;			// element id;
		var m_type:String; 			// element type;
		var m_pro_ele_id:Number;	// element pro_ele_id:  store only & return in xml
		
		var allowMoving:Boolean = false;
		
		var addEventListener:Function;
        var removeEventListener:Function;
        var dispatchEvent:Function;
        var dispatchQueue:Function;
	
		
		var DBL_CLICK_SPEED:Number = 350;
		var LAST_CLICK:Number;
		

        function Element(Void){
			mx.events.EventDispatcher.initialize(this);
			LAST_CLICK = 0;
			//trace("NEW EL id: " + m_id + " type: " + m_type + "\n" + "EL_POS_x:" + this._x + " EL_POS_y:" + this._y);
			trace("NEW" + m_id + " _x:" + this._x + " _y:" + this._y);
			
			this.useHandCursor = false;
			this._x = Math.floor(this._x);
			this._y = Math.floor(this._y);
			

			////////////////////////////////////////
			// DEBUGGING
			////////////////////////////////////////
			/*
			var myformat = new TextFormat();
				myformat.color = "0x666666";
				myformat.size = "10";
				myformat.font = "Verdana";
			var aux:MovieClip = this.createEmptyMovieClip("id_mc",3);
			this["id_mc"].createTextField("idTxt",1,28,-22,100,20);
			this["id_mc"].idTxt.autoSize = "left";
			this["id_mc"].idTxt.text = " " + m_id;
			this["id_mc"].idTxt.setTextFormat(myformat);
			*/
			//_root.traceDebug("ELEMENT created " + m_type + ": " + m_id);
			///////////////////////////////////////
			///////////////////////////////////////
        };
		
		
		function onPress(){
			this.swapDepths(_parent.getNextHighestDepth()-1);
			var thisPress = getTimer();
			
			if (Number(thisPress-LAST_CLICK)<DBL_CLICK_SPEED) {
			//if ((thisPress - LAST_CLICK) < DBL_CLICK_SPEED) {
				//trace("DBL_CLICKED_FIRED:" + (thisPress - LAST_CLICK))
				thisPress = 0;
				this.dispatchEvent({type:"onElementDblClicked"});
			}else{
				//trace("SINGLE_CLICKED:" + (thisPress - LAST_CLICK))
				//trace("thispress:" + thisPress + "-" + "LAST_CLICK:" + LAST_CLICK)
				this.dispatchEvent({type:"onElementClicked"});
				if(allowMoving){
					this.onMouseMove = function() {
						
						var p = {x:_root._xmouse,y:_root._ymouse};
						_parent.globalToLocal(p);
						
						this._x =  Math.round(p.x);
						this._y =  Math.round(p.y);
						
						//trace(this._x)
						//trace(this._y)
						
						//this._x =  Math.floor(_root._xmouse);
						//this._y =  Math.floor(_root._ymouse);
						this.dispatchEvent({type:"onElementMoved"});
						updateAfterEvent();
					};
				};
			}
			
			LAST_CLICK = thisPress;
		};

	
		function onRelease() {
			this.onMouseMove = null;
			this.allowMoving = false;
		};
		
		function onReleaseOutside() {
			this.onRelease();
		};
		
		function onRollOver(){
			this.dispatchEvent({type:"onElementRollOver"});
		};
		function onRollOut(){
			this.dispatchEvent({type:"onElementRollOut"});
		};
		
		function remove(){
			this.dispatchEvent({type:"onElementDeleted"});
			this.removeMovieClip();
		};
		
}





