import utils;
import flash.geom.Matrix;
class ListView extends MovieClip {
	var list:MovieClip;
	var width:Number;
	var height:Number;
	var _elementWidth:Number;
	var elements:Array;
	var _selectedItems:Array;
	var util:utils;
	var back:MovieClip;
	function ListView() {
		elements = new Array();
		_selectedItems=new Array();
		util=new utils();
		width=this._width;
		height=this._height;
	}
	function setWidth(num) {
		width = num;
	}
	function setHeight(num) {
		height = num;
	}
	function generateList(listArray:Array) {
		if(elements.length>0){
			util.removeScroll(this);
		}
		_elementWidth=width;
		setElementWidth(listArray.length);
		back = this.createEmptyMovieClip("list", 0);
		var backColor={fillType:"linear",colors:[0x666666],alphas:[20],ratios:[255],matrix:(new Matrix())};
		util.createSquare(back, width, height, backColor,null,null);
		list = this.createEmptyMovieClip("list", 1);
		for (var i = 0; i<listArray.length; i++) {
			var elementMc=getListElement(listArray[i]);
			elements.push(elementMc);
			var tmp=this;
			elementMc.onRelease=function(evt){
				if (!Key.isDown(Key.CONTROL)){
					tmp.unselectAll();
				}
				var myGlowFilter = new flash.filters.GlowFilter();
				myGlowFilter.color=0xD5FFBB;
				myGlowFilter.distance=0;
				myGlowFilter.strength=2;
				myGlowFilter.blurX=30;
				myGlowFilter.blurY=30;
				myGlowFilter.inner=true;
				var myFilters:Array = this.filters;
				myFilters.push(myGlowFilter);
				this.back.filters=myFilters;
				tmp._selectedItems.push(this);
			}
			elementMc.onRollOver=function(evt){
				tmp.setHover(this);
			}
			elementMc.onRollOut=function(evt){
				tmp.unSetHover(this);
			}
		}
		util.generateScroll(this,list,(width+1),(height+1))
	}
	function setHover(element){
		unSetHover(element);
		var myGlowFilter = new flash.filters.GlowFilter();
		myGlowFilter.color=0xD9E4FF;
		myGlowFilter.distance=0;
		myGlowFilter.strength=2;
		myGlowFilter.blurX=30;
		myGlowFilter.blurY=30;
		myGlowFilter.inner=true;
		var myFilters:Array = element.back.filters;
		myFilters.push(myGlowFilter);
		element.back.filters=myFilters;
	}
	function unSetHover(element){
		var filters:Array=element.back.filters;
		for(var i=0;i<filters.length;i++){
			if(filters[i].color==0xD9E4FF){
				filters.splice(i,1);
			}
		}
		element.back.filters=filters;
	}
	function getListElement(element) {
		var elementMc = list.createEmptyMovieClip(("element_"+elements.length), elements.length);
		var y=elements.length*20;
		var color = 0xFFFFFF;
		if((elements.length%2)==0){
			color = 0xEEE4EE;
		}
		var sqr=util.createSquare(elementMc, (_elementWidth), 20, color,color,null);
		sqr._alpha=90;
		elementMc.back=sqr;
		util.writeToMC({mc:elementMc,depth:10,x:0,y:0,width:(_elementWidth),height:20,name:("text"),text:element.text,bold:false,fontSize:12,color:0x000000,align:"left"});
		elementMc._y=y;
		elementMc.value=element.text;
		elementMc.data=element;
		return elementMc;
	}
	function unselectAll(){
		for(var i=0;i<_selectedItems.length;i++){
			_selectedItems[i].back.filters=new Array();
		}
		_selectedItems=new Array();
	}
	function get selectedItems(){
		return _selectedItems;
	}
	function _removeElement(el:MovieClip){
		for(var i=0;i<elements.length;i++){
			if(elements[i]==el){
				elements.splice(i,1);
				el.removeMovieClip();
			}
		}
	}
	function removeElement(el:MovieClip){
		_removeElement(el);
		redrawList();
	}
	function removeSelectedElements(){
		for(var i=0;i<_selectedItems.length;i++){
			_removeElement(_selectedItems[i]);
		}
		_selectedItems=new Array();
		redrawList();
	}
	private function redrawList(){
		var aux:Array=new Array();
		for(var i=0;i<elements.length;i++){
			aux.push(elements[i].data);
		}
		elements=new Array();
		util.removeScroll(this);
		this.generateList(aux);
	}
	function setElementWidth(cant){
		_elementWidth=width;
		if(height<(cant*20)){
			_elementWidth-=10;
		}
	}
}
