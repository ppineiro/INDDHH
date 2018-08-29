
<%@page import="com.dogma.UserData"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><div class="tabContent"><div class="fieldGroup"><div class="title"><system:label show="tooltip" label="sbtEjeDatEnt" /></div><div class="field required"><%
				if (! entityBean.isNewEntity()) {
					%><label class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeIdeEnt" />"><system:label show="text" label="lblEjeIdeEnt" />:</label><%
					out.print("<span class='monitor-input'>"+beInstVo.getEntityIdentification()+"</span>");
				} else {
					%><label class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeIdeEnt" />"><system:label show="text" label="lblEjeIdeEnt" />:</label><%
					if (BusEntityVo.IDENTIFIER_TXT_WRITE.equals(beVo.getBusEntIdePre())) {
						%><input type="text" name="txtEntPre" value="<%=BeanUtils.fmtStr(beInstVo.getBusEntInstNamePre())%>" size="5" maxlength="50"><%
						out.print(Parameters.IDENTIFIER_SEPARATOR);
					} else if (BusEntityVo.IDENTIFIER_TXT_FIXED.equals(BeanUtils.fmtStr(beVo.getBusEntIdePre()))) {
						out.print(beVo.getBusEntIdePreFix());
						
						out.print(Parameters.IDENTIFIER_SEPARATOR);
						%><input type="hidden" name="txtEntPre" value="<%=BeanUtils.fmtStr(beVo.getBusEntIdePreFix())%>"><%
					}
				
					if (BusEntityVo.IDENTIFIER_NUM_AUTO.equals(beVo.getBusEntIdeNum())) {
						%><span class='monitor-input'><system:label show="text" label="lblAutNum"/></span><%
	   				} else if (BusEntityVo.IDENTIFIER_NUM_SAME_PROCESS.equals(beVo.getBusEntIdeNum())) {
	   					%><span class='monitor-input'><system:label show="text" label="lblSameProc"/></span><%
					} else {
						%><input size=9 maxlength=9 name="txtEntNum" value="<%=BeanUtils.fmtInt(beInstVo.getBusEntInstNameNum())%>" <%if (BusEntityVo.IDENTIFIER_NUM_WRITE.equals(beVo.getBusEntIdeNum())){%> p_required=true <%}%>><%
					}
				
					if (BusEntityVo.IDENTIFIER_TXT_WRITE.equals(beVo.getBusEntIdePos())) {
						out.print(Parameters.IDENTIFIER_SEPARATOR);
						%><input size=5 maxlength=50 name="txtEntPos" value="<%=BeanUtils.fmtStr(beInstVo.getBusEntInstNamePos())%>"  size="5" maxlength="50"><%
					} else if (BusEntityVo.IDENTIFIER_TXT_FIXED.equals(beVo.getBusEntIdePos())) {
						out.print(Parameters.IDENTIFIER_SEPARATOR);
						%><input type=hidden maxlength=50 name="txtEntPos" value="<%=BeanUtils.fmtStr(beVo.getBusEntIdePosFix())%>"><%
						out.print(BeanUtils.fmtStr(beVo.getBusEntIdePosFix()));
					}
				}
				%></div><div class="field"><label class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeTipEnt" />"><system:label show="text" label="lblEjeTipEnt" /><system:label show="separator" label=""/></label><span class='monitor-input'><%
			UserData userData = BasicBeanStatic.getUserDataStatic(request);
			beVo.setLanguage(userData.getLangId());
			TranslationManager.setTranslationByNumber(beVo);
			%><%=BeanUtils.fmtHTML(beVo.getBusEntTitle())%></span></div></div><div class="fieldGroup"><div class="field"><label class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeUsuCreEnt" />"><system:label show="text" label="lblEjeUsuCreEnt" /><system:label show="separator" label=""/></label><span class='monitor-input'><%=BeanUtils.fmtHTML(beInstVo.getBusEntInstCreateUser())%></span></div><div class="field"><label class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeFecCreEnt" />"><system:label show="text" label="lblEjeFecCreEnt" /><system:label show="separator" label=""/></label><span class='monitor-input'><%=BeanUtils.fmtHTML(beInstVo.getBusEntInstCreateData())%></span></div><div class="field"><%	
			Object tBean = session.getAttribute("dBean");
			if (tBean instanceof InitTaskBean && ((InitTaskBean) tBean).getStartStatus() != null) {
				BusEntStatusVo statusVo = ((InitTaskBean) tBean).getStartStatus();
			%><label class="monitor-lbl" title="<system:label show="tooltip" label="lblEjeStaEnt" />"><system:label show="text" label="lblEjeStaEnt" /><system:label show="separator" label=""/></label><input type=hidden name="busEntSta" value="<%=BeanUtils.fmtInt(statusVo.getEntStaId())%>"><span class='monitor-input'><%=BeanUtils.fmtHTML(statusVo.getEntStaName())%></span><%} else { 
				Collection<BusEntStatusVo> col = entityBean.getStatusForEntity(beVo.getBusEntId());
				if (col != null) {%><label title="<system:label show="tooltip" label="lblEjeStaEnt" />"><system:label show="text" label="lblEjeStaEnt" /><system:label show="separator" label=""/></label><select id="busEntSta" name="busEntSta" <%Object obj = dBean; if ((request.getParameter("readOnly") != null) || (obj instanceof TaskBean) || (request.getAttribute("readOnly") != null)) {%> disabled="true" <%}%> ><option value="" selected><%	//Iterator it = col.iterator();
								BusEntStatusVo staVo = null;
			   					for (Iterator<BusEntStatusVo> it = col.iterator(); it.hasNext();) {
			   						staVo = it.next();
			   						staVo.setLanguage(userData.getLangId());
			   						TranslationManager.setTranslationByNumber(staVo);
									%><option value="<%=BeanUtils.fmtInt(staVo.getEntStaId())%>" <%
										if (staVo != null && staVo.getEntStaId().equals(beInstVo.getEntStaId())) {
											out.print ("selected");
										}%>><%=BeanUtils.fmtHTML(staVo.getEntStaName())%><% } %></select><%}
	   			}%></div></div></div>