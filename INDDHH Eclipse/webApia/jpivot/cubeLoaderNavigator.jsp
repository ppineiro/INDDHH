<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %><%@ taglib uri="http://www.tonbeller.com/wcf" prefix="wcf" %><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %><%@page import="java.io.BufferedReader"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.BIParameters"%><%@page import="com.dogma.bean.administration.CubeBean"%><%@ page session="true" contentType="text/html; charset=ISO-8859-1" %><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.UserData"%><%--

  JPivot / WCF comes with its own "expression language", which simply
  is a path of properties. E.g. #{customer.address.name} is
  translated into:
    session.getAttribute("customer").getAddress().getName()
  WCF uses jakarta commons beanutils to do so, for an exact syntax
  see its documentation.

  With JSP 2.0 you should use <code>#{}</code> notation to define
  expressions for WCF attributes and <code>\${}</code> to define
  JSP EL expressions.

  JSP EL expressions can not be used with WCF tags currently, all
  tag attributes have their <code>rtexprvalue</code> set to false.
  There may be a twin library supporting JSP EL expressions in
  the future (similar to the twin libraries in JSTL, e.g. core
  and core_rt).

  Check out the WCF distribution which contains many examples on
  how to use the WCF tags (like tree, form, table etc).

--%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="java.io.File"%><%@page import="java.io.BufferedWriter"%><%@page import="java.io.FileWriter"%><%@page import="com.dogma.bean.administration.CubeViewBean"%><%@page import="com.st.util.labels.LabelManager"%><html><head><title>JPivot Test Page</title><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/table/mdxtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/navi/mdxnavi.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/form/xform.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/table/xtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/tree/xtree.css"><link rel="stylesheet" type="text/css" href="tabs.css"><script language="javascript" src="<%=Parameters.ROOT_PATH%>/tabs.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/common.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/dimensions.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/viewBrowser.js" defer="true"></script><style>
	.divTable{
		width:100%;
	}
	.divTable td{
/*		border:1px solid blue;*/
	}
	<c:if test="${navi01.visible}">
	.navigatorTd{
		vertical-align:top;
		width:200px;
		padding-top:0px;
		background-color:FEFEFE;
	}
	#navi01{
		width:200px;
	}
	</c:if>
	.navigatorTd div{
		position:relative;
	}
	.toolbar table{
/*		background-image:url(gradient.jsp?colors=F3F3F3;DFDFDF&height=60&width=1&type=v);*/
		background-repeat:repeat-x;
		padding:2px;
		/*padding-left:6px;
		padding-right:6px;*/
		border:2px solid #ADADAD;
		border-top:2px solid #DEDEDE;
		border-left:2px solid #DEDEDE;
		background-color:FEFEFE;
	}	
	/*div{border:1px solid blue;}*/
	#editors{
		height:100px;
		overflow:auto;
		position:relative;
		border:1px solid #E3E3E3;
		border-right:1px solid #999999;
		border-bottom:1px solid #999999;
		background-color:FEFEFE;
	}
	#editors div table{
		width:100%;
		font-family:tahoma;
		font-size:10px;
		background-color:#FFFFFF;
	}
	#editors div select{
		font-family:tahoma;
		font-size:10px;
	}
	#editors div option{
		font-family:tahoma;
		font-size:10px;
	}
	#editors div table tr td{
		/*text-align:center;*/
	}
	#editors div input{
		font-family:tahoma;
		font-size:10px;
	}
	#mainTabs{
		overflow:auto;
		height:300px;
		position:relative;
		width:100%;
		border:1px solid #E3E3E3;
		border-right:1px solid #999999;
		border-bottom:1px solid #999999;
		background-color:#FFFFFF;
	}
	#mainTabs div{
		background-color:#FFFFFF;
	}
	#viewsBrowser{
		position:absolute;
		width:300px;
		height:260px;
		border:1px solid #BBBBBB;
		border-bottom:#666666;
		border-right:#666666;
		z-index:999999;
		background-color:white;
		padding:5px;
	}
	#viewsBrowser img{
		cursor:pointer;
		cursor:hand;
	}
	#browserBlock{
		position:absolute;
		width:100%;
		height:100%;
		background-color:black;
		z-index:999990;
		filter:alpha(opacity=50);
		opacity: 0.5;
		-moz-opacity:0.5;
		top:0px;
		left:0px;
	}
	.selectedView{
		background-color:#E3FFD6;
	}
	BODY{
		background-color:#F3F3F3;
	}
