<%
Collection colPerms = dBean.getColPermissions();
boolean withProject = (entityVo.getPrjId()!=null);
boolean hasPerms = (colPerms!=null & colPerms.size()>0);
boolean usePrjPerms = hasPerms && (((ObjAccessVo) colPerms.iterator().next()).getObjAccUsePrj()==null || ((ObjAccessVo) colPerms.iterator().next()).getObjAccUsePrj().intValue() == 1);
boolean chkBoxClicked = (withProject && !hasPerms) || (withProject && usePrjPerms);
%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtPerAccBusEnt")%></DIV><table class="tblFormLayout"><tr><td><input name="usePrjPerms" id="usePrjPerms" type=checkbox <%=(chkBoxClicked)?"checked":""%><%=(!withProject)?"disabled":""%> onClick="chkUsePrjPerms()"><%=LabelManager.getName(labelSet,"lblUsePrjPerm")%></td></tr></table><div type="grid" id="permGrid" style="height:200px" <%=(chkBoxClicked)?"disabled":""%>><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="50px" style="width:50px">&nbsp;</th><th min_width="300px" style="min-width:300px;width:70%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="150px" style="min-width:150px;width:30%" title="<%=LabelManager.getToolTip(labelSet,"lblPer")%>"><%=LabelManager.getName(labelSet,"lblPer")%></th></tr></thead><tbody class="scrollContent"><% Collection colPermissions = dBean.getColPermissions();
	   		   if ((colPermissions == null || colPermissions.size()==0) || (withProject && usePrjPerms)){ //Si aún no se definieron permisos o se usan los permisos del proyecto%><tr cantDelete="true"><td style="width:0px;display:none;" align="center"><input type='hidden' id="idSel" name="chkSel"><input type='hidden' name="hidPoolId" value="-1"><input type='hidden' name="hidRead" value="1"><input type='hidden' name="hidMod" value="1"></td><td align="center"><div style="width:18px; height:18px;"></div></td><td style="min-width:300px" title="<%=LabelManager.getToolTip(labelSet,"lblTod")%>"><%=LabelManager.getName(labelSet,"lblTod")%></td><td style="min-width:150px"><input name="chkAllowRead" type=checkbox <%=(!chkBoxClicked)?"checked":""%>  onClick="chgChkHidRead(event)"><%=LabelManager.getName(labelSet,"lblPerVer")%><input name="chkAllowModify" type=checkbox <%=(!chkBoxClicked)?"checked":""%>  onClick="chgChkHidMod(event)"><%=LabelManager.getName(labelSet,"lblPerMod")%></td></tr><%}else{//Ya se definieron permisos
				 Iterator itPermissions = colPermissions.iterator();
				 int intPermId=0;
				 while (itPermissions.hasNext()) {
					ObjAccessVo objAccessVo = (ObjAccessVo) itPermissions.next();
					Integer poolId= objAccessVo.getPoolId();
					String poolName;
					boolean readAccess = (objAccessVo.getReadOnly() != null && 1 == objAccessVo.getReadOnly().intValue());
					boolean writeAccess = ( objAccessVo.getReadWrite() != null && 1 == objAccessVo.getReadWrite().intValue());
					boolean cantDelete = (-1 == poolId.intValue());
					String rType="";
					String strImage;
					if (poolId.intValue() == -1){
						strImage="<div style='width:18px; height:18px;'></div>";
						poolName = LabelManager.getName(labelSet,"lblTod");
					} else if (objAccessVo.isAutoGenPool()) {
						strImage="<div style='width:18px; height:18px; background-image:url(" + com.dogma.Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/user.gif);background-repeat:no-repeat;'></div>";
						rType = "usu";
						poolName = objAccessVo.getPoolName();
					} else {
						strImage="<div style='width:18px; height:18px; background-image:url(" + com.dogma.Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/pool.gif);background-repeat:no-repeat;'></div>";
						rType = "grp";
						poolName = objAccessVo.getPoolName();
					}
					System.out.println("poolName:"+poolName+", readAccess:"+readAccess+", writeAccess:"+writeAccess);
					%><tr cantDelete="<%=cantDelete%>"><td style="width:0px;display:none;" align="center"><input type='hidden' id="idSel" name="chkSel"><input type='hidden' name="hidPoolId" value="<%=poolId.intValue()%>"><input type='hidden' name="hidRead" value="<%=(readAccess)?"1":"0"%>"><input type='hidden' name="hidMod" value="<%=(writeAccess)?"1":"0"%>"></td><td align="center"><%=strImage%></td><td title="<%= dBean.fmtHTML(poolName)%>"><%=dBean.fmtHTML(poolName)%></td><% if (poolId==-1){ %><td style="min-width:150px"><input name="chkAllowRead" type=checkbox <%=(readAccess)?"checked":""%> onClick="chgChkHidRead(event)"><%=LabelManager.getName(labelSet,"lblPerVer")%><input name="chkAllowModify" type=checkbox <%=(writeAccess)?"checked":""%> onClick="chgChkHidMod(event)"><%=LabelManager.getName(labelSet,"lblPerMod")%></td><%}else{ %><td style="min-width:150px"><input type="radio" id="rad<%=intPermId %>" onClick="chgRadHidRead(event)" name="<%=rType + intPermId%>" <%if (readAccess && !writeAccess){%> checked <%}%>><%=dBean.fmtScriptStr(LabelManager.getName(labelSet,"lblPerVer"))%><input type="radio" id="rad<%=intPermId %>" onClick="chgRadHidMod(event)" name="<%=rType + intPermId%>" <%if (writeAccess){%> checked <%}%>><%=dBean.fmtScriptStr(LabelManager.getName(labelSet,"lblPerMod"))%></td><%intPermId++;}%></tr><%}
			}%></tbody></table></div><table class="navBar" id="navBar"><tr><td align="right"><button type="button" id="addPoolUsrPerm" type="button" onclick="btnAddPoolUsrPerm_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgrGruUsr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgrGruUsr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgrGruUsr")%></button><button type="button" id="delPoolUsrPerm" type="button" onclick="btnDelPoolPerm_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><script src="<%=Parameters.ROOT_PATH%>/programs/administration/entities/permissions.js"></script><SCRIPT>

