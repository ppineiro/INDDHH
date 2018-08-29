function setNumeric(input){
	input.checkNumeric=function(){
		var element=this;
		if(window.event){
			element=window.event.srcElement;
		}
		if(element.value == ""){
			return;
		}
		
		var regExp = "";
		
		if(element.getAttribute("integer")!=null){
			regExp = /(^-?\d\d*$)/
		} else if (element.getAttribute("maskRegExp")!=null) {	
			regExp = new RegExp(element.getAttribute("maskRegExp"));
		} else {
			regExp = objNumRegExp;	
		}
		if(!regExp.test(element.value))	{	
			var i=element.value.length-1;
			while(!regExp.test(element.value) && i>=0){		
				element.value = element.value.substring(0, element.value.length-1);
				i--;
			}
			return;
			var pEl = element;
			while (pEl.parentNode.tagName != "TD"){
				pEl = pEl.parentNode;
			}
			
			var ingrid=false;
			var containerGrid=pEl.parentNode;
			while (containerGrid.tagName != "BODY"){
				containerGrid=containerGrid.parentNode;
				if(containerGrid && containerGrid.getAttribute("type")=="grid"){
					ingrid=true;
					break;
				}
			}
	
			if(element.getAttribute("grid") == "true" || ingrid) {
				if(element.getAttribute("colLabel")){
					pvntLabel = element.getAttribute("colLabel");
				}else{
					var index=(MSIE)?pEl.parentNode.cellIndex+1:pEl.parentNode.cellIndex;
					pvntLabel = containerGrid.getElementsByTagName("TH")[index].getElementsByTagName("SPAN")[0].innerHTML;
				}
			} else{
				var lastTd=pEl.parentNode.previousSibling;
				if(lastTd.tagName!="TD"){
					lastTd=lastTd.previousSibling;
				}
				pvntLabel = lastTd.innerHTML;
			}
			
			vLabel = replace(pvntLabel, ":","");
			vLabel = removeHTMLChars(vLabel);
	
				
			i = GNR_NUMERIC.indexOf("<TOK1>");
			alert(GNR_NUMERIC.substring(0,i)+ vLabel +GNR_NUMERIC.substring(i+6,GNR_NUMERIC.length));
			
			element.value="";
			var funcAux=function(){
				element.focus();
			}
			setTimeout(funcAux,300);
			
		}
	}
	
	input.validate=function(e){
		e=getEventObject(e);
		var element=getEventSource(e);
		validateNumber(element);
		 validating = false;
	}
	
	input.setEditing=function(){
		validating = true;
	}
	
	if (executionMode==false){
		if (document.addEventListener) {
	  		input.addEventListener("blur", input.validate, false);
	  		//input.addEventListener("keyup", input.checkNumeric, false);
	  		//input.addEventListener("focus", input.setEditing, false);
		}else{
			addListener(input,"blur", input.validate);
			//addListener(input,"keyup", input.checkNumeric)
			//addListener(input,"focus", input.setEditing);
		}	
	}
}

function setNumericField(fld){
	setNumeric(fld);
	addListener(fld,"blur",fld.validate);
	addListener(fld,"focus",fld.setEditing);
}

function unsetNumeric(input){
	input.checkNumeric=null;
	input.validate=null;
	input.setEditing=null;
}

function unsetNumericField(fld){
	removeListener(fld,"blur",fld.validate);
	removeListener(fld,"focus",fld.setEditing);
	unsetNumeric(fld);
}

function validateNumber(element){
	if(element.value == "" || element.getAttribute("p_numeric")==null){
		//validating = false;
		return true;
	}
	var regExp = "";
	
	if(element.getAttribute("integer")!=null){
		regExp = /(^-?\d\d*$)/
	} else if (element.getAttribute("maskRegExp")!=null) {	
		regExp = new RegExp(element.getAttribute("maskRegExp"));
	} else {
		regExp = objNumRegExp;	
	}

	if(!regExp.test(element.value))	{	
		var pEl = element;
		while (pEl.parentNode.tagName != "TD"){
			pEl = pEl.parentNode;
		}
			

		if(element.getAttribute("grid") == "true") {
			pvntLabel = element.getAttribute("colLabel");
		} else{
			var lastTd=pEl.parentNode.previousSibling;
			if(lastTd.tagName!="TD"){
				lastTd=lastTd.previousSibling;
			}
			pvntLabel = lastTd.innerHTML;
		}
		
		vLabel = replace(pvntLabel, ":","");
		vLabel = removeHTMLChars(vLabel);

			
		i = GNR_NUMERIC.indexOf("<TOK1>");
		alert(GNR_NUMERIC.substring(0,i)+ vLabel +GNR_NUMERIC.substring(i+6,GNR_NUMERIC.length));
		//validating = true;
		element.value="";
		if(element.type!="hidden"){
			element.focus();
		}
		return false;
		
	}
	//validating = false;
	return true;
}

