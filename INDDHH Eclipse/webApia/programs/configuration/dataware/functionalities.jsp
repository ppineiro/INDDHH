<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.analitic.DatawareBean"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%! 
private boolean firstCube = true;
private String processCubeAndView(String labelSet, int count, Collection functionalities, String cubeView) {
	if (count == 0) {
		firstCube = true;
	}
	StringBuffer buffer = new StringBuffer();
	String[] data = cubeView.split("·");
	FunctionalityVo fncVo = this.getFunctionlityVo(functionalities,data);
	String name = "";
	if (DatawareBean.CUBE_FUNCTIONALITY.equals(data[0])) { 
		if (! firstCube) {
			buffer.append("</ul>");
		} else {
			firstCube = false;
		}
		name = data[1];
	} else {
		buffer.append("<li>");
		name = data[2];
	}
	buffer.append("<input type=\"checkbox\" name=\"showFnc" + count + "\"" + ((fncVo != null)?" checked":"") + ">");
	buffer.append("<input type=\"hidden\" name=\"fncId" + count + "\" value=\"" + ((fncVo != null)?fncVo.getFncId().toString():"") + "\">");
	buffer.append("<input type=\"text\" maxlength=\"50\" size=\"80\" name=\"fncName" + count + "\" title=\"" + ((data.length == 3)?data[2]:data[1]) + "\" value=\"" + ((fncVo != null)?fncVo.getFncName():name) + "\">");
	buffer.append("<input type=\"hidden\" name=\"fncType" + count + "\" value=\"" + (DatawareBean.CUBE_FUNCTIONALITY.equals(data[0])?DatawareBean.CUBE_FUNCTIONALITY:DatawareBean.VIEW_FUNCTIONALITY) + "\">");
	buffer.append("<input type=\"hidden\" name=\"cubeName" + count + "\" value=\"" + data[1] + "\">");
	buffer.append("<input type=\"hidden\" name=\"viewName" + count + "\" value=\"" + ((data.length == 3)?data[2]:"") + "\">");
	buffer.append("<select name=\"fncFather" + count + "\">");
	buffer.append("<option value=\"" + Parameters.DW_COMPLETE_FATHER_ID.toString() + "\"" + ((fncVo != null && Parameters.DW_COMPLETE_FATHER_ID.equals(fncVo.getFncIdFather()))?" selected":"") + ">" + LabelManager.getName(labelSet,"mnuDwQryCom") + "</option>");
	buffer.append("<option value=\"" + Parameters.DW_RUNNING_FATHER_ID.toString() + "\"" + ((fncVo != null && Parameters.DW_RUNNING_FATHER_ID.equals(fncVo.getFncIdFather()))?" selected":"") + ">" + LabelManager.getName(labelSet,"mnuDwQryEje") + "</option>");
	buffer.append("<option value=\"" + Parameters.DW_OTHER_FATHER_ID.toString() + "\"" + ((fncVo != null && Parameters.DW_OTHER_FATHER_ID.equals(fncVo.getFncIdFather()))?" selected":"") + ">" + LabelManager.getName(labelSet,"mnuDwQryOth") + "</option>");
	buffer.append("</select>");
	if (DatawareBean.CUBE_FUNCTIONALITY.equals(data[0])) {
		buffer.append("<ul>");
	} else {
		buffer.append("</li>");
	}
	return buffer.toString();
}

private String processScoreCard(String labelSet, int count, Collection functionalities, String scoreCard) {
StringBuffer buffer = new StringBuffer();
	String[] data = scoreCard.split("·");
	FunctionalityVo fncVo = this.getFunctionlityVo(functionalities,data);
	String name = data[1];
	
	buffer.append("<input type=\"checkbox\" name=\"showFnc" + count + "\"" + ((fncVo != null)?" checked":"") + ">");
	buffer.append("<input type=\"hidden\" name=\"fncId" + count + "\" value=\"" + ((fncVo != null)?fncVo.getFncId().toString():"") + "\">");
	buffer.append("<input type=\"text\" maxlength=\"50\" size=\"80\" name=\"fncName" + count + "\" title=\"" + ((data.length == 3)?data[2]:data[1]) + "\" value=\"" + ((fncVo != null)?fncVo.getFncName():name) + "\">");
	buffer.append("<input type=\"hidden\" name=\"fncType" + count + "\" value=\"" + (DatawareBean.CUBE_FUNCTIONALITY.equals(data[0])?DatawareBean.CUBE_FUNCTIONALITY:DatawareBean.VIEW_FUNCTIONALITY) + "\">");
	buffer.append("<input type=\"hidden\" name=\"cardName" + count + "\" value=\"" + data[1] + "\">");
	buffer.append("<input type=\"hidden\" name=\"fncFather" + count + "\" value=\"" + Parameters.DW_SCORECARD_FATHER_ID.toString() + "\">");
	
	return buffer.toString();
}

private FunctionalityVo getFunctionlityVo(Collection functionalities, String[] data) {
	if (functionalities != null && functionalities.size() > 0) {
		String url = DatawareBean.generateFncUrl(data[0],data[1],(data.length == 3)?data[2]:"",data[1]);
		Iterator iterator = functionalities.iterator();
		FunctionalityVo fncVo = null;
		while (iterator.hasNext() && fncVo == null) {
			FunctionalityVo fnc = (FunctionalityVo) iterator.next();
			if (fnc.getFncUrl().equals(url)) {
				fncVo = fnc;
				functionalities.remove(fncVo);
			}
		}
		return fncVo;
	} else {
		return null;
	}
}

private String processBadFunctionalities(Collection functionalities) {
	if (functionalities != null && functionalities.size() > 0) {
		StringBuffer buffer = new StringBuffer();
		Iterator iterator = functionalities.iterator();
		while (iterator.hasNext()) {
			FunctionalityVo fncVo = (FunctionalityVo) iterator.next();
			buffer.append(fncVo.getFncName() + "<br>");
		}
		return buffer.toString();
	} else {
		return "";
	}
}

%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.DatawareBean"></jsp:useBean><style>
UL{
        MARGIN-TOP: 0px;
}
LI UL {
    DISPLAY: none;
    MARGIN-LEFT: 15px;
    MARGIN-RIGHT:0px;
}
</style></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDwFnc")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFncs")%></DIV><%
			Collection functionalities = dBean.getFunctionalities();
			if (dBean.getCubesAndViews() != null) {
				Iterator iterator = dBean.getCubesAndViews().iterator();
				int count = 0;
				while (iterator.hasNext()) { %><%= processCubeAndView(labelSet,count,functionalities,(String) iterator.next()) %><%
					count++;
				} %><input type="hidden" name="count" value="<%= count %>"><%
				if (dBean.getCubesAndViews().size() > 0) { %></ul><%
				}
			}
			%><br><div class="subTit"><%=LabelManager.getName(labelSet,"sbtBadFncs")%></div><%= processBadFunctionalities(functionalities) %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/configuration/dataware/functionalities.js'></script>

