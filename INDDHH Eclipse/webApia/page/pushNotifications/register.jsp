 
<%@page import="biz.statum.apia.utils.AES"%><%@page import="java.io.File"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="org.apache.commons.io.FileUtils"%><%@page import="org.apache.commons.codec.base64.Base64"%><%@page import="com.dogma.vo.UsrPushNotificationVo"%><%@page import="com.apia.core.CoreFacade"%><%

/*
Se envían los datos para autenticar el usuario y pass, en caso de autenticación correcta se guardan los campos y devuelve autenticación correcta.
Envia
-"usuario" = nombre del usuario para autenticar
-"pass" = contraseña para autenticar
-"url" = url del ambiente al cual se quiere autenticar
-"idNotificacion" = id del celular para las notificaciones
-"idAmbiente" = id del ambiente que se quiere crear
-"notificacion" = booleano para saber si quiere recibir notificaciones
-"SO" = Sistema operativo

Espera
-"autent" = booleano, true si se autentico correctamente false en caso contrario

se cambia el retorno para un json:
	
	
{
	  "result": {
	    "status": "true",
	    "image": "xxxxxxxx"
	  }
	}
*/
%><%
try{
	String usr 				= request.getParameter("usuario");
	String pass 			= request.getParameter("pass");
	
	
	String iv              = "01020304050607080901020304050607";
	String salt            = "70605040302010908070605040302010";
	String keySize         = "128";
	String iterationCount  = "100";
	String passPhrase      = "ApiaApp";

	pass = AES.decrypt(pass, passPhrase, salt, iv);	
	
	String phoneId 			= request.getParameter("idNotificacion");
	boolean notificacion	= "true".equals(request.getParameter("notificacion"));
	String so				= request.getParameter("SO");
	
	String idAmbiente 		= request.getParameter("idAmbiente");
	if(usr==null)usr="";
	usr=usr.toLowerCase();
	int result = CoreFacade.getInstance().doLogin(request, usr, usr, pass, false);
	if(result==0){
		//-si pasa insertar en UsrPushNotification
		UsrPushNotificationVo vo = new UsrPushNotificationVo();
		vo.setEnvId(Integer.valueOf(idAmbiente));
		vo.setUsrLogin(usr);
		vo.setNotPhoneId(phoneId);
		vo.setNotSo(so);
		if(notificacion){
			vo.setNotFlags("1");
		}
		CoreFacade.getInstance().registerUsrPushNotification(vo, "busClass");
		//-retornar
		out.clear();
		
		//obtener la imagen en base64
		
		
		String img = "";
		try{
			 System.out.println(Parameters.APP_PATH + EnvParameters.getEnvParameter(1, EnvParameters.SPLASH_IMAGE));
			byte[] b = Base64.encode(FileUtils.readFileToByteArray(new File(Parameters.APP_PATH + EnvParameters.getEnvParameter(1, EnvParameters.SPLASH_IMAGE))));
			img = new String(b);
		}catch(Exception e){
			e.printStackTrace();
		}
// 		System.out.println(img);
		
		String json = "{\"result\": {\"status\": \"true\",\"image\": \""+img+"\" }}";

		out.print(json);
		
	} else {
		//-retornar
		out.clear();
		
		String json = "{\"result\": {\"status\": \"false\"}}";
		out.print(json);
	}
} catch (Exception e) {
	e.printStackTrace();
	//-retornar
	String json = "{\"result\": {\"status\": \"false\"}}";
	out.print(json);
}

%>