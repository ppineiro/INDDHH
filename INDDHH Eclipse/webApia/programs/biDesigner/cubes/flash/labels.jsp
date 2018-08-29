<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%
response.setHeader("Pragma","no-cache");
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
out.print("lblDwDimCreate=");
out.print(LabelManager.getName(labelSet,"lblDwDimCreate"));
out.print("&lblDwDimName=");
out.print(LabelManager.getName(labelSet,"lblDwDimName"));
out.print("&lblDwDimension=");
out.print(LabelManager.getName(labelSet,"lblDwDimension"));
out.print("&lblDwDimFgnKey=");
out.print(LabelManager.getName(labelSet,"lblDwDimFgnKey"));
out.print("&lblDwDimName=");
out.print(LabelManager.getName(labelSet,"lblDwDimName"));
out.print("&lblDwDimDescription=");
out.print(LabelManager.getName(labelSet,"lblDwDimDescription"));
out.print("&lblDwDimTable=");
out.print(LabelManager.getName(labelSet,"lblDwDimTable"));
out.print("&lblDwDimPriKey=");
out.print(LabelManager.getName(labelSet,"lblDwDimPriKey"));
out.print("&lblDwDimShared=");
out.print(LabelManager.getName(labelSet,"lblDwDimShared"));
out.print("&lblDwDimOk=");
out.print(LabelManager.getName(labelSet,"lblDwDimOk"));
out.print("&lblDwDimCancel=");
out.print(LabelManager.getName(labelSet,"lblDwDimCancel"));
out.print("&lblDwSrcFields=");
out.print(LabelManager.getName(labelSet,"lblDwSrcFields"));
out.print("&lblDwDimensions=");
out.print(LabelManager.getName(labelSet,"lblDwDimensions"));
out.print("&lblDwProperties=");
out.print(LabelManager.getName(labelSet,"lblDwProperties"));
out.print("&lblDwPrpPrperty=");
out.print(LabelManager.getName(labelSet,"lblDwPrpPrperty"));
out.print("&lblDwPrpValue=");
out.print(LabelManager.getName(labelSet,"lblDwPrpValue"));
out.print("&lblDwDimUseDim=");
out.print(LabelManager.getName(labelSet,"lblDwDimUseDim"));
%>