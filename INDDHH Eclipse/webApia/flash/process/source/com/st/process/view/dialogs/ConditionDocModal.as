
import mx.controls.Alert;
import mx.controls.TextArea;
import mx.controls.Button;
import com.qlod.LoaderClass;

class com.st.process.view.dialogs.ConditionDocModal extends MovieClip{
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	var cnd_txt:TextArea;
	
	var conditionDocValue:String;
	
	var oLoader:LoaderClass;
	
	function ConditionDocModal(Void){
		var thisModal = this;
		conditionDocValue = thisModal._parent.conditionDocValue;
		
		 this.confirm_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"ok",conditionDocValue:thisModal.cnd_txt.text});
		 };
		 
		 this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
	};
	
	
	function onLoad(){
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		cnd_txt.setStyle("fontFamily","courier");
		
		//SET CONDITIONDOC TXT
		if(conditionDocValue!=null && conditionDocValue!=undefined && conditionDocValue!=""){
			cnd_txt.text = conditionDocValue;
		}else{
			cnd_txt.text = "";
		}
		
	};
	
}