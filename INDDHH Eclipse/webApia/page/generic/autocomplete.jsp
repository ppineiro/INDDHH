<%@page import="biz.statum.apia.web.action.generic.AutoCompleteAction"%><%@page import="biz.statum.apia.web.bean.generic.AutoCompleteBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><%
HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
AutoCompleteBean adminBean = (AutoCompleteBean) AutoCompleteAction.staticRetrieveBean(http);
%><%= adminBean.getResult() %>
