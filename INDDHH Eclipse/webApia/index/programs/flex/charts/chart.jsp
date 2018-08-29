<%@page import="com.dogma.bean.DogmaAbstractBean"%><%DogmaAbstractBean myBean = (DogmaAbstractBean) session.getAttribute("wBean");
if (myBean==null){
	myBean = (DogmaAbstractBean) session.getAttribute("wBean");
}
out.clear();
out.print(myBean.getChartBean().getXmlChartData());%>
