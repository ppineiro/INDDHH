

import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.RadioButton;
import mx.controls.RadioButtonGroup;

import com.st.util.WindowManager;

class com.st.process.view.dialogs.PrpModal extends MovieClip{
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var attName_txt:TextInput;
	var lblMultiplier_txt:TextField;
	var att_btn:Button;
	var multiplier_true:RadioButton;
	var multiplier_false:RadioButton;
	var entAttName_txt:TextInput;
	var lblEntMultiplier_txt:TextField;
	var entAtt_btn:Button;
	var entity_true:RadioButton;
	var entity_false:RadioButton;
	var backLabel:MovieClip;
	
	var multiplier_id:Number;
	var multiplier_name:String;
	var multiplier_type:String;
	
	var entity_id:Number;
	var entity_name:String;
	
	private var multiplierGroup:RadioButtonGroup;
	private var entityGroup:RadioButtonGroup;
	
	function PrpModal(Void){
		entAttName_txt._y=300;
		lblEntMultiplier_txt._visible=false;
		entAtt_btn._y=300;
		entity_true._visible=false;
		entity_false._visible=false;
		mx.events.EventDispatcher.initialize(this);
		var thisModal = this;
		multiplier_id =  thisModal._parent.multiplier_id;
		multiplier_name =  thisModal._parent.multiplier_name;
		multiplier_type =  thisModal._parent.multiplier_type;
		entity_id=thisModal._parent.entity_id;
		entity_name=thisModal._parent.entity_name;
		//if(multiplier_type=="a" || multiplier_type=="s"){
		if(multiplier_type!=null && multiplier_type!="m"){
			entAttName_txt._y=197;
			lblEntMultiplier_txt._visible=true;
			entAtt_btn._y=197;
			entity_true._visible=true;
			entity_false._visible=true;
			lblEntMultiplier_txt._y=120;
			backLabel._y=120;
		}
		this.confirm_btn.onPress = function() {
			var multiplier_id:Number = thisModal.multiplier_id;
			var multiplier_name:String =  thisModal.multiplier_name;
			var entity_id:Number = thisModal.entity_id;
			var entity_name:String =  thisModal.entity_name;
			
			thisModal._parent.dispatchEvent({type:"ok",multiplier_id:multiplier_id,multiplier_name:multiplier_name,entity_id:entity_id,entity_name:entity_name});
			
		};
		
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		
		this.att_btn.onPress = function() {
			//_level6.showAttDialog(56);
			var tmp = thisModal;
			
			var configOBj = new Object();
				configOBj.closeButton = true;
				configOBj.contentPath = "AttModal";
				//configOBj.title = _global.labelVars.lbl_poolWin.toUpperCase() + ": " +  __model.getTaskName(task_att_id);
				configOBj.title =_global.labelVars.attributesModalTitle;
				configOBj._width = 450;
				configOBj._height = 360;
				configOBj.n ="N";
				
			var objEvt = new Object();
				objEvt.ok = function(evt){
					var itemSelected = evt.selected;
					var att_id = itemSelected.id;
					var att_label = itemSelected.label;
					var att_name = itemSelected.name;
					tmp.setMultiplier(att_id,att_name);
					popUp.deletePopUp();
				}
				objEvt.click = function(evt:Object):Void{
					popUp.deletePopUp();
				}
			
			var popUp = WindowManager.popUp(configOBj,_level6);
				popUp.addEventListener("ok", objEvt);
				popUp.addEventListener("click", objEvt);
		};
		
		this.entAtt_btn.onPress = function() {
			//_level6.showAttDialog(56);
			var tmp = thisModal;
			
			var configOBj = new Object();
				configOBj.closeButton = true;
				configOBj.contentPath = "AttModal";
				//configOBj.title = _global.labelVars.lbl_poolWin.toUpperCase() + ": " +  __model.getTaskName(task_att_id);
				configOBj.title =_global.labelVars.attributesModalTitle;
				configOBj._width = 450;
				configOBj._height = 360;
				configOBj.n ="N";
				
			var objEvt = new Object();
				objEvt.ok = function(evt){
					var itemSelected = evt.selected;
					var att_id = itemSelected.id;
					var att_label = itemSelected.label;
					var att_name = itemSelected.name;
					tmp.setEntity(att_id,att_name);
					popUp.deletePopUp();
				}
				objEvt.click = function(evt:Object):Void{
					popUp.deletePopUp();
				}
			
			var popUp = WindowManager.popUp(configOBj,_level6);
				popUp.addEventListener("ok", objEvt);
				popUp.addEventListener("click", objEvt);
		};
		
	};
	
