// JavaScript Document
var xmlLoaders=new Object();
xmlLoaders.busy=false;
xmlLoaders.queuedLoaders=new Array();

function createDOMDocument(strNamespaceURI, strRootTagName) {
	var objDOM;
	if(window.navigator.appVersion.indexOf("MSIE")<0){
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
			doc=new XMLHttpRequest();
			doc.load=function(url){
				this.open("POST",url,false);
				if(!MSIE){
					this.overrideMimeType('text/xml');
				}
				this.ignoreWhitespace=true;
				this.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
				this.setRequestHeader("Content-length", this.owner.data.length);
				this.setRequestHeader("Connection", "close");
				this.send(this.owner.data);
			}
			doc.owner=this;
		}else{
			//doc = new ActiveXObject("Microsoft.XMLDOM");
			doc=new ActiveXObject("Microsoft.XMLHTTP");
			doc.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
			doc.setRequestHeader("enctype","utf-8");
			//doc.validateOnParse = false;
			doc.async = true;
			//doc.preserveWhiteSpace = false;
		}
	}
	catch(err){
	}
	this.doc=doc;
	var tmp=this;
	this.load=function(url){
		if(!xmlLoaders.busy){
			if(window.navigator.appVersion.indexOf("MSIE")>0){
				tmp.doc.onreadystatechange=function(){
					if(doc.readyState==4){
						//tmp.xmlLoaded=doc.documentElement;
						xmlLoaders.LoadNextLoader();
						tmp.xmlLoaded=doc.responseXML;
						tmp.textLoaded=doc.responseText;
						tmp.onload(tmp.xmlLoaded);
					}
				}
				tmp.doc.open("POST",url,false);
				tmp.doc.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
				tmp.doc.setRequestHeader("Content-length", tmp.data.length);
				tmp.doc.send(tmp.data);
			}else{
				this.doc.parentObject=this;
				this.doc.onload=function(){
					xmlLoaders.LoadNextLoader();
					this.parentObject.xmlLoaded=this.responseXML;
					this.parentObject.textLoaded=this.responseText;
					this.parentObject.onload(this.parentObject.xmlLoaded);
				}
				this.doc.load(url);
			}
		}else{
			this.queuedUrl=url;
			queuedLoaders.push(this);
		}
	}
	this.loadString=function(xmlString){
		var xmlData; 
		if(window.navigator.appVersion.indexOf("MSIE")>0){
			xmlData = new ActiveXObject("Microsoft.XMLDOM"); 
			xmlData.async="false"; 
			xmlData.loadXML(xmlString); 
		}else{ 
			var parser = new DOMParser(); 
			xmlData = parser.parseFromString(xmlString,"text/xml"); 
		}
		return xmlData;
	}
	this.setData=function(d){
		this.data=d;
	}
	
	this.onload=function(xmlLoaded){}
}
function data(){
	this.XmlLoader=new xmlLoader();
	this.XmlLoader.container=this;
	this.XslLoader=new xmlLoader();
	this.XslLoader.container=this;
	this.xmlData=null;
	this.xslData=null;
	this.XmlLoader.onload=function(){
		this.container.xmlData=this.xmlLoaded;
		this.container.onXmlReady(this.xmlLoaded);
	}
	this.XslLoader.onload=function(){
		this.container.xslData=this.xmlLoaded;
		this.container.onXslReady(this.xmlLoaded);
	}
	this.loadXML=function(url){
		this.XmlLoader.load(url);
	}
	this.loadXSL=function(url){
		this.XslLoader.load(url);
	}
	this.getNodesWith=function(att,value){
		var statement='//node['+att+'="'+value+'"]';
		return(xpathExecute(this.xmlData,statement));
	}
	this.onXmlReady=function(){}
	this.onXslReady=function(){}
	
}

function xpathExecute(from,query){
	var result;
	var doc;
	if(from.ownerDocument){
		from=from.ownerDocument;
	}
	if(window.navigator.appVersion.indexOf("MSIE")<0){
		result=from.evaluate(query,from,null,XPathResult.ANY_TYPE,null);
		doc= createDOMDocument("", "nodes");
		var nodes=doc.firstChild;
		var node=result.iterateNext();
		while (node) {
			var cloned=node.cloneNode(true);
			nodes.appendChild(cloned);
			node = result.iterateNext();
		}
	}else{
		result=from.selectNodes(query);
		doc= createDOMDocument("", "nodes");
		var nodes=doc.lastChild;
		for(var i=0;i<result.length;i++){
			nodes.appendChild(result[i].cloneNode(true));
		}
	}
	return doc;
}

function xslTransform(xmlDoc,xslDoc){
	if(window.navigator.appVersion.indexOf("MSIE")<0){
		var ownerDocument = createDOMDocument("", "root");
		var nodes=xmlDoc.firstChild;
		ownerDocument.firstChild.appendChild(nodes.cloneNode(true));
		var xsltProcessor = new XSLTProcessor();
		xsltProcessor.importStylesheet(xslDoc);
		var transformed=xsltProcessor.transformToFragment(ownerDocument, document);
		if(transformed.firstChild.nodeName.toUpperCase()!="DIV"){
			transformed=xsltProcessor.transformToDocument(ownerDocument);
		}
		return transformed;
	}else{
		var trans=xmlDoc.transformNode(xslDoc);
		if(trans.indexOf("div")<0){
			var loader=new xmlLoader();
			loaded=loader.loadString(trans);
			return loaded;
		}else{
			var div=document.createElement("DIV");
			div.innerHTML="<div>"+trans+"</div>";
			return div.firstChild.cloneNode(true);
		}
	}
}

xmlLoaders.LoadNextLoader=function(){
	this.busy=false;
	if(this.queuedLoaders.length>0){
		var loader=this.queuedLoaders[0];
		this.queuedLoaders.splice(0,1);
		loader.load(loader.queuedUrl);
	}
}

function getFirstChild(node){
	if(node){
		if(!MSIE && node.firstChild){
			return node.firstChild;
		}else{
			return node.lastChild;
		} 
	}
	return null;
}

function sort(xmlDoc,nodeName,type,order){
	if(!order){order="ascending";}
	var xslString='<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:template match="nodes"><xsl:copy><xsl:for-each select="*"><xsl:sort select="'+nodeName+'" order="'+order+'" data-type="'+type+'" /><xsl:copy-of select="."/></xsl:for-each></xsl:copy></xsl:template></xsl:stylesheet>';
	var loader=new xmlLoader();
	var xsl=loader.loadString(xslString);
	return xslTransform(xmlDoc,xsl);
}
function trim(string){
	while( escape(string.charAt(0))!=string.charAt(0) ){
		string=string.substring(1,string.length);
	}
	while( escape(string.charAt(string.length-1))!=string.charAt(string.length-1) ){
		string=string.substring(0,(string.length-1));
	}
	return string;
}
	