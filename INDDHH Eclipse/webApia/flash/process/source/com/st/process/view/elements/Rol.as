


class com.st.process.view.elements.Rol extends MovieClip{
	
	public static var ROL_FONT_FACE:String = "k0554";
	public static var ROL_FONT_COLOR:String = "0x333333";
	public static var ROL_FONT_SIZE:String = "8";
	public static var ROL_BG_COLOR:String = "0xEEEEFF";
	public static var ROL_BORDER_COLOR:String = "0xA4CBEA";
	public static var ROL_X:Number = 10;
	public static var ROL_Y:Number = -30;
	
	var __lbl_icon:MovieClip;
	
	
	public function Rol(Void){
		
	};

	public static function createRol(name:String, target:MovieClip, p_label:String):Rol {
    	//var rl:Rol = Rol(target.attachMovie("RolSymbol", name, target.getNextHighestDepth()));
		var rl:Rol = Rol(target.attachMovie("RolSymbol", name, 11));
    		rl.init(p_label);
			
    	return rl;
  	};

	
	public function init(p_label:String):Void{
		//rIndex++;
		//trace("instance index:" + rIndex)
		
		__lbl_icon = this.createEmptyMovieClip("__lbl_icon",10);
		__lbl_icon.createTextField("rol_txt",1, ROL_X, ROL_Y, 100,24);

		__lbl_icon["rol_txt"].embedFonts = true;
		__lbl_icon["rol_txt"].autoSize = "left";
		__lbl_icon["rol_txt"].border = true;
		__lbl_icon["rol_txt"].background = true;
		__lbl_icon["rol_txt"].borderColor = ROL_BORDER_COLOR;
		__lbl_icon["rol_txt"].backgroundColor = ROL_BG_COLOR;
		__lbl_icon["rol_txt"].text = p_label.toUpperCase();
		
		var myformat = new TextFormat();
			myformat.color = ROL_FONT_COLOR;
			myformat.size = ROL_FONT_SIZE;
			myformat.font = ROL_FONT_FACE;
			myformat.align = "center" ;
			
		__lbl_icon["rol_txt"].setTextFormat(myformat);
		
	}
	
	public function destroy(){
		__lbl_icon.removeMovieClip();
	};
	

};