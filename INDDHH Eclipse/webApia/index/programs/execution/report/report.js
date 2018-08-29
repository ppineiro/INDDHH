function btnDownload_click(repId){
	if (verifyRequiredObjects()) {
		var format = document.getElementById("radSelected").value;
		if (format==".html"){
			openWindow2(URL_ROOT_PATH + "/execution.ReportAction.do?action=download&format="+format+getParams(),700,500,"yes");
		}else{
			document.getElementById("frmMain").action = "execution.ReportAction.do?action=download&format=" + format + windowId;
			document.getElementById("frmMain").target="downloadFrame";
			var downloadFrame=document.getElementById("downloadFrame");
			if(MSIE){
				downloadFrame.onreadystatechange=function(){
					if (document.getElementById("downloadFrame").readyState=="interactive"){
						hideResultFrame();
					}
				}
			}else{
				//document.getElementById("downloadFrame").window.onload=function(){
				//	hideResultFrame();
				//}
				setTimeout(endGeneration,1000);
			}
			submitForm(document.getElementById("frmMain"));
		}
	}
}

function endGeneration(){
	var sXMLSourceUrl = "execution.ReportAction.do?action=checkGenFinish";
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xml){
		if ("true" == this.textLoaded){
			hideResultFrame();
		}else {
			setTimeout(endGeneration,1000);
		}
	}
	xmlLoad.load(sXMLSourceUrl);
}

function getParams(){
	//PARAMS="par1,par2,par3";
	var parameters = PARAMS;
	var parValues = "";
	if (parameters!=""){
		while (parameters.indexOf(",") > 0){
			var name = parameters.substring(0,parameters.indexOf(","));
			value = document.getElementById(name).value;
			parValues = parValues + "&" + name + "=" + value;			
			parameters = parameters.substring(parameters.indexOf(",")+1, parameters.length);
		}
		var name = parameters;
		value = document.getElementById(name).value;
		parValues = parValues + "&" + name + "=" + value;			
	}
	return parValues;
}

function btnExit_click(){
	splash();
}

function btnPreview_click(){

}

function changeRadFact(val){
	document.getElementById("radSelected").value = val;
}

function setPNumeric(){
	var inputs=document.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].getAttribute("p_numeric")=="true"){
			setNumericField(inputs[i]);
		}
	}

}
