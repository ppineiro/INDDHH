import mx.controls.ComboBox;
import mx.controls.Button;

class com.st.formDesigner.view.EntityAttributes extends MovieClip{
var confirm_btn:Button;
var cancel_btn:Button;
var atts:Array;
var att_cmb:ComboBox;
var idSelected:Number;
	function EntityAttributes(Void){
		
		var thisModal = this;
		atts=thisModal._parent.atts;
		
		//CANCEL
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		//CONFIRM
		this.confirm_btn.onPress = function() {
			var att_cmb = thisModal.att_cmb;
			thisModal.idSelected=att_cmb.selectedItem.data;
			var desc:String=att_cmb.selectedItem.label;
			var cod:Number=thisModal.idSelected;
			thisModal._parent.dispatchEvent({type:"ok",cod:cod,desc:desc});
		};
	};

	function onLoad(){
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		var att_array:Array=atts;
		for (var e=0;e < att_array.length;e++) {
			var col_id = att_array[e].a;
			var col_name = att_array[e].b;
			att_cmb.addItem(col_name,col_id);
			}
		}
	};	
