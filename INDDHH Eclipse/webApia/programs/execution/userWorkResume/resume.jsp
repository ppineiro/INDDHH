<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/execution/userWorkResume/resume.js" defer="true"></script></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.UserWorkResumeBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titResUsu")%></TD><TD></TD></TR></TABLE><div id="divContent"><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabListView")%>" tabText="<%=LabelManager.getName(labelSet,"tabListView")%>"><%HashMap availableLists = dBean.getTaskListForUser(request); %><table class="tblFormLayout" cellpadding="0" cellspacing="0"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLisTarEje")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLisTarEje")%>:</td><td><select id="cmbList" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLisTarEje")%>"><%
			   					Iterator itLst = availableLists.keySet().iterator();
			   					while(itLst.hasNext()){
			   						Integer id = (Integer)itLst.next();
			   						%><option value='<%=id%>' <%if(id.intValue()==0){out.print(" selected ");}%>><%=availableLists.get(id) %></option><%			   					
			   					}
			   					%></select></td><td></td><td></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"tabEjeTarLib")%></DIV><div type="grid" id="gridReady" style="height:185px" onselect="var tr=this.selectedItems[0];openTaskList('R',tr);"><table id="tblReady" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th min_width="150px" style="min-width:150px;width:40%" title="<%=LabelManager.getToolTip(labelSet,"lblPro")%>"><%=LabelManager.getName(labelSet,"lblPro")%></th><th min_width="150px" style="min-width:150px;width:40%" title="<%=LabelManager.getToolTip(labelSet,"lblTask")%>"><%=LabelManager.getName(labelSet,"lblTask")%></th><th min_width="80px" style="min-width:80px;width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblEjeGruTar")%>"><%=LabelManager.getName(labelSet,"lblEjeGruTar")%></th><th min_width="120px" style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblTot")%>"><%=LabelManager.getName(labelSet,"lblTot")%></th></tr></thead><tbody id="tblReady"><%
							Collection col = dBean.getUserResumeReady(request); 
							HashMap colProcessCounts = new HashMap();
							HashMap colTaskCounts = new HashMap();
							HashMap colGroupCounts = new HashMap();
							if(col!=null){
								Iterator it = col.iterator();
								UserWorwResumeRowVo vo = null;
								while(it.hasNext()){
									vo = (UserWorwResumeRowVo)it.next();
									if(colProcessCounts.get(vo.getProName())==null){
										colProcessCounts.put(vo.getProName(),vo.getCount());
									}else{
										int cant = ((Integer)colProcessCounts.get(vo.getProName())).intValue() + vo.getCount().intValue();
										colProcessCounts.put(vo.getProName(),new Integer(cant));
									}
									if(colTaskCounts.get(vo.getTskName())==null){
										colTaskCounts.put(vo.getTskName(),vo.getCount());
									}else{
										int cant = ((Integer)colTaskCounts.get(vo.getTskName())).intValue() + vo.getCount().intValue();
										colTaskCounts.put(vo.getTskName(),new Integer(cant));
									}
									if(colGroupCounts.get(vo.getGrpName())==null){
										colGroupCounts.put(vo.getGrpName(),vo.getCount());
									}else{
										int cant = ((Integer)colGroupCounts.get(vo.getGrpName())).intValue() + vo.getCount().intValue();
										colGroupCounts.put(vo.getGrpName(),new Integer(cant));
									}
									
							%><tr style="cursor:hand"><td style="min-width:150px" align="left"><%=vo.getProName() %></td><td style="min-width:150px" align="left"><%=vo.getTskName() %></td><td style="min-width:80px" align="left"><%=vo.getGrpName() %></td><td align="right"><%=vo.getCount() %></td></tr><%	} //end while
							}//end if%></tbody></table></div><DIV class="subTit"><%=LabelManager.getName(labelSet,"tabEjeTarAdq")%></DIV><div type="grid" id="gridAcq" style="height:185px" onselect="var tr=this.selectedItems[0];openTaskList('I',tr);"><table id="tblAcq" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th min_width="150px" style="min-width:150px;width:40%" title="<%=LabelManager.getToolTip(labelSet,"lblPro")%>"><%=LabelManager.getName(labelSet,"lblPro")%></th><th min_width="150px" style="min-width:150px;width:40%" title="<%=LabelManager.getToolTip(labelSet,"lblTask")%>"><%=LabelManager.getName(labelSet,"lblTask")%></th><th min_width="80px" style="min-width:80px;width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblEjeGruTar")%>"><%=LabelManager.getName(labelSet,"lblEjeGruTar")%></th><th min_width="120px" style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblTot")%>"><%=LabelManager.getName(labelSet,"lblTot")%></th></tr></thead><tbody id="tblAcq"><%
							col = dBean.getUserResumeAcquired(request); 
							HashMap colProcessCounts2 = new HashMap();
							HashMap colTaskCounts2 = new HashMap();
							HashMap colGroupCounts2 = new HashMap();
							if(col!=null){
								Iterator it = col.iterator();
								UserWorwResumeRowVo vo = null;
								while(it.hasNext()){
									vo = (UserWorwResumeRowVo)it.next();
									if(colProcessCounts2.get(vo.getProName())==null){
										colProcessCounts2.put(vo.getProName(),vo.getCount());
									}else{
										int cant = ((Integer)colProcessCounts2.get(vo.getProName())).intValue() + vo.getCount().intValue();
										colProcessCounts2.put(vo.getProName(),new Integer(cant));
									}
									if(colTaskCounts2.get(vo.getTskName())==null){
										colTaskCounts2.put(vo.getTskName(),vo.getCount());
									}else{
										int cant = ((Integer)colTaskCounts2.get(vo.getTskName())).intValue() + vo.getCount().intValue();
										colTaskCounts2.put(vo.getTskName(),new Integer(cant));
									}
									if(colGroupCounts2.get(vo.getGrpName())==null){
										colGroupCounts2.put(vo.getGrpName(),vo.getCount());
									}else{
										int cant = ((Integer)colGroupCounts2.get(vo.getGrpName())).intValue() + vo.getCount().intValue();
										colGroupCounts2.put(vo.getGrpName(),new Integer(cant));
									}
							%><tr style="cursor:hand"><td style="min-width:150px" align="left"><%=vo.getProName() %></td><td style="min-width:150px" align="left"><%=vo.getTskName() %></td><td style="min-width:80px" align="left"><%=vo.getGrpName() %></td><td align="right"><%=vo.getCount() %></td></tr><%	} //end while
							}//end if%></tbody></table></div></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeTarLib")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeTarLib")%>"><%
				//queryString de procesos:
				String strProNamesReady = "";
				String strProCantReady = "";
				Iterator itR = colProcessCounts.keySet().iterator();
				while(itR.hasNext()){
					String proName=(String)itR.next();
					strProNamesReady+="&proName="+proName;
					strProCantReady+="&proCant="+colProcessCounts.get(proName);
				}
				
				String strTskNamesReady = "";
				String strTskCantReady = "";
				itR = colTaskCounts.keySet().iterator();
				while(itR.hasNext()){
					String tskName=(String)itR.next();
					strTskNamesReady+="&proName="+tskName;
					strTskCantReady+="&proCant="+colTaskCounts.get(tskName);
				}
				String strGrpNamesReady = "";
				String strGrpCantReady = "";
				itR = colGroupCounts.keySet().iterator();
				while(itR.hasNext()){
					String grpName=(String)itR.next();
					strGrpNamesReady+="&proName="+grpName;
					strGrpCantReady+="&proCant="+colGroupCounts.get(grpName);
				}
				if(colGroupCounts.keySet().size() > 0){
				%><table><tr><td><img src="<%=Parameters.ROOT_PATH%>/programs/execution/userWorkResume/pie.jsp?title=<%=LabelManager.getName(labelSet,"lblPro")%><%=strProNamesReady+strProCantReady%>"></td><td><img src="<%=Parameters.ROOT_PATH%>/programs/execution/userWorkResume/pie.jsp?title=<%=LabelManager.getName(labelSet,"lblTask")%><%=strTskNamesReady+strTskCantReady%>"></td><td><img src="<%=Parameters.ROOT_PATH%>/programs/execution/userWorkResume/pie.jsp?title=<%=LabelManager.getName(labelSet,"lblEjeGruTar")%><%=strGrpNamesReady+strGrpCantReady%>"></td></tr></table><%} %></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeTarAdq")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeTarAdq")%>"><%
				//queryString de procesos:
				String strProNamesReady2 = "";
				String strProCantReady2 = "";
				itR = colProcessCounts2.keySet().iterator();
				while(itR.hasNext()){
					String proName=(String)itR.next();
					strProNamesReady2+="&proName="+proName;
					strProCantReady2+="&proCant="+colProcessCounts2.get(proName);
				}
				
				String strTskNamesReady2 = "";
				String strTskCantReady2 = "";
				itR = colTaskCounts2.keySet().iterator();
				while(itR.hasNext()){
					String tskName=(String)itR.next();
					strTskNamesReady2+="&proName="+tskName;
					strTskCantReady2+="&proCant="+colTaskCounts2.get(tskName);
				}
				String strGrpNamesReady2 = "";
				String strGrpCantReady2 = "";
				itR = colGroupCounts2.keySet().iterator();
				while(itR.hasNext()){
					String grpName=(String)itR.next();
					strGrpNamesReady2+="&proName="+grpName;
					strGrpCantReady2+="&proCant="+colGroupCounts2.get(grpName);
				}
				
				if(colGroupCounts2.keySet().size() > 0){
				%><table><tr><td><img src="<%=Parameters.ROOT_PATH%>/programs/execution/userWorkResume/pie.jsp?title=<%=LabelManager.getName(labelSet,"lblPro")%><%=strProNamesReady2+strProCantReady2%>"></td><td><img src="<%=Parameters.ROOT_PATH%>/programs/execution/userWorkResume/pie.jsp?title=<%=LabelManager.getName(labelSet,"lblTask")%><%=strTskNamesReady2+strTskCantReady2%>"></td><td><img src="<%=Parameters.ROOT_PATH%>/programs/execution/userWorkResume/pie.jsp?title=<%=LabelManager.getName(labelSet,"lblEjeGruTar")%><%=strGrpNamesReady2+strGrpCantReady2%>"></td></tr></table><%} %></div></div><form id=frmx method="post"></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button onclick="btnRefresh_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRef")%>" title="<%=LabelManager.getToolTip(labelSet,"btnRef")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRef")%></button><button onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><SCRIPT>
function tabSwitch(){
}
</SCRIPT>


