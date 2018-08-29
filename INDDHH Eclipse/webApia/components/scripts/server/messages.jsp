<%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.StringUtil"%><jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/><script language="javascript">
var LOGGED_USER				= "<%=bLogin.getUserId(request)%>";
var LOGGED_USER_NAME		= "<%=bLogin.getUserName(request)%>";
var GNR_DATE_SEPARATOR		= "<%=Parameters.DATE_SEPARATOR%>";
var GNR_TIME_SEPARATOR		= "<%=Parameters.TIME_SEPARATOR%>";

var GNR_WAIT_A_MOMENT 		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_WAIT_A_MOMENT))%>";

var GNR_CHK_NONE 			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_CHK_NONE))%>";
var GNR_CHK_ONLY_ONE 		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_CHK_ONLY_ONE))%>";
var GNR_CHK_AT_LEAST_ONE 	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_CHK_AT_LEAST_ONE))%>";
var GNR_DELETE_RECORD		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_DELETE_RECORD))%>";
var GNR_INIT_RECORD			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_INIT_RECORD))%>";
var GNR_INIT_MESSAGES		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_INIT_MESSAGES))%>";
var GNR_NOT_EMAIL			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_NOT_EMAIL))%>";
var SEC_PWD_MUST_BE_SAME	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.SEC_PWD_MUST_BE_SAME))%>";

var GNR_INVALID_NAME		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_INVALID_NAME))%>";
var GNR_INVALID_TIME		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_INVALID_TIME))%>";
var GNR_INVALID_LOGIN		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_INVALID_LOGIN))%>";

var GNR_PER_DAT_ING		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_PER_DAT_ING))%>";

GNR_REG_EXP_FAIL			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_REG_EXP_FAIL))%>";

var GNR_REQUIRED			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_REQUIRED))%>";
var GNR_NUMERIC				= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_NUMERIC))%>";
var GNR_STRING_SEPARATOR 	= "<%=StringUtil.PRIMARY_SEPARATOR%>";
var URL_ROOT_PATH		 	= "<%=Parameters.ROOT_PATH%>";
var URL_STYLE_PATH			= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>";

var GNR_ORDER_DUPLICATED	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_ORDER_DUPLICATED))%>";
var GNR_ERROR_MAX_ATTRIBUTE = "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_ERROR_MAX_ATTRIBUTE))%>"
var GNR_MAX_ATTRIBUTE		= <%=Parameters.MAX_ATTRIBUTE_QUERY%>;

var HOUR_FORMAT_ERROR		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_HOUR_FORMAT_ERROR))%>";
var FCH_FIN_MAY_FCH_INI     = "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_FCH_FIN_MAY_FCH_INI))%>";

var GNR_JANUARY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JANUARY))%>";
var GNR_FEBRUARY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_FEBRUARY))%>";
var GNR_MARCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MARCH))%>";
var GNR_APRIL		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_APRIL))%>";
var GNR_MAY			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MAY))%>";
var GNR_JUNE		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JUNE))%>";
var GNR_JULY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JULY))%>";
var GNR_AUGUST		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_AUGUST))%>";
var GNR_SEPTEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_SEPTEMBER))%>";
var GNR_OCTOBER		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_OCTOBER))%>";
var GNR_NOVEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_NOVEMBER))%>";
var GNR_DECEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_DECEMBER))%>";

var GNR_MONDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblLunes"))%>";
var GNR_TUESDAY  	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblMartes"))%>";
var GNR_WEDNESDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblMiercoles"))%>";
var GNR_THURSDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblJueves"))%>";
var GNR_FRIDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblViernes"))%>";
var GNR_SATURDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblSabado"))%>";
var GNR_SUNDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblDomingo"))%>";

var GNR_NO_EXI_MES	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_NO_EXI_MES))%>";
var GNR_FOR_FCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_FOR_FCH))%>";
var GNR_MIN_FCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MIN_FCH))%>";
var GNR_EL_MES_DE	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_EL_MES_DE))%>";
var GNR_TIE_28_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_28_DIA))%>";
var GNR_TIE_29_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_29_DIA))%>";
var GNR_TIE_30_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_30_DIA))%>";
var GNR_TIE_31_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_31_DIA))%>";
var GNR_TIE_00_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_00_DIA))%>";
var GNR_TIE_00_MES	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_00_MES))%>";

var GRID_SELECTALL  = "<%=LabelManager.getName(labelSet,"lblEjeSelTod")%>";
var GRID_SELECTNONE = "<%=LabelManager.getName(labelSet,"lblEjeSelNon")%>";

var MSG_FIELD_NOT_FOUND	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgFieldNotFound"))%>";

var DIGITAL_SIGNATURE_OK = "<%=LabelManager.getName(labelSet,"lblSigOK")%>";
var DIGITAL_SIGNATURE_NOK = "<%=LabelManager.getName(labelSet,"lblSigNOK")%>";
var DIGITAL_SIGNATURE_OK_CERT = "<%=LabelManager.getName(labelSet,"lblSigOKCERT")%>";

var TAB_EJE_FOR = "<%=LabelManager.getName(labelSet, "tabEjeFor")%>";

var SHOW_WAIT_IN_EXECUTION=<%=new Boolean(Parameters.SHOW_WAIT_IN_EXECUTION).toString()%>;

<%
Integer envId = null;
//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	envId = uData.getEnvironmentId();
} else {
	envId = new Integer(1);
}
%><%if(!"yyyy/MM/dd".equals(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DATE))){%>
var DATE_MASK 		= "<%="__" + Parameters.DATE_SEPARATOR + "__" + Parameters.DATE_SEPARATOR + "____"%>";
<%} else {%>
var DATE_MASK 		= "<%="____" + Parameters.DATE_SEPARATOR + "__" + Parameters.DATE_SEPARATOR + "__"%>";
<%}%>

var GNR_CURR_STYLE 	= "<%=EnvParameters.getEnvParameter(envId,EnvParameters.ENV_STYLE)%>";

var objDateRegExp 				=  /^<%=EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DAT_REG_EXP)%>$/
var objNumRegExp 				=  <%=EnvParameters.getEnvParameter(envId,EnvParameters.FMT_NUM_REG_EXP)%>
var strDateFormat 				= "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DATE))%>";
var charDecimalSeparator		= "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMAL_SEP))%>";
var addThousandSeparator		= <%="true".equals(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_SEPARATE_THOU))%>;
var charThousSeparator			= "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_THOUS_SEP))%>";
var amountDecimalSeparator		= "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMALS))%>";
var amountDecimalZeros			= "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_ZERO_DECIMALS))%>";
var rootPath					= "<%=Parameters.ROOT_PATH%>";
var internalDivType	= "<%=com.dogma.DogmaConstants.SESSION_CMP_HEIGHT%>";
var internalDivSize = "";

var currentModule = "<%=((String)request.getAttribute("currentModule"))%>";
function getCurrentModule(){
	return currentModule;
}
</script>