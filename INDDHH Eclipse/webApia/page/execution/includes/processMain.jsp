<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><div class="tabContent"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEjeDatPro" /></div><div class="field required"><%if (proInstVo.getProInstNameNum() != null) {
				%><span class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeIdePro" />"><system:label show="text" label="lblEjeIdePro" />:</span><%
				out.print("<span class='monitor-input'>"+proInstVo.getInstanceIdentification()+"</span>");
			} else {
				%><span class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeIdePro" />"><system:label show="text" label="lblEjeIdePro" />:</span><%
				if (ProcessVo.IDENTIFIER_TXT_WRITE.equals(proVo.getProIdePre())) {%><label style="display: none;" for="txtProPre" title="<system:label show="tooltip" label="lblPrefix" />"><system:label show="text" label="lblPrefix" />:</label><input id="txtProPre" size=5 maxlength=50 name="txtProPre" value="<%=BeanUtils.fmtStr(proInstVo.getProInstNamePre())%>"><%out.print(Parameters.IDENTIFIER_SEPARATOR);
				} else if (ProcessVo.IDENTIFIER_TXT_FIXED.equals(proVo.getProIdePre())) {
				   	%><span class="monitor-input"><%
			   			out.print(BeanUtils.fmtHTML(proVo.getProIdePreFix()));
			   			out.print(Parameters.IDENTIFIER_SEPARATOR);
				   	%></span><input type="hidden" name="txtProPre" value="<%=BeanUtils.fmtStr(proVo.getProIdePreFix())%>"><%
				}
				
				if (ProcessVo.IDENTIFIER_NUM_AUTO.equals(proVo.getProIdeNum())) {
					%><span class='monitor-input'><system:label show="text" label="lblAutNum"/></span><%
				} else {
					%><input title="<system:label show="tooltip" label="lblEjeIdePro" />" size=9 maxlength=9 name="txtProNum" id="txtProNum" value="<%=BeanUtils.fmtInt(proInstVo.getProInstNameNum())%>" <%if (ProcessVo.IDENTIFIER_NUM_WRITE.equals(proVo.getProIdeNum())){%> data-p_required=true <%}%>><%
				}
				
				if (ProcessVo.IDENTIFIER_TXT_WRITE.equals(proVo.getProIdePos())) {
					out.print(Parameters.IDENTIFIER_SEPARATOR);	
					%><label style="display: none;" for="txtProPos" title="<system:label show="tooltip" label="lblSuffix" />"><system:label show="text" label="lblSuffix" />:</label><input id="txtProPos" size=5 maxlength=50 name="txtProPos" value="<%=BeanUtils.fmtStr(proInstVo.getProInstNamePos())%>"><%
				} else if (ProcessVo.IDENTIFIER_TXT_FIXED.equals(proVo.getProIdePos())) {
					out.print(Parameters.IDENTIFIER_SEPARATOR);	
				   	%><input type="hidden" name="txtProPos" value="<%=BeanUtils.fmtStr(proVo.getProIdePosFix())%>"><span class="monitor-input"><%
				   		out.print(BeanUtils.fmtHTML(proVo.getProIdePosFix()));
				   	%></span><%
				}
			}
			%></div><div class="field"><span class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeNomPro" />"><system:label show="text" label="lblEjeNomPro" />:</span><%
			proVo.setLanguage(BasicBeanStatic.getUserDataStatic(request).getLangId());
			TranslationManager.setTranslationByNumber(proVo);
			%><span class='monitor-input'><%=BeanUtils.fmtHTML(proVo.getProTitle())%></span></div><div class="field"><span class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeAccPro" />"><system:label show="text" label="lblEjeAccPro" />:</span><span class='monitor-input'><%
			if (proVo.getProAction().equals(ProcessVo.PROCESS_ACTION_ALTERATION)) {
				%><system:label show="text" label="lblAccProAlt" /><%
			} else if (proVo.getProAction().equals(ProcessVo.PROCESS_ACTION_CANCEL)) {
				%><system:label show="text" label="lblAccProCan" /><%  
			} else {
				%><system:label show="text" label="lblAccProCre" /><%
			}%></span></div><div class="field required"><label for="cmbProPri" <%if((proInstVo.getProInstId()!= null) && !("true".equals(request.getAttribute("priProFnc")))){ %>class="monitor-lbl" <%} %> title="<system:label show="tooltip" label="lblEjePriPro" />"><system:label show="text" label="lblEjePriPro" />:</label><select id="cmbProPri" name="cmbProPri" <%if((proInstVo.getProInstId()!= null) && !("true".equals(request.getAttribute("priProFnc")))){ %>disabled <%} %>><option value="<%=com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL%>" <%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL){	out.print(" selected ");}%> ><system:label show="text" label="lblEjePriProNor" /></option><option value="<%=com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW%>"    <%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW){		out.print(" selected ");}%> ><system:label show="text" label="lblEjePriProBaj" /></option><option value="<%=com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH%>"   <%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH){		out.print(" selected ");}%> ><system:label show="text" label="lblEjePriProAlt" /></option><option value="<%=com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT%>" <%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT){	out.print(" selected ");}%> ><system:label show="text" label="lblEjePriProUrg" /></option></select></div></div><div class="fieldGroup"><%
			String createUser = BeanUtils.fmtHTML(proInstVo.getProInstCreateUser());
			if(createUser == null || createUser.equals("")) {
				createUser = BasicBeanStatic.getUserDataStatic(request).getUserId();
			}
		%><div class="field"><span class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeUsuCrePro" />"><system:label show="text" label="lblEjeUsuCrePro" />:</span><span class='monitor-input'><%=createUser%></span></div><% 	
			
			boolean hasStatus = ProInstanceVo.PROC_STATUS_RUNNING.equals(proInstVo.getProInstStatus()) || ProInstanceVo.PROC_STATUS_CANCELLED.equals(proInstVo.getProInstStatus())
					|| ProInstanceVo.PROC_STATUS_FINALIZED.equals(proInstVo.getProInstStatus()) || ProInstanceVo.PROC_STATUS_COMPLETED.equals(proInstVo.getProInstStatus());
			
			if(hasStatus) {
		%><div class="field"><span class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeStaPro" />"><system:label show="text" label="lblEjeStaPro" />:</span><span class='monitor-input'><%
			if (ProInstanceVo.PROC_STATUS_RUNNING.equals(proInstVo.getProInstStatus())) {
				%><system:label show="text" label="lblMonInstProStaRun" /><%
			} else if (ProInstanceVo.PROC_STATUS_CANCELLED.equals(proInstVo.getProInstStatus())) {
				%><system:label show="text" label="lblMonInstProStaCan" /><%
			} else if (ProInstanceVo.PROC_STATUS_FINALIZED.equals(proInstVo.getProInstStatus())) {
				%><system:label show="text" label="lblMonInstProStaFin" /><%
			} else if (ProInstanceVo.PROC_STATUS_COMPLETED.equals(proInstVo.getProInstStatus())) {
				%><system:label show="text" label="lblMonInstProStaCom" /><%
			} %></span></div><%
		
			}
			
			Collection<CalendarVo> colCal = dBean.getCalendars();
			Integer selCalId = dBean.getSelectedCalendar();
			boolean hasCalendar = (selCalId != null && selCalId.intValue() != 0);
			boolean dontAllowChangeCalendar = proVo.getFlagValue(ProcessVo.FLAG_DONT_ALLOW_CALENDAR_CHANGE);
				   					
		   	if (colCal != null && colCal.size()>0) { %><div class="field"><label for="selCal" <%if(dontAllowChangeCalendar) { %> class="monitor-lbl" <% } %> title="<system:label show="tooltip" label="titCal" />"><system:label show="text" label="titCal" />:</label><input type=hidden name="txtCal" value=""><select id="selCal" name="selCal" <%if(dontAllowChangeCalendar){out.print(" readonly='readonly' class='txtReadOnly' ");} %>><%
				Iterator itCal = colCal.iterator();
				CalendarVo calVo = null;%><option value="0" label=" "></option><%
				while (itCal.hasNext()) {
					calVo = (CalendarVo) itCal.next();%><option value="<%=calVo.getCalendarId()%>" 
					<%
					if (hasCalendar) {
						if (calVo.getCalendarId().equals(selCalId)) {
							out.print ("selected");
						}%>
					><%=calVo.getCalendarName()%></option><%} else {%>
					><%=calVo.getCalendarName()%></option><%}%><%}%></select><button type='button' class='genericBtn' id="btnViewCal" title="<system:label show="tooltip" label="btnVer" />"><system:label show="text" label="btnVer" /></button></div><%	} %></div></div>