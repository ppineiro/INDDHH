


class com.st.process.model.ProcessModel {
	private var elements:Object;
	private var maxID:Number;
	private var ATT_PRO_TYPE_DEFAULT:String = "m";
	private var process_events:Array;
	public var addListener:Function;
	public var removeListener:Function;
	private var broadcastMessage:Function;
	

	static private var __broadcasterMixin = AsBroadcaster.initialize(ProcessModel.prototype);
	
	
	public function ProcessModel() {
	}

	public function reset():Void {
		elements = new Object();
		broadcastMessage("onReset");
	};
	
	public function addTask(att_id:Number,att_pro_ele_id:Number,att_disabled:String,att_color:String,att_task_id:Number,att_type:String,att_label:String,att_x:Number,att_y:Number,info:Object):Void{
		var oTask = addElement(att_id,att_pro_ele_id,att_disabled,att_color,att_type,att_x,att_y,info);
			oTask.att_label = att_label;
			oTask.att_task_id = att_task_id;
		broadcastMessage("onTaskAdded",oTask.att_id,att_label,att_disabled,att_color,att_x,att_y);
	
	};
	
	public function addInitTask(att_id:Number,att_pro_ele_id:Number,att_type:String,att_label:String,att_x:Number,att_y:Number):Void{
		var oInitTask = addElement(att_id,att_pro_ele_id,"","",att_type,att_x,att_y);
		broadcastMessage("onInitTaskAdded",oInitTask.att_id,att_label,att_x,att_y);
		
	};
	public function addEndTask(att_id:Number,att_pro_ele_id:Number,att_type:String,att_label:String,att_x:Number,att_y:Number):Void{
		var oEndTask = addElement(att_id,att_pro_ele_id,"","",att_type,att_x,att_y);
		broadcastMessage("onEndTaskAdded",oEndTask.att_id,att_label,att_x,att_y);
		
	};
	
	public function addProcess (att_id:Number,att_pro_ele_id:Number,att_pro_disabled:String,att_color:String,att_pro_id:Number,att_type:String,att_label:String,att_x:Number,att_y:Number,info:Object):Void{
		var oProcess = addElement(att_id,att_pro_ele_id,att_pro_disabled,att_color,att_type,att_x,att_y,info);
			trace("MOCO "+att_label);
			oProcess.att_label = att_label;
			oProcess.att_pro_id = att_pro_id;
			oProcess.att_pro_type = ATT_PRO_TYPE_DEFAULT;
			
		broadcastMessage("onProcessAdded",oProcess.att_id,att_label,att_pro_disabled,att_color,att_x,att_y);
	};
	public function addOperator(att_id:Number,att_pro_ele_id:Number,att_ope_id:Number,att_type:String,att_x:Number,att_y:Number):Void{
		var oOperator = addElement(att_id,att_pro_ele_id,"","",att_type,att_x,att_y);
			oOperator.att_ope_id = att_ope_id;
			
		broadcastMessage("onOperatorAdded",oOperator.att_id,att_ope_id,att_x,att_y);
	};
	
	
	
	public function addElement(att_id:Number,att_pro_ele_id:Number,att_disabled:String,att_color:String,att_type:String,att_x:Number,att_y:Number,info:Object):Object {
		att_id = checkMaxID(att_id);
		
		if(elements[att_id] == null){
			elements[att_id] = new Object();
			elements[att_id].att_id = att_id;
			elements[att_id].att_pro_ele_id = att_pro_ele_id;
			elements[att_id].att_type = att_type;
			elements[att_id].vertices = new Object();
			elements[att_id].forms = new Array();
			elements[att_id].disabled=att_disabled;
			elements[att_id].color=att_color;
			elements[att_id].infoText=info.text;
			elements[att_id].infoTitle=info.title;
			setElementPosition(att_id,att_x,att_y);
			
			trace("ELEMENT ADDED: " + att_id);
			return elements[att_id];
		
		}else{
			return elements[att_id];
		}
	};
	
	public function getElementInfo(att_id:Number):Object{
		
		return {title:elements[att_id].infoTitle,text:elements[att_id].infoText};
	}
	
	public function removeElement(att_id:Number):Void {
		if(elements[att_id].att_type != "I"){  //not INIT task
			//removes a node from the graph
			delete elements[att_id];
			for (var i in elements) {
				//remove all vertices
				delete elements[i].vertices[att_id];
			}
			trace("ELEMENT REMOVED: " + att_id);
			broadcastMessage("onElementRemoved",att_id);
		}
	};
	
