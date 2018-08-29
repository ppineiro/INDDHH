
<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.labels.LabelManager"%><div class="gridContainer exec-tsk-mon"><div class="gridHeader"><table cellpadding="0" cellspacing="0" id="gridBodyFormEntHeader"><thead><tr class="header"><th width="200px" title="<system:label show="tooltip" label="lblMonTskPro" />"><div style="width: 200px"><system:label show="text" label="lblMonTskPro" /></div></th><th width="130px" title="<system:label show="tooltip" label="lblMonPoolNom" />"><div style="width: 130px"><system:label show="text" label="lblMonPoolNom" /></div></th><th width="130px" title="<system:label show="tooltip" label="lblMonProEleInstSta" />"><div style="width: 130px"><system:label show="text" label="lblMonProEleInstSta" /></div></th><th width="130px" title="<system:label show="tooltip" label="lblMonProEleInstDatRea" />"><div style="width: 130px"><system:label show="text" label="lblMonProEleInstDatRea" /></div></th><th width="130px" title="<system:label show="tooltip" label="lblMonProEleInstDatEnd" />"><div style="width: 130px"><system:label show="text" label="lblMonProEleInstDatEnd" /></div></th><th width="100px" title="<system:label show="tooltip" label="lblMonUsrLog" />"><div style="width: 100px"><system:label show="text" label="lblMonUsrLog" /></div></th></tr></thead></table></div><div class="gridBody" id="gridBodyFormEnt"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="200px"></th><th width="130px"></th><th width="130px"></th><th width="130px"></th><th width="130px"></th><th width="100px"></th></tr></thead><tbody class="tableData" id="tableDataFormEnt"><%
				Collection col = dBean.getProInstTasks(request);
				UserData userData = dBean.getUserData(new HttpServletRequestResponse(request,response)); 
				if (col != null) {
					java.util.Iterator it = col.iterator();
					int i = 0;
					com.dogma.vo.MonitorTaskVo mPITVo;
					Integer oldProEleInstId = null;
					while (it.hasNext()) {
						mPITVo = (com.dogma.vo.MonitorTaskVo) it.next(); 
						%><tr row_id="<%=mPITVo.getReqString()%>" row_for="<%=mPITVo.getMonFor()%>" <%if(i%2!=0){out.print(" class='trOdd' ");} %>><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><div style="width:200px;"><%=mPITVo.getTskTitle()%></div></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><div style="width:130px;"><%=mPITVo.getPoolName() != null ? mPITVo.getPoolName() : ""%></div></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%
								String label = 
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_WAITING.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaWai":
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_READY.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaRea":
									com.dogma.vo.ProEleInstHistoryVo.HTY_EVENT_RELEASE.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaRea":
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaAcq":
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaCom":
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_UNDO.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaRol":
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaCan":
									com.dogma.vo.ProInstanceVo.PROC_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaCan":												
									com.dogma.vo.ProInstanceVo.PROC_STATUS_FINALIZED.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaFin":												
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_SUSPENDED.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaSus":
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_ROLLBACK.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaRol":												
									com.dogma.vo.ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaSki":
									com.dogma.vo.ProEleInstHistoryVo.HTY_EVENT_DEALLOCATE.equals(mPITVo.getProEleInstStatus())?"lblMonProEleInstStaRea":"";
							%><div style="width:130px;"><%= LabelManager.getName(userData, label) %></div></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><div style="width:130px;"><%=mPITVo.getProEleInstDateReady()%></div></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><div style="width:130px;"><%=mPITVo.getProEleInstDateEnd() == null ? "" : mPITVo.getProEleInstDateEnd().toString() %></div></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><div style="width:100px;"><%=mPITVo.getUsrLogin() != null ? mPITVo.getUsrLogin() : ""%></div></td></tr><%
						i++;
					}
				}
				%></tbody></table></div></div>




  