<%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="com.dogma.UserData"%><DIV id="divContent"  <%=cmp_div_height%> class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeIdeEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeIdeEnt")%>:</td><td nowrap><input name="filEntNamPre" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeIdeEnt")%>" size=5 maxlength="50" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getEntNamePre())%>"><input name="filEntNamNum" size=5 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeIdeEnt")%>" p_numeric="true" maxlength="9" type="text" value="<%=dBean.fmtInt(dBean.getFilter().getEntNameNum())%>"><input name="filEntNamPos" size=5 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeIdeEnt")%>" maxlength="50" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getEntNamePos())%>"></td><%if (!BusEntityVo.ADMIN_FUNCT.equals(dBean.getSpecificEntityType()) && !dBean.isProAlter()) {%><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeProAct")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeProAct")%>:</td><td><%boolean allowUpdate = (dBean.getSpecificEntity()!= null && BusEntityVo.ALLOW_UPDATE_INSTANCE.equals(dBean.getEntityType().getBusEntAllowUpdInst()));%><% if (request.getParameter("txtProId") != null && !allowUpdate) {%><input type=hidden name="filProAct" value="0"><%=dBean.fmtHTML(LabelManager.getName(labelSet, "lblEjeNo"))%><%} else { %><select name="filProAct" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeProAct")%>"><option><option value="0" <%=com.dogma.DogmaConstants.DB_FALSE_INT.equals(dBean.getFilter().getBlnProc())? "selected" : ""%>><%=dBean.fmtHTML(LabelManager.getName(labelSet, "lblEjeNo"))%><option value="1" <%=com.dogma.DogmaConstants.DB_TRUE_INT.equals(dBean.getFilter().getBlnProc())? "selected" : ""%>><%=dBean.fmtHTML(LabelManager.getName(labelSet, "lblEjeSi"))%></select><%}%></td><%}%></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeFchDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeFchDes")%>:</td><td><input name="filFchDes" p_calendar="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeFchDes")%>" size="10" maxlength="10" type="text" class="txtDate" p_mask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" value="<%=dBean.fmtDate(dBean.getFilter().getDateFrom())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeFchHas")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeFchHas")%>:</td><td><input name="filFchHas" p_calendar="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeFchHas")%>" size="10" maxlength="10" type="text" class="txtDate" p_mask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" value="<%=dBean.fmtDate(dBean.getFilter().getDateTo())%>"></td></tr><%Collection col = null;
					if (dBean.getSpecificEntity() == null) {
						blnProcess = true;%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeTipEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeTipEnt")%>:</td><td colspan=3><select name="filTipEnt" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeTipEnt")%>" p_required="true"><option><%	col = dBean.getBusEntities(request);
				   					if (col != null) {
				   						Iterator it = col.iterator();
										BusEntityVo entVo = null;
				   						while (it.hasNext()) {
				   							entVo = (BusEntityVo) it.next();
				   							entVo.setLanguage(uData.getLangId());
				   							TranslationManager.setTranslationByNumber(entVo);
										%><option value="<%=dBean.fmtInt(entVo.getBusEntId())%>" <%
											if (dBean.getEntType() != null && dBean.getEntType().equals(entVo.getBusEntId())) {
												out.print ("selected");
											}%>><%=dBean.fmtHTML(entVo.getBusEntTitle())%><% 	}
				   					}
				   				%></select></td></tr><%}%><tr><%  if (dBean.getSpecificEntity() != null) {
							col = dBean.getStatusForEntity(request, dBean.getSpecificEntity());
						} else {
							col = dBean.getAllStatus(request);
						}
						if (col!=null) {
							blnStatus = true; %><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeStaEnt")%>:</td><td colspan=2><select name="filStaEnt" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeStaEnt")%>"><option><%
				   					if (col != null) {
				   						Iterator it = col.iterator();
										BusEntStatusVo staVo = null;
				   						while (it.hasNext()) {
				   							staVo = (BusEntStatusVo) it.next(); %><option value="<%=dBean.fmtInt(staVo.getEntStaId())%>" <%
											if (dBean.getFilter().getStatus() != null && dBean.getFilter().getStatus().equals(staVo.getEntStaId())) {
												out.print ("selected");
											}%>><%=dBean.fmtHTML(staVo.getEntStaName())%><% 	}
				   					} %></select></td><%}%><% 
		   				boolean[] showAttValue = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true};
		   				if (! blnSpecific) { %><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt1EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt1EntNeg") %>:</td><td><input type="text" name="txtFilAttVal1" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt1EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue1())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt2EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt2EntNeg") %>:</td><td><input type="text" name="txtFilAttVal2" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt2EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue2())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt3EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt3EntNeg") %>:</td><td><input type="text" name="txtFilAttVal3" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt3EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue3())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt4EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt4EntNeg") %>:</td><td><input type="text" name="txtFilAttVal4" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt4EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue4())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt5EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt5EntNeg") %>:</td><td><input type="text" name="txtFilAttVal5" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt5EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue5())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt6EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt6EntNeg") %>:</td><td><input type="text" name="txtFilAttVal6" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt6EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue6())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt7EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt7EntNeg") %>:</td><td><input type="text" name="txtFilAttVal7" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt7EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue7())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt8EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt8EntNeg") %>:</td><td><input type="text" name="txtFilAttVal8" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt8EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue8())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt9EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt9EntNeg") %>:</td><td><input type="text" name="txtFilAttVal9" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt5EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue9())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt10EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt10EntNeg") %>:</td><td><input type="text" name="txtFilAttVal10" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAt106EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValue10())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum1EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum1EntNeg") %>:</td><td><input type="text" name="txtFilAttValNum1" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum1EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueNum1())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum2EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum2EntNeg") %>:</td><td><input type="text" name="txtFilAttValNum2" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum2EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueNum2())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum3EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum3EntNeg") %>:</td><td><input type="text" name="txtFilAttValNum3" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum3EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueNum3())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum4EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum4EntNeg") %>:</td><td><input type="text" name="txtFilAttValNum4" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum4EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueNum4())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum5EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum5EntNeg") %>:</td><td><input type="text" name="txtFilAttValNum5" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum5EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueNum5())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum6EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum6EntNeg") %>:</td><td><input type="text" name="txtFilAttValNum6" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum6EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueNum6())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum7EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum7EntNeg") %>:</td><td><input type="text" name="txtFilAttValNum7" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum7EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueNum7())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum8EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum8EntNeg") %>:</td><td><input type="text" name="txtFilAttValNum8" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum8EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueNum8())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte1EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte1EntNeg") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte1I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte1EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte1I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte1F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte1EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte1F())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte2EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte2EntNeg") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte2I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte2EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte2I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte2F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte2EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte2F())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte3EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte3EntNeg") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte3I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte3EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte3I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte3F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte3EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte3F())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte4EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte4EntNeg") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte4I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte4EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte4I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte4F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte4EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte4F())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte5EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte5EntNeg") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte5I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte3EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte5I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte5F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte3EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte5F())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte6EntNeg") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte6EntNeg") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte6I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte4EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte6I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte6F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte4EntNeg") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getAttValueDte6F())%>"></td></tr><%
		   				} else if (dBean.getEntitySpecificAttributes() != null) {
							Iterator attributes = dBean.getEntitySpecificAttributes().iterator();
							AttributeVo att = null;
							int count = 0;
							int countStr = 0;
							int countNum = 0;
							int countDte = 0;
							int countIdStr = 0;
							int countIdNum = 0;
							int countIdDte = 0;
							boolean openTr = false;
							
							for (int i = 0; i < showAttValue.length; i++) {
								showAttValue[i] = false;
							}
							
							while (attributes.hasNext()) {
								att = (AttributeVo) attributes.next();
								count ++;
								
								countIdStr++;
								if (countIdStr > 10) {
									countIdNum++;
									if (countIdNum > 8) {
										countIdDte++;
									}
								}
								
								if (att != null) {
									showAttValue[count-1] = true;
									if (AttributeVo.TYPE_STRING.equals(att.getAttType())) {
										countStr++;
										if (countStr == 1 || countStr == 3 || countStr == 5 || countStr == 7 || countStr == 9) {
											if (openTr) {
												out.println("</tr>");
											}
											out.println("<tr>");
											openTr = true;
										} %><td title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=dBean.fmtHTML(att.getAttLabel())%>:</td><td><input type="text" name="txtFilAttVal<%=countIdStr%>" value="<%
											switch(countIdStr) {
												case 1:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue1()));
													break;
												case 2:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue2()));
													break;
												case 3:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue3()));
													break;
												case 4:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue4()));
													break;
												case 5:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue5()));
													break;
												case 6:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue6()));
													break;
												case 7:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue7()));
													break;													
												case 8:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue8()));
													break;
												case 9:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue9()));
													break;
												case 10:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValue10()));
													break;
											} %>"></td><%
										if (countStr == 2 || countStr == 4 || countStr == 6 || countStr == 8 || countStr == 10) {
											out.println("</tr>");
											openTr = false;
										}
	
									} else if (AttributeVo.TYPE_NUMERIC.equals(att.getAttType())) {
										countNum++;
										if (countNum == 1 || countNum == 3 || countNum == 5 || countNum == 7) {
											if (openTr) {
												out.println("</tr>");
											}
											out.println("<tr>");
											openTr = true;
										} %><td title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=dBean.fmtHTML(att.getAttLabel())%>:</td><td><input type="text" p_numeric="true" name="txtFilAttValNum<%=countIdNum%>" value="<%
											switch(countIdNum) {
												case 1:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueNum1()));
													break;
												case 2:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueNum2()));
													break;
												case 3:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueNum3()));
													break;
												case 4:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueNum4()));
													break;
												case 5:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueNum5()));
													break;
												case 6:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueNum6()));
													break;
												case 7:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueNum7()));
													break;
												case 8:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueNum8()));
													break;
											} %>"></td><%
										if (countNum == 2 || countNum == 4 || countNum == 6 || countNum == 8) {
											out.println("</tr>");
											openTr = false;
										}
									
									} else if (AttributeVo.TYPE_DATE.equals(att.getAttType())) {
										countDte++;
										if (countDte == 1 || countDte == 3 || countDte == 5) {
											if (openTr) {
												out.println("</tr>");
											}
											out.println("<tr>");
											openTr = true;
										} %><td title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=dBean.fmtHTML(att.getAttLabel())%>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte<%=countIdDte%>I" value="<%
											switch(countIdDte) {
												case 1:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte1I()));
													break;
												case 2:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte2I()));
													break;
												case 3:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte3I()));
													break;
												case 4:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte4I()));
													break;
												case 5:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte5I()));
													break;
												case 6:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte6I()));
													break;
											} %>">
											-
											<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilAttValDte<%=countIdDte%>F" value="<%
											switch(countIdDte) {
												case 1:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte1F()));
													break;
												case 2:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte2F()));
													break;
												case 3:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte3F()));
													break;
												case 4:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte4F()));
													break;
												case 5:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte5F()));
													break;
												case 6:
													out.print(dBean.fmtHTML(dBean.getFilter().getAttValueDte6F()));
													break;
											} %>"></td><%
										if (countDte == 2 || countDte == 4 || countDte == 5) {
											out.println("</tr>");
											openTr = false;
										}
									}
								} //if (att == null)
							} 
							if (openTr) {
								out.println("</tr>");
							}
						} %></table></div><table class="tblFormLayout"><td></td><td width="100%" align="right"><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></table></DIV><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeRes")%></DIV><div style="height:<%=Parameters.SCREEN_LIST_SIZE%>px;" type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table id="tblHead" cellpadding="0" cellspacing="0"><thead><tr><th align="center" style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeSelTod")%>"></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ID; %><th min_width="80px" style="width:80px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ID%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblEjeIdeEnt")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblEjeIdeEnt")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_TYPE; %><%if (!blnSpecific) {%><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_TYPE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblEjeTip")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblEjeTip")%><%=canOrderBy?"</u>":""%></th><%}%><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_STATUS; %><%if (blnStatus) {%><th min_width="120px" style="width:120px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_STATUS%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaEnt")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblEjeStaEnt")%><%=canOrderBy?"</u>":""%></th><%}%><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_PROCESS; %><%if (blnProcess) {%><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_PROCESS%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblEjeNomPro")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblEjeNomPro")%><%=canOrderBy?"</u>":""%></th><%}%><% if (! blnSpecific) { %><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_1; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_1%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt1EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt1EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_2; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_2%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt2EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt2EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_3; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_3%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt3EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt3EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_4; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_4%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt4EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt4EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_5; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_5%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt5EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt5EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_6; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_6%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt6EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt6EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_7; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_7%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt7EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt7EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_8; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_8%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt8EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt8EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_9; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_9%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt9EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt9EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_10; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_10%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAtt10EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAtt10EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_NUM_1; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_NUM_1%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum1EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttNum1EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_NUM_2; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_NUM_2%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum2EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttNum2EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_NUM_3; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_NUM_3%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum3EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttNum3EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_NUM_4; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_NUM_4%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum4EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttNum4EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_NUM_5; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_NUM_5%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum5EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttNum5EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_NUM_6; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_NUM_6%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum6EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttNum6EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_NUM_7; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_NUM_7%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum7EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttNum7EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_NUM_8; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_NUM_8%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum8EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttNum8EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_DTE_1; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_DTE_1%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte1EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttDte1EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_DTE_2; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_DTE_2%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte2EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttDte2EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_DTE_3; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_DTE_3%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte3EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttDte3EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_DTE_4; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_DTE_4%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte4EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttDte4EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_DTE_5; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_DTE_5%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte5EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttDte5EntNeg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_ATT_DTE_6; %><th min_width="150px" style="width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_ATT_DTE_6%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte6EntNeg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblAttDte6EntNeg")%><%=canOrderBy?"</u>":""%></th><%	} else if (dBean.getEntitySpecificAttributes() != null) {
									Iterator attributes = dBean.getEntitySpecificAttributes().iterator();
									AttributeVo att = null;
									int count = BusEntInstFilterVo.ORDER_ATT_1;
									while (attributes.hasNext()) {
										att = (AttributeVo) attributes.next();
										canOrderBy = 
										(count == BusEntInstFilterVo.ORDER_ATT_1 && BusEntInstFilterVo.ORDER_ATT_1 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_2 && BusEntInstFilterVo.ORDER_ATT_2 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_3 && BusEntInstFilterVo.ORDER_ATT_3 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_4 && BusEntInstFilterVo.ORDER_ATT_4 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_5 && BusEntInstFilterVo.ORDER_ATT_5 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_6 && BusEntInstFilterVo.ORDER_ATT_6 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_7 && BusEntInstFilterVo.ORDER_ATT_7 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_8 && BusEntInstFilterVo.ORDER_ATT_8 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_9 && BusEntInstFilterVo.ORDER_ATT_9 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_10 && BusEntInstFilterVo.ORDER_ATT_10 != dBean.getFilter().getOrderBy()) ||
																				
										(count == BusEntInstFilterVo.ORDER_ATT_NUM_1 && BusEntInstFilterVo.ORDER_ATT_NUM_1 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_NUM_2 && BusEntInstFilterVo.ORDER_ATT_NUM_2 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_NUM_3 && BusEntInstFilterVo.ORDER_ATT_NUM_3 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_NUM_4 && BusEntInstFilterVo.ORDER_ATT_NUM_4 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_NUM_5 && BusEntInstFilterVo.ORDER_ATT_NUM_5 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_NUM_6 && BusEntInstFilterVo.ORDER_ATT_NUM_6 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_NUM_7 && BusEntInstFilterVo.ORDER_ATT_NUM_7 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_NUM_8 && BusEntInstFilterVo.ORDER_ATT_NUM_8 != dBean.getFilter().getOrderBy()) ||

										(count == BusEntInstFilterVo.ORDER_ATT_DTE_1 && BusEntInstFilterVo.ORDER_ATT_DTE_1 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_DTE_2 && BusEntInstFilterVo.ORDER_ATT_DTE_2 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_DTE_3 && BusEntInstFilterVo.ORDER_ATT_DTE_3 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_DTE_4 && BusEntInstFilterVo.ORDER_ATT_DTE_4 != dBean.getFilter().getOrderBy()) ||
										(count == BusEntInstFilterVo.ORDER_ATT_DTE_5 && BusEntInstFilterVo.ORDER_ATT_DTE_5 != dBean.getFilter().getOrderBy()) ||				
										(count == BusEntInstFilterVo.ORDER_ATT_DTE_6 && BusEntInstFilterVo.ORDER_ATT_DTE_6 != dBean.getFilter().getOrderBy());
										
										showAttValue[count - BusEntInstFilterVo.ORDER_ATT_1] = att != null;
										if (att != null) { %><th min_width="100px" style="width:100px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=count%>')<%}%>" title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=canOrderBy?"<u>":""%><%=dBean.fmtHTML(att.getAttLabel())%><%=canOrderBy?"</u>":""%></th><%
										}
										count ++;
									} 
								}%><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_CREATE_DATE; %><th min_width="140px" style="width:140px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_CREATE_DATE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblEjeFchCre")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblEjeFchCre")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != BusEntInstFilterVo.ORDER_CREATE_USER; %><th min_width="110px" style="width:110px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=BusEntInstFilterVo.ORDER_CREATE_USER%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblEjeUsuCre")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblEjeUsuCre")%><%=canOrderBy?"</u>":""%></th></tr></thead><tbody><%	col = dBean.getList();
							if (col != null) {
								Iterator it = col.iterator();
								int i = 0;
								ConsultBusEntInstancesVo consVo = null;
								while (it.hasNext()) {
									consVo = (ConsultBusEntInstancesVo) it.next();%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkSel<%=i%>" value="<%=dBean.fmtInt(consVo.getBusEntInstId())%>"><input type="hidden" id="idSel" name="txtEntId<%=i%>" value="<%=dBean.fmtInt(consVo.getBusEntInstId())%>"><input type="hidden" name="txtBusEntId<%=dBean.fmtInt(consVo.getBusEntInstId())%>" value="<%=dBean.fmtInt(consVo.getBusEntId())%>"><input type="hidden" name="txtBusEntAdm<%=dBean.fmtInt(consVo.getBusEntInstId())%>" value="<%=dBean.fmtHTML(consVo.getEntityType().getBusEntAdminType())%>"></td><td><%=dBean.fmtHTML(consVo.getEntityIdentification())%></td><%if (!blnSpecific) {%><td><%=dBean.fmtHTML(consVo.getEntityType()!=null?consVo.getEntityType().getBusEntTitle():"")%></td><%}%><%if (blnStatus) {%><td><%=dBean.fmtHTML(consVo.getEntityStatus()!=null?TranslationManager.getStatusTitle(consVo.getEntityStatus().getEntStaName(), ((UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE)).getEnvironmentId(), ((UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE)).getLangId()):"")%></td><%}%><%if (blnProcess) {%><td><%=dBean.fmtHTML(consVo.getProcessInstance()!=null && consVo.getProcessInstance().getProcess() != null ? consVo.getProcessInstance().getProcess().getProName():"")%></td><%}%><% for (int j = 0; j < showAttValue.length; j++) { %><%if (showAttValue[j]) {%><td <%=(consVo.getAttLabel(j) != null)?("title=\"" + dBean.fmtHTML(consVo.getAttLabel(j)) + "\""):""%>><%=dBean.fmtHTMLObject(consVo.getAttValue(j))%></td><%}%><% } %><td><%=dBean.fmtHTMLTime(consVo.getBusEntInstCreateData())%></td><td><%=dBean.fmtHTML(consVo.getBusEntInstCreateUser())%></td></tr><%i++;%><%}
							}%></tbody></table></div><%
dBean.setFormHasBeenDrawed(true);
%>	