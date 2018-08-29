			<%boolean hasFlag = false;%><observations /><%if (! "true".equals(request.getParameter("readOnly"))) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeObsAct")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td vAlign="top" title="<%=LabelManager.getToolTip(labelSet,"lblEjeObs")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeObs")%>:</td><td colspan=4><textarea accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeObs")%>" name="txtComment" p_maxlength="true" maxlength="2000" cols=80 rows=10></textarea></td></tr><tr><td colspan=4 align=left><table><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeAgrMar")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeAgrMar")%>:</td><td><input type=checkbox name=chkAddAlert></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeAgrMarTod")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeAgrMarTod")%>:</td><td><input type=checkbox id=chkAddAllAlert name=chkAddAllAlert onchange="alertAll(this)"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeEliMar")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeEliMar")%>:</td><td><input type=checkbox id=chkRemAlert name=chkRemAlert onchange="alertRemove(this)"></td></tr></table></td></tr></table><% } %><% Collection comments = processBean.getComments();
				if (comments != null) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeObs")%></DIV><% if (! "true".equals(request.getParameter("readOnly"))) { %><div style="width:99%;height:200px;overflow:auto" id="divComentScroll"><% } else { %><div style="width:99%;height:99%;overflow:auto" id="divComentScroll"><% } %><table style="width:96%;" class="tblComment"><% 	Iterator itComm = comments.iterator();
				ProInstCommentVo comment = null;
				
				while (itComm.hasNext()) {
					comment = (ProInstCommentVo) itComm.next();
					out.print("<tr id='trHead'>");
					String value = "";
					if(comment.getProInstCommFlag().intValue()==1){
						value = "checked";
					}
					String props = "";
					if ( "true".equals(request.getParameter("readOnly"))) {
						props = " disabled ";
					}
					out.print("<td><input type=checkbox name=\"chkComment"+comment.getProInstComId()+"\" " + value +"  " + props + " ></td>");
					out.print("<td><B>"+dBean.fmtHTMLAMPM(comment.getRegDate())+"</B></td>");
					out.print("<td width='20%' title='" + dBean.fmtHTML(comment.getUserName())+"'>" + LabelManager.getName(labelSet,"lblEjeUsu") + ": <B>" + dBean.fmtHTML(comment.getRegUser()) + "</B></td>");
					out.print("<td width='20%'>" + LabelManager.getName(labelSet,"lblEjeGruTar") + ": <B>" + dBean.fmtHTML(comment.getPoolName()) + "</B></td>");
					out.print("<td width='35%'>" + LabelManager.getName(labelSet,"lblEjeTar") + ": <B>" + dBean.fmtHTML(comment.getTskName()) + "</B></td>");
					
					String flag = "&nbsp;&nbsp;&nbsp;";
					
					if(comment.getProInstCommFlag().intValue() == 1){
						hasFlag = true;
						flag = "<img src='" + Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/alert.gif'>";
					}	
					
					out.print("<tr id='trComment'><td width='3%'>" + flag + "</ td><td colspan=4><pre>" + dBean.fmtHTML(comment.getProInstComment()) + "</pre></td></tr>");
					
				}%></table></div><%}
				if(dBean.getProElement().getFlagValue(com.dogma.vo.ProElementVo.POS_HIGHLIGT_COMMENTS)){
					hasFlag = true;
				}
			%><script language=javascript>
				var FLAG_OBS = "<%=hasFlag%>";

				function alertAll(obj){
					if(obj.checked){
						document.getElementById("chkRemAlert").checked = false;
					}
				}
				function alertRemove(obj){
					if(obj.checked){
						document.getElementById("chkAddAllAlert").checked = false;
					}
				}
			</script><%
dBean.setFormHasBeenDrawed(true);
%>				