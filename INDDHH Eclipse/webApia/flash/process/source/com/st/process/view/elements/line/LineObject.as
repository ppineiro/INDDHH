import mx.events.EventDispatcher;
import flash.filters.GlowFilter;

class com.st.process.view.elements.line.LineObject extends MovieClip{
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	
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
	
	var lineMC:MovieClip;
	var arrowMC:MovieClip;
	
	var startVertex:MovieClip;
	var endVertex:MovieClip;
	
	private var lineVertexs=new Array();
	private var lineSegments=new Array();
	
	var lastClick:Number=0;
	var dblClickSpeed:Number=400;
	
	var justDblClicked=false;
	
	var isWizard=false;
	
	public function LineObject(){
		startVertex=null;
		endVertex=null;
		m_endElementMc.addEventListener("onElementMoved",this);
		m_startElementMc.addEventListener("onElementMoved",this);
		m_endElementMc.addEventListener("onElementDeleted",this);
		m_startElementMc.addEventListener("onElementDeleted",this);
		mx.events.EventDispatcher.initialize(this);
		this.useHandCursor = true;
		lineMC=this.createEmptyMovieClip("lineMC",2);
		setLineEvents();
		addSegment(m_startElementMc,m_endElementMc);
		refreshWholeLine();
	}
	
	function onDoubleClick(){
		var seg=null;
		//for(var i=0;i<lineSegments.length;i++){
			//if(lineSegments[i].hitTest(this._xmouse,this._ymouse,true)){
				//seg=lineSegments[i];
		for(var i in lineMC){
			var p={x:lineMC._xmouse+lineMC._parent._parent._x,y:lineMC._ymouse+lineMC._parent._parent._y};
			
			lineMC.localToGlobal(p); 
			if(lineMC[i]._parent){
				lineMC[i]._parent.globalToLocal(p);
			}
			if(lineMC[i].hitTest(p.x,p.y,true)){
				seg=lineMC[i];
				break;
			}
		}
		if(seg){
			addVertex(seg.getStartElement(),seg.getEndElement(),null,null);
		}
	}
	
	function setLineEvents(){
		var tmp=this;
		lineMC.onRelease=function() {
			var timer = getTimer();
			if(Key.isDown(Key.CONTROL)){
				if( (timer-this._parent.lastClick)<this._parent.dblClickSpeed){
					tmp.justDblClicked=true;
					tmp.onDoubleClick();
				}
			}else{
				tmp.dispatchEvent({type:"onLineClicked"});
			}
			tmp.lastClick=timer;
			
		}
		lineMC.onPress=function(){
			tmp.dispatchEvent({type:"onLineClick"});
		}
		lineMC.onRollOver=function(){
			var fGlow:GlowFilter = new GlowFilter(0x7aff43,.5,2,2,4,3,false,false);
			this.filters=[fGlow];
			tmp.dispatchEvent({type:"onElementRollOver"});
		}
		lineMC.onRollOut=function(){
			this.filters=[];
			tmp.dispatchEvent({type:"onElementRollOut"});
		}
	}
	function remove(){
		m_startElementMc.removeEventListener("onElementDeleted", this);
		m_endElementMc.removeEventListener("onElementDeleted",this);
		m_endElementMc.removeEventListener("onElementMoved",this);
		m_startElementMc.removeEventListener("onElementMoved",this);
		this.removeMovieClip();
	}
	
	
	public function addVertex(startEl,endEl,x,y){
		//startVertex=null;
		//endVertex=null;
		if(!x || !y){
			x=this._xmouse;
			y=this._ymouse;
		}
		var depth=this.getNextHighestDepth()+10;
		var lineVertex=this.attachMovie("LineVertex","vertex_"+depth,depth,{_x:x,_y:y});
		lineVertex.addEventListener("onVertexClick",this);
		lineVertex.addEventListener("onVertexMoved",this);
		lineVertex.addEventListener("onVertexClicked",this);
		lineVertex.addEventListener("onVertexDoubleClicked",this);
		lineVertex.addEventListener("onVertexRollOver",this);
		lineVertex.addEventListener("onVertexRollOut",this);
		
		if(startEl!=m_startElementMc){
			startEl.setNextElement(lineVertex);
		}else{
			startVertex=lineVertex;
		}
		
		if(endEl!=m_endElementMc){
			endEl.setLastElement(lineVertex);
		}else{
			endVertex=lineVertex;
		}
		lineVertex.setLastElement(startEl);
		lineVertex.setNextElement(endEl);
		lineVertexs.push(lineVertex);
		
		var seg=getSegment(startEl,endEl);
		seg.setEndElement(lineVertex);
		addSegment(lineVertex,endEl);
		refreshWholeLine();
	}
	
