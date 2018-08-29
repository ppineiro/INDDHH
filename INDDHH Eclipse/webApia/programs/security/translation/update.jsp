<%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.Parameters"%><%@page import="java.util.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><html><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %><% boolean onlyOne = request.getParameter("onlyOne") != null; %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.TranslationBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titTra") + " - " + dBean.getObjectName() %></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><TR><td><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><b><%=dBean.getObjectOriginalText() %></b></td><td></td><td></td></TR><TR><td><%=LabelManager.getNameWAccess(labelSet,"lblTooTip")%>:</td><td><b><%=(dBean.getObjectOriginalLabel()!=null?dBean.getObjectOriginalLabel():"")%></b></td><td></td><td></td></TR></table><div type="grid" id="gridTranslations" style="height:140px" multiSelect="false"><table  width="600px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblLan")%>"><%=LabelManager.getName(labelSet,"lblLan")%></th><th style="width:40%" title="<%=LabelManager.getToolTip(labelSet,"lblTra")%>"><%=LabelManager.getName(labelSet,"lblTra")%></th><th style="width:40%" title="<%=LabelManager.getToolTip(labelSet,"lblTraTooltip")%>"><%=LabelManager.getName(labelSet,"lblTraTooltip")%></th></tr></thead><tbody ><%	Collection col = dBean.getTranslations();
							if (col != null) {
								Iterator it = col.iterator();
								int i = 0;
								TranslationVo translationVo = null;
								System.out.println(col.size());
								while (it.hasNext()) {
									translationVo = (TranslationVo) it.next();%><tr><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidTransId<%=i%>" value="<%=dBean.fmtStr(translationVo.getLangId().toString())%>"></td><td style="width:20%;"><%=dBean.fmtHTML(translationVo.getLanguageName())%></td><td style="width:40%;"><input name="txtTrans" maxlength="255" type="text" value="<%=dBean.fmtHTML(translationVo.getTransName())%>"></td><td style="width:40%;"><input name="txtTransTooltip" maxlength="255" type="text" value="<%=dBean.fmtHTML(translationVo.getTransTooltip())%>"></td></tr><%i++;%><%}
							}%></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><TR><TD align="right"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script>
function btnExit_click() {
	window.returnValue=null;
	window.close();
}

function btnConf_click() {
	var result;
	var oRows = document.getElementById("gridTranslations").rows;
	if (oRows != null) {
		result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];

			var oTd = oRow.cells[0];
			arr = new Array();
			arr[0] = oTd.getElementsByTagName("input")[1].value;
			
			oTd = oRow.cells[2];			
			arr[1] = oTd.getElementsByTagName("input")[0].value;
			
			oTd = oRow.cells[3];			
			arr[2] = oTd.getElementsByTagName("input")[0].value;
			
			result[i] = arr;
		}
	}
	window.returnValue=result;
	window.close();
}	
</script>