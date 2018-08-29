<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MessageBean"></jsp:useBean><%
EnvMessageVo messageVo = dBean.getMessageVo();
boolean blockFrom = dBean.getBlockFrom();
boolean blockAll = dBean.getBlockAll();
//boolean blockFrom = (messageVo != null) && (messageVo.getEnvMsgDateFrom() != null) && messageVo.getEnvMsgDateFrom().before(new java.util.Date());
//boolean blockAll = blockFrom && messageVo.getEnvMsgDateTo().before(new java.util.Date());
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titMen":"titMenEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatMen")%></DIV><table class="tblFormLayout"><%if(dBean.isModeGlobal()){%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblAmb")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAmb")%>:</td><td colspan='3'><% if (messageVo != null && messageVo.getEnvId() == null) { 
		   						
		   				%><select name="cmbEnv_" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAmb")%>" onchange="changeCmb(this)"><option></option><%
  								Collection col = dBean.getAllEnvs();
	  							if (col != null) {
									Iterator it = col.iterator();
									EnvironmentVo eVo = null;
									while (it.hasNext()) {
										
										eVo = (EnvironmentVo)it.next();
										
										%><option value="<%=eVo.getEnvId()%>"  <%if(messageVo!=null){if(messageVo.getEnvId()!=null && messageVo.getEnvId().equals(eVo.getEnvId())){out.println("selected");}}%> ><%=eVo.getEnvName()%></option><%
									}
								}
	  							%></select><input type="hidden" name="cmbEnv" ><% } else {
 							Collection col = dBean.getAllEnvs();
 							if (col != null) {
								Iterator it = col.iterator();
								EnvironmentVo eVo = null;
								while (it.hasNext()) {
								eVo = (EnvironmentVo)it.next();
									if(messageVo.getEnvId()!=null && messageVo.getEnvId().equals(eVo.getEnvId())){%><input type="hidden" name="cmbEnv" value="<%=eVo.getEnvId()%>"><%=eVo.getEnvName()%><%
										break;
									}
								}
							}
			   			}%></td></tr><%}else{%><input type="hidden" name="cmbEnv" value="<%=dBean.getEnvId(request)%>"><%}%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblTexMen")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTexMen")%>:</td><td colspan=3><input name="txtMessage" p_required="true" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTexMen")%>" type="text" <%if(messageVo!=null) {%> value="<%=dBean.fmtStr(messageVo.getEnvMsgText())%>"<%}%> style="width:90%"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblFecDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFecDes")%>:</td><td><input name="txtFchDes" p_required="true" size="10" <% if (! blockFrom) {%>p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>"<%}%> maxlength="10" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFecDes")%>" type="text" <%if(messageVo!=null) {%> value="<%=dBean.fmtDate(messageVo.getEnvMsgDateFrom())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblFecHas")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFecHas")%>:</td><td><input name="txtFchHas" p_required="true" size="10" <% if (! blockAll) {%>p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>"<%}%> maxlength="10" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFecHas")%>" type="text" <%if(messageVo!=null) {%> value="<%=dBean.fmtDate(messageVo.getEnvMsgDateTo())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblTodGru")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTodGru")%>:</td><td><input id="chkAllPools" name="chkAllPools" type="checkbox" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTodGru")%>" <%if(messageVo!=null && messageVo.getEnvMsgAllPools() != null && messageVo.getEnvMsgAllPools().intValue() == 1) {%> checked <%}%> onclick="ckhPoolClick(this)"></td><td></td><td></td></tr></table><!--     - POOLS A SER NOTIFICADOS          --><div id="divPools"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtPooNot")%></DIV><div type="grid" id="gridPools" style="height:100px"><table id="tblPools" width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody id="tblPoolBody"><%if (messageVo.getMsgPools() != null){
						Iterator itPools = messageVo.getMsgPools().iterator();
						while (itPools.hasNext()) {
							PoolVo poolVo = (PoolVo) itPools.next();
							%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPoolSel"><input type=hidden name="chkPool" value="<%=dBean.fmtInt(poolVo.getPoolId())%>"><input type=hidden name="hidPoolName" value="<%=dBean.fmtHTML(poolVo.getPoolName())%>"></td><td><%=dBean.fmtHTML(poolVo.getPoolName())%></td></tr><%
						} 
					}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" id="addPool" name="addPool" onclick="btnAddPool_click()" <%if(dBean.isModeGlobal()){%>disabled<%} %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" name="delPool" onclick="btnDelPool_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></div></CONTROL:tab></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><% if(! blockAll) {%><button type="button" name="confirmar" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><%}%><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" defer=true src='<%=Parameters.ROOT_PATH%>/programs/security/messages/update.js'></script><SCRIPT>
var isGlobal = <%=dBean.isModeGlobal()%>;

function btnAddPool_click() {

	var rets = null;
	//if(isGlobal){
	//	rets = openModal("/programs/modals/pools.jsp?showAutogenerated=true&showGlobal=true",500,350);
		rets = openModal("/programs/modals/pools.jsp?showAutogenerated=true&envAndGlobal=true&envId="+document.getElementById("cmbEnv").value,500,350);
//	} else {
	//	rets = openModal("/programs/modals/pools.jsp?showAutogenerated=true&envAndGlobal=true&envId=<%=dBean.getEnvId(request)%>",500,350);
	//}
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridPools").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					
					oTd0.innerHTML = "<input type='checkbox' name='chkPoolSel'><input type='hidden' name='chkPool'><input type='hidden' name='hidPoolName' value=''>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.align="center";
					
					oTd1.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					document.getElementById("gridPools").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
	}else{
		doAfter(rets);
	}*/
}

function btnDelPool_click() {
	document.getElementById("gridPools").removeSelected();
}

if (<%= blockFrom %>) {
	document.getElementById("txtFchDes").disabled = true;

	if (<%= blockAll %>) {
		document.getElementById("cmbEnv").disabled = true;
		document.getElementById("txtMessage").disabled = true;
		document.getElementById("txtFchHas").disabled = true;
		document.getElementById("chkAllPools").disabled = true;
		document.getElementById("delPool").disabled = true;
		document.getElementById("addPool").disabled = true;
	}
}

function changeCmb(obj){
	document.getElementById("cmbEnv_").disabled = true;
	document.getElementById("cmbEnv").value = obj.value;
	document.getElementById("addPool").disabled = false;
	
}
</SCRIPT>
