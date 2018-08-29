<%@page import="com.dogma.Parameters"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<h1 class="logoMobile">
 <a href="https://www.ursec.gub.uy" title="URSEC: Unidad Reguladora de Servicios de Comunicaciones" target="_self"><img src="portal/img/logo-mobile.png" border="0" alt="URSEC: Unidad Reguladora de Servicios de Comunicaciones" width="186" height="91"></a>
</h1>
<div class="controlMobile">
	<div id="controlMenu" onclick="$('topnavMenu').toggleClass('visible');">Menu</div>
</div>
<div class="topnavMenu" id="topnavMenu">
   <ul class="topnav">
	  <!-- <li class="menuItem"><a href="<%= Parameters.ROOT_PATH %>" target="_top">Todos los trámites</a></li>  -->
      <li class="menuItem"><a href="apia.portal.PortalAction.run?dshId=1031&langId=<%=com.dogma.controller.ThreadData.getUserData().getLangId()%>&tabId=9998&tokenId=<%=com.dogma.controller.ThreadData.getUserData().getTokenId()%>" target="_top">Retomar Trámite</a></li>
	  <li class="menuItem"><a href="apia.portal.PortalAction.run?dshId=1032&langId=<%=com.dogma.controller.ThreadData.getUserData().getLangId()%>&tabId=9998&tokenId=<%=com.dogma.controller.ThreadData.getUserData().getTokenId()%>" target="_top">Consultar Expediente</a></li>
   </ul>
</div>

