/*************** debug mode ***********************/
var bDebug = false; 
//...:::::set to true to enter debug mode:::::...


var xmlDoc;
var xml=new Object();
var listener=new Object();
 /*********************************************************
 * function for creating DOMDocument					 *
 *********************************************************/
 
 
function new_XML_document(){
	try{
		var doc;
		if(MSIE){
			doc = new ActiveXObject("Microsoft.XMLDOM"); //actual (works)
		}else{
			doc=new XMLHttpRequest();
		}
		//var doc = new ActiveXObject('Msxml2.DOMDocument');//for msxml3.0
		//var doc = new ActiveXObject("MSXMl.DOMDocument");//in msdnpage
		return doc;
	}
	catch(err){
		return null;
	}
}
 /*********************************************************
 * function for creating DOMDocument from the source URL *
 *********************************************************/
function  __readInDOMDocument(url) {
	xmlDoc = new_XML_document();
	if (xmlDoc){
		if(MSIE){
			xmlDoc.onreadystatechange=chkXMLState;
			xmlDoc.validateOnParse = false;
			xmlDoc.async = false;
			//xmlDoc.resolveExternals = false;
			xmlDoc.preserveWhiteSpace = false;
			xmlDoc.load(url);
			listener.onLoad(xmlDoc);
		}else{
			xmlDoc.open("GET",url,false);
			xmlDoc.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");
			xmlDoc.setRequestHeader("mime-type","text/xml");
			xmlDoc.onload=function(){
					listener.onLoad(this);
			}
			xmlDoc.send(null);
			
		}
	}else{
		xmlDoc = null;
	}
}

var count=0;
var content="";
function xmlhttpChange(){
//alert(xmlhttp.readyState+" "+content);
if (xmlhttp.readyState==4){
  // if "OK"
	try{
		content=xmlhttp.responseText;
		if(xmlhttp.status==200){
		}else if(count<20){
			count+=1;
			var func="xmlhttpChange()";
			setTimeout(func,2000);
		}/*else if(count==20){
			alert("termino");
		}*/
/*		if (xmlhttp.status==200){
		alert("OK! retrieving XML data");
		}else{
		
		}*/
	}
	catch(e){
  
	}
}
  
}


 /*********************************************************
 * function for creating DOMDocument from a XML string *
 *********************************************************/
function __parseStringInDOMDocument(str) {
	xmlDoc = new_XML_document();
	if (xmlDoc){
		xmlDoc.onreadystatechange=chkXMLState;
		xmlDoc.validateOnParse = false;
		xmlDoc.async = false;
		//xmlDoc.resolveExternals = false;
		//xmlDoc.preserveWhiteSpace = true;
		xmlDoc.loadXML(str);
		return xmlDoc;
	}else{
		xmlDoc=null;
	}
}

function chkXMLState(){
	if (xmlDoc.readyState == 4){
			if (xmlDoc.parseError.reason != ""){
				reportParseError(xmlDoc.parseError);
				return xmlDoc;
			}else{
				return xmlDoc;
			}
		
	}else{		
	}
}
 

/*********************************************************
 * function for including HTML-fragments inside the node *
 *********************************************************/
function __insertHTMLFragment(sXmlUrl, sXslUrl, bView, xmlSrcType) {
  try {
			if (xmlSrcType==1)var xmlDoc = __readInDOMDocument(sXmlUrl);
			if (xmlSrcType==2)var xmlDoc = __parseStringInDOMDocument(sXmlUrl);
			
      var xslDoc = __readInDOMDocument(sXslUrl);
      var sXslResult = xmlDoc.transformNode(xslDoc);
      
      return sXslResult;
  }
  catch (ex) {
    if (bDebug)alert('Exception in retrieving node for insert HTML-fragment into:\n\n'+ex.description);
    return false;
  }

}

/*********************************************************
 * function for transforming XML w/ XSL *
 *********************************************************/
