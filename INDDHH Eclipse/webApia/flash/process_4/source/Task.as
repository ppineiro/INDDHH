


class Task extends Element{
	var m_taskId:Number;		//task task_id
	var m_name:String;			//task Label
	
	var m_rolId:Number;			//task rol_id
	var m_rolName:String;		//task rol name
	
	var m_process_form_array:Array;	//element task process forms
	var m_entity_form_array:Array;	//element task entity forms
	
	var m_events_array:Array; 		//task events array
	var m_pool_array:Array;			//task pool array
	
		
	function Task(Void){
		this._x = Math.floor(this._x);
		this._y = Math.floor(this._y);
		
		setIconLabel(m_name);
		
		if(m_rolId!=null){
			addRol(m_rolId,m_rolName);
		}
		
	};
	
	function addRol(p_id,p_label){
		var oRol = this.attachMovie("Rol", 'Rol', 1, {
				m_rolId:p_id,
				m_rolName:p_label
			});
		m_rolId = p_id;
		m_rolName = p_label;
	};
	
	function removeRol(){
		this["Rol"].removeMovieClip();
		m_rolId = null;
		m_rolName = null;
	};
	
	function setIconLabel(label_str:String){
		m_name = label_str;
		
		var ROL_FONT_FACE = "k0554";
		var ROL_FONT_COLOR = "0x333333";
		var ROL_FONT_SIZE = "8";
		var ROL_BG_COLOR = "0xEEEEFF";
		var ROL_BORDER_COLOR = "0xA4CBEA";

		this.createTextField("ico_txt",this.getNextHighestDepth(),-50,22,100,24);
			//createTextField("mytext",depth,_x,_y,_w,_h);
		this["ico_txt"].type = "dynamic";
		this["ico_txt"].embedFonts = true;
		this["ico_txt"].text = label_str.toUpperCase();
		//this["ico_txt"].border = true;
		//this["ico_txt"].background = true;
		//this["ico_txt"].borderColor = ROL_BORDER_COLOR;
		//this["ico_txt"].backgroundColor = ROL_BG_COLOR;
		
		this["ico_txt"].multiline = true;
		this["ico_txt"].wordWrap = true;
		
		/////////////
		//comment autosize to make it autosize in height
		this["ico_txt"].autoSize = "center";
		/////////////
		
		var myformat = new TextFormat();
			myformat.color = ROL_FONT_COLOR;
			myformat.size = ROL_FONT_SIZE;
			myformat.font = ROL_FONT_FACE;
			myformat.align = "center" ;
		this["ico_txt"].setTextFormat(myformat);
		
		//trace(":::::" + maxViewable(this["ico_txt"]));
		//stripText(this["ico_txt"]);
		//var visibleLines = textField.bottomScroll - (textField.scroll - 1);

	};
	
	///////////////////////////////////////////////////////
	//returns nro of viewable lines in a wrapped textfield
	//////////////////////////////////////////////////////
	function maxViewable(ObjTextField:TextField) {
		if (ObjTextField.maxscroll>1) return ObjTextField.bottomScroll;
		var b = (ObjTextField.html) ? ObjTextField.bottomScroll-1 : ObjTextField.bottomScroll;
		if (!ObjTextField.length) ObjTextField.text = "»";
		var out = Math.floor(ObjTextField._height/(ObjTextField.textHeight/b));
		if (ObjTextField.text == "»") ObjTextField.text = "";
		return out;
	};
	function stripText(objTextField:TextField,maxWidth:Number){
		if (maxWidth == undefined) maxWidth = objTextField._width
		maxWidth -= 4 //safety range
		_root.createTextField("dummyStriptextField", 123466987,999,999,9999,200)
		_root.dummyStriptextField.html = true
		var origHtmlType = objTextField.html
		objTextField.html = true
		_root.dummyStriptextField.type = objTextField.type
		_root.dummyStriptextField.setTextFormat(objTextField.getTextFormat())
		_root.dummyStriptextField.htmlText = objTextField.htmlText;
		var tWidth = _root.dummyStriptextField.textWidth;
		if (tWidth > maxWidth) {
			var t = objTextField.htmltext
			while (tWidth > maxWidth) {
				t = t.substr(0,t.length-1)
				_root.dummyStriptextField.htmlText = t + " ..."
				tWidth = _root.dummyStriptextField.textWidth
			}
			objTextField.htmlText = t + " ..."
		}
		objTextField.html = origHtmlType
		delete _root.dummyStriptextField
	}
	
	
	//---------------------------------------------------
	//				FORM FUNCTIONS
	//---------------------------------------------------
	function addProcessForm(p_ObjForm:Object){
		m_process_form_array.push(p_ObjForm);
	};
	
}
