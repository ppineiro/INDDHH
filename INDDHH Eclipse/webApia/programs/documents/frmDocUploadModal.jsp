<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.DocumentBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><%
	DogmaAbstractBean aBean = (DogmaAbstractBean)session.getAttribute("dBean");
	if(session.getAttribute("xBean") != null){
		aBean = (DogmaAbstractBean)session.getAttribute("xBean");
	}
	//find bean
	com.dogma.bean.execution.FormBean fBean = aBean.getFormBean(request);
	System.out.print(fBean);
	DocumentVo docVo = fBean.getSelectedDocument();
	Collection colDocHis = fBean.getDocumentHistory(request);
	String index = request.getParameter("index");
%><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDoc")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"  target="ifrUno" action="execution.FormAction.do?action=confirmDoc&frmParent=<%=request.getParameter("frmParent")%>&inModal=<%=(fBean.isPopulateGrid()||fBean.inModal)%>&frmId=<%=fBean.getFormId()%>&attId=<%=request.getParameter("attId")%>&docId=<%=docVo.getDocId()%>&index=<%=index%>" enctype="multipart/form-data"><%if (docVo != null) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocInfo")%></DIV><input type=hidden id=docId value="<%=fBean.fmtInt(docVo.getDocId())%>"><input type=hidden id=docName value="<%=fBean.fmtStr(docVo.getDocName())%>"><input type=hidden name=frmParent value="<%=request.getParameter("frmParent")%>"><table class="tblFormLayout"><%if (docVo.getDocName() != null) {%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocAct")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocAct")%>:</td><td colspan=3><%=fBean.fmtHTML(docVo.getDocName())%></td></tr><%}%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNueDoc")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNueDoc")%>:</td><td colspan=3><input style="width:340px" type="FILE" accesskey="<%=LabelManager.getToolTip(labelSet,"lblNueDoc")%>" <%if (docVo.getDocName() == null) {%>p_required="true"<%}%> name="fileName" size="35" ></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><textarea style="height:50px;width:340px" name="txtDesc" p_maxlength="true" maxlength="255" cols=60 rows=4 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>"><%=fBean.fmtStr(docVo.getDocDesc())%></textarea></td></tr></table><%if (colDocHis != null && colDocHis.size()>0)  {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocVer")%></DIV><div type="grid" id="sa" style="height:105px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:60px" title="<%=LabelManager.getToolTip(labelSet,"lblVer")%>"><%=LabelManager.getName(labelSet,"lblVer")%></th><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblUsu")%></th><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblTam")%>"><%=LabelManager.getName(labelSet,"lblFec")%></th></tr></thead><tbody  id="TBbody"><%if (colDocHis != null)  {
						Iterator it = colDocHis.iterator();
						int i=colDocHis.size();
						int j=0;
						while (it.hasNext()) {
							DocVersionVo docVerVo = (DocVersionVo) it.next();
							%><tr <%if (i%2==0){%>class=trOdd<%}%>><td align=right><input type=checkbox style="visibility:hidden"><A href="#nowhere" onclick="downloadDocument('<%=fBean.fmtInt(docVo.getDocId())%>',<%=j%>)"><%=i%></A></td><td><%=fBean.fmtHTML(docVerVo.getUsrLogin())%></td><td><%=fBean.fmtHTMLTime(docVerVo.getDocDate())%></td></tr><% 
							i--;
							j++;
						}
					}%></tbody></table></div><%}%><DIV class="subTit" <%if("true".equals(request.getParameter("hidePermissions"))){out.print(" style=\"display:none\" ");}%>><%=LabelManager.getName(labelSet,"sbtPerAccDoc")%></DIV><div style="height:120px;<%if("true".equals(request.getParameter("hidePermissions"))){out.print("display:none");}%>" type="grid" id="docGrid"><table width="500px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>">&nbsp;</th><th style="width:50px">&nbsp;</th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblPer")%>"><%=LabelManager.getName(labelSet,"lblPer")%></th></tr></thead><tbody class="scrollContent"><tr cantDelete="true"><td style="width:0px;display:none;" align="center"><input type='hidden' style='visibility:hidden;'><input type='hidden'></td><td align="center"><div style="width:18px; height:18px;"></div></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTod")%>"><%=LabelManager.getName(labelSet,"lblTod")%></td><td><input name="chkAllowRead" 	 type=checkbox <%if (docVo.getDocAllowAll()!=null && !DocPermissionVo.DOC_PER_TYPE_NONE.equals(docVo.getDocAllowAll()) ) {%> checked <%}%> ><%=LabelManager.getName(labelSet,"lblPerVer")%><input name="chkAllowModify" onclick="if (this.checked) { document.getElementById('chkAllowRead').checked=1}" type=checkbox <%if (DocPermissionVo.DOC_PER_TYPE_MODIFY.equals(docVo.getDocAllowAll())) {%> checked <%}%>><%=LabelManager.getName(labelSet,"lblPerMod")%></td></tr><%if  (docVo.getDocPermissions() != null) {
								Iterator it = docVo.getDocPermissions().iterator();
								String strVal = "";
								String strDesc = "";
								String strRad = "";
								String strImage = "";
								int i=0;				
								while (it.hasNext()) {
									i++;
									DocPermissionVo docPerVo = (DocPermissionVo) it.next();
									if (docPerVo.getUsrLogin() != null) {
										//strImage="<img src='" + com.dogma.Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/user.gif'>";
										strImage="<div style='width:18px; height:18px; background-image:url(" + com.dogma.Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/user.gif);background-repeat:no-repeat;'></div>";
										strVal = StringUtil.encodeString(new String[] {docPerVo.getUsrLogin(), docPerVo.getUsrName()}) ;
										strDesc = docPerVo.getUsrName();
										strRad = "usu";
									} else if (docPerVo.getPoolId() != null) {
										//strImage="<img src='" + com.dogma.Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/pool.gif'>";
										strImage="<div style='width:18px; height:18px; background-image:url(" + com.dogma.Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/pool.gif);background-repeat:no-repeat;'></div>";
										strVal = StringUtil.encodeString(new String[] {docPerVo.getPoolId().toString(), docPerVo.getPoolName()});
										strDesc = docPerVo.getPoolName();
										strRad = "grp";
									}
									%><tr style="100%"><td style="width:0px;display:none;" align="center"><input type='checkbox' name='chkPoolSel'><input type='hidden' name='chkPool' value="<%=strVal%>"></td><td align="center"><%=strImage%></td><td><%=aBean.fmtHTML(strDesc)%></td><td><input type=radio id="rad<%=i%>" name="<%=strRad + i%>" value="<%=DocPermissionVo.DOC_PER_TYPE_READ + strVal%>" <%if (DocPermissionVo.DOC_PER_TYPE_READ.equals(docPerVo.getDocPerType())){%> checked <%}%>><%=aBean.fmtHTML(LabelManager.getName(labelSet,"lblPerVer"))%><input type=radio id="rad<%=i%>" name="<%=strRad + i%>" value="<%=DocPermissionVo.DOC_PER_TYPE_MODIFY + strVal%>" <%if (DocPermissionVo.DOC_PER_TYPE_MODIFY.equals(docPerVo.getDocPerType())){%> checked <%}%>><%=aBean.fmtHTML(LabelManager.getName(labelSet,"lblPerMod"))%></td></tr><%
								}
							}%></tbody></table></div><table class="navBar" id="navBar" <%if("true".equals(request.getParameter("hidePermissions"))){out.print(" style=\"display:none\" ");}%>><COL class="col2"><tr><td><button type="button" type="button" onclick="btnAddPool_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgrGru")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgrGru")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgrGru")%></button><button type="button" type="button" onclick="btnAddUsr_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgrUsu")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgrUsu")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgrUsu")%></button><button type="button" type="button" onclick="btnDel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></form><iframe name=ifrUno src="" style="visibility:hidden;height:0px;width:0px;"></iframe><%}%><iframe name="iframeMessagesvvv" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" class="feedBackFrame" frameborder="no" style="display:none;" ></iframe></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><%if (docVo != null) {%><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><%} //document != null%><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><div id="isOpen" style="display:none" isOpen="true"></div></body></html><%@include file="../../components/scripts/server/endModalInc.jsp" %><script language="javascript">

