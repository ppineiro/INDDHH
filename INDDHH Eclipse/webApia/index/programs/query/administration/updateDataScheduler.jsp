<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><% if (QueryVo.TYPE_OFF_LINE.equals(queryVo.getQryType())) { %><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabQrySch")%>" tabText="<%=LabelManager.getName(labelSet,"tabQrySch")%>"><% 
						SchBusClaActivityVo schVo = queryVo.getSchBusClaActivityVo(); 
						BusClaParBindingVo paramVo = null; %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtQrySch")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblPeri")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPeri")%>:</td><td><select p_required=true name="cmbPeri" id="cmbPeri" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPeri")%>" onChange="checkPeriodicity();"><option></option><%
									Collection cPer = SchedulerBean.getPeriodicity(request,labelSet);
									if(cPer!=null){
										Iterator itPer = cPer.iterator();
										while(itPer.hasNext()){
											CmbDataVo cmb = (CmbDataVo)itPer.next(); %><option value="<%=dBean.fmtHTML(cmb.getValue())%>" <%if(schVo!=null && schVo.getPeriodicity()!=null && schVo.getPeriodicity().equals(cmb.getValue())){out.print(" selected ");}%> ><%=dBean.fmtHTML(cmb.getText())%></option><%
										}
									} %></select></td><td title="<%=LabelManager.getToolTip(labelSet,"lblSchAfterSchSel")%>"><%=LabelManager.getNameWAccess(labelSet,"lblSchAfterSchSel")%>:</td><% schVo = queryVo.getSchBusClaActivityVo(); %><td><select <% if (schVo != null && SchBusClaActivityVo.PERIODICITY_AFTER_SCHEDULER.equals(schVo.getPeriodicity())) { %> p_required=true <% } else { %> disabled <% } %> name="cmbSchAfterSchId" id="cmbSchAfterSchId" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblSchAfterSchSel")%>"><option></option><% 
					   					Collection schs = dBean.getSchedulers(); 
					   					if (schs != null) {
					   						for (Iterator it = schs.iterator(); it.hasNext(); ) {
					   							SchBusClaActivityVo aSch = (SchBusClaActivityVo) it.next();
					   							%><option value="<%=dBean.fmtHTML(aSch.getSchBusClaId())%>" <%if(schVo!=null && schVo.getSchAfterSchId()!=null && schVo.getSchAfterSchId().equals(aSch.getSchBusClaId())){out.print(" selected ");}%> ><%=dBean.fmtHTML(aSch.getSchName())%></option><%
					   						}
					   					} %></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblSchStaDis")%>"><%=LabelManager.getNameWAccess(labelSet,"lblSchStaDis")%>:</td><td><input type=checkbox name=chkSchDisabled <%if(schVo!=null && schVo.getSchActStatus() != null && SchBusClaActivityVo.STATUS_DISABLED == schVo.getSchActStatus().intValue()) {out.print(" checked ");} %> ></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblFchIni")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFchIni")%>:</td><td><input type=text name="txtFchIni" p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_required="true" size="10" maxlength="10" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFchIni")%>" <%if(schVo!=null){%>value="<%=dBean.fmtHTML(schVo.getFirstExecution())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblHorIni")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHorIni")%>:</td><td><input type=text name="txtHorIni" maxlength=5 size=5 p_mask="<%=DogmaUtil.getHTMLTimeMask()%>" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblHorIni")%>"  <%if(schVo!=null && schVo.getFirstExecution()!=null){%>value="<%=schVo.getHourMinute(schVo.getFirstExecution())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblUltEje")%>"><%=LabelManager.getName(labelSet,"lblUltEje")%>:</td><td><input type=text name="txtUltEje" readonly size="10" maxlength="10" class="txtReadOnly" <%if(schVo!=null){%>value="<%=dBean.fmtHTML(schVo.getLastExecution())%>"<%}%>><input type=text name="txtUltEjeHor" readonly maxlength=5 size=5 class="txtReadOnly" <%if(schVo!=null && schVo.getLastExecution()!=null){%>value="<%=schVo.getHourMinute(schVo.getLastExecution())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblSta")%>"><%=LabelManager.getName(labelSet,"lblSta")%>:</td><td><% if (schVo.getSchActStatus() != null) {
										switch (schVo.getSchActStatus().intValue()) {
											case SchBusClaActivityVo.STATUS_NONE:
												out.write(LabelManager.getName(labelSet,"lblSchStaNoRun"));
												break;
											case SchBusClaActivityVo.STATUS_IN_EXECUTION:
												out.write(LabelManager.getName(labelSet,"lblSchStaRun"));
												break;
											case SchBusClaActivityVo.STATUS_FOR_EXECUTION:
												out.write(LabelManager.getName(labelSet,"lblSchStaForRun"));
												break;
											case SchBusClaActivityVo.STATUS_CANCEL:
												out.write(LabelManager.getName(labelSet,"lblSchStaCancel"));
												break;
											case SchBusClaActivityVo.STATUS_FINISH_OK:
												out.write(LabelManager.getName(labelSet,"lblSchStaOk"));
												break;
											case SchBusClaActivityVo.STATUS_FINISH_ERROR:
												out.write(LabelManager.getName(labelSet,"lblSchStaError"));
												break;
										}
									} %></td></tr><%
			   			int radSel=1;
			   			if (!Parameters.SCHED_DISTRIBUTED || schVo.getNodeName() == null || "".equals(schVo.getNodeName())) {
			   				radSel=1;
			   			}else {
			   				radSel=2;
			   			}
			   		%><tr><td align=right><%=LabelManager.getName(labelSet,"lblExeNode")%>:</td><td><input type="radio" name="radExeNode" onclick="showOtherNode(1,false);" value="1" <%if(radSel==1) {out.print(" checked ");}%><%= (!Parameters.SCHED_DISTRIBUTED)?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblAllNodes")%></td></tr><tr><td><input type=hidden name="radSelected" value="<%=radSel%>"></td><td><input type="radio" name="radExeNode" onclick="showOtherNode(2,true);" value="2" <%if (radSel==2) {out.print(" checked ");}%><%= (!Parameters.SCHED_DISTRIBUTED)?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblSpecNode")%>:
									<input <%= (!Parameters.SCHED_DISTRIBUTED || schVo.getNodeName() == null || "".equals(schVo.getNodeName()))?"disabled":"" %> p_required="<%=(Parameters.SCHED_DISTRIBUTED)?"true":"false" %> type="text" name="txtExeNode" id="txtExeNode" value="<%=(Parameters.SCHED_DISTRIBUTED && schVo.getNodeName() != null)?dBean.fmtHTML(schVo.getNodeName()):""%>"></td></tr><!--     - Parámetros de la consulta          --><tr><td colspan="4"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtParSch")%></DIV></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblQryParamSave")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryParamSave")%></td><td colspan="3"><% 
				   					if (schVo != null) {
				   						paramVo = schVo.getParameter(QueryColumns.PARAM_SAVE_AS);
				   					} %><select name="<%= QueryColumns.PARAM_SAVE_AS %>" id="<%= QueryColumns.PARAM_SAVE_AS %>"  accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryParamSave")%>" p_required="true" accesskey="" onchange='paramSave_onChange()'><option></option><option value="<%= QryColumnVo.OFF_LINE_SAVE_AS_PDF %>" <%= (paramVo != null && QryColumnVo.OFF_LINE_SAVE_AS_PDF.equals(paramVo.getBusClaParBndValue()))?"selected":"" %>><%=LabelManager.getName(labelSet,"lblPdf")%></option><option value="<%= QryColumnVo.OFF_LINE_SAVE_AS_HTML %>" <%= (paramVo != null && QryColumnVo.OFF_LINE_SAVE_AS_HTML.equals(paramVo.getBusClaParBndValue()))?"selected":"" %>><%=LabelManager.getName(labelSet,"lblHtml")%></option><option value="<%= QryColumnVo.OFF_LINE_SAVE_AS_CSV %>" <%= (paramVo != null && QryColumnVo.OFF_LINE_SAVE_AS_CSV.equals(paramVo.getBusClaParBndValue()))?"selected":"" %>><%=LabelManager.getName(labelSet,"lblCsv")%></option><option value="<%= QryColumnVo.OFF_LINE_SAVE_AS_EXCEL %>" <%= (paramVo != null && QryColumnVo.OFF_LINE_SAVE_AS_EXCEL.equals(paramVo.getBusClaParBndValue()))?"selected":"" %>><%=LabelManager.getName(labelSet,"lblExcel")%></option></select></td><td></td><td>/<td></tr><tr><td></td><td><% 
				   					if (schVo != null) {
				   						paramVo = schVo.getParameter(QueryColumns.PARAM_PAGED);
				   					} %><input type="checkbox" name="<%= QueryColumns.PARAM_PAGED %>" id="<%= QueryColumns.PARAM_PAGED %>" onclick="paramPag_onClick()" <%= (paramVo != null && ! "".equals(paramVo.getBusClaParBndValue()))?"checked":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryParamPag")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryParamPag")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblQryParamPagNum")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryParamPagNum")%></td><td><% 
				   					if (schVo != null) {
				   						paramVo = schVo.getParameter(QueryColumns.PARAM_PAGE_NUM);
				   					} %><input type="text" p_numeric="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryParamPagNum")%>" name="<%= QueryColumns.PARAM_PAGE_NUM %>" id="<%= QueryColumns.PARAM_PAGE_NUM %>" value="<%= (paramVo != null && ! "".equals(paramVo.getBusClaParBndValue()))?dBean.fmtStr(paramVo.getBusClaParBndValue()):"0"%>"></td></tr><tr><td></td><td title=""><% 
				   					if (schVo != null) {
				   						paramVo = schVo.getParameter(QueryColumns.PARAM_HAS_MAX);
				   					} %><input type="checkbox" name="<%= QueryColumns.PARAM_HAS_MAX %>" onClick="paramMax_onClick()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryParamMax")%>" <%= (paramVo != null && ! "".equals(paramVo.getBusClaParBndValue()))?"checked":"" %>><%=LabelManager.getNameWAccess(labelSet,"lblQryParamMax")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblQryParamMaxNum")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryParamMaxNum")%></td><td><% 
				   					if (schVo != null) {
				   						paramVo = schVo.getParameter(QueryColumns.PARAM_MAX_NUM);
				   					} %><input type="text" p_numeric="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryParamMaxNum")%>" name="<%= QueryColumns.PARAM_MAX_NUM %>" id="<%= QueryColumns.PARAM_MAX_NUM %>" value="<%= (paramVo != null && ! "".equals(paramVo.getBusClaParBndValue()))?dBean.fmtStr(paramVo.getValueAsString()):"0"%>"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblQryParamRes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryParamRes")%></td><td><% 
				   					if (schVo != null) {
				   						paramVo = schVo.getParameter(QueryColumns.PARAM_RESULT_NUM);
				   					} %><input type="text" p_numeric="true" p_required="true" value="<%= (paramVo != null && ! "".equals(paramVo.getBusClaParBndValue()))?dBean.fmtStr(paramVo.getValueAsString()):"1"%>" name="<%= QueryColumns.PARAM_RESULT_NUM %>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryParamRes")%>"></td></tr></table></div><% } %>
