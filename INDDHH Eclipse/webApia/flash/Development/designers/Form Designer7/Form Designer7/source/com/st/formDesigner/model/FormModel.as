

class com.st.formDesigner.model.FormModel {
	
	// Internal properties
	private var elements:Object;
	private var maxID:Number;
	
	private var formProperties:Array;
	private var formEvents:Array;
	
	// Empty functions for "mix-ins" from AsBroadcaster
	public var addListener:Function;
	public var removeListener:Function;
	private var broadcastMessage:Function;
	 // Set up Model as a broadcaster
	static private var __broadcasterMixin = AsBroadcaster.initialize(FormModel.prototype);
	

	public function FormModel() {
		maxID = 0;
	};
	
	
	//Resets the model
	public function reset():Void {
		elements = new Object();
		broadcastMessage("onReset");
	};
	
	
	public function addElement(fieldId:Number,fieldLabel:String,fieldType:Number,attId:Number,attName:String,gridX:Number,gridY:Number,prp_Array:Array,evt_Array:Array){
		fieldId = checkMaxID(fieldId);
		
		if(elements[fieldId] == null){
			elements[fieldId] = new Object();
			elements[fieldId].fieldId = fieldId;
			elements[fieldId].fieldLabel = fieldLabel;
			elements[fieldId].fieldType = fieldType;
			elements[fieldId].attId = attId;
			elements[fieldId].attName = attName;
			elements[fieldId].gridX = gridX;
			elements[fieldId].gridY = gridY;
			elements[fieldId].prp_Array = prp_Array;
			elements[fieldId].evt_Array = evt_Array;
			
			trace("FORM ELEMENT ADDED: " + fieldId);
			broadcastMessage("onFormElementAdded",fieldId);
		}
		
	};

		public function addInputElement(fieldId:Number,fieldLabel:String,fieldType:Number,attId:Number,attName:String,gridX:Number,gridY:Number,prp_Array:Array,evt_Array:Array,bnd_Array:Array){
		fieldId = checkMaxID(fieldId);
		
		if(elements[fieldId] == null){
			elements[fieldId] = new Object();
			elements[fieldId].fieldId = fieldId;
			elements[fieldId].fieldLabel = fieldLabel;
			elements[fieldId].fieldType = fieldType;
			elements[fieldId].attId = attId;
			elements[fieldId].attName = attName;
			elements[fieldId].gridX = gridX;
			elements[fieldId].gridY = gridY;
			elements[fieldId].prp_Array = prp_Array;
			elements[fieldId].evt_Array = evt_Array;
			elements[fieldId].bnd_Array = bnd_Array;
			
			trace("FORM ELEMENT ADDED: " + fieldId);
			broadcastMessage("onFormInputElementAdded",fieldId);
		}
		
	};

	
	public function addGridElement(fieldId:Number,fieldLabel:String,fieldType:Number,attId:Number,attName:String,gridX:Number,gridY:Number,prp_Array:Array,evt_Array:Array,gridChildrenElement:Array){
		fieldId = checkMaxID(fieldId);
		
		if(elements[fieldId] == null){
			elements[fieldId] = new Object();
			elements[fieldId].fieldId = fieldId;
			elements[fieldId].fieldLabel = fieldLabel;
			elements[fieldId].fieldType = fieldType;
			elements[fieldId].attId = attId;
			elements[fieldId].attName = attName;
			elements[fieldId].gridX = gridX;
			elements[fieldId].gridY = gridY;
			elements[fieldId].prp_Array = prp_Array;
			elements[fieldId].evt_Array = evt_Array;
			elements[fieldId].children_Array = gridChildrenElement;
			
			trace("FORM GRID ELEMENT ADDED: " + fieldId);
			broadcastMessage("onFormGridElementAdded",fieldId);
			
			//hack to add cols to maxID
			if(gridChildrenElement.length>0){
				for(var cx=0;cx <gridChildrenElement.length;cx++){
					var tmpfieldId = checkMaxID(gridChildrenElement[cx].fieldId);
				}
			}
			
		}
	};
	
