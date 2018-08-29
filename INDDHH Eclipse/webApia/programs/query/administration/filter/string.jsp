<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titTypFil")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><% 
				int type = Integer.parseInt(request.getParameter("type")); 
				if (type == QryColumnFilterVo.TYPE_DEFAULT) {
					type = Parameters.QUERY_FILTER_DEFAULT_STRING.intValue();
				} %><input type="checkbox" onclick="type_click(this)" id="typeString" name="typeString" value="<%=QryColumnFilterVo.STRING_TYPE_EQUAL%>" <%= (type == QryColumnFilterVo.STRING_TYPE_EQUAL)?"checked":""%>><%=LabelManager.getName(labelSet,"lblFilEqu")%><br><input type="checkbox" onclick="type_click(this)" id="typeString" name="typeString" value="<%=QryColumnFilterVo.STRING_TYPE_STARTS_WITH%>" <%= (type == 0 || type == QryColumnFilterVo.STRING_TYPE_STARTS_WITH)?"checked":""%>><%=LabelManager.getName(labelSet,"lblFilLikRig")%><br><input type="checkbox" onclick="type_click(this)" id="typeString" name="typeString" value="<%=QryColumnFilterVo.STRING_TYPE_ENDS_WITH%>" <%= (type == QryColumnFilterVo.STRING_TYPE_ENDS_WITH)?"checked":""%>><%=LabelManager.getName(labelSet,"lblFilLikLef")%><br><input type="checkbox" onclick="type_click(this)" id="typeString" name="typeString" value="<%=QryColumnFilterVo.STRING_TYPE_LIKE%>" <%= (type == QryColumnFilterVo.STRING_TYPE_LIKE)?"checked":""%>><%=LabelManager.getName(labelSet,"lblFilLik")%><br><input type="checkbox" onclick="type_click(this)" id="typeString" name="typeString" value="<%=QryColumnFilterVo.STRING_TYPE_NOT_EQUAL%>" <%= (type == QryColumnFilterVo.STRING_TYPE_NOT_EQUAL)?"checked":""%>><%=LabelManager.getName(labelSet,"lblFilNotEqu")%><br><input type="checkbox" onclick="type_click(this)" id="typeString" name="typeString" value="<%=QryColumnFilterVo.STRING_TYPE_NOT_STARTS_WITH%>" <%= (type == 0 || type == QryColumnFilterVo.STRING_TYPE_NOT_STARTS_WITH)?"checked":""%>><%=LabelManager.getName(labelSet,"lblFilNotLikRig")%><br><input type="checkbox" onclick="type_click(this)" id="typeString" name="typeString" value="<%=QryColumnFilterVo.STRING_TYPE_NOT_ENDS_WITH%>" <%= (type == QryColumnFilterVo.STRING_TYPE_NOT_ENDS_WITH)?"checked":""%>><%=LabelManager.getName(labelSet,"lblFilNotLikLef")%><br><input type="checkbox" onclick="type_click(this)" id="typeString" name="typeString" value="<%=QryColumnFilterVo.STRING_TYPE_NOT_LIKE%>" <%= (type == QryColumnFilterVo.STRING_TYPE_NOT_LIKE)?"checked":""%>><%=LabelManager.getName(labelSet,"lblFilNotLik")%><br></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></TD><TD align="rigth"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	var value;
	value = null;
	var typeString=new Array();
	for (i = 0; i < document.getElementsByTagName("INPUT").length; i++) {
		if(document.getElementsByTagName("INPUT")[i].id=="typeString"){
			typeString.push(document.getElementsByTagName("INPUT")[i]);
		}
	}
	for (i = 0; i < typeString.length && value == null; i++) {
		if (typeString[i].checked) {
			value = typeString[i].value;
		}
	}
	window.returnValue = value;
	window.close();
}	

function btnExit_click() {
	window.returnValue=null;
	window.close();
}

function type_click(evt) {
	var typeString=new Array();
	for (i = 0; i < document.getElementsByTagName("INPUT").length; i++) {
		if(document.getElementsByTagName("INPUT")[i].id=="typeString"){
			typeString.push(document.getElementsByTagName("INPUT")[i]);
		}
	}
	for (i = 0; i < typeString.length; i++) {
		typeString[i].checked = false;
	}
	evt.checked = true;
}
</script>