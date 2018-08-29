<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.configuration.ParametersBean"%><%@page import="com.dogma.bi.BIEngine"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%!private String generateCode(ParametersBean dBean, Collection col, String labelSet, String styleDirectory) {
	StringBuffer buffer = new StringBuffer();
	if (col != null) {
		Iterator iterator = col.iterator();
		Object obj = null;
		ParametersVo param = null;
		String divTitle = null;
		boolean btnTestAuthVisible = false;
		boolean btnTestCVSVisible = false;
		boolean btnTestFTPVisible = false;
		boolean btnTestIndexVisible = false;
		boolean parBiGenUpdate = "true".equals(dBean.getParValue(col,"prmtBIGeneralUpdate")); 
		boolean parBiEntUpdate = "true".equals(dBean.getParValue(col,"prmtBIEntitiesUpdate"));
		boolean parBiProUpdate = "true".equals(dBean.getParValue(col,"prmtBIProcessUpdate"));
		boolean parBiExecAnywhere = "true".equals(dBean.getParValue(col,"prmtBIExecAnywhere"));
		boolean biInstalled = Parameters.BI_INSTALLED;
		boolean biCorrectlyInstalled = Parameters.BI_INSTALLED && BIEngine.biCorrectlyInstalled();
		
		while (iterator.hasNext()) {
			obj = iterator.next();

			if (obj instanceof ParametersVo) {
				param = (ParametersVo) obj; 
				if(param.getPrmType()!=ParametersVo.PARAM_TYPE_BUTTON && param.getPrmType()!=ParametersVo.PARAM_TYPE_BI_GRID_VALUE && param.getPrmType()!=ParametersVo.PARAM_TYPE_BI_DEFAULT_VIEWS){
					buffer.append("<tr>");
					buffer.append("<td style=\"white-space:nowrap;width:50%\" title=\"" +LabelManager.getToolTip(labelSet,param.getParameterId()) + "\">" + LabelManager.getNameWAccess(labelSet,param.getParameterId()) + ":</td>");
					buffer.append("<td style=\"width:50%\">");
				}else{
					buffer.replace(buffer.length()-11, buffer.length()-1, "");
				}
				switch (param.getPrmType()) {
					case ParametersVo.PARAM_TYPE_BOOLEAN :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						if (param.getParameterValue()==null || ! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if ("true".equals(param.getParameterValue())) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if ("false".equals(param.getParameterValue())) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;
					case ParametersVo.PARAM_TYPE_BOOLEAN_INIT_PROC:
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"fncChangeInitProc()\">");
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if ("true".equals(param.getParameterValue())) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if ("false".equals(param.getParameterValue())) {
							buffer.append("selected"); 
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;							
					case ParametersVo.PARAM_TYPE_BOOLEAN_ESCAPE_LIKE:
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"fncChangeEscape()\">");
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if ("true".equals(param.getParameterValue())) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if ("false".equals(param.getParameterValue())) {
							buffer.append("selected"); 
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;							
					case ParametersVo.PARAM_TYPE_CHAT_STATUS :
						int index = param.getParameterValue().indexOf("-");
						
						boolean commandsOk = "true".equals(param.getParameterValue().substring(0, index));
						boolean transferOk = "true".equals(param.getParameterValue().substring(index + 1));
						
						if (commandsOk) {
							buffer.append("<span style='color:green'>" + LabelManager.getName(labelSet,"lblYes") + "</span>");
						} else {
							buffer.append("<span style='color:red'>" + LabelManager.getName(labelSet,"lblNo") + "</span> ");
						}
						buffer.append(" - ");
						if (transferOk) {
							buffer.append("<span style='color:green'>" + LabelManager.getName(labelSet,"lblYes") + "</span>");
						} else {
							buffer.append("<span style='color:red'>" + LabelManager.getName(labelSet,"lblNo") + "</span> ");
						}
						
						if (! commandsOk) {
							buffer.append("&nbsp;&nbsp;&nbsp;");
							buffer.append("<button id=\"" +param.getParameterId() + "\" type=\"button\" onClick=\"chatActiviate('" + LabelManager.getName(labelSet,"msgChatActivateWar") + "');\" title=\"" + LabelManager.getToolTip(labelSet,"btnChatActivate") + "\">" + LabelManager.getToolTip(labelSet,"btnChatActivate") + "</button> ");
						}
						break;	
					case ParametersVo.PARAM_TYPE_BOOLEAN_CHAT :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"fncChangeChat()\">");
						if(param.getParameterValue()!=null){
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						}else{
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if ("true".equals(param.getParameterValue())) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if ("false".equals(param.getParameterValue())) {
							buffer.append("selected"); 
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;	
					case ParametersVo.PARAM_TYPE_BOOLEAN_CHAT_SAVE :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"fncChangeChatSave()\">");
						//----
						if(param.getParameterValue()!=null){
							if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
								buffer.append("<option value=\"\" selected></option>");
							}
						}else{
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if ("true".equals(param.getParameterValue())) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if ("false".equals(param.getParameterValue())) {
							buffer.append("selected"); 
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;	
					case ParametersVo.PARAM_TYPE_BOOLEAN_CHAT_INDEX :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"fncChangeChatIndex()\">");
						if(param.getParameterValue()!=null){
							if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
								buffer.append("<option value=\"\" selected></option>");
							}
						}else{
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if ("true".equals(param.getParameterValue())) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if ("false".equals(param.getParameterValue())) {
							buffer.append("selected"); 
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;	
					case ParametersVo.PARAM_TYPE_BOOLEAN_DOC_INDEX :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='docIndexOnchange()' >");
						if (param.getParameterValue()==null || ! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if ("true".equals(param.getParameterValue())) {
							buffer.append(" selected ");
							btnTestIndexVisible = true;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if ("false".equals(param.getParameterValue())) {
							buffer.append(" selected ");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;

					case ParametersVo.PARAM_TYPE_BOOLEAN_DOC_ENCRIPTION :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='docEncOnchange()' >");
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if (param.getParameterValue().equals("true")) {
							buffer.append(" selected ");
							btnTestIndexVisible = true;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if (param.getParameterValue().equals("false")) {
							buffer.append(" selected ");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;
						
					case ParametersVo.PARAM_TYPE_BI_STATUS:
						if (biInstalled){
							if (BIEngine.biCorrectlyInstalled()){
								buffer.append("<span style=\"color:green\">"+ LabelManager.getName(labelSet,"lblBIStatusOk")+"</span>");
							}else{
								buffer.append("<span style=\"color:red\">"+ LabelManager.getName(labelSet,"lblBIStatusNOk")+"</span>");						
								buffer.append("<button type=\"button\" onClick=\"alert('" + BIEngine.getBIConfErrorMsg(labelSet) + "')\" title=\"" + LabelManager.getToolTip(labelSet,"btnVer") + "\">" + LabelManager.getToolTip(labelSet,"btnVer") + "</button> ");
							}
						}else{
							buffer.append("<span style=\"color:red\">"+ LabelManager.getName(labelSet,"lblBINotInstalled")+"</span>");	
						}
						
						break;	
					case ParametersVo.PARAM_TYPE_BOOLEAN_BI_GEN_UPDATE :
						if (BIEngine.biCorrectlyInstalled()){ //Si la configuracion del bi es correcta --> esta el bi instalado
							buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='prmtBIgenUpdate()' >");
						}else{//la configuracion del bi no es correcta --> no esta instalado
							buffer.append("<select disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='prmtBIgenUpdate()' >");							
						}
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if (param.getParameterValue().equals("true")) {
							buffer.append("selected");
							parBiGenUpdate = true;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if (param.getParameterValue().equals("false")) {
							buffer.append("selected");
							parBiGenUpdate = false;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;
						
					case ParametersVo.PARAM_TYPE_BOOLEAN_BI_EXEC_ANYWHERE :
						if (BIEngine.biCorrectlyInstalled()){ //Si la configuracion del bi es correcta --> esta el bi instalado
							buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='fncBIExecAnywhere()' >");
						}else{//la configuracion del bi no es correcta --> no esta instalado
							buffer.append("<select disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='fncBIExecAnywhere()' >");							
						}
						if (param.getParameterValue() == null || ! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						
						if (param.getParameterValue() == null) param.setParameterValue("");
						
						buffer.append("<option value=\"true\"");
						if (param.getParameterValue().equals("true")) {
							buffer.append("selected");
							parBiExecAnywhere = true;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if (param.getParameterValue().equals("false")) {
							buffer.append("selected");
							parBiExecAnywhere = false;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;
					
					case ParametersVo.PARAM_TYPE_BI_QUEUE_IMPLEMENTATION :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						for(int i = 0; i < BIUpdProQueueSender.queueImplementations.length; i++){
							buffer.append("<option value=\"" + EmailQueueSender.queueImplementations[i] + "\"");
							if (param.getParameterValue().equals(EmailQueueSender.queueImplementations[i])) {
								buffer.append("selected");
							}
							buffer.append(">" + EmailQueueSender.queueImplementations[i] + "</option>");
						}
						buffer.append("</select>");
						break;
						
					case ParametersVo.PARAM_TYPE_BOOLEAN_BI_ENT_UPDATE :
						if (BIEngine.biCorrectlyInstalled() && parBiGenUpdate){ //Si la configuracion del bi es correcta --> esta el bi instalado
							buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId())  + "\" onchange='prmtBIEntUpdate()' >");
						}else{//la configuracion del bi no es correcta --> no esta instalado
							buffer.append("<select disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='prmtBIEntUpdate()' >");					
						}
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if (param.getParameterValue().equals("true")) {
							buffer.append("selected");
							parBiEntUpdate = true;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if (param.getParameterValue().equals("false")) {
							buffer.append("selected");
							parBiEntUpdate = false;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;
					
					case ParametersVo.PARAM_TYPE_BI_ACTION_ON_ERROR:
						if (BIEngine.biCorrectlyInstalled() && parBiGenUpdate && parBiEntUpdate){ //Si la configuracion del bi es correcta --> esta el bi instalado
							buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						}else{
							buffer.append("<select disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						}
						
						buffer.append("<option value=\"0\"");
						if (param.getParameterValue().equals("0")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParBIOnErrActLog") + "</option>");
						
						buffer.append("<option value=\"1\"");
						if (param.getParameterValue().equals("1")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParBIOnErrActException") + "</option>");
						buffer.append("</select>");
						
						break;

					case ParametersVo.PARAM_TYPE_BI_VERIFIE_ENT_CUBE_UPDATE:
						if (BIEngine.biCorrectlyInstalled()){ //Si la configuracion del bi es correcta --> esta el bi instalado
							buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						}else{
							buffer.append("<select disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						}
						
						buffer.append("<option value=\"0\"");
						if (param.getParameterValue().equals("0")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblBIAutomatic") + "</option>");
						
						buffer.append("<option value=\"1\"");
						if (param.getParameterValue().equals("1")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblBINever") + "</option>");
						
						buffer.append("<option value=\"2\"");
						if (param.getParameterValue().equals("2")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblBIAlways") + "</option>");
						
						buffer.append("</select>");
						
						break;	
						
					case ParametersVo.PARAM_TYPE_BOOLEAN_BI_PRO_UPDATE :
						if (BIEngine.biCorrectlyInstalled() && parBiGenUpdate){ //Si la configuracion del bi es correcta --> esta el bi instalado
							buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='prmtBIProUpdate()' >");
						}else{//la configuracion del bi no es correcta --> no esta instalado
							buffer.append("<select disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");							
						}
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if (param.getParameterValue().equals("true")) {
							buffer.append("selected");
							parBiProUpdate = true;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if (param.getParameterValue().equals("false")) {
							buffer.append("selected");
							parBiProUpdate = false;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;	
					case ParametersVo.PARAM_TYPE_BI_UPD_PRO_METHOD:
						if (BIEngine.biCorrectlyInstalled() && parBiGenUpdate && parBiProUpdate){ //Si la configuracion del bi es correcta --> esta el bi instalado
							buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='prmtBIProUpdMethFunc()' >");
						}else{
							buffer.append("<select disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange='prmtBIProUpdMethFunc()' >");
						}
						
						buffer.append("<option value=\"0\"");
						if (param.getParameterValue().equals("0")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblSch") + "</option>");
						
						buffer.append("<option value=\"1\"");
						if (param.getParameterValue().equals("1")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblMsgQueue") + "</option>");
						buffer.append("</select>");
						
						break;
					
					case ParametersVo.PARAM_TYPE_BI_COLOR:
						if (param.getParameterValue()!=null){
							buffer.append("<input type=\"input\" id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" style=\"width:60px\" class=\"txtReadonly\" readonly value=\""+ param.getParameterValue() + "\"/><a href=\"#\" onclick=\"colorPicker(this)\"><img width=\"15\" height=\"13\" border=\"0\" src=\"" + Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/palette.gif\"></a><input maxlength=\"0\" type=\"text\" size=\"2\" style=\"width:60px;background-color:" + param.getParameterValue() + ";\"></input>");
							if ("prmtBISerie1Color".equals(param.getParameterId())){
								buffer.append("<td align=\"left\" title=\"" + LabelManager.getToolTip("lblDefSer1Color") + "\">" + LabelManager.getName(labelSet,"lblDefSer1Color") + "</td>");
							}else if ("prmtBISerie2Color".equals(param.getParameterId())){
								buffer.append("<td align=\"left\" title=\"" + LabelManager.getToolTip("lblDefSer2Color") + "\">" + LabelManager.getName(labelSet,"lblDefSer2Color") + "</td>");
							}else if ("prmtBISerie3Color".equals(param.getParameterId())){
								buffer.append("<td align=\"left\" title=\"" + LabelManager.getToolTip("lblDefSer3Color") + "\">" + LabelManager.getName(labelSet,"lblDefSer3Color") + "</td>");
							}else if ("prmtBISerie4Color".equals(param.getParameterId())){
								buffer.append("<td align=\"left\" title=\"" + LabelManager.getToolTip("lblDefSer4Color") + "\">" + LabelManager.getName(labelSet,"lblDefSer4Color") + "</td>");
							}else if ("prmtBISerie5Color".equals(param.getParameterId())){
								buffer.append("<td align=\"left\" title=\"" + LabelManager.getToolTip("lblDefSer5Color") + "\">" + LabelManager.getName(labelSet,"lblDefSer5Color") + "</td>");
							}
						}
						break;
					case ParametersVo.PARAM_TYPE_BI_GRID_VALUE:
						//Formato del parametro: <parPrefix>_<IDAMBIENTE>_<IND_CBE_ENV>_<IND_CBE_ALL_ENV>_<PRF_ID>-<parPrefix>_<IDAMBIENTE>_<IND_CBE_ENV>_<IND_CBE_ALL_ENV>_<PRF_ID>-..
						////Ejemplo: "prmtBIEnv_1_1_0_1001-prmtBIEnv_1001_0_1_1001-prmtBIEnv_1002_1_1_1001"
						String values[] = param.getParameterValue().split("-");
						HashMap hashEnvs = dBean.getAllEnvironments(); //Obtenemos todos los ambientes en un hash
						Collection colPrfs = dBean.getAllProfiles(); //Obtenemos todos los perfiles en una collection
						
						buffer.append("<div type=\"grid\" id=\"gridBIParams\" style=\"height:200px\" >");
						buffer.append("<table width=\"500px\" cellpadding=\"0\" cellspacing=\"0\">");
						buffer.append("<thead>");
				   		buffer.append("<tr>");
				   		buffer.append("<th style=\"width:0px;display:none;\"></th>");
				   		buffer.append("<th min_width=\"200px\" style=\"min-width:120px;width:60%\" title=\"" + LabelManager.getToolTip(labelSet,"lblEnvs") + "\">" + LabelManager.getName(labelSet,"lblEnvs") +"</th>");
				   		buffer.append("<th min_width=\"180px\" style=\"width:180px\" title=\"" + LabelManager.getToolTip(labelSet,"titEnvCube") + "\">" + LabelManager.getName(labelSet,"titEnvCube") +"</th>");
				   		buffer.append("<th min_width=\"180px\" style=\"width:180px\" title=\"" + LabelManager.getToolTip(labelSet,"titAllEnvCube") + "\">" + LabelManager.getName(labelSet,"titAllEnvCube") +"</th>");
				   		buffer.append("<th min_width=\"120px\" style=\"min-width:120px;width:40%\" title=\"" + LabelManager.getToolTip(labelSet,"titInitCbeProfile") + "\">" + LabelManager.getName(labelSet,"titInitCbeProfile") +"</th>");
				   		buffer.append("</tr>");
				   		buffer.append("</thead>");
				   		buffer.append("<tbody>");
				   		for (int i=0;i<values.length;i++){
					   		buffer.append("<tr>");
					   		String strValues[] = values[i].split("_"); //<parPrefix>_<envId>_<IND_CBE_ENV>_<IND_CBE_ALL_ENV>_<prfId>
							EnvironmentVo envVo = (EnvironmentVo)hashEnvs.get(new Integer(strValues[1]));
							String envId = (strValues.length > 1) ? strValues[1] : "";
					   		String envCbe = (strValues.length > 2) ? strValues[2] : null;
					   		String allEnvCbe = (strValues.length > 3) ? strValues[3] : null;
					   		String prfId = (strValues.length > 4) ? strValues[4] : null;
					   		String envName = (envVo!=null)?envVo.getEnvName():"";
							
					   		buffer.append("<td style=\"width:0px;display:none;\"><input type=\"hidden\" /></td>");
					   		
					   		//Columna 1 con el nombre del ambiente y el id del ambiente oculto
					   		buffer.append("<td style=\"min-width:120px\">"+ envName);
					   		buffer.append("<input type=\"hidden\" name=\"hidEnvId\" value=\"" + envId +"\" />");
					   		buffer.append("</td>");
					   		
					   		//Columna 2 con un checkbox para indicar si existe un cubo en el ambiente con datos del ambiente
					   		buffer.append("<td style=\"width:180px\">");
					   		if ("1".equals(envCbe)){
					   			if (biCorrectlyInstalled && !"1".equals(envId)){
									buffer.append("<input type=\"checkbox\" id=\"chkboxEnvCbe" + i + "\" name=\"chkboxEnvCbe" + i + "\" onClick=\"chkEnvCbe(this)\" checked name=\"hasEnvCbe\" ></td>");					   			
					   			}else{
					   				buffer.append("<input type=\"checkbox\" id=\"chkboxEnvCbe" + i + "\" name=\"chkboxEnvCbe" + i + "\" onClick=\"chkEnvCbe(this)\" checked disabled name=\"hasEnvCbe\" ></td>");					   			
					   			}
					   		}else{
					   			if (biCorrectlyInstalled){
									buffer.append("<input type=\"checkbox\" id=\"chkboxEnvCbe" + i + "\" name=\"chkboxEnvCbe" + i + "\" onClick=\"chkEnvCbe(this)\" name=\"hasEnvCbe\" ></td>");					   			
					   			}else{
					   				buffer.append("<input type=\"checkbox\" id=\"chkboxEnvCbe" + i + "\" name=\"chkboxEnvCbe" + i + "\" onClick=\"chkEnvCbe(this)\" disabled name=\"hasEnvCbe\" ></td>");					   			
					   			}
					   		}
					   		
					   		//Columna 3 con un checkbox para indicar si existe un cubo en el ambiente con datos de todos los ambientes
							if ("1".equals(allEnvCbe)){
								if (biCorrectlyInstalled){
									buffer.append("<td style=\"width:180px\"><input type=\"checkbox\" name=\"chkboxAllEnvCbe" + i + "\" id=\"chkboxAllEnvCbe" + i + "\" onClick=\"chkAllEnvCbe(this)\" checked name=\"hasAllEnvCbe\" ></td>");
								}else{
									buffer.append("<td style=\"width:180px\"><input type=\"checkbox\" name=\"chkboxAllEnvCbe" + i + "\" id=\"chkboxAllEnvCbe" + i + "\" onClick=\"chkAllEnvCbe(this)\" checked disabled name=\"hasAllEnvCbe\" ></td>");
								}
							}else{
								if (biCorrectlyInstalled){
									buffer.append("<td style=\"width:180px\"><input type=\"checkbox\" name=\"chkboxAllEnvCbe" + i + "\" id=\"chkboxAllEnvCbe" + i + "\" onClick=\"chkAllEnvCbe(this)\" name=\"hasAllEnvCbe\" ></td>");
								}else{
									buffer.append("<td style=\"width:180px\"><input type=\"checkbox\" name=\"chkboxAllEnvCbe" + i + "\" id=\"chkboxAllEnvCbe" + i + "\" onClick=\"chkAllEnvCbe(this)\" disabled name=\"hasAllEnvCbe\" ></td>");
								}
							}
					   		
					   		//Columna 4 con un combo para seleccionar el perfil que tendra/tubo acceso la primera vez
							buffer.append("<td style=\"min-width:120px\">");
							if (biCorrectlyInstalled){
						   		buffer.append("<select id=\"prfCbe\" name=\"prfCbe\">");
							}else{
								buffer.append("<select disabled id=\"prfCbe\" name=\"prfCbe\">");
							}
							buffer.append("<option value=\"0\"></option>");
							Iterator itPrfs = colPrfs.iterator();
	   						while (itPrfs.hasNext()) {
	   							ProfileVo prfVo = (ProfileVo) itPrfs.next();
		   						buffer.append("<option value=\"" + prfVo.getPrfId() + "\"");
  								if (prfId != null && prfVo.getPrfId().intValue() == Integer.parseInt(prfId)){
									buffer.append("selected");
	   							}
	   							buffer.append(">" + prfVo.getPrfName() + "</option>");
		   					}
							buffer.append("</select></td></tr>");
				   		}
			   			buffer.append("</tbody>");
			   			buffer.append("</table>");
				   		buffer.append("</div><br/>");
				   		
				   		break;	

					case ParametersVo.PARAM_TYPE_BI_DEFAULT_VIEWS:
						
						buffer.append("<div type=\"grid\" id=\"gridBIParDefVws\" style=\"height:200px\" >");
						buffer.append("<table width=\"500px\" cellpadding=\"0\" cellspacing=\"0\">");
						buffer.append("<thead>");
				   		buffer.append("<tr>");
				   		buffer.append("<th style=\"width:0px;display:none;\"></th>");
				   		buffer.append("<th min_width=\"250px\" style=\"min-width:250px;width:60%\" title=\"" + LabelManager.getToolTip(labelSet,"lblCube") + "\">" + LabelManager.getName(labelSet,"lblCube") +"</th>");
				   		buffer.append("<th min_width=\"200px\" style=\"min-width:200px;width:40%\" title=\"" + LabelManager.getToolTip(labelSet,"lblDefView") + "\">" + LabelManager.getName(labelSet,"lblDefView") +"</th>");
				   		buffer.append("</tr>");
				   		buffer.append("</thead>");
				   		buffer.append("<tbody>");
						
				   		if (biCorrectlyInstalled){
	//						Formato del parametro: prmtBIDefaultVw_<CUBE_ID>_<VIEW_ID>-prmtBIDefaultVw_<CUBE_ID>_<VIEW_ID>..
							////Ejemplo: "prmtBIDefaultVw_1001_1001-prmtBIDefaultVw_1002_1031-prmtBIEnv_1003_1033"
							String vals[] = param.getParameterValue().split("-");
							HashMap hashCubes = dBean.getAllCubes(); //Obtenemos todos los cubos en un hash
							HashMap hashCbeViews = dBean.getAllCubeViews(); //Obtenemos todas las vistas de los cubos
							String envName = null;
							
					   		for (int i=0;i<vals.length;i++){
						   		buffer.append("<tr>");
						   		String strValues[] = vals[i].split("_"); //<parPrefix>_<cubeId>_<viewId>
						   		if (strValues.length != 3) continue; //no procesarlo, no tiene la cantidad de parámetros requerida
						   		CubeVo cbeVo = null;
						   		try {
									cbeVo = (CubeVo)hashCubes.get(new Integer(strValues[1]));
						   		}catch (Exception e){
						   			continue;
						   		}
								String cbeId = strValues[1];
						   		String viewId = strValues[2];
						   		String cbeTitle = "";
						   		String cbeDesc = "";
						   		envName = dBean.getEnvName(cbeVo.getCubeId());
						   		
						   		if (cbeVo.getCubeTitle().startsWith("lblDw") || cbeVo.getCubeTitle().startsWith("mnuDw")){
									if (cbeVo.getCubeTitle().indexOf(")") > 0){		
										cbeTitle = LabelManager.getToolTip(labelSet, cbeVo.getCubeTitle().substring(0, cbeVo.getCubeTitle().indexOf("(") - 1)) + " " + cbeVo.getCubeTitle().substring(cbeVo.getCubeTitle().indexOf("("), cbeVo.getCubeTitle().length());						
									}else{
										cbeTitle = LabelManager.getToolTip(labelSet, cbeVo.getCubeTitle()) + " (" + envName + ")";
									}
								}else{
									cbeTitle = dBean.fmtHTML(cbeVo.getCubeTitle());
								}
								
								if (cbeVo.getCubeDesc()!=null){
									if (cbeVo.getCubeDesc().startsWith("lblDw") || cbeVo.getCubeDesc().startsWith("mnuDw")){
										if (cbeVo.getCubeDesc().indexOf(")") > 0){	
											cbeDesc = LabelManager.getToolTip(labelSet, cbeVo.getCubeDesc().substring(0, cbeVo.getCubeDesc().indexOf("(") - 1)) + " " + cbeVo.getCubeDesc().substring(cbeVo.getCubeDesc().indexOf("("), cbeVo.getCubeDesc().length());		
										}else{
											cbeDesc = LabelManager.getToolTip(labelSet, cbeVo.getCubeDesc()) + " (" + envName + ")";
										}
									}else{
										cbeDesc = dBean.fmtHTML(cbeVo.getCubeDesc());
									}
								}
								
						   		buffer.append("<td style=\"width:0px;display:none;\"><input type=\"hidden\" /></td>");
						   		
						   		//Columna 1 con el nombre del cubo y el id del ambiente oculto
						   		buffer.append("<td style=\"min-width:250px\" title=\"" + cbeDesc + "\">"+ cbeTitle);
						   		buffer.append("<input type=\"hidden\" name=\"hidCbeId\" value=\"" + cbeId +"\" />");
						   		buffer.append("</td>");
						   		
						   		//Columna 2 con un combo para seleccionar la vista por defecto del cubo
								buffer.append("<td style=\"min-width:200px\">");
								if (biCorrectlyInstalled){
							   		buffer.append("<select id=\"defVwCmb\" name=\"defVwCmb\">");
								}else{
									buffer.append("<select disabled id=\"defVwCmb\" name=\"defVwCmb\">");
								}
								Collection colViews = (Collection) hashCbeViews.get(new Integer(cbeId));
								if (colViews!=null && colViews.size()>0){
									Iterator itVws = colViews.iterator();
			   						while (itVws.hasNext()) {
			   							CubeViewVo cbeVwVo = (CubeViewVo) itVws.next();
				   						buffer.append("<option value=\"" + cbeVwVo.getVwId() + "\"");
		  								if (cbeVwVo.getInitialView().intValue() == 1){
											buffer.append("selected");
			   							}
			   							buffer.append(">" + cbeVwVo.getVwName() + "</option>");
				   					}
								}
								buffer.append("</select></td></tr>");
					   		}
				   		}
			   			buffer.append("</tbody>");
			   			buffer.append("</table>");
				   		buffer.append("</div>");
						
						break;
					//El valor para valor nulo del bi debe ser por cubo, ya que si se cambia habria que actualizar todos los cubos (no descomentar esto)
					//case ParametersVo.PARAM_TYPE_BI_NULL_VALUE:
					//	if (BIEngine.biCorrectlyInstalled() == 0 && parBiGenUpdate){ //Si la configuracion del bi es correcta y se eligio actualizacion--> esta el bi instalado
					//		buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" maxlength=\"255\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
					//	}else{
					//		buffer.append("<input disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" maxlength=\"255\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
					//	}
					//break;	

					case ParametersVo.PARAM_TYPE_AUTH_TYPE:
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"prmtAutMethod_onchange()\">");
						
						buffer.append("<option value=\"0\"");
						if (param.getParameterValue().equals("0")) {
							buffer.append("selected");
						}
						buffer.append(">APIA</option>");
						
						buffer.append("<option value=\"1\"");
						if (param.getParameterValue().equals("1")) {
							btnTestAuthVisible = true;
							buffer.append("selected");
						}
						buffer.append(">APIA LDAP</option>");
						
						buffer.append("<option value=\"2\"");
						if (param.getParameterValue().equals("2")) {
							btnTestAuthVisible = true;
							buffer.append("selected");
						}
						buffer.append(">LDAP</option>");
						
						buffer.append("<option value=\"3\"");
						if (param.getParameterValue().equals("3")) {
							buffer.append("selected");
						}
						buffer.append(">EXTERNAL VALIDATION</option>");
						
		
											
						buffer.append("</select>");
						
						break;	
	
					case ParametersVo.PARAM_TYPE_DOC_TYPE:
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"prmtDocType_onchange()\">");
						
						buffer.append("<option value=\"0\"");
						if (param.getParameterValue().equals("0")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParDocTipArc") + "</option>");
						
						buffer.append("<option value=\"1\"");
						if (param.getParameterValue().equals("1")) {
							buffer.append("selected");
							btnTestCVSVisible = true;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParDocTipCVS") + "</option>");
						
						buffer.append("<option value=\"2\"");
						if (param.getParameterValue().equals("2")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParDocTipDBDoc") + "</option>");
						
						buffer.append("<option value=\"3\"");
						if (param.getParameterValue().equals("3")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParDocTipFTP") + "</option>");
												
						buffer.append("<option value=\"4\"");
						if (param.getParameterValue().equals("4")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParDocTipSFTP") + "</option>");
						
						
						buffer.append("</select>");
						
						break;	
					
					case ParametersVo.PARAM_TYPE_BOOLEAN_SIGNON :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"prmtSignOn_onchange()\" >");
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if (param.getParameterValue().equals("true")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if (param.getParameterValue().equals("false")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;
	
	
					case ParametersVo.PARAM_TYPE_AUTH_FULL:
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" >");
						buffer.append("<option value=\"false\"");
						if (param.getParameterValue().equals("false")) {
							buffer.append("selected");
						}
						buffer.append(">LOGIN</option>");
						
						buffer.append("<option value=\"true\"");
						if (param.getParameterValue().equals("true")) {
							buffer.append("selected");
						}
						buffer.append(">FULL</option>");
	
						buffer.append("</select>");
						break;	
	
					case ParametersVo.PARAM_TYPE_LOG_LEVEL :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
	
						buffer.append("<option value=\"DEBUG\"");
						if (param.getParameterValue().equals("DEBUG")) {
							buffer.append("selected");
						}
						buffer.append(">DEBUG</option>");
	
						buffer.append("<option value=\"ERROR\"");
						if (param.getParameterValue().equals("ERROR")) {
							buffer.append("selected");
						}
						buffer.append(">ERROR</option>");
	
						buffer.append("<option value=\"NOTICE\"");
						if (param.getParameterValue().equals("NOTICE")) {
							buffer.append("selected");
						}
						buffer.append(">NOTICE</option>");
	
						buffer.append("<option value=\"PANIC\"");
						if (param.getParameterValue().equals("PANIC")) {
							buffer.append("selected");
						}
						buffer.append(">PANIC</option>");
	
						buffer.append("<option value=\"PHASE\"");
						if (param.getParameterValue().equals("PHASE")) {
							buffer.append("selected");
						}
						buffer.append(">PHASE</option>");
	
						buffer.append("<option value=\"TRACE\"");
						if (param.getParameterValue().equals("TRACE")) {
							buffer.append("selected");
						}
						buffer.append(">TRACE</option>");
	
						buffer.append("<option value=\"WARNING\"");
						if (param.getParameterValue().equals("WARNING")) {
							buffer.append("selected");
						}
						buffer.append(">WARNING</option>");
	
						buffer.append("</select>");
						break;
	
					case ParametersVo.PARAM_TYPE_QUERY_FILTER:
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						
						buffer.append("<option value=\"" + com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_EQUAL + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_EQUAL))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,LabelConstants.LBL_QRY_FIL_EQU) + "</option>");
						
						buffer.append("<option value=\"" + com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_STARTS_WITH + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_STARTS_WITH))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,LabelConstants.LBL_QRY_FIL_LIK_RIG) + "</option>");
						
						buffer.append("<option value=\"" + com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_ENDS_WITH + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_ENDS_WITH))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,LabelConstants.LBL_QRY_FIL_LIK_LEF) + "</option>");
						
						buffer.append("<option value=\"" + com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_LIKE + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_LIKE))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,LabelConstants.LBL_QRY_FIL_LIK) + "</option>");

						//---------------
						
						buffer.append("<option value=\"" + com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_NOT_EQUAL + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_NOT_EQUAL))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,LabelConstants.LBL_QRY_FIL_NOT_EQU) + "</option>");

						buffer.append("<option value=\"" + com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_NOT_STARTS_WITH + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_NOT_STARTS_WITH))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,LabelConstants.LBL_QRY_FIL_NOT_LIK_RIG) + "</option>");

						buffer.append("<option value=\"" + com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_NOT_ENDS_WITH + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_NOT_ENDS_WITH))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,LabelConstants.LBL_QRY_FIL_NOT_LIK_LEF) + "</option>");

						buffer.append("<option value=\"" + com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_NOT_LIKE + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.filter.QryColumnFilterVo.STRING_TYPE_NOT_LIKE))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,LabelConstants.LBL_QRY_FIL_NOT_LIK) + "</option>");

						//---------------
						
						buffer.append("</select>");
						break;
						
					case ParametersVo.PARAM_TYPE_STRING :
						buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" maxlength=\"255\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;
					case ParametersVo.PARAM_TYPE_STRING_NOT_REQUIRED :
						buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" maxlength=\"255\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;
					case ParametersVo.PARAM_TYPE_STRING_DISABLED :
						buffer.append("<input disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" maxlength=\"255\" size=\"40\" type=\"text\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;						
					
					case ParametersVo.PARAM_TYPE_DEF_LANG :
					
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						
						/*
						buffer.append("<option value=\"" + com.dogma.vo.LanguageVo.LANG_SP + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.LanguageVo.LANG_SP))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblIdiEsp") + "</option>");
						
						buffer.append("<option value=\"" + com.dogma.vo.LanguageVo.LANG_PT + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.LanguageVo.LANG_PT))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblIdiPor") + "</option>");

						buffer.append("<option value=\"" + com.dogma.vo.LanguageVo.LANG_EN + "\"");
						if (param.getParameterValue().equals(Integer.toString(com.dogma.vo.LanguageVo.LANG_EN))) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblIdiIng") + "</option>");
						*/
						
						Collection c = Parameters.getLanguages(); 
          				if(c!=null){
          					Iterator it = c.iterator();
          					while(it.hasNext()){
          						LanguageVo l = (LanguageVo)it.next();
          						buffer.append("<option value=\"" + l.getLangId() + "\"");
          						if (param.getParameterValue().equals(Integer.toString(l.getLangId()))) {
          							buffer.append("selected");
          						}
          						buffer.append(">" + l.getLangName() + "</option>");
          					}
          				}
						
						buffer.append("</select>");
						break;
					
					case ParametersVo.PARAM_TYPE_DEF_LBL_SET :
						
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						
						Collection colLbl = dBean.getLabelSets();
						if(colLbl!=null){
							Iterator itLblSet = colLbl.iterator();
							while(itLblSet.hasNext()){
								LblSetVo lblSetVo = (LblSetVo)itLblSet.next();
								buffer.append("<option value=\"" + lblSetVo.getLblSetId() + "\"");
								if (param.getParameterValue().equals(lblSetVo.getLblSetId().toString())) {
									buffer.append("selected");
								}
								buffer.append(">" + lblSetVo.getLblSetName() + "</option>");
							}
						}
						
						
						buffer.append("</select>");
						break;
						
					case ParametersVo.PARAM_TYPE_CHAR :
						buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" maxlength=\"1\" size=\"3\" type=\"text\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;
	
					case ParametersVo.PARAM_TYPE_NUMBER :
						buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" type=\"text\" maxlength=9 value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" p_required=true p_numeric='true'  accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;
					case ParametersVo.PARAM_TYPE_BUTTON :
						if((param.getParameterId().equals("btnTestAuth") && !btnTestAuthVisible) ||
							(param.getParameterId().equals("btnTestCVS") && !btnTestCVSVisible) ||
							(param.getParameterId().equals("btnTestIndexDoc") && !btnTestIndexVisible) ||
							(param.getParameterId().equals("btnTestFTP") && !btnTestFTPVisible)){
							buffer.append("<button id=\"" + param.getParameterId() + "\" style=\"visibility:hidden\" type=\"button\" onclick=\"" + param.getParameterValue() + "_click()\" accesskey=\""+ LabelManager.getAccessKey(labelSet,param.getParameterValue()) + "\" title=\"" + LabelManager.getToolTip(labelSet,param.getParameterValue()) + "\">" + LabelManager.getNameWAccess(labelSet,"btnTest") + "</button>");							
						}else{
							buffer.append("<button id=\"" + param.getParameterId() + "\" type=\"button\" onclick=\"" + param.getParameterValue() + "_click()\" accesskey=\""+ LabelManager.getAccessKey(labelSet,param.getParameterValue()) + "\" title=\"" + LabelManager.getToolTip(labelSet,param.getParameterValue()) + "\">" + LabelManager.getNameWAccess(labelSet,"btnTest") + "</button>");
						}
						break;
					case ParametersVo.PARAM_TYPE_NUMBER_NOT_RQUIRED :
						buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" type=\"text\" maxlength=9 value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\"  p_numeric='true'  accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;
					case ParametersVo.PARAM_TYPE_PASSWORD :
						buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" type=\"password\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" p_required=true  accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;
					case ParametersVo.PARAM_TYPE_PASSWORD_NOT_REQUIRED :
						buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" type=\"password\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;
					case ParametersVo.PARAM_TYPE_PASSWORD_DISABLED :
						buffer.append("<input disabled id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" type=\"password\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						break;
					case ParametersVo.PARAM_TYPE_PASS_NOT_REQ_WITH_HID_INPUT :
						buffer.append("<input id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() + "\" type=\"password\" value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						buffer.append("<input id=\"" + param.getParameterId() + "_hidden" + "\" name=\"" + param.getParameterId() + "_hidden" + "\" type=\"text\"value=\"" + dBean.fmtHTML(param.getParameterValue()) + "\" style=\"visibility:hidden\">");
						break;
					case ParametersVo.PARAM_TYPE_QUEUE_IMPLEMENTATION :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"prmtQueImpl_onchange()\">");
						for(int i = 0; i < EmailQueueSender.queueImplementations.length; i++){
							buffer.append("<option value=\"" + EmailQueueSender.queueImplementations[i] + "\"");
							if (param.getParameterValue().equals(EmailQueueSender.queueImplementations[i])) {
								buffer.append("selected");
							}
							buffer.append(">" + EmailQueueSender.queueImplementations[i] + "</option>");
						}
						buffer.append("</select>");
						break;
					case ParametersVo.PARAM_TYPE_BOOLEAN_USE_QUEUE :
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\" onchange=\"prmtUseQueue_onchange()\">");
						if (! (param.getParameterValue().equals("true") || param.getParameterValue().equals("false"))) {
							buffer.append("<option value=\"\" selected></option>");
						}
						buffer.append("<option value=\"true\"");
						if (param.getParameterValue().equals("true")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblYes") + "</option>");
						buffer.append("<option value=\"false\"");
						if (param.getParameterValue().equals("false")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblNo") + "</option>");
						buffer.append("</select>");
						break;
						
					case ParametersVo.PARAM_TYPE_INACTIVITY_PERIOD:
						buffer.append("<table>");
						buffer.append("<tr>");
						buffer.append("<th style='width:100px'>"+LabelManager.getName(labelSet,"lblDia")+"</th>");
						buffer.append("<th style='width:50px'>"+LabelManager.getName(labelSet,"lblHoraIni")+"</th>");
						buffer.append("<th style='width:0px;display:none'></th>");
						buffer.append("<th style='width:50px'>"+LabelManager.getName(labelSet,"lblInactDur")+"</th>");
						buffer.append("</tr>");
						
						String data = (String)InactivityPeriod.getInstance().getData().get(Integer.valueOf(1));
						String hour=""; String lapse="";
						if(data!=null){
							hour=data.split("-")[0];
							lapse=data.split("-")[1];
						}
						buffer.append("<tr>");
						buffer.append("<td>"+LabelManager.getName(labelSet,"lblDomingo")+"</td>");
						buffer.append("<td><input type='text' name='inactSundayStart' size='2' maxlength='2' p_numeric='true' value='"+hour+"'></td>");
						buffer.append("<td style='width:0px;display:none'>"+LabelManager.getName(labelSet,"lblDomingo")+"</td>");
						buffer.append("<td><input type='text' name='inactSundayLapse' size='2' maxlength='2' p_numeric='true' value='"+lapse+"'></td>");
						buffer.append("</tr>");
						
						data = (String)InactivityPeriod.getInstance().getData().get(Integer.valueOf(2));
						hour=""; lapse="";
						if(data!=null){
							hour=data.split("-")[0];
							lapse=data.split("-")[1];
						}
						
						buffer.append("<tr>");
						buffer.append("<td>"+LabelManager.getName(labelSet,"lblLunes")+"</td>");
						buffer.append("<td><input type='text' name='inactMondayStart' size='2' maxlength='2' p_numeric='true' value='"+hour+"'></td>");
						buffer.append("<td style='width:0px;display:none'>"+LabelManager.getName(labelSet,"lblLunes")+"</td>");
						buffer.append("<td><input type='text' name='inactMondayLapse' size='2' maxlength='2' p_numeric='true' value='"+lapse+"'></td>");
						buffer.append("</tr>");
						
						data = (String)InactivityPeriod.getInstance().getData().get(Integer.valueOf(3));
						hour=""; lapse="";
						if(data!=null){
							hour=data.split("-")[0];
							lapse=data.split("-")[1];
						}
						
						buffer.append("<tr>");
						buffer.append("<td>"+LabelManager.getName(labelSet,"lblMartes")+"</td>");
						buffer.append("<td><input type='text' name='inactTuesdayStart' size='2' maxlength='2' p_numeric='true' value='"+hour+"'></td>");
						buffer.append("<td style='width:0px;display:none'>"+LabelManager.getName(labelSet,"lblMartes")+"</td>");
						buffer.append("<td><input type='text' name='inactTuesdayLapse' size='2' maxlength='2' p_numeric='true' value='"+lapse+"'></td>");
						buffer.append("</tr>");
						
						data = (String)InactivityPeriod.getInstance().getData().get(Integer.valueOf(4));
						hour=""; lapse="";
						if(data!=null){
							hour=data.split("-")[0];
							lapse=data.split("-")[1];
						}
						
						
						buffer.append("<tr>");
						buffer.append("<td>"+LabelManager.getName(labelSet,"lblMiercoles")+"</td>");
						buffer.append("<td><input type='text' name='inactWednesdayStart' size='2' maxlength='2' p_numeric='true' value='"+hour+"'></td>");
						buffer.append("<td style='width:0px;display:none'>"+LabelManager.getName(labelSet,"lblMiercoles")+"</td>");
						buffer.append("<td><input type='text' name='inactWednesdayLapse' size='2' maxlength='2' p_numeric='true' value='"+lapse+"'></td>");
						buffer.append("</tr>");
						
						data = (String)InactivityPeriod.getInstance().getData().get(Integer.valueOf(5));
						hour=""; lapse="";
						if(data!=null){
							hour=data.split("-")[0];
							lapse=data.split("-")[1];
						}
						
						buffer.append("<tr>");
						buffer.append("<td>"+LabelManager.getName(labelSet,"lblJueves")+"</td>");
						buffer.append("<td><input type='text' name='inactThursdayStart' size='2' maxlength='2' p_numeric='true' value='"+hour+"'></td>");
						buffer.append("<td style='width:0px;display:none'>"+LabelManager.getName(labelSet,"lblJueves")+"</td>");
						buffer.append("<td><input type='text' name='inactThursdayLapse' size='2' maxlength='2' p_numeric='true' value='"+lapse+"'></td>");
						buffer.append("</tr>");
						
						data = (String)InactivityPeriod.getInstance().getData().get(Integer.valueOf(6));
						hour=""; lapse="";
						if(data!=null){
							hour=data.split("-")[0];
							lapse=data.split("-")[1];
						}
						
						buffer.append("<tr>");
						buffer.append("<td>"+LabelManager.getName(labelSet,"lblViernes")+"</td>");
						buffer.append("<td><input type='text' name='inactFridayStart' size='2' maxlength='2' p_numeric='true' value='"+hour+"'></td>");
						buffer.append("<td style='width:0px;display:none'>"+LabelManager.getName(labelSet,"lblViernes")+"</td>");
						buffer.append("<td><input type='text' name='inactFridayLapse' size='2' maxlength='2' p_numeric='true' value='"+lapse+"'></td>");
						buffer.append("</tr>");
						
						data = (String)InactivityPeriod.getInstance().getData().get(Integer.valueOf(7));
						hour=""; lapse="";
						if(data!=null){
							hour=data.split("-")[0];
							lapse=data.split("-")[1];
						}
						
						
						buffer.append("<tr>");
						buffer.append("<td>"+LabelManager.getName(labelSet,"lblSabado")+"</td>");
						buffer.append("<td><input type='text' name='inactSaturdayStart' size='2' maxlength='2' p_numeric='true' value='"+hour+"'></td>");
						buffer.append("<td style='width:0px;display:none'>"+LabelManager.getName(labelSet,"lblSabado")+"</td>");
						buffer.append("<td><input type='text' name='inactSaturdayLapse' size='2' maxlength='2' p_numeric='true' value='"+lapse+"'></td>");
						buffer.append("</tr>");
						buffer.append("</table>");
						break;
					case ParametersVo.PARAM_TYPE_TASK_LIST_INITIAL_ORDER:
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRIORIDAD + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRIORIDAD)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjePriPro") + "</option>");
						/*
						buffer.append("<option value=\"" + ListTaskBean. + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.)) {
							buffer.append("selected");
							btnTestCVSVisible = true;
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeStaPro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean. + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeStaTsk") + "</option>");
						*/
						buffer.append("<option value=\"" + ListTaskBean.ORDER_TASK_TITLE + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_TASK_TITLE)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblTskTit") + "</option>");
												
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_ID_NUM + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_ID_NUM)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeInsEntNum") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PROC_ID_NUM + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PROC_ID_NUM)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeInsProNum") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_TASK_GROUP + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_TASK_GROUP)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeGruTar") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PROC_TITLE + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PROC_TITLE)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblProTit") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PROC_TYPE + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PROC_TYPE)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeTipProTar") + "</option>");
						
						buffer.append("<option value=\"" + +ListTaskBean.ORDER_TASK_DATE + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_TASK_DATE)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeFecCreTar") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PROC_DATE + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PROC_DATE)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeFecCreProTar") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PROC_USER + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PROC_USER)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeUsuCreProTar") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_STATUS + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_STATUS)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeStaEntTar") + "</option>");
						/*
						buffer.append("<option value=\"13\"");
						if (param.getParameterValue().equals("13")) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblEjeUseAdq") + "</option>");
						*/
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_1 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_1)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt1Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_2 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_2)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt2Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_3 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_3)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt3Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_4 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_4)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt4Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_5 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_5)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt5Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_NUM_1 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_NUM_1)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum1Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_NUM_2 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_NUM_2)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum2Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_NUM_3 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_NUM_3)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum3Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_DTE_1 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_DTE_1)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte1Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_DTE_2 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_DTE_2)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte2Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_PRO_INST_ATT_DTE_3 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_PRO_INST_ATT_DTE_3)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte3Pro") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_1 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_1)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt1EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_2 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_2)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt2EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_3 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_3)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt3EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_4 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_4)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt4EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_5 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_5)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt5EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_6 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_6)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt6EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_7 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_7)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt7EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_8 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_8)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt8EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_9 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_9)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt9EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_10 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_10)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAtt10EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_NUM_1 +"\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_NUM_1)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum1EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_NUM_2 +"\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_NUM_2)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum2EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_NUM_3 +"\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_NUM_3)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum3EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_NUM_4 +"\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_NUM_4)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum4EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_NUM_5 +"\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_NUM_5)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum5EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_NUM_6 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_NUM_6)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum6EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_NUM_7 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_NUM_7)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum7EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_NUM_8 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_NUM_8)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttNum8EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_DTE_1 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_DTE_1)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte1EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_DTE_2 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_DTE_2)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte2EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_DTE_3 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_DTE_3)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte3EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_DTE_4 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_DTE_4)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte4EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_DTE_5 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_DTE_5)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte5EntNeg") + "</option>");
						
						buffer.append("<option value=\"" + ListTaskBean.ORDER_ENT_INST_ATT_DTE_6 + "\"");
						if (param.getParameterValue().equals(""+ListTaskBean.ORDER_ENT_INST_ATT_DTE_6)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblAttDte6EntNeg") + "</option>");
						
						
						
						buffer.append("</select>");
						
						break;
					case ParametersVo.PARAM_TYPE_REQUIRED_ASTERIX_POSITION:
						buffer.append("<select id=\"" + param.getParameterId() + "\" name=\"" + param.getParameterId() +"\" p_required=true accesskey=\"" + LabelManager.getAccessKey(labelSet,param.getParameterId()) + "\">");
						
						buffer.append("<option value=\"" + Parameters.REQUIRED_ASTERISK_POSITION_AFTER + "\"");
						if (param.getParameterValue().equals(Parameters.REQUIRED_ASTERISK_POSITION_AFTER)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParAfterField") + "</option>");

						buffer.append("<option value=\"" + Parameters.REQUIRED_ASTERISK_POSITION_BEFORE + "\"");
						if (param.getParameterValue().equals(Parameters.REQUIRED_ASTERISK_POSITION_BEFORE)) {
							buffer.append("selected");
						}
						buffer.append(">" + LabelManager.getName(labelSet,"lblParBeforeText") + "</option>");
						
						buffer.append("</select>");
						
						break;
				}
			} else {
				buffer.append("<tr>");
				buffer.append("<td colspan=\"2\"><DIV class=\"subTit\">"+ LabelManager.getName(labelSet,obj.toString()) +"</DIV>");
			}

			buffer.append("</td></tr>");
		}
	}
	
	return buffer.toString();
}%><%!private String getBIError(String labelSet, int biSta){
	if (biSta == 1){
		//BIDB_IMPLMENTATION
		return LabelManager.getName(labelSet,"msgBIImplNotFound");
	}else if (biSta == 2){//BIDB_IMPLMENTATION not oracle, postgres or sqlserver
		return LabelManager.getName(labelSet,"msgBIWrngImpl");
	}else if (biSta == 3){//BIDB_URL
		return LabelManager.getName(labelSet,"msgBIUrlNotFound");
	}else if (biSta == 4){//BIDB_PWD
		return LabelManager.getName(labelSet,"msgBIPwdNotFound");
	}else if (biSta == 5){//BIDB_USR
		return LabelManager.getName(labelSet,"msgBIUsrNotFound");
	}else if (biSta == 15){//BIDB_IMPLEMENTAION not much with BIDB_URL
		return LabelManager.getName(labelSet,"msgBIUrlNotCorWithImpl");
	}else{
		return LabelManager.getName(labelSet,"msgDwNoSpecError");
	}
}%><%@page import="com.st.util.email.EmailQueueSender"%><%@page import="com.dogma.bi.queue.process.BIUpdProQueueSender"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script defer=true>
function tabSwitch(){
	document.getElementById('txtTab').value = document.getElementById('samplesTab').getSelectedTabIndex();
}

