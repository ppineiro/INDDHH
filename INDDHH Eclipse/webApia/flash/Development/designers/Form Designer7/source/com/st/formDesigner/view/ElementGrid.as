

/////////////////////////////////////////////////
// element Mc
// 180x30
////////////////////////////////////////////////
import mx.events.EventDispatcher;


class com.st.formDesigner.view.ElementGrid extends MovieClip{
	
	var EL_COLOR = "0xDDDDDD";
	var EL_COLOR_SEL = "0xB4E0F3";
	
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	
	var m_doubleClickSpeed:Number = 300;
	var m_lastClick:Number;
	//var skipRelease:Boolean = false;
	
	var colSpan:Number;
	var rowSpan:Number;
	var child_arr:Array;
	var colArray:Array;
	
	
	function ElementGrid(Void){
		var tmp = this;
		mx.events.EventDispatcher.initialize(this);
		this.useHandCursor = false;
		
		//col & row span background
		this["box_mc"]._xscale = colSpan*100;
		this["box_mc"]._yscale = rowSpan*100;
		this["box_mc"].useHandCursor = false;
		var x:Number;
		var y:Number;
		var flag:Boolean=false;
		this["box_mc"].onPress = function(){
			if(!flag){
				x=_root._xmouse;
				y=_root._ymouse;
				flag=true;
				}
			tmp.swapDepths(_parent.getNextHighestDepth()-1);
			//if ((getTimer() - tmp.m_lastClick) < tmp.m_doubleClickSpeed) {
				//DBL CLICK
				//tmp.dispatchEvent({type:"onElementDblClicked"});
			//}else{
				//CLICK
				trace("GRID CLICKED")
				tmp.dispatchEvent({type:"onElementClicked"});
				this.onMouseMove = function(){
					tmp.dispatchEvent({type:"onElementMoved"});
					updateAfterEvent();
				}
			//}
			//tmp.m_lastClick = getTimer();
		};
		
		this["box_mc"].onRelease = function(){
			if(x==_root._xmouse && y==_root._ymouse){
				tmp.dispatchEvent({type:"onElementDblClicked"});
				}
			flag=false;
			delete this.onMouseMove;
			tmp.dispatchEvent({type:"onElementReleased"});
		};

		this["box_mc"].onReleaseOutside = function() {
			this.onRelease();
		};
		
		//setup mask
		var box_mask = this.attachMovie("box","box_mask", 2);
			box_mask._xscale = (colSpan*100);
			box_mask._yscale = (rowSpan*100);
		this.setMask(box_mask);
		
		//Add Cols
		var xPos = 0;
		var colNro = child_arr.length;
		
		colArray = [];
		
		
		if(colNro==0 || colNro==null){colNro=1}
		var cellWidth = 720/colNro;
		
		//trace("cellWidth:" + cellWidth)
		for(var t=0;t<child_arr.length;t++){
			var objType = child_arr[t].fieldType;
			var nextDepth = this.getNextHighestDepth();
			//trace(child_arr[t].fieldLabel)
			colArray[t] = this.attachMovie("gridElementCol","col_" + t, nextDepth,{
				fieldLabel:child_arr[t].fieldLabel,
				fieldId:child_arr[t].fieldId,
				fieldType:objType
			});
			var x:Number;
			var y:Number;
			var flag:Boolean=false;
			colArray[t].onPress=function(){
				//tmp.dispatchEvent({type:"onColClicked",fieldId:this.fieldId,fieldType:this.fieldType});
				if ((getTimer() - tmp.m_lastClick) < tmp.m_doubleClickSpeed) {
					//DBL CLICK
					tmp.dispatchEvent({type:"onColDblClicked",fieldId:this.fieldId,fieldType:this.fieldType});
				}else{
					if(!this.flag){
						this.x=_root._xmouse;
						this.y=_root._ymouse;
						this.flag=true;
					}
					//CLICK
					tmp.dispatchEvent({type:"onColClicked",fieldId:this.fieldId,fieldType:this.fieldType});
				}
				tmp.m_lastClick = getTimer();
			}
			colArray[t].onRollOver=function(){
				tmp.dispatchEvent({type:"onColRollOver",fieldId:this.fieldId,fieldType:this.fieldType});
			}
			colArray[t].onRollOut=function(){
				tmp.dispatchEvent({type:"onColRollOut",fieldId:this.fieldId,fieldType:this.fieldType});
			}
			colArray[t].onRelease=function(){
				if(this.x==_root._xmouse && this.y==_root._ymouse){
					tmp.dispatchEvent({type:"onColDblClicked",fieldId:this.fieldId,fieldType:this.fieldType});
				}
				this.flag=false;
				
			}
			
			colArray[t]._x = xPos;
			colArray[t]["gridbg_mc"]._width = cellWidth;
			xPos = xPos + cellWidth;
			this.addElementToCol(objType,t);
		}
		
		
	};
	