function __returnXMLtransform(xmlDoc,xslDoc){
	try {
		var sXslResult = xmlDoc.transformNode(xslDoc);
		return sXslResult;
	}
	catch (ex){
		if (bDebug)alert("XSL: " + xslDoc.url + "\n\n Exception in XSL Transform:\n" + ex.description);
    return false;
	}
}



/*------------------------------------------------------*/
/*			GET CLIENT ERROR FUNCTIONS					*/
/*------------------------------------------------------*/
function getClientError(){
// [args = (code,type)]
var argsLen = arguments.length;
sCode="";
sTipo="";
for (var i = 0; i < argsLen; i=i+2){
      sCode += "err=" + arguments[i] + "&";
      sTipo	+=	"type=" + arguments[i+1] + "&";
 }
 var sClientErrURL = "/components/errorHandler/getClientError.jsp?" + sCode + sTipo;
 window.document.body.showMsg();
//window.setTimeout("__readInDOMDocument('" + sClientErrURL + "')",1);
window.setTimeout("loadClientError('" + sClientErrURL + "')",1);
}

function loadClientError(sXMLUrl){
oXmlDomError = __readInDOMDocument(sXMLUrl);
	if (oXmlDomError.parseError.reason!=""){
		window.document.body.hideMsg();
	}else{
		showClientError(oXmlDomError);	
	}
}

function showClientError(oXML){
	var dArgs = new Array(window,oXML);
	var dUrl = "/components/errorHandler/getError.jsp";
	var dOptions =  "DialogWidth:650px;DialogHeight:300px;status:no;help:no;unadorned:yes;center:yes;";	
	var dErrWin = window.showModalDialog(dUrl , dArgs , dOptions);
	window.document.body.hideMsg();
}


function showXMLLoadingError(element,xmlRoot){
	showClientError(xmlRoot);
	
/*------------------COMMENTED--------
		var sUserMsg,sException,sStack,sParams;
		var auxUserM = xmlRoot.selectSingleNode("USER_MSG");
		sUserMsg = "ADFAC USER MESSAGE: ";

			if(auxUserM!=null && auxUserM.hasChildNodes()){
				sUserMsg += auxUserM.childNodes(0).nodeValue;
			}else{
				sUserMsg += "";
			}
			
		var XMLSource_URL = element.sXMLSource;
		var sElementName = element.tagName;
		var sId = element.id;	
			
			var sErrWhere = "\n ERROR EM : " +  element.sXMLSource;
			var sErrFrom =  "\n DESDE : " + sElementName + " [ " + sId + " ]";

			
		var auxEx = xmlRoot.selectSingleNode("EXCEPTION");
		sException = "\n EXCEPTION : ";
		if (auxEx!=null && auxEx.hasChildNodes()){
			sException += auxEx.childNodes(0).nodeValue;
		}else{
			sException += "";
		}
			
		var auxStack = 	xmlRoot.selectSingleNode("EXCEPTION_STACK");
		sStack = "\n STACK : "
		if (auxStack!=null && auxStack.hasChildNodes()){
			sStack += auxStack.childNodes(0).nodeValue;
		}else{
			sStack += "";
		}

		var auxParams = xmlRoot.selectSingleNode("PARAMETERS");
		sParams = "PARAMETERS : \n";
		if (auxParams!=null && auxParams.hasChildNodes()){
			for(var x=0;x< auxParams.childNodes.length;x++){
				colName = auxParams.childNodes(x).childNodes(0).childNodes(0).nodeValue;
				if(auxParams.childNodes(x).childNodes(1).childNodes(0)!=null){
					colValue = auxParams.childNodes(x).childNodes(1).childNodes(0).nodeValue;
				}else{
					colValue =	auxParams.childNodes(x).childNodes(1).text;
				}
				sParams += colName + " : " + colValue + "\n";
			}
		}
			
			if(bDebug){
				var auxDebug = window.confirm(sUserMsg);
				if(auxDebug==true){
					alert(sErrWhere 
					+ sErrFrom + "\n"
					+ sException 
					+ sStack 
					+ sParams);
					//alert(xmlRoot.xml);
				}
			}else{
				alert(sUserMsg);
			}
			
		window.focus();
		
		----------------------------------*/
}