</SCRIPT><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.ParametersBean"></jsp:useBean><script language="javascript" DEFER src='<%=Parameters.ROOT_PATH%>/programs/configuration/parameters/parameters.js'></script></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPar")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type="tabElement" id="samplesTab" ontabswitch="tabSwitch()" defaultTab="<%=(request.getParameter("txtTab")==null?"0":request.getParameter("txtTab"))%>"><div type="tab" style="visibility:hidden; " tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParForm")%>" tabText="<%=LabelManager.getName(labelSet,"tabParForm")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPar")%></DIV><table class="tblFormLayout"><%= generateCode(dBean,dBean.getParamsFormat(),labelSet, styleDirectory) %></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParLoc")%>" tabText="<%=LabelManager.getName(labelSet,"tabParLoc")%>"><table class="tblFormLayout"><%= generateCode(dBean,dBean.getParamsLocation(),labelSet, styleDirectory) %></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParLog")%>" tabText="<%=LabelManager.getName(labelSet,"tabParLog")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPar")%></DIV><table class="tblFormLayout"><%= generateCode(dBean,dBean.getParamsLog(),labelSet, styleDirectory) %></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParEMail")%>" tabText="<%=LabelManager.getName(labelSet,"tabParEMail")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPar")%></DIV><table class="tblFormLayout"><%= generateCode(dBean,dBean.getParamsEmail(),labelSet, styleDirectory) %><tr><td>&nbsp;</td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEmailTo")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEmailTo")%>:</td><td><input type="text" name="txtEmailTo" value="" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEmailTo")%>"><button type="button" onclick="btnTestEmail_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTestEmail")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTestEmail")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTest")%></button></td></tr></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParOther")%>" tabText="<%=LabelManager.getName(labelSet,"tabParOther")%>"><table class="tblFormLayout"><%= generateCode(dBean,dBean.getParamsOther(),labelSet, styleDirectory) %></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParChat")%>" tabText="<%=LabelManager.getName(labelSet,"tabParChat")%>"><table class="tblFormLayout"><%= generateCode(dBean,dBean.getParamsChat(),labelSet, styleDirectory) %></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabParAut")%>" tabText="<%=LabelManager.getName(labelSet,"tabParAut")%>"><table class="tblFormLayout" style="width:100%"><%= generateCode(dBean,dBean.getParamsAuth(),labelSet, styleDirectory) %></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDwQry")%>" tabText="<%=LabelManager.getName(labelSet,"tabDwQry")%>"><table class="tblFormLayout" style="width:100%"><%= generateCode(dBean,dBean.getParamsBI(),labelSet, styleDirectory) %></table></div></div><input type="hidden" name="txtTab"></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD><button type="button" onclick="btnTestAll_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTestAll")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTestAll")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTestAll")%></button></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><SCRIPT>
MSG_WRNG_PASS = "<%=LabelManager.getName(labelSet,"msgPasMusHavEightChars") %>";
MSG_BI_EXEC_PARMS_WILL_BE_LOST = "<%=LabelManager.getName(labelSet, "msgBIExecParLost")%>";
</SCRIPT>
