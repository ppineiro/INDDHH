<%@ page session="true" contentType="text/html; charset=ISO-8859-1" %><%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %><jp:mondrianQuery id="query01" jdbcDriver="oracle.jdbc.driver.OracleDriver" jdbcUrl="jdbc:oracle:thin:apiabi/apiabi@sttest01:1521:apiatest" catalogUri="/queries/PCNP.xml">
select {[Measures].[Cantidad]} on columns, {( [Proceso],[Grupo] ) } on rows from PCNP

</jp:mondrianQuery><c:set var="title01" scope="session">4 hierarchies on one axis</c:set>
