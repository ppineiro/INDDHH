import mx.controls.TextArea;

class com.st.process.view.infoText extends MovieClip{
	var infoTextArea:TextArea;
	var text:String="";
	
	function infoText(){
		text=this._parent.text;
		var inputs=this.createEmptyMovieClip("inputs",1);
		infoTextArea=inputs.createClassObject(TextArea,'ta',0,{_x:5,_y:5,_width:445,_height:180});	
		infoTextArea.setStyle("borderStyle", "none");
		var mc:MovieClip=inputs.attachMovie("back","mc",2,{_x:5,_y:5,_width:445,_height:180});
		mc.useHandCursor=false;
		mc.onPress=function(){
		}
		infoTextArea.editable=false;
		infoTextArea.html=true;
	}
	
	function onLoad(){
		infoTextArea.text=text;
	}

}