


import com.st.process.view.elements.Rol;

class com.st.process.view.elements.Task extends com.st.process.view.elements.Element{
	
	var LABEL_FONT_FACE:String = "k0554";
	var LABEL_FONT_COLOR:String = "0x333333";
	var LABEL_FONT_SIZE:String = "8";
	var LABEL_BG_COLOR:String = "0xEEEEFF";
	var LABEL_BORDER_COLOR:String = "0xA4CBEA";
	 
	
	var __rolmc:Rol;
	
	
	public function Task(Void){
		var lbl_att:Array = [LABEL_FONT_FACE,LABEL_FONT_COLOR,LABEL_FONT_SIZE];
		var lbl_pos:Array = [-50,22,100,24]; //_x,_y,_w,_h
		setElementLabel(this,lbl_pos,lbl_att);
	};
	
	
	function showRol(p_label:String){
		__rolmc = Rol.createRol("rolObj", this, p_label);
		
	};

	function hideRol(){
		__rolmc.destroy();
	};
	
	
};
