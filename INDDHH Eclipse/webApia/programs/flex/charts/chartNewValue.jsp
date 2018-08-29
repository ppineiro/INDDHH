<%@page import="com.dogma.bean.DogmaAbstractBean"%><%DogmaAbstractBean myBean = (DogmaAbstractBean) session.getAttribute("wBean");
if (myBean==null){
	myBean = (DogmaAbstractBean) session.getAttribute("wBean");
}
Integer id = new Integer(request.getParameter("id"));
out.clear();
if (myBean.getChartBean()!=null){
	out.print(myBean.getChartBean().getXmlNewValue(id));
}%>