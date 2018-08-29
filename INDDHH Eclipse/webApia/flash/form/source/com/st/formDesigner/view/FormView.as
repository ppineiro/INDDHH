

import mx.managers.PopUpManager;
import mx.containers.Window;
import mx.controls.Alert;

import com.st.util.WindowManager;

import com.st.formDesigner.controller.FormController;
import com.st.formDesigner.model.FormModel;


class com.st.formDesigner.view.FormView{
	
	private var __controller:FormController;
	private var __model:FormModel;
	
	private var __mainMc:MovieClip; //ref to root
	private var __scrollPane:MovieClip;
	private var __grid:MovieClip;
	private var __frmArea:MovieClip;
	private var __ctrlPoints:MovieClip;
	
	private var __PrpBar:MovieClip;
	private var __ToolBar:MovieClip;
	
	private var GRID_CELL_WIDTH:Number = 180;
	private var GRID_CELL_HEIGHT:Number = 30;
	private var GRID_COLS:Number = 4;
	private var GRID_ROWS:Number = 50;
	private var GRID_LINE_THICKNESS:Number = 1;
	private var GRID_LINE_COLOR:String = "DFDFDF";
	
	private var EL_COLOR:String = "0xDDDDDD";
	private var EL_COLOR_SEL:String = "0xB4E0F3";
	
	private var objsInGrid_array:Array; 	//Elements Pos in Grid
	private var collisionGrid_array:Array; 	//cells in Grid
	
	private var bg_doubleClickSpeed:Number = 300;
	private var bg_lastClick:Number;
	
	private var prevPos:Object;				//element previous position x,y
	private var selectedElement:MovieClip = null;
	private var controlPointsOn:Boolean = false;
	
	private var mouseListener:Object;
	private var stageListener:Object;
	private var toolTip:com.st.formDesigner.view.ToolTipClass;
	var t;
	
	function FormView(mainMc:MovieClip, controller:FormController, model:FormModel) {
		__controller = controller;
		__model = model;
		__model.addListener(this);
		__mainMc = mainMc;

		toolTip = new com.st.formDesigner.view.ToolTipClass(_root);
		prevPos = new Object();
		
		objsInGrid_array = new Array(GRID_COLS);
		collisionGrid_array = new Array(GRID_COLS);
		initUI();
	};
	
	//Event fires when the model has been reset
	public function onReset():Void {
		__controller.getFormDefinition(); //get form XML
	};
	
	private function initUI():Void{
		var tmp = this;
		//INIT SCROLL CONTAINER IN ROOT
		__mainMc.createClassObject(mx.containers.ScrollPane,"scrollPane",3);
		//this.scrollPane.setStyle("background",0xDFDFDF);
		//this.scrollPane.setStyle("borderStyle", "none");
		
		//__mainMc.scrollPane._visible = false;
		__mainMc.scrollPane._x = 12;
		__mainMc.scrollPane._y = 46;
		__mainMc.scrollPane.setSize(746,280);
		__mainMc.scrollPane.hScrollPolicy = "off";
		__mainMc.scrollPane.vPageScrollSize = 40;
		__mainMc.scrollPane.vLineScrollSize = 40;
		// ----- INIT CONTAINER
		__mainMc.scrollPane.contentPath = "Grid"; 
		
		__scrollPane = __mainMc.scrollPane;
		
		//FORM BG
		var frm = __scrollPane.content.attachMovie("frm_bg","frm",0);
			frm._width = GRID_CELL_WIDTH * GRID_COLS;
			frm._height = GRID_CELL_HEIGHT * GRID_ROWS;
			frm.useHandCursor = false;
			frm.onPress = function(){
				if ((getTimer() - tmp.bg_lastClick) < tmp.bg_doubleClickSpeed) {
					tmp.onFormDblClicked(this);
				}else{
					if(_global.isLoaded==true){
					tmp.onFormDblClicked(this);
					tmp.onFormClicked(this);
					}
				}
				tmp.bg_lastClick = getTimer();
			};
		
		
		//INIT ELEMENT AREA & GRID
		__grid = __scrollPane.content.createEmptyMovieClip("grid_mc",1);
		__frmArea = __scrollPane.content.createEmptyMovieClip("eleArea_mc",2);
		__ctrlPoints = __scrollPane.content.createEmptyMovieClip("control_mc",3);
		
		
		//INIT TOOLBARS
		initToolsUI();
		//-------------------------------------------------------------
		//----------------------------------------------
		//LOAD EntityBind MODAL SWF
		//----------------------------------------------
		var bndLoadListener:Object = new Object();
			bndLoadListener.onLoadStart = function(target_mc:MovieClip) {trace("LOADING ATT MODAL")}
			bndLoadListener.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
				trace("LOADING ENTITY BIND:" + loadedBytes)
			}
			bndLoadListener.onLoadComplete = function(target_mc:MovieClip) {}
			bndLoadListener.onLoadInit = function(target_mc:MovieClip) {
				target_mc.init(tmp.__controller,tmp.__model);
			}
	
		var bnd_loader:MovieClipLoader = new MovieClipLoader();
			bnd_loader.addListener(bndLoadListener);
			bnd_loader.loadClip(_global.SWF_OBJ_PATH + "EntityBindings.swf", 12);	

