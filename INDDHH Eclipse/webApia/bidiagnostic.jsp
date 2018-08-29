<%@page language="java"%><%@page import="com.dogma.vo.NavigationVo"%><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.SchemaVo"%><%@page import="com.dogma.vo.CubeVo"%><%@page import="com.dogma.vo.CubeViewVo"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="com.dogma.vo.UserVo"%><%@page import="com.dogma.business.security.FunctionalityService"%><%@page import="com.dogma.vo.ProfileVo"%><html><head><script language="javascript" src="http://localhost:8080/Apia2.3/scripts/util.js"></script><script language="javascript" src="http://localhost:8080/Apia2.3/scripts/modalController.js"></script><script language="javascript" src="http://localhost:8080/Apia2.3/scripts/common.js"></script><style>
td{
/*border:1px solid black;*/
vertical-align:top;
}
</style></head><body><table align='center'><tr><td><b><font size=6>APIA BI DIAGNOSTICS</font></b></td></tr><tr><td>&nbsp;</td></tr><tr><td><b>Database Parameters</b></td></tr><tr><td><table border='1'><tr><td>URL</td><td><%=com.dogma.BIParameters.BIDB_URL%></td></tr><tr><td>User</td><td><%=com.dogma.BIParameters.BIDB_USR%></td></tr><tr style="display:none"><td>Password</td><td><%=com.dogma.BIParameters.BIDB_PWD%></td></tr><tr><td>Implementation</td><td><%=com.dogma.BIParameters.BIDB_IMPLEMENTATION%></td></tr><tr><td>Max connections</td><td><%=com.dogma.BIParameters.BIDB_MAX_CONNECTIONS%></td></tr><tr><td>Min connections</td><td><%=com.dogma.BIParameters.BIDB_MIN_CONNECTIONS%></td></tr><tr><td>Connection renew time</td><td><%=com.dogma.BIParameters.BIDB_CONN_RENEW_TIME%></td></tr><tr><td>Connection renew time</td><td><%=com.dogma.BIParameters.BIDB_CONN_RENEW_TIME%></td></tr></table></td></tr><tr><td>&nbsp;</td></tr><tr><td><b>BI SCHEMAS INFORMATION</b></td></tr><tr><td><table border='1'><TR><TH>SCHEMAS</TH><TH>CUBES</TH></TR><% Collection schCol =  com.dogma.business.administration.SchemaService.getInstance().getSchemaList();
					   Iterator schIt = schCol.iterator();
					   while (schIt.hasNext()){
  						 SchemaVo schemaVo = (SchemaVo) schIt.next();
						 Collection cubesCol = com.dogma.business.administration.SchemaService.getInstance().getCubeList(schemaVo.getSchemaId());			
						 Iterator cubesIt = cubesCol.iterator();%><tr><td><table border='1'><tr><TD><div style="text-decoration:underline;color:#0000FF;cursor:pointer;cursor:hand;" onclick="viewSchemaDef(<%=schemaVo.getSchemaId()%>)"><%=schemaVo.getSchemaName()%></div></TD></tr></table></td><td><div style="height:280px;overflow:auto;"><table border='1'><%   while (cubesIt.hasNext()){
							   CubeVo cubeVo = (CubeVo) cubesIt.next();%><tr><TD><div><%=cubeVo.getCubeName()%></div></TD><% Collection viewsCol = com.dogma.business.administration.CubeViewService.getInstance().getCubeViewsList(cubeVo.getCubeId());
	   						      int vwCant = viewsCol.size();
								  Iterator cubeViewsIt = viewsCol.iterator();%><td><table width="100%" border='1'><tr><th>views</th><th>perfiles-navegador</th><th>perfiles-visualizador</th></tr><%
							   		while (cubeViewsIt.hasNext()){
								   		CubeViewVo cubeViewVo = (CubeViewVo) cubeViewsIt.next();%><tr><td><%=cubeViewVo.getVwName()%></td><%//PERFILES DE LA VISTA EN MODO NAVEGADOR%><td><table><%
								   			Collection prfsColNav = FunctionalityService.getInstance().getPrfsCanAccessVwFunct(cubeViewVo.getVwId(),"navigator");
								   			Iterator prfsIt = prfsColNav.iterator();
								   			while (prfsIt.hasNext()){
								   				ProfileVo prfVo = (ProfileVo) prfsIt.next();
								   				if (prfVo.getPrfName() != null){
								   					%><tr><td rowspan=<%=vwCant%>><%=prfVo.getPrfName()%></td></tr><%
								   				}
								   			}
								   		%></table></td><%//PERFILES DE LA VISTA EN MODO VISUALIZADOR%><td><table><%
								   			Collection prfsColVw = FunctionalityService.getInstance().getPrfsCanAccessVwFunct(cubeViewVo.getVwId(),"viewer");
								   			Iterator prfsvwIt = prfsColVw.iterator();
								   			while (prfsvwIt.hasNext()){
								   				ProfileVo prfVo = (ProfileVo) prfsvwIt.next();
								   				if (prfVo.getPrfName() != null){
								   					%><tr><td><%=prfVo.getPrfName()%></td></tr><%
								   				}
								   			}
								   		%></table></td></tr><%}%></table></td></tr><%}%></table></td></tr><%}%></table></div></td></tr></table><div id="xmlDiv" style="height:300px;border:1px solid black;position:relative;overflow:auto;"></div><form id="formXml" method="post" action="cubeXmlShow.jsp"><input type="hidden" name="xml" id="xml" /></form></body></html><script language="javascript">
var URL_ROOT_PATH="http://localhost:8080/Apia2.3/";
var schemas=new Object();
<%schIt = schCol.iterator();
while (schIt.hasNext()){
SchemaVo schemaVo = (SchemaVo) schIt.next();
%>
schemas["<%=schemaVo.getSchemaId()%>"]='<%=com.dogma.business.administration.SchemaService.getInstance().getXmlSchemaDef(schemaVo.getSchemaId())%>';
<%}%>

	function viewSchemaDef(schId) {
		//var xml = cubes[cubeId];
		//var modal=openModal("",500,300);
		//alert("XML "+cubes[cubeId]);
		document.getElementById("xmlDiv").innerHTML=escapeXML(schemas[schId]);
		//document.getElementById("xml").value=cubes[cubeId];
		//document.getElementById("formXml").target=modal.getElementsByTagName("IFRAME")[0].id;
		//document.getElementById("formXml").submit();
	}
	function escapeXML(xml){
		var xml2="";
		for(var i=0;i<xml.length;i++){
			if(xml.charAt(i)=="<"){
				xml2+="&lt;";
			}else if(xml.charAt(i)==">"){
				xml2+="&gt;";
			}else{
				xml2+=xml.charAt(i);
			}
		}
		return xml2;
	}	
</script>