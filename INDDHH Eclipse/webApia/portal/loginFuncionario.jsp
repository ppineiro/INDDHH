<%@page import="com.dogma.Configuration"%>
<script type="text/javascript">
<%--  tramitaton postgres--%>
document.location.href="<%=Configuration.ROOT_PATH %>/apia.portal.PortalAction.run?dshId=1045&langId=<%=com.dogma.controller.ThreadData.getUserData().getLangId()%>&tabId=9999&tokenId=<%=com.dogma.controller.ThreadData.getUserData().getTokenId()%>";
<%--  tramitaton oracle--%>
<%-- document.location.href="<%=Configuration.ROOT_PATH %>/apia.portal.PortalAction.run?dshId=1161&langId=<%=com.dogma.controller.ThreadData.getUserData().getLangId()%>&tabId=9999&tokenId=<%=com.dogma.controller.ThreadData.getUserData().getTokenId()%>"; --%>

</script>