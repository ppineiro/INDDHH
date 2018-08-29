		
<%@page import="com.st.util.translator.TranslationManager"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.Parameters"%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeDatEnt")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeIdeEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeIdeEnt")%>:</td><td class=readOnly><%
		   					   			if (! entityBean.isNewEntity()) {
		   					   			out.print(beInstVo.getEntityIdentification());
		   					   		} else {
		   				   		if (BusEntityVo.IDENTIFIER_TXT_WRITE.equals(beVo.getBusEntIdePre())) {
		   			%><input size=5 maxlength=50 name="txtEntPre" value="<%=dBean.fmtStr(beInstVo.getBusEntInstNamePre())%>"><%
			   					out.print(Parameters.IDENTIFIER_SEPARATOR);
			   				} else if (BusEntityVo.IDENTIFIER_TXT_FIXED.equals(beVo.getBusEntIdePre())) {
			   					out.print(dBean.fmtHTML(beVo.getBusEntIdePreFix()));
			   				%><input type=hidden maxlength=50 name="txtEntPre" value="<%=dBean.fmtStr(beVo.getBusEntIdePreFix())%>"><%
			   					out.print(Parameters.IDENTIFIER_SEPARATOR);
			   				}
			   				
			   				if (BusEntityVo.IDENTIFIER_NUM_AUTO.equals(beVo.getBusEntIdeNum())) {
								out.print(LabelManager.getName(labelSet,"lblAutNum"));
							  } else {
			   				%><input size=9 maxlength=9 name="txtEntNum" value="<%=dBean.fmtInt(beInstVo.getBusEntInstNameNum())%>" <%if (BusEntityVo.IDENTIFIER_NUM_WRITE.equals(beVo.getBusEntIdeNum())){%> p_required=true <%}%> p_numeric=true><%
			   				}
			   				
							if (BusEntityVo.IDENTIFIER_TXT_WRITE.equals(beVo.getBusEntIdePos())) {
			   					out.print(Parameters.IDENTIFIER_SEPARATOR);
							%><input size=5 maxlength=50 name="txtEntPos" value="<%=dBean.fmtStr(beInstVo.getBusEntInstNamePos())%>"><%
							} else if (BusEntityVo.IDENTIFIER_TXT_FIXED.equals(beVo.getBusEntIdePos())) {
			   					out.print(Parameters.IDENTIFIER_SEPARATOR);
			   				%><input type=hidden maxlength=50 name="txtEntPos" value="<%=dBean.fmtStr(beVo.getBusEntIdePosFix())%>"><%
			   					out.print(dBean.fmtHTML(beVo.getBusEntIdePosFix()));
			   				}
						}
		   				%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeUsuCreEnt")%>"><%=LabelManager.getName(labelSet,"lblEjeUsuCreEnt")%>:</td><td class="readOnly"><%=dBean.fmtHTML(beInstVo.getBusEntInstCreateUser())%>&nbsp</td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeTipEnt")%>"><%=LabelManager.getName(labelSet,"lblEjeTipEnt")%>:</td><td class="readOnly"><%=dBean.fmtHTML(beVo.getBusEntTitle())%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeFecCreEnt")%>"><%=LabelManager.getName(labelSet,"lblEjeFecCreEnt")%>:</td><td class="readOnly"><%=dBean.fmtHTML(beInstVo.getBusEntInstCreateData())%>&nbsp</td></tr><tr><%	Object tBean = session.getAttribute("dBean");
		   			if (tBean instanceof InitTaskBean && ((InitTaskBean) tBean).getStartStatus() != null) {
			   				BusEntStatusVo statusVo = ((InitTaskBean) tBean).getStartStatus();
		   			%><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaEnt")%>"><%=LabelManager.getName(labelSet,"lblEjeStaEnt")%>:</td><td class=readOnly><input type=hidden name="busEntSta" value="<%=dBean.fmtInt(statusVo.getEntStaId())%>"><%=dBean.fmtHTML(statusVo.getEntStaName())%><%} else { 
		   			Collection col = entityBean.getStatusForEntity(request, beVo.getBusEntId());
		   			if (col != null) { 
		   			%><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaEnt")%>"><%=LabelManager.getName(labelSet,"lblEjeStaEnt")%>:</td><td colspan=3><select name="busEntSta" <%Object obj = dBean; if ((request.getParameter("readOnly") != null) || (obj instanceof TaskBean)) {%> disabled="true" <%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeStaEnt")%>"><option value="" selected><%	Iterator it = col.iterator();
								BusEntStatusVo staVo = null;
			   					while (it.hasNext()) {
			   						staVo = (BusEntStatusVo) it.next();
			   						staVo.setLanguage(((UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE)).getLangId());
			   						TranslationManager.setTranslationByNumber(staVo);
									%><option value="<%=dBean.fmtInt(staVo.getEntStaId())%>" <%
										if (staVo != null && staVo.getEntStaId().equals(beInstVo.getEntStaId())) {
											out.print ("selected");
										}%>><%=dBean.fmtHTML(staVo.getEntStaName())%><% 	}
		   				%></select></td><%}
	   				}%></tr></table><%
dBean.setFormHasBeenDrawed(true);
%>			   	