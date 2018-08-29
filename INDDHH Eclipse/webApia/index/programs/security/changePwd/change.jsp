<%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCamPas")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatCamPas")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblPwdAct")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPwdAct")%>:</td><td><input onkeyup="enableBtnOk(event)" id="txtActPwd" name="txtActPwd" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPwdAct")%>" type="password"></td><td></td><td></td></tr><tr><td  title="<%=LabelManager.getToolTip(labelSet,"lblPwdNew")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPwdNew")%>:</td><td><input onkeyup="enableBtnOk(event)" id="txtPwd" name="txtPwd" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPwdNew")%>" type="password" <%if(Parameters.PWD_REG_EXP!=null){out.print("sRegExp =\""+Parameters.PWD_REG_EXP+"\" onchange='testRegExpPassword(this)'");}%>  ></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblConPwd")%>"><%=LabelManager.getNameWAccess(labelSet,"lblConPwd")%>:</td><td><input onkeyup="enableBtnOk(event)" id="txtNewPwd" name="txtNewPwd" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblConPwd")%>" type="password" <%if(Parameters.PWD_REG_EXP!=null){out.print("sRegExp =\""+Parameters.PWD_REG_EXP+"\" onchange='testRegExpPassword(this)'");}%> ></td><td></td><td></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">

function enableBtnOk(evt){
		var element=evt.target;
		if(window.event){
			evt=window.event;
			element=evt.srcElement;
		}
		//Boton backSpace
		if (evt.keyCode==8 && element.value==""){
			document.getElementById('btnOK').disabled=true;
			return true;
		}
		
		//Boton suprimir
		if (evt.keyCode==46 && element.value==""){
			document.getElementById('btnOK').disabled=true;
			return true;
		}
		
		//Otras teclas menos enter
		if (evt.keyCode != 13){
			if (element.name == 'txtUser' && evt.keyCode != 9){
				if((document.getElementById('txtActPwd').value != null) &&
   					(document.getElementById('txtPwd').value != "") &&
   					(document.getElementById('txtNewPwd').value != "")){
	   				document.getElementById('btnOK').disabled=false;
	   			}
			}else if (element.name == 'txtPwd' && evt.keyCode!=9){
				if ((document.getElementById('txtActPwd').value != null) && 
	   				(document.getElementById('txtPwd').value != "")&&
   					(document.getElementById('txtNewPwd').value != "")){
	   				document.getElementById('btnOK').disabled=false;
	  	 		}
			}
		}
}

</script><script language="javascript" defer="true" src='<%=Parameters.ROOT_PATH%>/programs/security/changePwd/change.js'></script>