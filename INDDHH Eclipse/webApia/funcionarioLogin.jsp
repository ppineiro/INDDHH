<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<script type="text/javascript">
<%--  tramitaton --%>
document.location.href="apia.portal.PortalAction.run?dshId=1045&langId=<%=com.dogma.controller.ThreadData.getUserData().getLangId()%>&tabId=9999&tokenId=<%=com.dogma.controller.ThreadData.getUserData().getTokenId()%>";
<%--  tramitaton oracle--%>
<%-- document.location.href="apia.portal.PortalAction.run?dshId=1161&langId=<%=com.dogma.controller.ThreadData.getUserData().getLangId()%>&tabId=9999&tokenId=<%=com.dogma.controller.ThreadData.getUserData().getTokenId()%>"; --%>
//document.location.href="apia.portal.PortalAction.run?dshId=1022&langId=<%=com.dogma.controller.ThreadData.getUserData().getLangId()%>";
<%-- document.location.href="<%=com.dogma.Parameters.ROOT_PATH%>/page/login/classic/login.jsp"; --%>
</script>