function chgChkHidRead(evt){
	evt=getEventObject(evt);
	var el=getEventSource(evt);
	var tr = getParentRow(el);
	var td = tr.getElementsByTagName("TD");
	if (!td[3].getElementsByTagName("INPUT")[1].checked){//si no estaba seleccionado el modo escritura
		if (td[0].getElementsByTagName("INPUT")[2].value == 1){ //si estaba seleccionado el modo lectura
 			td[0].getElementsByTagName("INPUT")[2].value = 0; //lo desmarcamos
		}else{
 			td[0].getElementsByTagName("INPUT")[2].value = 1; //lo marcamos
		}
	}else{
		//Marcamos el modo lectura
		td[3].getElementsByTagName("INPUT")[0].checked = true;
		td[0].getElementsByTagName("INPUT")[2].value = 1;
	}
}

function chgChkHidMod(evt){
	evt=getEventObject(evt);
	var el=getEventSource(evt);
	var tr = getParentRow(el);
	var td = tr.getElementsByTagName("TD");
	if (td[0].getElementsByTagName("INPUT")[3].value == 1){//si estaba seleccionado el modo escritura
 		td[0].getElementsByTagName("INPUT")[3].value = 0;//lo desmarcamos
	}else{
 		td[0].getElementsByTagName("INPUT")[3].value = 1;//lo marcamos
 		//Marcamos tambien el modo lectura:
 		td[3].getElementsByTagName("INPUT")[0].checked = true;
 		td[0].getElementsByTagName("INPUT")[2].value = 1;
	}
}

