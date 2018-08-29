/* SCRIPTS */

// Reemplaza clase 'no-js' del tag <html> por la clase 'js'
docElement = document.getElementsByTagName('html')[0];
docElement.className = docElement.className.replace(/\bno-js\b/,'') + ' js';

var newURL = window.location.protocol + "//" + window.location.host + "/" + window.location.pathname;
//var newURL = "http://tramites.gub.uy/busqueda?q=cedula";
		//var pathArray = window.location.pathname.split( '/' );
		var pathArray = newURL.split( '/' );
		var secondLevelLocation = pathArray[3]; // 8
		console.log(secondLevelLocation);
		var parametroArray = secondLevelLocation.split( '?' );
		var parametro = parametroArray[0];
		if (parametro == "busqueda"){
			docElement = document.getElementsByTagName('html')[0];
			docElement.className = docElement.className + ' busqueda';
		}
		
/* asginar alto y ancho de pantalla como variables globales */
$(window).resize(function() {
	var anchoPantalla = $(window).width();
	var altoPantalla = $(window).height();
});
		

/*
MENU ACCESIBLE
*/
$(document).ready(function()
{
    $(".menu").accessibleDropDown();
});

$.fn.accessibleDropDown = function ()
{
    var el = $(this);

    /* Setup dropdown menus for IE 6 */

    $("li", el).mouseover(function() {
        $(this).addClass("hover");
    }).mouseout(function() {
        $(this).removeClass("hover");
    });
    
    /* Make dropdown menus keyboard accessible */

    $("input", el).focus(function() {
        $(this).parents("li").addClass("hover");
    }).blur(function() {
        $(this).parents("li").removeClass("hover");
    });
    
    $("a", el).focus(function() {
        $(this).parents("li").addClass("hover");
    }).blur(function() {
        $(this).parents("li").removeClass("hover");
    });
}
/* fin MENU ACCESIBLE */


/* Items colapsables en tramite ampliado */
//$(function(){
$(document).ready(function (){	
	//alert('funciona?');
		var anchoPantalla = $(window).width();
		if (anchoPantalla < 768){
			$(".itemsTramites > li").addClass('cerrado');
			$(".itemsTramites > li h4").addClass('colapsable');
			
			$(".itemsTramites > li h4").click(function(event) {
				$(this).parent().toggleClass('cerrado').toggleClass("abierto");
			});
		}
	});
		
