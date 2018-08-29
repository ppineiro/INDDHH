<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.FormBean"></jsp:useBean><%
FormVo formVo = dBean.getFormVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (formVo.getFrmId()==null)?true:dBean.hasWritePermission(request, formVo.getFrmId(), formVo.getPrjId(), actualUser);

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titFor")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type ="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getName(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatFor")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   								boolean hasProject = (formVo.getPrjId() != null && formVo.getPrjId().intValue() != 0);%><td title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td colspan=2><input type=hidden name="txtPrj" value=""><%if(formVo.getFrmFather()!=null){%><span><%if (colProj != null && colProj.size()>0) {
		   							  Iterator itPrj = colProj.iterator();
		   							  ProjectVo prjVo = null;
		   						  	  while (itPrj.hasNext()) {
		   								prjVo = (ProjectVo) itPrj.next();
		   								if (hasProject) {
		   									if (prjVo.getPrjId().equals(formVo.getPrjId())) {%><b><%=prjVo.getPrjName()%></b><input type="hidden" name="selPrj" value="<%=prjVo.getPrjId()%>" /><%}
										}
			   						  }
			   					    }%></span><%}else{%><select name="selPrj" onchange="cmbProySel()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
			   							Iterator itPrj = colProj.iterator();
			   							ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
		   									prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
		   									<%if (hasProject) {
												if (prjVo.getPrjId().equals(formVo.getPrjId())) {
													out.print ("selected");
												}%>
												><%=prjVo.getPrjName()%></option><%} else {%>
												><%=prjVo.getPrjName()%></option><%}
			   							}
		   							}%></select><%}%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><%if(formVo.getFrmFather()!=null){%><td><span><%if(formVo!=null) {%><b><%=dBean.fmtStr(formVo.getFrmName())%></b><%}%></span><input type="hidden" name="txtName" id="txtName" value="<%=dBean.fmtStr(formVo.getFrmName())%>" /></td><%}else{%><td><input p_required=true name="txtName" id="txtName" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(formVo!=null) {%>value="<%=dBean.fmtStr(formVo.getFrmName())%>"<%}%>></td><%}%><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><%if(formVo.getFrmFather()!=null){%><td><span><%if(formVo!=null) {%><b><%=dBean.fmtStr(formVo.getFrmTitle())%></b><%}%></span><input type="hidden" name="txtTitle" id="txtTitle" value="<%=dBean.fmtStr(formVo.getFrmTitle())%>" /></td><%}else{%><td colspan=3><input p_required=true name="txtTitle" onchange="document.getElementById('docTit').value=this.value"  id="txtTitle" size=80 maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" type="text" <%if(formVo!=null) {%>value="<%=dBean.fmtStr(formVo.getFrmTitle())%>"<%}%>></td><%}%></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><input  name="txtDesc" id="txtDesc" maxlength="255" size=80 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(formVo!=null) {%>value="<%=dBean.fmtStr(formVo.getFrmDesc())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblFrmSign")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFrmSign")%>:</td><td><select name="cmbSign" id="cmbSign"><option <%if(formVo!=null && !formVo.getFlagValue(FormVo.FLAG_SIGNABLE)) {%>selected<%}%> value='0'><%=LabelManager.getName(labelSet,"lblNo")%></option><option <%if(formVo!=null && formVo.getFlagValue(FormVo.FLAG_SIGNABLE)) {%>selected<%}%> value='1'><%=LabelManager.getName(labelSet,"lblSi")%></option><option <%if(formVo!=null && formVo.getFlagValue(FormVo.FLAG_SIGNABLE_REQ)) {%>selected<%}%> value='2'><%=LabelManager.getName(labelSet,"lblAllways")%></option></select></td><td><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></td><td></td></tr></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabForLay")%>" tabText="<%=LabelManager.getToolTip(labelSet,"tabForLay")%>"><!--     - LAYOUT FLASH         --><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"  
					 codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" 
						WIDTH="100%" 
						HEIGHT="500px" 
						style="/*border:1px solid black*/"
						id="shell" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/form/deploy/shell.swf" /><!--param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/form_designer/bin/formdesigner.swf" /--><param name="FlashVars" value="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/form/deploy/<%if(formVo.getFrmFather()!=null){%>&isFormView=true<%}%><%=windowId%>" /><!--param name="FlashVars" value="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&urlBase=<%=Parameters.ROOT_PATH%>/flash/form_designer/bin/<%if(formVo.getFrmFather()!=null){%>&isFormView=true<%}%><%=windowId%>" /--><param name="quality" value="high" /><param name="menu" value="false"/><param name="bgcolor" value="#efefef" /><param name="WMODE" value="transparent" /><embed wmode="transparent" menu="false" allowScriptAccess="sameDomain" src="<%=Parameters.ROOT_PATH%>/flash/form/deploy/shell.swf" quality="high" bgcolor="#efefef" width="100%" height="450" swLiveConnect="true" id="shell" name="shell" align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/form/deploy/<%if(formVo.getFrmFather()!=null){%>&isFormView=true<%}%><%=windowId%>" /><!--embed wmode="transparent" menu="false" allowScriptAccess="sameDomain" src="<%=Parameters.ROOT_PATH%>/flash/form_designer/bin/formdesigner.swf" quality="high" bgcolor="#efefef" width="100%" height="450" swLiveConnect="true" id="shell" name="shell" align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&urlBase=<%=Parameters.ROOT_PATH%>/flash/form_designer/bin/<%if(formVo.getFrmFather()!=null){%>&isFormView=true<%}%><%=windowId%>" /--></object><button type="button" onclick="getSWFVersions()" style="display:none">getVersion</button><TEXTAREA name="txtMap" id="txtMap" cols="100" rows="30" style="display:none"><%=formVo.getGeneratedXML()%></TEXTAREA></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDocFor")%>" tabText="<%=LabelManager.getToolTip(labelSet,"tabDocFor")%>"><!--     - DOCUMENTS          --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDoc")%></DIV><jsp:include page="../../documents/documents.jsp" flush="true"><jsp:param name="docBean" value="form"/></jsp:include><script src="<%=Parameters.ROOT_PATH%>/programs/documents/documents.js"></script></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"sbtDatAjax")%>" tabText="<%=LabelManager.getToolTip(labelSet,"sbtDatAjax")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatAjax")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDisAjax")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDisAjax")%>:</td><td colspan=3><input  name="txtFireAjax"  type=checkbox accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDisAjax")%>" type="text" <%if(formVo!=null && formVo.getFrmFiresAjax()!=null && formVo.getFrmFiresAjax().intValue() != 0) {%> checked <%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblRefreshAjax")%>"><%=LabelManager.getNameWAccess(labelSet,"lblRefreshAjax")%>:</td><td colspan=3><input  name="txtUpdateAjax"  type=checkbox accesskey="<%=LabelManager.getAccessKey(labelSet,"lblRefreshAjax")%>" type="text" <%if(formVo!=null && formVo.getFrmUpdatedByAjax()!=null && formVo.getFrmUpdatedByAjax().intValue() != 0) {%> checked <%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblRefROAjax")%>"><%=LabelManager.getNameWAccess(labelSet,"lblRefROAjax")%>:</td><td colspan=3><input  name="txtROAjax"  type=checkbox accesskey="<%=LabelManager.getAccessKey(labelSet,"lblRefROAjax")%>" type="text" <%if(formVo!=null && formVo.getFrmAjaxReadonly()!=null && formVo.getFrmAjaxReadonly().intValue() != 0) {%> checked <%}%>></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabTskDoc")%>" tabText="<%=LabelManager.getName(labelSet,"tabTskDoc")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocFor")%></DIV><table class="tblFormLayout" cellpadding="0" cellspacing="0"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocId")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocId")%>:</td><td><input name="txtDocID" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDocId")%>" type="text" <%if(formVo!=null) {%>value="<%=dBean.fmtStr(formVo.getFrmUniqueId())%>"<%}%>></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocTit")%>:</td><td><input id="docTit" readonly class="txtReadOnly" p_readonly="true" <%if(formVo!=null) {%>value="<%=dBean.fmtStr(formVo.getFrmTitle())%>"<%}%>></td><td></td><td></td></tr></table><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtForEvt")%></DIV><div type="grid" id="gridForEvtForm" height="100"><table id="tblForEvt" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblForEvt")%>"><%=LabelManager.getName(labelSet,"lblForEvt")%></th><th min_width="675px" style="width:675px" title="<%=LabelManager.getToolTip(labelSet,"lblForAct")%>"><%=LabelManager.getName(labelSet,"lblForAct")%></th></tr></thead><tbody id="gridForEvtFormBody"><% 
						if(formVo!=null && formVo.getFrmDocEvents()!=null && formVo.getFrmDocEvents().size() > 0) {
							Iterator itE = formVo.getFrmDocEvents().iterator();
							while(itE.hasNext()){
								FrmDocEventsVo vo = (FrmDocEventsVo)itE.next();
								%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkEnvSel"><input type=hidden name="chkEnv" value="<%//=dBean.fmtInt(environmentVo.getEnvId())%>"></td><td><select name="cmbFrmEvt"><option value='<%=EventVo.EVENT_FRM_ONLOAD%>' <%if(EventVo.EVENT_FRM_ONLOAD==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONLOAD</option><option value='<%=EventVo.EVENT_FRM_ONRELOAD%>' <%if(EventVo.EVENT_FRM_ONRELOAD==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONRELOAD</option><option value='<%=EventVo.EVENT_FRM_ONSUBMIT%>' <%if(EventVo.EVENT_FRM_ONSUBMIT==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONSUBMIT</option><option value='<%=EventVo.EVENT_FRM_ONBEFORE_PRINT%>' <%if(EventVo.EVENT_FRM_ONBEFORE_PRINT==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONBEFOREPRINT</option><option value='<%=EventVo.EVENT_FRM_ONAFTER_PRINT%>' <%if(EventVo.EVENT_FRM_ONAFTER_PRINT==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONAFTERPRINT</option></select></td><td><input type="text" name="txtEvtFrmDoc"  maxlength=3000 size=130 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"><input type="hidden" name="txtFrmObjId"  value="<%=dBean.fmtStr(vo.getObjId())%>"></td></tr><% 
							} 
						  } %></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnAddFormEvt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelFormEvt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr ></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtForFieldEvt")%></DIV><div type="grid" id="gridForEvt" height="100"><table id="tblForEvt" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblForObj")%>"><%=LabelManager.getName(labelSet,"lblForObj")%></th><th min_width="120px" style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblForEvt")%>"><%=LabelManager.getName(labelSet,"lblForEvt")%></th><th min_width="520px" style="width:520px" title="<%=LabelManager.getToolTip(labelSet,"lblForAct")%>"><%=LabelManager.getName(labelSet,"lblForAct")%></th></tr></thead><tbody id="tblForEvtBody"><% 
						if(formVo!=null && formVo.getFldDocEvents()!=null && formVo.getFldDocEvents().size() > 0) {
							Iterator itE = formVo.getFldDocEvents().iterator();
							while(itE.hasNext()){
								FrmDocEventsVo vo = (FrmDocEventsVo)itE.next();
								%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkEnvSel"><input type=hidden name="chkEnv" value="<%//=dBean.fmtInt(environmentVo.getEnvId())%>"></td><td><input type="text" name="txtEvtObj" width="70"  maxlength=255 value="<%=dBean.fmtStr(vo.getObjId())%>"></td><td><select name="cmbFldEvt"><option value='<%=EventVo.EVENT_FLD_ONCHANGE%>' <%if(EventVo.EVENT_FLD_ONCHANGE==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONCHANGE</option><option value='<%=EventVo.EVENT_FLD_ONCLICK%>' <%if(EventVo.EVENT_FLD_ONCLICK==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONCLICK</option><option value='<%=EventVo.EVENT_FLD_POPULATE%>' <%if(EventVo.EVENT_FLD_POPULATE==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONPOPULATE</option><option value='<%=EventVo.EVENT_FLD_ONMODALRETURN%>' <%if(EventVo.EVENT_FLD_ONMODALRETURN==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONMODALRETURN</option><option value='<%=EventVo.EVENT_FLD_GRID_ADD%>' <%if(EventVo.EVENT_FLD_GRID_ADD==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONROWADD</option><option value='<%=EventVo.EVENT_FLD_GRID_DEL%>' <%if(EventVo.EVENT_FLD_GRID_DEL==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONROWDEL</option><option value='<%=EventVo.EVENT_FLD_GRID_SORT%>' <%if(EventVo.EVENT_FLD_GRID_SORT==(vo.getEvtId().intValue())){out.print(" selected ");} %> >ONROWSORT</option></select></td><td><input type="text" name="txtEvtFldDoc" maxlength="3000" size="100" value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><% 
							} 
						  } %></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnAddFieldEvt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelFieldEvt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr ></table></div><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabFrmPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabFrmPer")%>"><%@ include file="permissions.jsp" %></div></div><input type="hidden" id="hidFlashLoaded" name="hidFlashLoaded" value="false"></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD><% /* 
					<button type="button" onclick="showFlashInput()" >XML Input</button><button type="button" onclick="showFlashOutput()">XML Output</button> */ %></TD><TD align="right"><button type="button" <%=(!saveChanges)?"disabled":"" %> onclick="actionAfterFlash='confirm';showFlashOutput()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button><!--     - <button type="button" onclick="btnConf_click()">test</button>          --></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";
  
