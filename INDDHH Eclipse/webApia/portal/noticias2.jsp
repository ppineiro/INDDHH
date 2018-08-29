<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dogma.Configuration"%>

<html>
<head>
	<title>N2</title>
	<script>
    /**
    * Array con las paginas que se iran mostrando en la web
    */
    var paginas=new Array(
        '<%=Configuration.ROOT_PATH %>/portal/noticias1.jsp',
        '<%=Configuration.ROOT_PATH %>/portal/noticias2.jsp',
        '<%=Configuration.ROOT_PATH %>/portal/noticias3.jsp',
        '<%=Configuration.ROOT_PATH %>/portal/noticias4.jsp'
    );
 
    /**
    * Funcion para cambiar la imagen
    */
    function changePag(){
        // obtenemos un numero aleatorio entre 0 y la cantidad de paginas que hay
        var index=Math.floor((Math.random()*paginas.length));
 
		// cambiamos la pagina
		//window.location.href = paginas[index];	
		parent.document.getElementById("iframe_pnlId_1_1007_1068").innerHTML = "<iframe src='" + paginas[index] + "' width='100%' frameborder='0' height='400px' ></iframe>";        
        
    }
 
    /**
    * Función que se ejecuta una vez cargada la página
    */
    onload=function(){	
        // Indicamos que cada 5 segundos cambie la imagen
        setInterval(changePag,5000);
    }
	</script>
</head>
 
<body>
 
<div style="padding:1px;">
				<h2 style="color:#00558d;text-transform: uppercase;font-size: 0.8em;font-family: Arial Black;">antel arena</h2>
												<div class="image">
			<img src="http://www.elpais.com.uy/files/section_list_art_small/uploads/2015/06/07/5574ce178c6d9.jpg" alt="">
		</div>
			<a style="font-size: 1.6em;color: #1b1b1b;font-family: 'UtopiaStd-Bold';" href="http://www.elpais.com.uy/informacion/astori-obra-antel-arena-detiene-retoma-condiciones.html" class="news-title">
		Danilo Astori: "La obra se detiene", pero "no habrá que pagar multas"
	</a>

	<div class="text" style="font-size: 1em;color: #1b1b1b;margin: 12px 0 0;line-height: 16px;">
		El ministro de Economía y Finanzas, Danilo Astori, confirmó que las obras de construcción del Antel Arena se detendrán y se retomarán "cuando el gobierno considere que están dadas las condiciones". Aseguró que"no habrá que pagar multas".
   </div>
</div>
 
</body>
</html>

<%					
Date curDate = new Date();
SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
String DateToStr = format.format(curDate);
%>