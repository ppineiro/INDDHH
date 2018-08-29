var requiredFields=new Array();
function setRequiredFields(){
	var inputs=document.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].getAttribute("p_required")=="true"){
			setRequiredField(inputs[i]);
		}
	}
	var textAreas=document.getElementsByTagName("TEXTAREA");
	for(var i=0;i<textAreas.length;i++){
		if(textAreas[i].getAttribute("p_required")=="true"){
			setRequiredField(textAreas[i]);
		}
	}
}

function isReqAdded(field){
	for(var i=0;i<requiredFields.length;i++){
		if(field==requiredFields[i]){
			return true;
		}
	}
	return false;
}

function setRequiredField(field){
	
	if(field.id.indexOf("hidRad")>=0 || field.type=="radio"){
		setRequiredRadio(field);
		return;
	}
	var hasReqSpan=false;
	/*
	var spans=field.parentNode.getElementsByTagName("SPAN");
	for(var i=0;i<spans.length;i++){
		if(spans[i].getAttribute("required")=="true" && spans[i].style.display != "none"){
			hasReqSpan=true;
		}
	}
	*/
	if (field.parentNode.innerHTML.indexOf("*") > 0) {
		var spans = field.parentNode.getElementsByTagName("SPAN");		
		for (var i = 0; i < spans.length; i++) {
			if (spans[i].innerHTML.indexOf("*") >= 0) {
				hasReqSpan = true;
				break;
			}
		}
	}
	if(!hasReqSpan){
		var span = document.createElement("SPAN");
		field.setAttribute("p_required","true");
		span.setAttribute("required","true");
		span.style.whiteSpace="nowrap";
		span.innerHTML=" *";
		var beforeMe = field;
		if(beforeMe.nextSibling && beforeMe.nextSibling.tagName=="SPAN" && beforeMe.nextSibling.getAttribute("dtpicker")=="true"){
			beforeMe=beforeMe.nextSibling;
		}
		field.parentNode.insertBefore(span,beforeMe.nextSibling);
		field.parentNode.style.whiteSpace="nowrap";
		
		if(req_align == req_align_before) {
			//Movemos el asterisco
			var aster_span = document.createElement("SPAN");
			aster_span.innerHTML="* ";
			
			//span.setAttribute("style", "display:none");
			
			var field_parent = field.parentNode;
			
			//Verificar que no sea una grilla
			while(field_parent.nodeName != "TD") {
				field_parent = field_parent.parentNode;
			}
			
			if(!(field.getAttribute("req_desc") != null || field.getAttribute("req_desc") != undefined ||
					field_parent.getAttribute("req_desc") != null || field_parent.getAttribute("req_desc") != undefined)) {
				//No se esta en una grilla
				
				var brother = field.parentNode.previousSibling;
				if(brother==null){
					brother = field.parentNode.parentNode.previousSibling;
				}
				while(brother != null && brother.nodeName != "TD") {
					brother = brother.previousSibling;					
				}
				if(brother == null) {					
					if(field.parentNode.parentNode != null){
						brother = field.parentNode.parentNode.previousSibling;
					}
					while(brother != null && brother.nodeName != "TD") {
						brother = brother.previousSibling;					
					}
				}
				try {
					brother.insertBefore(aster_span, brother.firstChild);				
					span.style.display = "none";				
				} catch(e) {}
			}
		}
	}
	requiredFields.push(field);
}

