

import mx.events.EventDispatcher;
import flash.filters.GlowFilter;

class com.st.process.view.elements.LineObj extends MovieClip {
	
	var ARROW_SIZE:Number = 8;
	var NAME_FONT_FACE:String = "k0554";
	var NAME_FONT_COLOR:String = "0x333333";
	var NAME_FONT_SIZE:String = "8";
	var NAME_BG_COLOR:String = "0xDFDFDF";
	var NAME_BORDER_COLOR:String = "0xCCCCCC";
	var thinLine:MovieClip;
	
	var m_endPoint:Number;
	var m_startPoint:Number;
	var m_startElementMc:MovieClip;	
	var m_endElementMc:MovieClip;
	
	var isLooped_back:Boolean;
	var loop_mc:MovieClip;
	
	var __conditionmc:MovieClip;
	var __namemc:MovieClip;
	var __wizmc:MovieClip;
	
	var lineStyle="";
	var lineWidth=1.5;
	var lineColor=0xA4A4A4;
	var theLine:MovieClip;
	
	var arrowHeadSide=8;
	var curveRadiusOri=20;
	
	var isWizard=false;
	
	var startType="";
	var endType="";
	
	
	var addEventListener:Function;
    var removeEventListener:Function;
    var dispatchEvent:Function;
    var dispatchQueue:Function;
	
	function LineObj(){
		mx.events.EventDispatcher.initialize(this);
		this.useHandCursor = true;
	
		/*this.scaleLine(m_endElementMc._x,
					   m_endElementMc._y,
					   m_startElementMc._x - m_endElementMc._x,
					   m_startElementMc._y - m_endElementMc._y,
					   true);*/
		updateLine();
		
		
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
		
		var fGlow:GlowFilter = new GlowFilter(0x7aff43,.5,2,2,4,3,false,false);
		thinLine.filters=[fGlow];

		
		this.dispatchEvent({type:"onElementRollOver"});
	};
	function onRollOut(){
		thinLine.filters=[];
		this.dispatchEvent({type:"onElementRollOut"});
	};
	
	function onElementMoved(p_eventObj) {
		var movedMc = p_eventObj.target;
		var movedMc_x = movedMc._x;
		var movedMc_y = movedMc._y;

		updateLine();
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
		updateLine();
		
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
		
		updateLine();
	};
	
	public function hideCondition():Void{
		__conditionmc.removeMovieClip();
		__conditionmc = null;
	};
	
	public function setAsWizard(p_wizard:Boolean):Void{
		isWizard=p_wizard;
		updateLine();
		m_endElementMc.dispatchEvent({type:"onElementMoved"}); //hack to update pos
	};
	
