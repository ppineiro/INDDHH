<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dogma.Configuration"%>

<html>
<head>
	<title></title>
</head>

<body style="background-color: white">
<br>
<div align="center">

	<table width="300px" cellpadding="0" cellspacing="0" style="width: 300px">
		
		<tr style="font-weight: bold; height: 15px; color: #727272">
			<td style="border-width: 0px" colspan="2">
				<b>Moneda</b>
			</td>
			<td style="border-width: 0px; text-align: right;">
				<b>Promedio</b>
			</td>
		</tr>

		
				<tr style="background-color: #f3f3f4; height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/us.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						US$ Bill
					</td>
					<td style="border-width: 0px; text-align: right;">
						27,189
					</td>
				</tr>
			
				<tr style="height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/us.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						US$ Fdo
					</td>
					<td style="border-width: 0px; text-align: right;">
						27,142
					</td>
				</tr>
			
				<tr style="background-color: #f3f3f4; height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/euro.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						Euro
					</td>
					<td style="border-width: 0px; text-align: right;">
						29,9987
					</td>
				</tr>
			
				<tr style="height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/arg.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						Peso
					</td>
					<td style="border-width: 0px; text-align: right;">
						2,175
					</td>
				</tr>
			
				<tr style="background-color: #f3f3f4; height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/bra.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						Real
					</td>
					<td style="border-width: 0px; text-align: right;">
						8,55
					</td>
				</tr>
			
				<tr style="height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/ui.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
					   &nbsp
					</td>
					<td style="border-width: 0px; text-align: right;">
						3,0988
					</td>
				</tr>
			
		<tr style="height: 20px; color: #727272;">
			<td style="border-width: 0px; margin-right: 5px; text-align: center" 
				colspan="3">
				<%					
				Date curDate = new Date();
				SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
				String DateToStr = format.format(curDate);
				%>
				<span id="ctl00_ctl24_g_aedc6d69_2228_47a8_a410_a7c7f4ed87ef_ctl00_lblInfo">Cierre del <%=DateToStr%></span>
			</td>
		</tr>
	</table>    
</div>

</body>
</html>