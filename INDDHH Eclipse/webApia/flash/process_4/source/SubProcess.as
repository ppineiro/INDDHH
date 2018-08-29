

class SubProcess extends Element{
		
	var m_pro_id:Number; 	//element pro_id
	var m_name:String;		//element Label
	var m_iterate:Boolean; 
	var m_condition:String;
	
    function SubProcess(Void){
		setIconLabel(m_name);
		
		if(m_iterate){
			//trace("ITERATE")
			addIteration();
		}
    };
	
	function isIterated(){
		return m_iterate;
	};
	
	function addIteration(){
		var aux = this.attachMovie("iteration", 'iteration', 1,{
			_x:-12,
			_y:-12
		});
		m_iterate = true;
	};
	
	function removeIteration(){
		this["iteration"].removeMovieClip();
		m_iterate = false;
	};
	
	function getCondition():String{
		return m_condition;
	};
	
	function setCondition(p_condition:String){
		if(p_condition==undefined ||p_condition==null)p_condition=="";
		m_condition = p_condition;
	};
	
	function setIconLabel(label_str:String){
		m_name = label_str;
	
		var ROL_FONT_FACE = "k0554";
		var ROL_FONT_COLOR = "0x333333";
		var ROL_FONT_SIZE = "8";
		var ROL_BG_COLOR = "0xEEEEFF";
		var ROL_BORDER_COLOR = "0xA4CBEA";

		this.createTextField("ico_txt",this.getNextHighestDepth(),-50,28,100,24);
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
	
		
}