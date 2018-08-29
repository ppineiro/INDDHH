<%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %><script language="javascript" defer="true" src="../../../../scripts/feedBackFrame.js"></script></head><jsp:useBean id="dBeanModal" scope="session" class="com.dogma.bean.query.ModalBean"><% dBeanModal.initEnv(request); %></jsp:useBean><%
dBeanModal.initEnv(request);
QueryVo queryVo = dBeanModal.getQueryVo();
Collection filterColumns = queryVo.getFilters();
%><body onLoad="<% if (! queryVo.getFlagValue(QueryVo.FLAG_DONT_EXECUTE_FIRST)) { %>btnSearch_click();<%} if(queryVo.getFlagValue(QueryVo.FLAG_DONT_EXECUTE_FIRST) || queryVo.getFlagValue(QueryVo.FLAG_FILTER_OPEN)) {%>toggleFilter()<% }%>"  ><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titQry")%>: <%=(queryVo.getQryId().intValue()<1000)?LabelManager.getName(labelSet,queryVo.getQryTitle()):dBeanModal.fmtHTML(queryVo.getQryTitle())%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><% int toRemove = 130;
			if (filterColumns.size() > 0) {%><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="btnToggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection()"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><div id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%=Parameters.FILTER_LIST_SIZE%>px;"><table class="tblFormLayout" style="width:100%;"><COL width="15%"><COL  width="35%"><COL  width="15%"><COL width="35%"><%@include file="modalFilterQuerySection.jsp" %></table></DIV></div><% toRemove = 160;
			} %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div type="grid" fastGrid="true" id="gridList" style="height:<%= Parameters.FORM_QRY_MODAL_HEIGHT - toRemove %>px"  multiSelect="false" onselect="enableConfirm()"><table class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><%
					   			if (!dBeanModal.getQueryVo().getHasIncrement()) {
					   				Iterator header = dBeanModal.getQueryVo().getShowColumns().iterator();
						   			QryColumnVo columnVo = null;
						   			int xCount = 0;
						   			while (header.hasNext()) {
						   				columnVo = (QryColumnVo) header.next(); 
						   				
										//El comportamiento aca es el siguiente:
										// - si hay mas de cuatro columnas, se respeta siempre el tamaño definido por el usuario
										// - si hay menos de tres columnas, se respeta el tamaño de las columnas, 
										//   a exepcion de la ultima que toma el 100%
							   				
						   				String strWidth = "";
						   				if(dBeanModal.getQueryVo().getShowColumns().size() > 4) {
						   					strWidth = "style=\"width:" + columnVo.getQryColWidth().toString() + "px\"";
						   				} else {
						   					if(xCount == (dBeanModal.getQueryVo().getShowColumns().size() -1 )) {
						   						strWidth = "style='width:100%'";
						   					} else {
							   					strWidth = "style=\"width:" + columnVo.getQryColWidth().toString() + "px\"";
						   					}
						   				}
						   				xCount++;
						   				%><th <%=columnVo.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN)?"style=\"display:none;\"":strWidth%> title="<%=dBeanModal.fmtHTML(columnVo.getQryColTooltip())%>"><%=dBeanModal.fmtHTML(columnVo.getQryColHeadName())%></th><%
						   			}
						   		} else {
						   			Collection allShowCols = dBeanModal.getModalShowColumns();
						   			if (allShowCols != null && allShowCols.size() > 0) {
						   				Iterator header = allShowCols.iterator();
						   				while (header.hasNext()) {
						   					String colName = (String)header.next();
							   				//String strWidth = "style=\"width:100px\"";
							   				%><th title="<%=dBeanModal.fmtHTML(colName)%>"><%=dBeanModal.fmtHTML(colName)%></th><%
						   				}
						   			}
						   		} %></tr></thead><tbody ></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD><button type="button" onclick="btnSearch_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></TD><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" id="btnConf" disabled onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
var selected = null;

function clickChk(element) {
	if (selected != null) selected.checked = false;
	selected = element;
}

function callEventOnChange(filter) {
	document.getElementById("frmMain").action = "query.ModalAction.do?action=eventOnChange&&inModal=<%= request.getParameter(DogmaConstants.IN_MODAL) %>&filter=" + filter;
	submitForm(document.getElementById("frmMain"));
}

function btnConf_click() {
	window.parent.returnValue=getSelected();
	window.parent.close();
}	

function btnSearch_click(){
	var win=window;
	while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
		win=win.parent;
	}
	win.document.getElementById("iframeMessages").showResultFrame(document.body);
	if(document.readyState == "complete" || (window.navigator.appVersion.indexOf("MSIE")<0)){
		if(document.getElementById("listFilterArea") && document.getElementById("listFilterArea").style.display!="none"){
			toggleFilterSection('<%= Parameters.FORM_QRY_MODAL_HEIGHT - 216 - Parameters.FILTER_LIST_SIZE %>','<%= Parameters.FORM_QRY_MODAL_HEIGHT - 210 %>');
		}
		document.getElementById("gridList").clearTable();
		setTimeout(doXMLLoad,100);
	}

}

