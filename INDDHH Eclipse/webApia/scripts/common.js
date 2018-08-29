var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
var MSIE6 = window.navigator.appVersion.indexOf("MSIE 6")>=0;
var MSIE7 = window.navigator.appVersion.indexOf("MSIE 7")>=0;
var MSIE8 = window.navigator.appVersion.indexOf("MSIE 8")>=0;
var MSIE9 = window.navigator.appVersion.indexOf("MSIE 9")>=0;
var OPERA = window.navigator.userAgent.toLowerCase().indexOf("opera")>=0;
var FIREFOX = window.navigator.userAgent.toLowerCase().indexOf("firefox")>=0;
var FIREFOX1 = window.navigator.userAgent.toLowerCase().indexOf("firefox/1.0")>=0;
var FIREFOXVER = FIREFOX?( window.navigator.userAgent.toLowerCase().charAt(window.navigator.userAgent.toLowerCase().indexOf("firefox/")+8)  ):"";
var MOZILLA = (window.navigator.appVersion.toLowerCase().indexOf("firefox")<0 && window.navigator.userAgent.toLowerCase().indexOf("mozilla")>=0);
var CHROME = ((window.navigator.appVersion.toLowerCase().indexOf("chrome"))>=0);

var DONT_SET_FOCUS = false;

if(MSIE7){
	MSIE6 = false;
}

function getEventObject(evt){
	if(evt && evt.element){
		return evt;
	}
	if(MSIE){
		return window.event;
	}
	return evt;
}

function getEventSource(evt){
	if(evt && evt.element){
		return evt.element;
	}
	if(MSIE){
		return window.event.srcElement;
	}
	return evt.target;
}

function findRowIndex(el){
	var tr=el;
	while(tr.tagName!="TR"){
		tr=tr.parentNode;
	}
	var index = tr.rowIndex;
	try{
		tr = tr.parentNode.parentNode;
		if(tr.getAttribute("isPaged") == "true"){
			var currentPage = tr.getAttribute("currentPage");
			var recordsPerPage = tr.getAttribute("recordsPerPage");
			index = ((currentPage-1) * recordsPerPage) + index;			
		}
	}catch(e){
		return index;
	}
	return index;
	
}

function getStageWidth(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		return document.body.parentNode.clientWidth-5;	
	}else{
		return document.body.offsetWidth-5;
	}
}
function getStageHeight(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		var height=document.body.parentNode.clientHeight;
		if(document.body.parentNode.clientHeight==0){
			height=document.body.clientHeight;
		}
		return height;
	}else{
		return height=window.innerHeight;
	}
}

function getAbsolutePosition(element) {
	var r = { x: element.offsetLeft, y: element.offsetTop };
	if (element.offsetParent) {
		var tmp = getAbsolutePosition(element.offsetParent);
		r.x += tmp.x;
		r.y += tmp.y;
	}
	return r;
}

function getLocalPosition(element,local) {
	var r = { x: element.offsetLeft, y: element.offsetTop };
	if (element.offsetParent!=local) {
		var tmp = getAbsolutePosition(element.offsetParent,local);
		r.x += tmp.x;
		r.y += tmp.y;
	}
	return r;
}

function createDOMDocument(strNamespaceURI, strRootTagName) {
	var objDOM;
	if(!MSIE){
		objDOM = document.implementation.createDocument(strNamespaceURI, strRootTagName, null);
	}else{
		var STR_ACTIVEX='Microsoft.XMLDOM';
		objDOM = new ActiveXObject(STR_ACTIVEX);
		//if there is a root tag name, we need to preload the DOM
		if (strRootTagName) {
		   //If there is both a namespace and root tag name, then
		   //create an artifical namespace reference and load the XML.
		   if (strNamespaceURI) {
			  objDOM.loadXML("<a0:" + strRootTagName + "xmlns:a0=\"" +  strNamespaceURI + "\" />");
		   } else {
			  objDOM.loadXML('<' + strRootTagName + '/>');
		   }
		}
	}
	return objDOM;
}

function xmlLoader(){
	var doc;
	this.data="";
	try{
		if(!MSIE){
			var tmp=this;
			doc=new XMLHttpRequest();
			doc.load=function(url){
				this.open("POST",url,false);
				this.overrideMimeType('text/xml');
				this.ignoreWhitespace=true;
				this.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
				this.setRequestHeader("Content-length", tmp.data.length);
				this.setRequestHeader("Connection", "close");
				this.send(tmp.data);
			}
		}else{
			//doc = new ActiveXObject("Microsoft.XMLDOM");
			doc=new ActiveXObject("Microsoft.XMLHTTP");
			doc.validateOnParse = false;
			doc.async = true;
			doc.preserveWhiteSpace = false;
		}
	}
	catch(err){
	}
	this.doc=doc;
	var tmp=this;
	this.load=function(url){
		if(MSIE){
			tmp.doc.onreadystatechange=function(){
				if(doc.readyState==4){
					tmp.xmlLoaded=doc.responseXML.lastChild;
					tmp.textLoaded=doc.responseText;
					tmp.onload(tmp.xmlLoaded);
				}
			}
			tmp.doc.open("GET",url,false);
			tmp.doc.send(null);
		}else{
			this.doc.parentObject=this;
			this.doc.onload=function(){
				this.parentObject.xmlLoaded=this.responseXML;
				this.parentObject.textLoaded=this.responseText;
				var first=null;
				if(this.parentObject.xmlLoaded){
					first=this.parentObject.xmlLoaded.firstChild;
				}
				this.parentObject.onload(first);
			}
			this.doc.load(url);
		}
	}
	this.loadString=function(xmlString){
		var xmlData; 
		if(MSIE){
			xmlData = new ActiveXObject("Microsoft.XMLDOM"); 
			xmlData.async="false"; 
			xmlData.loadXML(xmlString); 
		}else{ 
			var parser = new DOMParser(); 
			xmlData = parser.parseFromString(xmlString,"text/xml"); 
		}
		return xmlData;
	}
	this.onload=function(xmlLoaded){}
}