	public function setElementPosition(att_id:Number,att_x:Number,att_y:Number){
		elements[att_id].att_x = att_x;
		elements[att_id].att_y = att_y;
	};
	
	
	public function addLineElement(startId:Number,endId:Number,name:String,condition:String,disabled:String):Void{
		if(!(startId==endId)){
			if((getVertexId(startId,endId)!=null) || (getVertexId(endId,startId)!=null)){
				trace("VERTEX " + startId + "/" + endId + " already exists");
			}else{
				addVertex(startId,endId);
				broadcastMessage("onLineAdded",startId,endId,disabled);
				if(name){
					addLineName(startId,endId,name);
				}
				if(condition){
					addLineCondition(startId,endId,condition);
				}
			}
		}
	};
	
	public function removeLineElement(startId:Number,endId:Number):Void{
		removeVertex(startId, endId);
		trace("LINE REMOVED: " + startId + "/" + endId);
		broadcastMessage("onLineRemoved",startId,endId);
	};
	
	public function dependencyHasLoopBack(id_a:Number, id_b:Number, loop_back:Boolean):Void{
		var oLine:Object = getVertex(id_a,id_b);
		if(loop_back==true){
			oLine.loopBack = loop_back;
			dependencyIsWizard(id_a,id_b,false);
			trace("LINE LOOP_BACK: " + id_a + "/" + id_b);
		}else{
			delete oLine.loopBack;
		}
		broadcastMessage("onDependencyLoopBack",id_a,id_b,loop_back);
	};
	
	public function dependencyIsWizard(id_a:Number, id_b:Number, isWizard:Boolean):Void{
		var oLine:Object = getVertex(id_a,id_b);
		if(isWizard==true){
			oLine.takeNext = isWizard;
			dependencyHasLoopBack(id_a,id_b,false);
			trace("LINE TAKE_NEXT: " + id_a + "/" + id_b);
		}else{
			delete oLine.takeNext;
		}
		broadcastMessage("onDependencyWizard",id_a,id_b,isWizard);
	};
	
	
	public function isWizard(id_a:Number, id_b:Number):Boolean{
		var oLine:Object = getVertex(id_a,id_b);
		if(oLine.takeNext){
			return true;
		}
		return false;
	};
	
	public function isLooped(id_a:Number, id_b:Number):Boolean{
		var oLine:Object = getVertex(id_a,id_b);
		if(oLine.loopBack){
			return true;
		}
		return false;
	};
	
	
	public function addLineCondition(id_a:Number,id_b:Number,condition:String):Void{
		var oLine:Object = getVertex(id_a,id_b);
			oLine.condition = condition;
		
		trace("LINE " + id_a + "_" + id_b + " CONDITION ADDED: " + condition);
		broadcastMessage("onDependencyConditionAdded",id_a,id_b,condition);
	};
	public function removeLineCondition(id_a:Number,id_b:Number):Void{
		delete elements[id_a].vertices[id_b].condition;
		trace("LINE " + id_a + "_" + id_b + " CONDITION REMOVED: ");
		broadcastMessage("onDependencyConditionRemoved",id_a,id_b);
	};
	public function getLineCondition(id_a:Number,id_b:Number):String{
		//var oLine:Object = getVertex(id_a,id_b);
			//return oLine.condition;
		return elements[id_a].vertices[id_b].condition;
	};
	
	
	
	public function addLineName(id_a:Number,id_b:Number,name:String,disabled:String):Void{
		elements[id_a].vertices[id_b].name = name;
		trace("LINE " + id_a + "_" + id_b + " NAME ADDED: " + name);
		broadcastMessage("onDependencyNameAdded",id_a,id_b,name,disabled);
	};
	public function removeLineName(id_a:Number,id_b:Number):Void{
		delete elements[id_a].vertices[id_b].name;
		trace("LINE " + id_a + "_" + id_b + " NAME REMOVED: ");
		broadcastMessage("onDependencyNameRemoved",id_a,id_b);
	};
	
	public function updateTaskMultiplier(att_id:Number,multiplier_id:Number,multiplier_name:String){
		if(multiplier_id){
			elements[att_id].multiplier_id = multiplier_id;
			elements[att_id].multiplier_name = multiplier_name;
		}else{
			delete elements[att_id].multiplier_id;
			delete elements[att_id].multiplier_name;
		}
	};
	