	function removeVertex(vertex){
		for(var i=0;i<lineVertexs.length;i++){
			if(lineVertexs[i]==vertex){
				if(startVertex==vertex){
					startVertex=(vertex.getNextElement() && vertex.getNextElement()!=m_endElementMc)?vertex.getNextElement():null;
				}
				if(endVertex==vertex){
					endVertex=(vertex.getLastElement() && vertex.getLastElement()!=m_startElementMc)?vertex.getLastElement():null;
				}
				var segment=getSegment(vertex,vertex.getNextElement());
				removeSegment(segment);
				segment=getSegment(vertex.getLastElement(),vertex);
				segment.setEndElement(vertex.getNextElement());
				if(vertex.getLastElement()!=m_startElementMc){
					vertex.getLastElement().setNextElement(vertex.getNextElement());
				}
				if(vertex.getLastElement()!=m_endElementMc){
					vertex.getNextElement().setLastElement(vertex.getLastElement());
				}
				lineVertexs.splice(i,1);
				vertex.remove();
				refreshWholeLine();
			}
		}
	}
	
	function removeSegment(segment){
		for(var i in lineMC){
			var seg=lineMC[i];
			if(seg==segment){
				lineSegments.splice(i,1);
				segment.remove();
			}
		}
		
	}
	
	function onVertexClick(eventObj:Object):Void{
		var vertex = eventObj.target;
	}
	function onVertexMoved(eventObj:Object):Void{
		var vertex = eventObj.target;
		refreshWholeLine();
	}
	function onVertexClicked(eventObj:Object):Void{
		var vertex = eventObj.target;
	}
	function onVertexRollOver(eventObj:Object):Void{
		var vertex = eventObj.target;
	}
	function onVertexRollOut(eventObj:Object):Void{
		var vertex = eventObj.target;
	}
	function onVertexDoubleClicked(eventObj:Object):Void{
		var vertex = eventObj.target;
		removeVertex(vertex);
	}
	
	function refreshWholeLine(){
		//for(var i=0;i<lineSegments.length;i++){
			//var seg=lineSegments[i];
		for(var i in lineMC){
			var seg=lineMC[i];
			seg.setDotted(isLooped_back);
			seg.updateSegment();
		}
		setArrow();
		updateArrowPos();
		updateLineIcons();
	}
	
	function addSegment(startEl,endEl){
		var depth=lineMC.getNextHighestDepth()+10;
		var segment=lineMC.attachMovie("LineSegment",("lineSegment_"+depth),depth,{startPoint:startEl,endPoint:endEl});
		segment.addEventListener("onSegmentDocubleClicked",this);
		//this.lineSegments.push(segment);
	}
	

	function getSegment(startEl,endEl){
		//for(var i=0;i<lineSegments.length;i++){
		//	var seg=lineSegments[i];
		for(var i in lineMC){
			var seg=lineMC[i];
			if(seg.getStartElement()==startEl && seg.getEndElement()==endEl){
				return seg;
			}
		}
	}
	
	function onElementMoved(){
		refreshWholeLine();
	}
	function onElementDeleted(){
		this.dispatchEvent({type:"onLineDelete"});
	}
	
	function setArrow(){
		arrowMC=this.createEmptyMovieClip("arrowMC",4);
		createArrow(0,0);
		if(isWizard){
			createArrow(0,15);
		}
	}
	
	function createArrow(x,y){
		arrowMC.lineStyle(0.25,0xCCCCCC,100);
		arrowMC.beginFill(0xCCCCCC,100);
		var size=10;
		arrowMC.moveTo(x,y);
		arrowMC.lineTo((size+x),-(size-y));
		arrowMC.lineTo(0,-(size-y));
		arrowMC.lineTo(-(size+x),-(size-y));
		arrowMC.lineTo(x,y);
		arrowMC.endFill();
	}
	
