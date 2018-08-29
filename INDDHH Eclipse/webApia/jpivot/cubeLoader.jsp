<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %><%@ taglib uri="http://www.tonbeller.com/wcf" prefix="wcf" %><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %><%@page import="java.io.BufferedReader"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.BIParameters"%><%@page import="com.dogma.bean.administration.CubeBean"%><%@ page session="true" contentType="text/html; charset=ISO-8859-1" %><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.UserData"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="java.io.File"%><%@page import="java.io.BufferedWriter"%><%@page import="java.io.FileWriter"%><%@page import="com.dogma.bean.administration.CubeViewBean"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.CubeBean"></jsp:useBean><html><head><title>JPivot Test Page</title><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/table/mdxtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/navi/mdxnavi.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/form/xform.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/table/xtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/tree/xtree.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/tabs.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/cubeLoader.css"><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/tabs.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/common.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/dimensions.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/viewBrowser.js" defer="true"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/util.js" defer="true"></script><style><c:if test="${navi01.visible}">
	.navigatorTd{
		vertical-align:top;
		width:200px;
		padding-top:0px;
		background-color:FEFEFE;
	}
	#navi01{
		width:200px;
	}
</c:if></style></head><body bgcolor=white onload="setDimensions();setTabs();setEditorSizer();startsizeHeights();"><div style="position:relative;height:35px"><table><tr><td width="100%"></td><td width="0px"><img src="../images/jpivot/analytics.gif" /></td></tr></table></div><form action="<%=Parameters.ROOT_PATH%>/jpivot/cubeLoader.jsp" method="post" id="frmMain" target="_self"><div id="divContent"><%
/////////// Obtenemos la definicion del cubo //////////////
	if(request.getParameter("cubeName")!=null && !"null".equals(request.getParameter("cubeName")) ){
		dBean.loadCubeVo(request.getParameter("cubeName"));	
	}
	if (dBean.getCubeVo() == null) {
		//msgAlertCubeNotFound(request.getParameter("cubeName"));
		System.out.println("NO SE ENCONTRO EL CUBO: " + request.getParameter("cubeName"));
	}
	
	Integer cubeId = dBean.getCubeVo().getCubeId();

	if(dBean.getJustLoaded()){
		if(request.getSession().getAttribute("toolbar01")!=null){
			request.getSession().removeAttribute("toolbar01");
		}
		dBean.setJustLoaded(false);
		request.getSession().removeAttribute("toolbar01");
		String jdbcDriver = null;
		if ("ORACLE".equals(BIParameters.BIDB_IMPLEMENTATION)){
			jdbcDriver = BIParameters.BI_ORACLE_DRIVER;
		}else if ("SQLSERVER".equals(BIParameters.BIDB_IMPLEMENTATION)){
			jdbcDriver = BIParameters.BI_SQLSERVER_DRIVER;
		}else if ("POSTGRES".equals(BIParameters.BIDB_IMPLEMENTATION)){
			jdbcDriver = BIParameters.BI_POSTGRES_DRIVER;
		}

		File cubeDef = new File(Parameters.APP_PATH+"/jpivot/cubeDefinitionXML.xml");
		BufferedWriter writer;
		writer = new BufferedWriter(new FileWriter(cubeDef, false));
		writer.write(dBean.getXmlCubeDef());
		writer.close();
		com.dogma.UserData udata = BasicBeanStatic.getUserDataStatic(request);
		String user = udata.getUserName();

		/////////// Obtenemos la definicion de la vista //////////////
		CubeViewBean cubeVwBean = new CubeViewBean();
		//Cargamos cualquier vista por defecto (si se quiere cargar una en particular en lugar de null pasar el nombre de la vista)
		Integer viewId=null;
		if(request.getParameter("viewId")!=null){
			viewId=new Integer(request.getParameter("viewId").toString());
		}
		cubeVwBean.loadCubeViewVo(cubeId,viewId);
%><c:set var="title01" scope="session">4 hierarchies on one axis</c:set><jp:mondrianQuery id="query01" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=BIParameters.BIDB_URL%>" jdbcUser="<%=BIParameters.BIDB_USR%>" jdbcPassword="<%=BIParameters.BIDB_PWD%>" catalogUri="/jpivot/cubeDefinitionXML.xml"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><c:if test="${query01 == null}"><jsp:forward page="."/></c:if><%}%><c:set var="title01" scope="session">Arrows</c:set><%-- define table, navigator and forms --%><jp:table id="table01" query="#{query01}"/><jp:navigator id="navi01" query="#{query01}" visible="true"/><wcf:form id="mdxedit01" xmlUri="/jpivot/table/mdxedit.xml" model="#{query01}" visible="false"/><wcf:form id="sortform01" xmlUri="/jpivot/table/sortform.xml" model="#{table01}" visible="false"/><wcf:form id="savebrowser01" xmlUri="/jpivot/views/viewBrowser.xml" model="#{query01}" visible="false"/><wcf:form id="loadbrowser01" xmlUri="/jpivot/views/viewBrowser.xml" model="#{query01}" visible="true"/><jp:print id="print01"/><wcf:form id="printform01" xmlUri="/jpivot/print/printpropertiesform.xml" model="#{print01}" visible="false"/><jp:chart id="chart01" query="#{query01}" visible="false"/><wcf:form id="chartform01" xmlUri="/jpivot/chart/chartpropertiesform.xml" model="#{chart01}" visible="false"/><wcf:table id="query01.drillthroughtable" visible="false" selmode="none" editable="true"/><%if("navigator".equals(dBean.getLoaderType())){%><%@include file="navigatorInclude.jsp" %><%}else{%><%@include file="viewerInclude.jsp" %><%}%><%if("true".equals(request.getAttribute("justSaved"))){%><c:set target="${savebrowser01}" property="visible" value="false" /><%}%><%if("true".equals(request.getAttribute("justLoaded")) || "true".equals(request.getParameter("justLoaded")) ){%><c:set target="${loadbrowser01}" property="visible" value="false" /><%}%><%-- render toolbar --%><wcf:render ref="toolbar01" xslUri="/jpivot/toolbar/htoolbar.xsl" xslCache="true"/><wcf:render ref="savebrowser01" xslUri="/jpivot/views/viewBrowser.xsl" xslCache="false"/><wcf:render ref="loadbrowser01" xslUri="/jpivot/views/viewBrowser.xsl" xslCache="false"/><input type="hidden" id="path" name="path" value="<%=request.getParameter("path")!=null?request.getParameter("path"):""%>" /><p><input type="hidden" name="browserAction" id="browserAction" value="<c:if test="${savebrowser01.visible}">save</c:if>"/><%-- if there was an overflow, show error message --%><c:if test="${query01.result.overflowOccured}"><p><strong style="color:red">Resultset overflow occured</strong><p></c:if><%String tabSet1=(String)request.getParameter("tabSet1"); 
if( tabSet1==null ){%><c:if test="${navi01.visible}"><%tabSet1="0";%></c:if><c:if test="${chart01.visible}"><%tabSet1="1";%></c:if><%}%><table class="divTable"><tr><%String navigator=(String)request.getParameter("navigator");
		if("true".equals(navigator)){%><%}%><c:if test="${navi01.visible}"><td class="navigatorTd"><div style="overflow:auto;"><%-- render navigator --%><wcf:render ref="navi01" xslUri="/jpivot/navi/navigator.xsl" xslCache="true"/><div></td></c:if><td style="vertical-align:top;/*width:100%*/"><c:if test="${table01.visible}"><div type="tabElement" tabElement="1" id="mainTabs" defaultTab="<%=tabSet1!=null?tabSet1:"0"%>" ontabswitch="document.getElementById('tabSet1').value=this.shownIndex"><div type="tab"  style="display:none;" tabTitle="Grid" tabText="Grid"><wcf:render ref="table01" xslUri="/jpivot/table/mdxtable.xsl" xslCache="true"/></div></c:if><c:if test="${chart01.visible}"><div type="tab" align="center" style="display:none;background-color:rgb(<c:out value="${chart01.bgColorR}"/>,<c:out value="${chart01.bgColorG}"/>,<c:out value="${chart01.bgColorB}"/>)" tabTitle="Chart" tabText="Chart"><wcf:render ref="chart01" xslUri="/jpivot/chart/chart.xsl" xslCache="true"/></div></c:if></td></tr></table><%String tabSet2=(String)request.getParameter("tabSet2"); 
if( tabSet2==null ){%><c:if test="${mdxedit01.visible}"><%tabSet2="0";%></c:if><c:if test="${sortform01.visible}"><%tabSet2="1";%></c:if><c:if test="${chartform01.visible}"><%tabSet2="2";%></c:if><c:if test="${chartform01.visible}"><%tabSet2="3";%></c:if><%}%><c:if test="${mdxedit01.visible || sortform01.visible || printform01.visible || chartform01.visible}"><div id="editorSizer" style="position:absolute;"><div id="editors" type="tabElement" defaultTab="<%=(tabSet2!=null)?tabSet2:"0"%>"  ontabswitch="document.getElementById('tabSet2').value=this.shownIndex"><c:if test="${mdxedit01.visible}"><div type="tab" <%if(!"0".equals(tabSet2)){%>style="display:none;" <%}%>tabText="MDX Query Editor" tabTitle="MDX Query Editor" style="display:none;"><%-- edit mdx --%><wcf:render ref="mdxedit01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${sortform01.visible}"><div type="tab" <%if(!"1".equals(tabSet2)){%>style="display:none;" <%}%>tabText="SORT" tabTitle="SORT" style="display:none;"><%-- sort properties --%><wcf:render ref="sortform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${chartform01.visible}"><div type="tab" <%if(!"2".equals(tabSet2)){%>style="display:none;" <%}%>tabText="Chart" tabTitle="Chart Properties" style="display:none;"><!-- <div id="chartProps"> --><%-- chart properties --%><wcf:render ref="chartform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${printform01.visible}"><div type="tab" <%if(!"3".equals(tabSet2)){%>style="display:none;" <%}%>tabText="Print" tabTitle="Print Properties" style="display:none;"><%-- print properties --%><wcf:render ref="printform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><!-- render the table --></div></div></c:if><!-- <a href=".">back to index</a> --></div><input type="hidden" id="tabSet1" name="tabSet1" value="<%=tabSet1%>"><input type="hidden" id="tabSet2" name="tabSet2" value="<%=tabSet2%>"><input type="hidden" id="navigator" name="navigator" value="<c:if test="${navi01.visible}">true</c:if>"><input type="hidden" id="cubeName" name="cubeName" value="<%=request.getParameter("cubeName")%>"></form></body></html><script language="javascript" defer="true">
	var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
	function sizeMainTabsWidth(){
		var tabElement=document.getElementById("mainTabs");
		var width=getStageWidth()-20;
		var editorSizer=document.getElementById("editorSizer");
		if(editorSizer){
			editorSizer.style.width=(width+5)+"px";
		}
		if(document.getElementById("editors")){
		var tabs=document.getElementById("editors").tabs;
			if(tabs){
				for(var i=0;i<tabs.length;i++){
					tabs[i].style.width=(width-15)+"px";
				}
			}
		}
		if(getElementsByClassName("navigatorTd")[0]){
			width-=getElementsByClassName("navigatorTd")[0].offsetWidth;
		}
		tabElement.style.width=width+"px";
		if(MSIE){
			addListener(window,"resize",sizeMainTabsWidth);		
			sizeMainTabsWidth();
		}
	}
	function startsizeHeights(){
		addListener(window,"resize",sizeHeights);
		sizeHeights();
	}
	function sizeHeights(){
		var width=getStageWidth();
		if(MSIE){
			document.body.style.padding="0px";
			document.body.style.margin="0px";
			document.body.style.marginLeft="10px";
			width+=5;
		}else{
			width+=20;
		}
		if(document.getElementById("browserBlock")){
			document.getElementById("browserBlock").style.height=getStageHeight()+"px";
			document.getElementById("browserBlock").style.width=(width)+"px";
		}
		if(!MSIE6){
		if(getElementsByClassName("navigatorTd")[0] && document.getElementById("editors")){
			var height1=getElementsByClassName("navigatorTd")[0].offsetHeight-30;
			var height2=getStageHeight()-170;
			document.getElementById("mainTabs").style.height=height1+"px";
			height2=height2-height1;
			if(MSIE){
				height2-=20;
			}
			if(height2<150){height2=150;}
			document.getElementById("editors").style.height=height2+"px";
		}else if(document.getElementById("editors")){
			var height=getStageHeight()-(document.getElementById("mainTabs").offsetHeight+170);
			if(MSIE){
				height2-=20;
			}
			document.getElementById("editors").style.height=height+"px";
		}else{
			document.getElementById("mainTabs").style.height=(getStageHeight()-170)+"px";
			if(getElementsByClassName("navigatorTd")[0]){
				getElementsByClassName("navigatorTd")[0].style.height=(getStageHeight()-170)+"px";
			}
		}
		}
	}
	window.parent.parent.hideResultFrame();
</script><script language="javascript">
	var URL_ROOT_PATH		 	= "<%=Parameters.ROOT_PATH%>";
	var cubeId					="<%=cubeId%>";
	var MSG_WRNG_VW_NAME        ="<%=LabelManager.getName("msgWrngVwName")%>";
  	function setEditorSizer(){
  		var srcData=document.getElementById("srcData");
  		if(srcData){
  			srcData.style.top=((getStageHeight()-srcData.clientHeight)/2)+"px";
  			srcData.style.left=((getStageWidth()-srcData.clientWidth)/2)+"px";
  		}
  		
  	}
  </script>
