<%@page import="com.dogma.bean.execution.TaskBean"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.UserData"%><%@page import="java.util.ArrayList"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.DogmaException"%><%@page import="java.util.Iterator"%><%@page import="java.util.Collection"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.action.portlet.BasePortletAction"%><%

TaskBean dBean = (TaskBean) request.getSession().getAttribute("apiaPortletBean");
UserData userData	= dBean.getUserData(request);
Integer labelSet	= userData.getLabelSetId();
Integer langId		= userData.getLangId();

boolean mustShow	= false;
%><div class="apiaTitle"><b><%=LabelManager.getName(labelSet,langId,"lblMen")%></b></div><div class="apiaDesc">
Acción no soportada. Tarea no completada. Contactar al administrador.
</div><div class="apiaContainer"><a href="ProcessStartAction.portlet?action=onlyShowTask">Volver a la tarea</a></div><div class="apiaContainer"><a href="ProcessStartAction.portlet?<%= BasePortletAction.getInitialParamsUrl(request) %>">Volver al inicio</a></div>