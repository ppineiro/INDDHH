

import mx.events.EventDispatcher;

class LineObj extends MovieClip {
	
	var ARROW_SIZE:Number = 8;
	var DBLCLICKSPEED:Number = 300;
	
	var m_name:String; 				//dependancy label
	var m_condition:String;			//dependancy condition
	
	var m_endPoint:Number;
	var m_startPoint:Number;
	var m_startElementMc:MovieClip;	//reference to start task mc (element)
	var m_endElementMc:MovieClip;	//reference to end task mc (dependancy)
	
	var m_lastClick:Number;
	
	var addEventListener:Function;
    var removeEventListener:Function;
    var dispatchEvent:Function;
    var dispatchQueue:Function;
	
	function LineObj(){
		mx.events.EventDispatcher.initialize(this);
		this.useHandCursor = true;
		this.createArrow();
		
		//name
		if(m_name!=null){
			setName(m_name);
		}else{
			m_name = "";
		}
		//condition
		if(m_condition!=null){setCondition(m_condition);}
		
		//init pos
		this.scaleLine(m_endElementMc._x,
					   m_endElementMc._y,
					   m_startElementMc._x - m_endElementMc._x,
					   m_startElementMc._y - m_endElementMc._y,
					   true);
		
		//attach listeners
		m_endElementMc.addEventListener("onElementMoved",this);
		m_startElementMc.addEventListener("onElementMoved",this);
		
		m_endElementMc.addEventListener("onElementDeleted",this);
		m_startElementMc.addEventListener("onElementDeleted",this);
		
	};
	
	function onPress(){
		if (getTimer() - m_lastClick < DBLCLICKSPEED) {
			this.dispatchEvent({type:"onLineDblClicked"});
		}else{
			this.dispatchEvent({type:"onLineClicked"});
		}
		m_lastClick = getTimer();
	};

	function onRelease() {
	};
	
	function onReleaseOutside() {
	};
	
	function onRollOver(){
		this.dispatchEvent({type:"onElementRollOver"});
	};
	function onRollOut(){
		this.dispatchEvent({type:"onElementRollOut"});
	};
	
	function onElementMoved(p_eventObj) {
		if(p_eventObj.target.m_id == m_startElementMc.m_id){
			this.scaleLine(p_eventObj.target._x,
						p_eventObj.target._y,
						m_endElementMc._x - p_eventObj.target._x,
						m_endElementMc._y - p_eventObj.target._y,
						false);
		}else{
			this.scaleLine(m_endElementMc._x,
						m_endElementMc._y,
						m_startElementMc._x - p_eventObj.target._x,
						m_startElementMc._y - p_eventObj.target._y,
						true);
		}
	};
	
	function onElementDeleted(){
		this.remove();
	};
	
	function remove(){
		m_startElementMc.removeEventListener("onElementDeleted", this);
		m_endElementMc.removeEventListener("onElementDeleted",this);
		m_endElementMc.removeEventListener("onElementMoved",this);
		m_startElementMc.removeEventListener("onElementMoved",this);
		this.removeMovieClip();
	};
	
	function scaleLine(theX,theY,theXScale,theYScale,dir){
		/////////////////
		//FULL LINE FROM EL to EL
		////////////////
		this._x = theX;
		this._y = theY;
		this["theLine_mc"]._xscale = theXScale;
		this["theLine_mc"]._yscale = theYScale;
		this.updateArrow(dir);
		/////////////////
	};
	
	function createArrow(){
		var TmpArrow:MovieClip = this.createEmptyMovieClip("Arrow_mc",2);
			TmpArrow.lineStyle(0.25,0xCCCCCC,100);
			TmpArrow.beginFill(0xCCCCCC,100);
			TmpArrow.moveTo(0,0);
			TmpArrow.lineTo(ARROW_SIZE,-ARROW_SIZE);
			TmpArrow.lineTo(0,-ARROW_SIZE);
			TmpArrow.lineTo(-ARROW_SIZE,-ARROW_SIZE);
			TmpArrow.lineTo(0,0);
			TmpArrow.endFill();
	};
	
