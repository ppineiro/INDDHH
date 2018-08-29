


import mx.controls.TextInput;
import mx.controls.Button;

class com.st.process.view.dialogs.NameModal extends MovieClip{
	var name_txt:TextInput;
	var confirm_btn:Button;
	var cancel_btn:Button;
	var nameValue:String;
	
	function NameModal(Void){
		mx.events.EventDispatcher.initialize(this);
		var thisModal = this;
		nameValue =  thisModal._parent.nameValue;
		
		
		this.confirm_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"ok",name:thisModal.name_txt.text});
		};
		
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
	};
	
	function onLoad(){
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		if(nameValue!="undefined" && nameValue!=null){
			name_txt.text = nameValue;
		}
	};

}