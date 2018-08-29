



class com.st.process.view.elements.SubProcess extends com.st.process.view.elements.Element{
		
	var LABEL_FONT_FACE:String = "k0554";
	var LABEL_FONT_COLOR:String = "0x333333";
	var LABEL_FONT_SIZE:String = "8";
	
	var TYPE_FONT_FACE:String = "k0554";
	var TYPE_FONT_COLOR:String = "0x333333";
	var TYPE_FONT_SIZE:String = "8";
	var TYPE_BG_COLOR:String = "0xEFEFEF";
	var TYPE_BORDER_COLOR:String = "0xDFDFDF";
	
	var __iterateIconMc:MovieClip;
	var __conditionIconMc:MovieClip;
	var __type_txt:TextField;
	
	
    public function SubProcess(Void){
		var lbl_att:Array = [LABEL_FONT_FACE,LABEL_FONT_COLOR,LABEL_FONT_SIZE];
		var lbl_pos:Array = [-50,28,100,24]; //_x,_y,_w,_h
		
		setElementLabel(this,lbl_pos,lbl_att);
    };
	
	
	public function setType(att_pro_type:String){
		var lbl_k = _global.labelVars.lbl_processContext11;
		var lbl_j = _global.labelVars.lbl_processContext12;
		var lbl_sync = _global.labelVars.lbl_processContext10;
		var lbl_async = _global.labelVars.lbl_processContext9;
		
		var lbl_att:Array = [TYPE_FONT_FACE,TYPE_FONT_COLOR,TYPE_FONT_SIZE,TYPE_BG_COLOR,TYPE_BORDER_COLOR];
		var lbl_pos:Array = [-40,-40,80,24]; //_x,_y,_w,_h
		if(__type_txt){
			com.st.util.Util.removeLabel(__type_txt);
		}
		//set process type marker
		switch(att_pro_type){
			case "m": 
			break;
			case "a": 
				__type_txt = com.st.util.Util.createLabel(this,lbl_async,lbl_pos,lbl_att);
			break;
			case "s": 
				__type_txt = com.st.util.Util.createLabel(this,lbl_sync,lbl_pos,lbl_att);
			break;
			case "j": 
				__type_txt = com.st.util.Util.createLabel(this,lbl_j,lbl_pos,lbl_att);
			break;
			case "k": 
				__type_txt = com.st.util.Util.createLabel(this,lbl_k,lbl_pos,lbl_att);
			break;
			default:
		}
	};
	
	
	public function iterate(iterate:Boolean):Void{
		if(iterate){
			__iterateIconMc = this.attachMovie("iteration", '__iteratemc', 1,{
				_x:-12,
				_y:-12
			});
		}else{
			__iterateIconMc.removeMovieClip();
		}
	};
	
	public function setCondition(condition:Boolean){
		if(condition){
			__conditionIconMc = this.attachMovie("condition", 'Condition', 2, {
			_x:36,
			_y:30
			});
		}else{
			__conditionIconMc.removeMovieClip();
		}
	};
	
		
}