function btnExit_click() {
	window.close();
}
</script><SCRIPT>

function btnAddPool_click() {
	var rets = openModal("/programs/modals/pools.jsp?showAutogenerated=false&showOnlyEnv=true&envId=" + <%=docVo.getEnvId()%> + "&showGlobal=true",500,350);
	rets.onclose=function(){
		addObject(rets.returnValue,false);
	}
}

function btnAddUsr_click() {
	var rets = openModal("/programs/modals/users.jsp?environment=all",500,300);
	rets.onclose=function(){
		addObject(rets.returnValue,true);
	}
}

var intPermissions = 100000;

function addObject(rets, isUser) {
	if (rets != null) {
		for (j = 0; j < rets.length; j++) {
			var ret = rets[j];
			var addRet = true;

			trows=document.getElementById("docGrid").rows;
			for (i=1;i<trows.length && addRet;i++) {
				var td=trows[i].cells[0];
				var obj=td.getElementsByTagName("INPUT")[0];
				if(obj.type=="hidden"){
					obj=td.getElementsByTagName("INPUT")[1];
				}
				if (obj.name.indexOf("Pool")>0 && obj.value.indexOf(ret[0]) == 0) {
					addRet = false;
				}
			}
			if (addRet) {
				var tr=trows[0].cloneNode(true);
				tr.setAttribute("cantDelete","");
				var tds=tr.getElementsByTagName("TD");
				var oTd0 = tds[0]; 
				var oTd1 = tds[1]; 
				var oTd2 = tds[2]; 
				var oTd3 = tds[3];
				oTd0.getElementsByTagName("INPUT")[0].style.visibility="visible";
				oTd0.getElementsByTagName("INPUT")[0].value = ret[0];
				if (isUser) {
					oTd1.getElementsByTagName("DIV")[0].style.backgroundImage=("url(" + URL_STYLE_PATH+ "/images/user.gif)");
					oTd1.getElementsByTagName("DIV")[0].style.backgroundRepeat="no-repeat";
					oTd2.innerHTML = ret[1];
				} else {
					oTd1.getElementsByTagName("DIV")[0].style.backgroundImage=("url(" + URL_STYLE_PATH+ "/images/pool.gif)");
					oTd1.getElementsByTagName("DIV")[0].style.backgroundRepeat="no-repeat";
					oTd2.innerHTML = ret[1];
				}
				var rType;
				if (isUser) {
					rType = "usu";
				} else {
					rType = "grp";
				}
		
				rValue = new Array();
				rValue[0] = ret[0];
				rValue[1] = ret[1];
		
				var str = "<input type=radio id='rad" + intPermissions + "' name='" + rType;
				str += intPermissions+"'><%=aBean.fmtScriptStr(LabelManager.getName(labelSet,"lblPerVer"))%><input type=radio id='rad" + intPermissions + "' name='" + rType; 
				str += intPermissions+"' checked><%=aBean.fmtScriptStr(LabelManager.getName(labelSet,"lblPerMod"))%>";
				
				oTd3.innerHTML = str;
				oTd3.childNodes[0].value="<%=DocPermissionVo.DOC_PER_TYPE_READ%>" + encodeStr(rValue);
				oTd3.childNodes[2].value="<%=DocPermissionVo.DOC_PER_TYPE_MODIFY%>" + encodeStr(rValue);
				
				var oTr = document.createElement("TR");
				oTr.appendChild(oTd0);
				oTr.appendChild(oTd1);
				oTr.appendChild(oTd2);
				oTr.appendChild(oTd3);
				document.getElementById("docGrid").addRow(oTr);
				document.getElementById("docGrid").updateScroll();
				intPermissions++;
			}
		}
	}		
}


