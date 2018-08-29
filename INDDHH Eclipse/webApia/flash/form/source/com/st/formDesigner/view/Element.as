

/////////////////////////////////////////////////
// element Mc
// 180x30
////////////////////////////////////////////////
import mx.events.EventDispatcher;

class com.st.formDesigner.view.Element extends MovieClip{
	
	var EL_COLOR = "0xDDDDDD";
	var EL_COLOR_SEL = "0xB4E0F3";
	
	var bind:MovieClip;
	var isBinded:MovieClip;
	var hasBind:Boolean=false;
	
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	
	var m_doubleClickSpeed:Number = 300;
	var m_lastClick:Number;
	//var skipRelease:Boolean = false;
	
	function Element(Void){
		mx.events.EventDispatcher.initialize(this);
		this.useHandCursor = false;
	};
	
	
	////////////////////////////////////////////////////////////////////
	// width & height used in grid snapping
	////////////////////////////////////////////////////////////////////
	function _getElementWidth(){
		return this["box_mc"]._width;
	};
	
	function _getElementHeight(){
		return this["box_mc"]._height;
	};

	
	var x:Number;
	var y:Number;
	var flag:Boolean=false;
	
	function onPress(){
		//Element
		//if(!this.isTweening()){
			this.swapDepths(_parent.getNextHighestDepth()-1);
			if ((getTimer() - m_lastClick) < m_doubleClickSpeed) {
				//DBL CLICK
//				this.dispatchEvent({type:"onElementDblClicked"});
			}else{
				//CLICK
				this.dispatchEvent({type:"onElementClicked"});
				if(flag==false){
				this.x=_root._xmouse;
				this.y=_root._ymouse;
				}
				this.onMouseMove = function(){
					this.dispatchEvent({type:"onElementMoved"});
					updateAfterEvent();
				}
			}
			m_lastClick = getTimer();
		//}
	};
	
	function onRelease(){
		if(this.x==_root._xmouse && this.y==_root._ymouse){
			this.dispatchEvent({type:"onElementDblClicked"});
			}
		delete this.onMouseMove;
		this.dispatchEvent({type:"onElementReleased"});
		this.flag=false;
	};

	function onReleaseOutside() {
		this.onRelease();
	};
	
	function onRollOver(){
		this.dispatchEvent({type:"onElementRollOver"});
		showBind();
	};
	function onRollOut(){
	this.dispatchEvent({type:"onElementRollOut"});
	if(hasBind){
		bind._alpha=40;
	}

	};
	
	function showBind(){
			if(hasBind){
				bind._alpha=70;
				}
		}
	function setHasBind(isBind:Boolean){
			hasBind=isBind;
			if(isBind){
				this.createEmptyMovieClip("b",60);
				bind=attachMovie("bind","b",60,{_x:0,_y:0});
				bind._alpha=30;
			}else{
				this.createEmptyMovieClip("b",60);
				isBind=null;
			}
		}
	function showBinded(aux:Boolean){
			if(aux){
				isBinded=attachMovie("binded","binded",30,{_x:0,_y:0});
				isBinded._alpha=0;
				isBinded.alphaTo(60);
			}
			if(!aux){
				this.createEmptyMovieClip("binded",30);
				//isBinded=new MovieClip();
			}
		}
	/*
	function select(){
		var bgcolor = new Color(bg_mc);
			bgcolor.setRGB(EL_COLOR_SEL);  
	};
	function deselect(){
		var bgcolor = new Color(bg_mc);
			bgcolor.setRGB(EL_COLOR);  
	};
	*/
	
	////////////////////
	// FRMGRID
	////////////////////
	/*
	function addColToGrid(el_type,p_fieldId){
		this["obj_" + fieldId].addColumn(el_type,p_fieldId);
	};
	
	function checkFrmGridHit(p:Object):Boolean{
		if(this.fieldType==14){
			for(var j in frm_element.colArray){
				if(frm_element.colArray[j].hitTest(p.x, p.y, false)){
					//trace("COL EL CLICKED" + frm_element.colArray[j].fieldLabel);
					doGridColPress(frm_element.colArray[j]);
					return false;
				}
			}
		}
		return true;
	};
	
	function doGridColPress(frmGridCol:MovieClip){
		trace(frmGridCol.fieldLabel);
	};
	
	////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////
	// PROPERTIES FUNCTIONS
	/////////////////////////////////////////////////////////
	function setElementDisabled(pEnabled:Boolean){
		m_disabled = pEnabled;
		frm_element.setFieldDisabled(m_disabled);
	};
	
	function setElementRequired(pRequired:Boolean){
		m_required = pRequired;
		frm_element.setFieldRequired(m_required);
	};
	
	function setElementValue(pValue:String){
		fieldLabel = pValue;
		frm_element.setFieldLabel(fieldLabel);
	};
	
	function setElementSize(pSize:Number){
		m_size = pSize;
		frm_element.setFieldSize(m_size);
	};
	
	function setElementReadOnly(pReadOnly:Boolean){
		m_readOnly = pReadOnly;
		frm_element.setFieldReadOnly(m_readOnly);
	};
	
	function setElementWidth(pWidth:Number){
		frm_element.setFieldWidth(pWidth);
	};
	function setElementHeight(pHeight:Number){
		frm_element.setFieldHeight(pHeight);
	};
	function setElementSource(pUrl:String){
		frm_element.setFieldSource(pUrl);
	};
	
	
	////////////////////////////////////////////////////////
	// ATT FUNCTIONS
	/////////////////////////////////////////////////////////
	function setAttributes(p_attId:Number,p_attlabel:String,p_attName:String){
		attId = p_attId;
		attName = p_attName;
		this.setElementValue(p_attlabel);
		//fieldLabel = p_attlabel;
		//frm_element.setLabel(fieldLabel);
	};
	
	////////////////////////////////////////////////////////
	// TMP FUNCTIONS
	/////////////////////////////////////////////////////////
	function randomColor(){
		var e = new Color(bg_mc);
		var col = random(255) << 16 | random(255) << 8 | random(255);
		e.setRGB(col);  
	};
	*/
}