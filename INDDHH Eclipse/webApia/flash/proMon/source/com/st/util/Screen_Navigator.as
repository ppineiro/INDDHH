import com.st.process.view.ProcessView;

class com.st.util.Screen_Navigator extends MovieClip{
	
	var cursor_mc:MovieClip; 	//cursor nav
	var navArea_mc:MovieClip;	//nav area
	
	var TOTAL_MAP_WIDTH:Number = 2400;
	var TOTAL_MAP_HEIGHT:Number = 1800;
	
	var stageListener:Object;
	
	var gutter:MovieClip;
	var bgElement:MovieClip;
	
	var gutterLeft:Number;
	var gutterRight:Number;
	var gutterTop:Number;
	var gutterBottom:Number;
	
	var zoommed:Number;
	
	var contentRight:Number;
	var contentLeft:Number;
	var contentBottom:Number;
	var contentTop:Number;
	var __view:ProcessView;
	
	var zoomPercent:Number;
	
	function init(back:MovieClip,view:ProcessView){
		__view=view;
		var me = this;
		bgElement = back;
		this.setPanBounds();
		cursor_mc.onPress = function(){
			this.startDrag(false, _parent.gutterLeft, _parent.gutterTop, _parent.gutterRight, _parent.gutterBottom);
			this.onMouseMove = function() {
				_parent.doPanning();
				updateAfterEvent();
			};
		};
		cursor_mc.onRelease = cursor_mc.onReleaseOutside = function() {
			this.stopDrag();
			this.onMouseMove = null;
		};
		
		var stageListener = {};
			stageListener.onResize = function(){
				trace("S_NAV _ONRESIZEEE------------------------")
				me.setPanBounds();
			}
	
		Stage.addListener(stageListener);
		
	};
	
	function doPanning(){
		var xpercent = (cursor_mc._x-gutterLeft)/(gutterRight-gutterLeft);
		var ypercent = (cursor_mc._y-gutterTop)/(gutterBottom-gutterTop);
		
		var x = xpercent*(contentLeft-contentRight)+contentRight;
		var y = ypercent*(contentTop-contentBottom)+contentBottom;
		
		//trace("·:::::::::........." + getZoomView())
		
		
		if(getZoomView()==50){
			x = x/4;
			y = y/4;
		}
		
		
		/*
		trace("\n<--");
		trace("X_PERCENT:" + xpercent + " Y_PERCENT:" + ypercent);
		trace("PANNING_X:" + Math.round(x) + "\n PANNING_Y:"  + Math.round(y))
		trace("--->\n")
		*/
		__view.setPanning(Math.round(x),Math.round(y));    
	};
	
	function setPanBounds(){
		
		//----------------------
		//cursor_mc._width = (Stage.width/10)/2;
		//cursor_mc._height = (Stage.height/10)/2;
		////--------------------------
		
		
		contentRight = bgElement._x;
		contentLeft = Stage.width - TOTAL_MAP_WIDTH;
		contentBottom = bgElement._y;
		contentTop = Stage.height - TOTAL_MAP_HEIGHT;
		
		
		//contentLeft=-(TOTAL_MAP_WIDTH);
		//contentTop=-(TOTAL_MAP_HEIGHT);
		//contentBottom=0;
		//contentRight=0;
		
		/*
		trace("\n")
		trace("contentLeft:" + contentLeft)
		trace("contentTop:" + contentTop)
		trace("contentBottom:" + contentBottom)
		trace("contentRight:" + contentRight)
		trace("\n")
		*/
		
		gutter = navArea_mc;
		gutterLeft = gutter._x;
		gutterRight = ((gutter._x + gutter._width) - cursor_mc._width);
		gutterTop = gutter._y + 0;
		gutterBottom = ((gutter._y + gutter._height) - cursor_mc._height);
		
		//trace("cursor_mc._width:" + cursor_mc._width)
	};
	
	function resetCursorPosition(){
		cursor_mc._x = 0;
		cursor_mc._y = 0;
		setPanBounds();
		doPanning();
	};
	
	function setZoomView(p_value:Number){
		resetCursorPosition();
		zoommed=p_value;
		switch(p_value){
			case 1:	//default 100%
				zoomPercent = 100;
			break;
			case 2:	//50%
				zoomPercent = 50//65;
			break;
			case 3:	//25%
				zoomPercent = 25//45;
			break;
		}
		var scalePan = p_value*100;
		cursor_mc._xscale = scalePan;
		cursor_mc._yscale = scalePan;
		
	
		this.setPanBounds();
		
		__view.setZoom(zoomPercent);
	};
	
	function getZoomView(){
		return zoomPercent;
	};
	
}