</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/administration/form/update.js'></script><script language="javascript">
function tabSwitch(){
}

var cmbFieldsHTML = "<%=dBean.getFieldsEvtCmbHTML(request)%>";
var cmbFormsHTML = "<%=dBean.getFormEvtCmbHTML(request)%>";

//////////////////////////////////////////////////////////////////
//	FLASH FNs
//////////////////////////////////////////////////////////////////
// Handles all the FSCommand messages in a Flash movie

var flashLoaded = false;
var actionAfterFlash = "";
var flashShown=false;

function shell_DoFSCommand(command, args) {
	var shellObj
	var isInternetExplorer=(navigator.userAgent.indexOf("MSIE")>0);
	var shellObj = isInternetExplorer ? document.all.sin : document.sin;
	if (command == "outputXML") {
		showFlashXML(args,"1")
	}
	if(command == "inputXML") {
		showFlashXML(args,"2")
	}
	if(command == "hideFlash") {
		if(args!="" && args!="undefined" && args!=null){
			document.getElementById("txtMap").value=args;
			//var flashObj=getFlashObject("shell");
			var flashObj=document.getElementsByTagName("EMBED")[0];
			var flashVars=flashObj.getAttribute("flashVars");
			flashVars=flashVars.split("&stringModel=")[0];
			args=args.split("\"&lt;").join(escape("\"&amp;lt;"));
			args=args.split("&gt;\"").join(escape("&amp;gt;\""));
			flashVars+=("&stringModel="+args);
			flashObj.setAttribute("flashVars",flashVars);
			hideAllContents();
			document.getElementById("tab"+listener.contentNumber).parentNode.className="here";
			document.getElementById("content"+listener.contentNumber).style.display="block";
			var container=window.parent.document.getElementById(window.name);
			if (container != null) {
				container.style.display="none";
				container.style.display="block";
			}
			flashShown=false;
		}
	}
	if (command == "isReady") {
		flashLoaded = true;
		document.getElementById("hidFlashLoaded").value = "true";
		flashShown=true;
	}
	if (command == "largalo") {
		//alert(args);
	}
	if(command == "getSWFVersions"){
		alert(args);
	}
}


