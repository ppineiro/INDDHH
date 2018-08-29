<%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.WidInformationVo"%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtWidInfo")%></DIV><table width="100%" class="tblFormLayout"><tr><td align="left"><input type="checkbox" name="chkWidLstUpdate" id="chkWidLstUpdate" <%=(widVo==null || widVo.getWidId()==null || dBean.seeInformation(WidInformationVo.WID_INFO_LAST_UPDATE))?"checked":""%> title="<%=LabelManager.getToolTip(labelSet,"lblWidShowLstUpdate")%>"><%=LabelManager.getNameWAccess(labelSet,"lblWidLastUpdate")%></input></td></tr><tr><td align="left"><input type="checkbox" name="chkWidSource" id="chkWidSource" <%=(widVo==null || widVo.getWidId()==null || dBean.seeInformation(WidInformationVo.WID_INFO_SOURCE_DATA))?"checked":""%> title="<%=LabelManager.getToolTip(labelSet,"lblWidShowSource")%>"><%=LabelManager.getToolTip(labelSet,"lblWidSource")%></input></td></tr></table><div type="grid" id="extraInfo" style="height:200px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="200px" style="width:200px" title="<%=LabelManager.getToolTip(labelSet,"lblWidInfoType")%>"><%=LabelManager.getName(labelSet,"lblWidInfoType")%></th><th min_width="500px" style="width:500px" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%></th><th min_width="150px" style="min-width:150px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"titVisible")%>"><%=LabelManager.getName(labelSet,"titVisible")%></th></tr></thead><tbody class="scrollContent"><% Collection colInformation = dBean.getColInformation();
	   		   int i=0;
	   		   if (colInformation!=null && colInformation.size()>0){
	   		   	Iterator itInformation = colInformation.iterator();
		   	    while (itInformation.hasNext()){
		   			WidInformationVo widInfoVo = (WidInformationVo) itInformation.next();
			   		if (!WidInformationVo.WID_INFO_LAST_UPDATE.equals(widInfoVo.getWidInfoType()) && !WidInformationVo.WID_INFO_SOURCE_DATA.equals(widInfoVo.getWidInfoType())){%><tr><td style="width:0px;display:none;" align="center"><input type="checkbox" name="chkInfoSel"></td><td><input type="text" name="widInfoType" maxlength="50" style="width:200px" value="<%=widInfoVo.getWidInfoType()%>"></input></td><td><input type='text' name='widInfoDesc' maxlength="255" style="width:500px" value="<%=widInfoVo.getWidInfoDesc()%>"></input></td><td style="min-width:150px"><input type="checkbox" name="visible" value="<%=i%>" <%=(widInfoVo.getWidInfoVisible().intValue()==1)?"checked":""%>></td></tr><%i++;
	 	  		  }
	 	  	  	}
		   	   }%></tbody></table></div><table class="navBar" id="navBar"><tr><td align="left"><button type="button" onclick="btnUp_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnUp")%>" title="<%=LabelManager.getToolTip(labelSet,"btnUp")%>"><%=LabelManager.getNameWAccess(labelSet,"btnUp")%></button><button type="button" onclick="btnDown_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDown")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDown")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDown")%></button></td><td></td><td align="right"><button type="button" type="button" onclick="btnAddInfo_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnWidAddInfo")%>" title="<%=LabelManager.getToolTip(labelSet,"btnWidAddInfo")%>"><%=LabelManager.getNameWAccess(labelSet,"btnWidAddInfo")%></button><button type="button" type="button" onclick="btnDelInfo_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnWidDelInfo")%>" title="<%=LabelManager.getToolTip(labelSet,"btnWidDelInfo")%>"><%=LabelManager.getNameWAccess(labelSet,"btnWidDelInfo")%></button></td></tr></table><script src="<%=Parameters.ROOT_PATH%>/programs/biDesigner/widgets/permissions.js"></script><SCRIPT>

function btnAddInfo_click() {
	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD");
	var oTd2 = document.createElement("TD");
	var oTd3 = document.createElement("TD");

	oTd0.innerHTML = "<input type='checkbox' name='chkInfoSel'>";
	oTd1.innerHTML = "<input type='text' name='widInfoType' maxlength='50' style='width:200px' value=''></input>"; 
	oTd2.innerHTML = "<input type='text' name='widInfoDesc' maxlength='255' style='width:500px'></input>";

	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	oTr.appendChild(oTd3);
	document.getElementById("extraInfo").addRow(oTr);	
	var rowId = oTr.rowIndex - 1;
	oTd3.innerHTML = "<input type='checkbox' name='visible' value='' checked>"; //--> Agregamos el checkbox visible
	setIndexes();
}


function btnDelInfo_click() {
	if (document.getElementById("extraInfo").selectedItems.length > 0){
		var oRows=document.getElementById("extraInfo").selectedItems;
		for(var i=(oRows.length-1);(i>=0);i--){
			oRows[i].parentNode.removeChild(oRows[i]);
			document.getElementById("extraInfo").updateScroll();
			oRows[i].style.height="0px";
		}
	}else{
		alert(MSG_MUST_SEL_ONE_ROW_FIRST);
	}
	setIndexes();
}

function btnUp_click(){
	var grid=document.getElementById("extraInfo");
	var cant=grid.selectedItems.length;
	if(cant > 0) {
		if(cant == 1) {
			grid.moveSelectedUp();
		} else if (cant > 1) {
			alert(GNR_CHK_ONLY_ONE);
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	setIndexes();
}

function btnDown_click(){
	var grid=document.getElementById("extraInfo");
	var cant=grid.selectedItems.length;
	if(cant > 0) {
		if(cant == 1) {
			grid.moveSelectedDown();
		} else if (cant > 1) {
			alert(GNR_CHK_ONLY_ONE);
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	setIndexes();
}


function setIndexes(){
	var grid=document.getElementById("extraInfo");
	for(var i=0;i<grid.rows.length;i++){
		grid.rows[i].cells[3].getElementsByTagName("INPUT")[0].value=i;
	}
}

</SCRIPT>