function unsetRequiredField(field){
	if(field.id.indexOf("hidRad")>=0 || field.type=="radio"){
		var id=field.id;
		if(field.id.indexOf("hidRad")<0){
			id="hidRad_"+field.id;
		}
		field=document.getElementById(id);
		unSetRequiredRadio(field);
		return;
	} else {
		field.setAttribute("p_required","");
	}
	if(field.parentNode.innerHTML.indexOf("*")>0){
		var spans=field.parentNode.getElementsByTagName("SPAN");
		var span=null;
		for(var i=0;i<spans.length;i++){
			if(spans[i].innerHTML.indexOf("*")>=0){
				span=spans[i];
				break;
			}
		}
		if(span!=null) {
			span.parentNode.removeChild(span);
		}
		field.parentNode.style.whiteSpace="nowrap";
		
		//Se intenta borrar el otro span
		
		
		var field_parent = field.parentNode;
		
		while(field_parent.nodeName != "TD") {
			field_parent = field_parent.parentNode;
		}
		
		if(!(field_parent.getAttribute("req_desc") != null || field_parent.getAttribute("req_desc") != undefined)) {
			
			var brother = field.parentNode.previousSibling;
			if(brother==null){
				brother = field.parentNode.parentNode.previousSibling;
			}
			while(brother != null && brother.nodeName != "TD")
				brother = brother.previousSibling;
			if(brother == null) {					
				if(field.parentNode.parentNode != null){
					brother = field.parentNode.parentNode.previousSibling;
				}
				while(brother != null && brother.nodeName != "TD") {
					brother = brother.previousSibling;					
				}
			}
			var aster_spans = brother.getElementsByTagName("SPAN");		
			for(var aster_i = 0; aster_i < aster_spans.length; aster_i++){
				if(aster_spans[aster_i].innerHTML.indexOf("*")>=0){
					brother.removeChild(aster_spans[aster_i]);
					break;
				}
			}
		}
	}
	for(var i = 0; i < requiredFields; i++) {
		if(field == requiredFields[i]) {
			requiredFields.splice(i, 1);
		}
	}
	//input.parentNode.style.width=(input.parentNode.clientWidth+10)+"px";
}

function setRequiredRadio(field){
	var td=field.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var span=document.createElement("span");
	span.setAttribute("required","true");
	span.innerHTML="*";
	if(!(td.previousSibling.getElementsByTagName("SPAN")[0] && td.previousSibling.getElementsByTagName("SPAN")[0].innerHTML=="*")){
		//return;
		td.appendChild(span);
		td.previousSibling.appendChild(span);
	}
	if(field.type=="radio"){
		field=document.getElementById("hidRad_"+field.id);
	}
	field.setAttribute("p_required","true");
	requiredFields.push(field);
	
	if(req_align == req_align_before) {
		//Movemos el asterisco
		var aster_span = document.createElement("SPAN");
		aster_span.innerHTML="* ";
		
		//span.setAttribute("style", "display:none");
		span.style.display = "none";
		
		var span_parent = span.parentNode;
		try {
			span_parent.insertBefore(aster_span, span_parent.firstChild);
		} catch(e) {}			
	}
}

function unSetRequiredRadio(field){
	var td=field.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var spans = td.previousSibling.getElementsByTagName("SPAN");
	
	for(var i = 0; i < spans.length; i++){
		if(spans[i].innerHTML.indexOf("*") >= 0){			
			spans[i].parentNode.removeChild(spans[i]);			
			break;
		}
	}
	
	//Intentamos borrar el otro span tambien
	spans = td.previousSibling.getElementsByTagName("SPAN");	
	for(var i = 0; i < spans.length; i++){
		if(spans[i].innerHTML.indexOf("*") >= 0){			
			spans[i].parentNode.removeChild(spans[i]);			
			break;
		}
	}
	
	field.setAttribute("p_required","");
	for(var i=0;i<requiredFields;i++){
		if(field==requiredFields[i]){
			requiredFields.splice(i,1);
		}
	}
}

function unSetRequiredFieldsToNodes(html){
	var nodes=html.getElementsByTagName("*");
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].getAttribute("p_required")=="true"){
			unsetRequiredField(nodes[i]);
		}
	}
}

function setRequiredFieldsToNodes(html){
	var nodes=html.getElementsByTagName("*");
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].getAttribute("p_required")=="true" && !isReqAdded(nodes[i]) && isAppended(nodes[i]) ){
			setRequiredField(nodes[i]);
		}
	}
}

function clearRequired(){
	requiredFields=new Array();
}