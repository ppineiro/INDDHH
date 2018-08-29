<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.WsBean"/><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titUsu")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><br><div class="tableContainerNoHScroll" style="height:200px;" type="grid" id="grid"><table width="300px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:20px" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>">Sel</th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblUsu")%>"><%=LabelManager.getName(labelSet,"lblUsu")%></th></tr></thead><tbody class="scrollContent"><%
							String[] data = request.getParameterValues("reqData");
						
							List lData = Arrays.asList(data);
							Collection c1 = dBean.getWSUsers();
							int i=0;
							
							if(c1!=null){
								Iterator itc = c1.iterator();
								while(itc.hasNext()){
									UserVo u = (UserVo)itc.next();
									%><tr><td style="width:20px"><input type="radio" name="s_user" s_user="<%=u.getUsrLogin()%>" <%if(lData.contains(u.getUsrLogin())){ out.print(" checked ");} %>></td><td><%=u.getUsrLogin()%></td></tr><%
								}
							}
						%></tbody></table></div></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></TD><TD align="right"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button></TD><TD align="right"><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">


function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	


function getSelected(){
	var arr = new Array();
	var oChks = document.getElementsByName("s_user");
	for(var a=0;a < oChks.length;a++){
		if(oChks[a].checked == true){
			arr.push(oChks[a].getAttribute("s_user"));			
		}
	}
	
	return arr;
}


function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>