	function addColToGridElement(gridFieldId:Number,fieldType:Number){
		var colObj = {};
			colObj.fieldId = checkMaxID()
			colObj.fieldLabel = "untitled";
			colObj.fieldType = fieldType;
			colObj.posGrid_x = elements[gridFieldId].children_Array.length + 1;
			colObj.posGrid_y = 0;
			colObj.attId = null;
			colObj.attName = "Untitled";
			colObj.attLabel = null;
			colObj.evt_Array = [];
			colObj.prp_Array = [];
			
		elements[gridFieldId].children_Array.push(colObj);
		
		trace("\n FORM GRID COLUMN ADDED: " + colObj.fieldId);
		broadcastMessage("onColAddedToGrid",gridFieldId,fieldType,colObj.fieldId);
		
	};
	
		function moveRight(fieldId:Number,gridId:Number){
		trace("COL MOVED: " + fieldId);
		broadcastMessage("onColMoved",fieldId,gridId,1);
		//problema si se borra antes del evento!!
//		delete elements[fieldId];
		var gridColChildren = elements[gridId].children_Array;
		for(var e=0;e<gridColChildren.length;e++){
			if(gridColChildren[e].fieldId == fieldId){
				if(e<gridColChildren.length-1){
					var o:Object=new Object();
					var o2:Object=new Object();
					o=gridColChildren[e].valueOf();
					o2=gridColChildren[e+1].valueOf();
					var aux:Number=e+1;//o.posGrid_x;
					var aux2:Number=e+2;//o2.posGrid_x;
					o.posGrid_x=aux2;
					o2.posGrid_x=aux;
					gridColChildren[e]=null;
					gridColChildren[e+1]=null;
					gridColChildren[e]=o2.valueOf();
					gridColChildren[e+1]=o.valueOf();
					e=gridColChildren.length;
				}
			}
		}
		
	}
	
		function moveLeft(fieldId:Number,gridId:Number){
		trace("COL MOVED: " + fieldId);
		broadcastMessage("onColMoved",fieldId,gridId,-1);
		//problema si se borra antes del evento!!
//		delete elements[fieldId];
		var gridColChildren = elements[gridId].children_Array;
		for(var e=0;e<gridColChildren.length;e++){
			if(gridColChildren[e].fieldId == fieldId){
				if(e>0){
					var o:Object=new Object();
					var o2:Object=new Object();
					o=gridColChildren[e].valueOf();
					o2=gridColChildren[e-1].valueOf();
					var aux:Number=e+1;//o.posGrid_x;
					var aux2:Number=e;//o2.posGrid_x;
					o.posGrid_x=aux2;
					o2.posGrid_x=aux;
					gridColChildren[e]=null;
					gridColChildren[e-1]=null;
					gridColChildren[e]=o2.valueOf();
					gridColChildren[e-1]=o.valueOf();
					e=gridColChildren.length;
				}
			}
		}
		
	}
	
	function removeGridCol(fieldId:Number,gridId:Number){
		trace("COL REMOVED: " + fieldId);
		broadcastMessage("onColRemoved",fieldId,gridId);
		//problema si se borra antes del evento!!
		delete elements[fieldId];
		
		//---
		/*
		var gridColChildren = elements[gridId].children_Array;
		for(var d=0;d<gridColChildren.length;d++){
			if(gridColChildren[d].fieldId == fieldId){
				delete gridColChildren[d];
			}
		}*/
		
		//--------------
		var gridColChildren = elements[gridId].children_Array;
		for(var e=0;e<gridColChildren.length;e++){
			if(gridColChildren[e].fieldId == fieldId){
				gridColChildren.splice(e, 1); 
			}
		}
		
		
	};
	
	
	function removeElement(fieldId:Number){
		trace("ELEMENT REMOVED: " + fieldId);
		broadcastMessage("onElementRemoved",fieldId);
		//problema si se borra antes del evento!!
		delete elements[fieldId];
	};
	
	
	
