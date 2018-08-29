function _valNumberFormat(){
	if(element.value == ""){
		return;
	}
	var regExp = "";
	if(element.integer!=null){
		regExp = /(^-?\d\d*$)/
	} else if (element.maskRegExp!=null) {	
		regExp = new RegExp(element.maskRegExp);
	} else {
		regExp = objNumRegExp;	
	}
	if(!regExp.test(element.value))	{	
								
		var pEl = element;
		while (pEl.parentNode.tagName != "TD"){
			pEl = pEl.parentNode;
		}
			

		if(element.grid == "true") {
			pvntLabel = element.colLabel;
		} else{
			pvntLabel = pEl.parentNode.previousSibling.innerText;
		}
		
		vLabel = replace(pvntLabel, ":","");
		vLabel = removeHTMLChars(vLabel);

			
		i = GNR_NUMERIC.indexOf("<TOK1>");
		alert(GNR_NUMERIC.substring(0,i)+ vLabel +GNR_NUMERIC.substring(i+6,GNR_NUMERIC.length));
		
		element.value="";
		element.focus();
		
	}
	
}