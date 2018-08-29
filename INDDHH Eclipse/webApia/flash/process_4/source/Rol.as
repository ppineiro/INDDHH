


class Rol extends MovieClip{
	
		var m_rolId:Number;		//element rol_id
		var m_rolName:String;
		
		var ROL_FONT_FACE = "k0554";
		var ROL_FONT_COLOR = "0x333333";
		var ROL_FONT_SIZE = "8";
		var ROL_BG_COLOR = "0xEEEEFF";
		var ROL_BORDER_COLOR = "0xA4CBEA";
		
        function Rol(Void){
			var myformat = new TextFormat();
				myformat.color = ROL_FONT_COLOR;
				myformat.size = ROL_FONT_SIZE;
				myformat.font = ROL_FONT_FACE;
			
			var aux:MovieClip = this.createEmptyMovieClip("rolLabel_mc",3);
			this["rolLabel_mc"].createTextField("nameTxt",1,28,-22,100,20);
						  //createTextField("mytext",depth,_x,_y,_w,_h);
			this["rolLabel_mc"].nameTxt.embedFonts = true;
			this["rolLabel_mc"].nameTxt.autoSize = "left";
			this["rolLabel_mc"].nameTxt.border = true;
			this["rolLabel_mc"].nameTxt.text = m_rolName.toUpperCase();
			this["rolLabel_mc"].nameTxt.background = true;
			this["rolLabel_mc"].nameTxt.borderColor = ROL_BORDER_COLOR;
			this["rolLabel_mc"].nameTxt.backgroundColor = ROL_BG_COLOR;
			
			this["rolLabel_mc"].nameTxt.setTextFormat(myformat);
			
        };
}

