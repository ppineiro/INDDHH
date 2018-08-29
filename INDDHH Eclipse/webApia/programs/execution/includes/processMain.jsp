			<DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeDatPro")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeIdePro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeIdePro")%>:</td><td class=readOnly><%
			   				   			if (proInstVo.getProInstNameNum() != null) {
			   				   			out.print(proInstVo.getInstanceIdentification());
			   				   		} else {
			   					   		if (ProcessVo.IDENTIFIER_TXT_WRITE.equals(proVo.getProIdePre())) {
			   			%><input size=5 maxlength=50 name="txtProPre" value="<%=dBean.fmtStr(proInstVo.getProInstNamePre())%>"><%
				   					out.print(Parameters.IDENTIFIER_SEPARATOR);
				   				} else if (ProcessVo.IDENTIFIER_TXT_FIXED.equals(proVo.getProIdePre())) {
			   						out.print(dBean.fmtHTML(proVo.getProIdePreFix()));
			   					%><input type="hidden" maxlength=50 name="txtProPre" value="<%=dBean.fmtStr(proVo.getProIdePreFix())%>"><%
			   						out.print(Parameters.IDENTIFIER_SEPARATOR);	
			   					  }
				   				
				   				if (ProcessVo.IDENTIFIER_NUM_AUTO.equals(proVo.getProIdeNum())) {
									out.print(LabelManager.getName(labelSet,"lblAutNum"));
								  } else {
								%><input size=9 maxlength=9 name="txtProNum" value="<%=dBean.fmtInt(proInstVo.getProInstNameNum())%>" <%if (ProcessVo.IDENTIFIER_NUM_WRITE.equals(proVo.getProIdeNum())){%> p_required=true <%}%>><%
								}
								
								if (ProcessVo.IDENTIFIER_TXT_WRITE.equals(proVo.getProIdePos())) {
				   					out.print(Parameters.IDENTIFIER_SEPARATOR);	
								%><input size=5 maxlength=50 name="txtProPos" value="<%=dBean.fmtStr(proInstVo.getProInstNamePos())%>"><%
								} else if (ProcessVo.IDENTIFIER_TXT_FIXED.equals(proVo.getProIdePos())) {
				   					out.print(Parameters.IDENTIFIER_SEPARATOR);	
			   					%><input type="hidden" maxlength=50 name="txtProPos" value="<%=dBean.fmtStr(proVo.getProIdePosFix())%>"><%
			   						out.print(dBean.fmtHTML(proVo.getProIdePosFix()));
			   					}
			   				}
			   				%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaPro")%>"><%=LabelManager.getName(labelSet,"lblEjeStaPro")%>:</td><td class="readOnly"><%
							if (ProInstanceVo.PROC_STATUS_RUNNING.equals(proInstVo.getProInstStatus())) {
								out.write(LabelManager.getName(labelSet,"lblMonInstProStaRun"));
							} else if (ProInstanceVo.PROC_STATUS_CANCELLED.equals(proInstVo.getProInstStatus())) {
								out.write(LabelManager.getName(labelSet,"lblMonInstProStaCan"));
							} else if (ProInstanceVo.PROC_STATUS_FINALIZED.equals(proInstVo.getProInstStatus())) {
								out.write(LabelManager.getName(labelSet,"lblMonInstProStaFin"));
							} else if (ProInstanceVo.PROC_STATUS_COMPLETED.equals(proInstVo.getProInstStatus())) {
								out.write(LabelManager.getName(labelSet,"lblMonInstProStaCom"));
							} %></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeNomPro")%>"><%=LabelManager.getName(labelSet,"lblEjeNomPro")%>:</td><td class="readOnly"><%=dBean.fmtHTML(proVo.getProTitle())%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeAccPro")%>"><%=LabelManager.getName(labelSet,"lblEjeAccPro")%>:</td><td class="readOnly"><%
			   				if (proVo.getProAction().equals(ProcessVo.PROCESS_ACTION_ALTERATION)) {
		   						out.print(LabelManager.getName(labelSet,"lblAccProAlt"));
		   					} else if (proVo.getProAction().equals(ProcessVo.PROCESS_ACTION_CANCEL)) {
		   						out.print(LabelManager.getName(labelSet,"lblAccProCan"));  
		   					} else {
		   						out.print(LabelManager.getName(labelSet,"lblAccProCre"));
		   					}%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeUsuCrePro")%>"><%=LabelManager.getName(labelSet,"lblEjeUsuCrePro")%>:</td><td class="readOnly"><%=dBean.fmtHTML(proInstVo.getProInstCreateUser())%>&nbsp</td><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeFecCrePro")%>"><%=LabelManager.getName(labelSet,"lblEjeFecCrePro")%>:</td><td class="readOnly"><%=dBean.fmtHTML(proInstVo.getProInstCreateDate())%>&nbsp</td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjePriPro")%>"><%=LabelManager.getName(labelSet,"lblEjePriPro")%>:</td><td><select name="cmbProPri" p_required=true <%if((proInstVo.getProInstId()!= null) && !("true".equals(request.getAttribute("priProFnc")))){ %>disabled <%} %>><option value="<%=com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL%>" <%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL){	out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblEjePriProNor")%></option><option value="<%=com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW%>"    <%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW){		out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblEjePriProBaj")%></option><option value="<%=com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH%>"   <%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH){		out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblEjePriProAlt")%></option><option value="<%=com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT%>" <%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT){	out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblEjePriProUrg")%></option></select></td><%	Collection colCal = dBean.getCalendars();
			   				Integer selCalId = dBean.getSelectedCalendar();
		   					boolean hasCalendar = (selCalId != null && selCalId.intValue() != 0);
		   					boolean dontAllowChangeCalendar = proVo.getFlagValue(ProcessVo.FLAG_DONT_ALLOW_CALENDAR_CHANGE);
		   					
   		  					if (colCal != null && colCal.size()>0) { %><td title="<%=LabelManager.getToolTip(labelSet,"titCal")%>"><%=LabelManager.getNameWAccess(labelSet,"titCal")%>:</td><td><input type=hidden name="txtCal" value=""><select name="selCal" <%if(dontAllowChangeCalendar){out.print(" readonly='readonly' class='txtReadOnly' ");} %>><%Iterator itCal = colCal.iterator();
			   						CalendarVo calVo = null;%><option value="0"></option><%
			   						while (itCal.hasNext()) {
			   							calVo = (CalendarVo) itCal.next();%><option value="<%=calVo.getCalendarId()%>" 
				   						<%if (hasCalendar) {
											if (calVo.getCalendarId().equals(selCalId)) {
												out.print ("selected");
											}%>
											><%=calVo.getCalendarName()%></option><%} else {%>
											><%=calVo.getCalendarName()%></option><%}%><%}%></select>
			   						&nbsp;
			   						<button type="button" id="btnVerCal" onClick="btnViewCalendar()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVer")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVer")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVer")%></button></td><%}else{ %><td></td><td></td><%} %></tr></table><%
dBean.setFormHasBeenDrawed(true);
%>		