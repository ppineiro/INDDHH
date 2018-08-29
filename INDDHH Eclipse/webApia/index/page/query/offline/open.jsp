<%@page import="java.io.BufferedReader"%><%@page import="java.io.FileReader"%><%@page import="com.dogma.vo.custom.QryResultFileVo"%><%@page import="java.io.File"%><%@page import="biz.statum.apia.web.bean.query.OffLineBean"%><%@page import="biz.statum.apia.web.action.query.OffLineAction"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/query/offline/open.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.query.OffLineAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;		
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><%@include file="../common/panelInfo.jsp" %><div class="fncPanel options"><div class="title"><system:label show="text" label="titActions" /></div><div class="content"><div id="btnBackToList" class="button suggestedAction" title="<system:label show="tooltip" label="btnVol" />"><system:label show="text" label="btnVol" /></div><div id="btnCloseTab" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><%				
				HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
				OffLineBean bean= OffLineAction.staticRetrieveBean(http);
				
				QryResultFileVo resultVo = bean.getResultFileVo();
				
				File file = new File(resultVo.getFilePath());
			    FileReader fr = new FileReader(file);
			    BufferedReader br = new BufferedReader(fr);
			    String linea = null;
			    while((linea = br.readLine()) != null) {
	    			out.println(linea);
				}
				
				br.close();
				fr.close();				
			%><input type="hidden" id="pCount" value="<%=bean.getPagesCountValue()%>"><div class="gridFooter"><%@include file="../../includes/navButtons.jsp" %></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../includes/footer.jsp" %></body></html>
