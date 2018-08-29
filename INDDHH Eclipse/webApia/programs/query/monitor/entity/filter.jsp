<%@page import="com.dogma.vo.BusEntInstanceVo"%><%@page import="biz.statum.sdk.util.CollectionUtil"%><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.BusEntityVo"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="com.dogma.UserData"%><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMonEntFilUsuAct")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonEntFilUsuAct")%>:</td><td><input type="text" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonEntFilUsuAct")%>" name="usrLogin" value="<%= dBean.fmtStr(dBean.getFilter().getUsrLogin()) %>"></td><% if (dBean.getFilter().isGlobal()) { %><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeTipEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeTipEnt")%>:</td><td colspan=3><select name="busEntId" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeTipEnt")%>" p_required="true"><option><%	Collection col = dBean.getEntities();
							   					if (col != null) {
							   						Iterator it = col.iterator();
													BusEntityVo entVo = null;
							   						while (it.hasNext()) {
							   							entVo = (BusEntityVo) it.next();
							   							entVo.setLanguage(uData.getLangId());
							   							TranslationManager.setTranslationByNumber(entVo);
													%><option value="<%=dBean.fmtInt(entVo.getBusEntId())%>" <%
														if (entVo.getBusEntId().equals(dBean.getFilter().getBusEntId())) {
															out.print ("selected");
														}%>><%=dBean.fmtHTML(entVo.getBusEntTitle())%><% 	}
							   					}
							   				%></select></td><% } %></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMonEntFilActFrom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonEntFilActFrom")%>:</td><td><input name="dateFrom" p_calendar="true" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonEntFilActFrom")%>" size="10" maxlength="10" type="text" class="txtDate" p_mask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" value="<%=dBean.fmtDate(dBean.getFilter().getDateFrom())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMonEntFiLActTo")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonEntFiLActTo")%>:</td><td><input name="dateTo" p_calendar="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonEntFiLActTo")%>" size="10" maxlength="10" type="text" class="txtDate" p_mask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" value="<%=dBean.fmtDate(dBean.getFilter().getDateTo())%>"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeIdeEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeIdeEnt")%>:</td><td nowrap><input name="identPre" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeIdeEnt")%>" size=5 maxlength="50" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getIdentPre())%>"><input name="identNum" size=5 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeIdeEnt")%>" p_numeric="true" maxlength="9" type="text" value="<%=dBean.fmtInt(dBean.getFilter().getIdentNum())%>"><input name="identPost" size=5 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeIdeEnt")%>" maxlength="50" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getIdentPost())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeUsuCre")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeUsuCre")%>:</td><td><input type="text" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeUsuCre")%>" name="usrLoginCreated" value="<%= dBean.fmtStr(dBean.getFilter().getUsrLoginCreated()) %>"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMonEntFilCreFrom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonEntFilCreFrom")%>:</td><td><input name="dateCreatedFrom" p_calendar="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonEntFilCreFrom")%>" size="10" maxlength="10" type="text" class="txtDate" p_mask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" value="<%=dBean.fmtDate(dBean.getFilter().getDateCreatedFrom())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMonEntFilCreTo")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonEntFilCreTo")%>:</td><td><input name="dateCreatedTo" p_calendar="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonEntFilCreTo")%>" size="10" maxlength="10" type="text" class="txtDate" p_mask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" value="<%=dBean.fmtDate(dBean.getFilter().getDateCreatedTo())%>"></td></tr><tr><%
											   					boolean[] showAttValue = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false};
											   						   				if (CollectionUtil.notEmpty(dBean.getEntityAttributes())) {
											   											Iterator attributes = dBean.getEntityAttributes().iterator();
											   											AttributeVo att = null;
											   											int count = 0;
											   											int countStr = 0;
											   											int countNum = 0;
											   											int countDte = 0;
											   											int countIdStr = 0;
											   											int countIdNum = 0;
											   											int countIdDte = 0;
											   											boolean openTr = false;
											   											
											   											//for (int i = 0; i < showAttValue.length; i++) {
											   											//	showAttValue[i] = false;
											   											//}
											   											
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
											   														} 
											   														Collection<BusEntInstanceVo> attMapping = (Collection<BusEntInstanceVo>) dBean.getAttMapping().get(att.getAttId());
											   														String value = null; 
											   														switch(countIdStr) {
											   															case 1:
											   																value = dBean.getFilter().getAttValue1();
											   																break;
											   															case 2:
											   																value = dBean.getFilter().getAttValue2();
											   																break;
											   															case 3:
											   																value = dBean.getFilter().getAttValue3();
											   																break;
											   															case 4:
											   																value = dBean.getFilter().getAttValue4();
											   																break;
											   															case 5:
											   																value = dBean.getFilter().getAttValue5();
											   																break;
											   															case 6:
											   																value = dBean.getFilter().getAttValue6();
											   																break;
											   															case 7:
											   																value = dBean.getFilter().getAttValue7();
											   																break;													
											   															case 8:
											   																value = dBean.getFilter().getAttValue8();
											   																break;
											   															case 9:
											   																value = dBean.getFilter().getAttValue9();
											   																break;
											   															case 10:
											   																value = dBean.getFilter().getAttValue10();
											   																break;
											   														}
											   				%><td title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=dBean.fmtHTML(att.getAttLabel())%>:</td><td><%
													if (attMapping == null) {
												%><input type="text" name="txtFilAttVal<%=countIdStr%>" value="<%=dBean.fmtHTML(value)%>"><%
														} else {
													%><select name="txtFilAttVal<%=countIdStr%>"><option value=""></option><%
																for (BusEntInstanceVo instVo : attMapping) {
															%><option value="<%=instVo.getBusEntInstNameNum()%>" <%=biz.statum.sdk.util.StringUtil.toString(instVo.getBusEntInstNameNum()).equals(value) ? "selected" : ""%>><%=biz.statum.sdk.util.StringUtil.toString(instVo.getAttValueCmb(), biz.statum.sdk.util.StringUtil.toString(instVo.getBusEntInstNameNum()))%></option><%
																		}
																	%></select><%
															}
														%></td><%
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
																						} 
																						
																						Collection<BusEntInstanceVo> attMapping = (Collection<BusEntInstanceVo>) dBean.getAttMapping().get(att.getAttId());
																						
																						Integer value = null;
																						switch(countIdNum) {
																							case 1:
																								value = dBean.getFilter().getAttValueNum1();
																								break;
																							case 2:
																								value = dBean.getFilter().getAttValueNum2();
																								break;
																							case 3:
																								value = dBean.getFilter().getAttValueNum3();
																								break;
																							case 4:
																								value = dBean.getFilter().getAttValueNum4();
																								break;
																							case 5:
																								value = dBean.getFilter().getAttValueNum5();
																								break;
																							case 6:
																								value = dBean.getFilter().getAttValueNum6();
																								break;
																							case 7:
																								value = dBean.getFilter().getAttValueNum7();
																								break;
																							case 8:
																								value = dBean.getFilter().getAttValueNum8();
																								break;
																						}
												%><td title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=dBean.fmtHTML(att.getAttLabel())%>:</td><td><% if (attMapping == null) { %><input type="text" p_numeric="true" name="txtFilAttValNum<%=countIdNum%>" value="<%= dBean.fmtHTML(value) %>"><%
													} else { %><select name="txtFilAttValNum<%=countIdNum%>"><option value=""></option><%
																for (BusEntInstanceVo instVo : attMapping) { %><option value="<%= instVo.getBusEntInstNameNum() %>" <%= (value != null && value.equals(instVo.getBusEntInstNameNum())) ? "selected" : "" %>><%= biz.statum.sdk.util.StringUtil.toString(instVo.getAttValueCmb(), biz.statum.sdk.util.StringUtil.toString(instVo.getBusEntInstNameNum())) %></option><%
																}
															%></select><%
													} %></td><%
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
								} %></table></div><table class="tblFormLayout"><td></td><td width="100%" align="right"><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></table></DIV>
