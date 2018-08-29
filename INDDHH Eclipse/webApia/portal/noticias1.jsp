<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dogma.Configuration"%>

<html>

<head>
	<title>N1</title>
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
 
<div class="first-article hp_no_video " id="m40-39-41" style="padding:1px;"><h2 id="m51-1-52" style="color:#00558d;text-transform: uppercase;font-size: 0.8em;font-family: Arial Black;">cosse proyectó que pérdidas bajarán este año</h2>
<a id="m44-43-45" class="image right page-link " href="/informacion/aplican-plan-ajuste-equilibrar-cuentas.html" style="background: none;"><img src="http://www.elpais.com.uy/files/section_list_art_small/uploads/2015/05/27/556587e44db96.jpg"></a>
<a id="m57-2-58" style="font-size: 1.6em;color: #1b1b1b;font-family: 'UtopiaStd-Bold';"class="news-title page-link " href="/informacion/aplican-plan-ajuste-equilibrar-cuentas.html">Aplican plan de ajuste para equilibrar cuentas en Ancap</a><div class="description-image"><div id="m63-3-64" class="text fixed-width " style="font-size: 1em;color: #1b1b1b;margin: 12px 0 0;line-height: 16px;">El gobierno anunció ayer un plan de ajuste para que Ancap baje la pérdida de US$ 324,1 millones que registró en 2014, a US$ 50 millones en 2015. Para lograrlo se propone bajar el stock de combustible, readecuar créditos y pesificar parte de la deuda; reducir honorarios, tener más cuidado con las contrataciones, y bajar el nivel de las inversiones y la publicidad.</div></div>
</div>
 
</body>
</html>

<%					
Date curDate = new Date();
SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
String DateToStr = format.format(curDate);
%>