	private function checkMaxID(p_currentID:Number):Number{
		if(p_currentID==null){
			return maxID++;
		}else{
			if(p_currentID >= maxID){
				maxID = p_currentID+1;
			}else{
				
			}
		return p_currentID;
		}
	};
	
	/////////////////////////////////////////////////
	// element <FORM_FIELD> properties gets
	////////////////////////////////////////////////
	public function getElementGridX(fieldId:Number):Number{
		return elements[fieldId].gridX;
	};
	public function getElementGridY(fieldId:Number):Number{
		return elements[fieldId].gridY;
	};
	public function setElementPosInGrid(fieldId:Number,xGrid:Number,yGrid:Number){
		elements[fieldId].gridY = yGrid;
		elements[fieldId].gridX = xGrid;
	};
	public function getElementType(fieldId:Number):Number{
		return elements[fieldId].fieldType;
	};
	public function getElementLabel(fieldId:Number):String{
		var type=elements[fieldId].fieldType;
		if(type==7 || type==8 || type==5){
		return this.getElementProperty(fieldId,6);
		}else{
		return elements[fieldId].fieldLabel;
		}
	};
	
	public function getGridElementChildrenArray(fieldId:Number):Array{
		return elements[fieldId].children_Array;
	};
	
	public function getElementColEvts(gridId:Number,fieldId:Number):Array{
		//GET ELEMENT COL EVENTS IN GRID
		var gridColChildren = elements[gridId].children_Array;
		for(var d=0;d<gridColChildren.length;d++){
			if(gridColChildren[d].fieldId == fieldId){
				var evtArr = gridColChildren[d].evt_Array;
				return evtArr;
			}
		}
		
	};
	
	////////////////////////////////////////////////////////////////
	//	EVENTS [appends array/objects inside to element object]
	/////////////////////////////////////////////////////////////////
	public function setGridElementEvts(gridFieldId:Number,fieldId:Number,evt_arr:Array){
		trace("COLUMN EVENTS::FOR " + fieldId)
		var gridColChildren = elements[gridFieldId].children_Array;
		for(var d=0;d<gridColChildren.length;d++){
			if(gridColChildren[d].fieldId == fieldId){
				trace("ENCONTRO EL COL a agregar los eventos")
				gridColChildren[d].evt_Array = evt_arr;
			}
		}
	};
	
	
	public function setElementEvts(fieldId:Number,evt_arr:Array){
		elements[fieldId].evt_Array = evt_arr;
	};
	public function getElementEvts(fieldId:Number):Array{
		return elements[fieldId].evt_Array;
	};
	
	public function setFormEvts(evt_arr:Array){
		formEvents = evt_arr;
	};
	public function getFormEvts():Array{
		return formEvents;
	};
	
	//////////////////////////////////////////////////////////////
	//entity binds
	//////////////////////////////////////////////////////////////
	
	public function setEntityBinds(fieldId:Number,entBndArr:Array){
		elements[fieldId].bnd_Array =entBndArr;
		var aux:Boolean=false;
		if(entBndArr.length>0){
			aux=true;
			}
		broadcastMessage("onElementGotBind",fieldId,aux);
	};
	
	public function getEntityBinds(fieldId:Number):Array{
		return elements[fieldId].bnd_Array;
	};
	
	public function hasEntityBindings(fieldId:Number){
		var aux:Array=getEntityBinds(fieldId);
		if(aux.length>0){
			broadcastMessage("onElementGotBind",fieldId,true);
			}
		}
	
	///////////////////////////////////////////////////
	// element <PROPERTY> PROP ARRAY GETs
	///////////////////////////////////////////////////
	public function setElementColSpan(fieldId:Number,val:Number):Void{
		setElementProperty(fieldId,8,"N",val.toString());
		broadcastMessage("onElementColSpanChanged",fieldId,val);
	};
	