function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtName").value)){
			if (verifyPermissions()){
				document.getElementById("frmMain").action = "administration.FormAction.do?action=confirm";
				document.getElementById("samplesTab").showContent(0);
				submitForm(document.getElementById("frmMain"));
			}
		}
	}	
}


function showFlashOutput(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		if (flashLoaded==true || flashLoaded=="true"){
				getFlashObject("shell").SetVariable("call", "getOutputXML");
		} else {
			btnConf_click();
		}
	}else{
		if((flashLoaded==true || flashLoaded=="true")&& flashShown){
			getFlashObject("shell").SetVariable("call", "getOutputXML");
		} else {
			btnConf_click();
		}
	}
}

function showFlashInput(){
	if (flashLoaded) {
		var shell = getFlashObject("shell");
		shell.SetVariable("call", "getInputXML");
	}
}


function verifyPermissions(){
	if (!document.getElementById("usePrjPerms").checked){ //Si no se usan los permisos del proyecto
		//Verificamos si almenos una persona tiene acceso de modificacion
		var permRows=document.getElementById("permGrid").rows;
		var someoneCanModify = false;
		for(var i=0;i<permRows.length;i++){
			var canModify= ("1" == permRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value);
			if(canModify){//Verificamos que los nombres de los atributos no sean nulos
				someoneCanModify = true;
			}
		}
		if (!someoneCanModify){
			alert(MSG_PERMISSIONS_ERROR);	
			return false;
		}
	}
	return true;
}

