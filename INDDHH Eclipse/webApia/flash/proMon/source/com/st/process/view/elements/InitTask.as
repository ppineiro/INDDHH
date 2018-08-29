

class com.st.process.view.elements.InitTask extends com.st.process.view.elements.Element{
		
	var LABEL_FONT_FACE:String = "k0554";
	var LABEL_FONT_COLOR:String = "0x333333";
	var LABEL_FONT_SIZE:String = "8";
		
	public function InitTask(Void){
		var lbl_att:Array = [LABEL_FONT_FACE,LABEL_FONT_COLOR,LABEL_FONT_SIZE];
		var lbl_pos:Array = [-50,16,100,24]; //_x,_y,_w,_h
		setElementLabel(this,lbl_pos,lbl_att);
    };
	
		
};

