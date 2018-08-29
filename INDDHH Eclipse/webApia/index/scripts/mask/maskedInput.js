// Javascript Document
var maskedInputs=new Array();

function setMasks(){
	var inputs=document.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].getAttribute("p_calendar")=='true' && inputs[i].getAttribute("maskReady")!='true'){
			inputs[i].setAttribute("maskReady","true");
			setMask(inputs[i],inputs[i].getAttribute("p_mask"));
			setDTPicker(inputs[i]);
		}else if(inputs[i].getAttribute("p_mask")!=null){
			setMask(inputs[i],inputs[i].getAttribute("p_mask"));
		}
	}
}

function setMasksToNodes(node){
	var inputs=node.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].getAttribute("p_calendar")=='true'){
			setMask(inputs[i],inputs[i].getAttribute("p_mask"));
			setDTPicker(inputs[i]);
		}else if(inputs[i].getAttribute("p_mask")!=null){
			setMask(inputs[i],inputs[i].getAttribute("p_mask"));
		}
	}
}

function unsetMasksToNodes(node){
	var inputs=node.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].getAttribute("p_mask")!=null){
			unsetMask(inputs[i],inputs[i].getAttribute("p_mask"));
		}
	}
}

function setMask(input,mask){
	try{if(inFirstTr(input)){return;}}catch(e){}
	maskedInputs.push(input);
	var maskArray=mask.split("'");
	var emptyMask="";
	var mask="";
	for(var i=0;i<maskArray.length;i++){
		var subText=maskArray[i];
		var firstValue=subText.charAt(0);
		if(firstValue.toLowerCase()!="n" && firstValue.toLowerCase()!="a"){
			emptyMask+=subText.charAt(0);
		}else{
			for(var u=0;u<subText.length;u++){
				emptyMask+="_";
			}
		}
		mask+=maskArray[i];
	}
	startInputMask(mask,emptyMask,maskArray,0,input);
}

function unsetMask(input,mask){
	for(i=0;i<maskedInputs.length;i++){
		if(input==maskedInputs[i]){
			maskedInputs.splice(i,1);
			stopInputMask(input);
		}
	}
}

function startInputMask(mask,emptyMask,spaces,actualSpace,input){
	if(input.maskReady){
		return false;
	}else{
		input.maskReady=true;
	}
	input.style.position="static";
	input.style.cursor = "text";
	input.style.fontFamily = "courier new";
	input.style.fontSize = "8pt";
	input.maxLength=mask.length;
	input.mask=mask;
	input.emptyMask=emptyMask;
	if(input.readOnly==true || input.readOnly=="true"){
		input.disabled=false;
		//input.style.backgroundColor = "transparent";
	}
	input.unMaskedText="";
	if(input.value==""){
		input.value=input.emptyMask;
	}else{
		for(var i=0;i<input.value.length;i++){
			if(input.value.charAt(i)!=input.emptyMask.charAt(i)){
				input.unMaskedText+=input.value.charAt(i);
			}
		}
	}
	var maskValues="";
	for(var i=0;i<input.mask.length;i++){
		if(input.mask.charAt(i)=="n" || input.mask.charAt(i)=="a"){
			maskValues+=input.mask.charAt(i);
		}
	}
	input.maskValues=maskValues;
	addListener(input,"keydown",maskedInputEventHandler.keydown);
	
	addListener(input,"keyup",maskedInputEventHandler.keyup);
	
	addListener(input,"focus",maskedInputEventHandler.focus);
	
	addListener(input,"keypress",maskedInputEventHandler.keypress);
	
	addListener(input,"blur", maskedInputEventHandler.blur);
	
	addListener(input,"click", maskedInputEventHandler.click);
	
	input.setPosition=function(position){
		if(this.setSelectionRange){
			this.focus();
			this.setSelectionRange(position, position);
		}else if(this.createTextRange){
			var range = this.createTextRange();
			range.collapse(true);
			range.moveEnd('character', position);
			range.moveStart('character', position);
			range.select();
		}
	}
	input.updateInput=function(){
		this.value="";
		var value="";
		var actualUnMasked=0;
		var curPos=0;
		var maskValues=this.maskValues;
		var i=0;
		while(i<this.emptyMask.length && (actualUnMasked<this.unMaskedText.length)){
			var thisChar=this.mask.charAt(i);
			if((thisChar=="n" || thisChar=="a") && (actualUnMasked<=this.unMaskedText.length)){
				value+=this.unMaskedText.charAt(actualUnMasked);
				actualUnMasked++;
			}else{
				value+=this.emptyMask.charAt(i);
			}
			i++;
		}
		value+=this.emptyMask.substring(value.length,this.emptyMask.length);
		this.value=value;
		this.updateCursor();
	}
	input.updateCursor=function(){
		var finished=false;
		var i=this.emptyMask.length-1;
		while(!finished && i>=0){
			if(this.emptyMask.charAt(i)!=this.value.charAt(i)){
				this.setPosition(i);
				finished=true;
			}else{
				i--;
			}
		}
		if(this.emptyMask.charAt(i+1)!="n" && this.emptyMask.charAt(i+1)!="a"){
			//i++;
		}
		this.setPosition(i+1);
	}
	
	input.setMaskedValue=function(val){
		this.value=val;
		for(var i=0;i<this.value.length;i++){
			if(this.value.charAt(i)!=this.emptyMask.charAt(i)){
				this.unMaskedText+=this.value.charAt(i);
			}
		}
	}
	input.clear=function(){
		this.unMaskedText="";
		this.value=this.emptyMask;
	}
	input.setValue=function(val){
		this.unMaskedText="";
		for(var i=0;i<val.length;i++){
			if(val.charAt(i)!=this.emptyMask.charAt(i)){
				this.unMaskedText+=val.charAt(i);
			}
		}
		this.updateInput();
	}
	makeUnselectable(input);
}

