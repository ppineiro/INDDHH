
<%@page import="java.util.LinkedHashMap"%><%@page import="java.util.Collection"%><%@page import="java.util.HashMap"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><%@page import="com.dogma.vo.BusEntInstCommentVo"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.tag.TagUtils"%><%@page import="com.st.util.labels.LabelManager"%><div class="tabContent"><%
	Collection<BusEntInstCommentVo> comments = dBean.getComments();
	String comment_table = "";
	String current_comment = null;
	boolean IS_READONLY = "true".equals(request.getParameter("fromEntQuery"))
				|| "true".equals(request.getAttribute("isMonitor"));
	
	String lblEjeUsu = LabelManager.getName(uData, "lblEjeUsu") + ": ";
	String img_src = TagUtils.getContext(new HttpServletRequestResponse(request, response)) + "/css/" + uData.getUserStyle() + "/img/alert.gif";
	
	if (comments != null) {		
		Integer current_bus_ent_ins_id = null;
		biz.statum.apia.web.bean.BasicBean basicBean = null;
		biz.statum.apia.web.bean.execution.TaskBean tBean = null;
		
		if("false".equals(request.getAttribute("isTask"))) {
			basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_EXEC_NAME);
			if (basicBean != null && basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean) {
				tBean = (biz.statum.apia.web.bean.execution.TaskBean)basicBean;
				current_bus_ent_ins_id = tBean.getCurrentElement().getProEleInstId();
			}
		}		
		
		for(BusEntInstCommentVo comment : comments){				
			String value = "";
			String props = "";
			
			if("1".equals(comment.getBusEntInstCommFlag()))
				value = "checked";				
			if("true".equals(request.getParameter("readOnly")))
				props = " disabled ";

			comment_table += "<tr class='head'>" +
				"<td><input type='checkbox' " + (IS_READONLY?"disabled":"") + " name='chkComment" + comment.getBusEntInstComId() + "' " + value + " " + props + "></td>" +
				"<td><B>" + BeanUtils.fmtHTMLAMPM(comment.getRegDate()) + "</B></td>" +
				"<td title='" + BeanUtils.fmtHTML(comment.getRegUser()) + "'>" + lblEjeUsu  + "<B>" + BeanUtils.fmtHTML(comment.getUsrLogin()) + "</B></td>" +
			"</tr>" +
			"<tr class='trComment'>" +
				"<td>"; 
			
			if("1".equals(comment.getBusEntInstCommFlag())) {
				commentsMarked = true;
				comment_table += "<img src='" + img_src + "' alt=''>";
			}
			
			comment_table += "</td>" +
				"<td colspan=4 >"+ BeanUtils.fmtHTML(comment.getBusEntInstComment()) + "</td>" +
			"</tr>";	
		}
	}
	if(current_comment == null)
		current_comment = "";
	
	if (! IS_READONLY ) { %><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEjeEntComAct" /></div><div class="fieldCommentLeft"><div class="field fieldComment"><label title="<system:label show="tooltip" label="lblEjeEntCom" />"><system:label show="text" label="lblEjeEntCom" />:</label><textarea id="txtComment" name="txtComment" ><%=current_comment%></textarea></div></div><div class="fieldCommentRight"><div class="field"><label title="<system:label show="tooltip" label="lblEjeAgrMar" />"><system:label show="text" label="lblEjeAgrMar" />:</label><input type=checkbox name=chkAddAlert></div><div class="field"><label title="<system:label show="tooltip" label="lblEjeAgrMarTod" />"><system:label show="text" label="lblEjeAgrMarTod" />:</label><input type=checkbox id=chkAddAllAlert name=chkAddAllAlert onchange="alertAll(this)"></div><div class="field"><label title="<system:label show="tooltip" label="lblEjeEliMar" />"><system:label show="text" label="lblEjeEliMar" />:</label><input type=checkbox id=chkRemAlert name=chkRemAlert onchange="alertRemove(this)"></div></div></div><%} %><% if (comments != null) { %><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEjeEntCom" /></div><table id="tblComment" class="tblComment"><tbody><%=comment_table%></tbody></table></div><% } %></div>	