	function updateArrow(dir){
		var theObjArrow:MovieClip = this["Arrow_mc"];
		var oLine:MovieClip = this["theLine_mc"];
		
		/////////////////////////////////////
		//center Arrow in the middle
		//////////////////////////////////////
		var x1 = oLine._x;
		var y1 = oLine._y;
		var x2 = oLine._xscale;
		var y2 = oLine._yscale;
		var arr_Point = [];
		var ARROW_POS = 30;
		
		/////////////////////////
		/*
		trace("x2:" + x2)
		trace("y2:" + y2)
		
		var point:Object = {x:x2, y:y2};
  			this.globalToLocal(point);

		trace("point_x2:" + point.x);
		trace("point_y2:" + point.y);
		
		x2 = point.x;
		y2 = point.y;
		*/
		/////////////////////////
		
		var distBtwEls = distance(x1,y1,x2,y2);
		if(distBtwEls <= ARROW_POS){
			ARROW_POS = distBtwEls;
		}
		
		if(dir){
			arr_Point = pointsOnLine(x1, y1, x2, y2, ARROW_POS);
		}else{
			arr_Point = pointsOnLine(x1, y1, x2, y2, distance(x1,y1,x2,y2)-30);
		}
		
		theObjArrow._x = Math.round (arr_Point[0].x); 
		theObjArrow._y = Math.round (arr_Point[0].y);
		//trace(theObjArrow._x + " & " + theObjArrow._y)
		////////////////////////////////////////////////////////////////
		
		
		//ROTATE ARROW
		var theAng = angleTo(oLine,theObjArrow);
		if(dir){
			theObjArrow._rotation = theAng-90;
		}else{
			theObjArrow._rotation = theAng+90;
		}
		
		//UPDATE NAME
		if(m_name!=null){
			updateNamePos();
		}
		
		//Update Condition marker
		if(m_condition!=null){
			updateConditionPos();
		}
		
	};
	
	function angleTo(obj:MovieClip,X,Y):Number{
		 return Math.atan2(obj._y-(!Y ? X._y : Y), obj._x-(!Y ? X._x : X))*180/Math.PI;
	};

	function updateNamePos(){
		var oLine:MovieClip = this["theLine_mc"];
		var name_mc = this["name_mc"].nameTxt;
			name_mc._x = Math.floor((oLine._xscale/2) - (name_mc._width/2)-15);
			name_mc._y = Math.floor((oLine._yscale/2) - (name_mc._height/2)-15);
	};
	
	function updateConditionPos(){
		var oLine:MovieClip = this["theLine_mc"];
		this["Condition"]._x = Math.floor(oLine._xscale/2);
		this["Condition"]._y = Math.floor(oLine._yscale/2);
	};
	
	
	function setName(p_name:String){
		var myformat = new TextFormat();
			myformat.color = "0x666666";
			myformat.size = "8";
			myformat.font = "k0554";
		
		var aux:MovieClip = this.createEmptyMovieClip("name_mc",3);

		this["name_mc"].createTextField("nameTxt",1,10,10,100,20);
					  //createTextField("mytext",depth,_x,_y,_w,_h);
		
		this["name_mc"].nameTxt.embedFonts = true;
		this["name_mc"].nameTxt.autoSize = "left";
		this["name_mc"].nameTxt.text = p_name.toUpperCase();
		this["name_mc"].nameTxt.setTextFormat(myformat);
		
		this.m_name = p_name;
		
		updateNamePos();
	};
	
	function getName():String{
		return m_name;
	};
	
	function setCondition(p_condition:String){
		if(p_condition==undefined)p_condition=="";
		m_condition = p_condition;
		
		if(m_condition!=null && m_condition!=""){
			conditionMarker(true);
		}else{
			conditionMarker(false);
		}
		
	};
	
	function getCondition():String{
		return m_condition;
	};
	
	function conditionMarker(p_marker:Boolean){
		this["Condition"].removeMovieClip();
		if(p_marker){
			var aux = this.attachMovie("condition", 'Condition', 15, {
				_x:140,
				_y:10
				});
			updateConditionPos();
		}
	};
	
	
	////////////////////////////////////////////////////////////////
	// TEMP MATH FUNCTIONS
	/////////////////////////////////////////////////////////////////
	function distance(x1, y1, x2, y2) {
		var dX = x2-x1;
		var dY = y2-y1;
		return Math.sqrt(dX*dX+dY*dY);
		//var Distance=Math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
	};
	
	
	function angle(x1, y1, x2, y2) {
		return (Math.atan2(y2-y1, x2-x1)*180/Math.PI);
	};
	
	

	function pointsOnLine(p1x, p1y, p2x, p2y, n) {
		var pts = [];
		var x=0;
		var y;
		
		if(p2x!=0){
			var m = (p2y-p1y)/(p2x-p1x);
			var b = p1y - p1x * m;

			//trace("Slope : " + m + "   B : " + b + "p1x = " + p1x );
			x = p1x - Math.sqrt((n*n)/(1+m*m));
			y = m*x+b;
		}else{
			y = n; 
			if(p2y < 0){
				y = y *-1;
			}
		}
		
		var theX = x;
		var theY = y;
		
		if (p2x <= 0) {
			pts.push({x:theX, y:theY});
		} else if(p2x > 0){
			pts.push({x:theX*-1, y:theY*-1});
		}
		
		return pts;
	};
	
}
