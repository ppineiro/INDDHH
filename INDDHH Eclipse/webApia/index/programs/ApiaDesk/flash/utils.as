import flash.geom.Matrix;
class utils{
	function utils(){}
	function writeToMC(obj:Object){
		var mc=obj.mc;
		mc.createTextField((obj.name),obj.depth,obj.x,obj.y,obj.width,obj.height);
		var my_txt=mc[obj.name];
		my_txt.multiline = true;
		my_txt.wordWrap = true;
		var my_fmt:TextFormat = new TextFormat();
		my_txt.leftMargin=obj.leftMargin;
		my_fmt.font="Arial";
		my_fmt.size=obj.fontSize;
		my_fmt.bold=obj.bold;
		my_fmt.align=obj.align;
		my_fmt.color=obj.color;
		my_txt.text = obj.text;
		my_txt.selectable=false;
		my_txt.setTextFormat(my_fmt);
		return my_txt;
	}
	
	
	function generateScroll(containermc:MovieClip,contentmc:MovieClip,width,height){
		var hasHScroll=(containermc._width>width);
		var hasVScroll=(containermc._height>height);
		var mask=createSquare(containermc,width,height,0x000000,0x000000);
		containermc.mask=mask;
		containermc.setMask(mask);
		containermc.content=contentmc;
		if(hasHScroll){
			var hScrollWidth=(!hasVScroll) ? width : (width-10);
			var backColor={fillType:"linear",colors:[0xFFFFFF,0xBBBBBB,0xBBBBBB,0x666666],alphas:[100,100,100,100],ratios:[60,150,200,240],matrix:(new Matrix())};
			containermc.leftButton=createSquare(containermc,10,10,backColor,0x000000,{_x:0,_y:(height-10)});
			containermc.rightButton=createSquare(containermc,10,10,backColor,0x000000,{_x:(width-20),_y:(height-10)});
			createTriangle(containermc.leftButton,6,(Math.sqrt(36-3)),0x333333,null,{_rotation:270,_x:2,_y:8});
			createTriangle(containermc.rightButton,6,(Math.sqrt(36-3)),0x333333,null,{_rotation:90,_x:8,_y:2});
			containermc.rightButton.onPress=function(){
				this._parent.hScrollBar.scroll(-1);
			}
			containermc.leftButton.onPress=function(){
				this._parent.hScrollBar.scroll(+1);
			}
			var hScrollBar:MovieClip=createSquare(containermc,(hScrollWidth-20),10,null,0x000000,{_x:10,_y:(height-10)});
			hScrollBar.dragBar=createSquare(hScrollBar,((hScrollWidth-20)/(containermc._width/(hScrollWidth-20))),8,backColor,0x000000,{_x:0,_y:0});
			containermc.hScrollBar=hScrollBar;
			hScrollBar.scroll=function(dir){
				var cont=this._parent.content;
				var scrollBar=this;
				var actualX=Math.abs(cont._x);
				var maxMove=cont._width-(scrollBar._width+20);
				var maxScroll=scrollBar._width-scrollBar.dragBar._width;
				var xNum=Math.floor(actualX/(scrollBar._width+20));
				actualX=-((xNum-dir)*(scrollBar._width+20));
				if(Math.abs(actualX)<=Math.abs(maxMove) && actualX<0){
					scrollBar.dragBar._x=-((actualX*maxScroll)/maxMove);
					cont._x=actualX;
				}else if(actualX>=0){
					scrollBar.dragBar._x=0;
					cont._x=0;
				}else{
					scrollBar.dragBar._x=maxScroll;
					cont._x=-maxMove;
				}
			}
			hScrollBar.dragBar.onPress=function(evt){
				startDrag(this,false,0,0,(hScrollBar._width-this._width),(hScrollBar._height-11));
				this.onMouseMove = function() {
					var cont=this._parent._parent.content;
					var maxScroll=this._parent._width-this._width;
					var maxMove=cont._width-(this._parent._width+20);
					cont._x=-( ( (this._x * maxMove) / maxScroll ) );
				}
			}
			hScrollBar.dragBar.onRelease=function(evt){
				this.stopDrag();
				this.onMouseMove=null;
			}
			hScrollBar.dragBar.onReleaseOutside=function(evt){
				this.stopDrag();
				this.onMouseMove=null;
			}
		}
		if(hasVScroll){
			var vScrollHeight=(!hasHScroll) ? height : (height-10);
			var backColor={fillType:"linear",colors:[0xFFFFFF,0xBBBBBB,0xBBBBBB,0x666666],alphas:[100,100,100,100],ratios:[60,150,200,240],matrix:(new Matrix())};
			containermc.upButton=createSquare(containermc,10,10,backColor,0x000000,{_x:(width-10),_y:0});
			containermc.downButton=createSquare(containermc,10,10,backColor,0x000000,{_x:(width-10),_y:(vScrollHeight-10)});
			createTriangle(containermc.upButton,6,(Math.sqrt(36-3)),0x333333,null,{_x:2,_y:2});
			createTriangle(containermc.downButton,6,(Math.sqrt(36-3)),0x333333,null,{_rotation:180,_x:8,_y:8});
			containermc.downButton.onPress=function(){
				this._parent.vScrollBar.scroll(-1);
			}
			containermc.upButton.onPress=function(){
				this._parent.vScrollBar.scroll(+1);
			}
			var vScrollBar:MovieClip=createSquare(containermc,10,(vScrollHeight-20),null,0x000000,{_x:(width-10),_y:10});
			vScrollBar.dragBar=createSquare(vScrollBar,10,((vScrollHeight-20)/(containermc._height/(vScrollHeight-20))),backColor,0x000000,{_x:0,_y:0});
			containermc.vScrollBar=vScrollBar;
			vScrollBar.scroll=function(dir){
				var cont=this._parent.content;
				var scrollBar=this;
				var actualY=Math.abs(cont._y);
				var maxMove=cont._height-(scrollBar._height+20);
				var maxScroll=scrollBar._height-scrollBar.dragBar._height;
				var yNum=Math.floor(actualY/(scrollBar._height+20));
				actualY=-((yNum-dir)*(scrollBar._height+20));
				if(Math.abs(actualY)<=Math.abs(maxMove) && actualY<0){
					scrollBar.dragBar._y=-((actualY*maxScroll)/maxMove);
					cont._y=actualY;
				}else if(actualY>=0){
					scrollBar.dragBar._y=0;
					cont._y=0;
				}else{
					scrollBar.dragBar._y=maxScroll;
					cont._y=-maxMove;
				}
			}
			vScrollBar.dragBar.onPress=function(evt){
				startDrag(this,false,0,0,(vScrollBar._width-11),(vScrollBar._height-this._height));
				this.onMouseMove = function() {
					var cont=this._parent._parent.content;
					var maxScroll=this._parent._height-this._height;
					var maxMove=cont._height-(this._parent._height+20);
					cont._y=-( ( (this._y * maxMove) / maxScroll ) );
				}
			}
			vScrollBar.dragBar.onRelease=function(evt){
				this.stopDrag();
				this.onMouseMove=null;
			}
			vScrollBar.dragBar.onReleaseOutside=function(evt){
				this.stopDrag();
				this.onMouseMove=null;
			}
		}
		if(hasHScroll && hasVScroll){
			containermc.corner=createSquare(containermc,10,10,0xFEFEFE,null,{_x:(width-9),_y:(height-9)});
		}
		containermc.border=createSquare(containermc,width-1,height-1,null,0x000000,{_x:0,_y:0});
	}
	
