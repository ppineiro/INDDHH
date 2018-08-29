<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.vo.custom.ProToCancelVo"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.ProStartBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeProCan")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtEjeFil")%></td><td align="right"><button id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><div id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblProTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblProTit")%>:</td><td><input name="txtProTitle" maxlength="50" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getProTitle())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblProTit")%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMonProAct")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonProAct")%></td><td><select name="cmbAct" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonProAct")%>"><option value=""></option><option value="<%=ProcessVo.PROCESS_ACTION_CREATION%>" <%=ProcessVo.PROCESS_ACTION_CREATION.equals(dBean.getFilter().getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonProActCre")%></option><%if (envUsesEntities) {%><option value="<%=ProcessVo.PROCESS_ACTION_ALTERATION%>" <%=ProcessVo.PROCESS_ACTION_ALTERATION.equals(dBean.getFilter().getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonProActAlt")%></option><%}%><option value="<%=ProcessVo.PROCESS_ACTION_CANCEL%>" <%=ProcessVo.PROCESS_ACTION_CANCEL.equals(dBean.getFilter().getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonProActCan")%></option></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProAct")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProAct")%>:</td><td><select name="cmbBackLog" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProAct")%>"><option value=""></option><option value="<%=ProStartFilterVo.ESTADO_ACTIVIDAD_ATRASADO%>" <%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_ATRASADO.equals(dBean.getFilter().getProInstBackLog())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonInstProActAtr")%></option><option value="<%=ProStartFilterVo.ESTADO_ACTIVIDAD_ALARMA%>" <%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_ALARMA.equals(dBean.getFilter().getProInstBackLog())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonInstProActAla")%></option><option value="<%=ProStartFilterVo.ESTADO_ACTIVIDAD_EN_FECHA%>" <%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_EN_FECHA.equals(dBean.getFilter().getProInstBackLog())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonInstProActEnFec")%></option></select></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProCreUsu")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProCreUsu")%>:</td><td><input name="txtInstUser" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProCreUsu")%>" maxlength="50" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getProUser())%>"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProNroReg")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProNroReg")%>:</td><td><input name="txtNamPre" maxlength="50" size="5" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProNroReg")%>" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getProInstNamePre())%>"><input name="txtNamNum" maxlength="11" size="7" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProNroReg")%>" type="text" value="<%=dBean.fmtInt(dBean.getFilter().getProInstNameNum())%>" class="txtNumeric"><input name="txtNamPos" maxlength="50" size="5"accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProNroReg")%>" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getProInstNamePos())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProCreDatEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProCreDatEnt")%>:</td><td><input name="txtStaSta" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProCreDatEnt")%>" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" type="text" value="<%=dBean.fmtDate(dBean.getFilter().getProStartFrom())%>">
		   							-
			   						<input name="txtStaEnd" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProCreDatEnt")%>" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" type="text" value="<%=dBean.fmtDate(dBean.getFilter().getProStartTo())%>"></td></tr><%
						BusEntityVo busEntityVo = dBean.getBusEntityVo();
						if (busEntityVo.getBusEntAttributes() != null) {
							boolean[] showAttValue = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true};
							Iterator attributes = busEntityVo.getBusEntAttributes().iterator();
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
										} %><td title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=dBean.fmtHTML(att.getAttLabel())%>:</td><td><input type="text" name="txtFilEntInstAttVal<%=countIdStr%>" value="<%
											switch(countIdStr) {
												case 1:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue1()));
													break;
												case 2:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue2()));
													break;
												case 3:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue3()));
													break;
												case 4:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue4()));
													break;
												case 5:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue5()));
													break;
												case 6:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue6()));
													break;
												case 7:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue7()));
													break;													
												case 8:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue8()));
													break;
												case 9:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue9()));
													break;
												case 10:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValue10()));
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
										} %><td title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=dBean.fmtHTML(att.getAttLabel())%>:</td><td><input type="text" p_numeric="true" name="txtFilEntInstAttValNum<%=countIdNum%>" value="<%
											switch(countIdNum) {
												case 1:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueNum1()));
													break;
												case 2:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueNum2()));
													break;
												case 3:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueNum3()));
													break;
												case 4:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueNum4()));
													break;
												case 5:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueNum5()));
													break;
												case 6:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueNum6()));
													break;
												case 7:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueNum7()));
													break;
												case 8:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueNum8()));
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
										} %><td title="<%=dBean.fmtHTML(att.getAttDesc())%>"><%=dBean.fmtHTML(att.getAttLabel())%>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilEntInstAttValDte<%=countIdDte%>I" value="<%
											switch(countIdDte) {
												case 1:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte1I()));
													break;
												case 2:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte2I()));
													break;
												case 3:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte3I()));
													break;
												case 4:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte4I()));
													break;
												case 5:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte5I()));
													break;
												case 6:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte6I()));
													break;
											} %>">
											-
											<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilEntInstAttValDte<%=countIdDte%>F" value="<%
											switch(countIdDte) {
												case 1:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte1F()));
													break;
												case 2:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte2F()));
													break;
												case 3:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte3F()));
													break;
												case 4:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte4F()));
													break;
												case 5:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte5F()));
													break;
												case 6:
													out.print(dBean.fmtHTML(dBean.getFilter().getEntInstAttValueDte6F()));
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
						} %><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt1Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt1Pro") %>:</td><td><input type="text" name="txtFilProInstAttVal1" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt1Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValue1())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt2Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt2Pro") %>:</td><td><input type="text" name="txtFilProInstAttVal2" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt2Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValue2())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt3Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt3Pro") %>:</td><td><input type="text" name="txtFilProInstAttVal3" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt3Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValue3())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt4Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt4Pro") %>:</td><td><input type="text" name="txtFilProInstAttVal4" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt4Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValue4())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAtt5Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAtt5Pro") %>:</td><td><input type="text" name="txtFilProInstAttVal5" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAtt5Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValue5())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum1Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum1Pro") %>:</td><td><input type="text" name="txtFilProInstAttValNum1" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum1Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueNum1())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum2Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum2Pro") %>:</td><td><input type="text" name="txtFilProInstAttValNum2" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum2Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueNum2())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttNum3Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttNum3Pro") %>:</td><td><input type="text" name="txtFilProInstAttValNum3" p_numeric="true" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttNum3Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueNum3())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte1Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte1Pro") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilProInstAttValDte1I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte1Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueDte1I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilProInstAttValDte1F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte1Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueDte1F())%>"></td><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte2Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte2Pro") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilProInstAttValDte2I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte2Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueDte2I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilProInstAttValDte2F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte2Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueDte2F())%>"></td></tr><tr><td title="<%= LabelManager.getToolTip(labelSet,"lblAttDte3Pro") %>"><%= LabelManager.getNameWAccess(labelSet,"lblAttDte3Pro") %>:</td><td><input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilProInstAttValDte3I" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte3Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueDte3I())%>">
		   							-
		   							<input type="text" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" name="txtFilProInstAttValDte3F" accesskey="<%= LabelManager.getAccessKey(labelSet,"lblAttDte3Pro") %>" value="<%= dBean.fmtHTML(dBean.getFilter().getProInstAttValueDte3F())%>"></td></tr></table></div><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td colspan=3 align="left"><button onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></tr></table></DIV><!--     ---------------------------------------------               --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeRes")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table class="tblDataGrid"><thead><tr><th style="width:0px;display:none;">&nbsp;</th><th style="width:140px" title="<%=LabelManager.getToolTip(labelSet,"lblEjeIdeEnt")%>"><%=LabelManager.getName(labelSet,"lblEjeIdeEnt")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblEjeIdePro")%>"><%=LabelManager.getName(labelSet,"lblEjeIdePro")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblProTit")%>"><%=LabelManager.getName(labelSet,"lblEjeProName")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblEjeUsuCreProTar")%>"><%=LabelManager.getName(labelSet,"lblEjeUsuCreProTar")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblEjeFecCrePro")%>"><%=LabelManager.getName(labelSet,"lblEjeFecCrePro")%></th></tr></thead><tbody><%	Collection col = dBean.getList();
							if (col != null) {
								Iterator it = col.iterator();
							int i = 0;
								ProToCancelVo consVo = null;
								while (it.hasNext()) {
									consVo = (ProToCancelVo) it.next();%><tr proInstCancelId="<%=consVo.getProInstId()%>" proInstCancelAction="<%=dBean.fmtStr(consVo.getProAction())%>"><td style="width:0px;display:none;"><input type="hidden" id="chkSel<%=i%>" name="chkSel<%=i%>"><input type="hidden" id="idSel" name="txtEntId<%=i%>" value="<%=dBean.fmtInt(consVo.getBusEntInstId())%>"></td><td><%=dBean.fmtHTML(consVo.getEntityIdentification())%></td><td><%=dBean.fmtHTML(consVo.getProcessIdentification())%></td><td><%=dBean.fmtHTML(consVo.getProTitle())%></td><td><%=dBean.fmtHTML(consVo.getProUserName())%></td><td><%=dBean.fmtHTMLTime(consVo.getProInstCreateDate())%></td></tr><%i++;%><%}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><%@include file="../../includes/navButtons.jsp" %><td><button type="button" onclick="btnCancel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCanPro")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCanPro")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCanPro")%></button></td></tr></table><input type=hidden name="txtProId" value="<%=dBean.getTxtProId()%>"><input type=hidden name="txtBusEntId" value="<%=dBean.getBusEntId()%>"><input type=hidden name="proInstCancelId" value=""><input type=hidden name="proInstCancelAction" value=""></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/execution/proStart/proCancel.js"></script><%@include file="../../../components/scripts/server/endInc.jsp" %>