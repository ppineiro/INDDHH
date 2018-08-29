<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="java.util.*"%><%!
private String generateCode(DogmaAbstractBean dBean, Integer envId, Collection col, Collection styles, String labelSet) {
	StringBuffer buffer = new StringBuffer();
	if (col != null) {
		Iterator iterator = col.iterator();
		while (iterator.hasNext()) {
			EnvParameterVo param = (EnvParameterVo) iterator.next(); 
			buffer.append("<tr valign='top'>");
			buffer.append("<td title=\"" +LabelManager.getToolTip(labelSet,param.getEnvParName()) + "\">" + LabelManager.getNameWAccess(labelSet,param.getEnvParName()) + ":</td>");
			buffer.append("<td>");
			switch (param.getPrmType()) {
				case EnvParameterVo.PARAM_TYPE_BOOLEAN :
				case EnvParameterVo.PARAM_TYPE_BOOLEAN_CHAT :
					buffer.append("<select name=\"" + param.getEnvParName() +"\" id=\"" + param.getEnvParName() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getEnvParName()) + "\"");
					if (EnvParameterVo.PARAM_TYPE_BOOLEAN_CHAT == param.getPrmType()) buffer.append(" onChange=\"initChat();\" ");
					buffer.append(">");
					if (! (param.getEnvParValue().equals("true") || param.getEnvParValue().equals("false"))) {
						buffer.append("<option value=\"\" selected></option>");
					}
					buffer.append("<option value=\"true\"");
					if ("true".equals(param.getEnvParValue()) || "1".equals(param.getEnvParValue())) {
						buffer.append("selected");
					}
					buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
					buffer.append("<option value=\"false\"");
					if ("false".equals(param.getEnvParValue()) || "0".equals(param.getEnvParValue())) {
						buffer.append("selected");
					}
					buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
					buffer.append("</selected>");
					break;
					
				case EnvParameterVo.PARAM_TYPE_STRING :
					//buffer.append("<div>");
					buffer.append("<input name=\"" + param.getEnvParName() + "\" maxlength=\"50\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getEnvParValue()) + "\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getEnvParName()) + "\">");
					if("prmtEnvSplashImage".equals(param.getEnvParName())){
						buffer.append("<img onclick='splashUploadModal(this)' src='"+Parameters.ROOT_PATH+"/images/imagePicker.gif' style='cursor:pointer;cursor pointer;height:20px;width:20px;'>");
					}
					//buffer.append("</div>");
					break;
			
				case EnvParameterVo.PARAM_TYPE_STRING_NOT_REQ :
					//buffer.append("<div>");
					buffer.append("<input name=\"" + param.getEnvParName() + "\" id=\"" + param.getEnvParName() + "\" maxlength=\"50\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getEnvParValue()) + "\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getEnvParName()) + "\">");
					//buffer.append("</div>");
					break;

				case EnvParameterVo.PARAM_TYPE_FMT_DATE :
					buffer.append("<select name='" + param.getEnvParName() + "' p_required=true accesskey='" + LabelManager.getAccessKey(labelSet,param.getEnvParName()) + "'>"); 
					
					buffer.append("<option "); 
					if("dd/MM/yyyy".equals(param.getEnvParValue())){
						buffer.append(" selected "); 
					}
					buffer.append(" value='dd/MM/yyyy'>dd/MM/yyyy</option>");
					
					buffer.append("<option "); 
					if("MM/dd/yyyy".equals(param.getEnvParValue())){
						buffer.append(" selected "); 
					}
					buffer.append(" value='MM/dd/yyyy'>MM/dd/yyyy</option>");
					
					buffer.append("<option "); 
					if("yyyy/MM/dd".equals(param.getEnvParValue())){
						buffer.append(" selected "); 
					}
					buffer.append(" value='yyyy/MM/dd'>yyyy/MM/dd</option>");
										
					buffer.append("</select>");
					

					break;

				case EnvParameterVo.PARAM_TYPE_CHAR :
					buffer.append("<input name=\"" + param.getEnvParName() + "\" maxlength=\"1\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getEnvParValue()) + "\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getEnvParName()) + "\">");
					break;

				case EnvParameterVo.PARAM_TYPE_NUMBER :
					buffer.append("<input name=\"" + param.getEnvParName() + "\" type=\"text\" value=\"" + dBean.fmtHTML(param.getEnvParValue()) + "\" p_required=true p_numeric='true' accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getEnvParName()) + "\">");
					break;
					 
				case EnvParameterVo.PARAM_TYPE_PASSWORD :
					buffer.append("<input name=\"" + param.getEnvParName() + "\" type=\"password\" value=\"" + dBean.fmtHTML(param.getEnvParValue()) + "\" p_required=true p_numeric='true'  accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getEnvParName()) + "\">");
					break;
					
				case EnvParameterVo.PARAM_TYPE_STYLE :
					buffer.append("<select name='" + param.getEnvParName() + "' p_required=true accesskey='" + LabelManager.getAccessKey(labelSet,param.getEnvParName()) + "'>"); 
					
					if (styles != null && styles.size() > 0) {
						Iterator it = styles.iterator();
						String style = null;
						String styleDirectory = EnvParameters.getEnvParameter(envId,EnvParameters.ENV_STYLE, true);
						while (it.hasNext()) {
							style = (String) it.next();
							buffer.append("<option value=\"" + style + "\"" + (styleDirectory.equals(style)?"selected":"") + ">" + style + "</option>");
						}
					} else {
						buffer.append("<option></option>");
					}
					
					buffer.append("</select>");
			}
			buffer.append("</td></tr>");
		}
	}
	
	return buffer.toString();
}
%><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParForm")%>" tabText="<%=LabelManager.getName(labelSet,"tabParForm")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPar")%></DIV><table class="tblFormLayout"><%= generateCode(dBean, theEnvId, paramsFormat, styles, labelSet) %></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParOther")%>" tabText="<%=LabelManager.getName(labelSet,"tabParOther")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPar")%></DIV><table class="tblFormLayout"><%= generateCode(dBean, theEnvId, paramsOther, styles, labelSet) %></table></div></div>