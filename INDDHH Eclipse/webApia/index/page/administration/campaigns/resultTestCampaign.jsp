<%@page import="biz.statum.apia.web.action.administration.CampaignsAction"%><%@page import="biz.statum.apia.web.bean.administration.CampaignsBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html style="height: 95%;"><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"></head><body style="height: 100%;"><%
		HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
		CampaignsBean bean = CampaignsAction.staticRetrieveBean(http,false);
	%><%=bean.getTestResult()%></body></html>