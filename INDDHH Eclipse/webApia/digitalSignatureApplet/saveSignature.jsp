<%@page import="java.util.HashMap"%><%@page import="com.dogma.vo.custom.KeyAndSign"%><%

//se almacena en sesion el id de cada firma

String appletToken = request.getParameter("appletToken");

HashMap<String,KeyAndSign> signedData = (HashMap<String,KeyAndSign>)request.getSession().getAttribute("SIGNED_DATA" + appletToken);
if(signedData == null)
	signedData = new HashMap<String,KeyAndSign>(); 

//se quita el escapeo de algunos caracteres (enters, carriage returns y +
String key = request.getParameter("clave");
if(key != null) {
	key=key.replace("charmas", "+");
	key=key.replace("char13", "");
	key=key.replace("char10", "");
}

String sign = request.getParameter("firma");
sign=sign.replace("charmas", "+");
sign=sign.replace("char13", "");
sign=sign.replace("char10", "");

String pkcs7 = request.getParameter("pkcs7");
if(pkcs7 != null) {
	pkcs7=pkcs7.replace("charmas", "+");
	pkcs7=pkcs7.replace("char13", "");
	pkcs7=pkcs7.replace("char10", "");
}

KeyAndSign ks = new KeyAndSign();
ks.setPublicKey(key);
ks.setSign(sign);
ks.setSerialNumber(request.getParameter("serialNumber"));
ks.setPkcs7(pkcs7);

String rewriteFile = request.getParameter("rewriteFile");
String pathOut = request.getParameter("pathOut");
if(rewriteFile != null && rewriteFile.equals("true") && pathOut != null && !pathOut.equals("")) {
	ks.setRewriteFile(true);
	ks.setPathOut(pathOut);
}

signedData.put(request.getParameter("id"), ks);
//request.getParameter("certEndDate");  //fecha de vencimiento del certificado
//request.getParameter("rootCA");  //fecha de vencimiento del certificado
request.getSession().setAttribute("SIGNED_DATA" + appletToken, signedData);
%>