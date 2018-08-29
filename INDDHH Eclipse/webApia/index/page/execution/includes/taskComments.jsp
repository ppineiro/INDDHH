
<%@page import="java.util.LinkedHashMap"%><%@page import="java.util.Collection"%><%@page import="java.util.HashMap"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><%@page import="com.dogma.vo.ProInstCommentVo"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.tag.TagUtils"%><%@page import="com.st.util.labels.LabelManager"%><div class="tabContent"><%
	Collection<ProInstCommentVo> comments = processBean.getComments();
	String comment_table = "";
	String current_comment = null;
	boolean current_comment_checked = false;
	
	String lblEjeUsu = LabelManager.getName(uData, "lblEjeUsu") + ": ";
	String lblEjeGruTar = LabelManager.getName(uData, "lblEjeGruTar") + ": ";
	String lblEjeTar = LabelManager.getName(uData, "lblEjeTar") + ": ";
	String img_src = TagUtils.getContext(new HttpServletRequestResponse(request, response)) + "/css/" + uData.getUserStyle() + "/img/alert.gif";
	
	if (comments != null) {
		
		Integer current_pro_ele_inst_id = null;
		biz.statum.apia.web.bean.BasicBean basicBean = null;
		biz.statum.apia.web.bean.execution.TaskBean tBean = null;
		
		if("true".equals(request.getAttribute("isTask"))) {
			basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_EXEC_NAME);
			if (basicBean != null && basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean) {
				tBean = (biz.statum.apia.web.bean.execution.TaskBean)basicBean;
				current_pro_ele_inst_id = tBean.getCurrentElement().getProEleInstId();
			}
		}
		
		LinkedHashMap<String, LinkedHashMap<Integer,ProInstCommentVo>> commentHash = new LinkedHashMap<String, LinkedHashMap<Integer,ProInstCommentVo>>();
		for(ProInstCommentVo comment : comments) {
			if(commentHash.containsKey(comment.getProInstCommGroupId())) {
				LinkedHashMap<Integer,ProInstCommentVo> commentGroup = commentHash.get(comment.getProInstCommGroupId());
				commentGroup.put(comment.getProInstCommGroupOrder(), comment);
			} else {				
				LinkedHashMap<Integer,ProInstCommentVo> commentGroup = new LinkedHashMap<Integer,ProInstCommentVo>();
				if(comment.getProInstCommGroupOrder() != null)
					commentGroup.put(comment.getProInstCommGroupOrder(), comment);
				else
					commentGroup.put(0, comment);
				
				String id = comment.getProInstCommGroupId();
				if(id==null){
					id = String.valueOf(new java.util.Date().getTime());					
				}
					
				commentHash.put(id, commentGroup);
			}
		}
		
		Collection<LinkedHashMap<Integer, ProInstCommentVo>> commentsGroup = commentHash.values(); //En el hash ya tienen apendeado los otros comentarios
		int iter = 0;
		boolean saltear = true;
		for(LinkedHashMap<Integer, ProInstCommentVo> commentGroup : commentsGroup){
			ProInstCommentVo comment = commentGroup.get(0);
			
			if(iter == 0 && (comment.getProEleInstId() == null || comment.getRegUser() == null || comment.getProEleInstId().equals(current_pro_ele_inst_id) && uData.getUserId().equals(comment.getRegUser()))) {
				if(current_comment == null) {
					current_comment = BeanUtils.fmtHTML(comment.getProInstComment());
					current_comment_checked = comment.getProInstCommFlag().intValue() == 1;
				}
			} else if(comment.getProEleInstId() != null && comment.getRegUser() != null){
				
				if(saltear && comment.getProEleInstId().equals(current_pro_ele_inst_id) && uData.getUserId().equals(comment.getRegUser())) {
					iter++;
					continue;
				}
				saltear = false;
				
				String value = "";
				String props = "";
				
				if(comment.getProInstCommFlag().intValue() == 1)
					value = "checked";				
				if("true".equals(request.getParameter("readOnly")))
					props = " disabled ";

				comment_table += "<tr class='head'>" +
					"<td><input type='checkbox' name='chkComment" + comment.getProInstComId() + "' " + value + " " + props + "></td>" +
					"<td><B>" + BeanUtils.fmtHTMLAMPM(comment.getRegDate()) + "</B></td>" +
					"<td title='" + BeanUtils.fmtHTML(comment.getUserId()) + "'>" + lblEjeUsu  + "<B>" + BeanUtils.fmtHTML(comment.getUserName()) + "</B></td>" +
					"<td title='"+ BeanUtils.fmtHTML(comment.getPoolDesc()) +"'>" + lblEjeGruTar + "<B>" + BeanUtils.fmtHTML(comment.getPoolName()) + "</B></td>" +
					"<td title='"+ BeanUtils.fmtHTML(comment.getTskName()) +"'>" + lblEjeTar + "<B>" + BeanUtils.fmtHTML(comment.getTskTitle()) + "</B></td>" +
				"</tr>" +
				"<tr class='trComment'>" +
					"<td>"; 
				
				if(comment.getProInstCommFlag().intValue() == 1 ) {
					commentsMarked = true;
					comment_table += "<img src='" + img_src + "' alt=''>";
				}
				
				String current_old_comment = "";
				for( int i = 0; i < commentGroup.size(); i++)
					current_old_comment += BeanUtils.fmtHTML(commentGroup.get(i).getProInstComment());
				
				comment_table += "</td>" +
					"<td colspan=4 >"+ BeanUtils.fmtHTML(current_old_comment) + "</td>" +
				"</tr>";
			}
			
			iter++;
		}
	}
	if(current_comment == null)
		current_comment = "";
	
	if (! "true".equals(request.getParameter("readOnly"))) { %><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEjeObsAct" /></div><div class="fieldCommentLeft"><div class="field fieldComment"><label title="<system:label show="tooltip" label="lblEjeObs" />"><system:label show="text" label="lblEjeObs" />:</label><textarea id="txtComment" name="txtComment" ><%=current_comment%></textarea></div></div><div class="fieldCommentRight"><div class="field"><label title="<system:label show="tooltip" label="lblEjeAgrMar" />"><system:label show="text" label="lblEjeAgrMar" />:</label><input type=checkbox name=chkAddAlert <%=current_comment_checked ? "checked=\"checked\"" : "" %> /></div><div class="field"><label title="<system:label show="tooltip" label="lblEjeAgrMarTod" />"><system:label show="text" label="lblEjeAgrMarTod" />:</label><input type=checkbox id=chkAddAllAlert name=chkAddAllAlert onchange="alertAll(this)"></div><div class="field"><label title="<system:label show="tooltip" label="lblEjeEliMar" />"><system:label show="text" label="lblEjeEliMar" />:</label><input type=checkbox id=chkRemAlert name=chkRemAlert onchange="alertRemove(this)"></div></div></div><%} %><% if (comments != null) { %><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEjeObs" /></div><table id="tblComment" class="tblComment"><tbody><%=comment_table%></tbody></table></div><% } %><script type="text/javascript">
	
	function greet() {
		alert("Hola");
	}
	
	
	function appendComment(pro_inst_comm_id, checked, regdate, username, poolname, taskname, txt) {
		var tbody = $('tblComment').getElement('tbody');
		
		var trHead = new Element('tr.head', {
			html: "<td><input type='checkbox' name='chkComment" + pro_inst_comm_id + "' " + (checked ? "checked" : "") + "></td>" +
			"<td><b>" + regdate + "</b></td>" +
			"<td title='" + username + "'><%=lblEjeUsu%><b>" + username + "</b></td>" +
			"<td><%=lblEjeGruTar%><b>" + poolname + "</b></td>" +
			"<td><%=lblEjeTar%><b>" + ( taskname ? taskname : CURRENT_TASK_NAME ) + "</b></td>"
		});
		
		if(tbody.getChildren() && tbody.getChildren().length) {
			trHead.inject(tbody.getElement('tr'), 'before');
		} else {
			trHead.inject(tbody);
		}
		
		new Element('tr.trComment', {
			html: "<td>" + ( checked ? "<img src='<%=img_src%>' alt=''>" : "") + "</td><td colspan=4>" + txt + "</td>"
		}).inject(trHead, 'after');
		
	} 
	
	function replaceComment(txt) {
		$('txtComment').set('value', txt)
	}
	
	</script></div>	