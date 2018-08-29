<%@page import="com.st.util.labels.LabelManager"%><%request.setAttribute("isTask","true"); %><%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css"><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css"><script type="text/javascript">
	function initPage(){
		checkErrors();	
		$('btnCloseTab').addEvent('click', closeCurrentTab);
	}
	function closeCurrentTab() {
		getTabContainerController().removeActiveTab();
	}
	function checkErrors(xmlDoc){
		 
		if(!xmlDoc) {
			//Obtener el xml del textarea		
			if (window.DOMParser) {
				parser = new DOMParser();
				xmlDoc = parser.parseFromString($('execErrors').value,"text/xml");
			} else {
				// Internet Explorer
				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async = false;
				xmlDoc.loadXML($('execErrors').value); 
			}
		}
		
		//ie friendly
		var xml = xmlDoc.childNodes.length == 1 ? xmlDoc.childNodes[0] : xmlDoc.childNodes[1];
		
		
		
		if (xml.getElementsByTagName("sysExceptions").length != 0) {
			processXmlExceptions(xml.getElementsByTagName("sysExceptions").item(0), true);
		}
		
		if (xml.getElementsByTagName("sysMessages").length != 0) {
			processXmlMessages(xml.getElementsByTagName("sysMessages").item(0), true);
		}
		
		$('execErrors').value  = "<?xml version='1.0' encoding='iso-8859-1'?><data onClose='' />";
	}

	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData" action="" method="post"><div class="optionsContainer"><div class="fncPanel info"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="title"><%String errType = request.getParameter("errType");
							if ("pro".equals(errType)){ %><%=LabelManager.getName("msgProNotFound")%><%	} else if ("pool".equals(errType)){ %><%=LabelManager.getName("msgPoolNotFound")%><%	} else { %><%="Error getting task"%><%	}%></div><div class="content divFncDescription"><div class="fncDescriptionImgSection"><region:render section='taskImage' /></div><div class="fncDescriptionText" id="fncDescriptionText"><region:render section='tskDescription' /></div><div class="clear"></div></div></div><div class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnCloseTab" class="button suggestedAction" ><system:label show="text" label="btnClose" /></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><%if ("pro".equals(errType)){ %><%="<b>"+LabelManager.getName("msgProNotFound")+"</b>"%><%	} else if ("pool".equals(errType)){ %><%="<b>"+LabelManager.getName("msgUsrNoPool")+"</b>"%><%	}%><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../execution/includes/endInclude.jsp" %></body></html>