function chgRadHidRead(evt){
	evt=getEventObject(evt);
	var el=getEventSource(evt);
	var tr = getParentRow(el);
	var td = tr.getElementsByTagName("TD");
	//El modo lectura en los pooles siempre esta seteado -> al hacer click en el rad lectura lo unico que hacemos es desmarcar el modo escritura
	td[0].getElementsByTagName("INPUT")[3].value = 0;//lo desmarcamos como modo escritura
}

function chgRadHidMod(evt){
	evt=getEventObject(evt);
	var el=getEventSource(evt);
	var tr = getParentRow(el);
	var td = tr.getElementsByTagName("TD");
	//El modo lectura en los pooles siempre esta seteado -> al hacer click en el rad escritura lo unico que hacemos es marcar el modo escritura
	td[0].getElementsByTagName("INPUT")[3].value = 1;//lo marcamos como modo escritura
}

function btnAddPoolUsrPerm_click() {
	var rets = openModal("/programs/modals/pools.jsp?showAutogenerated=true&envAndGlobal=true&envId=" + <%=envId%> + "&showGlobal=true",500,350);
	rets.onclose=function(){
		addObject(rets.returnValue);
	}
}

var intPermId = 1000;//ponemos 1000 como el inicial pq ya pueden haber cargados y se cargan desde 0 (si ya hay mas de 1000 hay problemas)

function addObject(rets) {
	if (rets != null) {
		for (j = 0; j < rets.length; j++) {
			var ret = rets[j];
			var addRet = true;
			
			var poolId = ret[0]; //poolId
			var poolName = ret[1]; //poolName
			var poolAutoGen = ("1" == ret[5]); //poolAutoGen (si es true es un usuario, sino un grupo)
			
			//Nos fijamos si ya no se habia agregado el grupo
			trows=document.getElementById("permGrid").rows;
			for (i=0;i<trows.length && addRet;i++) {
				var actId = trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
				if (actId == poolId) {
					addRet = false;
				}
			}
			
			if (addRet) {
				var oTd0 = document.createElement("TD"); //oculto
				var oTd1 = document.createElement("TD"); //imagen
				var oTd2 = document.createElement("TD"); //nombre
				var oTd3 = document.createElement("TD"); //permisos
				
				oTd0.innerHTML='<input type="hidden" name="chkSel" value=""></input>';
				oTd0.innerHTML += '<input type="hidden" name="hidPoolId" value="' + poolId +'">';
				oTd0.innerHTML += '<input type="hidden" name="hidRead" value="1">'; //el modo lectura siempre esta seteado
				oTd0.innerHTML += '<input type="hidden" name="hidMod" value="1">';	

				oTd1.innerHTML = '<div style="width:18px; height:18px;"></div>';				
				if (poolAutoGen) { //Si se va a agregar un usuario
					oTd1.getElementsByTagName("DIV")[0].style.backgroundImage=("url(" + URL_STYLE_PATH+ "/images/user.gif)"); //mostramos imagen para usuarios
				} else {
					oTd1.getElementsByTagName("DIV")[0].style.backgroundImage=("url(" + URL_STYLE_PATH+ "/images/pool.gif)"); //mostramos imagen para grupos
				}
				oTd1.getElementsByTagName("DIV")[0].style.backgroundRepeat="no-repeat";
				
				oTd2.title = poolName;
				oTd2.innerHTML = poolName;//mostramos el nombre del usuario

				var rType;
				if (poolAutoGen) { //Si es un pool autogenerado es un usuario
					rType = "usu";
				} else {
					rType = "grp";
				}
						
				//creamos los radio buttons para seleccionar los permisos
				var str = "<input type='radio' id='rad" + intPermId + "' onClick='chgRadHidRead(event)' name='" + rType + intPermId +"'><%=dBean.fmtScriptStr(LabelManager.getName(labelSet,"lblPerVer"))%>";
				str += "<input type=radio id='rad" + intPermId + "' onClick='chgRadHidMod(event)' name='" + rType + intPermId + "' checked><%=dBean.fmtScriptStr(LabelManager.getName(labelSet,"lblPerMod"))%>";
				
				oTd3.innerHTML = str;
								
				var oTr = document.createElement("TR");
				oTr.setAttribute("cantDelete","false");
				oTr.appendChild(oTd0);
				oTr.appendChild(oTd1);
				oTr.appendChild(oTd2);
				oTr.appendChild(oTd3);
				document.getElementById("permGrid").addRow(oTr);
				document.getElementById("permGrid").updateScroll();
				intPermId++;
			}
		}
	}		
}