function stopInputMask(input){
	
	input.unMaskedText=null;
	
	input.maskValues=null;
	
	removeListener(input,"keydown",maskedInputEventHandler.keydown);
	
	removeListener(input,"keyup",maskedInputEventHandler.keyup);
	
	removeListener(input,"focus",maskedInputEventHandler.focus);
	
	removeListener(input,"keypress",maskedInputEventHandler.keypress);
	
	removeListener(input,"blur", maskedInputEventHandler.blur);
	
	removeListener(input,"click", maskedInputEventHandler.click);
	
	input.setPosition=null;
	
	input.updateInput=null;

	input.updateCursor=null;
	
	input.setMaskedValue=null;

	input.clear=null;
	
	input.setValue=null;
	
	input.maskReady=false;
	//makeUnselectable(input);
	input.value="";
}

var maskedInputEventHandler={
	keydown:function(event){
		event=getEventObject(event);
		if(event.ctrlKey){
			if(event.keyCode==86){
				var input=getEventSource(event);
				input.value="";
			}
		}
		if((event.keyCode==8)||(event.keyCode==39)||(event.keyCode==37)){
			if(MSIE){
				event.keyCode=0;
			}else{
				event.preventDefault();
			}
		}
	},
	keyup:function(event){
		event=getEventObject(event);
		var input=getEventSource(event);
		if(event.ctrlKey){
			if(event.keyCode==86){
				for(var i=0;i<input.mask.length;i++){
					if(input.mask.charAt(i)=="n" || input.mask.charAt(i)=="a"){
						input.unMaskedText=input.unMaskedText+input.value.charAt(i);
					}
				}
				return;
			}
		}
		if(event.keyCode==46){
			input.unMaskedText="";
			input.updateInput();
		}
	},
	focus:function(event){
		event=getEventObject(event);
		var el=getEventSource(event);
		if(el.value!=el.emptyMask && el.value!="" &&
			 (el.emptyMask=="" || el.emptyMask==null) ) {
				el.setMaskedValue(el.value);
		}
		el.setPosition(0);
	},
	keypress:function(event){
		event=getEventObject(event);
		var el=getEventSource(event);
		if(event.keyCode==13){
			return false;
		}
		if(el.readOnly==true || el.readOnly=="true"){
			return;
		}
		var unMaskedValue="";
		event.cancelBubble=true;
		if((event.keyCode==8)){
			var newText=el.unMaskedText
			newText=newText.substring(0,(el.unMaskedText.length-1));
			el.unMaskedText=newText;
			el.updateInput();
		}else if((event.keyCode==39)||(event.keyCode==37)){
			el.updateCursor();
		}else{
			unMaskedText=el.unMaskedText;
			var maskValues=el.maskValues;
			var nextMaskChar=maskValues.charAt(unMaskedText.length);
			var code=event.charCode;
			if (MSIE){
				code=event.keyCode;
			}
			if(nextMaskChar=="n"){
				if(code>47 && code<58){
					newchar=String.fromCharCode(code);
					el.unMaskedText+=newchar;
					el.updateInput();
				}
			}else{
				newchar=String.fromCharCode(code);
				el.unMaskedText+=newchar;
				el.updateInput();
			}
		}
		if(el.unMaskedText.length>el.maskValues.length){
			el.unMaskedText=el.unMaskedText.substring(0,el.maskValues.length);
		}
		if ((el.unMaskedText.length==8) && (el.getAttribute("p_calendar")=="true")){
			valDate = isDate(el.value,"");
			if(valDate[0]==false){
				el.unMaskedText="";
				el.updateInput();
				el.focus();
				el.value=el.emptyMask;
				alert(valDate[1]);
				return null;
			}
		   //fireEvent(el,"change");
		}
	},
	blur:function(event){
		event=getEventObject(event);
		var el=getEventSource(event);
		if(el.readOnly == true){
			return;
		}
		if((el.unMaskedText.length>8) && (el.unMaskedText.length<8) && (el.getAttribute("p_calendar")=="true")){
			el.unMaskedText="";
			el.value = el.emptyMask;
		}else{
			var value=el.value;
			var valueAux="";
			var i=0;
			var termine=false;
			while(i<value.length && !termine){
				if(value.charAt(i)!="_"){
					valueAux+=value.charAt(i);
				}else if(value.charAt(i)=="_"){
					termine=true;
				}
				i++;
			}
			el.value=valueAux;
		}
		if (el.getAttribute("p_calendar")=="true" && el.emptyMask!=el.value && el.value!="") {
			valDate = isDate(el.value,"");
			if(valDate[0]==false){
				alert(valDate[1]);
				el.unMaskedText="";
				el.updateInput();
				el.focus();
			}
		}
		if(el.value==""){
			el.value=el.emptyMask;
			if(el.getAttribute("start_value") == "")
				return;
		}
		if(el.getAttribute("start_value")!=el.value){
		   fireEvent(el,"change");
		}
	},
	click:function(event){
		event=getEventObject(event);
		var el=getEventSource(event);
		var position=el.value.length;
		if(el.value==el.emptyMask){
			position=0;
		}
		if(el.value.length!=el.emptyMask.length){
			value=el.value;
			value+=el.emptyMask.substring(el.value.length,el.emptyMask.length);
			el.value=value;
		}
		el.setPosition(position);
	}
}

