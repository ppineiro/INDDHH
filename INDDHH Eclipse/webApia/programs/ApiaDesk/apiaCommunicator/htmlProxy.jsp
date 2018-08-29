<%@page import="java.io.FileWriter"%><%@page import="com.oreilly.servlet.multipart.ParamPart"%><%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%><%@page import="org.apache.commons.fileupload.FileItem"%><%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@page import="java.net.*"%><%@page import="java.security.*"%><%@page import="javax.servlet.http.HttpServletRequest"%><%@page import="com.oreilly.servlet.multipart.MultipartParser"%><%@page import="com.oreilly.servlet.multipart.Part"%><%@page import="com.oreilly.servlet.multipart.FilePart"%><%!

class HttpClient {

    private String proxyHost = null;
    private int proxyPort = -1;
    private boolean isHttps = false;
    private boolean isProxy = false;
    private URLConnection urlConnection = null;
    
    /**
     * @param url URL string
     */
    public HttpClient(String url) 
        throws MalformedURLException , ConnectException {
        this.urlConnection = getURLConnection(url);
    }
    /**
     * @param phost PROXY host name
     * @param pport PROXY port string
     * @param url URL string
     */
    public HttpClient(String phost, int pport, String url)
        throws MalformedURLException , ConnectException {
        if (phost != null && pport != -1) {
            this.isProxy = true;
        }
        this.proxyHost = phost;
        this.proxyPort = pport;
        if (url.indexOf("https") >= 0) {
            isHttps = true;
        }
        this.urlConnection = getURLConnection(url);
        // set user agent to mimic a common browser
        String ua="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)";
        this.urlConnection.setRequestProperty("user-agent", ua);
    }
    