	public function createNewCol(el_type:Number,fieldId:Number){
		//trace("CREATE NEW COL::::::::::::::::::::")
		//trace("fieldId"+fieldId)
		//trace("colArray.length"+colArray.length)
		addColumn(el_type,fieldId);
	};
	
	
	function addColumn(newObjType:Number,id:Number){
		var tmp = this;
		var nCol = colArray.length;
		var cellWidth = 720/(nCol+1);
		var xPos = 0;
		
		///--reposition old
		for(var e=0;e<nCol;e++){
			if(colArray[e]){
				//trace("Label:: " + colArray[e].fieldLabel);
				colArray[e]._x = xPos;
				colArray[e]["gridbg_mc"]._width = cellWidth;
				xPos = xPos + cellWidth;
			}
		};
		
		///---new
		var nextDepth = this.getNextHighestDepth();
		colArray[nCol] = this.attachMovie("gridElementCol","col_" + nCol, nextDepth,{
			fieldLabel:"untitled",
			fieldId:id,
			fieldType:newObjType
		});
		colArray[nCol]._x = xPos;
		colArray[nCol]["gridbg_mc"]._width = cellWidth;
		var x:Number;
		var y:Number;
		var flag:Boolean=false;
		colArray[nCol].onPress=function(){
			//tmp.dispatchEvent({type:"onColClicked",fieldId:this.fieldId,fieldType:this.fieldType});
			if ((getTimer() - tmp.m_lastClick) < tmp.m_doubleClickSpeed) {
				//DBL CLICK
				tmp.dispatchEvent({type:"onColDblClicked",fieldId:this.fieldId,fieldType:this.fieldType});
			}else{
				//CLICK
				if(!this.flag){
					this.x=_root._xmouse;
					this.y=_root._ymouse;
					this.flag=true;
				}
				tmp.dispatchEvent({type:"onColClicked",fieldId:this.fieldId,fieldType:this.fieldType});
			}
			tmp.m_lastClick = getTimer();
		}
		colArray[nCol].onRollOver=function(){
			tmp.dispatchEvent({type:"onColRollOver",fieldId:this.fieldId,fieldType:this.fieldType});
		}
		colArray[nCol].onRollOut=function(){
			tmp.dispatchEvent({type:"onColRollOut",fieldId:this.fieldId,fieldType:this.fieldType});
		}
		colArray[nCol].onRelease=function(){
			if(this.x==_root._xmouse && this.y==_root._ymouse){
			tmp.dispatchEvent({type:"onColDblClicked",fieldId:this.fieldId,fieldType:this.fieldType});
			}
			this.flag=false;
		}
		
		updateChildrenCollection(id,newObjType);
		
		addElementToCol(newObjType,nCol);
		
	};
	
	
	function changeAttribute(fieldId:Number,attLabel:String){
		for(var e=0;e<colArray.length;e++){
			if(colArray[e].fieldId == fieldId){
				colArray[e].fieldLabel = attLabel;
			}
		}
	};
	
	function removeCol(colId:Number){
		trace("COL TO REMOVE:::" + colId)
		for(var e=0;e<colArray.length;e++){
			if(colArray[e].fieldId == colId){
				colArray[e].removeEventListener("onElementClicked",this._parent);
				colArray[e].removeEventListener("onElementDblClicked",this._parent);
				colArray[e].removeEventListener("onElementMoved",this._parent);				
				colArray[e].removeEventListener("onElementReleased",this._parent);
				colArray[e].removeMovieClip();
				delete colArray[e];
				colArray.splice(e, 1); 
			}
		}
		///--reposition
		trace("colArray.length::" + colArray.length)
		var nCol = colArray.length;
		var cellWidth = 720/(nCol);
		var xPos = 0;
		for(var e=0;e<nCol;e++){
			if(colArray[e]){
				//trace("Label:: " + colArray[e].fieldLabel);
				colArray[e]._x = xPos;
				colArray[e]["gridbg_mc"]._width = cellWidth;
				xPos = xPos + cellWidth;
			}
		};
		var x:Number=0;
		var aux=0;
		for(x in colArray){
			colArray[x]._name=aux;
			aux=aux+1;
			}
		
	};
	