function setDTPicker(input){
	try{if(inFirstTr(input)){return;}}catch(e){}
	if(input.getAttribute("dtPicker")!="ready"){
		input.parentNode.style.whiteSpace="nowrap";
		if(input.parentNode.clientWidth<130){
			input.parentNode.style.width="120px";
		}
		var span=document.createElement("SPAN");
		var dtPickerStarter = null;
		//if (input.disabled == false) {
			dtPickerStarter='<input type="image" onclick="toggleDatePicker(event);return false;" id="daysOfMonthPos" name="daysOfMonthPos" style="width:22px; height:20px;" src="'+URL_STYLE_PATH+'/images/btn_cal.gif" align="absmiddle" border="0" /><span id="daysOfMonth_'+input.id+' style="position:relative;z-index:999999999999999;visibility:hidden;display:none;;" type="calendar"></span>';
		//} else {
			//dtPickerStarter='<input type="image" onclick="return false;" id="daysOfMonthPos" name="daysOfMonthPos" style="width:22px; height:20px;" src="'+URL_STYLE_PATH+'/images/btn_cal.gif" align="absmiddle" border="0" /><span id="daysOfMonth_'+input.id+' style="position:relative;z-index:999999999999999;visibility:hidden;display:none;;" type="calendar"></span>';
		//}
		span.setAttribute("dtPicker","true");
		input.setAttribute("dtPicker","ready");
		span.innerHTML=dtPickerStarter;
		
		
		span.style.display = input.style.display;
		span.style.visibility = input.style.visibility;
		
		input.parentNode.insertBefore(span,input.nextSibling);
	}
}
function unsetDTPicker(input){
	try{if(inFirstTr(input)){return;}}catch(e){}
	if(input.getAttribute("dtPicker")=="ready"){
		input.parentNode.style.whiteSpace="nowrap";
		input.setAttribute("dtPicker","");
		if(input.parentNode.clientWidth<130){
			input.parentNode.style.width="120px";
		}
		var spans=input.parentNode.getElementsByTagName("span");
		for(var i=0;i<spans.length;i++){
			if(spans[i].getAttribute("dtPicker")=="true"){
				span=spans[i];
			}
		}
		if(span){
			span.parentNode.removeChild(span);
		}
	}
}

function hideEmptyMasks(){
	for(var i=0;i<maskedInputs.length;i++){
		if(maskedInputs[i].value==maskedInputs[i].emptyMask){
			maskedInputs[i].value="";
		}
	}
}

function showEmptyMasks(){
	for(var i=0;i<maskedInputs.length;i++){
		if(maskedInputs[i].value==""){
			maskedInputs[i].value=maskedInputs[i].emptyMask;
		}
	}
}

function checkDates(){
	for(var i=0;i<maskedInputs.length;i++){
		var maskedInput=maskedInputs[i];
		if(maskedInput.getAttribute("p_calendar")=="true"){
			if(maskedInput.value!=maskedInput.emptyMask && maskedInput.value!="" &&
			 (maskedInput.unMaskedText=="" || maskedInput.unMaskedText==null) ) {
				maskedInput.setMaskedValue(maskedInput.value);
			}
			if(maskedInput.value!="" &&
				maskedInput.value!=maskedInput.emptyMask &&
				(maskedInput.unMaskedText.length!=8)){
					return false;
			}
		}
	}
	return true;
}

//mozilla defer
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", setMasks, false);
}else{
	setMasks();
}