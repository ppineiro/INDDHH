

class Operator extends Element{

	var m_opeId:Number;		//element ope_id
	
	var font_color:String;
	
	function Operator(Void){
		switch(m_opeId){
			case 3: // operator V
				//	"OR"; //	|=
				font_color = "0x000000";
				setName("OR");
				this.gotoAndStop("_yellow");
			break;
			case 2: // operator A
				//	"AND";	//	&=
				font_color = "0x000000";
				setName("AND");
				this.gotoAndStop("_green");
			break;
			case 1: // operator X
				//	"XOR";	//	^=
				font_color = "0x000000";
				setName("XOR");
				this.gotoAndStop("_red");
			break;
		};

	};
	
	function setName(p_name:String){
		var myformat = new TextFormat();
			myformat.color = font_color;
			myformat.size = "8";
			myformat.font = "k0554";
			myformat.align = "center";
		
		this.createTextField("label_txt",this.getNextHighestDepth(),-13,-8,26,16);
			//createTextField("mytext",depth,_x,_y,_w,_h);
		
		//this["label_txt"].border = true;
		this["label_txt"].embedFonts = true;
		this["label_txt"].text = p_name.toUpperCase();
		this["label_txt"].setTextFormat(myformat);
		
	};
		
}