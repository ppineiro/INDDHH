

class com.st.util.Util{
	
	
	public function Util(){
	};
	
	public static function createLabel(targetMc:MovieClip,lbl:String,pos:Array,att:Array):TextField{
		//targetMc.createTextField("ico_txt5",targetMc.getNextHighestDepth(),pos[0],pos[1],pos[2],pos[3]);
		targetMc.createTextField("ico_txt5",90,pos[0],pos[1],pos[2],pos[3]);
		targetMc["ico_txt5"].type = "dynamic";
		targetMc["ico_txt5"].embedFonts = true;
		targetMc["ico_txt5"].text = lbl.toUpperCase();
		targetMc["ico_txt5"].multiline = true;
		targetMc["ico_txt5"].wordWrap = true;
		targetMc["ico_txt5"].border = true;
		targetMc["ico_txt5"].background = true;
		targetMc["ico_txt5"].borderColor = att[4];
		targetMc["ico_txt5"].backgroundColor = att[3];
		
		/////////////
		//comment autosize to make it autosize in height
		targetMc["ico_txt5"].autoSize = "center";
		/////////////
		var myformat = new TextFormat();
			myformat.font = att[0];
			myformat.color = att[1];
			myformat.size = att[2];
			myformat.align = "center";
		targetMc["ico_txt5"].setTextFormat(myformat);
		
		return targetMc["ico_txt5"];
	};
	
	
	public static function removeLabel(obj_txt:TextField){
		obj_txt.removeTextField();
	};
	
};