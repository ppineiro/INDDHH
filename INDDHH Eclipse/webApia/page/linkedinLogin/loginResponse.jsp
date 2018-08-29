<%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="sun.org.mozilla.javascript.internal.json.JsonParser"%><%@page import="java.io.OutputStreamWriter"%><%@page import="com.dogma.Configuration"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.controller.ThreadData"%><%@page import="biz.statum.apia.web.bean.security.LoginBean"%><%@page import="org.json.JSONException"%><%@page import="org.json.JSONObject"%><%@page import="java.net.URLEncoder"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%		

        String clientId	= Configuration.LINKEDIN_APP_ID;
		String secret	= Configuration.LINKEDIN_SECRET;
		String redirectURI = Configuration.LINKEDIN_PUBLISHED_URL + "/page/linkedinLogin/loginResponse.jsp";
		
		String error = request.getParameter("error");
		if(error!=null){
			response.sendRedirect(Parameters.ROOT_PATH+"/errorFacebookLogin.jsp?message=LinkedIn response: "+error);
		} else {
		
		 String code = request.getParameter("code");

	        String urlParameters = "code=" + code + "&client_id="
	                + clientId + "&client_secret="
	                + secret + "&redirect_uri="
	                + redirectURI
	                + "&grant_type=authorization_code";

	        URL url = new URL("https://www.linkedin.com/uas/oauth2/accessToken");
	        URLConnection urlConn = url.openConnection();
	        urlConn.setDoOutput(true);
	        OutputStreamWriter writer = new OutputStreamWriter(
	                urlConn.getOutputStream());
	        writer.write(urlParameters);
	        writer.flush();

	        String line, outputString = "";
	        BufferedReader reader = new BufferedReader(new InputStreamReader(
	                urlConn.getInputStream()));
	        while ((line = reader.readLine()) != null) {
	            outputString += line;
	        }
	        JSONObject json = new JSONObject(outputString);
	        String access_token = json.getString("access_token");
	        url = new URL("https://api.linkedin.com/v1/people/~:(id,email-address,firstName,lastName)?format=json&oauth2_access_token="+access_token );
			
	        urlConn = url.openConnection();
	       // urlConn.setRequestProperty("Authorization", access_token);
	        
	        outputString = "";
	        reader = new BufferedReader(new InputStreamReader(urlConn.getInputStream()));
	        while ((line = reader.readLine()) != null) {
	            outputString += line;
	        }
		
		
	        json = new JSONObject(outputString);
	        String id = "l"+json.getString("id");
			String email = json.getString("emailAddress");
			String name = json.getString("firstName") + " " +json.getString("lastName");
		
		
		
			id = id.toLowerCase();
		
			String envs = Configuration.LINKEDIN_LOGIN_ENVS;
            String[] envNames = envs.split(",");
            EnvironmentVo e = CoreFacade.getInstance().getEnvironment(envNames[0]);
            
             
            Integer langId= 1;
            Integer envId= e.getEnvId();
            
            LoginBean lb = new LoginBean();
            ThreadData.set(ThreadData.LOGINFROMFACEBOOK, "true");
            String messages = lb.createFacebookGoogleUser(id,name,email,"LinkedIn");
            int res = lb.login(request, envId, id, null, null, langId);
            if(res == LoginBean.LOGIN_OK){
            	String tokenId = ThreadData.getUserData().getTokenId();
            	response.sendRedirect(Parameters.ROOT_PATH+"/apia.security.LoginAction.run?action=gotoSplash&tokenId=" + tokenId + "&tabId=1");
            } else {
            	response.sendRedirect(Parameters.ROOT_PATH+"/errorFacebookLogin.jsp?message="+messages);
            }
		}
%>