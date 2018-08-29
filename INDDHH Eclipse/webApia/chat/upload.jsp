<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@page import="biz.statum.chat.web.external.websocket.chat.ExternalManager"%><%@page import="biz.statum.chat.web.external.websocket.chat.ExternalComunicator"%><%

ExternalComunicator comunicator = ExternalManager.getInstance().getComunicator();
String jsonString = request.getParameter("json");
String result = comunicator.userUploadFile(jsonString, request, response);

%><%= result %>