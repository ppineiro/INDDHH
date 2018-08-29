<%@page import="com.dogma.vo.*"%><%@page import="com.apia.erd.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/administration/entities/merToEntities.js"></script></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEntNeg")%></TD><TD></TD></TR></TABLE><div id="divContent"><br/><% String tableName = request.getParameter("tableName");
				
		HashMap<String,Table> tables = dBean.getTables();
		Table table = tables.get(tableName); 
		if (table != null) { %><form id="frmMain" name="frmMain" method="POST" ><DIV class="subTit">Atributos de <%=tableName%></DIV><div type="grid" id="grdMain" name="grdMain" style="height:200px;"><table cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="display:none;width:0px"></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblAtt")%>"><%=LabelManager.getName(labelSet,"lblAtt")%></th><th style="width:30px" title="<%=LabelManager.getToolTip(labelSet,"lblPK")%>"><%=LabelManager.getName(labelSet,"lblPK")%></th><th style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblReq")%>"><%=LabelManager.getName(labelSet,"lblReq")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblTip")%>"><%=LabelManager.getName(labelSet,"lblTip")%></th></tr></thead><tbody class="scrollContent"><%
					Collection<Column> cols = table.getColumns().values();
					for(Column col : cols){
						boolean isPK = false;
						PrimaryKey pk = table.getPk();
						if (pk!=null && pk.getColumns().contains(col.getName())) {
							isPK = true;
						}
						
						%><tr><td style="display:none;width:0px"><input type="hidden" /></td><td><%=col.getName()%><input type="hidden" id="colName" value="<%=col.getName()%>" /></td><td><input type="checkbox" id="chkPK" name="chkPK" disabled <%if(isPK){out.print(" checked ");}%> /></td><td><input type="checkbox" id="chkReq" name="chkReq" disabled <%if(col.isRequired()){out.print(" checked ");}%> /></td><td><select name="selTypeMain" id="selTypeMain"><option value="<%=col.TYPE_FRM_INPUT%>"><%=LabelManager.getName(labelSet,"lblInput")%></option><option value="<%=col.TYPE_FRM_COMBO%>"><%=LabelManager.getName(labelSet,"lblCombobox")%></option><option value="<%=col.TYPE_FRM_LIST%>"><%=LabelManager.getName(labelSet,"lblListbox")%></option><option value="<%=col.TYPE_FRM_CHECK%>"><%=LabelManager.getName(labelSet,"lblCheckbox")%></option><option value="<%=col.TYPE_FRM_RADIO%>"><%=LabelManager.getName(labelSet,"lblRadio")%></option><option value="<%=col.TYPE_FRM_TEXTAREA%>"><%=LabelManager.getName(labelSet,"lbltxtArea")%></option><option value="<%=col.TYPE_FRM_FILEINPUT%>"><%=LabelManager.getName(labelSet,"lblFileInput")%></option><option value="<%=col.TYPE_FRM_EDITOR%>"><%=LabelManager.getName(labelSet,"lblEditor")%></option><option value="<%=col.TYPE_FRM_PWD%>"><%=LabelManager.getName(labelSet,"lblPwdType")%></option></select></td></tr><% } %></tbody></table></div></form><% } 
		
				
		String fatherCheckedHer = request.getParameter("fatherCheckedHer");
		String fatherCheckedBind = request.getParameter("fatherCheckedBind");
		String childCheckedAdm = request.getParameter("childCheckedAdm");
		
		if(fatherCheckedHer!=null && !"".equals(fatherCheckedHer)){
			String [] fatherNamesHer=fatherCheckedHer.split(";");
			if (fatherNamesHer.length > 0) { %><DIV class="subTit">Formularios ancestros</DIV><%
			}
			for(int i=0; i<fatherNamesHer.length; i++){
				String fNameHer = fatherNamesHer[i];
				Table tableHer = tables.get(fNameHer);
				if (tableHer != null) { %><form id="frmHer<%=i%>" name="frmHer<%=i%>" method="POST" enctype="multipart/form-data"><DIV class="subTit">Atributos de <%=tableHer.getName()%></DIV><div type="grid" id="grdHer<%=i%>" name="grdHer<%=i%>" style="height:200px;"><table cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="display:none;width:0px"></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblAtt")%>"><%=LabelManager.getName(labelSet,"lblAtt")%></th><th style="width:30px" title="<%=LabelManager.getToolTip(labelSet,"lblPK")%>"><%=LabelManager.getName(labelSet,"lblPK")%></th><th style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblReq")%>"><%=LabelManager.getName(labelSet,"lblReq")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblTip")%>"><%=LabelManager.getName(labelSet,"lblTip")%></th></tr></thead><tbody class="scrollContent"><%
								Collection<Column> cols = tableHer.getColumns().values();
								for(Column col : cols){
									boolean isPK = false;
									PrimaryKey pk = tableHer.getPk();
									if (pk.getColumns().contains(col.getName())) {
										isPK = true;
									}
									%><tr><td style="display:none;width:0px"><input type="hidden" /></td><td><%=col.getName()%><input type="hidden" id="colName" value="<%=col.getName()%>" /></td><td><input type="checkbox" id="chkPK" name="chkPK" disabled <%if(isPK){out.print(" checked ");}%> /></td><td><input type="checkbox" id="chkReq" name="chkReq" disabled <%if(col.isRequired()){out.print(" checked ");}%> /></td><td><select id="selTypeAnc" name="selTypeAnc" disabled><%
											if (col.getTypeInFrm() != null) { %><option value="<%=col.TYPE_FRM_INPUT%>" <%if (col.TYPE_FRM_INPUT.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblInput")%></option><option value="<%=col.TYPE_FRM_COMBO%>" <%if (col.TYPE_FRM_COMBO.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblCombobox")%></option><option value="<%=col.TYPE_FRM_LIST%>" <%if (col.TYPE_FRM_LIST.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblListbox")%></option><option value="<%=col.TYPE_FRM_CHECK%>" <%if (col.TYPE_FRM_CHECK.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblCheckbox")%></option><option value="<%=col.TYPE_FRM_RADIO%>" <%if (col.TYPE_FRM_RADIO.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblRadio")%></option><option value="<%=col.TYPE_FRM_TEXTAREA%>" <%if (col.TYPE_FRM_TEXTAREA.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lbltxtArea")%></option><option value="<%=col.TYPE_FRM_FILEINPUT%>" <%if (col.TYPE_FRM_FILEINPUT.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblFileInput")%></option><option value="<%=col.TYPE_FRM_EDITOR%>" <%if (col.TYPE_FRM_EDITOR.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblEditor")%></option><option value="<%=col.TYPE_FRM_PWD%>" <%if (col.TYPE_FRM_PWD.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblPwdType")%></option><%	
											} else { %><option value="<%=col.TYPE_FRM_INPUT%>" <%out.print(" selected ");%> ><%=LabelManager.getName(labelSet,"lblInput")%></option><option value="<%=col.TYPE_FRM_COMBO%>"><%=LabelManager.getName(labelSet,"lblCombobox")%></option><option value="<%=col.TYPE_FRM_LIST%>"><%=LabelManager.getName(labelSet,"lblListbox")%></option><option value="<%=col.TYPE_FRM_CHECK%>"><%=LabelManager.getName(labelSet,"lblCheckbox")%></option><option value="<%=col.TYPE_FRM_RADIO%>"><%=LabelManager.getName(labelSet,"lblRadio")%></option><option value="<%=col.TYPE_FRM_TEXTAREA%>"><%=LabelManager.getName(labelSet,"lbltxtArea")%></option><option value="<%=col.TYPE_FRM_FILEINPUT%>"><%=LabelManager.getName(labelSet,"lblFileInput")%></option><option value="<%=col.TYPE_FRM_EDITOR%>"><%=LabelManager.getName(labelSet,"lblEditor")%></option><option value="<%=col.TYPE_FRM_PWD%>"><%=LabelManager.getName(labelSet,"lblPwdType")%></option><% } %></select></td></tr><% } %></tbody></table></div></form><% }
			}
		}
		
		if(fatherCheckedBind!=null && !"".equals(fatherCheckedBind)){
			String [] fatherNamesBind=fatherCheckedBind.split(";");
			for(int i=0; i<fatherNamesBind.length; i++){
				String fNameBind = fatherNamesBind[i];
				Table tableBind = tables.get(fNameBind);
			}
		}
		
		if(childCheckedAdm!=null && !"".equals(childCheckedAdm)){
			String [] childNamesAdm=childCheckedAdm.split(";");
			if (childNamesAdm.length > 0) { %><DIV class="subTit">Formularios hijos</DIV><%
			}
			for(int i=0; i<childNamesAdm.length; i++){
				String cNameAdm = childNamesAdm[i];
				Table tableAdm = tables.get(cNameAdm);
				if (tableAdm != null) { %><form id="frmAdm<%=i%>" name="frmAdm<%=i%>" method="POST" enctype="multipart/form-data"><DIV class="subTit">Atributos de <%=tableAdm.getName()%></DIV><div type="grid" id="grdAdm<%=i%>" name="grdAdm<%=i%>" style="height:200px;"><table cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="display:none;width:0px"></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblAtt")%>"><%=LabelManager.getName(labelSet,"lblAtt")%></th><th style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblReq")%>"><%=LabelManager.getName(labelSet,"lblReq")%></th><th style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblTip")%>"><%=LabelManager.getName(labelSet,"lblTip")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblInc")%>"><%=LabelManager.getName(labelSet,"lblInc")%></th></tr></thead><tbody class="scrollContent"><%
								Collection<Column> cols = tableAdm.getColumns().values();
								for(Column col : cols){					
									%><tr><td style="display:none;width:0px"><input type="hidden" /></td><td><%=col.getName()%><input type="hidden" id="colName" value="<%=col.getName()%>" /></td><td><input type="checkbox" id="chkReq" name="chkReq" disabled <%if(col.isRequired()){out.print(" checked ");}%> /></td><td><select id="selTypeHij" name="selTypeHij"><%
											if (col.getTypeInFrm() != null) { %><option value="<%=col.TYPE_FRM_INPUT%>" <%if (col.TYPE_FRM_INPUT.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblInput")%></option><option value="<%=col.TYPE_FRM_COMBO%>" <%if (col.TYPE_FRM_COMBO.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblCombobox")%></option><option value="<%=col.TYPE_FRM_LIST%>" <%if (col.TYPE_FRM_LIST.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblListbox")%></option><option value="<%=col.TYPE_FRM_CHECK%>" <%if (col.TYPE_FRM_CHECK.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblCheckbox")%></option><option value="<%=col.TYPE_FRM_RADIO%>" <%if (col.TYPE_FRM_RADIO.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblRadio")%></option><option value="<%=col.TYPE_FRM_TEXTAREA%>" <%if (col.TYPE_FRM_TEXTAREA.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lbltxtArea")%></option><option value="<%=col.TYPE_FRM_FILEINPUT%>" <%if (col.TYPE_FRM_FILEINPUT.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblFileInput")%></option><option value="<%=col.TYPE_FRM_EDITOR%>" <%if (col.TYPE_FRM_EDITOR.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblEditor")%></option><option value="<%=col.TYPE_FRM_PWD%>" <%if (col.TYPE_FRM_PWD.equals(col.getTypeInFrm())) {out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblPwdType")%></option><% } else { %><option value="<%=col.TYPE_FRM_INPUT%>" <%out.print(" selected ");%> ><%=LabelManager.getName(labelSet,"lblInput")%></option><option value="<%=col.TYPE_FRM_COMBO%>"><%=LabelManager.getName(labelSet,"lblCombobox")%></option><option value="<%=col.TYPE_FRM_LIST%>"><%=LabelManager.getName(labelSet,"lblListbox")%></option><option value="<%=col.TYPE_FRM_CHECK%>"><%=LabelManager.getName(labelSet,"lblCheckbox")%></option><option value="<%=col.TYPE_FRM_RADIO%>"><%=LabelManager.getName(labelSet,"lblRadio")%></option><option value="<%=col.TYPE_FRM_TEXTAREA%>"><%=LabelManager.getName(labelSet,"lbltxtArea")%></option><option value="<%=col.TYPE_FRM_FILEINPUT%>"><%=LabelManager.getName(labelSet,"lblFileInput")%></option><option value="<%=col.TYPE_FRM_EDITOR%>"><%=LabelManager.getName(labelSet,"lblEditor")%></option><option value="<%=col.TYPE_FRM_PWD%>"><%=LabelManager.getName(labelSet,"lblPwdType")%></option><% } %></select></td><td><input type="checkbox" id="chkInc" name="chkInc" <%out.print(" checked ");%> /></td></tr><% } %></tbody></table></div></form><%
				}
			}
		}
		%></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="confirm()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">

function confirm(){
	var retorno="retorno";  //ver que cargar en esta variable
	
	window.returnValue=retorno;
	window.close();
}
</script>

