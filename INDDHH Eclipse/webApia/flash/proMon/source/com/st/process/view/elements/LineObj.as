

import mx.events.EventDispatcher;

class com.st.process.view.elements.LineObj extends MovieClip {
	
	var ARROW_SIZE:Number = 8;
	var NAME_FONT_FACE:String = "k0554";
	var NAME_FONT_COLOR:String = "0x333333";
	var NAME_FONT_SIZE:String = "8";
	var NAME_BG_COLOR:String = "0xDFDFDF";
	var NAME_BORDER_COLOR:String = "0xCCCCCC";
	
	var m_endPoint:Number;
	var m_startPoint:Number;
	var m_startElementMc:MovieClip;	
	var m_endElementMc:MovieClip;	
	
	var isLooped_back:Boolean;
	var loop_mc:MovieClip;
	
	var __conditionmc:MovieClip;
	var __namemc:MovieClip;
	var __wizmc:MovieClip;
	
	
	var addEventListener:Function;
    var removeEventListener:Function;
    var dispatchEvent:Function;
    var dispatchQueue:Function;
	
	function LineObj(){
		mx.events.EventDispatcher.initialize(this);
		this.useHandCursor = true;
		this.createArrow();
	
		this.scaleLine(m_endElementMc._x,
					   m_endElementMc._y,
					   m_startElementMc._x - m_endElementMc._x,
					   m_startElementMc._y - m_endElementMc._y,
					   true);
		
		
		m_endElementMc.addEventListener("onElementMoved",this);
		m_startElementMc.addEventListener("onElementMoved",this);
		m_endElementMc.addEventListener("onElementDeleted",this);
		m_startElementMc.addEventListener("onElementDeleted",this);
	};
	
	function onPress(){
		this.dispatchEvent({type:"onLineClick"});
	};

	function onRelease() {
		this.dispatchEvent({type:"onLineClicked"});
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
		var movedMc = p_eventObj.target;
		var movedMc_x = movedMc._x;
		var movedMc_y = movedMc._y;
		
		if(movedMc.att_id == m_startElementMc.att_id){
			this.scaleLine(movedMc_x,movedMc_y,
						m_endElementMc._x - movedMc_x,
						m_endElementMc._y - movedMc_y,
						false);
		}else{
			this.scaleLine(m_endElementMc._x,
						m_endElementMc._y,
						m_startElementMc._x - movedMc_x,
						m_startElementMc._y - movedMc_y,
						true);
		}
	};
	
	
	
	function onElementDeleted(){
		//this.remove();
		this.dispatchEvent({type:"onLineDelete"});
	};
	
	function remove(){
		m_startElementMc.removeEventListener("onElementDeleted", this);
		m_endElementMc.removeEventListener("onElementDeleted",this);
		m_endElementMc.removeEventListener("onElementMoved",this);
		m_startElementMc.removeEventListener("onElementMoved",this);
		this.removeMovieClip();
	};
	
	function scaleLine(theX,theY,theXScale,theYScale,dir){
		this._x = theX;
		this._y = theY;
		this["theLine_mc"]._xscale = theXScale;
		this["theLine_mc"]._yscale = theYScale;
		this.updateArrow(dir);
		/////////////////
	};
	
	function createArrow(){
		var TmpArrow:MovieClip = this.createEmptyMovieClip("Arrow_mc",2);
			TmpArrow.lineStyle(0.25,0x444444,100);
			TmpArrow.beginFill(0x444444,100);
			TmpArrow.moveTo(0,0);
			TmpArrow.lineTo(ARROW_SIZE,-ARROW_SIZE);
			TmpArrow.lineTo(0,-ARROW_SIZE);
			TmpArrow.lineTo(-ARROW_SIZE,-ARROW_SIZE);
			TmpArrow.lineTo(0,0);
			TmpArrow.endFill();
	};
	
	function createDblArrow(){
		var TmpArrow:MovieClip = this.createEmptyMovieClip("Arrow_mc",2);
			TmpArrow.lineStyle(0.25,0x444444,100);
			TmpArrow.beginFill(0x444444,100);
			TmpArrow.moveTo(0,0);
			TmpArrow.lineTo(ARROW_SIZE,-ARROW_SIZE);
			TmpArrow.lineTo(0,-ARROW_SIZE);
			TmpArrow.lineTo(-ARROW_SIZE,-ARROW_SIZE);
			TmpArrow.lineTo(0,0);
			TmpArrow.endFill();
			
		var a2:MovieClip = TmpArrow.createEmptyMovieClip("Arrow_mc",1);
			a2.lineStyle(0.25,0x444444,100);
			a2.beginFill(0x444444,100);
			a2.moveTo(0,0);
			a2.lineTo(ARROW_SIZE,-ARROW_SIZE);
			a2.lineTo(0,-ARROW_SIZE);
			a2.lineTo(-ARROW_SIZE,-ARROW_SIZE);
			a2.lineTo(0,0);
			a2.endFill();
			
			a2._x = 0;
			a2._y = -10;
	};
	
