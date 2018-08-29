<%@page import="java.io.File"%><%@page import="java.io.IOException"%><%@page import="java.io.FileInputStream"%><%@page import="java.io.InputStream"%><%@page import="java.util.Properties"%><%@include file="/page/includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="/page/includes/headInclude.jsp" %><script type="text/javascript">	
	function initPage() {	
		frameElement.getParent().setStyle('max-height', this.document.body.offsetHeight + 12);
		frameElement.setStyle('height', this.document.body.offsetHeight + 10);
		parent.SYS_PANELS.adjustVisual();
	}
	
</script><%

Properties prop = new Properties();
InputStream input = null;
String imgSrc = null;
String desc = null;
String url = null;

try {
	
	String path = Configuration.APP_PATH + File.separator + "about" + File.separator + uData.getEnvironmentName() + File.separator + "info" + "_" + uData.getLangId()  + ".properties";

	try {
		input = new FileInputStream(path);
	} catch (IOException ex) {
		path = Configuration.APP_PATH + File.separator + "about" + File.separator + uData.getEnvironmentName() + File.separator + "info.properties";
		input = new FileInputStream(path);
	}
	
	prop.load(input);

	imgSrc = prop.getProperty("image");
	desc = prop.getProperty("description");
	url = prop.getProperty("url");

	if(imgSrc == null || "".equals(imgSrc.trim())) {
		imgSrc = EnvParameters.getEnvParameter(envId, EnvParameters.SPLASH_IMAGE);
	}
	
} catch (IOException ex) {
	
} finally {
	if (input != null) {
		try {
			input.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}

boolean hasEnvInfo = desc != null && !"".equals(desc.trim());
%><style type="text/css">
	.leftColAbout {
		width: <%= hasEnvInfo ? "30%" : "45%"%>;
		padding: 1% 3% 0% 1%;
		display: inline-block;
		vertical-align: middle;
		text-align: center;
	}
	
	.middleColAbout {
		width: <%= hasEnvInfo ? "30%" : "45%"%>;
		padding: <%= hasEnvInfo ? "1% 1% 0%" : "1% 1% 0% 3%"%>;
		display: inline-block;
		vertical-align: middle;
		text-align: center;
	}
	
	.rightColAbout {
		width: 30%;
		padding: 1% 0% 0% 2%;
		display: inline-block;
		vertical-align: middle;
		text-align: center;
	}
	
	img {
		width: <%= hasEnvInfo ? "100%" : "80%"%>;
	}
</style></head><body><div><div><div class="leftColAbout"><img src="<system:util show="context" />/images/statum.png"></div><div class="middleColAbout"><img src="<system:util show="context" />/images/apiaLogo.png"></div><%if(hasEnvInfo) { %><div class="rightColAbout"><img src="<system:util show="context" /><%=imgSrc%>"></div><%} %></div><div><div class="leftColAbout"><p><system:label show="text" label="lblSTATUMDesc" forHtml="true" forScript="true"/></p><a href="http://www.statum.biz/" target="_blank"><system:label show="text" label="lblMoreInfo" forHtml="true" forScript="true"/></a></div><div class="middleColAbout"><p><system:label show="text" label="lblApiaDesc" forHtml="true" forScript="true"/></p><a href="http://www.statum.biz/statum/type1/9/apia-informacion" target="_blank"><system:label show="text" label="lblMoreInfo" forHtml="true" forScript="true"/></a></div><%if(hasEnvInfo) { %><div class="rightColAbout"><p><%=desc%></p><%if(url != null && !"".equals(url.trim())) { %><a href="<%=url%>" target="_blank"><system:label show="text" label="lblMoreInfo" forHtml="true" forScript="true"/></a><%} %></div><%} %></div></div></body></html>