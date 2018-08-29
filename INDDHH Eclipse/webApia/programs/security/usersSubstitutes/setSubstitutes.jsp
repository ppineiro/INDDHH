<%@page import="java.text.SimpleDateFormat"%><%@page import="java.text.DateFormat"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onload="loadPage()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.UserSubstituteBean"></jsp:useBean><%UsersSubstitutesVo userVo = dBean.getUserVo(); 
boolean isCurrentUser = dBean.isCurrentUser();
boolean fromList = dBean.isFromList();
boolean fromHierarchy = dBean.isFromHierarchy();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titSetUsrSub")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtSetUsrSub")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td  title="<%=LabelManager.getToolTip(labelSet,"lblLog")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLog")%>:</td><td><input id="txtLog" name="txtLog" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLog")%>" <%if(userVo != null && userVo.getUsrLogin()!=null){%> value="<%=userVo.getUsrLogin()%>" <%}%>disabled><%if(isCurrentUser || !fromList) {%><img onclick="btnSelUsr_click()" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" style="position: static;" /><%}%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblDteTo")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDteTo")%>:</td><td><input type="checkbox" id="chkEndDate"   onclick="changeEndDateChk()"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDteFrom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDteFrom")%>:</td><td><input name="txtDteFrom" p_required="true" size=10 maxlength="10" <%if(userVo != null && userVo.getStartDate()!=null){out.print(" disabled ");}%> p_calendar="true" class="txtDate" onchange= "getUser()" p_mask="<%=com.dogma.util.DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDteFrom")%>" type="text"  <%if(userVo != null && userVo.getStartDate()!=null){%> value="<%=com.dogma.util.DogmaUtil.dateToString(dBean.getEnvId(request), userVo.getStartDate())%>" <%}%><%if(fromList){%> disabled <%}%>></td><td></td><!--  <td title="<%=LabelManager.getToolTip(labelSet,"lblDteTo")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDteTo")%>:</td> --><td><div id="divDteTo"><input name="txtDteTo" p_required="true" size=10 maxlength="10" <%if(userVo != null && userVo.getEndDate()!=null){out.print(" disabled ");}%> p_calendar="true" class="txtDate" onchange= "getUser()" p_mask="<%=com.dogma.util.DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDteTo")%>" type="text"  <%if(userVo != null && userVo.getEndDate()!=null){%> value="<%=com.dogma.util.DogmaUtil.dateToString(dBean.getEnvId(request),userVo.getEndDate())%>" <%}%><%if(fromList){%> disabled <%}%>></div></td></tr></table><% if(userVo != null && userVo.getStartDate()!=null && userVo.getEndDate()!=null){%><div class="subTit"><%=LabelManager.getName(labelSet,"sbtUsrSub")%></div><div type="grid" id="gridUserSubstitutes" style="height:200px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="100px" style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblPool")%>"><%=LabelManager.getName(labelSet,"lblPool")%></th><th min_width="100px" style="min-width:100px;width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblUsuSub")%>"><%=LabelManager.getName(labelSet,"lblUsuSub")%></th><th min_width="100px" style="min-width:100px;width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblPrf")%>"><%=LabelManager.getName(labelSet,"lblPrf")%></th></tr></thead><tbody><% if(userVo != null && userVo.getGroups()!=null){ 
							Iterator it = userVo.getGroups().iterator();
							int i =0;
							while(it.hasNext()){
								PoolVo uVo = (PoolVo) it.next();
							%><tr name="firstTr" id="firstTr" ><td style="width:0px;display:none;"><input type="hidden" id="chkPool<%=i%>" name="chkPool"><input type="hidden" name="hidPoolId<%=i%>" value="<%=uVo.getPoolId()%>"></td><td><%=uVo.getPoolName()%></td><td style="min-width:100px"><%=dBean.getValuesToShow(uVo.getPoolId(), userVo.getGroupsSubstitutes(), new UserVo())%></td><td style="min-width:100px"><%=dBean.getValuesToShow(uVo.getPoolId(), userVo.getGroupProfiles(), new ProfileVo())%></td></tr><% i++;
							}
						} %></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><td></td><td><%if(!fromList){ %><button type="button" onclick="btnAdd_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgrUsr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgrUsr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgrUsr")%></button><button type="button" onclick="btnDel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEliUsr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEliUsr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEliUsr")%></button><button type="button" onclick="btnAddProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgrPrf")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgrPrf")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgrPrf")%></button><button type="button" onclick="btnDelProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEliPrf")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEliPrf")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEliPrf")%></button><%} %></td></tr></table><%} %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button"  onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>" <%if(fromList){ %> style="display:none" <%}%>><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click(<%=fromList%>)" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" defer="true" src='<%=Parameters.ROOT_PATH%>/programs/security/usersSubstitutes/setSubstitutes.js'></script><script language="javascript"><%
DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
%>
function changeEndDateChk(){
	if(document.getElementById("chkEndDate").checked){
		document.getElementById("txtDteTo").clear();
		document.getElementById("divDteTo").style.display="block";
	}else{
		document.getElementById("txtDteTo").setMaskedValue("<%=com.dogma.util.DogmaUtil.dateToString(dBean.getEnvId(request),df.parse("2100-01-01"))%>");
		document.getElementById("divDteTo").style.display="none";
	}
	getUser();
}

function btnSelUsr_click(){
	var rets;
	if(<%=fromHierarchy%>){
		var currentUser = '<%=dBean.getUserId(request)%>';
		rets = openModal("/programs/modals/users.jsp?currentUser=" + currentUser + "&onlyActive=true" ,500,300);
	}
	else{
		rets = openModal("/programs/modals/users.jsp?onlyActive=true",500,300);
	}
	var doAfter=function(rets){
		if(rets != null) {
			var ret = rets[0];
			document.getElementById("txtLog").value = ret[0];
			document.getElementById("txtLog").disabled = true;
			document.getElementById("txtDteFrom").value = '__/__/____';
			document.getElementById("txtDteTo").value = '__/__/____';			
			document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=getUser&usrLogin=" + document.getElementById("txtLog").value;
			submitForm(document.getElementById("frmMain"));
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}


function btnAdd_click(){
	var cant = chksChecked(document.getElementById("gridUserSubstitutes"));
	if(cant != 0) {
		var login = document.getElementById("txtLog").value;
		var startDate = document.getElementById("txtDteFrom").value;
		var endDate = document.getElementById("txtDteTo").value;
		var selected = document.getElementById("gridUserSubstitutes").selectedItems;
		if(login!=null && !login==""){
			var rets;
			if(<%=fromHierarchy%>){
				var currentUser = '<%=dBean.getUserId(request)%>';
				rets = openModal("/programs/modals/users.jsp?currentUser="+currentUser+"&usrLogin="+login+"&startDate=" + startDate +"&endDate=" +endDate + "&onlyActive=true",500,300);
			}
			else{
				rets = openModal("/programs/modals/users.jsp?usrLogin="+login+"&startDate=" + startDate +"&endDate=" +endDate + "&onlyActive=true",500,300);
			}
			var sel = selected[0];
			var doLoad=function(rets, sel){
				var pool = 	sel.getElementsByTagName("INPUT")[1].value;
				if (rets != null) {
					substitutes = new Array();
					var i=0;
					for (j = 0; j < rets.length; j++) {
						var ret = rets[j];
						if(ret!=null){		
							substitutes[i] = ret[0];
							i++;
						}
					}
					document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=addSubstitute&substitutes=" + substitutes +"&poolId=" + pool;
					submitForm(document.getElementById("frmMain"));
				}
			}
			rets.onclose=function(){
				doLoad(rets.returnValue, sel);
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

var MSGFECFINMAYFECINI = "<%=LabelManager.getName(labelSet,"msgFecFinMayFecIni")%>";

function loadPage(){
	document.getElementById("chkEndDate").disabled=document.getElementById("txtDteTo").disabled;
	if(document.getElementById("txtDteTo").value.indexOf("2100") > 0){
		
	} else {
		document.getElementById("chkEndDate").checked = true;
	}
}
</script>