//////////////////////////////////
//	DEBUG
//////////////////////////////
function showHTML(html,winName){

var w = window.open("",winName,"height=480,width=680,resizable=yes,scrollbars=yes");
	w.document.open();
    w.document.write(html);
    w.document.close();
    w.focus();
}		

function showFlashXML(doc,winName){
	var oXML;
	var tempdoc;
	if(navigator.userAgent.indexOf("MSIE")>0){
		oXML = new ActiveXObject("Microsoft.XMLDOM");
		tempdoc = new ActiveXObject("Microsoft.XMLDOM");
		oXML.loadXML(doc);
	}else{
		//oXML= document.implementation.createDocument("", "", null);
		tempdoc = document.implementation.createDocument("", "", null);
		var objDOMParser = new DOMParser(); 
		oXML = objDOMParser.parseFromString(doc,"text/xml");
	}
    tempdoc.async = false;
    /*if (!tempdoc.load(URL_ROOT_PATH + "/flash/process/xml/mimedefault.xsl")){
		//showHTML(reportParseError(tempdoc.parseError));
		alert("ERROR loading XSL")
	}else{*/
		if (actionAfterFlash == "confirm") {
			document.getElementById("txtMap").value=doc;
			btnConf_click();
		} else {
			var html = transformNode(oXML,tempdoc);
	    	showFlashHTML(html,winName);
	    }
    //}
}
var listener;

