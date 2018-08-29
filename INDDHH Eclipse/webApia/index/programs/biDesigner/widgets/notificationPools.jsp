<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.custom.ProDefinitionVo"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><%
String pools = request.getParameter("pools");
%><!--     - USUARIOS A SER NOTIFICADOS          --><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Grupos</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" target="frmSubmit" onSubmit="return false"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no"  ></iframe><br><div type="grid" id="gridPools" style="height:200px"><table id="tblPools" class="tblDataGrid"><thead><tr><th style="width:0px;display:none;" title="Seleccionar"></th><th style="width:100%" title="<%=LabelManager.getName(labelSet, "lblPoolNot")%>"><%=LabelManager.getName(labelSet, "lblPoolNot")%></th></tr></thead><tbody id="tblPoolBody"><%if (pools != null && !pools.equals("") && !pools.equals("-") && pools != "undefined" && !pools.equals("undefined")){
				String [] poolArr = pools.split(",");
				for (int i=0;i<poolArr.length;i++){
					String poolId = poolArr[i];
					String poolName = poolArr[i+1];
					i++;
					%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPoolSel"><input type=hidden name="idPool" value="<%=poolId%>"><input type=hidden name="txtPool" value="<%=poolName%>"></td><td><%=poolName%></td></tr><%
				}
			}%></tbody></table></div><form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><tr><td><button type="button" onclick="btnAddPool_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelPool_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td><td><button type="button" onclick="btnConfPools_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExitPools_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></html><SCRIPT>
  TYPE_NUMERIC = "<%= AttributeVo.TYPE_NUMERIC %>";
  TYPE_DATE = "<%= AttributeVo.TYPE_DATE %>";
  TYPE_STRING = "<%= AttributeVo.TYPE_STRING %>";
  ENV_ID = "<%=envId%>";
 </script><script  language="javascript">
 
  function btnAddPool_click() {
		var rets = openModal("/programs/modals/pools.jsp?showAutogenerated=true&showOnlyEnv=true&envId=" + ENV_ID + "&showGlobal=true",500,350);
			var doAfter=function(rets){
				if (rets != null) {
					for (j = 0; j < rets.length; j++) {
						var ret = rets[j];
						var addRet = true;
						
						trows=document.getElementById("gridPools").rows;
						for (i=0;i<trows.length & addRet;i++) {
							if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
								addRet = false;
							}
						}
						
					if (addRet) {
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
						
						oTd0.innerHTML = "<input type='checkbox' name='chkPoolSel'><input type='hidden' name='idPool'><input type='hidden' name='txtPool'>";
						oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
						oTd0.getElementsByTagName("INPUT")[2].value = ret[1];

						oTd0.align="center";
						
						oTd1.innerHTML = ret[1];
						
						var oTr = document.createElement("TR");
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						document.getElementById("gridPools").addRow(oTr);
					}
				}
			}
		}
		rets.onclose=function(){
			doAfter(rets.returnValue);
		}
	}

	function btnDelPool_click() {
		document.getElementById("gridPools").removeSelected();
	}

	function btnConfPools_click(event) {
		var pools = getSelected();
		if (pools.length > 255) {
			alert("Se ingresaron demasiados grupos, por favor elimine algunos.");
			return;
		}
		window.returnValue = pools;
		window.close();
	}	

	function btnExitPools_click() {
		window.returnValue=null;
		window.close();
	}
	
	function getSelected(){
		var oRows=document.getElementById("gridPools").rows;
		var result = "";
		if (oRows != null) {
			for (i = 0; i < oRows.length; i++) {
				var oRow = oRows[i];

				var poolId = oRow.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
				var poolName = oRow.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[2].value;

				if (result==""){
					result = poolId + "," + poolName;
				}else {
					result = result + "," + poolId + "," + poolName;
				}
			}
		}
		return result;
	}
</script>