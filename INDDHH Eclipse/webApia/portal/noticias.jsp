<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dogma.Configuration"%>


<!DOCTYPE html>
<head>
<script>
    /**
    * Array con las imagenes que se iran mostrando en la web
    */
    var imagenes=new Array(
        '<%=Configuration.ROOT_PATH %>/portal/img/img1.png',
        '<%=Configuration.ROOT_PATH %>/portal/img/img2.png',
        '<%=Configuration.ROOT_PATH %>/portal/img/img3.png',
        '<%=Configuration.ROOT_PATH %>/portal/img/img4.png'
    );
 
    /**
    * Funcion para cambiar la imagen
    */
    function rotarImagenes()
    {
        // obtenemos un numero aleatorio entre 0 y la cantidad de imagenes que hay
        var index=Math.floor((Math.random()*imagenes.length));
 
        // cambiamos la imagen
        document.getElementById("imagen").src=imagenes[index];
    }
 
    /**
    * Función que se ejecuta una vez cargada la página
    */
    onload=function()
    {
        // Cargamos una imagen aleatoria
        rotarImagenes();
 
        // Indicamos que cada 5 segundos cambie la imagen
        setInterval(rotarImagenes,5000);
    }
</script>
</head>
 
<body>
 
<img src="" id="imagen">
 
</body>
</html>

<%					
Date curDate = new Date();
SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
String DateToStr = format.format(curDate);
%>