	function updateChildrenCollection(p_fieldId:Number,p_fieldType:Number){
		/*
		var formFieldAttributes:Object = {};
			formFieldAttributes.fieldId = p_fieldId;
			//formFieldAttributes.fieldLabel = ;
			formFieldAttributes.fieldType = p_fieldType;
			//formFieldAttributes.attId = parseInt();
			//formFieldAttributes.attName = "";
			formFieldAttributes.posGrid_x = child_arr.length +1;
			formFieldAttributes.posGrid_y = 0;
		
		var properties_Array:Array = new Array();
		var events_Array:Array = new Array();
		*/
		//child_arr.push(formFieldAttributes);
		
	};
	
	function addElementToCol(objType:Number,pos:Number){
		trace("FORM COMPONENT ADDED -->" + pos)
		var c;
		var initObject:Object = {};
		
		switch(objType){
			case 1:
				c = "TextInput";
			break;
			case 2:
				c = "ComboBox";
			break;
			case 3:
				c = "CheckBox";
			break;
			case 5:
				c = "Button";
				initObject = ""; //getInitObjectProperties(gridElementsColl[pos].prp_Array)
			break;
			case 12:
				c = "TextInput";
			break;
			case 7:
				c = "Label";
			break;
			case 11:
				c = "TextInput";
			break;

		}
		
		//ATTACH OBJ
		var nextDepth = colArray[pos].getNextHighestDepth();
		var tmpObj;
		if(objType!=11){
			tmpObj = colArray[pos].createObject(c,"comp", 1,initObject);
		}else{
			if(objType==11){
			tmpObj = colArray[pos].attachMovie("hidden","comp", 1,initObject);
			tmpObj._alpha=60;
			tmpObj.brightnessTo(70);
			}
			if(objType==12){
			tmpObj = colArray[pos].attachMovie(c,"comp", 1,initObject);
			tmpObj.text="*****";
			}
		}
			tmpObj._x = 4;
			tmpObj._y = 34;
		
		//trace("COMP CREATED:" + tmpObj._name + "\n")
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
	
	function getColObj(colFieldId:Number):MovieClip{
		//trace("---> GET OBJECT:" + colFieldId);
		for(var e=0; e < colArray.length; e++){
			if(colArray[e].fieldId==colFieldId){
				var obj =  colArray[e];
				//trace("FOUND OBJ" + obj)
				//trace("-->>>" + obj["comp"])
				return obj["comp"];
			}
		}
		//trace("NOT FOUND OBJ!!!!!!!!!!")
	};
	function moveCol(colFieldId:Number,num:Number){
		for(var e=0; e < colArray.length; e++){
			if(colArray[e].fieldId==colFieldId){
				if(!(((e==0)&&(num==-1)) || ((e==colArray.length-1)&&(num==1)))){
					var obj:Object=new Object();
					var obj2:Object=new Object();
					obj =  colArray[e].valueOf();
					obj2 =  colArray[e+num].valueOf();
					var x:Number=obj._x;
					obj._x=obj2._x;
					obj2._x=x;
					obj2.swapDepths(obj);
					colArray[e]=null;
					colArray[e+num]=null;
					colArray[e]=obj2;
					colArray[e+num]=obj;
					e=colArray.length+1;
				}
			}
		}
	}
	/*
	
	function onPress(){
		if (this.hitTest(_root._xmouse, _root._ymouse,true)) { //this
		//if(!this.isTweening()){
			this.swapDepths(_parent.getNextHighestDepth()-1);
			if ((getTimer() - m_lastClick) < m_doubleClickSpeed) {
				//DBL CLICK
				this.dispatchEvent({type:"onElementDblClicked"});
			}else{
				//CLICK
				this.dispatchEvent({type:"onElementClicked"});
				this.onMouseMove = function(){
					this.dispatchEvent({type:"onElementMoved"});
					updateAfterEvent();
				}
			}
			m_lastClick = getTimer();
		}
	};
	
	function onRelease(){
		delete this.onMouseMove;
		this.dispatchEvent({type:"onElementReleased"});
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