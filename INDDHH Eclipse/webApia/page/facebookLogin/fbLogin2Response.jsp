<%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.dogma.Configuration"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.controller.ThreadData"%><%@page import="biz.statum.apia.web.bean.security.LoginBean"%><%@page import="org.json.JSONException"%><%@page import="org.json.JSONObject"%><%@page import="java.net.URLEncoder"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%		

		String code = request.getParameter("code");
        if (code == null || code.equals("")) {
            // an error occurred, handle this
        }

        String token = null;
        try {
            String g = "https://graph.facebook.com/oauth/access_token?client_id="+Configuration.FB_APP_ID+"&redirect_uri=" + URLEncoder.encode(Configuration.FB_PUBLISHED_URL + "/page/facebookLogin/fbLogin2Response.jsp", "UTF-8") + "&client_secret="+Configuration.FB_SECRET+"&code=" + code;
            URL u = new URL(g);
            URLConnection c = u.openConnection();
            BufferedReader in = new BufferedReader(new InputStreamReader(c.getInputStream()));
            String inputLine;
            StringBuffer b = new StringBuffer();
            while ((inputLine = in.readLine()) != null)
                b.append(inputLine + "\n");            
            in.close();
            token = b.toString();
            if (token.startsWith("{"))
                throw new Exception("error on requesting token: " + token + " with code: " + code);
        } catch (Exception e) {
                e.printStackTrace();
        }

        String graph = null;
        try {
            String g = "https://graph.facebook.com/me?fields=id,name,email&" + token;
            URL u = new URL(g);
            URLConnection c = u.openConnection();
            BufferedReader in = new BufferedReader(new InputStreamReader(c.getInputStream()));
            String inputLine;
            StringBuffer b = new StringBuffer();
            while ((inputLine = in.readLine()) != null)
                b.append(inputLine + "\n");            
            in.close();
            graph = b.toString();
        } catch (Exception e) {
                e.printStackTrace();
        }

        String facebookId;
        String name;
        String email="";
        try {
            JSONObject json = new JSONObject(graph);
            facebookId = "f"+json.getString("id");
            name = json.getString("name");
            
            
            facebookId = facebookId.toLowerCase();
           
            if(json.has("email")){
            	email = json.getString("email");
            }
           
            
            String envs = Configuration.FB_LOGIN_ENVS;
            String[] envNames = envs.split(",");
            EnvironmentVo e = CoreFacade.getInstance().getEnvironment(envNames[0]);
            
            
            Integer langId= 1;
            Integer envId= e.getEnvId();
            
            LoginBean lb = new LoginBean();
            ThreadData.set(ThreadData.LOGINFROMFACEBOOK, "true");
            String messages = lb.createFacebookGoogleUser(facebookId,name,email,"Facebook");
            int res = lb.login(request, envId, facebookId, null, null, langId);
            if(res == LoginBean.LOGIN_OK){
            	String tokenId = ThreadData.getUserData().getTokenId();
            	response.sendRedirect(Parameters.ROOT_PATH+"/apia.security.LoginAction.run?action=gotoSplash&tokenId=" + tokenId + "&tabId=1");
            } else {
            	response.sendRedirect(Parameters.ROOT_PATH+"/errorFacebookLogin.jsp?message="+messages);
            }
            
            
            
        } catch (JSONException e) {
            // an error occurred, handle this
            e.printStackTrace();
        }
        
%>