function reportParseError(error){
  var s = "";
  for (var i=1; i< error.linepos; i++) {
    s += "-";
  }
  r = "XML CLIENT LOADING OR PARSING ERROR: " + error.reason + "\n" +
      "URL: " + error.url + "\n";
  
	if(bDebug){
		if (error.line > 0){
			var confirmError = confirm(r);
			if (confirmError==true){
				errLines = "<font face=Verdana size=2><font size=2>XML parsing or loading Error '" + error.url + "'</font>" +"<P><B>" + error.reason + "  at line " + error.line + ", character " + error.linepos + "</B></P></font>";
				errLines += "<font size=3><XMP>" + "\n" + error.srcText + "\n" + s + "^" + "</XMP></font>";
				var dError = window.showModalDialog("/components/componentsJSP/debugXMLModal.jsp",errLines,"dialogHeight:400px;dialogWidth:700px;center:Yes; help:no; resizable:Yes; status:no;");
			}
		}else{
			alert(r);
		}
	}else{
		alert(r);
	}
}




/*------------------------------------------------------*/
/*					TEMP FUNCTIONS						*/
/*------------------------------------------------------*/
function showHTML(html){
var w = window.open("",null,"height=480,width=680,resizable=yes,scrollbars=yes");
	w.document.open();
    w.document.write(html);
    w.document.close();
    w.focus();
}		
function showXML(doc){
    var tempdoc = new ActiveXObject("Microsoft.XMLDOM");
    tempdoc.async = false;
    if (!tempdoc.load(URL_ROOT_PATH + "/css/mimedefault.xsl")){
		showHTML(reportParseError(tempdoc.parseError));
	}else{
   		var html = doc.transformNode(tempdoc);
   		showHTML(html);
    }
}



function loadXmlDom(url,preview){

	oXml = new_XML_document();
	oXml.async = false;
	oXml.validateOnParse = false;
	oXml.resolveExternals = false;
	oXml.preserveWhiteSpace = false;

	if (!oXml.load(url)){
		showHTML(reportParseError(oXml.parseError))
	} else {
		if (preview==true){
			showXML(oXml)
		}
		if (oXml.documentElement.nodeName != "EXCEPTION"){
			return oXml;
		} else{
			return oXml;
		}
	}
}

function isXMLOk(sXmlResult) {
	if(MSIE){
		if (sXmlResult.parseError.reason!=""){
				alert("error parsing xml");
				return false;
		}else{
			var xmlRoot = sXmlResult.documentElement;
			if (xmlRoot.nodeName == "EXCEPTION") {
				return false;
			}
		}
	}else{
		
		if (sXmlResult.responseXML.documentElement.nodeName == "EXCEPTION" || sXmlResult.responseXML.documentElement.nodeName == "exception"){
			return false;
		}
	}
	return true;
}

xml.addListener=function(aListener){
	listener=aListener;
}

xml.detachListener=function(){
	listener=[];
}

if(navigator.userAgent.indexOf("MSIE")<0){
	Document.prototype.loadXML = function (s) {
	   // parse the string to a new doc
	   var doc2 = (new DOMParser()).parseFromString(s, "text/xml");
	
	   // remove all initial children
	   while (this.hasChildNodes())
	      this.removeChild(this.lastChild);
	
	   // insert and import nodes
	   for (var i = 0; i < doc2.childNodes.length; i++) {
	      this.appendChild(this.importNode(doc2.childNodes[i], true));
	   }
	}
}

function transformNode(oXML,tempdoc){
	if(MSIE){
		return oXML.transformNode(tempdoc);
	}else{
		var processor = new XSLTProcessor();
		processor.importStylesheet(tempdoc);
		return processor.transformToDocument(oXML);
	}
}

function getXMLRoot(sXmlResult){
	if (MSIE){
		return sXmlResult.documentElement;
	}else{
 		return sXmlResult.responseXML.childNodes[0];
	}
}