	public function loopBack(p_loopBack:Boolean):Void{
		isLooped_back = p_loopBack;
		//var oLine:MovieClip = this["theLine_mc"];
		//var a_color:Color = new Color(oLine);
		m_endElementMc.dispatchEvent({type:"onElementMoved"});//hack to update pos
	}
	
	public function setAsWizard(p_wizard:Boolean):Void{
		isWizard=p_wizard;
		m_endElementMc.dispatchEvent({type:"onElementMoved"}); //hack to update pos
	}
	
	public function getLastSegment(){
		for(var i in lineMC){
			var seg=lineMC[i];
			if(seg.getEndElement()==m_endElementMc){
				return seg;
			}
		}
		return null;
	}
	
	function updateArrowPos(){
		//arrowMC
		var lastVertex=(endVertex)?endVertex:m_startElementMc;
		var sin=m_endElementMc._x-lastVertex._x;
		var cos=m_endElementMc._y-lastVertex._y;

		var angle=-(Math.atan2(sin,cos)*(180/Math.PI));
		arrowMC._rotation= angle;
		arrowMC._x=m_endElementMc._x+ ( Math.cos((angle-90)*(Math.PI/180))*35 );
		arrowMC._y=m_endElementMc._y+ ( Math.sin((angle-90)*(Math.PI/180))*35 );
	}
	
	function updateLineIcons(){
		if(__namemc || __conditionmc){
			var middle=getMiddlePoint();
			var mx=middle.x+0;
			var my=middle.y+0;
			__namemc._x = mx-(__namemc._width/2);
			__namemc._y = my+2;
			//trace("zdcsdf dsf sdf sdf sdf "+(middle.x) );
			__conditionmc._x=mx;
			__conditionmc._y=my;
		}
	}
	
	public function showCondition(p_condition:String):Void{
		__conditionmc = this.attachMovie("condition", 'Condition', 9, {
			_x:140,
			_y:10
			});
		
		refreshWholeLine();
	};
	
	public function hideCondition():Void{
		__conditionmc.removeMovieClip();
		__conditionmc = null;
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
		refreshWholeLine();
		
	};
	
	public function hideName():Void{
		__namemc.removeMovieClip();
		__namemc = null;
	};
	
	function getMiddlePoint(){
		var distance=0;
		for(var i in lineMC){
			var lineLenght=lineMC[i].getLength();
			if(lineLenght){
				distance+=lineLenght;
			}
		}
		var middle=distance/2;
		distance=0;
		var length=middle;
		var seg=null;
		if(getLineVertexQuant()==0){
			seg=getSegment(m_startElementMc,m_endElementMc);
		}else{
			var s=m_startElementMc;
			var e=startVertex;
			while(e){
				seg=getSegment(s,e);
				var lineLenght=seg.getLength();
				if(distance<middle && distance+lineLenght>middle){
					length=middle-distance;
					e=null;
					break;
				}else{
					distance+=lineLenght;
					s=e;
					e=s.getNextElement();
				}
			}
		}
		return seg.getSegmentPoint(length);
		
	}
	
	public function getVertexData(){
		var data="";
		var e=startVertex;
		while(e){
			data+=e._x+";"+e._y;
			e=e.getNextElement();
			if(e!=m_endElementMc){
				data+="-";
			}else{
				e=null;
			}
		}
		return data;
	}
	
	public function setVertexData(data:String){
		var vertexes=data.split("-");
		var x=vertexes[0].split(";")[0];
		var y=vertexes[0].split(";")[1];
		addVertex(m_startElementMc,m_endElementMc,x,y);
		var vert=startVertex;
		for(var i=1;i<vertexes.length;i++){
			x=vertexes[i].split(";")[0];
			y=vertexes[i].split(";")[1];
			addVertex(vert,m_endElementMc,x,y);
			vert=vert.getNextElement();
		}
	}
	
	private function getLineVertexQuant(){
		var count=0;
		for(var i=0;i<lineVertexs.length;i++){
			if(lineVertexs[i]._parent==this){
				count++;
			}
		}
		return count;
	}
	
}