	public function setElementRowSpan(fieldId:Number,val:Number):Void{
		setElementProperty(fieldId,9,"N",val.toString());
		broadcastMessage("onElementRowSpanChanged",fieldId,val);
	};
	
	public function getElementRowSpan(fieldId:Number):Number{
		var rowspan:Number = parseInt(getElementProperty(fieldId,9));
		if(rowspan==null || rowspan=="undefined" || isNaN(rowspan)){
			var type = getElementType(fieldId);
			rowspan = getDefaultElementRowSpan(type);
		}
		return rowspan;
	};
	
	public function getElementColSpan(fieldId:Number):Number{
		var colspan:Number = parseInt(getElementProperty(fieldId,8));
		if(colspan==null || colspan=="undefined" || isNaN(colspan)){
			var type = getElementType(fieldId);
			colspan = getDefaultElementColSpan(type);
		}
		return colspan;
	};
	
	public function getDefaultElementRowSpan(fieldType:Number):Number{
		var defaultRowSpan:Number;
		if(fieldType==10 || fieldType==6 || fieldType==14){	
			defaultRowSpan = 3;				//3 rows [elements 10,6]
		}else if(fieldType==13){
			defaultRowSpan = 4;				//4 rows [element 13]
		}else{										
			defaultRowSpan = 1;				//2 rows [elements 1,2,3,4,5,6,7,8,9]
		}
		return defaultRowSpan;
	};
	
	public function getDefaultElementColSpan(fieldType:Number):Number{
		var defaultColSpan:Number;
		if(fieldType==5 || fieldType==7){	
			defaultColSpan = 1;				//1 cols [elements 5,7]
		}else if(fieldType==8 || fieldType==14){ 				
			defaultColSpan = 4;				//4 cols [element 8]
		}else{										
			defaultColSpan = 2;				//2 cols [elements 1,2,3,4,6,9,10]
		}
		return defaultColSpan;
	};
	
	public function setAttribute(fieldId:Number,attId:Number,attLabel:String,attName:String){
		elements[fieldId].attId = attId;
		elements[fieldId].attName = attName;
		elements[fieldId].fieldLabel = attLabel;
		broadcastMessage("onAttributeChanged",fieldId,attId,attName,attLabel);
	};
	
	public function setColAttribute(gridId:Number,fieldId:Number,attId:Number,attLabel:String,attName:String){
		//elements[gridId].attId = attId;
		trace("COLID=" + fieldId)
		var gridColChildren = elements[gridId].children_Array;
		for(var d=0;d<gridColChildren.length;d++){
			if(gridColChildren[d].fieldId == fieldId){
				trace("ATT FOUND")
				gridColChildren[d].attId = attId;
				gridColChildren[d].attName = attName;
				gridColChildren[d].attLabel = attLabel;
				broadcastMessage("onColAttributeChanged",gridId,fieldId,attId,attName,attLabel);
			}
		}
	};
	///////////////////////////////////////////////////////////
	// get any property value by id 
	//////////////////////////////////////////////////////////
	public function setFormProperties(prpArray:Array){
		formProperties = prpArray;
	};
	
	public function getFormProperties():Array{
		return formProperties;
	};
	
	public function getFormProperty(prop_id){
		trace("GET__FORM_PRP___>>>>>")
		var prpArr = formProperties;
		//iterate properties array
		for(var p=0; p < formProperties.length; p++){
			if(formProperties[p].prpId==prop_id){
				return formProperties[p].value;
			}
		}
	};
	public function setFormProperty(prop_id:Number,prop_type:String,prop_value:String):Void{
		trace("SET__FORM_PRP___>>>>>" + prop_value)
		
		var s:Boolean = false;
		
		for(var p=0; p < formProperties.length; p++){
			if(formProperties[p].prpId==prop_id){
				formProperties[p].value = prop_value;
				s = true;
			}
		}
		
		if(s==false){
			var prpObj = new Object();
				prpObj.prpId = prop_id;
				prpObj.value = prop_value;
				prpObj.type = prop_type;
			formProperties.push(prpObj);
		}
		
		trace("PROPERTYCHANGED FOR FORM:");
	};