	public function loopBack(p_loopBack:Boolean):Void{
		isLooped_back = p_loopBack;
		var oLine:MovieClip = this["theLine_mc"];
		var a_color:Color = new Color(oLine);
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
	
	
	
	function line(mc,pt1,pt2,width,color,alpha){
		mc.lineStyle(width,color,alpha,false);
		var diffX=pt1.x-pt2.x;
		var diffY=pt1.y-pt2.y;
		var tmp=this;
		function drawArrowHead(mc,x,y,to){
			mc=mc.createEmptyMovieClip("arrow_"+mc.getNextHighestDepth(),mc.getNextHighestDepth());
			var arrowHeadSide=tmp.arrowHeadSide;
			var m_endElementMc=tmp.m_endElementMc;
			mc.beginFill(tmp.lineColor,70);
			if(to=="N" || to=="S"){
				y+=30*(to=="N"?-1:1);
				mc.moveTo(x-(arrowHeadSide/2),y);
				mc.lineTo(x+(arrowHeadSide/2),y);
				mc.lineTo(x, y+(arrowHeadSide* (to=="N"?1:-1) ) );
				mc.lineTo(x-(arrowHeadSide/2),y);
			}else{
				x+=30*(to=="E"?-1:1);
				mc.moveTo(x,y-(arrowHeadSide/2));
				mc.lineTo(x,y+(arrowHeadSide/2));
				mc.lineTo(x+(arrowHeadSide* (to=="E"?1:-1) ),y );
				mc.lineTo(x,y-(arrowHeadSide/2));
			}
			mc.endFill();
		}
		
		var to="E";
		var sgnX=Math.abs( diffX/2 )/( diffX/2 );
		var sgnY=Math.abs( diffY/2 )/( diffY/2 );
		if(sgnY==0){
			sgnY=Math.abs( diffY/2 )/( diffY/2 );
		}
		if(diffX==0 || diffY==0){
			mc.moveTo(pt1.x,pt1.y);
			//mc.lineTo(pt2.x,pt2.y);
			drawLineTo(mc,pt1,pt2,isLooped_back);
			if(diffY==0){
				to=(pt1.x<pt2.x)?"E":"W";
			}else{
				to=(pt1.y<pt2.y)?"N":"S";
			}
			drawArrowHead(mc,pt2.x,pt2.y,to);
			if(isWizard){
				var x=pt2.x;
				var y=pt2.y;
				if(to=="N" || to=="S"){
					y+=8*(to=="N"?-1:1);
				}else{
					x+=8*(to=="E"?-1:1);
				}
				drawArrowHead(mc,x,y,to);
			}
		}else{
			var curveRadius=curveRadiusOri;
			if(curveRadius*2>=Math.abs(diffX) || curveRadius*2>=Math.abs(diffY)){
				curveRadius=curveRadius/2;
			}
			if(curveRadius*2>=Math.abs(diffX) || curveRadius*2>=Math.abs(diffY)){
				curveRadius=0;
			}
			//if(Math.abs(diffX)>Math.abs(diffY)){
			if( pt1.x<pt2.x ){
				var halfX=((diffX/2)*( sgnX ))+ ((diffX<0)?pt1.x:pt2.x);
				mc.moveTo(pt1.x,pt1.y);
				var to=1;
				if( ( pt1.y<pt2.y && pt1.x>pt2.x ||
				   pt1.y>pt2.y && pt1.x<pt2.x) ){
					to=-1;
				}
				drawLineTo(mc,pt1,{x:halfX+(sgnX*curveRadius),y:pt1.y},isLooped_back);
				drawCurveTo(mc,{x:halfX+(sgnX*curveRadius),y:pt1.y},{x:halfX, y: (pt1.y - (sgnY*curveRadius) ) }, to ,isLooped_back);
				drawLineTo(mc,{x:halfX, y: (pt1.y - (sgnY*curveRadius) ) },{x:halfX,y:(pt2.y+(sgnY*curveRadius))},isLooped_back);
				drawCurveTo(mc,{x:halfX,y: (pt2.y + (sgnY*curveRadius)) },{x:(halfX -(sgnX*curveRadius) ), y: pt2.y },-to,isLooped_back);
				drawLineTo(mc,{x:(halfX -(sgnX*curveRadius) ), y: pt2.y },pt2,isLooped_back);
				//to=(diffX<0)?"E":"W";
			}else{
				var halfY=((diffY/2)*( sgnY ))+ ((diffY<0)?pt1.y:pt2.y);
				mc.moveTo(pt1.x,pt1.y);
				var to=-1;
				if(pt1.y<pt2.y && pt1.x>pt2.x ||
				   pt1.y>pt2.y && pt1.x<pt2.x ){
					to=1;
				}
				drawLineTo(mc,pt1,{x:pt1.x,y:halfY+(sgnY*curveRadius)},isLooped_back);
				drawCurveTo(mc,{y:halfY+(sgnY*curveRadius),x:pt1.x},{y:halfY, x: (pt1.x - (sgnX*curveRadius) ) },to,isLooped_back);
				drawLineTo(mc,{y:halfY, x: (pt1.x - (sgnX*curveRadius) ) },{y:halfY,x: (pt2.x+(sgnX*curveRadius)) },isLooped_back);
				drawCurveTo(mc,{y:halfY,x: (pt2.x + (sgnX*curveRadius)) },{y:(halfY -(sgnY*curveRadius) ), x: pt2.x },-to,isLooped_back);
				drawLineTo(mc,{y:(halfY -(sgnY*curveRadius) ), x: pt2.x },pt2,isLooped_back);
				//to=(diffY<0)?"N":"S";
			}
			//if(Math.abs(diffX)>Math.abs(diffY)){
			var x2=pt2.x;
			var y2=pt2.y;
			if( pt1.x<pt2.x ){
				to=(diffX<0)?"E":"W";
				if(Math.abs(diffX)<80 && Math.abs(diffY)>40){
					to=(diffY<0)?"N":"S";
					x2=((diffX/2)*( sgnX ))+ ((diffX<0)?pt1.x:pt2.x);
					
				}
				drawArrowHead(mc,x2,y2,to);
			}else{
				to=(diffY<0)?"N":"S";
				if(Math.abs(diffY)<80 && Math.abs(diffX)>40){
					to=(diffX<0)?"E":"W";
					y2=((diffY/2)*( sgnY ))+ ((diffY<0)?pt1.y:pt2.y);
				}
				drawArrowHead(mc,x2,y2,to);
			}
			if(isWizard){
				var x=x2;
				var y=y2;
				if(to=="N" || to=="S"){
					y+=6*(to=="N"?-1:1);
				}else{
					x+=6*(to=="E"?-1:1);
				}
				drawArrowHead(mc,x,y,to);
			}
		}
	}
	
	function updateLine(){
		theLine=this.createEmptyMovieClip("newLine",30);
		thinLine=this.createEmptyMovieClip("thisLine",35);
		var s={x:m_startElementMc._x,y:m_startElementMc._y};
		m_endElementMc._parent.localToGlobal(s);
		theLine.globalToLocal(s);
		var e={x:m_endElementMc._x,y:m_endElementMc._y};
		m_endElementMc._parent.localToGlobal(e);
		theLine.globalToLocal(e);
		line(thinLine,s,e,lineWidth,lineColor,60);
		line(theLine,s,e,12,0x000000,0);
		updateLineIcons(s,e);
	}
	
	function updateLineIcons(s,e){
		var x=-(((s.x-e.x)/2)-s.x);
		var y=-(((s.y-e.y)/2)-s.y);
		__namemc._x = x-(__namemc._width/2);
		__namemc._y = y-10;
		__conditionmc._x=x;
		__conditionmc._y=y-10;
	}
	var dot_size=5;
	function drawLineTo(mc,pt1,pt2,dotted){
		//mc.lineStyle(lineWidth,lineColor,60,false);
		if(dotted){
			dashTo(mc,pt1.x,pt1.y,pt2.x,pt2.y,dot_size,dot_size)
		}else{
			mc.moveTo(pt1.x,pt1.y);
			mc.lineTo(pt2.x,pt2.y);
		}
	}
	
	function drawCurveTo(mc,pt1,pt2,sgn,dashed){
		if(sgn>0){
			if(pt1.x<pt2.x && pt1.y<pt2.y){
				drawCurve(mc,pt2.x,pt1.y,pt1,pt2,dashed);
			}else if(pt1.x<pt2.x && pt1.y>pt2.y){
				drawCurve(mc,pt1.x,pt2.y,pt1,pt2,dashed);
			}else if(pt1.x>pt2.x && pt1.y>pt2.y){
				drawCurve(mc,pt2.x,pt1.y,pt1,pt2,dashed);
			}else if(pt1.x>pt2.x && pt1.y<pt2.y){
				drawCurve(mc,pt1.x,pt2.y,pt1,pt2,dashed);
			}
		}else{
			if(pt1.x<pt2.x && pt1.y<pt2.y){
				drawCurve(mc,pt1.x,pt2.y,pt1,pt2,dashed);
			}else if(pt1.x<pt2.x && pt1.y>pt2.y){
				drawCurve(mc,pt2.x,pt1.y,pt1,pt2,dashed);
			}else if(pt1.x>pt2.x && pt1.y>pt2.y){
				drawCurve(mc,pt1.x,pt2.y,pt1,pt2,dashed);
			}else if(pt1.x>pt2.x && pt1.y<pt2.y){
				drawCurve(mc,pt2.x,pt1.y,pt1,pt2,dashed);
			}
		}
	}
	
	function dashTo(mc,startx, starty, endx, endy, len, gap) {
		var seglength, deltax, deltay, segs, cx, cy;
		seglength = len + gap;
		deltax = endx - startx;
		deltay = endy - starty;
		var delta = Math.sqrt((deltax * deltax) + (deltay * deltay));
		segs = Math.floor(Math.abs(delta / seglength));
		var radians = Math.atan2(deltay,deltax);
		cx = startx;
		cy = starty;
		deltax = Math.cos(radians)*seglength;
		deltay = Math.sin(radians)*seglength;
		for (var n = 0; n < segs; n++) {
			mc.moveTo(cx,cy);
			mc.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
			cx += deltax;
			cy += deltay;
		}
		mc.moveTo(cx,cy);
		delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
		if(delta>len){
			mc.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
		} else if(delta>0) {
			mc.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
		}
		mc.moveTo(endx,endy);
	}
	
	
	function drawCurve(mc,anchorX,anchorY,pt1,pt2,dashed){
		if(!dashed){
			/*mc.moveTo(anchorX-2,anchorY-2);
			mc.lineTo(anchorX+2,anchorY+2);
			mc.moveTo(anchorX-2,anchorY+2);
			mc.lineTo(anchorX+2,anchorY-2);
			
			mc.moveTo(pt1.x-2,pt1.y-2);
			mc.lineTo(pt1.x+2,pt1.y+2);
			mc.moveTo(pt1.x-2,pt1.y+2);
			mc.lineTo(pt1.x+2,pt1.y-2);
			
			mc.moveTo(pt2.x-2,pt2.y-2);
			mc.lineTo(pt2.x+2,pt2.y+2);
			mc.moveTo(pt2.x-2,pt2.y+2);
			mc.lineTo(pt2.x+2,pt2.y-2);*/
			
			mc.moveTo(pt1.x,pt1.y);
			mc.curveTo(anchorX,anchorY,pt2.x,pt2.y,dashed);
		}else{
			//mc.curveTo(anchorX,anchorY,pt2.x,pt2.y);*/
			dashCurve(mc,anchorX,anchorY,pt1,pt2,dashed);
		}
		
	}
	
	function dashCurve(mc,anchorX,anchorY,pt1,pt2,dashed){
		//trace("aca 3 "+pt1.y);
		var radius=(anchorX==pt2.x)?Math.abs(anchorY-pt2.y):Math.abs(anchorX-pt2.x);
		var dist=((2*Math.PI)*radius)/4;
		var cant=Math.floor(dist/dot_size);
		var angle=90/cant;
		
		var sgX=( (pt2.x<pt1.x) )?1:1;
		var sgY=( (pt2.y<pt1.y) )?1:1;
		var cOX=(anchorX==pt1.x)?pt2.x:pt1.x;
		var cOY=(anchorY==pt1.y)?pt2.y:pt1.y;
		
		for(var i=0;i<cant;i++){
			//trace(Math.cos(   parseAngle( ((i+1)*angle) )   )+" "+Math.sin(   parseAngle( ((i+1)*angle) )   ));
			var x=sgX*(Math.cos(   parseAngle( ((i+1)*angle) )   )* radius *( ( (pt2.x==anchorX)?-1:1 )*( Math.abs(pt1.x-pt2.x)/(pt1.x-pt2.x) ) ) );
			var y=sgY*(Math.sin(   parseAngle( ((i+1)*angle) )   )* radius *( ( (pt2.y==anchorY)?-1:1 )*( Math.abs(pt1.y-pt2.y)/(pt1.y-pt2.y) ) ) );
			
			x+=cOX;
			y+=cOY;
			
			if(i%2==0 && dashed){
				mc.moveTo(x,y);
			}else{
				mc.lineTo(x,y);
			}
		}
		mc.moveTo(pt1.x,pt1.y);
		/*mc.moveTo(cOX-2,cOY-2);
		mc.lineTo(cOX+2,cOY+2);
		mc.moveTo(cOX-2,cOY+2);
		mc.lineTo(cOX+2,cOY-2);
		
		mc.moveTo(anchorX-2,anchorY-2);
		mc.lineTo(anchorX+2,anchorY+2);
		mc.moveTo(anchorX-2,anchorY+2);
		mc.lineTo(anchorX+2,anchorY-2);
		
		mc.moveTo(pt1.x-2,pt1.y-2);
		mc.lineTo(pt1.x+2,pt1.y+2);
		mc.moveTo(pt1.x-2,pt1.y+2);
		mc.lineTo(pt1.x+2,pt1.y-2);
		
		mc.moveTo(pt2.x-2,pt2.y-2);
		mc.lineTo(pt2.x+2,pt2.y+2);
		mc.moveTo(pt2.x-2,pt2.y+2);
		mc.lineTo(pt2.x+2,pt2.y-2);*/
		
		mc.moveTo(pt2.x,pt2.y);
	}
	
	function parseAngle(angle){
		return angle*(Math.PI/180);
	}
	
	function getEndElementLines(){
		var lines=new Array();
		for(var i in this._parent){
			if(this._parent[i] != this && 
			   (this._parent[i].m_startElementMc==m_endElementMc ||
				this._parent[i].m_endElementMc==m_endElementMc) ){
				lines.push(this._parent[i]);
			}
		}
		return lines;
	}
	
	function getStartElementLines(){
		var lines=new Array();
		for(var i in this._parent){
			if(this._parent[i] != this && 
			   (this._parent[i].m_startElementMc==m_startElementMc ||
				this._parent[i].m_endElementMc==m_startElementMc) ){
				lines.push(this._parent[i]);
			}
		}
		return lines;
	}
	
	function checkEndElement(){
		var lines=getEndElementLines();
		
		for(var i=0;i<lines.length;i++){
			if(lines[i].m_startElementMc==this.m_endElementMc &&
			lines[i].startType==this.endType){
				
			}
		}
	}
	
}