    /**
     * private method to get the URLConnection
     * @param str URL string
     */
    private URLConnection getURLConnection(String str) 
        throws MalformedURLException , ConnectException {
        try {
            if (isHttps) {
                /* when communicating with the server which has unsigned or invalid
                 * certificate (https), SSLException or IOException is thrown.
                 * the following line is a hack to avoid that
                 */
                Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
                System.setProperty("java.protocol.handler.pkgs", "com.sun.net.ssl.internal.www.protocol");
                if (isProxy) {
                    System.setProperty("https.proxyHost", proxyHost);
                    System.setProperty("https.proxyPort", proxyPort + "");
                }
            } else {
                if (isProxy) {
                    System.setProperty("http.proxyHost", proxyHost);
                    System.setProperty("http.proxyPort", proxyPort  + "");
                }
            }
            URL url = new URL(str);
            return (url.openConnection());
            
        } catch (MalformedURLException me) {
            throw new MalformedURLException(str + " is not a valid URL");
        } catch (ConnectException e) {
        	throw e;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * returns the inputstream from URLConnection
     * @return InputStream
     */
    public InputStream getInputStream() {
        try {
            return (this.urlConnection.getInputStream());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * return the OutputStream from URLConnection
     * @return OutputStream
     */
    public OutputStream getOutputStream() {
        
        try {
            return (this.urlConnection.getOutputStream());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * posts data to the inputstream and returns the InputStream.
     * @param postData data to be posted. must be url-encoded already.
     * @return InputStream input stream from URLConnection
     */
    public InputStream doPost(String postData) throws ConnectException {
        this.urlConnection.setDoOutput(true);
        OutputStream os = this.getOutputStream();
        if(os==null){
        	throw new ConnectException();
        }
        PrintStream ps = new PrintStream(os);
        ps.print(postData);
        ps.close();
        
        return (this.getInputStream());
    }
    
    public void doPostData(HttpServletRequest req,HttpServletResponse res) {
    	try{
	    	this.urlConnection.setDoOutput(true);
	    	this.urlConnection.setDoInput(true);
	    	this.urlConnection.setAllowUserInteraction(false);
	    	
	    	MultipartParser parser = new MultipartParser(req, 10000000, true, true);
	    	
	    	Part part;
	        while ((part = parser.readNextPart()) != null ){
	        	if (part.isFile()) {
	                FilePart filePart = (FilePart) part;
	                filePart.writeTo(this.getOutputStream());
	        	}
	        }
    	
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    }
    
    public String getContentEncoding() {
        if (this.urlConnection == null) return null;
        return (this.urlConnection.getContentEncoding());
    }
    public int getContentLength() {
        if (this.urlConnection == null) return -1;
        return (this.urlConnection.getContentLength());
    }
    public String getContentType() {
        if (this.urlConnection == null) return null;
        return (this.urlConnection.getContentType());
    }
    public long getDate() {
        if (this.urlConnection == null) return -1;
        return (this.urlConnection.getDate());
    }
    public String getHeader(String name) {
        if (this.urlConnection == null) return null;
        return (this.urlConnection.getHeaderField(name));
    }
    public long getIfModifiedSince() {
        if (this.urlConnection == null) return -1;
        return (this.urlConnection.getIfModifiedSince());
    }
}

%><%




	if(ServletFileUpload.isMultipartContent(request)){
		//System.out.println("QUERY QUERY QUERY QUERY QUERY QUERY QUERY QUERY QUERY QUERY QUERY QUERY QUERY QUERY  \n \n "+request.getQueryString());
		HashMap fieldsMap = new HashMap();
		
		MultipartParser parser = new MultipartParser(request, (1024 * 1024 * 200), true, true);
    	
    	Part part;
        while ((part = parser.readNextPart()) != null ){
        	if (part.isParam()) {
        		String name = part.getName();
        		ParamPart paramPart = (ParamPart) part;
                String value = paramPart.getStringValue();
		    	System.out.println("\n  name value -> "+name+"-----"+value+"\n");
		        fieldsMap.put(name, value);
		    }
        	
        	if (part.isFile()) {

                FilePart filePart = (FilePart) part;
                filePart.writeTo(new File("c:\\culo.txt"));

            }
		}
		System.out.println("\n  requurl -> "+fieldsMap.get("reqUrl").toString());
		String reqUrl=fieldsMap.get("reqUrl").toString();
		HttpClient client=new HttpClient(reqUrl);
		client.doPostData(request,response);
		
	}else{
		InputStream in=null;
		try {
			String reqUrl=request.getParameter("reqUrl");
			HttpClient client=new HttpClient(reqUrl);
			String postData="";
			Enumeration paramNames=request.getParameterNames();
			while(paramNames.hasMoreElements()){
				String name=paramNames.nextElement().toString();
				postData+=name+"="+request.getParameter(name);
				if(paramNames.hasMoreElements()){
					postData+="&";
				}
			}
			in=client.doPost(postData);
			response.setContentType(client.getContentType());
			String contentType=client.getContentType();
			if(contentType==null){
				contentType="text";
			}
			if(contentType.indexOf("text")>=0){
				byte[] buffer = new byte[1024];
				int read = 0;
		        String responseStr="";
				while (true) {
					read = in.read(buffer);
					if (read <= 0) break;
					//outStream.write(buffer, 0, read );
					String s=new String(buffer,0,read);
					responseStr+=s;
					//out.write(s);
				}
				out.clear();
				out.write(responseStr);
			}else{
				
				byte[] buffer = new byte[8 * 1024];
				int count = 0;
				do {
					response.getOutputStream().write(buffer, 0, count);
					count = in.read(buffer, 0, buffer.length);
				} while (count != -1);
				out.clear();
			}
		} catch (ConnectException e) {
	    	e.printStackTrace();
	    } catch (Exception e) {
	    	e.printStackTrace();
	    	response.getWriter().print("<CONNLOST />");
	    } finally {
	        try {
	            if (in != null) {
	                in.close();
	            }
	        } catch (Exception e) {
	            // do nothing
	        }
	    }
    }
%>