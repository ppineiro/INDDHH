class com.st.process.view.elements.line.LineSegment extends MovieClip{
	
	var lineStyle="";
	var lineWidth=1.5;
	var lineColor=0xA4A4A4;
	
	var thinLine:MovieClip;
	var backLine:MovieClip;
	
	var startPoint:MovieClip;
	var endPoint:MovieClip;
	
	var dotted=false;
	
	function LineSegment(){
	}
	
	
	public function updateSegment(){
		var x1=startPoint._x;
		var y1=startPoint._y;
		var x2=endPoint._x;
		var y2=endPoint._y;
		drawLineFromTo(thinLine,x1,y1,x2,y2);
	}
	
	public function getStartElement():MovieClip{
		return startPoint;
	}
	public function getEndElement():MovieClip{
		return endPoint;
	}
	public function setStartElement(point:MovieClip){
		startPoint=point;
	}
	public function setEndElement(point:MovieClip){
		endPoint=point;
	}
	
	function setDotted(dot){
		dotted=dot;
	}
	
	function drawLineFromTo(mc,startx, starty, endx, endy){
		thinLine=this.createEmptyMovieClip("thinLine",2);
		backLine=this.createEmptyMovieClip("backLine",1);
		thinLine.lineStyle(lineWidth,lineColor,60,false);
		backLine.lineStyle(15,lineColor,0,false);
		if(dotted){
			dashTo(thinLine,startx, starty, endx, endy, 5, 5);
			dashTo(backLine,startx, starty, endx, endy, 5, 5);
		}else{
			thinLine.moveTo(startx,starty);
			thinLine.lineTo(endx,endy);
			backLine.moveTo(startx,starty);
			backLine.lineTo(endx,endy);
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
	
	function remove(){
		this.removeMovieClip();
	}
	
	function getLength(){
		var xLength=Math.abs(endPoint._x-startPoint._x);
		var yLength=Math.abs(endPoint._y-startPoint._y);
		return Math.sqrt( Math.pow(xLength,2) + Math.pow(yLength,2) );
	}
	
	function getSegmentPoint(length){
		var xLength=endPoint._x-startPoint._x;
		var yLength=endPoint._y-startPoint._y;
		//var tan=yLength/xLength;
		var cotang=Math.atan2(yLength,xLength);
		//var minX=(startPoint._x<endPoint._x)?startPoint._x:endPoint._x;
		//var minY=(startPoint._y<endPoint._y)?startPoint._y:endPoint._y;
		var minX=startPoint._x;
		var minY=startPoint._y;
		var point={ x:(Math.cos(cotang)*length)+minX, y:(Math.sin(cotang)*length)+minY };
		return point;
	}
	
}