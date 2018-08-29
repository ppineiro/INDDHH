

class com.st.process.view.elements.Operator extends com.st.process.view.elements.Element{

	var LABEL_FONT_FACE:String = "k0554";
	var LABEL_FONT_COLOR:String = "0x000000";
	var LABEL_FONT_SIZE:String = "8";
	
	var att_ope_id:Number;		//element ope_id

	
	public function Operator(Void){
		
		var lbl_att:Array = [LABEL_FONT_FACE,LABEL_FONT_COLOR,LABEL_FONT_SIZE];
		var lbl_pos:Array = [-13,-8,26,16]; //_x,_y,_w,_h
		
		switch(att_ope_id){
			case 3: // operator V
				//	"OR"; //	|=
				att_label = "OR";
				setElementLabel(this,lbl_pos,lbl_att);
				this.gotoAndStop("_yellow");
			break;
			case 2: // operator A
				//	"AND";	//	&=
				att_label = "AND";
				setElementLabel(this,lbl_pos,lbl_att);
				this.gotoAndStop("_green");
			break;
			case 1: // operator X
				//	"XOR";	//	^=
				att_label = "XOR";
				setElementLabel(this,lbl_pos,lbl_att);
				this.gotoAndStop("_red");
			break;
		};

	};
		
}