function btnDel_click() {
	var oRows=document.getElementById("docGrid").selectedItems;
	for(var i=(oRows.length-1);(i>=0);i--){
		if(oRows[i].getAttribute("cantDelete")!="true"){
			oRows[i].parentNode.removeChild(oRows[i]);
			document.getElementById("docGrid").updateScroll();
		}
		oRows[i].style.height="0px";
	}
}

function btnConf_click() {
	if (document.getElementById("docName").value != "" &&
		document.getElementById("fileName").value != "") {
		if (document.getElementById("fileName").value.length != (document.getElementById("fileName").value.lastIndexOf(document.getElementById("docName").value) + document.getElementById("docName").value.length)) {
			alert("<%=fBean.fmtScriptStr(LabelManager.getName(labelSet,com.dogma.document.DocumentException.DOC_SAME_NAME))%>");
			
			return;
			
		}
	} else if (!verifyRequiredObjects()) {
			return;
	}
	submitFormModal(document.getElementById("frmMain"));
}

function downloadDocument (docId, version) {
	document.getElementById("ifrUno").src = "execution.FormAction.do?action=download&docId="+docId+"&version="+version+"&frmId=<%=request.getParameter("frmId")%>&frmParent=<%=request.getParameter("frmParent")%>";
}

function submitOK() {
	window.close();
}
</SCRIPT>