// contenedor categorias
$(function(){
	$("#layout li a.catLink").click(function(event) {
		var id = $(this).attr('id');
		
		// desplazo la pantalla al contenedor
		/*$('html, body').animate({
				scrollTop: $(".categorias").offset().top - 100
			}, 2000);
		*/
		
		// cargar categorias
		var myjson = '{"categorias":[{"nombre":"Hogar y Familia","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Hogar_y_Familia&title=Hogar+y+Familia","subcategorias":[{"nombre":"Vivienda y Hábitat","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Vivienda_y_Habitat&title=Vivienda+y+H%C3%A1bitat"},{"nombre":"Salud","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Salud&title=Salud"},{"nombre":"Seguridad P\u00FAblica","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Seguridad_Publica&title=Seguridad+P%C3%BAblica"},{"nombre":"Trabajo","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Trabajo&title=Trabajo"}]},{"nombre":"Uruguayos en el exterior","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Uruguayos_en_el_Exterior&title=Uruguayos+en+el+Exterior","subcategorias":null},{"nombre":"Documentaci\u00F3n","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Documentacion&title=Documentaci%C3%B3n","subcategorias":null},{"nombre":"Actividad Productiva y Empresarial","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Actividad_Productiva_y_Empresarial&title=Actividad+Productiva+y+Empresarial","subcategorias":[{"nombre":"Gesti\u00F3n de Empresas","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Gestion_de_Empresas&title=Gesti%C3%B3n+de+Empresas"},{"nombre":"Gesti\u00F3n Medio Ambiental","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Gestion_Medio_Ambiental&title=Gesti%C3%B3n+Medio+Ambiental"},{"nombre":"Industrial y Minera","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Industrial_y_Minera&title=Industrial+y+Minera"},{"nombre":"Transporte y Obras","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Transporte_y_Obras&title=Transporte+y+Obras"},{"nombre":"Turismo","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Turismo&title=Turismo"},{"nombre":"Agropecuaria y Pesquera","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Agropecuaria_y_Pesquera&title=Agropecuaria+y+Pesquera"}]},{"nombre":"Cultura","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Cultura&title=Cultura","subcategorias":[{"nombre":"Educaci\u00F3n","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Educacion&title=Educaci%C3%B3n"},{"nombre":"Patrimonio","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Patrimonio&title=Patrimonio"},{"nombre":"Recreaci\u00F3n","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Recreacion&title=Recreaci%C3%B3n"}]},{"nombre":"Beneficios sociales","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Beneficios_Sociales&title=Beneficios+Sociales","subcategorias":null},{"nombre":"Discapacidad","url":"http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Discapacidad&title=Discapacidad","subcategorias":null}]}';

		var json = JSON.parse( myjson ); 
		var nombre = json.categorias[id].nombre;
		var link = json.categorias[id].url;
		
		// ocultar la lista de categorias
		$("#layout ul").hide();
			
		if (!$('div.overlay').length){ // le pregunto si no cree el overlay ya
			// creo el overlay con el nombre y url de la categoria
			$("#layout").append(
				'<div class="overlay">'+
					'<div class="overlay_h">'+
						'<a href="#"  id="cerrarOverlay">Todas las categorías</a>'+
						'<span class="overlay_title">'+nombre+'</span>'+
					'</div>'+
				'</div>'
			).hide().fadeIn('slow');

			// meto dentro del overlay las subcategorias
			$.each(json.categorias[id].subcategorias,function(i,subcategoria){
				$(".overlay").append(
					'<a href=\"' +subcategoria.url+ '\"  class=\"subcategoria\">' +subcategoria.nombre+ '</a>'
				);
			});
			
			$("#cerrarOverlay").click(cerrarOverlay);
		}
		
		return false;
	});
});

function cerrarOverlay(){
	$('.overlay').remove();
	$("#layout ul").fadeIn();
	return false;
}

// Buscador doble en tramite ampliado
function OnSubmitForm(){
	if (document.pressed == 'portal.gub.uy'){
		document.Buscador.action = 'http://buscador.gub.uy/search';
	}
	else if (document.pressed == 'Buscar en tramites.gub.uy'){
		document.Buscador.action ='http://tramites.gub.uy/busqueda';
	}
	return true;
}

// Abrir y cerrar menu principal
// Abrir y cerrar buscador
$(function () {
    $("#abrirMenu").click(function (event) {
        event.preventDefault();
        $('.menu ul').toggleClass('open-menu');
        if ($(".menu ul").is(':visible')) {
            $("html, body").animate({scrollTop: $("body").offset().top}, 1000);
        }
        $("body").toggleClass("m_open");
        
        if ($(".buscador").hasClass('open-buscador')) {
            $('.buscador').removeClass('open-buscador');
        }
    });
    
    $("#abrirBuscador").click(function (event) {
        event.preventDefault();
        $('.buscador').toggleClass('open-buscador');
        
        if ($(".menu ul").hasClass('open-menu')) {
            $('.menu ul').removeClass('open-menu');
        }
    });

    $(".btn-buscador").click(function (event) {
        event.preventDefault();
        $(".buscador-head").slideToggle();
    });
    
    /* abrir subitems
    $(".menu li .item").click(function (event) {
        event.preventDefault();
        this.parent().toggleClass("hover");
    }); */
    
    
    // mostrar listado de direcciones
    $(".btn-direcciones").click(function (event) {
        event.preventDefault();
        $("ul.listaDirecciones").slideToggle().toggleClass('direccionesAbierto');
        var estaAbierto = $("ul.listaDirecciones").hasClass('direccionesAbierto');
        if (estaAbierto) {
            $(".btn-direcciones").text('Cerrar listado de direcciones');
        } else {
            $(".btn-direcciones").text('Ver más direcciones');
        }
    });
    
    
    // Desplegar submenu responsive
   /* $(".menu ul li a").click(function (event) {
        event.preventDefault();
        $(this).next(".submenu").slideToggle();
    });*/
    
});