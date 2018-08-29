function setSelBinds(){
	var divs=document.getElementsByTagName("DIV");
	for(var i=0;i<divs.length;i++){
		if(divs[i].getAttribute("TYPE")=="selbind"){
			setSelBind(divs[i])
		}
	}
}
var listener=new Object();
function setSelBind(element){
	element.doXMLLoad=function(){
		var sXMLSourceUrl;
		var sXMLSource=this.getAttribute("sXMLSource");
		var sParams=this.getAttribute("sParams");
		if(sParams != "" && sParams != null){
			sXMLSourceUrl = sXMLSource + "?" + sParams;
		}else{
			sXMLSourceUrl = escape(sXMLSource);
		}
		listener.container=this;
		listener.onLoad=function(sXmlResult){
			if (this.container.bSelClean==false){
				this.container.clearContent();
			}
			if (isXMLOk(sXmlResult)) {
				this.container.readXML(sXmlResult);
			} else {
				this.container.bBindSuccess = false;
				this.container.fireAfterLoad();	
			}
		}
		xml.addListener(listener);
		var sXmlResult = __readInDOMDocument(sXMLSourceUrl);
	}
	element.readXML=function(sXmlResult){
		var xmlRoot=getXMLRoot(sXmlResult);
		if (xmlRoot.childNodes.length>0){
			for (var e=0;e<xmlRoot.childNodes.length;e++){
				rowAttColl = xmlRoot.childNodes[e].attributes;
				var value="";
				if(xmlRoot.childNodes[e].childNodes[0].firstChild){
					value=xmlRoot.childNodes[e].childNodes[0].firstChild.nodeValue;
				}
				var text="";
				if(xmlRoot.childNodes[e].childNodes[1].firstChild){
					text=xmlRoot.childNodes[e].childNodes[1].firstChild.nodeValue;
				}
				this.doOpts(value,text,rowAttColl);
			}
		}
		this.bSelClean=false;
		this.bBindSuccess = true;
		//fireAfterLoad();
	}
	element.doOpts=function(value,text,attColl){
		var oOpt = document.createElement("OPTION");
		oOpt.innerHTML = text;
		oOpt.value = value;
		if(attColl.length >0){
			for (var a=0; a < attColl.length;a++){
				oOpt.setAttribute(attColl[a].name,attColl[a].text);
			}
		}
		this.getElementsByTagName("SELECT")[0].appendChild(oOpt);
	}
	element.clear=function(){
		this.clearContent();
	}

	element.clearContent=function(){
		var select=this.getElementsByTagName("select")[0];
		var optLen=this.getElementsByTagName("select")[0].options.length;
		for(var o=0;o < optLen; o++){
			select.remove(0);
		}
	}
	element.load=function(){
		this.doXMLLoad();
	}
	
}


function unsetSelBinds(divs){
	while(divs.length>0){
		unsetSelBind(divs[0])
		divs.splice(0,1);
	}
}

function unsetSelBind(element){
	delete(element.doXMLLoad);
	delete(element.readXML);
	delete(element.doOpts);
	delete(element.clear);
	delete(element.clearContent);
	delete(element.load);
	
}