<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
boolean envUsesEntities = false;
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getStrLabelSetId();
}
out.clear();
out.print("lbl_btnConfirm=");out.print(LabelManager.getName(labelSet,"flaCon")); //Confirmar
out.print("&lblbtnCancel=");out.print(LabelManager.getName(labelSet,"flaCan")); //Cancelar
out.print("&lbl_events=");out.print(LabelManager.getName(labelSet,"flaEve")); //Eventos
out.print("&lbl_attributes=");out.print(LabelManager.getName(labelSet,"flaAtr"));//Atributos
out.print("&lbl_deleteItem=");out.print(LabelManager.getName(labelSet,"flaEli"));//deleteItem
out.print("&lbl_attName=");out.print(LabelManager.getName(labelSet,"flaNom"));//Nombre
out.print("&lbl_attLabel=");out.print(LabelManager.getName(labelSet,"flaEti"));//label
out.print("&lbl_attType=");out.print(LabelManager.getName(labelSet,"flaTip"));//type
out.print("&lbl_attMaxlength=");out.print(LabelManager.getName(labelSet,"flaMax"));//max
out.print("&lbl_evt_title=");out.print(LabelManager.getName(labelSet,"flaTitEvt"));//Events
out.print("&lbl_class_title=");out.print(LabelManager.getName(labelSet,"flaCla"));//Classes
out.print("&lbl_prpBarName=");out.print(LabelManager.getName(labelSet,"flaPro"));//property
out.print("&lbl_prpBarValue=");out.print(LabelManager.getName(labelSet,"flaVal"));//value
out.print("&lbl_frmEvents=");out.print(LabelManager.getName(labelSet,"flaForEve"));//form events
out.print("&lbl_untitledElement=");out.print(LabelManager.getName(labelSet,"flaUntitled")); //Untitled
out.print("&lbl_binds=");out.print(LabelManager.getName(labelSet,"flaEntBin"));
out.print("&lbl_BindBtn=");out.print(LabelManager.getName(labelSet,"flaBindBtn"));
out.print("&lbl_deleteGrid=");out.print(LabelManager.getName(labelSet,"flaDelGrid"));
out.print("&lbl_eventBindAtt=");out.print(LabelManager.getName(labelSet,"flaBinAtt"));
out.print("&rad_eventBindingsValue=");out.print(LabelManager.getName(labelSet,"flaBinAttVal"));
out.print("&rad_eventBindingsAttribute=");out.print(LabelManager.getName(labelSet,"flaBinAttAtt"));
out.print("&lbl_frmEntityTitle=");out.print(LabelManager.getName(labelSet,"flaBinAttEnt"));
out.print("&lbl_BindProcess=");out.print(LabelManager.getName(labelSet,"flaBinAttPro"));
out.print("&lbl_toLeft=");out.print(LabelManager.getName(labelSet,"flaMovIzq")); //Move Left
out.print("&lbl_toRight=");out.print(LabelManager.getName(labelSet,"flaMovDer")); //Move Right
out.print("&lbl_frmInit=");out.print(LabelManager.getName(labelSet, "btnIni")); 
out.print("&lbl_frmInitQ=");out.print(LabelManager.getName(labelSet, "msgFrmInitQ")); 
out.print("&lbl_frmInitTit=");out.print(LabelManager.getName(labelSet, "btnIniEnt")); 

out.print("&lbl_ConditionModalTitle=");out.print(LabelManager.getName(labelSet, "flaProCndMod"));

out.print("&lblConditionRules=");out.print(com.st.util.StringUtil.replace(LabelManager.getName(labelSet, "flaProCndRul")+LabelManager.getName(labelSet, "flaProCndRul2")+LabelManager.getName(labelSet, "flaProCndRul3"),"\r","")); //Con Rules

out.print("&lbl_changeElement=");out.print(LabelManager.getName(labelSet, "lbl_changeElement")); 

out.print("&lblToolInput=Input");
out.print("&lblToolListbox=ListBox");
out.print("&lblToolCombobox=ComboBox");
out.print("&lblToolCheck=CheckBox");
out.print("&lblToolRadio=RadioButton");
out.print("&lblToolPass=Password");
out.print("&lblToolTxtArea=TextArea");
out.print("&lblToolLabel=Label");
out.print("&lblToolSubTit=SubTitle");
out.print("&lblToolFile=File Input");
out.print("&lblToolHidden=Hidden Input");
out.print("&lblToolButton=Button");
out.print("&lblToolGrid=Grid");
out.print("&lblToolImage=Image");
out.print("&lblToolHref=Link");
out.print("&lblToolTextFormat=Editor");
%>