function hideFlash(){
	getFlashObject("shell").SetVariable("call","hideFlash");
}

function showContent(contentNumber){
	if(document.getElementById("content"+contentNumber).style.display!="block"){
		if(navigator.userAgent.indexOf("MSIE")<0){
			if(contentNumber!=1 && flashLoaded && document.getElementById("content1").style.display=="block"){
				listener.contentNumber=contentNumber;
				hideFlash();
			}else{
				hideAllContents();
				document.getElementById("tab"+contentNumber).parentNode.className="here";
				document.getElementById("content"+contentNumber).style.display="block";
				var container=window.parent.document.getElementById(window.name);
				if(container){
					container.style.display="none";
					container.style.display="block";
				}
			}
		}else{
			hideAllContents();
			document.getElementById("tab"+contentNumber).parentNode.className="here";
			document.getElementById("content"+contentNumber).style.display="block";
		}
	}
	/*if(navigator.userAgent.indexOf("MSIE")<0){
		var continer=window.parent.document.getElementById(window.name);
		continer.style.display="none";
		continer.style.display="block";
	}*/
}
function hideAllContents(){
	for(var i=0;i<3;i++){
		/*if(i==1 && (navigator.userAgent.indexOf("MSIE")<0)){
			if(document.getElementById("flashContainer").clientWidth>0){
				document.getElementById("flashContainer").setAttribute("realWidth",document.getElementById("flashContainer").clientWidth);
			}
			document.getElementById("tab"+i).parentNode.className="";
			//document.getElementById("flashContainer").style.height="500px";
			document.getElementById("flashContainer").style.width="0px";
			document.getElementById("flashContainer").style.height="0px";
//			getFlashObject("shell").style.height="500px";
		}else{*/
			document.getElementById("tab"+i).parentNode.className="";
			document.getElementById("content"+i).style.display="none";
		//}
	}
}

function getSWFVersions(){
	getFlashObject("shell").SetVariable("call", "getSWFVersions");
}

</SCRIPT><SCRIPT LANGUAGE="VBScript">
Sub shell_FSCommand(ByVal command, ByVal args)
    call shell_DoFSCommand(command, args)
end sub
</SCRIPT><script language="javascript">
function getFlashObject(movieName){
	if (window.document[movieName]){
		return window.document[movieName];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds[movieName]){
			return document.embeds[movieName];
		}
	}else{ // if (navigator.appName.indexOf("Microsoft Internet")!=-1){
		return document.getElementById(movieName);
	}
}
</script>

