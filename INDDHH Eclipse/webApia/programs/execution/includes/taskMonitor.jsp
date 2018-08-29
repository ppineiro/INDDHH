<DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMonTsk")%></DIV><div type="grid" id="gridList" style="HEIGHT:<%= Parameters.FILTER_LIST_SIZE+300%>px"><table width="900px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:200px" title="<%=LabelManager.getToolTip(labelSet,"lblMonTskPro")%>"><%=LabelManager.getName(labelSet,"lblMonTskPro")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonPoolNom")%>"><%=LabelManager.getName(labelSet,"lblMonPoolNom")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstSta")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstSta")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatRea")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatRea")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatEnd")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatEnd")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonUsrLog")%>"><%=LabelManager.getName(labelSet,"lblMonUsrLog")%></th><th></th></tr></thead><tbody><%
							Collection col = dBean.getProInstTasks(request);
							if (col != null) {
								java.util.Iterator it = col.iterator();
								int i = 0;
								com.dogma.vo.MonitorTaskVo mPITVo;
								Integer oldProEleInstId = null;
								while (it.hasNext()) {
									mPITVo = (com.dogma.vo.MonitorTaskVo) it.next(); 
									%><tr onclick="validateTask()" row_id="<%=dBean.fmtStr(mPITVo.getReqString())%>" row_for="<%=dBean.fmtStr(mPITVo.getMonFor())%>" id=LIST><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getTskTitle())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getPoolName())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_WAITING.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaWai"):
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_READY.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):
											com.dogma.vo.ProEleInstHistoryVo.HTY_EVENT_RELEASE.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaAcq"):
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCom"):
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_UNDO.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRol"):
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCan"):
											com.dogma.vo.ProInstanceVo.PROC_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCan"):												
											com.dogma.vo.ProInstanceVo.PROC_STATUS_FINALIZED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaFin"):												
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_SUSPENDED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaSus"):
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_ROLLBACK.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRol"):												
											com.dogma.vo.ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaSki"):
											com.dogma.vo.ProEleInstHistoryVo.HTY_EVENT_DEALLOCATE.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):""
										%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateReady())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateEnd())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getUsrLogin())%></td></tr><%
									i++;
								}
							}
							%></tbody></table></div><%
dBean.setFormHasBeenDrawed(true);
%>				