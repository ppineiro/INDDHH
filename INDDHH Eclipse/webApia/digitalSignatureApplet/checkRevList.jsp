<%@page import="com.dogma.bean.GenericBean"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%
String sn = request.getParameter("serialNumber");
//validar

GenericBean gb = new GenericBean();
int res = gb.isRevoked(sn);
String ret;
if(res==1){
	ret = "REVOKED";
}else if (res==0){
	ret = "OK";
} else {
	 ret = "ERROR";
}
//responder: si el certificado esta revocado se retorna "REVOKED"
out.clear();
out.print(ret);


%>