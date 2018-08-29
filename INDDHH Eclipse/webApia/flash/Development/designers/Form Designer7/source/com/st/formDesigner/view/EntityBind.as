


import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import com.qlod.LoaderClass;
import com.st.util.WindowManager;

class com.st.formDesigner.view.EntityBind extends MovieClip{
	
		var fields_dg:DataGrid;
		var ent_cmb:ComboBox;
		
		var erase_btn:Button;
		var confirm_btn:Button;
		var cancel_btn:Button;
		var bind_btn:Button;
		
		var oLoader:LoaderClass;
		
		var ENTITIES_XML;
		var ENTITY_ATT_XML;
		var entId:String;
		var ele_array:Object;
		var bnd_array:Object;
		var att_id:Number;
		var entityCod:Number;
		
		var thisFieldId:Number;
		var thisField:Object;
		
		var entAtt_array:Array;
		
		var frmAttClass_DP:Array;
		
		var entityAtt:Array;
		
	function EntityBind(Void){
		mx.events.EventDispatcher.initialize(this);
		oLoader = new LoaderClass();
		
		ENTITIES_XML = _global.XML_ENTITIES;
		ENTITY_ATT_XML=_global.XML_ENTITIES_ATT;
				
		var thisModal = this;
		
		ele_array = thisModal._parent.ele_array;
		bnd_array = thisModal._parent.bnd_array;
		entityCod=bnd_array[0].entity_id;
		thisFieldId = thisModal._parent.fieldId;
		frmAttClass_DP = new Array();

		this.erase_btn.onPress = function() {
			var selIndex:Number = thisModal.fields_dg.selectedIndex;
			var tmp=thisModal;
			if(selIndex!=null){
				var selItem=thisModal.fields_dg.dataProvider.getItemAt(selIndex);
				selItem.ent_att_name="";
				selItem.ent_att="";
				thisModal.fields_dg.dataProvider.replaceItemAt(selIndex,selItem);
				}else{
					for(var i=0;i<thisModal.fields_dg.dataProvider.length;i++){
						var selItem=thisModal.fields_dg.dataProvider.getItemAt(i);
						selItem.ent_att_name="";
						selItem.ent_att="";
						thisModal.fields_dg.dataProvider.replaceItemAt(i,selItem)
					}
					tmp._parent.dispatchEvent({type:"erase"});
				}
			}
		this.confirm_btn.onPress = function() {
			var p_Array:Array = thisModal.getDataFromGrid(thisModal.fields_dg);
			var auxArray:Array=new Array();
			for(var i=0;i<p_Array.length;i++){
				if(p_Array[i].frm_att!="" && p_Array[i].frm_att!=undefined &&
					p_Array[i].ent_att!="" && p_Array[i].frm_att!=undefined &&
					p_Array[i].att_name!="" && p_Array[i].frm_att!=undefined){
					auxArray.push(p_Array[i]);
				}
							
			}
			var o:Object=new Object();
			o.entity_id=thisModal.ent_cmb.selectedItem.data;
			o.mapping=auxArray;
			thisModal.bnd_array=new Array();
			thisModal.bnd_array.push(o);
			var id:Number=thisModal.thisFieldId;
			var aux:Array;
			if(auxArray.length>0){
				aux=thisModal.bnd_array;
			}else{
				aux=new Array();
			}
			thisModal._parent.dispatchEvent({type:"ok",binds:aux,fieldId:id});
		}
				
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		}
			