function sendVars(url,vars){
	var doc;
	doc=new XMLHttpRequest();
	doc.open("POST", url, false); 
	doc.setRequestHeader("content-type","application/x-www-form-urlencoded");
//	doc.setRequestHeader("Content-length", (vars.length+500));
	doc.send(vars);
	return doc; 
}

function makeUnselectable(element) {
	element.onselectstart = function() {
		return false;
	}
	element.unselectable = "on";
	element.style.MozUserSelect = "none";
	element.style.cursor = "default";
}

function getUnPaddedWidth(obj){
	var width=obj.offsetWidth;
	var paddingLeft;
	var paddingRight;
	if (OPERA){
		paddingLeft=getPxValue(obj.style.paddingLeft);
		paddingRight=getPxValue(obj.style.paddingRight);
	}else if (obj.currentStyle){
		paddingLeft=getPxValue(obj.currentStyle["padding-left"]);
		paddingRight=getPxValue(obj.currentStyle["padding-right"]);
	}else{
		paddingLeft=getPxValue(window.getComputedStyle(obj,"").getPropertyValue("padding-left"));
		paddingRight=getPxValue(window.getComputedStyle(obj,"").getPropertyValue("padding-right"));
	}
	width-=(parseInt(paddingLeft)+parseInt(paddingRight));
	return width;
}

function getMargins(obj) {	
	
	var marginLeft;
	var marginRight;
	if (OPERA) {
		marginLeft = getPxValue(obj.style.paddingLeft);
		marginRight = getPxValue(obj.style.paddingRight);
	} else if (obj.currentStyle){
		marginLeft = getPxValue(obj.currentStyle["margin-left"]);
		marginRight = getPxValue(obj.currentStyle["margin-right"]);
	} else {
		marginLeft = getPxValue(window.getComputedStyle(obj,"").getPropertyValue("margin-left"));
		marginRight = getPxValue(window.getComputedStyle(obj,"").getPropertyValue("margin-right"));
	}
	
	if(marginLeft == "") borderLeft = 0;
	if(marginRight == "") borderRight = 0;
	
	return (parseInt(marginLeft) + parseInt(marginRight));
}

function getUnPaddedAndUnBorderWidth(obj) {
	var width = obj.offsetWidth;
	var paddingLeft;
	var borderLeft;
	var paddingRight;
	var borderRight;
	if (OPERA){
		paddingLeft = getPxValue(obj.style.paddingLeft);
		borderLeft = getPxValue(obj.style.borderLeft);
		paddingRight = getPxValue(obj.style.paddingRight);
		borderRight = getPxValue(obj.style.borderRight);
	}else if (obj.currentStyle){		
		paddingLeft = getPxValue(obj.currentStyle["padding-left"]);
		borderLeft = getPxValue(obj.currentStyle["border-left"]);
		paddingRight = getPxValue(obj.currentStyle["padding-right"]);
		borderRight = getPxValue(obj.currentStyle["border-right"]);
	}else{		
		paddingLeft = getPxValue(window.getComputedStyle(obj,"").getPropertyValue("padding-left"));
		borderLeft = getPxValue(window.getComputedStyle(obj,"").getPropertyValue("border-left-width"));
		paddingRight = getPxValue(window.getComputedStyle(obj,"").getPropertyValue("padding-right"));
		borderRight = getPxValue(window.getComputedStyle(obj,"").getPropertyValue("border-right-width"));
	}
	
	if(borderLeft == "") borderLeft = 0;
	if(borderRight == "") borderRight = 0;
	
	width -= (parseInt(paddingLeft) + parseInt(paddingRight) + parseInt(borderLeft) + parseInt(borderRight));
	return width;
}

function getUnPaddedHeight(obj){
	var height=obj.offsetHeight;
	var paddingTop;
	var paddingBottom;
	if (OPERA){
		paddingTop=getPxValue(obj.style.paddingTop);
		paddingBottom=getPxValue(obj.style.paddingBottom);
	}else if (obj.currentStyle){
		paddingTop=getPxValue(obj.currentStyle["padding-top"]);
		paddingBottom=getPxValue(obj.currentStyle["padding-left"]);
	}else{
		paddingTop=getPxValue(window.getComputedStyle(obj,"").getPropertyValue("padding-top"));
		paddingBottom=getPxValue(window.getComputedStyle(obj,"").getPropertyValue("padding-left"));
	}
	height-=(parseInt(paddingTop)+parseInt(paddingBottom));
	return height;
}

function getStyle(oElm, strCssRule){
	var strValue = "";
	if(document.defaultView && document.defaultView.getComputedStyle){
		strValue = document.defaultView.getComputedStyle(oElm, "").getPropertyValue(strCssRule);
	}
	else if(oElm.currentStyle){
		strCssRule = strCssRule.replace(/\-(\w)/g, function (strMatch, p1){
			return p1.toUpperCase();
		});
		strValue = oElm.currentStyle[strCssRule];
	}
	return strValue;
}


function addOptionToCombo(combo,value,text){
	var option=document.createElement("OPTION");
	option.value=value;
	option.innerHTML=text;
	combo.appendChild(option);
}