function doXMLLoad(){

<%
Iterator iteratorParam = filterColumns.iterator();
StringBuffer param = new StringBuffer();
while (iteratorParam.hasNext()) {
	QryColumnFilterVo filter = (QryColumnFilterVo) iteratorParam.next();
	if (QryColumnVo.FUNCTION_NONE == filter.getFunction() && ! filter.isHidden()) {
		if (param.length() > 0) {
			param.append("+ \"&");
		} else {
			param.append("\"");
		}
		param.append(filter.getFilterId() + "=\" + escape(document.getElementById('" + filter.getFilterId() + "').value)");
		if (QryColumnVo.COLUMN_DATA_DATE.equals(filter.getQryColumnVo().getQryColDataType())) {
			param.append("+ \"&" + filter.getFilterId() + "i=\" + escape((document.getElementById('" + filter.getFilterId() + "i') != null)?document.getElementById('" + filter.getFilterId() + "i').value:\"\")");
		} else {
			param.append("+ \"&" + filter.getFilterId() + "t=\" + escape(document.getElementById('" + filter.getFilterId() + "t').value)");
		}
	}
} %><%if(param!=null && param.toString().length() > 0) {%>
		var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/query/administration/modal/modalQueryXML.jsp?" + <%= param.toString() %>;
	<%} else {%>
		var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/query/administration/modal/modalQueryXML.jsp";
	<%}%>

	var listener=new Object();
	listener.onLoad=function(xml){
		readDocXML(xml);
		hideResultFrame();
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function closeWaitAMoment(){
	var win=window;
	while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
		win=win.parent;
	}
	win.document.getElementById("iframeMessages").showResultFrame(document.body);
}

function readDocXML(sXmlResult){
	var xmlRoot=getXMLRoot(sXmlResult);
	document.getElementById("moreData").style.display="none";
	document.getElementById("noData").style.display="none";
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length == 0) {
			document.getElementById("noData").style.display="block";
		} else {
			var headingCount=document.getElementById("gridList").thead.rows[0].cells.length;
			var rows=new Array();
			for(j=0;j<xmlRoot.childNodes.length;j++){
				if (j >= <%=Parameters.MAX_RESULT_MODAL %>) {
					document.getElementById("moreData").style.display="block";
				} else {
					xRow = xmlRoot.childNodes[j];
					var oTr = document.createElement("TR");
					oTr.ondblclick = btnConf_click;
					var oTd0 = document.createElement("TD"); 
					var innerHtmloTd0 = "<input type='hidden' name='chk'>";
					var oTd1;

					oTr.appendChild(oTd0);
					for (i = 0; i < xRow.childNodes.length; i++) {
						var value="";
						if(xRow.childNodes[i].firstChild){
							value=xRow.childNodes[i].firstChild.nodeValue;
						}
						innerHtmloTd0 += "<input type='hidden' name='value" + i + "' value=\"" + value.split("\"").join("&quot;") + "\">"
					
						//oTd0.setAttribute("value" + i,xRow.childNodes[i].firstChild.nodeValue);
						if(/*(i >= 2) && */ headingCount>oTr.getElementsByTagName("TD").length){
							oTd1 = document.createElement("TD");
							oTd1.innerHTML = value;
							if(value==""){
								oTd1.innerHTML = "&nbsp;";
							}
							oTr.appendChild(oTd1);
						}
						
					}
					rows.push(oTr);
					oTd0.innerHTML = innerHtmloTd0;
				}
			}
			document.getElementById("gridList").addRows(rows);	
		}
	}else{
		alert(xmlRoot.firstChild.nodeValue);
	}
	hideResultFrame();
	xmlRoot = "";
	sXmlResult = "";
}		


function getSelected(){
	var oRow = document.getElementById("gridList").selectedItems[0];
	if (oRow != null) {
		var oTd = oRow.getElementsByTagName("TD")[0];
		arr = new Array();
		
		count = 0;

		var input = oTd.getElementsByTagName("INPUT")[0];
		while (input.nextSibling != null) {
			input = input.nextSibling;
			if(input.tagName=="INPUT"){
				arr.push(input.value);
			}
		}
		lastModalReturn = arr;
		return arr;
	}
}

function enableConfirm() {
	var oRows = document.getElementById("gridList").selectedItems;
	document.getElementById("btnConf").disabled = ((oRows == null) || (oRows.length == 0));
}

function btnExit_click() {
	window.parent.returnValue=null;
	window.parent.close();
}

function toggleFilter(){
	toggleFilterSection('<%= Parameters.FORM_QRY_MODAL_HEIGHT - 216 - Parameters.FILTER_LIST_SIZE %>','<%= Parameters.FORM_QRY_MODAL_HEIGHT - 210 %>')
}

</script>