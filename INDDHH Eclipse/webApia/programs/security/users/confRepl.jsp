<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.UserBean"></jsp:useBean><%
UserVo userVo = dBean.getUserVo();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titUsu":"titUsuEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatUsu")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLog")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLog")%>:</td><td><input type="text" readonly class="txtReadOnly" value="<%=dBean.fmtStr(userVo.getUsrLogin())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblPwd")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPwd")%>:</td><td><input type="password" value="<%=dBean.fmtStr(userVo.getUsrPassword())%>" readonly class="txtReadOnly" ></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input type="text" value="<%=dBean.fmtStr(userVo.getUsrName())%>" readonly class="txtReadOnly" ></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEma")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEma")%>:</td><td><input type="text" value="<%=dBean.fmtStr(userVo.getUsrEmail())%>" readonly class="txtReadOnly" ></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblCom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblCom")%>:</td><td colspan=3><input type="text" value="<%=dBean.fmtStr(userVo.getUsrComments())%>" readonly class="txtReadOnly"></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnRea_click('<%=request.getParameter("clone")%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRea")%>" title="<%=LabelManager.getToolTip(labelSet,"btnRea")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRea")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/users/update.js'></script>