	function removeScroll(mc){
		mc.setMask(null);
		if(mc.hScrollBar){mc.hScrollBar.removeMovieClip();mc.rightButton.removeMovieClip();mc.leftButton.removeMovieClip();}
		if(mc.vScrollBar){mc.vScrollBar.removeMovieClip();mc.upButton.removeMovieClip();mc.downButton.removeMovieClip();}
		if(mc.mask){mc.mask.removeMovieClip();}
		if(mc.vScrollBar){mc.corner.removeMovieClip();}
		if(mc.vScrollBar){mc.border.removeMovieClip();}
	}
	
	function createSquare(mc,width,height,color,lineColor,atts){
		var num=mc.getNextHighestDepth();
		var square:MovieClip=mc.createEmptyMovieClip(("square_"+num),num);
		if(lineColor!=null && lineColor!=undefined){
			square.lineStyle(1,lineColor);
		}
		if(color!=null && color!=undefined){
			if(!color.fillType){
				square.beginFill(color);
			}else{
				square.beginGradientFill(color.fillType,color.colors,color.alphas,color.ratios,color.matrix);
			}
		}
		square.moveTo(0,0);
		square.lineTo(0, height);
		square.lineTo(width, height);
		square.lineTo(width, 0);
		square.lineTo(0, 0);
		for(var i in atts){
			square[i]=atts[i];
		}
		return square;
	}
	
	function createTriangle(mc,base,height,color,lineColor,atts){
		var num=mc.getNextHighestDepth();
		var square:MovieClip=mc.createEmptyMovieClip(("square_"+num),num);
		if(lineColor!=null && lineColor!=undefined){
			square.lineStyle(1,lineColor);
		}
		if(color!=null && color!=undefined){
			if(!color.fillType){
				square.beginFill(color);
			}else{
				square.beginGradientFill(color.fillType,color.colors,color.alphas,color.ratios,color.matrix);
			}
		}
		square.moveTo(0,height);
		square.lineTo(base, height);
		square.lineTo((base/2), 0);
		square.lineTo(0, height);
		for(var i in atts){
			square[i]=atts[i];
		}
		return square;
	}

}