	public function iterateProcessElement(att_id:Number,iterate_flag:Boolean):Void{
		if(iterate_flag==true){
			elements[att_id].iterated = iterate_flag;
		}else{
			delete elements[att_id].iterated;
			updateProcessIterationCondition(att_id,false);
		}
		trace("SUBPROCESS " + att_id + " ITERATE: " + iterate_flag);
		broadcastMessage("onIterateProcess",att_id,iterate_flag);
	};
	
	public function isProcessIterated(att_id:Number):Boolean{
		if(elements[att_id].iterated){
			return true;
		}
		return false;
	};
	
	//subprocess iterate condition
	public function updateProcessIterationCondition(att_id:Number,b_flag:Boolean,condition:String):Void{
		if(b_flag){
			if(isProcessIterated(att_id)){
				elements[att_id].condition = condition;
			}
		}else{
			delete elements[att_id].condition;
		}
		trace("SUBPROCESS " + att_id + " ITERATE CONDITION: " + b_flag + "\n" + condition);
		broadcastMessage("onIterateProcessCondition",att_id,b_flag);
	};

	public function getProcessIterateCondition(att_id:Number):String{
		if(isProcessIterated(att_id)){
			return elements[att_id].condition;
		}
	};

	public function getFormCondition(att_id:Number):String{
			return elements[att_id].condition;
	};

	
	public function setProcessType(att_id:Number,att_pro_type:String):Void{
		if(att_pro_type == "m" || att_pro_type == "a" || att_pro_type == "s"){
			elements[att_id].type = att_pro_type;
		}else{
			delete elements[att_id].type;
		}
		broadcastMessage("onProcessTypeChanged",att_id,att_pro_type);
	};
	
	public function getProcessType(att_id:Number):String{
		var att_pro_type = elements[att_id].type;
		if(att_pro_type == "m" || att_pro_type == "a" || att_pro_type == "s"){
			return elements[att_id].type;
		}else{
			return null;
		}
	};
	/////////////////////////////
	//SubProcess Forms
	/////////////////////////////
	public function setProcessForms(att_id:Number,frmArr:Array):Void{
		/*trace("Model UPDATE id:" + att_id + " len=" + frmArr.length)
		for (var i in  frmArr) {trace("FRM." + i + " = " +  frmArr[i].name);}*/
		elements[att_id].forms = frmArr;
	};
	public function getProcessForms(att_id:Number):Array{
		/*trace("Model GET id:" + att_id + " len=" + elements[att_id].forms.length)
		for (var i in  elements[att_id].forms) {trace("FRM." + i + " = " +  elements[att_id].forms[i].name);}*/
		return elements[att_id].forms;
	};
	
	
	
	
	private function addVertex(id_a:Number, id_b:Number):Void{
		// adds a vertex to the graph
		elements[id_a].vertices[id_b] = new Object();
		elements[id_a].vertices[id_b].id = id_b;
		trace("VERTEX ADDED:" + id_a + "/" + id_b);
	}; 
	
	private function removeVertex(id_a:Number, id_b:Number):Void{
		//removes a vertex from the graph
		delete elements[id_a].vertices[id_b];
		trace("VERTEX REMOVED:" + id_a + "/" + id_b);
	};
	
	private function getVertex(id_a:Number, id_b:Number):Object{
		return elements[id_a].vertices[id_b];
	};
	