</style></head><body bgcolor=white onload="setDimensions();setTabs();setEditorSizer();startsizeHeights();"><div style="position:relative;height:35px"><table><tr><td width="100%"></td><td width="0px"><img src="images/jpivot/analytics.gif" /></td></tr></table></div><form action="cubeLoaderNavigator.jsp" method="post" id="frmMain" target="_self"><div id="divContent"><%-- include query and title, so this jsp may be used with different queries --%><%
/////////// Obtenemos la definicion del cubo //////////////
CubeBean cubeBean = new CubeBean();
cubeBean.loadCubeVo(request.getParameter("cubeName"));
System.out.println("-------->Nombre Cubo: "+ request.getParameter("cubeName"));
Integer cubeId = cubeBean.getCubeVo().getCubeId();

if("true".equals(request.getParameter("justLoaded")) ){
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
writer.write(cubeBean.getXmlCubeDef());
writer.close();
com.dogma.UserData udata = BasicBeanStatic.getUserDataStatic(request);
String user = udata.getUserName();

/////////// Obtenemos la definicion de la vista //////////////
CubeViewBean cubeVwBean = new CubeViewBean();
//Cargamos cualquier vista por defecto (si se quiere cargar una en particular en lugar de null pasar el nombre de la vista)
Integer name=null;
if(request.getParameter("viewId")!=null){
	name=new Integer(request.getParameter("viewId").toString());
}
cubeVwBean.loadCubeViewVo(cubeId,name);
System.out.println("-------->Nombre Vista: "+ cubeVwBean.getCubeViewVo().getVwName());
System.out.println("------------->MDX:"+cubeVwBean.getMdxQuery());
%><jp:mondrianQuery id="query01" jdbcDriver="<%=jdbcDriver%>" jdbcUrl="<%=BIParameters.BIDB_URL%>" jdbcUser="<%=BIParameters.BIDB_USR%>" jdbcPassword="<%=BIParameters.BIDB_PWD%>" catalogUri="/jpivot/cubeDefinitionXML.xml"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><c:set var="title01" scope="session">4 hierarchies on one axis</c:set><c:if test="${query01 == null}"><jsp:forward page="."/></c:if><%}%><c:set var="title01" scope="session">Arrows</c:set><%-- define table, navigator and forms --%><jp:table id="table01" query="#{query01}"/><jp:navigator id="navi01" query="#{query01}" visible="true"/><wcf:form id="mdxedit01" xmlUri="/jpivot/table/mdxedit.xml" model="#{query01}" visible="false"/><wcf:form id="sortform01" xmlUri="/jpivot/table/sortform.xml" model="#{table01}" visible="false"/><wcf:form id="savebrowser01" xmlUri="/jpivot/views/viewBrowser.xml" model="#{query01}" visible="false"/><wcf:form id="loadbrowser01" xmlUri="/jpivot/views/viewBrowser.xml" model="#{query01}" visible="true"/><jp:print id="print01"/><wcf:form id="printform01" xmlUri="/jpivot/print/printpropertiesform.xml" model="#{print01}" visible="false"/><jp:chart id="chart01" query="#{query01}" visible="false"/><wcf:form id="chartform01" xmlUri="/jpivot/chart/chartpropertiesform.xml" model="#{chart01}" visible="false"/><wcf:table id="query01.drillthroughtable" visible="false" selmode="none" editable="true"/><%-- define a toolbar for Navigator mode --%><wcf:toolbar id="toolbar01" bundle="com.tonbeller.jpivot.toolbar.resources"><wcf:scriptbutton id="cubeNaviButton" tooltip="toolb.cube" img="cube" model="#{navi01.visible}"/><wcf:scriptbutton id="mdxEditButton" tooltip="toolb.mdx.edit" img="mdx-edit" model="#{mdxedit01.visible}"/><wcf:scriptbutton id="sortConfigButton" tooltip="toolb.table.config" img="sort-asc" model="#{sortform01.visible}"/><wcf:separator/><wcf:scriptbutton id="levelStyle" tooltip="toolb.level.style" img="level-style" model="#{table01.extensions.axisStyle.levelStyle}"/><wcf:scriptbutton id="hideSpans" tooltip="toolb.hide.spans" img="hide-spans" model="#{table01.extensions.axisStyle.hideSpans}"/><wcf:scriptbutton id="propertiesButton" tooltip="toolb.properties"  img="properties" model="#{table01.rowAxisBuilder.axisConfig.propertyConfig.showProperties}"/><wcf:scriptbutton id="nonEmpty" tooltip="toolb.non.empty" img="non-empty" model="#{table01.extensions.nonEmpty.buttonPressed}"/><wcf:scriptbutton id="swapAxes" tooltip="toolb.swap.axes"  img="swap-axes" model="#{table01.extensions.swapAxes.buttonPressed}"/><wcf:separator/><wcf:scriptbutton model="#{table01.extensions.drillMember.enabled}"	 tooltip="toolb.navi.member" radioGroup="navi" id="drillMember"   img="navi-member"/><wcf:scriptbutton model="#{table01.extensions.drillPosition.enabled}" tooltip="toolb.navi.position" radioGroup="navi" id="drillPosition" img="navi-position"/><wcf:scriptbutton model="#{table01.extensions.drillReplace.enabled}"	 tooltip="toolb.navi.replace" radioGroup="navi" id="drillReplace"  img="navi-replace"/><wcf:scriptbutton model="#{table01.extensions.drillThrough.enabled}"  tooltip="toolb.navi.drillthru" id="drillThrough01"  img="navi-through"/><wcf:separator/><wcf:scriptbutton id="chartButton01" tooltip="toolb.chart" img="chart" model="#{chart01.visible}"/><wcf:scriptbutton id="chartPropertiesButton01" tooltip="toolb.chart.config" img="chart-config" model="#{chartform01.visible}"/><wcf:separator/><wcf:scriptbutton id="printPropertiesButton01" tooltip="toolb.print.config" img="print-config" model="#{printform01.visible}"/><wcf:imgbutton id="printpdf" tooltip="toolb.print" img="print" href="./Print?cube=01&type=1"/><wcf:imgbutton id="printxls" tooltip="toolb.excel" img="excel" href="./Print?cube=01&type=0"/><wcf:separator/><wcf:scriptbutton id="saveButton01" tooltip="toolb.save" img="save-view" model="#{savebrowser01.visible}"/><wcf:scriptbutton id="loadButton01" tooltip="toolb.load" img="load-view" model="#{loadbrowser01.visible}"/></wcf:toolbar><%if("true".equals(request.getAttribute("justSaved"))){%><c:set target="${savebrowser01}" property="visible" value="false" /><%}%><%if("true".equals(request.getAttribute("justLoaded")) || "true".equals(request.getParameter("justLoaded")) ){%><c:set target="${loadbrowser01}" property="visible" value="false" /><%}%><%-- render toolbar --%><wcf:render ref="toolbar01" xslUri="/jpivot/toolbar/htoolbar.xsl" xslCache="true"/><wcf:render ref="savebrowser01" xslUri="/jpivot/views/viewBrowser.xsl" xslCache="false"/><wcf:render ref="loadbrowser01" xslUri="/jpivot/views/viewBrowser.xsl" xslCache="false"/><input type="hidden" id="path" name="path" value="<%=request.getParameter("path")!=null?request.getParameter("path"):""%>" /><p><input type="hidden" name="browserAction" id="browserAction" value="<c:if test="${savebrowser01.visible}">save</c:if>"/><%-- if there was an overflow, show error message --%><c:if test="${query01.result.overflowOccured}"><p><strong style="color:red">Resultset overflow occured</strong><p></c:if><%String tabSet1=(String)request.getParameter("tabSet1"); 
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
	window.parent.hideResultFrame();
</script><script language="javascript">
	var URL_ROOT_PATH		 	= "<%=Parameters.ROOT_PATH%>";
	var cubeId					="<%=cubeId%>";
	var MSG_WRNG_VW_NAME        ="<%=LabelManager.getName("msgWrngVwName")%>";
  	function setEditorSizer(){
  		
  	}
  </script>