		this.bind_btn.onPress = function(){
			//show bind modal
			var selIndex:Number = thisModal.fields_dg.selectedIndex;
			var selItem=thisModal.fields_dg.dataProvider.getItemAt(selIndex);
			if(selIndex!=null){
				thisModal.showEntityAtt(thisModal.entAtt_array);
				}
		}
		
	}
	
	function onLoad(){
		var thisModal = this;
		this.erase_btn.enabled=false;
		fields_dg.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		bind_btn.label = _global.labelVars.lbl_BindBtn;
		
		//RENDER COLUMNS
		var column = new DataGridColumn("frm_att_name");
			column.headerText = _global.labelVars.lbl_frmAtt;
			column.width = 160;
		fields_dg.addColumn(column);
		
		var column = new DataGridColumn("ent_att_name");
			column.headerText = _global.labelVars.lbl_entAtt;
			column.width = 220;
			column.cellRenderer("ModalShow");
			fields_dg.addColumn(column);
		var listenerObject:Object=new Object();
		listenerObject.change = function(evt){
			var entIdAux=thisModal.ent_cmb.selectedItem.data;
			thisModal.entId=entIdAux;
			entAtt_array=new Array;
			if(thisModal.bnd_array[0].entity_id!=entIdAux){
				var aux:Array=thisModal.ele_array;
				thisModal.fields_dg.dataProvider.removeAll();
				var fieldId:Number;
				thisModal.frmAttClass_DP=[];
				for(fieldId in aux){
					if(!((parseInt(thisModal.ele_array[fieldId].fieldId)==thisModal.thisFieldId)||
					(isNaN(thisModal.ele_array[fieldId].attId))||
					(thisModal.ele_array[fieldId].attId=="0"))){
						var att_name:String;
						var att_cod:Number;
						var frm_name:String=aux[fieldId].fieldLabel;
						var frm_id:String=aux[fieldId].attId;
						thisModal.frmAttClass_DP.addItem({frm_att_name:frm_name,
								ent_att_name:att_name,
								frm_att:frm_id,
								ent_att:att_cod});
						}
					}
				thisModal.fields_dg.dataProvider = thisModal.frmAttClass_DP;
				}
			thisModal.getXML(thisModal.ENTITY_ATT_XML,thisModal.entId,null);
		}
		ent_cmb.addEventListener("change", listenerObject);

		//LOAD CMBs
		this.getXML(thisModal.ENTITIES_XML,"",thisModal.ent_cmb);
		this.updateGrid();
	};
	
	function updateGrid(){
				//INIT GRID
				var tmp=this;
				var fieldId:Number;
				for(fieldId in ele_array){
					if(!((parseInt(ele_array[fieldId].fieldId)==tmp.thisFieldId)||
						(isNaN(ele_array[fieldId].attId))||
						(ele_array[fieldId].attId=="0"))){
						var att_name:String;
						var att_cod:Number;
						for(var e:Number=0;e<bnd_array.length;e++){
						var aux:Array=bnd_array[e].mapping;
						for(var i=0;i<aux.length;i++){
							if(parseInt(aux[i].frm_att)==parseInt(ele_array[fieldId].attId)){
								att_cod=aux[i].ent_att;
								att_name=aux[i].att_name;
								}
							}
						}
					frmAttClass_DP.addItem({frm_att_name:ele_array[fieldId].fieldLabel,
										   	ent_att_name:att_name,
											frm_att:ele_array[fieldId].attId,
											ent_att:att_cod});
					}
				}
				if(frmAttClass_DP.length>0){					
					this.erase_btn.enabled=true;
					}
				fields_dg.dataProvider = frmAttClass_DP;
				
			}	
	
	function getXML(p_url:String,p_type:String,cmb:ComboBox){
		var tmp=this;
		var x = new XML();
			x.ignoreWhite = true;
		var loaderListener = new Object();
			loaderListener.onLoadStart = function(){};
			loaderListener.onLoadProgress = function(loaderObj){};
			loaderListener.onTimeout = function(loaderObj){};
			loaderListener.onLoadComplete = function(success,loaderObj){
				//trace("onLoadComplete" + loaderObj.getTargetObj().toString());
				var x = loaderObj.getTargetObj();
				var list:Array=new Array();
				for (var e=0;e < x.firstChild.childNodes.length;e++) {
					var obj:Object=new Object();
					obj.a= x.firstChild.childNodes[e].childNodes[0].firstChild.nodeValue;
					obj.b= x.firstChild.childNodes[e].childNodes[1].firstChild.nodeValue;
					list.push(obj);
				}
				if(p_type==""){
					tmp.loadCombo(cmb,list);
					}else{
						if(this.cmb==null){
						tmp.entAtt_array=list;
						}
					}
			};
						
		var auxURL:String;
		if(_global.DEBUG_IN_IDE){
			auxURL = p_url;
		}else{
			if(p_type=="" || p_type==undefined || p_type=="undefined"){
			auxURL = p_url;
			}else{
			auxURL = p_url + "&entId=" + p_type;
			}
		}
		
		oLoader.load(x,auxURL,loaderListener);
	};
	
	function loadCombo(cmb:ComboBox,list:Array){
		var cod:Number;
		for (var e=0;e < list.length;e++) {
			//p_objCmb.addItem(x.firstChild.childNodes[e].attributes.name,x.firstChild.childNodes[e].attributes.id);
			var col_id = list[e].a;
			var col_name = list[e].b;
			if(col_id==this.bnd_array[0].entity_id){
				cod=e;
				}			
			cmb.addItem(col_name,col_id);
			}
			if(!(cod==undefined || cod==null || cod=="")){
			cmb.selectedIndex=cod;
			}
			var aux:String=cmb.selectedItem.data;
			getXML(ENTITY_ATT_XML,aux,null);
		}
	
	function showEntityAtt(atts:Array){
		var tmp = this;
		var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "EntityAttributes";
			//configOBj.title = _global.labelVars.lbl_eventWin.toUpperCase() + " : " + __model.getTaskName(task_att_id);
			configOBj.title =_global.labelVars.EntAttDialogTit;
			configOBj._width = 250;
			configOBj._height = 150;
			configOBj.atts = atts;
//			configOBj.fieldId=fieldId;
			
		var objEvt = new Object();
			objEvt.ok = function(bnd:Object){
				var codSelected:Number=bnd.cod;
				var descSelected:String=bnd.desc;
				var dg_index:Number= tmp.fields_dg.selectedIndex;
				tmp.fields_dg.dataProvider[dg_index].ent_att= codSelected;
				tmp.fields_dg.dataProvider[dg_index].ent_att_name= descSelected;
				popUp.deletePopUp();
			}
			objEvt.click = function(bnd:Object):Void{
				popUp.deletePopUp();
			}
		var popUp = WindowManager.popUp(configOBj,this);
			popUp.addEventListener("ok", objEvt);
			popUp.addEventListener("click", objEvt);
	};
	
		function getDataFromGrid(objGrid:DataGrid){
		var obj_Array = new Array();
		for(var x=0; x < objGrid.dataProvider.length; x++)	{
			var p_data = new Object();
				p_data.frm_att = objGrid.dataProvider[x].frm_att;
				p_data.ent_att = objGrid.dataProvider[x].ent_att;
				p_data.att_name = objGrid.dataProvider[x].ent_att_name;
				if(!(p_data.ent_att=="" || p_data.ent_att==null || p_data.ent_att==undefined)){
					obj_Array.push(p_data);
				}
		}
		return obj_Array;
	};

	
}