	function updateArrow(dir:Boolean){
		var mainArrow:MovieClip = this["Arrow_mc"];
		posArrows(mainArrow,dir);
		
		if(isLooped_back){
			if(dir){
				posArrows(loop_mc,false);
			}else{
				posArrows(loop_mc,true);
			}
		}
	};
	
	function posArrows(oArrow:MovieClip, dir:Boolean):Void{
		var theObjArrow:MovieClip = oArrow;
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
		updateNamePos();
		//UPDATE CONDITION marker
		updateConditionPos();
		
	};
	
	function angleTo(obj:MovieClip,X,Y):Number{
		 return Math.atan2(obj._y-(!Y ? X._y : Y), obj._x-(!Y ? X._x : X))*180/Math.PI;
	};

	function updateNamePos(){
		var oLine:MovieClip = this["theLine_mc"];
		if(__namemc){
			__namemc._x = Math.floor((oLine._xscale/2) - (__namemc._width/2)-20);
			__namemc._y = Math.floor((oLine._yscale/2) - (__namemc._height/2)-20);
		}
	};
	
	function updateConditionPos(){
		var oLine:MovieClip = this["theLine_mc"];
		if(__conditionmc){
			__conditionmc._x = Math.floor(oLine._xscale/2);
			__conditionmc._y = Math.floor(oLine._yscale/2);
		}
	};
	
	
	public function showName(p_name:String):Void{
		__namemc = this.createEmptyMovieClip("__namemc",3);
		
		__namemc.createTextField("name_txt",1, 10, 10, 100,20);
		__namemc["name_txt"].embedFonts = true;
		__namemc["name_txt"].autoSize = "left";
		__namemc["name_txt"].text = p_name.toUpperCase();
		__namemc["name_txt"].border = true;
		__namemc["name_txt"].background = true;
		__namemc["name_txt"].borderColor = NAME_BORDER_COLOR;
		__namemc["name_txt"].backgroundColor = NAME_BG_COLOR;
		
		var myformat = new TextFormat();
			myformat.color = NAME_FONT_COLOR;
			myformat.size = NAME_FONT_SIZE;
			myformat.font = NAME_FONT_FACE;
		
		__namemc["name_txt"].setTextFormat(myformat);
		updateNamePos();
		
	};
	
	public function hideName():Void{
		__namemc.removeMovieClip();
		__namemc = null;
	};
	
	public function showCondition(p_condition:String):Void{
		__conditionmc = this.attachMovie("condition", 'Condition', 15, {
			_x:140,
			_y:10
			});
		
		updateConditionPos();
	};
	
	public function hideCondition():Void{
		__conditionmc.removeMovieClip();
		__conditionmc = null;
	};
	
	public function setAsWizard(p_wizard:Boolean):Void{
		if(p_wizard){
			createDblArrow();
		}else{
			createArrow();
		}
		m_endElementMc.dispatchEvent({type:"onElementMoved"}); //hack to update pos
	};
	
	public function loopBack(p_loopBack:Boolean):Void{
		isLooped_back = p_loopBack;
		var oLine:MovieClip = this["theLine_mc"];
		var a_color:Color = new Color(oLine);
		
		if(isLooped_back){
			//loop_mc = createLoopBackArrow();
			//a_color.setRGB(0x000000);
			//oLine.removeMovieClip();
			//this.removeMovieClip(oLine);
			var l_depth:Number = oLine.getDepth();
			this.attachMovie("lineDotted","theLine_mc",l_depth,{_x:0,_y:0});
			
		}else{
			//loop_mc.removeMovieClip();
			//a_color.setRGB(0xDFDFDF);
			//oLine.removeMovieClip();
			//this.removeMovieClip(oLine);
			var l_depth:Number = oLine.getDepth();
			this.attachMovie("line","theLine_mc",l_depth,{_x:0,_y:0});
		}
		
		m_endElementMc.dispatchEvent({type:"onElementMoved"});//hack to update pos
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
