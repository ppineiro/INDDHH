<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dogma.Configuration"%>

<html>
<head>
	<title>N3</title>
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
				<h2 style="color:#00558d;text-transform: uppercase;font-size: 0.8em;font-family: Arial Black;">INFORME DEL INSTITUTO CUESTA DUARTE</h2>
												<div class="image">
			<img src="http://www.elpais.com.uy/files/section_list_art_small/uploads/2014/12/04/5480fa501a9b5.jpg" alt="">
		</div>
			<a style="font-size: 1.6em;color: #1b1b1b;font-family: 'UtopiaStd-Bold';" href="http://www.elpais.com.uy/informacion/pit-pauta-salarial-incertidumbre-loteria.html" class="news-title">
		PIT dice que pauta salarial genera "incertidumbre" y "efecto lotería"
	</a>

	<div class="text" style="font-size: 1em;color: #1b1b1b;margin: 12px 0 0;line-height: 16px;">
		"Aceptar la lógica propuesta supone dotar de mucha incertidumbre al resultado de lo negociado, incorporando en los acuerdos un “efecto lotería” cuyo balance global recién podrá ser hecho una vez terminado el plazo del convenio", dice un informe del Instituto Cuesta Duarte.
   </div>
</div>
 
</body>
</html>

<%					
Date curDate = new Date();
SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
String DateToStr = format.format(curDate);
%>