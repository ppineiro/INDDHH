<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><%@page import="com.dogma.bean.query.AdministrationBean" %><%@include file="../../../components/scripts/server/startInc.jsp" %><%@include file="../../../components/scripts/server/headInclude.jsp" %><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><title>Untitled Document</title></head><script language="javascript" defer="true">
	var color="<%=request.getAttribute("selectedColor")%>";
	function closeTheColorPicker() {
		window.parent.document.getElementById("colorPicker").style.display = "none";
	}
	
	function startColor(){
		setAColor(color);
	}
	
	function showColor(color){
		window.returnValue=color;
		closeColorPicker();
	}

	function setAColor(aColor) {
		var obj=getFlashObject("flashColorPicker");
		obj.SetVariable("call", "setJSColor,"+aColor);
	}	
	
	function closeColorPicker(){
		window.close();
	}
	function getFlashObject(movieName){
		if (window.document[movieName]){
			return window.document[movieName];
		}
		if (navigator.appName.indexOf("Microsoft Internet")==-1){
			if (document.embeds && document.embeds[movieName]){
				return document.embeds[movieName];
			}
		}else{ // if (navigator.appName.indexOf("Microsoft Internet")!=-1){
			return document.getElementById(movieName);
		}
	}
	if(!MSIE){
		window.parent.document.getElementById("modalBlocker").style.display="none";
	}
	if (document.addEventListener) {
		document.addEventListener("DOMContentLoaded", startColor, false);
	}else{
		startColor();
	}
</script><body><input type="hidden" id="colorSelected" value="" style="display:none"><object id="flashColorPicker" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="260" height="150"><param name="movie" value="colorpicker.swf"><param name="quality" value="high"><param name="wmode" value="transparent"><param name="FlashVars" value="confirm=<%=LabelManager.getName(labelSet,"flaCon")%>&cancel=<%=LabelManager.getName(labelSet,"flaCan")%>"><embed src="colorpicker.swf"  swliveconnect="true" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="260" height="150" name="flashColorPicker" FlashVars="confirm=<%=LabelManager.getName(labelSet,"flaCon")%>&cancel=<%=LabelManager.getName(labelSet,"flaCan")%>"></embed></object></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %>