		//-------------------------------------------------------------
		//-------------------------------------------------------------
		//LOAD ATT MODAL SWF
		//-------------------------------------------------------------
		var attLoadListener:Object = new Object();
			attLoadListener.onLoadStart = function(target_mc:MovieClip) {trace("LOADING ATT MODAL")}
			attLoadListener.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
				trace("LOADING ATT MODAL:" + loadedBytes)
			}
			attLoadListener.onLoadComplete = function(target_mc:MovieClip) {}
			attLoadListener.onLoadInit = function(target_mc:MovieClip) {
				target_mc.init(tmp.__controller,tmp.__model);
			}
	
		var att_loader:MovieClipLoader = new MovieClipLoader();
			att_loader.addListener(attLoadListener);
			att_loader.loadClip(_global.SWF_OBJ_PATH + "AttributesDialog.swf", 6);
		//------------------------------------------------
		//--------------------------------------------------------------
		//----------------------------------------------
		//LOAD EVT SWF
		//----------------------------------------------
		var evtLoadListener:Object = new Object();
			evtLoadListener.onLoadStart = function(target_mc:MovieClip) {trace("LOADING EVT MODAL")}
			evtLoadListener.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
				trace("LOADING EVT MODAL:" + loadedBytes)
			}
			evtLoadListener.onLoadComplete = function(target_mc:MovieClip) {}
			evtLoadListener.onLoadInit = function(target_mc:MovieClip) {
				target_mc.init(tmp.__controller,tmp.__model);
			}
	
		var evt_loader:MovieClipLoader = new MovieClipLoader();
			evt_loader.addListener(evtLoadListener);
			evt_loader.loadClip(_global.SWF_OBJ_PATH + "EvtDialog.swf", 4);
		//----------------------------------------------------------------------
		makeGrid();
	};
	
	private function initToolsUI():Void{
		var tmp = this;
		//----------------------------------------------
		//LOAD PROP SWF
		//----------------------------------------------
		var myListener:Object = new Object();
			myListener.onLoadStart = function(target_mc:MovieClip) {}
			myListener.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
			}
			myListener.onLoadComplete = function(target_mc:MovieClip) {
			}
			myListener.onLoadInit = function(target_mc:MovieClip) {
				target_mc.init(tmp.__controller,tmp.__model);
				tmp.__PrpBar = target_mc;
			}
		
		var my_mcl:MovieClipLoader = new MovieClipLoader();
			my_mcl.addListener(myListener);
		
		//__PrpBar = __mainMc.createEmptyMovieClip("__PrpBar", __mainMc.getNextHighestDepth());
		//my_mcl.loadClip(_global.PROPBAR , __PrpBar);
		my_mcl.loadClip(_global.PROPBAR , 3);
		
		//----------------------------------------------
		//ATTACH BUTTON SWF
		//----------------------------------------------
		if(_global.isFormView!=true){
			__ToolBar = __mainMc.attachMovie("ToolBar","__ToolBar",600,{_x:200,_y:22});
			__ToolBar.addEventListener("onNewElementDropped",this);
		}
	};
	
	
	/////////////////////////////////////////////////////////////////////
	// GRID FUNCTIONS
	/////////////////////////////////////////////////////////////////////
	private function makeGrid():Void{
		var lineSize = GRID_LINE_THICKNESS;
		var size = GRID_CELL_WIDTH;
		var sizeH = GRID_CELL_HEIGHT;
		var rgb:String = GRID_LINE_COLOR;
		
		var w = size*GRID_COLS; 
		var h = sizeH*GRID_ROWS; 
		
		var tmp = this;
		
		with (__grid) { 
			lineStyle(lineSize,"0x"+rgb,100); 
			var i = Math.round(w/size); 
			//SET COLUMNS [GRID_COLS] 4
			while (i--) {
				var v = i*size; 
				moveTo(v,0); 
				lineTo(v,h); 
				//----------------grid array
				tmp.objsInGrid_array[i] = new Array(tmp.GRID_ROWS);
				tmp.collisionGrid_array[i] = new Array(tmp.GRID_ROWS);
				//---------------
			} 
			var i = Math.round(h/sizeH); 
			//SET ROWS [GRID_ROWS] 14
			while (i--) { 
				var v = i*sizeH; 
				moveTo(0,v); 
				lineTo(w,v); 
				//----------------grid array
				for(var d=0;d<4;d++){
					tmp.objsInGrid_array[d][i] = 0;
					tmp.collisionGrid_array[d][i] = 0;
				}
				//-----------------------------
			} 
			moveTo(0,h); 
			lineTo(w,h); 
			lineTo(w,0); 
		}
		
	}; 
	
	
	function isGridCellCollision(p_obj:MovieClip):Boolean{
		var el_xPos = getGridX(p_obj);
		var el_yPos = getGridY(p_obj);
		
		var rowSpan = __model.getElementRowSpan(p_obj.fieldId);
		var colSpan = __model.getElementColSpan(p_obj.fieldId);
		
		if(checkGridCollision(el_xPos,el_yPos,rowSpan,colSpan)){
			return true;
		}else{
			return false;
		}
		
	};
	
	private function checkGridCollision(p_gridX:Number,p_gridY:Number,p_rows:Number,p_cols:Number):Boolean{
		//check obj is in same x,y
		if(p_gridX >= GRID_COLS || p_gridY >= GRID_ROWS || p_gridX < 0 || p_gridY < 0){
			return true;
		}
		//check if overlapping row or col spans - iterates collisionGrid_array
		for (var x = p_gridX; x < p_gridX + p_cols; x++){
			for(var y = p_gridY; y < p_gridY + p_rows; y++){
				if(collisionGrid_array[x][y] == 1){
					return true;
				}
			}
		}
		return false;
	};
	
	
	/////////////////////////////////////////////////////////////////////
	// MC POSITION IN GRID FUNCTIONS
	/////////////////////////////////////////////////////////////////////
	function setInitialPosInGrid(p_el:MovieClip,p_posX:Number,p_posY:Number,colSpan:Number,rowSpan:Number){
		var el_width:Number = (GRID_CELL_WIDTH*colSpan); 
		var el_height:Number= (GRID_CELL_HEIGHT*rowSpan);
		
		var posX = (p_posX * GRID_CELL_WIDTH);
		var posY = (p_posY * GRID_CELL_HEIGHT);
		
		p_el._x = posX;
		p_el._y = posY;
		
		updateObjInGridArray(p_el,p_posX,p_posY);
		setObjCellsFlag(p_el,true);
	};
	
	function snapToGrid(p_el:MovieClip){
		var xSpan:Number;
		var ySpan:Number;
		
		var colSpan = __model.getElementColSpan(p_el.fieldId);
		
		xSpan = GRID_CELL_WIDTH*colSpan;
		ySpan = GRID_CELL_HEIGHT;
		
		var xgridRef = p_el._getElementWidth();
		var ygridRef = p_el._getElementHeight();
		
		var snapX = Math.round((p_el._x+xgridRef)/xSpan)*xSpan-xgridRef;
		var snapY = Math.round((p_el._y+ygridRef)/ySpan)*ySpan-ygridRef;
		
		p_el._x = snapX;
		p_el._y = snapY;
	}; 
	
	
	public function setObjCellsFlag(p_obj:MovieClip,p_flag:Boolean):Void{
		//p_flag true=1/used cell - false=0/not used [after moved]
		
		var cellState:Number;
		if(p_flag){cellState=1}else{cellState=0}
		
		var currentXGridPos:Number = getGridX(p_obj);
		var currentYGridPos:Number = getGridY(p_obj);
	
		//trace("CURRENT Y POS ----> " + currentYGridPos)
		//trace("CURRENT X POS ----> " + currentXGridPos)
		
		var rowSpan:Number = __model.getElementRowSpan(p_obj.fieldId);
		var colSpan:Number = __model.getElementColSpan(p_obj.fieldId);
		//////////////////////////////////////
		//UPDATE NEW USED CELLS
		//topLeft cell [main cell]
		collisionGrid_array[currentXGridPos][currentYGridPos] = cellState;
		//extra cells
		for (var x = currentXGridPos; x < (currentXGridPos + colSpan); x++){
			for (var y = currentYGridPos; y < (currentYGridPos + rowSpan); y++){
				collisionGrid_array[x][y] = cellState; //set cell to used
			}
		}
	};
	
	private function getGridX(p_el:MovieClip):Number{
		//returns grid x coordinate based on current _x pos
		var xGridPos:Number = (p_el._x) / GRID_CELL_WIDTH;
		return xGridPos;
	};
	
	private function getGridY(p_el:MovieClip):Number{
		//returns grid y coordinate based on current _y pos
		var yGridPos:Number = p_el._y / GRID_CELL_HEIGHT;
		return yGridPos;
	};
	
	function getGridY_fromGlobal(p_el:MovieClip):Number{
		//returns grid y coordinate based on current GLOBAL x & y pos
		var pt = new Object();        		
			pt.x = p_el._x;	
			pt.y = p_el._y;
		__frmArea.globalToLocal(pt); //when called from outside mc
		
		var ygridRef = p_el._height/2;
		var yGridPos = Math.floor((pt.y - ygridRef) / GRID_CELL_HEIGHT);
		return yGridPos;
	};
	
	function updateObjPos(p_obj:MovieClip){
		var currentXGridPos:Number = getGridX(p_obj);
		var currentYGridPos:Number = getGridY(p_obj);
		
		updateObjInGridArray(p_obj,currentXGridPos,currentYGridPos);
		setObjCellsFlag(p_obj,true);
	
	};
	
	function deleteObjPosFromGrids(p_obj:MovieClip){
		var currentXGridPos = getGridX(p_obj);
		var currentYGridPos = getGridY(p_obj);
		removeObjFromGrid(p_obj);
		setObjCellsFlag(p_obj,false);
	};
	////////////////////////////////////////////////////////
 	// 	objsInGrid_array ARRAY FUNCTIONS
 	//	keeps track of obj grid positioning
 	//////////////////////////////////////////////////////////
	function updateObjInGridArray(p_obj:MovieClip,p_gridX:Number,p_gridY:Number){
		//updates array with p_obj new pos in grid
		//trace("grid_X:" + p_gridX + " grid_Y:" + p_gridY);
		
		//REMOVE old pos
		removeObjFromGrid(p_obj);
		//SET new pos
		objsInGrid_array[p_gridX][p_gridY] = p_obj;
		
		__model.setElementPosInGrid(p_obj.fieldId,p_gridX,p_gridY);
	};
	
	function removeObjFromGrid(p_obj:MovieClip){
		//REMOVE old pos
		for (var x=0; x < GRID_COLS; x++){
			for (var y=0; y < GRID_ROWS; y++){
				if(objsInGrid_array[x][y]==p_obj){
					objsInGrid_array[x][y] = 0; //remove ref.
					trace(objsInGrid_array[x][y]);
				}
			}
		}
	};
	
	
	/////////////////////////////////////////////////////////////////////
	// ELEMENT FUNCTIONS
	/////////////////////////////////////////////////////////////////////
	public function onFormElementAdded(fieldId:Number):Void{
		var nextDepth = __frmArea.getNextHighestDepth();
		var tmp = this;
		var rowSpan = __model.getElementRowSpan(fieldId);
		var colSpan = __model.getElementColSpan(fieldId);
		var gridPosX = __model.getElementGridX(fieldId);
		var gridPosY = __model.getElementGridY(fieldId);
		var elType = __model.getElementType(fieldId);
		
		//CHECK FOR OVERLAPPING when creating element
		if(!checkGridCollision(gridPosX,gridPosY,rowSpan,colSpan)){
			var tmpMc = __frmArea.attachMovie("Element","Form_El_" + fieldId, nextDepth,{
							fieldId:fieldId
						});
				tmpMc.addEventListener("onElementGotBind",this);									
				tmpMc.addEventListener("onElementClicked",this);
				tmpMc.addEventListener("onElementDblClicked",this);
				tmpMc.addEventListener("onElementMoved",this);
				tmpMc.addEventListener("onElementReleased",this);
				tmpMc.addEventListener("onElementRollOver",this);
				tmpMc.addEventListener("onElementRollOut",this);
				tmpMc.addEventListener("showBinded",this);
			
			
			//col & row span background
			tmpMc.box_mc._xscale = colSpan*100;
			tmpMc.box_mc._yscale = rowSpan*100;
			//setup mask
			var box_mask = tmpMc.attachMovie("box","box_mask", 2);
				box_mask._xscale = (colSpan*100);
				box_mask._yscale = (rowSpan*100);
			tmpMc.setMask(box_mask);
			
			attachFrmObj(tmpMc,fieldId,elType);
			setInitialPosInGrid(tmpMc,gridPosX,gridPosY,colSpan,rowSpan);
			
		}else{
			trace(elType + " ELEMENT " + fieldId +  " OVERLAPPING");
		}
		__model.hasEntityBindings(fieldId);
		
	};
	
	public function onFormInputElementAdded(fieldId:Number):Void{
		var nextDepth = __frmArea.getNextHighestDepth();
		var tmp = this;
		var rowSpan = __model.getElementRowSpan(fieldId);
		var colSpan = __model.getElementColSpan(fieldId);
		var gridPosX = __model.getElementGridX(fieldId);
		var gridPosY = __model.getElementGridY(fieldId);
		var elType = __model.getElementType(fieldId);
		
		//CHECK FOR OVERLAPPING when creating element
		if(!checkGridCollision(gridPosX,gridPosY,rowSpan,colSpan)){
			var tmpMc = __frmArea.attachMovie("Element","Form_El_" + fieldId, nextDepth,{
							fieldId:fieldId
						});
				tmpMc.addEventListener("onElementGotBind",this);
				tmpMc.addEventListener("onElementClicked",this);
				tmpMc.addEventListener("onElementDblClicked",this);
				tmpMc.addEventListener("onElementMoved",this);
				tmpMc.addEventListener("onElementReleased",this);
				tmpMc.addEventListener("onElementRollOver",this);
				tmpMc.addEventListener("onElementRollOut",this);
				tmpMc.addEventListener("showBinded",this);
			
			
			//col & row span background
			tmpMc.box_mc._xscale = colSpan*100;
			tmpMc.box_mc._yscale = rowSpan*100;
			//setup mask
			var box_mask = tmpMc.attachMovie("box","box_mask", 2);
				box_mask._xscale = (colSpan*100);
				box_mask._yscale = (rowSpan*100);
			tmpMc.setMask(box_mask);
			
			attachFrmObj(tmpMc,fieldId,elType);
			setInitialPosInGrid(tmpMc,gridPosX,gridPosY,colSpan,rowSpan);
			
		}else{
			trace(elType + " ELEMENT " + fieldId +  " OVERLAPPING");
		}
		__model.hasEntityBindings(fieldId);
	};
	
	public function onFormGridElementAdded(fieldId:Number):Void{
		trace("element added");
		//onFormElementAdded(fieldId)
		var nextDepth = __frmArea.getNextHighestDepth();
		var tmp = this;
		var rowSpan = __model.getElementRowSpan(fieldId);
		var colSpan = __model.getElementColSpan(fieldId);
		var gridPosX = __model.getElementGridX(fieldId);
		var gridPosY = __model.getElementGridY(fieldId);
		var elType = __model.getElementType(fieldId);
		
		var child_arr:Array = __model.getGridElementChildrenArray(fieldId);
		//trace("GRID ADDED CHILDREN ARRA==" + child_arr.toString() + "\n\n")
		//CHECK FOR OVERLAPPING when creating element
		if(!checkGridCollision(gridPosX,gridPosY,rowSpan,colSpan)){
			var tmpMc = __frmArea.attachMovie("Element_grid","Form_El_" + fieldId, nextDepth,{
							fieldId:fieldId,
							rowSpan:rowSpan,
							colSpan:colSpan,
							child_arr:child_arr
						});
				tmpMc.addEventListener("onElementClicked",this);
				tmpMc.addEventListener("onElementDblClicked",this);
				tmpMc.addEventListener("onElementMoved",this);
				tmpMc.addEventListener("onElementReleased",this);
				//tmpMc.addEventListener("onElementRollOver",this);
				//tmpMc.addEventListener("onElementRollOut",this);
				tmpMc.addEventListener("onColMove",this);
				tmpMc.addEventListener("onColRollOver",this);
				tmpMc.addEventListener("onColRollOut",this)				
				tmpMc.addEventListener("onColClicked",this);
				tmpMc.addEventListener("onColDblClicked",this);
			
			setInitialPosInGrid(tmpMc,gridPosX,gridPosY,colSpan,rowSpan);
			//-----------------------------------------------------
			
		}else{
			(elType + " ELEMENT " + fieldId +  " OVERLAPPING");
		}
	};
	
	public function onColAddedToGrid(gridFieldId:Number,fieldType:Number,fieldId:Number){
		var gridElement:MovieClip = __frmArea["Form_El_" + gridFieldId];
		gridElement.createNewCol(fieldType,fieldId);
	};
	
	private function onColTypeChanged(gridId,gridFieldId,newType){
		var gridElement:MovieClip = __frmArea["Form_El_" + gridId];
		gridElement.changeColType(gridFieldId,newType);
	}
	
	private function attachFrmObj(tmpMc:MovieClip,fieldId:Number,elType:Number):Void{
		var w = tmpMc._width;
		var h = tmpMc._height;
		
		switch(elType){
			case 1: //INPUT
				var z = tmpMc.createClassObject(mx.controls.TextInput,"_el",1);
					z.setSize(170,20);
					z._x = 180; 
					z._y = Math.round((h/2) - (z.height/2));
					z.text = "abc";
					setElementLabel(tmpMc,__model.getElementLabel(fieldId));
				
			break;
			
			case 2: //COMBOBOX
				var z = tmpMc.createClassObject(mx.controls.ComboBox,"_el",1);
					z.setSize(170,20);
					z._x = 180;
					z._y = Math.round((h/2) - (z.height/2));
					setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 3: //CHECKBOX
				var z = tmpMc.createClassObject(mx.controls.CheckBox,"_el",1);
					z._x = 180;
					z._y = 10;
					setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 4: //RADIO
				var z = tmpMc.createClassObject(mx.controls.RadioButton,"_el",1);
					z._x = 180;
					z._y = 10;
					setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 5: //BUTTON
				var z = tmpMc.createClassObject(mx.controls.Button,"_el",1);
					z._x = Math.round((w/2) - (z.width/2));
					z._y = Math.round((h/2) - (z.height/2));
					z.label = __model.getElementLabel(fieldId);
			break;
			
			case 6: //TEXTAREA
				var z = tmpMc.createClassObject(mx.controls.TextArea,"_el",1);
					z.setSize(170,60);
					z._x = 180; 
					z._y = Math.round((h/2) - (z.height/2));
					setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 7: //LABEL
				setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 8: //SUBTITLE
				setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 9: //FILE
				var z = tmpMc.createClassObject(mx.controls.TextInput,"_el",1);
					z.setSize(120,20);
					z._x = 180; 
					z._y = Math.round((h/2) - (z.height/2));
					z.text = "abc";
					
				var b = tmpMc.createClassObject(mx.controls.Button,"_el",2);
					b.setSize(30,20);
					b._x = 320;
					b._y = Math.round((h/2) - (b.height/2));
					b.label = "...";
					
				setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 10: //LISTBOX
				var z = tmpMc.createClassObject(mx.controls.List,"_el",1);
					z.setSize(170,60);
					z._x = 180;
					z._y = Math.round((h/2) - (z.height/2));
					z.setStyle("alternatingRowColors",[0xFFFFFF,0xEFEFEF]);
					
					setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 11: //HIDDEN
				var z = tmpMc.createClassObject(mx.controls.TextInput,"_el",1);
					z.setSize(170,20);
					z._x = 180; 
					z._y = Math.round((h/2) - (z.height/2));
					z.text = "abc";
					z._alpha=35;
					z.brightnessTo(70)
					setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 12://PASSWORD
				var z = tmpMc.createClassObject(mx.controls.TextInput,"_el",1);
					z.setSize(170,20);
					z._x = 180; 
					z._y = Math.round((h/2) - (z.height/2));
					z.text = "*******";
					setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
			
			case 13://IMAGE
				trace("ADD IMG")
			break;
			case 14://GRID
				trace("ADD GRID")
			break;
			case 15://HREF
				setElementLabel(tmpMc,__model.getElementLabel(fieldId));
				trace("ADD HREF")
			break;
			case 16://TEXTFORMAT
				var z = tmpMc.createClassObject(mx.controls.TextArea,"_el",1);
				tmpMc.attachMovie("controlsImg","controlsImg",9,{_x:190,_y:5});
				z.setSize(510,80);
				z._x = 180; 
				z._y = Math.round((h/2) - (z.height/2))+20;
				setElementLabel(tmpMc,__model.getElementLabel(fieldId));
			break;
		}
	};
	
	public function setElementLabel(targetMc:MovieClip,txtVal:String):Void{
		var w:Number = 170;//(Math.round(targetMc._width/170))*170;
		var h:Number = targetMc._height;
		var y:Number = Math.round((h/2) - (8));
		var x:Number = 6;
		targetMc.createTextField("ico_txt",5,x,y,w,20);
		targetMc["ico_txt"].type = "dynamic";
		//this["ico_txt"].embedFonts = true;
		targetMc["ico_txt"].text = txtVal;
		targetMc["ico_txt"].multiline = true;
		targetMc["ico_txt"].wordWrap = true;
		/*
		targetMc["ico_txt"].border = true;
		targetMc["ico_txt"].borderColor = "0xCCCCCC";
		*/
		/////////////
		//comment autosize to make it autosize in height
		targetMc["ico_txt"].autoSize = "center";
		targetMc["ico_txt"]._xscale(targetMc._width);
		/////////////
		var myformat = new TextFormat();
			myformat.font = "Verdana";
			myformat.color = "0x000000";
			myformat.size = 9;
			//myformat.align = "center" ;
		targetMc["ico_txt"].setTextFormat(myformat);
	};
	
	////////////////////////////////////////////////////////////////
	//	FORM events
	///////////////////////////////////////////////////////////////
	function onFormClicked(p_obj:MovieClip){
		deselectObj(selectedElement);
		__PrpBar.showProps(null,0)
	};
	
	function onFormDblClicked(p_obj:MovieClip){
		var el:MovieClip = p_obj;
		var tmp = this;
		var s_evt = _global.labelVars.lbl_frmEvents.toUpperCase();
		var s_init = _global.labelVars.lbl_frmInit.toUpperCase();
		if(el.menu == undefined) {
			//Create a Menu instance and add some items
			el.menu = mx.controls.Menu.createMenu();
			el.menu.embedFonts = true;
			el.menu.setStyle("fontFamily","k0554");
			el.menu.setStyle("fontSize","8");
			el.menu.setStyle("rollOverColor","0xEFEFEF");
			el.menu.setStyle("selectionColor","0xEFEFEF");
			//Add items
			el.menu.addMenuItem(s_evt);
			el.menu.addMenuItem(s_init);
			//Add a change-listener to catch item selections
			var changeListener = new Object();
			changeListener.change = function(event) {
				var item = event.menuItem;
				if(item.attributes.label == s_evt){
					//FRM EVENTS
					_level4.showEvtFormDialog(0,false);
				}
				if(item.attributes.label == s_init){
					//FRM INIT
					var myClickHandler:Function = function (evt_obj:Object) {
						if (evt_obj.detail == Alert.OK) {
							tmp.__model.initModel();
						}
					}
					var dialog_obj:Object = Alert.show( _global.labelVars.lbl_frmInitQ,_global.labelVars.lbl_frmInitTit, Alert.OK | Alert.CANCEL, null, myClickHandler, "testIcon", Alert.OK);
				}
			}
			el.menu.addEventListener("change", changeListener);
		}
		
		var theMenuX = Math.floor(_root._xmouse);
		var theMenuY = Math.floor(_root._ymouse )+ 0.5; //fontF
		if(_global.isFormView!=true){
			el.menu.show(theMenuX,theMenuY);
		}
	};
	
	////////////////////////////////////////////////////////////////
	//	ELEMENT events
	///////////////////////////////////////////////////////////////
	function onElementGotBind(fieldId,aux){
		var obj = __frmArea["Form_El_" + fieldId];
		obj.setHasBind(aux);
		}
	
	function onElementClicked(p_eventObj){
		//hideToolTip();
		var el = p_eventObj.target;
			el._alpha = 40;
		
		trace("ELEMENT CLICKED: " + el.fieldId);
		selectObj(el);
		
		//store current pos
		prevPos.x = el._x;
		prevPos.y = el._y;
		
		//create dummy mc
		//createDummyInPlace(el);
		
		//remove ref. to obj cells in span grid
		setObjCellsFlag(el,false);
		
	};

	function showBinded(id:Number,aux:Boolean){
		var bnd:Array=__model.getEntityBinds(id);
		var lista=bnd[0].mapping;
		var elements=__model.getAllElements();
		for(var a=0;a<lista.length;a++){
			var frm_att=lista[a].frm_att;
				for(var b in elements){
					if(elements[b].attId==frm_att){
						var fieldId=elements[b].fieldId;
						var obj = __frmArea["Form_El_" + fieldId];
						obj.showBinded(aux);
					}
				}
			}
		}
	function onElementRollOver(p_eventObj){
		var el = p_eventObj.target;
		var fieldId=el.fieldId;
		var elements=__model.getAllElements();
		var id:Number=0;
		var nom:String;
		showBinded(fieldId,true);
		for(var i in elements){
			if(elements[i].fieldId==fieldId){
					nom=elements[i].attName;
			}
		}
		if(!(nom=="undefined"||nom=="" ||nom==undefined || nom=="Untitled")){
			this.showToolTip(nom);
			}
		}

	function onElementRollOut(p_eventObj){
		var el = p_eventObj.target;
		var fieldId=el.fieldId;
		showBinded(fieldId,false);
		t=p_eventObj;
		this.hideToolTip()
		}

	function showToolTip(p_txt:String){
		toolTip.setText(p_txt + " ");
	};
	
	function hideToolTip(){
		toolTip.clearText();
	};
	
	function onElementMoved(p_eventObj){
		var el:MovieClip = p_eventObj.target;
		//trace("ELEMENT WIDTH::" + el._width)
		//trace("ELEMENT box_mc WIDTH::" + el.box_mc._width)
		
		var elCenterX:Number = el._getElementWidth()/2;
		var elCenterY:Number = el._getElementHeight()/2;
		
		if(controlPointsOn == true){
			removeControlPoints(el);
		}
		
		var colSpan = __model.getElementColSpan(el.fieldId);
		
		//MOVE Element & check BOunds
		if(colSpan >= 3){ 		//If element COLSPAN >= 3 dont move X
			el._y = __frmArea._ymouse - elCenterY;
		}else{
			el._x = __frmArea._xmouse - elCenterX;
			el._y = __frmArea._ymouse - elCenterY;
		}
		
		//SNAP element TO GRID
		snapToGrid(el);
		
		//set vertical SCROLL PANE position
		var pt = new Object();        		
			pt.x = el._x;	
			pt.y = el._y;
		__scrollPane.localToGlobal(pt); 
		
		//trace("POS=" + pt.y)
		//trace("POS GRID BOTTOM=" + (this._parent._x + this._parent._height))
		/*
		if((pt.y+20) >= Math.floor(this._parent._height)){
			trace("1")
			this._parent.vPosition += 10;
		}
		if((pt.y-20) <= Math.floor(this._parent._x + 30)){
			this._parent.vPosition -= 10;
		}*/
	
	};
	
	
	function onElementReleased(p_eventObj){
		var thisClip = this;
		var el = p_eventObj.target;
		trace("****X=" + el._x + " : " +  prevPos.x);
		//trace("Y=" + el._y + " : " +  prevPos.y);
		if(el._x == prevPos.x & el._y == prevPos.y){
			//same position as previous.
			//removeDummy();
			el._alpha = 100;
			el._x = prevPos.x;
			el._y = prevPos.y;
			updateObjPos(el);
			addControlPoints(el);
		}else{
			//different pos --> check for collision
			var posClear:Boolean = isGridCellCollision(el);
			//trace("CELL COLLISION:" + posClear);
			if(!posClear){//collision == False [set new pos]
				el._alpha = 100;
				//removeDummy();
				updateObjPos(el);
				addControlPoints(el);
			}else{//collision == True [move to previous pos]
				//trace("collision == True [move to previous pos]")
				var objTween = new Object();
				objTween.onTweenEnd = function(){
					el.removeListener(objTween);
					//thisClip.removeDummy();
					el._alpha = 100;
					//make sure its in the right pos.
					el._x = prevPos._x;
					el._y = prevPos._y;
					//update pos in grid array
					thisClip.updateObjPos(el);
					thisClip.addControlPoints(el);
					//trace("END Tween:" + el.fieldLabel)
				}
				objTween.onTweenStart = function(){
					//trace("START Tween:" + el.fieldLabel)
				}
				el.stopTween();
				el.addListener(objTween);
				el.slideTo(prevPos.x,prevPos.y,0.3,"easeOut");
			}
		}
	};
	function onColRollOver(p_eventObj){
		var gridFieldId = p_eventObj.target.fieldId;
		var fieldId = p_eventObj.fieldId;
		var elements:Array=__model.getGridElementChildrenArray(gridFieldId);
		var nom:String;
		for(var i=0;i<elements.length;i++){
			if(elements[i].fieldId==fieldId){
					nom=elements[i].attName;
			}
		}
		if(!(nom=="undefined"||nom=="" ||nom==undefined || nom=="Untitled")){
			this.showToolTip(nom);
			}
	};	
	function onColRollOut(p_eventObj){
		var el = p_eventObj.target;
		var fieldId=el.fieldId;
		t=p_eventObj;
		this.hideToolTip()
		}

	function onColClicked(p_eventObj){
		var p_obj = p_eventObj.target;
		var gridFieldId = p_eventObj.target.fieldId;
		selectObj(p_obj);
		
		//SELECT COL pressed
		trace("COL CLICKED:" + p_eventObj.fieldId + " IN GRID:" + gridFieldId);
		
		__PrpBar.showGridColElementProps(gridFieldId,p_eventObj.fieldId,p_eventObj.fieldType);
	};
	
	function onColMove(p_eventObj){
		var p_obj = p_eventObj.target;
		var gridFieldId = p_eventObj.target.fieldId;
		var colFieldId = p_eventObj.fieldId;
		var ini=p_eventObj.iniPos;
		var end=p_eventObj.endPos;
		if(ini<end){
			for(var i=ini;i<end;i++){
				moveRight(colFieldId,gridFieldId);
			}
		}
		if(end<ini){
			for(var i=end;i<ini;i++){
				moveLeft(colFieldId,gridFieldId);
			}
		}
	}
	
	function onColDblClicked(p_eventObj){
		var tmp = this;
		var el:MovieClip = p_eventObj.target;
		var gridFieldId:Number = p_eventObj.target.fieldId;
		var colFieldId:Number = p_eventObj.fieldId;
		var type = p_eventObj.fieldType;
		
		//trace("COL DBLCLICKED:" + colFieldId)
		
		var s_att = _global.labelVars.lbl_attributes.toUpperCase();
		var s_evt = _global.labelVars.lbl_events.toUpperCase();
		var s_delItem = _global.labelVars.lbl_deleteItem.toUpperCase();
		var s_delGrid = _global.labelVars.lbl_deleteGrid.toUpperCase();
		var s_moveLeft = _global.labelVars.lbl_toLeft.toUpperCase();
		var s_moveRight = _global.labelVars.lbl_toRight.toUpperCase();
		
		//to change an element for another
		var s_input = _global.labelVars.lblToolInput;
		var s_combo = _global.labelVars.lblToolCombobox;
		var s_checkbox = _global.labelVars.lblToolCheck;
		var s_password = _global.labelVars.lblToolPass;
		var s_hidden = _global.labelVars.lblToolHidden;
		var s_changefor = _global.labelVars.lbl_changeElement;
		
		el.menu.removeAll();
		el.menu = undefined;
		
		if(el.menu == undefined) {
			//Create a Menu instance and add some items
			el.menu = mx.controls.Menu.createMenu();
			el.menu.embedFonts = true;
			el.menu.setStyle("fontFamily","k0554");
			el.menu.setStyle("fontSize","8");
			el.menu.setStyle("rollOverColor","0xEFEFEF");
			el.menu.setStyle("selectionColor","0xEFEFEF");
			//Add items
			
			if(type==7 || type==8 || type==13 || type == 14){ //image,label,subtitle
			}else{
				if(type==5){
					
				}else{
					el.menu.addMenuItem(s_att); //add att menu
				}
				if(type!=9 && type!=11 && type!=12){
					el.menu.addMenuItem(s_evt);//add evtmenu
				}
			}
			if(type!=14){				
				el.menu.addMenuItem(s_delItem);
			}
			el.menu.addMenuItem(s_moveRight);
			el.menu.addMenuItem(s_moveLeft);
			el.menu.addMenuItem(s_delGrid);
			
			if(type==1 || type==2 || type == 3 || type==11 || type==12){ //input 1 combo 2 checkbox 4 hidden 11 passwod 12
				var auxArray=[1,2,3,11,12];
				var menuItem=el.menu.addMenuItem(s_changefor);
				menuItem.addMenuItem({label:s_input});
				menuItem.addMenuItem({label:s_combo});
				menuItem.addMenuItem({label:s_checkbox});
				menuItem.addMenuItem({label:s_hidden});
				menuItem.addMenuItem({label:s_password});
				for(var i=0;i<auxArray.length;i++){
					if(type==auxArray[i]){
						var item:Object =menuItem.getMenuItemAt(i);
						item.attributes.enabled="false";
					}
				}
			}
			
			//Add a change-listener to catch item selections
			var changeListener = new Object();
				changeListener.change = function(event) {
					var item = event.menuItem;
					if(item.attributes.label == s_att){
						//atributos
						_level6.showAttDialog(colFieldId,false,gridFieldId);
					}
					if(item.attributes.label == s_evt){
						//eventos elemento
						_level4.showEventDialogForGridCol(gridFieldId,colFieldId);
					}
					if(item.attributes.label == s_delItem){
						//delete grid col element
						tmp.removeGridElement(colFieldId,gridFieldId);
					}
					if(item.attributes.label == s_delGrid){
						tmp.removeElement(el);
					}
					if(item.attributes.label == s_moveRight){
						tmp.moveRight(colFieldId,gridFieldId);
					}
					if(item.attributes.label == s_moveLeft){
						tmp.moveLeft(colFieldId,gridFieldId);
					}
					if(tmp.getTypeFromLabel(item.attributes.label)){
						tmp.__controller.changeGridElementType(el.fieldId,colFieldId,tmp.getTypeFromLabel(item.attributes.label));
					}
				}
			el.menu.addEventListener("change", changeListener);
			
		}else{	
			//MENU ALREADY CREATED //add or remove items
			//el.menu.removeAll()
		}
		
		//var theMenuX = Math.floor(el._x);
		//var theMenuY = Math.floor(el._y + 20)+ 0.5; //fontF
		var theMenuX = Math.floor(_root._xmouse);
		var theMenuY = Math.floor(_root._ymouse )+ 0.5; //fontF
		if(_global.isFormView!=true){
			el.menu.show(theMenuX,theMenuY);
		}
		
	};
	
	
	
	function onElementDblClicked(p_eventObj){
		trace("ELEMENT DOUBLE CLICKE");
		var el:MovieClip = p_eventObj.target;
		el.menu.removeAll();
		el.menu = undefined;
		var thisClip = this;
		var s_att = _global.labelVars.lbl_attributes.toUpperCase();
		var s_evt = _global.labelVars.lbl_events.toUpperCase();
		var s_bnd=_global.labelVars.lbl_binds.toUpperCase();
		var s_delItem = _global.labelVars.lbl_deleteItem.toUpperCase();
		
		//to change an element for another
		var s_input = _global.labelVars.lblToolInput;
		var s_combo = _global.labelVars.lblToolCombobox;
		var s_checkbox = _global.labelVars.lblToolCheck;
		var s_radio = _global.labelVars.lblToolRadio;
		var s_password = _global.labelVars.lblToolPass;
		var s_hidden = _global.labelVars.lblToolHidden;
		var s_changefor = _global.labelVars.lbl_changeElement;
	
		if(el.menu == undefined) {
			//Create a Menu instance and add some items
			el.menu = mx.controls.Menu.createMenu();
			el.menu.embedFonts = true;
			el.menu.setStyle("fontFamily","k0554");
			el.menu.setStyle("fontSize","8");
			el.menu.setStyle("rollOverColor","0xEFEFEF");
			el.menu.setStyle("selectionColor","0xEFEFEF");
			//Add items
			var type:Number = __model.getElementType(el.fieldId);
			
			if(type==7 || type==8 || type==13 || type == 15){ //image,label,subtitle,href,grid
			}else{
				if(type==5 || type==14){
					
				}else{
					el.menu.addMenuItem(s_att); //add att menu
				}
				if(type!=9 && type!=11 && type!=12 && type!=16){
					el.menu.addMenuItem(s_evt);//add evt menu
				}
			}
			if(type==1){
				el.menu.addMenuItem(s_bnd);
			}
			el.menu.addMenuItem(s_delItem);
			
			if((type==1 && (!__model.getEntityBinds(el.fieldId) || (__model.getEntityBinds(el.fieldId) && __model.getEntityBinds(el.fieldId).length==0) ) )||
				type==2 || type==3 || type == 4 || type==11 || type==12){ //input 1 combo 2 checkbox 3 radio 4 hidden 11 passwod 12
				var auxArray=[1,2,3,4,11,12];
				var menuItem=el.menu.addMenuItem(s_changefor);
				menuItem.addMenuItem({label:s_input});
				menuItem.addMenuItem({label:s_combo});
				menuItem.addMenuItem({label:s_checkbox});
				menuItem.addMenuItem({label:s_radio});
				menuItem.addMenuItem({label:s_hidden});
				menuItem.addMenuItem({label:s_password});
				for(var i=0;i<auxArray.length;i++){
					if(type==auxArray[i]){
						var item:Object =menuItem.getMenuItemAt(i);
						item.attributes.enabled="false";
					}
				}
			}
						
			//Add a change-listener to catch item selections
			var changeListener = new Object();
			var tmp=this;
				changeListener.change = function(event) {
					var item = event.menuItem;
					if(item.attributes.label == s_att){
						//atributos
						_level6.showAttDialog(el.fieldId,true);
					}
					if(item.attributes.label == s_evt){
						//eventos elemento
						_level4.showEvtDialog(el.fieldId,true);
					}
					if(item.attributes.label == s_delItem){
						//delete form element
						thisClip.removeElement(el);
					}
					if(item.attributes.label == s_bnd){
						//show entity bind
						_level12.showEntBindDialog(el.fieldId);
					}
					if(tmp.getTypeFromLabel(item.attributes.label)){
						tmp.__controller.changeElementType(el.fieldId,tmp.getTypeFromLabel(item.attributes.label));
					}
				}
			el.menu.addEventListener("change", changeListener);
			
		}else{	
			//MENU ALREADY CREATED //add or remove items
			//el.menu.removeAll()
		}
		
		//var theMenuX = Math.floor(el._x);
		//var theMenuY = Math.floor(el._y + 20)+ 0.5; //fontF
		var theMenuX = Math.floor(_root._xmouse);
		var theMenuY = Math.floor(_root._ymouse )+ 0.5; //fontF
		if(_global.isFormView!=true){
			el.menu.show(theMenuX,theMenuY);
		}		
	};
	
	function getTypeFromLabel(lbl){
		var arrTypes=[{label:_global.labelVars.lblToolInput,type:1},
					  	{label:_global.labelVars.lblToolCombobox,type:2},
						{label:_global.labelVars.lblToolCheck,type:3},
						{label:_global.labelVars.lblToolRadio,type:4},
						{label:_global.labelVars.lblToolPass,type:12},
						{label:_global.labelVars.lblToolHidden,type:11}];
		for(var i=0;i<arrTypes.length;i++){
			if(lbl==arrTypes[i].label){
				return arrTypes[i].type;
			}
		}
		return null;
	}
	/////////////////////////////////////////////////////////////
	// Selection
	////////////////////////////////////////////////////////////
	function selectObj(p_obj:MovieClip){
		if(selectedElement!=p_obj){
			//trace(p_obj.fieldId + " SELECTED");
			deselectObj(selectedElement);
			selectedElement = p_obj;
			//select element
			var bg_mc = p_obj.box_mc["bg_mc"];
			changeRGB(bg_mc,EL_COLOR_SEL);
			//control points for streching
			addControlPoints(p_obj);
			
			//SHOW ELEMENT PROPERTIES
			passPropsToPanel(p_obj.fieldId,p_obj.fieldType);
			
		}else{
			if(p_obj.controlPointsOn == true){
				//this.removeControlPoints(p_obj);
			}
		}
	};
	
	function deselectObj(p_obj:MovieClip){
		//trace(p_obj.fieldId + " DESELECTED");
		var bg_mc = p_obj.box_mc["bg_mc"];
		changeRGB(bg_mc,EL_COLOR);
		removeControlPoints(p_obj);
		__PrpBar.clearPropGrid();
		selectedElement = null;
	};
	
	private function changeRGB(obj:MovieClip,rgb:String){
		var bgcolor = new Color(obj);
			bgcolor.setRGB(rgb);
	};
	
	function removeElement(p_obj:MovieClip){
		//deselect & remove control points
		deselectObj(p_obj);
		//update
		__model.removeElement(p_obj.fieldId);		
	};
	
	function removeGridElement(fieldId:Number,gridId:Number){
		__model.removeGridCol(fieldId,gridId);
	};
	
	function moveRight(fieldId:Number,gridId:Number){
		__model.moveRight(fieldId,gridId);
	};
	
	function moveLeft(fieldId:Number,gridId:Number){
		__model.moveLeft(fieldId,gridId);
	};
	
	function onElementRemoved(fieldId:Number){
		var p_obj = __frmArea["Form_El_"+fieldId];
		//remove from grid & clear cells
		deleteObjPosFromGrids(p_obj);
		//delete
		p_obj.removeMovieClip();
	}
	function onColRemoved(fieldId:Number,gridId:Number){
		trace("GRID:" + gridId + " COL:" + fieldId)
		var p_grid = __frmArea["Form_El_"+gridId];
			p_grid.removeCol(fieldId);
		
	};
	function onColMoved(fieldId:Number,gridId:Number,num:Number){
		trace("GRID:" + gridId + " COL:" + fieldId+" NUM:"+num)
		var p_grid = __frmArea["Form_El_"+gridId];
		p_grid.moveCol(fieldId,num);		
	};
	/////////////////////////////////////////////////////////////
	// COLSPAN & ROWSPAN CONTROL POINTS
	////////////////////////////////////////////////////////////
	private function addControlPoints(p_obj:MovieClip):Void{
		controlPointsOn = true;
		var objType:Number = __model.getElementType(p_obj.fieldId);
		//add horizontal control
		var h_pos = p_obj._x + (p_obj._getElementWidth());
		var v_pos = p_obj._y + (p_obj._getElementHeight()/2);
		
		var minCol = __model.getDefaultElementColSpan(objType);
		var minRow = __model.getDefaultElementRowSpan(objType);
		
		var c_h = __ctrlPoints.attachMovie("ControlPoints","hcontrol",100,{
				view:this,
				formObj:p_obj,
				dir:1,
				minCol:minCol,
				minRow:minRow,
				_x:h_pos,
				_y:v_pos});
		c_h.addEventListener("onStretchMoveX",this);
		
		//add vertical control if type control needs it
		if(objType ==3 || objType ==4 || objType ==6 || objType ==7 || objType ==10 || objType ==13){
			var h_pos = p_obj._x + (p_obj._getElementWidth()/2);
			var v_pos = p_obj._y + (p_obj._getElementHeight());
			
			var c_v = __ctrlPoints.attachMovie("ControlPoints","vcontrol",101,{
					view:this,
					formObj:p_obj,
					dir:2,
					minCol:minCol,
					minRow:minRow,
					_x:h_pos,
					_y:v_pos});
			c_v.addEventListener("onStretchMoveY",this);
		}
	};
	
	private function removeControlPoints(p_obj:MovieClip):Void{
		__ctrlPoints["hcontrol"].removeMovieClip();
		__ctrlPoints["vcontrol"].removeMovieClip();
		controlPointsOn = false;
	};
	
	public function onStretchMoveX(p_eventObj:Object):Void{
		var newColSpan:Number = p_eventObj.h_cols;
		var el:MovieClip = p_eventObj.p_obj;
		
		//update colspan property
		__model.setElementColSpan(el.fieldId,newColSpan);
		
		//modify vertical control point position
		var h_pos = el._x + (el._getElementWidth()/2);
		var v_pos = el._y + (el._getElementHeight());
		
		__ctrlPoints["vcontrol"]._x = h_pos;
		__ctrlPoints["vcontrol"]._y = v_pos;
		//--
	};

	public function onStretchMoveY(p_eventObj:Object):Void{
		var newRowSpan:Number = p_eventObj.v_rows;
		var el:MovieClip = p_eventObj.p_obj;
		
		//update rowspan property
		__model.setElementRowSpan(el.fieldId,newRowSpan);
		
		//modify horizontal control point position
		var h_pos = el._x + (el._getElementWidth());
		var v_pos = el._y + (el._getElementHeight()/2);
		
		__ctrlPoints["hcontrol"]._x = h_pos;
		__ctrlPoints["hcontrol"]._y = v_pos;
	};
	
	public function onElementColSpanChanged(fieldId:Number,cols:Number):Void{
		var obj = __frmArea["Form_El_" + fieldId];
		obj["box_mc"]._xscale = cols*100;
		obj["box_mask"]._xscale = cols*100;
		var type:Number = __model.getElementType(fieldId);
		if(type!=6){
			obj["ico_txt"]._width = (Math.round(obj["box_mc"]._width/170))*170;
		}
		__frmArea["Form_El_" + fieldId]
	};
	public function onElementRowSpanChanged(fieldId:Number,rows:Number):Void{
		var obj = __frmArea["Form_El_" + fieldId];
		obj["box_mc"]._yscale = rows*100;
		obj["box_mask"]._yscale = rows*100;
	};
		
	public function onAttributeChanged(fieldId:Number,attId:Number,attName:String,attLabel:String){
		var objField:MovieClip = __frmArea["Form_El_" + fieldId];
		//var el_component:MovieClip = objField._el;
		objField["ico_txt"].text = attLabel;
		var myformat = new TextFormat();
			myformat.font = "Verdana";
			myformat.color = "0x000000";
			myformat.size = 9;
		objField["ico_txt"].setTextFormat(myformat);
	};
	public function onColAttributeChanged(gridId:Number,fieldId:Number,attId:Number,attName:String,attLabel:String){
		trace("onColAttributeChanged:" + attLabel)
		var objField:MovieClip = __frmArea["Form_El_" + gridId];
			objField.changeAttribute(fieldId,attLabel);
			var myformat = new TextFormat();
				myformat.font = "Verdana";
				myformat.color = "0x000000";
				myformat.size = 9;
			objField["ico_txt"].setTextFormat(myformat);			
	}
	/////////////////////////////////////////////
	//	functions for SNAP for Control Points
	////////////////////////////////////////////
	public function snapOnX(p_CtrlPoint:MovieClip,p_el:MovieClip):Number{
		var xSpan:Number = GRID_CELL_WIDTH;
		var xgridRef = p_el._getElementWidth();
		var snapX = Math.round((p_CtrlPoint._x+xgridRef)/xSpan)*xSpan-xgridRef;
		return snapX;
	};
	
	public function snapOnY(p_CtrlPoint:MovieClip,p_el:MovieClip):Number{
		var ySpan:Number = GRID_CELL_HEIGHT;
		var ygridRef = p_el._getElementHeight();
		var snapY = Math.round((p_CtrlPoint._y+ygridRef)/ySpan)*ySpan-ygridRef;
		return snapY;
	};
	
	function getXmax(p_obj:MovieClip){
		//iterate collisionGrid_array to find next element
		var el_xPos = getGridX(p_obj);
		var el_yPos = getGridY(p_obj);
		
		var elType = __model.getElementType(p_obj.fieldId);
		var el_colSpan = __model.getDefaultElementColSpan(elType);
		var el_rowSpan = __model.getDefaultElementRowSpan(elType);
		
		for (var x = el_xPos + el_colSpan; x < GRID_COLS; x++){
			if(x!=el_xPos){
				for(var y = el_yPos; y <  el_yPos+ el_rowSpan; y++){
					if(collisionGrid_array[x][y] == 1){
						return x;
					}
				}
			}
		}
		//all clear
		return GRID_COLS;
	};
	
	
	public function getYmax(p_obj:MovieClip){
		//iterate collisionGrid_array to find next element
		var el_xPos = getGridX(p_obj);
		var el_yPos = getGridY(p_obj);
		
		var elType = __model.getElementType(p_obj.fieldId);
		var el_colSpan = __model.getDefaultElementColSpan(elType);
		var el_rowSpan = __model.getDefaultElementRowSpan(elType);
		
		for(var y = el_yPos + el_rowSpan; y < GRID_ROWS; y++){
			if(y!=el_yPos){
				for (var x = el_xPos; x < el_xPos + el_colSpan; x++){
					if(collisionGrid_array[x][y] == 1){
						return y;
					}
				}
			}
		}
		//all clear
		return GRID_ROWS;
	};
	
	
	
	//////////////////////////////////////////////////////////////////
	// TOOLBAR
	//////////////////////////////////////////////////////////////////
	public function onNewElementDropped(p_eventObj){
		var tmpObj = new Object();
			tmpObj._x = Math.floor(_root._xmouse); //tmpObj._x = p_eventObj.obj._x;
			tmpObj._y = Math.floor(_root._ymouse); //tmpObj._y = p_eventObj.obj._y;
			tmpObj._width = p_eventObj.obj._width	//180; //depends on default cols
			tmpObj._height = p_eventObj.obj._height  //30;
		
		var dropTarget = checkDropTargetIsGrid(tmpObj,p_eventObj.el_type);

		if(dropTarget!=null){
			//////////////////////////////////////
			//ON GRID DROP
			////////////////////////////////////////
			trace("onNewElementDropped ONGRID:" + dropTarget.fieldId);
			__controller.addColToGrid(dropTarget.fieldId,p_eventObj.el_type);
			
		}else{
			///////////////////////////////////////////
			//NORMAL ELEMENT DROP
			///////////////////////////////////////////
			var x = Math.floor(getGridX(tmpObj));
			var y = Math.floor(getGridY_fromGlobal(tmpObj));
			
			//if(type != button and type != label) and (colposition == 1 or colposition == 3) 
			if((p_eventObj.el_type != 7 && p_eventObj.el_type != 5) && (x == 1 || x == 3)){
				x = x-1;
			}
			//if type == subtitle & colpos == 1,2,3) pos == 0
			if((p_eventObj.el_type==8 || p_eventObj.el_type==14 || p_eventObj.el_type==16) && (x == 1 || x == 2 || x == 3)){
				x = 0;
			}
			
			//trace("X" + " : " + x + "  Y" + " : " + y)
			var el_colSpan = __model.getDefaultElementColSpan(p_eventObj.el_type);
			var el_rowSpan = __model.getDefaultElementRowSpan(p_eventObj.el_type);
			
			if(!checkGridCollision(x,y,el_rowSpan,el_colSpan)){
				if(	p_eventObj.el_type == 14){
					//ADD GRID
					trace("ADD NEW GRID ELEMENT")
					__controller.addFormGridElement(null,
							   _global.labelVars.lbl_untitledElement,
								p_eventObj.el_type,
							   null,
							  _global.labelVars.lbl_untitledElement,
							   x,
							   y,
							  new Array(),
							  new Array(),
							   new Array());
				}else{
					//ADD ELEMENT
					trace("ADD NEW ELEMENT")
				__controller.addFormElement(null,
										_global.labelVars.lbl_untitledElement,
										p_eventObj.el_type,
										null,
										_global.labelVars.lbl_untitledElement,
										x,
										y,
										new Array(),
										new Array());
				}
				
			}else{
				trace("OVERLAP FROM DROP")
			}
			///////////////////////
			//SELECT NEW ELEMENT
			/*
			//select obj
			var newObj =
			if(newObj!=false){
				selectObj(newObj);
			}*/
		}
	};
	
	public function checkDropTargetIsGrid(p_source:Object,type:Number){
		if(type==5 || type==2 || type==1 || type==3 || type==12 || type==7 || type==11 || type==15 || type==9){
			var el_coll = __frmArea;
			for(var j in el_coll){
				//trace("J:" + j)
				if(__model.getElementType(el_coll[j].fieldId)==14){
					if(el_coll[j].hitTest(p_source._x, p_source._y, false)) { //test hit against all mc inside taskarea
						//trace("HITTED:" + j)
						return el_coll[j];
					}
				}
			}
			return null;
		}else{
			return null;
		}
	};
	
	
	//////////////////////////////////////////
	// PROPERTIES PANEL
	/////////////////////////////////////////
	private function passPropsToPanel(fieldId:Number,fieldType:Number){
		var fieldType = __model.getElementType(fieldId);
		__PrpBar.showProps(fieldId,fieldType);
	};
	
	
	public function onElementPropertyChanged(fieldId:Number,prop_id:Number,prop_type:String,prop_value:String):Void{
		var fieldType:Number = __model.getElementType(fieldId);
		var aux:String="Form_El_"+ fieldId;
		var el;
		if((fieldType==7 ||fieldType==8 || fieldType==15) && (prop_id==6 || prop_id==15 )){
			var o:Object=__model.getXY(fieldId);
			el=objsInGrid_array[o.x][o.y];
		}else{
			el = __frmArea[aux]._el;
		}
		//trace("onElementPropertyChanged "+fieldId+" "+prop_type+" "+prop_value+" "+fieldId+" "+el);
		changeComponentProperty(el,prop_id,fieldType,prop_value,prop_type);
	};
	
	
	function onElementGridColPropertyChanged(gridFieldId:Number,fieldId:Number,prop_id:Number,prop_type:String,prop_value:String,fieldType:Number){
		var el:MovieClip;
		//trace(">>>>" + el._name + "\n gridFieldId:" + gridFieldId +"\n fieldId" + fieldId + "\n prop_id:" + prop_id + "\n prop_type" + prop_type)
	 	el=__frmArea["Form_El_" + gridFieldId].getColObj(fieldId);
		if( (fieldType==7 || fieldType==15)&&prop_id==6){
			el.label=prop_value;
			el.text=prop_value;
			}
		if(fieldType==7&&prop_id==15){
			el._width=el._parent._width;
			/*var myformat = new TextFormat();
			myformat.textAlign = prop_value ;*/
			el.setStyle("textAlign", prop_value); 

			//el.setTextFormat(myformat);
		}
		changeComponentProperty(el,prop_id,fieldType,prop_value,prop_type);
	};
	
	
	function changeComponentProperty(el:MovieClip,prop_id:Number,fieldType:Number,prop_value:String,prop_type:String){
		var DEFAULT_WIDTH_RATIO:Number = 6; //html size
		var DEFAULT_INPUT_WIDTH:Number = 28;
		var DEFAULT_INPUT_HEIGHT:Number = 22;
		//---
		switch(prop_id){
			case 1: //1 - SIZE
				if(fieldType==1 || fieldType==2 || fieldType==6){ //INPUT or CMB or TEXTAREA
					if(fieldType==1){
						el.setSize(prop_value*DEFAULT_WIDTH_RATIO,DEFAULT_INPUT_HEIGHT);
					}else if(fieldType==2){
						el.setSize(prop_value,DEFAULT_INPUT_HEIGHT);
					}else{
						el.setSize(prop_value*DEFAULT_WIDTH_RATIO,(60));
					}
				}
				break;
			case 2: //2 - readonly
					if(prop_value== "true" || prop_value== true){}
				break;
			case 4:	//4 - disabled
				if(prop_value== "true" || prop_value== true){
					el.setStyle("backgroundColor",0xDDDDDD);
				}else{
					el.setStyle("backgroundColor",0xFFFFFF);
				}
				break;
			case 6:	//6 - value
				if(fieldType==5){
					el.label=prop_value;
					}
				if(fieldType==7 || fieldType==8 || fieldType==15){
					el["ico_txt"]._width=(Math.round(el._width/170))*170;
					var myformat = new TextFormat();
						myformat.font = "Verdana";
						myformat.color = "0x000000";
						myformat.size = 9;
						var format=el["ico_txt"].getTextFormat();
						myformat.align = format.align ;
					if(prop_value==""){
						el["ico_txt"].text=" ";
					}else{
						el["ico_txt"].text=prop_value;
					}
					el["ico_txt"].setTextFormat(myformat);
//					setElementLabel(el,prop_value);
					}
				break;
			case 7:	//7 - required - String 
					if(prop_value== "true" || prop_value== true){
						//this["label_mc"].label_txt.textColor = 0x000080;
					}else{
						//this["label_mc"].label_txt.textColor = 0x000000;
					}
				break;
			case 15://7 - align - String 
					var myformat = new TextFormat();
						myformat.font = "Verdana";
						myformat.color = "0x000000";
						myformat.size = 9;
						myformat.align =prop_value ;
					el["ico_txt"].setTextFormat(myformat);
				break;
			case 20: //20 - grid height - number
					
				break;
			case 21: //21 - width - number
				//p_obj.setElementWidth(p_value);
				break;
			case 22: //22 - urlSource - string
				//p_obj.setElementSource(p_value);
				break;
		}
		
		
		
	};
	
	
};







