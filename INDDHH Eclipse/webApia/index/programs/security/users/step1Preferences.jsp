		<div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabPref")%>" tabText="<%=LabelManager.getName(labelSet,"tabPref")%>"><!-- Estilos del usuario --><DIV id="divSty"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtUsuSty")%></DIV><div type="grid" id="gridStyles" style="height:100px"><table id="tblStyles"  width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="120px" style="min-width:120px;width:80%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="80px" style="min-width:80px;width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblSelSty")%>"><%=LabelManager.getName(labelSet,"lblSelSty")%></th></tr></thead><tbody id="tblPerBody"><% Collection stylesCol = dBean.getUsrStyles();
						if (stylesCol!=null && stylesCol.size()>0){
							Iterator itStyles = stylesCol.iterator();
							while (itStyles.hasNext()) {
								String styleName = ((UsrStylesVo) itStyles.next()).getStyleName();
								%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkStySel"><input type=hidden name="chkSty" value="<%=styleName%>"></td><td style="min-width:120px"><%=dBean.fmtHTML(styleName)%></td><td style="min-width:80px"><input type="checkbox" name="chkSelSty" onclick="selStyle(this,'<%=dBean.fmtHTML(styleName)%>')" <%=(userVo.getUsrStyle()!=null && styleName.equals(userVo.getUsrStyle()))?"checked":"" %>></td></tr><%
							} 
						}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD><input type="hidden" name="hidSelStyle" value="<%=(userVo.getUsrStyle()!=null)?userVo.getUsrStyle():""%>"></TD><td><button type="button" onclick="btnAddStyle_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelStyle_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></DIV></div>