	private function getVertexId(id_a, id_b):Number{
		//get the info stored in a particular vertex
		return elements[id_a].vertices[id_b].id;
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
	
	
	////////////////////////////////////////////////////////////////
	//	TASK ROLES
	/////////////////////////////////////////////////////////////////
	public function addRol(att_id:Number,rolId:Number,rolName:String):Void{
		elements[att_id].rolId = rolId;
		elements[att_id].rolName = rolName;
		broadcastMessage("onTaskRolAdded",att_id,rolName);
	};
	public function getRolId(att_id:Number):Number{
		if(elements[att_id].rolId){
			return elements[att_id].rolId;
		}else{
			return null;
		}
	};
	public function getRolName(att_id:Number):String{
		if(elements[att_id].rolName){
			return elements[att_id].rolName;
		}else{
			return null;
		}
	};
	public function removeRol(att_id:Number):Void{
		delete elements[att_id].rolId;
		delete elements[att_id].rolName;
		trace("ELEMENT " + att_id + " ROL REMOVED");
		broadcastMessage("onTaskRolRemoved",att_id);
	};
	
	//////////////////////////////////////////////////////////////
	//	TASK FORMS [appends array to element object w/ form obj]
	//////////////////////////////////////////////////////////////
	public function addFormToStep(att_id:Number,step_pos:Number,form:Object){
		if(elements[att_id].forms[step_pos]==null){
			elements[att_id].forms[step_pos] = [];
		}
		elements[att_id].forms[step_pos].push(form);
	};
	public function addFormToTask(att_id:Number,forms:Array){
		elements[att_id].forms = forms;
	};
	public function getTaskForms(att_id:Number):Array{
		return elements[att_id].forms;
	};
	
	
	////////////////////////////////////////////////////////////////
	//	TASK EVENTS [appends array/objects inside to element object]
	/////////////////////////////////////////////////////////////////
	public function setTaskEvts(att_id:Number,evt_arr:Array){
		elements[att_id].taskEvents = evt_arr;
		trace(elements[att_id].att_label + " evts:" + evt_arr.length)
	};
	public function getTaskEvts(att_id:Number):Array{
		return elements[att_id].taskEvents;
	};
	////////////////////////////////////////////////////////////////
	//	PROCESS EVENTS [appends array/objects inside to element object]
	/////////////////////////////////////////////////////////////////
	public function setProcessEvts(evt_arr:Array){
		process_events = evt_arr;
	};
	public function getProcessEvts():Array{
		return process_events;
	};
	
	////////////////////////////////////////////////////////////////
	//	TASK POOLS [appends array/objects inside to element object]
	/////////////////////////////////////////////////////////////////
	public function addPools(elementId:Number,task_pools:Array):Void{
		elements[elementId].pools = task_pools;
	};
	public function getPools(elementId:Number):Array{
		return elements[elementId].pools;
	};

	////////////////////////////////////////////////////////////////
	//	TASK STATES [appends array/objects inside to element object]
	/////////////////////////////////////////////////////////////////
	public function addStates(elementId:Number,task_states:Array):Void{
		elements[elementId].states = task_states;
	};
	public function getStates(elementId:Number):Array{
	return elements[elementId].states;
	};

	
	
	
	////////////////////////////////////////////////////////////////
	//	GET MODEL
	/////////////////////////////////////////////////////////////////
	public function getElements():Object{
		return elements;
	};
	
	public function getModelLength():Number{
		var mIndex:Number = 0;
		for (var z in elements) {
			if(elements[z].att_id != null){
				mIndex++;
			}
		}
		return mIndex;
	};
	//ALL ELEMENTS
	public function getElementId(pos:Number):Number{
		return elements[pos].att_id;
	};
	public function getElementType(att_id:Number):String{
		return elements[att_id].att_type;
	};
	public function getElementProEleId(att_id:Number):Number{
		return elements[att_id].att_pro_ele_id;
	};
	public function getElementX(att_id:Number):Number{
		return elements[att_id].att_x;
	};
	public function getElementY(att_id:Number):Number{
		return elements[att_id].att_y;
	};
	//TASK
	public function getTaskId(att_id:Number):Number{
		return elements[att_id].att_task_id;
	};
	public function getTaskName(att_id:Number):String{
		return elements[att_id].att_label;
	};
	public function getTaskRolId(att_id:Number):Number{
		var a = getRolId(att_id);
		return a;
	};
	public function getTaskRolName(att_id:Number):String{
		var a = getRolName(att_id);
		return a;
	};
	public function getTaskMultiplier(att_id:Number):Object{
		if(elements[att_id].multiplier_id){
			var m_obj = new Object();
				m_obj.id = elements[att_id].multiplier_id;
				m_obj.name = elements[att_id].multiplier_name;
			return m_obj;
		}else{
			return null;
		}
	};
	//OP
	public function getOperatorId(att_id:Number):Number{
		return elements[att_id].att_ope_id;
	};
	//PROCESS
	public function getProcessId(att_id:Number):Number{
		return elements[att_id].att_pro_id;
	};
	public function getProcessIterate(att_id:Number):Boolean{
		return elements[att_id].iterated;
	};
	public function getProcessName(att_id:Number):String{
		return elements[att_id].att_label;
	};
	//DEPENDENCY 
	public function getVertices(id_a:Number):Object{
		return elements[id_a].vertices;
	};
	public function getLineId(id_a:Number,id_b:Number):Number{
		return elements[id_a].vertices[id_b].id;
	};
	public function getLineName(id_a:Number,id_b:Number):String{
			return elements[id_a].vertices[id_b].name;
	};

}