function btnDelPoolPerm_click() {
	if (document.getElementById("permGrid").selectedItems.length > 0){
		var oRows=document.getElementById("permGrid").selectedItems;
		for(var i=(oRows.length-1);(i>=0);i--){
			if(oRows[i].getAttribute("cantDelete")!="true"){
				oRows[i].parentNode.removeChild(oRows[i]);
				document.getElementById("permGrid").updateScroll();
			}
			oRows[i].style.height="0px";
		}
	}else{
		alert(MSG_MUST_SEL_ONE);
	}
}

function delAllPerms(leaveAllPermClicked){
	var oRows = document.getElementById("permGrid").rows;
	for(var i=1; i<oRows.length;i++){
		oRows[i].parentNode.removeChild(oRows[i]);
		document.getElementById("permGrid").updateScroll();
	}
		
	var td = oRows[0].getElementsByTagName("TD");
	if (leaveAllPermClicked){ //Dejamos el todos clickeado
		//Marcamos el modo lectura
		td[3].getElementsByTagName("INPUT")[0].checked = true;
		td[0].getElementsByTagName("INPUT")[2].value = 1;
		//Marcamos escritura
		td[3].getElementsByTagName("INPUT")[1].checked = true;
	 	td[0].getElementsByTagName("INPUT")[3].value = 1;
	}else {//Dejamos el todos desclickeado
		//Desmarcamos el modo lectura
		td[3].getElementsByTagName("INPUT")[0].checked = false;
		td[0].getElementsByTagName("INPUT")[2].value = 0;
		//Desmarcamos escritura
		td[3].getElementsByTagName("INPUT")[1].checked = false;
	 	td[0].getElementsByTagName("INPUT")[3].value = 0;
	}
}

function chkUsePrjPerms() {
	if (document.getElementById("usePrjPerms").checked){ //Si el checkBox esta clickeado
		var msg = confirm(MSG_PERM_WILL_BE_LOST);
		if (msg) {
			//Deshabilitamos la grilla de permisos
			document.getElementById("permGrid").disabled = true;
			//Deshbilitamos los botones de la grilla
			document.getElementById("addPoolUsrPerm").disabled = true;
			document.getElementById("delPoolUsrPerm").disabled = true;
			delAllPerms(false);
		}else{ //desclikeamos el checkbox
			document.getElementById("usePrjPerms").checked = false;
		}
	}else{ //Si el checkbox no esta clickeado
		//Habilitamos la grilla de permisos
		document.getElementById("permGrid").disabled = false;
		//Habilitamos los botones de la grilla
		document.getElementById("addPoolUsrPerm").disabled = false;
		document.getElementById("delPoolUsrPerm").disabled = false;
		//Clickeamos los checkbox de lectura/escritura
		var oRows = document.getElementById("permGrid").rows;
		var td = oRows[0].getElementsByTagName("TD");
		//Marcamos el modo lectura
		td[3].getElementsByTagName("INPUT")[0].checked = true;
		td[0].getElementsByTagName("INPUT")[2].value = 1;
		//Marcamos escritura
		td[3].getElementsByTagName("INPUT")[1].checked = true;
		td[0].getElementsByTagName("INPUT")[3].value = 1;
	}
}
</SCRIPT>