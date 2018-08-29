<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.bi.BIEngine"%><%@include file="../../../components/scripts/server/startInc.jsp"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%></head><body onload="init()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.DashboardBean"></jsp:useBean><%
DashboardVo dshVo = dBean.getDashboardVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (dshVo.getDashboardId()==null)?true:dBean.hasWritePermission(request, dshVo.getDashboardId(), actualUser);

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDashboards")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatDashboard")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="dshName" p_required="true" maxlength="50" size="30" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(dshVo!=null) {%>value="<%=dBean.fmtStr(dshVo.getDashboardName())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><td><input name="dshTitle" p_required="true" maxlength="50" size="30" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" type="text" <%if(dshVo!=null) {%>value="<%=dBean.fmtStr(dshVo.getDashboardTitle())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><input name="dshDesc" maxlength="255" size="55" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(dshVo!=null) {%>value="<%=dBean.fmtStr(dshVo.getDashboardDesc())%>"<%}%>></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></tr></table><br><br><br><!--     - Perfiles con acceso al cubo   --><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblPrfAccDashboard")%></DIV><div type="grid" id="gridProfiles" style="height:200px"><table id="tblProfiles"  width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="200px" style="min-width:200px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody id="tblPerBody"><%  Collection widProfs = dshVo.getProfiles();
								if (widProfs != null && widProfs.size()>0){
								Iterator itProfiles = widProfs.iterator();
								while (itProfiles.hasNext()) {
									ProfileVo profileVo = (ProfileVo) itProfiles.next();
									%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPrfSel"><input type="hidden" name="chkPrf" value="<%=dBean.fmtInt(profileVo.getPrfId())%>"></td><td style="min-width:200px"><%if(profileVo.getPrfAllEnv().intValue() == 1){out.print("<B>");}%><%=dBean.fmtHTML(profileVo.getPrfName())%></td><%if(profileVo.getPrfAllEnv().intValue() == 1){out.print("</B>");}%></tr><%
								} 
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" id="btnAddCbePrf" onclick="btnAddProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" id="btnDelCbePrf" onclick="btnDelProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><br></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDsgDash")%>" tabText="<%=LabelManager.getName(labelSet,"tabDsgDash")%>"><!--    DISEÑO DEL DASHBOARD    --><TABLE WIDTH="100%" HEIGHT="100%" BORDER=0 cellspacing=0><TR><TD VALIGN="middle" ALIGN="center"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="50%" height="50%" id="dashDesign" align="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/programs/biDesigner/dashboards/dashboardDesigner.swf" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" /><param name="wmode" value="windowed" /><param name="flashVars" value='xmlUrl=<%=Parameters.ROOT_PATH%>/programs/biDesigner/dashboards/dashboard.jsp'/><embed src="<%=Parameters.ROOT_PATH%>/programs/biDesigner/dashboards/dashboardDesigner.swf" wmode="transparent" quality="high" bgcolor="#ffffff" flashvars="xmlUrl=<%=Parameters.ROOT_PATH%>/programs/biDesigner/dashboards/dashboard.jsp" width="50%" height="50%" name="dashDesign" id="dashDesign" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /></object></TD></TR></TABLE><table class="navBar" style="display:none"><tr><td vAlign="middle"><TEXTAREA id="txtXML" name="txtXML" cols="100" rows="30"><%=StringUtil.replace(dBean.getDashboardXML(),"&","&amp;")%></TEXTAREA></td><td><button type="button" id="btnConfirm" onclick="obtainXML()" title="Confirmar">Confirmar</button></td></tr></table></div><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDshPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabDshPer")%>"><%@ include file="permissions.jsp" %></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="obtainXML()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><iframe style="height=0px;width:0px" border="no" id="iframeSize"></iframe></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%><script language="javascript" defer="true" src='<%=Parameters.ROOT_PATH%>/programs/biDesigner/dashboards/update.js'></script><script type="text/javascript">
MSG_MUST_ENT_ONE_PRF = "<%=LabelManager.getName(labelSet,"msgMustEntOnePrfForDsh")%>";
MSG_MUST_ENT_ONE_WID = "<%=LabelManager.getName(labelSet,"msgMustEntOneWidget")%>";
LBL_CHK_WID_NAME = "<%=LabelManager.getToolTip(labelSet,"lblChkVwWidName")%>";
LBL_CHK_WID_DESC = "<%=LabelManager.getToolTip(labelSet,"lblChkVwWidDesc")%>";
MSG_MUST_ENT_DSH_WID = "<%=LabelManager.getName(labelSet,"msgMustEntSchWidth")%>";
MSG_MUST_ENT_DSH_HEI = "<%=LabelManager.getName(labelSet,"msgMustEntSchHeight")%>";
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";

function obtainXML(){
	if(flashLoadedVar){
		getFlashMovie("dashDesign").getDashDesignXML();
		//document.getElementById("txtXML").value = getMyApp("dashDesign").getDashDesignXML();
	}else{
		btnConf_click();
	}
}

function getMyApp(appName) {
   return document[appName];
}

function sendSize(){
	var width=getStageWidth();
	var height=getStageHeight();
	document.getElementById("iframeSize").src="<%=Parameters.ROOT_PATH%>/programs/biDesigner/dashboards/dashboard.jsp?setSize=true&width="+width+"&height="+height;
}

function sizeFlash(){
	if(!MSIE){
		var divContent=document.getElementById("divContent");
		getMyApp("dashDesign").setAttribute("width",divContent.offsetWidth);
		getMyApp("dashDesign").setAttribute("height",(divContent.offsetHeight-5));
	}
}

function init(){
	sendSize();
	sizeFlash();
}

</script>