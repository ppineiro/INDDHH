<%@page import="com.dogma.Configuration"%>
<link href="<%=Configuration.ROOT_PATH %>/portal/css/estilos-responsive.css?subtype=css" rel="stylesheet" type="text/css">
<style type="text/css">
	ul.points li {
	    background: transparent url("portal/img/bullet.png") no-repeat 0 8px;
	    padding-left: 15px;
	}
	h5 {
		color: #6b6b6b;
	}
	a.a-navigation {
		text-decoration: underline;
	}
	a.a-navigation:HOVER {
		text-decoration: none;
	}
</style>
 
<div class="contenedor accesos cfx" style="margin-bottom: 0px; border: none; box-shadow: none;">
	<div class="top cfx"><span class="topRg"></span></div>
	<div class="contenido group">
		<h5>Trámites recomendados</h5>
		<ul class="points">
			<li><a class="a-navigation" target="_top" href="apia.portal.PortalAction.run?action=init&viewItem=true&dshId=3&busEntInstId=4189">Solicitud de Grabación de Radio o TV</a></li>
			
			<li><a class="a-navigation" target="_top" href="apia.portal.PortalAction.run?action=init&viewItem=true&dshId=3&busEntInstId=4373">Venta de trasmisores radioeléctricos</a></li>
			
			<li><a class="a-navigation" target="_top" href="apia.portal.PortalAction.run?action=init&viewItem=true&dshId=3&busEntInstId=4374">Modificación de la participación societaria</a></li>
			
			<li><a class="a-navigation" target="_top" href="apia.portal.PortalAction.run?action=init&viewItem=true&dshId=3&busEntInstId=4375">Autorización de Transferencia o Cesión de Licencia</a></li>
			
			<li><a class="a-navigation" target="_top" href="apia.portal.PortalAction.run?action=init&viewItem=true&dshId=3&busEntInstId=4244">Alta y baja de estaciones de radiocomunicaciones</a></li>
		</ul>
	</div><!--contenido-->
	<div class="bottom cfx"><span class="botRg"></span></div>
</div>