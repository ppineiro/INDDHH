<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.analitic.DatawareBean"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%! 
private String generateCode(DatawareBean dBean, Collection col, String labelSet) {
	StringBuffer buffer = new StringBuffer();
	if (col != null) {
		Iterator iterator = col.iterator();
		Object obj = null;
		ParametersVo param = null;
		String divTitle = null;
		while (iterator.hasNext()) {
			obj = iterator.next();
			if (obj instanceof ParametersVo) {
				param = (ParametersVo) obj;
				if (param.getPrmType() != ParametersVo.PARAM_TYPE_HIDDE) {
					buffer.append("<tr>");
					buffer.append("<td title=\"" +LabelManager.getToolTip(labelSet,param.getParameterId()) + "\">" + LabelManager.getNameWAccess(labelSet,param.getParameterId()) + ":</td>");
					buffer.append("<td colspan=\"3\">");
					switch (param.getPrmType()) {
						case ParametersVo.PARAM_TYPE_STRING :
							buffer.append("<input name=\"" + param.getParameterId() + "\" maxlength=\"255\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
							break;
		
						case ParametersVo.PARAM_TYPE_NUMBER :
							buffer.append("<input name=\"" + param.getParameterId() + "\" type=\"text\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" p_required=true p_numeric='true'  accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
							break;
		
						case ParametersVo.PARAM_TYPE_PASSWORD :
							buffer.append("<input name=\"" + param.getParameterId() + "\" type=\"password\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" p_required=true p_numeric='true'  accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
							break;
					}
				}
			} else {
				buffer.append("<tr>");
				buffer.append("<td colspan=\"4\"><DIV class=\"subTit\">"+ LabelManager.getName(labelSet,obj.toString()) +"</DIV>");
			}
			buffer.append("</td></tr>");
		}
	}
	return buffer.toString();
}


private String processAttributes(DatawareBean dBean, Collection col, String labelSet, String type, String styleDirectory) {
	StringBuffer buffer = new StringBuffer();
	if (col != null) {
		String id = null;
		int count = 0;

		Iterator iterator = col.iterator();
		while (iterator.hasNext()) {
			EnvDwAttributeVo attributeVo = (EnvDwAttributeVo) iterator.next(); 
			if (attributeVo == null) {
				attributeVo = new EnvDwAttributeVo();
			}
			id = type + count; 
			buffer.append("<tr>");
			buffer.append("<td align=\"right\" style=\"width:20%;\">" + LabelManager.getNameWAccess(labelSet,"lblDwAtt" + id) + ":</td>");
			buffer.append("<td align=\"center\" style=\"width:20%;\">");
			buffer.append("<input type=\"text\" accessKey=\"" + LabelManager.getAccessKey(labelSet,"lblDwAtt" + id) + "\" name=\"txtNam" + id +"\" value=\"" + ((attributeVo.getEnvDwName() != null)?attributeVo.getEnvDwName():"") + "\">");
			buffer.append("</td>");
			buffer.append("<td align=\"center\" style=\"white-space:nowrap;width:40%;\">");
			buffer.append("<input type=\"hidden\" name=\"hidEnvId" + id + "\" value=\"" + ((attributeVo.getEnvId() != null)?attributeVo.getEnvId().toString():"") + "\">");
			buffer.append("<input type=\"hidden\" name=\"hidAttId" + id + "\" value=\"" + ((attributeVo.getAttId() != null)?attributeVo.getAttId().toString():"") + "\">");
			buffer.append("<input type=\"text\" name=\"txtAttNam" + id + "\" value=\"" + ((attributeVo.getAttName() != null)?attributeVo.getAttName():"") + "\" readonly class=\"txtReadOnly\">");
			buffer.append("<img src=\"" + Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/btnQuery.gif\" accessKey=\"" + LabelManager.getAccessKey(labelSet,"lblDwAtt" + id) + "\" onclick=\"btnLoadAtt_click(" + count + ",'" + type + "')\" style=\"cursor:hand\" accesskey=\"\">");
			buffer.append("<img src=\"" + Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/eraser.gif\" onclick=\"btnRemAtt_click(" + count + ",'" + type + "')\" title=\"" + LabelManager.getToolTip(labelSet,"btnRemAtt") + "\" accesskey=\"" + LabelManager.getAccessKey(labelSet,"btnRemAtt") + "\">");
			buffer.append("</td>");
			buffer.append("<td align=\"center\" style=\"width:20%;\">");
			buffer.append("<select name=\"cmbAttFrom" + id + "\"");
			if (attributeVo.getAttId() == null) {
				buffer.append(" disabled=true");
			}
			buffer.append(" accessKey=\"" + LabelManager.getAccessKey(labelSet,"lblDwAtt" + id) + "\">");
			buffer.append("<option value=\"" + EnvDwAttributeVo.ATTRIBUTE_FROM_PROCESS + "\"" + (EnvDwAttributeVo.ATTRIBUTE_FROM_PROCESS.equals(attributeVo.getEnvDwAttFrom())?" selected":"") + ">" + LabelManager.getName(labelSet,"lblPro") + "</option>");
			buffer.append("<option value=\"" + EnvDwAttributeVo.ATTRIBUTE_FROM_ENTITY + "\"" + (EnvDwAttributeVo.ATTRIBUTE_FROM_ENTITY.equals(attributeVo.getEnvDwAttFrom())?" selected":"") + ">" + LabelManager.getName(labelSet,"lblEnt") + "</option>");
			buffer.append("</select>");
			buffer.append("</td>");
			buffer.append("</tr>");
			count ++;
		}
	}
	return buffer.toString();
} 
%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.analitic.DatawareBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDw")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDwParam")%>" tabText="<%=LabelManager.getName(labelSet,"tabDwParam")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDwParam")%></DIV><table class="tblFormLayout"><%= generateCode(dBean,dBean.getConnectionParams(),labelSet) %><tr><td title="<%=LabelManager.getToolTip(labelSet,"prmtDwLan")%>"><%=LabelManager.getNameWAccess(labelSet,"prmtDwLan")%>:</td><td colspan="3"><select name="prmtDwLan" accesskey="<%= LabelManager.getAccessKey("prmtDwLan") %>"><option value="en" <%= "en".equals(dBean.getLanId())?"selected":"" %>><%= LabelManager.getName("lblDwLanEn") %></option><option value="es" <%= "es".equals(dBean.getLanId())?"selected":"" %>><%= LabelManager.getName("lblDwLanEs") %></option><option value="pt" <%= "pt".equals(dBean.getLanId())?"selected":"" %>><%= LabelManager.getName("lblDwLanPt") %></option></select></td></tr><tr><td></td><td colspan="3"><button type="button" onclick="btnTest_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTestDW")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTestDW")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTestDW")%></button></td></tr></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDwAtt")%>" tabText="<%=LabelManager.getName(labelSet,"tabDwAtt")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDwAtt")%></DIV><table class="tblFormLayout"><tr><td></td><td align="center"><%= LabelManager.getName(labelSet,"lblDwName")%></td><td align="center"><%= LabelManager.getName(labelSet,"lblDwAtt")%></td><td align="center"><%= LabelManager.getName(labelSet,"lblDwAttFrom")%></td></tr><%= processAttributes(dBean, dBean.getStringAttribute(), labelSet, EnvDwAttributeVo.TYPE_STRING,styleDirectory) %><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><%= processAttributes(dBean, dBean.getNumericAttribute(), labelSet, EnvDwAttributeVo.TYPE_NUMERIC,styleDirectory) %><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><%= processAttributes(dBean, dBean.getDateAttribute(), labelSet, EnvDwAttributeVo.TYPE_DATE,styleDirectory) %></table></div></div></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>

var TYPE_STRING = "<%= EnvDwAttributeVo.TYPE_STRING %>";
var TYPE_NUMERIC = "<%= EnvDwAttributeVo.TYPE_NUMERIC %>";
var TYPE_DATE = "<%= EnvDwAttributeVo.TYPE_DATE %>";

var COUNT_STRING = <%= EnvDwAttributeVo.TYPE_STRING_COUNT %>;
var COUNT_NUMERIC = <%= EnvDwAttributeVo.TYPE_NUMERIC_COUNT %>;
var COUNT_DATE = <%= EnvDwAttributeVo.TYPE_DATE_COUNT %>;

</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/configuration/dataware/parameters.js'></script><script>
function tabSwitch(){
}
</SCRIPT>