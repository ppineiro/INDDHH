// JavaScript Document
var model;
var iconWinId=0;

function new_XML_document(){
	try{
		var doc;
		if(MSIE){
			doc = new ActiveXObject("Microsoft.XMLDOM");
			doc.validateOnParse = false;
			doc.async = true;
			doc.preserveWhiteSpace = false;
		}else{
			doc=new XMLHttpRequest();
			doc.load=function(url){
				this.open("GET",url,false);
				doc.overrideMimeType('text/xml');
				doc.ignoreWhitespace=true;
				doc.send(null);
			}
		}
		return doc;
	}
	catch(err){
		return null;
	}
}

function saveModel(xml){
	sendVars("ApiaDeskAction.do?action=saveModel&xmlMenu=true",("&xmlModel="+xml));
}

function loadModel(url){
	var xml=new xmlLoader();
	xml.onload=function(root){
		root=getFirstChild(root);
		if(root){
			var model=parseModel(root);
			xmlLoaderListener.onload(model);
		}else{
			xmlLoaderListener.onload(new Array());
		}
	}
	xml.load(URL_ROOT_PATH+"/"+url);
}
function startModelCookie(){
	//setCookie ('ApiaDeskModel', "",null);//para eliminar el cookie
	var cookieInfo=getCookie("ApiaDeskModel");
	if(cookieInfo!=null && cookieInfo!="null" && cookieInfo!=""){
		var xmlModel=parseStringToXML(cookieInfo);
		if(xmlModel.getElementsByTagName("desktop")[0]){
			var model=parseModel(xmlModel.getElementsByTagName("desktop")[0]);
			xmlLoaderListener.onload(model);
			return true;
		}
	}
	xmlLoaderListener.onload(new Array());
}