	function onLoad(){
		//SET BTN LABELS
		var tmp = this;
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		lblMultiplier_txt.text =  _global.labelVars.lbl_tskMulti;//"Task Multiplier";
		lblEntMultiplier_txt.text = _global.labelVars.lbl_procEntities;//"Entity Multiplier";
		multiplier_true.label = "true";
		multiplier_false.label = "false";
		entity_true.label = "true";
		entity_false.label = "false";		
		
		multiplier_true.data = "1";
		multiplier_false.data = "2";
		
		multiplier_true.groupName = "multiplierGroup";
		multiplier_false.groupName = "multiplierGroup";
		
		entity_true.data = "1";
		entity_false.data = "2";

		entity_true.groupName = "entityGroup";
		entity_false.groupName = "entityGroup";

		//set initial state
		if(multiplier_id){
			attName_txt.text = multiplier_name;
			multiplier_true.selected = true;
		}else{
			multiplier_false.selected = true;
			tmp.attName_txt.enabled = false;
			tmp.att_btn.enabled = false;
			tmp.attName_txt.text = "";
		}
		
		if(entity_id){
			entAttName_txt.text = entity_name;
			entity_true.selected = true;
		}else{
			entity_false.selected = true;
			tmp.entAttName_txt.enabled = false;
			tmp.entAtt_btn.enabled = false;
			tmp.entAttName_txt.text = "";
		}

		//attach events to radio
		var radioListener = new Object();
			radioListener.click = function (evt){
				var chkState = evt.target.selection.data;
				//trace(chkState);
				if(chkState==1){
					tmp.attName_txt.enabled = true;
					tmp.att_btn.enabled = true;
					tmp.attName_txt.setStyle("backgroundColor","0xFFFFFF");
				}else{
					tmp.setMultiplier(null,null);
					tmp.attName_txt.enabled = false;
					tmp.att_btn.enabled = false;
					tmp.attName_txt.text = "";
					tmp.attName_txt.setStyle("backgroundColor","0xDFDFDF");
				}
			}
		var radioListener2 = new Object();
			radioListener2.click = function (evt){
				var chkState = evt.target.selection.data;
				//trace(chkState);
				if(chkState==1){
					tmp.entAttName_txt.enabled = true;
					tmp.entAtt_btn.enabled = true;
					tmp.entAttName_txt.setStyle("backgroundColor","0xFFFFFF");
				}else{
					tmp.setEntity(null,null);
					tmp.entAttName_txt.enabled = false;
					tmp.entAtt_btn.enabled = false;
					tmp.entAttName_txt.text = "";
					tmp.entAttName_txt.setStyle("backgroundColor","0xDFDFDF");
				}
			}
		multiplierGroup.addEventListener("click", radioListener);
		entityGroup.addEventListener("click", radioListener2);
	}
	
	function setMultiplier(att_multiplier_id:Number,att_multiplier_name:String){
		multiplier_id = att_multiplier_id;
		multiplier_name = att_multiplier_name;
		
		attName_txt.text = multiplier_name;
	}
	
	function setEntity(att_entity_id:Number,att_entity_name:String){		
		entity_id = att_entity_id;
		entity_name = att_entity_name;
		trace("setEntity "+entity_id+" "+entity_id+" "+att_entity_id);
		
		entAttName_txt.text = entity_name;
	};

}
