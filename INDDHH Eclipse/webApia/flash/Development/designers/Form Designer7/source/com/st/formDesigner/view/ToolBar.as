
import mx.events.EventDispatcher;

class com.st.formDesigner.view.ToolBar extends MovieClip{
	
	var toolTip:com.st.formDesigner.view.ToolTipClass;
	
	var input_btn:MovieClip;
	var label_btn:MovieClip;
	var radio_btn:MovieClip;
	var checkbox_btn:MovieClip;
	var password_btn:MovieClip;
	var button_btn:MovieClip;
	var textarea_btn:MovieClip;
	var listbox_btn:MovieClip;
	var combobox_btn:MovieClip;
	var subtitle_btn:MovieClip;
	var file_btn:MovieClip;
	var hidden_btn:MovieClip;
	var img_btn:MovieClip;
	var grid_btn:MovieClip;
	
	
	function ToolBar(Void){
		mx.events.EventDispatcher.initialize(this);
		var t = this;
		toolTip = new com.st.formDesigner.view.ToolTipClass(_root);
		
		var lblToolInput = _global.labelVars.lblToolInput;
		var lblToolListbox = _global.labelVars.lblToolListbox;
		var lblToolCombobox = _global.labelVars.lblToolCombobox;
		var lblToolCheck = _global.labelVars.lblToolCheck;
		var lblToolRadio = _global.labelVars.lblToolRadio;
		var lblToolPass = _global.labelVars.lblToolPass;
		var lblToolTxtArea = _global.labelVars.lblToolTxtArea;
		var lblToolLabel = _global.labelVars.lblToolLabel;
		var lblToolSubTit = _global.labelVars.lblToolSubTit;
		var lblToolFile = _global.labelVars.lblToolFile;
		var lblToolHidden = _global.labelVars.lblToolHidden;
		var lblToolButton = _global.labelVars.lblToolButton;
		var lblToolImage = _global.labelVars.lblToolImage;
		var lblToolGrid = _global.labelVars.lblToolGrid;
		
		//------------------------------------------------------------------
		//BUTTONS
		//case 1: //INPUT
		this.input_btn.onPress = function(){t.dragElement(this,"input_ico")};
		this.input_btn.onRelease = function(){t.dropRelease(this)};
		this.input_btn.onReleaseOutside = function(){t.dropElement(this,1)};
		this.input_btn.onRollOver = function(){t.showToolTip(lblToolInput)};
		this.input_btn.onRollOut = function(){t.hideToolTip()};
		//case 2: //COMBOBOX
		this.combobox_btn.onPress = function(){t.dragElement(this,"combobox_ico")};
		this.combobox_btn.onRelease = function(){t.dropRelease(this)};
		this.combobox_btn.onReleaseOutside = function(){t.dropElement(this,2)};
		this.combobox_btn.onRollOver = function(){t.showToolTip(lblToolCombobox)};
		this.combobox_btn.onRollOut = function(){t.hideToolTip()};
		//case 3: //CHECKBOX
		this.checkbox_btn.onPress = function(){t.dragElement(this,"checkbox_ico")};
		this.checkbox_btn.onRelease = function(){t.dropRelease(this)};
		this.checkbox_btn.onReleaseOutside = function(){t.dropElement(this,3)};
		this.checkbox_btn.onRollOver = function(){t.showToolTip(lblToolCheck)};
		this.checkbox_btn.onRollOut = function(){t.hideToolTip()};
		//case 4: //RADIO
		this.radio_btn.onPress = function(){t.dragElement(this,"radio_ico")};
		this.radio_btn.onRelease = function(){t.dropRelease(this)};
		this.radio_btn.onReleaseOutside = function(){t.dropElement(this,4)};
		this.radio_btn.onRollOver = function(){t.showToolTip(lblToolRadio)};
		this.radio_btn.onRollOut = function(){t.hideToolTip()};
		//case 5: //BUTTON
		this.button_btn.onPress = function(){t.dragElement(this,"button_ico")};
		this.button_btn.onRelease = function(){t.dropRelease(this)};
		this.button_btn.onReleaseOutside = function(){t.dropElement(this,5)};
		this.button_btn.onRollOver = function(){t.showToolTip(lblToolButton)};
		this.button_btn.onRollOut = function(){t.hideToolTip()};
		//case 6: //TEXTAREA
		this.textarea_btn.onPress = function(){t.dragElement(this,"textarea_ico")};
		this.textarea_btn.onRelease = function(){t.dropRelease(this)};
		this.textarea_btn.onReleaseOutside = function(){t.dropElement(this,6)};
		this.textarea_btn.onRollOver = function(){t.showToolTip(lblToolTxtArea)};
		this.textarea_btn.onRollOut = function(){t.hideToolTip()};
		//case 7: //LABEL
		this.label_btn.onPress = function(){t.dragElement(this,"label_ico")};
		this.label_btn.onRelease = function(){t.dropRelease(this)};
		this.label_btn.onReleaseOutside = function(){t.dropElement(this,7)};
		this.label_btn.onRollOver = function(){t.showToolTip(lblToolLabel)};
		this.label_btn.onRollOut = function(){t.hideToolTip()};
		//case 8: //SUBTITLE
		this.subtitle_btn.onPress = function(){t.dragElement(this,"subtitle_ico")};
		this.subtitle_btn.onRelease = function(){t.dropRelease(this)};
		this.subtitle_btn.onReleaseOutside = function(){t.dropElement(this,8)};
		this.subtitle_btn.onRollOver = function(){t.showToolTip(lblToolSubTit)};
		this.subtitle_btn.onRollOut = function(){t.hideToolTip()};
		//case 9: //FILE
		this.file_btn.onPress = function(){t.dragElement(this,"upload_icon")};
		this.file_btn.onRelease = function(){t.dropRelease(this)};
		this.file_btn.onReleaseOutside = function(){t.dropElement(this,9)};
		this.file_btn.onRollOver = function(){t.showToolTip(lblToolFile)};
		this.file_btn.onRollOut = function(){t.hideToolTip()};
		//case 10: //LISTBOX
		this.listbox_btn.onPress = function(){t.dragElement(this,"listbox_ico")};
		this.listbox_btn.onRelease = function(){t.dropRelease(this)};
		this.listbox_btn.onReleaseOutside = function(){t.dropElement(this,10)};
		this.listbox_btn.onRollOver = function(){t.showToolTip(lblToolListbox)};
		this.listbox_btn.onRollOut = function(){t.hideToolTip()};
		//case 11: //HIDDEN
		this.hidden_btn.onPress = function(){t.dragElement(this,"hidden_ico")};
		this.hidden_btn.onRelease = function(){t.dropRelease(this)};
		this.hidden_btn.onReleaseOutside = function(){t.dropElement(this,11)};
		this.hidden_btn.onRollOver = function(){t.showToolTip(lblToolHidden)};
		this.hidden_btn.onRollOut = function(){t.hideToolTip()};
		//case 12: //PASSWORD
		this.password_btn.onPress = function(){t.dragElement(this,"password_ico")};
		this.password_btn.onRelease = function(){t.dropRelease(this)};
		this.password_btn.onReleaseOutside = function(){t.dropElement(this,12)};
		this.password_btn.onRollOver = function(){t.showToolTip(lblToolPass)};
		this.password_btn.onRollOut = function(){t.hideToolTip()};
		//case 13: //IMAGE
		this.img_btn.onPress = function(){t.dragElement(this,"img_ico")};
		this.img_btn.onRelease = function(){t.dropRelease(this)};
		this.img_btn.onReleaseOutside = function(){t.dropElement(this,13)};
		this.img_btn.onRollOver = function(){t.showToolTip(lblToolImage)};
		this.img_btn.onRollOut = function(){t.hideToolTip()};
		//case 14: //GRID
		this.grid_btn.onPress = function(){t.dragElement(this,"grid_ico")};
		this.grid_btn.onRelease = function(){t.dropRelease(this)};
		this.grid_btn.onReleaseOutside = function(){t.dropElement(this,14)};
		this.grid_btn.onRollOver = function(){t.showToolTip(lblToolGrid)};
		this.grid_btn.onRollOut = function(){t.hideToolTip()};
	};
	
	function dragElement(oBtn,oDrag){
		hideToolTip();
		var pX = _root._xmouse - oBtn._width/2;
		var pY = _root._ymouse - oBtn._height/2;
		var dragDummy = _root.attachMovie(oDrag,"btnDrag",1000,{_x:pX,_y:pY,_alpha:50});
		oBtn.onMouseMove = function(){
				dragDummy._x = _root._xmouse - dragDummy._width/2;
				dragDummy._y = _root._ymouse - dragDummy._height/2;
				updateAfterEvent();
		};
	};
	
	function dropElement(oBtn,p_type){
		oBtn.onMouseMove = null;
		if(_root["btnDrag"].hitTest(_root.scrollPane)){
			oBtn._parent.dispatchEvent({type:"onNewElementDropped",obj:_root["btnDrag"],el_type:p_type});
		}
		_root["btnDrag"].removeMovieClip();
	};
	
	function dropRelease(oBtn){
		oBtn.onMouseMove = null;
		_root["btnDrag"].removeMovieClip();
	};
	
	function showToolTip(p_txt:String){
		toolTip.setText(p_txt + " ");
	};
	
	function hideToolTip(){
		toolTip.clearText();
	};
	
}