function parseElementToXml(el){
	var ret="";
	if(el){
		if(el.getObject){
			el=el.getObject();
		}
		
		var icon=escape(el.icon);
		var bar=icon.lastIndexOf("/");
		icon=icon.substring(bar,icon.length);
		ret='<element name="'+el.name;
		if(el.type){
			ret+='" type="'+el.type;
		}
		if(el.atts && el.atts.postit){
			ret+='" postit="true" postitText="'+el.atts.text;
		}
		if(el.atts && el.atts.fncId){
			ret+='" fncId="'+el.atts.fncId;
		}
		ret+='" icon="'+icon;
		if(el.url){
			ret+='" url="'+escape(el.url);
		}
		if(el.elementWindow){
			iconWinId++;
			ret+='" windowId="'+iconWinId;
			el.elementWindow.elementId=iconWinId;
		}
		if(el.elements){
			ret+='">';
			for(var i=0;i<el.elements.length;i++){
				ret+=parseElementToXml(el.elements[i]);
			}
			ret+='</element>';
		}else{
			ret+='" />';
		}
	}
	return ret;
}
function parseWindowToXml(el){
	var ret="";
	if(el){
		var icon=escape(el.objectData.icon);
		var bar=icon.lastIndexOf("/");
		icon=icon.substring(bar,icon.length);
		var height=el.offsetHeight;
		var width=el.offsetWidth;
		var top=el.offsetTop;
		var left=el.offsetLeft;
		var minimized="false";
		if(height==0 && width==0){
			top=el.actualTop;
			left=el.actualLeft;
			height=el.actualHeight;
			width=el.actualWidth;
			minimized="true"
		}
		var url="";
		if(el.url!=""){
			url=updateVariable("windowId","",el.url);
		}
		ret+='<window name="'+el.name+'" icon="'+icon+'" '+((url!="")?('url="'+escape(url)+'" '):'')+'width="'+width+'" height="'+height+'" x="'+left+'" y="'+top+'" minimized="'+minimized;
		if(el.elementId){
			ret+='" elementId="'+el.elementId;
		}
		if(el.objectData.elements && el.objectData.elements.length>0 && el.taskList==null){
			ret+='">';
			for(var i=0;i<el.objectData.elements.length;i++){
				ret+=parseElementToXml(el.objectData.elements[i]);
			}
			ret+='</window>';
		}else if(el.taskList!=null){
			ret+='" taskList="'+el.taskList+'" />';
		}else{
			ret+='" />';
		}
	}
	return ret;
}
function parsePostitToXml(element){
	var ret="";
	if(element){
		ret+='<postit text="'+element.text.value+'" left="'+element.x+'" top="'+element.y+'" />'
	}
	return ret;
}
function parseStringToXML(xmlString){
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
function getModel(){
	iconWinId=0;
	var model='<?xml version="1.0" encoding="iso-8859-1"?><desktop>';
	for(var i=0;i<windows.length;i++){
		if(windows[i].persistable){
			model+=parseWindowToXml(windows[i]);
		}
	}
	for(var i=0;i<deskTop.elements.length;i++){
		model+=parseElementToXml(deskTop.elements[i]);
	}
	if(postIts.length>0){
		model+="<postits visibility=\""+postitsState+"\">"
		for(var i=0;i<postIts.length;i++){
			model+=parsePostitToXml(postIts[i]);
		}
		model+="</postits>"
	}
	model+=schelduler.getSchedulerXML();
	model+='</desktop>';
	setCookie ('ApiaDeskModel', model,null);
	saveModel(model);
}

function parseModel(root){
	var mod=new Array();
	for(var i=0;i<root.childNodes.length;i++){
		if(root.childNodes[i].nodeName == "element"){
			var element=parseElement(root.childNodes[i]);
			mod.push(element);
		}
		if(root.childNodes[i].nodeName == "window"){
			var win=parseWindow(root.childNodes[i]);
			mod.push(win);
		}
		if(root.childNodes[i].nodeName == "postits"){
			postitsInitState=root.childNodes[i].getAttribute("visibility");
			
			
			for(var u=0;u<root.childNodes[i].childNodes.length;u++){
				if(root.childNodes[i].childNodes[u].nodeName == "postit"){
					var text=root.childNodes[i].childNodes[u].getAttribute("text");
					var left=root.childNodes[i].childNodes[u].getAttribute("left");
					var top=root.childNodes[i].childNodes[u].getAttribute("top");
					var postit={text:text,left:left,top:top,type:'postit'};
					mod.push(postit);
				}
			}
		}
		if(root.childNodes[i].nodeName == "scheduler"){
			var scheduler=root.childNodes[i];
			for(var u=0;u<scheduler.childNodes.length;u++){
				if(scheduler.childNodes[u].nodeName == "date"){
					var dateElements=parseModel(scheduler.childNodes[u]);
					var date=scheduler.childNodes[u].getAttribute("value");
					schelduler.setDateElements(date,dateElements);
				}
			}
		}
	}
	return mod;
}

function parseElement(elementXML){
	var atts={name:unescape(elementXML.getAttribute("name")),url:unescape(elementXML.getAttribute("url")),icon:("styles/"+currStyle+"/images"+elementXML.getAttribute("icon")),droppable:elementXML.getAttribute("droppable"),type:elementXML.getAttribute("type")};
	for(var i=0;i<elementXML.childNodes.length;i++){
		if(!atts.elements){atts.elements=new Array();}
		if(elementXML.childNodes[i].nodeName == "element"){
			var child=parseElement(elementXML.childNodes[i]);
			atts.elements.push(child);
		}
	}
	if(elementXML.getAttribute("windowId")){
		atts.windowId=elementXML.getAttribute("windowId");
	}
	if(atts.elements || atts.type=="folder"){
		return new folder(atts);
	}else if(elementXML.getAttribute("postit")=="true"){
		atts.text=elementXML.getAttribute("postitText");
		return getPostitObject(atts);
	}
	return new element(atts);
}

function parseWindow(elementXML){
	var element={type:"window",name:unescape(elementXML.getAttribute("name")),icon:("styles/"+currStyle+"/images"+elementXML.getAttribute("icon")),title:unescape(elementXML.getAttribute("name")),url:unescape(elementXML.getAttribute("url")),width:elementXML.getAttribute("width"),y:elementXML.getAttribute("y"),x:elementXML.getAttribute("x"),height:elementXML.getAttribute("height"),minimized:elementXML.getAttribute("minimized")};
	if(elementXML.getAttribute("taskList")!=null){
		element.taskList=elementXML.getAttribute("taskList");
	}
	if(elementXML.getAttribute("elementId")!=null){
		element.elementId=elementXML.getAttribute("elementId");
	}
	element.elements=new Array();
	for(var i=0;i<elementXML.childNodes.length;i++){
		if(elementXML.childNodes[i].nodeName == "element"){
			var child=parseElement(elementXML.childNodes[i]);
			element.elements.push(child);
		}
	}
	return element;
}

function getXMLRoot(sXmlResult){
	if (MSIE){
		return sXmlResult.documentElement;
	}else{
 		return sXmlResult.responseXML.childNodes[0];
	}
}

function getCookie(name){
  var cname = name + "=";               
  var dc = document.cookie;             
  if (dc.length > 0) {              
    begin = dc.indexOf(cname);       
    if (begin != -1) {           
      begin += cname.length;       
      end = dc.indexOf(";", begin);
      if (end == -1) end = dc.length;
        return unescape(dc.substring(begin, end));
    } 
  }
  return null;
}


function setCookie(name, value, expires, path, domain, secure) {
  document.cookie = name + "=" + escape(value) + 
  ((expires == null) ? "" : "; expires=" + expires.toGMTString()) +
  ((path == null) ? "" : "; path=" + path) +
  ((domain == null) ? "" : "; domain=" + domain) +
  ((secure == null) ? "" : "; secure");
}


function delCookie (name,path,domain) {
  if (getCookie(name)) {
    document.cookie = name + "=" +
    ((path == null) ? "" : "; path=" + path) +
    ((domain == null) ? "" : "; domain=" + domain) +
    "; expires=Thu, 01-Jan-70 00:00:01 GMT";
  }
}

var schelduler;

function initSchelduler(){
	schelduler=new Object();
	schelduler.schedule=new Array();
	schelduler.date="";
	schelduler.getDate=function(date){
		for(var i=0;i<this.schedule.length;i++){
			if(this.schedule[i].date==date){
				return this.schedule[i];
			}
		}
		this.schedule.push({date:date,elements:new Array(),postits:new Array()});
		return this.schedule[(this.schedule.length-1)];
	}
	schelduler.setDate=function(date){
		schelduler.date=date;
	}
	schelduler.scheduleElement=function(element){
		this.getDate(this.date).elements.push(element);
		return element;
	}
	schelduler.schedulePostit=function(postit){
		this.getDate(this.date).postits.push(postit);
	}
	schelduler.getScheduledDays=function(month,year){
		var days="";
		for(var i=0;i<this.schedule.length;i++){
			if(this.schedule[i].date.indexOf(month+"/"+year)>0 && this.schedule[i].date){
				days+=this.schedule[i].date.substring(0,this.schedule[i].date.indexOf("/"))+";";
			}
		}
		getFlashObject(calendarWidget.id).SetVariable("call", ("setSchelduledDays,"+days));
		this.scheduledDays=days;
	}
	schelduler.removeCurrent=function(){
		this.removeDate(this.date);
	}
	schelduler.removeDate=function(date){
		for(var i=0;i<this.schedule.length;i++){
			if(this.schedule[i].date==date){
				this.schedule.splice(i,1);
			}
		}
	}
	schelduler.setElements=function(date,els,pts){
		if(els.length==0 && pts.length==0){
			this.removeDate(date);
			return null;
		}
		if(!this.schedule[date]){
			schelduler.schedule[date]=new Object();
		}
		this.getDate(this.date).elements=els;
		this.getDate(this.date).postits=pts;
	}
	schelduler.setDateElements=function(date,els){
		for(var i=0;i<els.length;i++){
			if(els[i].type=="postit"){
				this.getDate(date).postits.push(els[i]);
			}else{
				this.getDate(date).elements.push(els[i]);
			}
		}
	}
	schelduler.showSchedule=function(){
		if(this.getDate(this.date)){
			var els=new Array();
			var elements=this.getDate(this.date).elements;
			var postits=this.getDate(this.date).postits;
			for(var i=0;i<postits.length;i++){
				var postit=new element({icon:"styles/"+currStyle+"/images/postit_icon_50x50.png",name:("POSTIT "+i)});
				postit.text=postits[i].text;
				postit.postit="true";
				els.push(postit);
			}
			for(var i=0;i<elements.length;i++){
				els.push(elements[i]);
			}
			var dayFolder=new folder({icon:"styles/"+currStyle+"/images/folder_icon.png",name:(this.date),url:"",elements:els});
			var win=dayFolder.getIconElement().openWindow();
			win.onclose=function(evt){
				var elements=this.objectData.elements;
				var els=new Array();
				var pts=new Array();
				for(var i=0;i<elements.length;i++){
					if(elements[i].postit){
						pts.push(elements[i]);
					}else{
						els.push(elements[i]);
					}
				}
				schelduler.setElements(this.name,els,pts);
				var month=this.name.split("/")[1];
				var year=this.name.split("/")[2];
				schelduler.getScheduledDays(month,year);
			}
		}
	}
	schelduler.showDaySchedule=function(date){
		this.date=date;
		this.showSchedule();
	}
	schelduler.getSchedulerXML=function(){
		var date=serverDate;
		if(date.length==1){
			date="0"+date;
		}
		var month=serverMonth;
		if(month.length==1){
			month="0"+month;
		}
		var todayDate=date+"/"+month+"/"+serverYear;
		var xml="<scheduler>";
		for(var i=0;i<this.schedule.length;i++){
			if(this.schedule[i]){
				var date=this.schedule[i].date;
				var sepDate=date.split("/");
				if(parseInt(sepDate[0]) >= serverDate &&
					parseInt(sepDate[1]) >= serverMonth &&
					parseInt(sepDate[2]) >= serverYear){
					xml+='<date value="'+date+'">';
					var els=this.schedule[i].elements;
					var pts=this.schedule[i].postits;
					for(var u=0;u<els.length;u++){
						xml+=parseElementToXml(els[u]);
					}
					if(pts.length>0){
						xml+='<postits>'
						for(var u=0;u<pts.length;u++){
							xml+=parsePostitToXml(pts[u]);
						}
						xml+='</postits>'
					}
					xml+="</date>";
				}
			}
		}
		xml+="</scheduler>";
		return xml;
	}
	schelduler.removeScheduledDays=function(strDays){
		var arrayDays=strDays.split(";");
		for(var i=0;i<arrayDays.length;i++){
			if(arrayDays[i]!=null && arrayDays[i]!=""){
				this.removeDate(arrayDays[i]);
			}
		}
	}
	schelduler.getDaysList=function(){
		var days="";
		for(var i=0;i<this.schedule.length;i++){
			days+=this.schedule[i].date+";";
		}
		getFlashObject(calendarWidget.id).SetVariable("call", ("setListSchelduledDays,"+days));
	}
	schelduler.checkToday=function(){
		var date=serverDate+"/"+serverMonth+"/"+serverYear;
		if(this.getDate(date)){
			var elements=this.getDate(date).elements;
			var postits=this.getDate(date).postits;
			for(var i=0;i<postits.length;i++){
				var postit=addPostit(postits[i].text);
				postit.style.left=((i*30)+10)+"px";
				postit.style.top=((i*30)+10)+"px";
			}
			if(elements.length>0){
				var dayFolder=new folder({icon:"styles/"+currStyle+"/images/folder_icon.png",name:("TO DO!"),url:"",elements:elements});
				var win=dayFolder.getIconElement().openWindow();
				var minimizedwin=win.minimizedwin;
				win.minimize();
				pos=getAbsolutePosition(minimizedwin);
				var helpTip=showHelpTip({text:lblPending,x:(pos.x),y:(pos.y)});
				helpTip.onclick=function(){fireEvent(minimizedwin,"click");}
			}
			this.removeDate(date);
		}
	}
}

// JavaScript Document
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

function showXmlError(xml){
	if(xml && xml.firstChild && xml.firstChild.nodeName.toUpperCase()=="EXCEPTION"){
		var win=window;
		while(!win.document.getElementById('iframeMessages') && win!=win.parent){
			win=win.parent;
		}
		win.document.getElementById('iframeMessages').showMessage(xml.firstChild.firstChild.nodeValue, null);
		return true;
	}
	return false;
}

initSchelduler();