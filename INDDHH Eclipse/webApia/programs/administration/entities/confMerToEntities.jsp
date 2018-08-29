<%@page import="com.dogma.vo.*"%><%@page import="com.apia.erd.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEntNeg")%></TD><TD></TD></TR></TABLE><%int i = 0; %><div id="divContent"><form id="frmMain" name="frmMain" method="POST" ><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblPoolForTask")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPoolForTask")%>:</td><td><input p_required=true name="txtPoolName" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPoolForTask")%>" type="text" value="admin"></td><td></td><td></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"tabDatEntNeg")%></DIV><div style="height: 450px;" type="grid" id="gridList" docBean=""><table cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="display:none;width:0px"></th><th style="width:100px"	title="<%=LabelManager.getToolTip(labelSet,"titEnt")%>"><%=LabelManager.getName(labelSet,"titEnt")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"titNomEnt")%>"><%=LabelManager.getName(labelSet,"titNomEnt")%></th><th style="width:30px" title="<%=LabelManager.getToolTip(labelSet,"lblPrefix")%>"><%=LabelManager.getName(labelSet,"lblPrefix")%></th><th style="width:50px"	title="<%=LabelManager.getToolTip(labelSet,"lblTipoAdm")%>"><%=LabelManager.getName(labelSet,"lblTipoAdm")%></th><th style="width:30px"	title="<%=LabelManager.getToolTip(labelSet,"lblFrm")%>"><%=LabelManager.getName(labelSet,"lblFrm")%></th><th style="width:30px"	title="<%=LabelManager.getToolTip(labelSet,"lblIgnoreNumPK")%>"><%=LabelManager.getName(labelSet,"lblIgnoreNumPK")%></th><th style="width:30px"	title="<%=LabelManager.getToolTip(labelSet,"lblModalRetAtt")%>"><%=LabelManager.getName(labelSet,"lblModalRetAtt")%></th><th style="width:30px"	title="<%=LabelManager.getToolTip(labelSet,"lblEntProCre")%>"><%=LabelManager.getName(labelSet,"lblEntProCre")%></th><th style="width:30px"	title="<%=LabelManager.getToolTip(labelSet,"lblEntProAlt")%>"><%=LabelManager.getName(labelSet,"lblEntProAlt")%></th><th style="width:30px"	title="<%=LabelManager.getToolTip(labelSet,"lblQry")%>"><%=LabelManager.getName(labelSet,"lblQry")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblPadres")%>"><%=LabelManager.getName(labelSet,"lblPadres")%></th><th style="width:30px"	title="<%=LabelManager.getToolTip(labelSet,"lblBind")%>"><%=LabelManager.getName(labelSet,"lblBind")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblNomRel")%>"><%=LabelManager.getName(labelSet,"lblNomRel")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblHijos")%>"><%=LabelManager.getName(labelSet,"lblHijos")%></th><th style="width:50px"	title="<%=LabelManager.getToolTip(labelSet,"lblAdm")%>"><%=LabelManager.getName(labelSet,"lblAdm")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblNomRel")%>"><%=LabelManager.getName(labelSet,"lblNomRel")%></th><!--  <th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"titAtr")%>"><%=LabelManager.getName(labelSet,"titAtr")%></th> --><th style="display:none;width:0px"></th></tr></thead><tbody class="scrollContent"><% Collection<Table> tables = dBean.convertMerToEntities(request);
							if (tables != null) {
								Iterator<Table> it = tables.iterator();
								Table table;
								int num=0; 
								while (it.hasNext()) {
									table = it.next(); 
									if(table.getName()!=null && table.getName() != ""){%><tr><td style="display:none;width:0px"><input type="hidden" /></td><td><%=table.getName()%><input type="hidden" id="entName<%=i%>" name="entName<%=i%>" value="<%=table.getName()%>" /></td><td><input type="text" id="entNewName<%=i%>" name="entNewName<%=i%>" value="<%=table.getName()%>" p_required="true"/></td><%String prefix = table.getName();
											prefix = prefix.replaceAll("_","");
											if(prefix.length()>5){
												prefix = prefix.substring(0,5);
											}
											
											
										
											%><td><input type="text" id="entPrefix<%=i%>" name="entPrefix<%=i%>" value="<%=prefix%>" size="3" maxlength="3" p_required="true"/></td><td><select id="selTypeAdm" name="selTypeAdm<%=num++%>" onchange="changeAdmType(this,<%=i%>)"><option <%=(Table.ADMIN_FUNCT.equals(dBean.getMerMap().get("cmbTipAdmDef"))?" selected":"") %> value="<%=Table.ADMIN_FUNCT%>"><%=LabelManager.getName(labelSet,"lblTipAdmFun")%></option><option <%=(Table.ADMIN_PROCESS.equals(dBean.getMerMap().get("cmbTipAdmDef"))?" selected":"") %> value="<%=Table.ADMIN_PROCESS%>"><%=LabelManager.getName(labelSet,"lblTipAdmPro")%></option><option <%=(Table.ADMIN_BOTH.equals(dBean.getMerMap().get("cmbTipAdmDef"))?" selected":"") %> value="<%=Table.ADMIN_BOTH%>"><%=LabelManager.getName(labelSet,"lblTipAdmAmb")%></option></select><input type="hidden" name="counter" value="0"></input></td><td><input type="checkbox" id="chkFrm<%=i%>" name="chkFrm<%=i%>" checked/></td><td><input type="checkbox" name="chkIgnoreNumPK<%=i%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblIgnoreNumPK")%>" checked></td><td><input type="checkbox" name="chkCreateModal<%=i%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblModalRetAtt")%>" checked><select id="cmbFinder<%=i%>" name="cmbFinder<%=i%>"><%
												Collection<Column> cols = table.getColumns().values();
												boolean selected = false;
												for(Column col : cols){
													%><option <%
													String valuesToCheck = (String)dBean.getMerMap().get("txtAttPre");
													String[] arrVal = valuesToCheck.split(",");
													for(int j=0;j<arrVal.length;j++){
														if(!selected && col.getName().toUpperCase().contains(arrVal[j].toUpperCase())){
															out.print(" selected ");
															selected=true;
															break;
														}	
													}
													
													
													%> value="<%=col.getType()%>-<%=col.getName()%>"><%=col.getName()%></option><%
													
												}
												%></select></td><td><input type="checkbox" id="chkProCre<%=i%>" name="chkProCre<%=i%>" <%=("on".equals(dBean.getMerMap().get("chkAddCrePro"))?" checked ":"") %><%=(Table.ADMIN_FUNCT.equals(dBean.getMerMap().get("cmbTipAdmDef"))?" disabled ":"") %> /></td><td><input type="checkbox" id="chkProAlt<%=i%>" name="chkProAlt<%=i%>" <%=("on".equals(dBean.getMerMap().get("chkAddAltPro"))?" checked ":"") %><%=(Table.ADMIN_FUNCT.equals(dBean.getMerMap().get("cmbTipAdmDef"))?" disabled ":"") %> /></td><td><input type="checkbox" id="chkQry<%=i%>" name="chkQry<%=i%>" <%=("on".equals(dBean.getMerMap().get("chkAddQry"))?" checked ":"") %> /></td><% 
											Collection<ForeignKey> fks = table.getForeignKeys();
											if (fks != null && fks.size() > 0) {
												int j = 0;
												String td1="<td>";
												String td2="<td>";
												String td3="<td>";
												//String td4="<td>";
												for (ForeignKey fk : fks) {
													td1+=fk.getFather()+"<input type=\"hidden\" id=\"father"+j+"\" value=\""+fk.getFather()+"\" /><br/><br/>";
													td2+="<select name=\"cmbAdmPad"+table.getName()+"_"+ fk.getName() +"\"><option " + ("N".equals(dBean.getMerMap().get("cmbBindDefVal"))?" selected":"") + " value='N'>No</option><option " + ("S".equals(dBean.getMerMap().get("cmbBindDefVal"))?" selected":"") + " value='S'>Si</option><option " + ("A".equals(dBean.getMerMap().get("cmbBindDefVal"))?" selected":"") + " value='A'>Si, Administrar</option></select><br/><br/>";
													td3+="<input name=\"txtRelNamePad"+table.getName()+"_"+ fk.getName() +"\" maxlength=\"50\" accesskey=\""+LabelManager.getAccessKey(labelSet,"lblNomRel")+"\" type=\"text\" /><br/><br/>";
													//td4+="<input type=\"checkbox\" id=\"chkHerFrm"+j+"\" name=\"chkHerFrm"+j+"\" /><br/><br/>";
													j++; 
												}
												td1 = td1.substring(0,td1.length()-10)+"</td>";
												td2 = td2.substring(0,td2.length()-10)+"</td>";
												td3 = td3.substring(0,td3.length()-10)+"</td>";
												//td4 = td4.substring(0,td4.length()-10)+"</td>"; 
												%><%=td1%><%=td2%><%=td3%><%//=td4%><% } else { %><td></td><td></td><!-- <td></td>  --><td></td><% }
											
											Collection<ForeignKey> eks = table.getExportedKeys();
											if (eks != null && eks.size() > 0) {
												int k = 0;
												String td1="<td>";
												String td2="<td>";
												String td3="<td>";
												
												for (ForeignKey ek : eks) { 
													td1+=ek.getFather()+"<input type=\"hidden\" id=\"childAdm"+k+"\" value=\""+ek.getFather()+"\" /><br/><br/>";
													td2+="<input type=\"checkbox\" name=\"chkCard"+table.getName()+"_"+ ek.getFather()+ k + "\" onclick=\"document.getElementById('cmbAdmHij"+table.getName()+"_"+ ek.getFather()+ k +"').disabled=!this.checked\" /><select disabled id=\"cmbAdmHij"+table.getName()+"_"+ ek.getFather() + k +"\" name=\"cmbAdmHij"+table.getName()+"_"+ ek.getFather() +"\"><option value='1'>1-1</option><option value='n'>1-n</option></select><br/><br/>";
													td3+="<input name=\"txtRelNameChild"+table.getName()+"_"+ ek.getFather() +"\" maxlength=\"50\" accesskey=\""+LabelManager.getAccessKey(labelSet,"lblNomRel")+"\" type=\"text\" /><br/><br/>";
													k++;
												}
												td1 = td1.substring(0,td1.length()-10)+"</td>";
												td2 = td2.substring(0,td2.length()-10)+"</td>";
												td3 = td3.substring(0,td3.length()-10)+"</td>";
												%><%=td1%><%=td2%><%=td3%><% } else { %><td></td><td></td><td></td><% } %><!-- <td><button type="button" onclick="btnVerAtts_click('<%=table.getName()%>',<%=i%>)" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVerAtt")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVerAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVerAtt")%></button></td>
											--><td style="display:none;width:0px"><input type="hidden" id="hiddenAtts<%=i%>" /></td></tr><%i++;
									}	
								}
							}%></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="loadState()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnLoadState")%>" title="<%=LabelManager.getToolTip(labelSet,"btnLoadState")%>"><%=LabelManager.getNameWAccess(labelSet,"btnLoadState")%></button><button type="button" onclick="saveState()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSaveState")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSaveState")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSaveState")%></button><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var LOAD_FROM_FILE = "<%= dBean.LOAD_FROM_FILE %>";
var LOAD_FROM_DB = "<%= dBean.LOAD_FROM_DB %>";
</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/entities/confMerToEntities.js"></script><script>
//cmbLoadFrom_change();
</script>