	///////////////////////////////////////////////////
	// element prps
	//////////////////////////////////////////////////
	public function getElementProperty(fieldId:Number,prop_id:Number):String{
		//IDS
		//1 - size  - Numeric
		//2 - readonly - String (true/false)
		//3 - font size - Numeric
		//4 - disabled - String
		//5 - font color -  String
		//6 - value - String
		//7 - required - String 
		//8 - rowspan - Numeric
		//9 - colspan - Numeric
	
		var prpArr = elements[fieldId].prp_Array;
		var fieldType=elements[fieldId].fieldIdType;
		//iterate properties array
		for(var p=0; p < prpArr.length; p++){
			if(prpArr[p].prpId==prop_id){
				return prpArr[p].value;
			}
		}			
	};
	
	public function setElementProperty(fieldId:Number,prop_id:Number,prop_type:String,prop_value:String):Void{
		var prpArr = elements[fieldId].prp_Array;
		var s:Boolean = false;
		
		for(var p=0; p < prpArr.length; p++){
			if(prpArr[p].prpId==prop_id){
				prpArr[p].value = prop_value;
				s = true;
			}
		}
		trace("entros "+fieldId+" "+prop_id+" "+prop_type+" "+prop_value+" "+s);		
		if(s==false){
			var prpObj = new Object();
				prpObj.prpId = prop_id;
				prpObj.value = prop_value;
				prpObj.type = prop_type;
			prpArr.push(prpObj);
		}
		
		trace("_____PROPERTYCHANGED FOR:" + fieldId)
		broadcastMessage("onElementPropertyChanged",fieldId,prop_id,prop_type,prop_value);
	};
	
	public function getGridColElementProperty(gridFieldId:Number,fieldId:Number,prop_id:Number):String{
		var gridColChildren = elements[gridFieldId].children_Array;
		for(var d=0;d<gridColChildren.length;d++){
			if(gridColChildren[d].fieldId == fieldId){
				var prpArr = gridColChildren[d].prp_Array;
				//iterate properties array
				for(var p=0; p < prpArr.length; p++){
					if(prpArr[p].prpId==prop_id){
						return prpArr[p].value;
					}
				}
			}
		}
	};
	
	public function setGridColElementProperty(gridFieldId:Number,fieldId:Number,prop_id:Number,prop_type:String,prop_value:String):Void{
		var gridColChildren = elements[gridFieldId].children_Array;
		for(var d=0;d<gridColChildren.length;d++){
			if(gridColChildren[d].fieldId == fieldId){
				var prpArr = gridColChildren[d].prp_Array;
				var elType = gridColChildren[d].fieldType;
				
				var s:Boolean = false;
				for(var p=0; p < prpArr.length; p++){
					if(prpArr[p].prpId==prop_id){
						prpArr[p].value = prop_value;
						s = true;
					}
				}
				if(s==false){
					var prpObj = new Object();
						prpObj.prpId = prop_id;
						prpObj.value = prop_value;
						prpObj.type = prop_type;
					prpArr.push(prpObj);
				}
			}
		}
		trace("PROPERTYCHANGED FOR:" + fieldId)
		broadcastMessage("onElementGridColPropertyChanged",gridFieldId,fieldId,prop_id,prop_type,prop_value,elType);
	};
	
	
	public function getAllElements():Object{
		return elements;
	};
	
	public function getAllFormProperties():Array{
		return formProperties;
	};
	public function getAllFormEvents():Array{
		return formEvents;
	};
	
	public function getXY(fieldId:Number):Object{
		var o:Object=new Object;
		o.x=elements[fieldId].gridX;
		o.y=elements[fieldId].gridY;
		return o;
		}
	
};






