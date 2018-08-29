<%@page import="com.dogma.Parameters"%>

<!--[if i]><![endif]-->
<!DOCTYPE html>
<!--[if lt IE 9]><html class="jsOff ie" lang="es-ES"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="jsOff" lang="es-ES"><!--<![endif]--><!--[if IE]>
	<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE" />
<![endif]--><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta name="description" content="La descripción debe contener de 70 a 140 caracteres. Se hace referencia al contenido principal donde se muestran los átomos y moléculas del formulario tipo.">
    <meta name="author" content="Nombre autor">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, user-scalable=no">
	<title>Registro de Personas y Empresas</title>	
    <!-- CSS/RESET-GENERAL-FORMULARIOTIPO-RESPONSIVE -->
    <link rel="stylesheet" type="text/css" href="files/estilos-formulario-tipo.css" media="screen">
	
	<script type="text/javascript">
	
	function controlarPasos() {
	
		var checked = false;		
		var radios;
		
		var btns = frmData.pasonro1;
		for (var i=0; el=btns[i]; i++) {
			radios = el;						
			if (el.checked){				
				if (radios.value == "paso11"){
					checked = true;
				}
			}
		}
		if (!checked){			
			alert("Para poder continuar debe seleccionar la opción si.");
			radios.focus();
			return false;
		}
		
		var checked = false;
		var radios;
		
		var btns = frmData.pasonro2;
		for (var i=0; el=btns[i]; i++) {
			radios = el;						
			if (el.checked){				
				if (radios.value == "paso21"){
					checked = true;
				}
			}
		}
		if (!checked){			
			alert("Para poder continuar debe seleccionar la opción si.");
			radios.focus();
			return false;
		}
		
		frmData.submit();
	}
	
	</script>
</head>

<body role="document">
    <div class="contenedorGeneral">
        <div class="contGralContenido">
            <h1>Registro de Personas y Empresas</h1>	

			<h2>Requisitos del trámite</h2>			
			
			<!--
			<div class="dialog-box dialog-error">
                <div class="dialog-icon">
                    <span class="icn icn-circle-error-lg"></span>
                </div>
                <div class="dialog-data">
                    <span class="dialog-title">Hay <strong>3 errores</strong> en el formulario</span>
                    <ol class="lista-errores">
                        <li><a href="#">Debe ingresar una fecha</a></li>
                        <li><a href="#">Lorem ipsum ad his scripta</a></li>
                        <li><a href="#">Blandit incorrupte quaerendum in quo</a></li>
                    </ol>
                </div>
            </div>
			-->
							
			<br>
			
			<div class="dialog-box dialog-info">
				<div class="dialog-icon">
					<span class="icn icn-circle-info-lg"></span>
				</div>
				<div class="dialog-data">
					<span class="dialog-title">Mediante este trámite es posible realizar el registro en lí­nea de las personas y empresas que se relacionan con URSEC.</span>
					<span class="dialog-title">Registrando además del domicilio electrónico, los representantes y/o apoderados, los administradores de usuarios de trámites en lí­nea y los usuarios de notificaciones electrónicas.</span>
					<!-- <span class="dialog-title">Se recomienda leer el <a href="<%=Parameters.EXTERNAL_URL%>/docs/anexos/Instructivo_registro_personas_y_empresas.pdf" target="_blank">instructivo</a> previamente.</span>  -->
					<span class="dialog-title">Se recomienda ver el video según el tipo de persona o empresa que desea registrar:</span>
					<span class="dialog-title">- <a href="https://www.youtube.com/watch?v=4PibEQRrf-8" target="_blank">Persona física</a></span>
					<span class="dialog-title">- <a href="https://www.youtube.com/watch?v=7ZdeM00Wj2s&feature=youtu.be" target="_blank">Unipersonal</a></span>
					<span class="dialog-title">- <a href="https://www.youtube.com/watch?v=suvHR2fSOZc&feature=youtu.be" target="_blank">Persona jurídica</a></span>
					<span class="dialog-title">Para poder realizar el trámite, es necesario cumplir con los siguientes pasos previos:</span>						
				</div>
			</div>
								
			<form id="frmData" action="<%=Parameters.EXTERNAL_URL%>/portal/tramite.jsp?id=4559" method="post">
			<div class="dialog-box dialog-warning">
				<div class="dialog-icon">
					<span class="icn icn-warning-lg"></span>
				</div>
				<div class="dialog-data">
				<span class="dialog-title"><b>Paso 1: Registro en el Portal del Estado Uruguayo (</b><a href="https://www.youtube.com/watch?v=aJVZqXGWjCk" target="_blank">video</a><b>)</b></span>
					<ol>					
						<li>Es necesario que <b>todas</b> las personas que serán declaradas en el trámite "Registro de Personas y Empresas" se encuentren registrados en el Portal del Estado Uruguayo.</li>
						<li>Se debe tener en cuenta que las personas que se declararán pueden ser: titulares, representantes, apoderados, administradores de usuarios de trámites en lí­nea y los usuarios de notificaciones electrónicas.</li>
						<li>Cada persona, de no estar registrada, deberá registrarse en el <a href="https://gestionusuarios.portal.gub.uy/registro/index" target="_blank">Portal del Estado Uruguayo.</a></li>
							<br>
							<div>
										<span class="label label-align-top">¿Usted ya completo este paso?:</span>
										<ul class="group-list">							
											<li>
												<label for="paso11">
													<input id="paso11" name="pasonro1" value="paso11" title="Si" type="radio">
													<span>Si</span>
												</label>
											</li>
											<li>
												<label for="paso12">
													<input id="paso12" name="pasonro1" value="paso12" title="No" type="radio">
													<span>No</span>
												</label>
											</li>
										</ul>									
							</div>						
					</ol>                    
				</div>				
			</div>
							
			<div class="dialog-box dialog-warning">
				<div class="dialog-icon">
					<span class="icn icn-warning-lg"></span>
				</div>
				<div class="dialog-data">
					<span class="dialog-title"><b>Paso 2: Registro de Usuario de URSEC (</b><a href="https://www.youtube.com/watch?v=ewzrV9RoWKY&feature=youtu.be" target="_blank">video</a><b>)</b></span>
					<ol>					
						<li>A su vez, es necesario que todas las personas mencionadas anteriormente estén  registradas en el "Registro de Usuarios de URSEC".</li>
						<li>El registro debe realizarse mediante el trámite en lí­nea <a href="<%=Parameters.EXTERNAL_URL%>/portal/tramite.jsp?id=4313" target="_blank">Registro de Usuario de URSEC.</a></li>
						<!-- <li>NOTA: Si usted va a registrar en URSEC una Persona Física o Empresa Unipersonal de la que es titular, no es necesario presentar certificado notarial.</li> -->
							<br>
							<div>
										<span class="label label-align-top">¿Usted ya completo este paso?:</span>
										<ul class="group-list">							
											<li>
												<label for="paso21">
													<input id="paso21" name="pasonro2" value="paso21" title="Si" type="radio">
													<span>Si</span>
												</label>
											</li>
											<li>
												<label for="paso22">
													<input id="paso22" name="pasonro2" value="paso22" title="No" type="radio">
													<span>No</span>
												</label>
											</li>
										</ul>									
							</div>						
					</ol>                    
				</div>				
			</div>
			
			<div class="dialog-box dialog-warning">
				<div class="dialog-icon">
					<span class="icn icn-warning-lg"></span>
				</div>
				<div class="dialog-data">
					<span class="dialog-title"><b>Paso 3: Registro de Personas y Empresas en URSEC</b></span>
					<ol>					
						<li>Por último, se debe realizar el trámite "Registro de Personas y Empresas" declarando a las personas mencionadas en los pasos 1 y 2.</li>
						<li>Para completar este trámite, se debe acceder con un usuario registrado en el Portal del Estado Uruguayo, no siendo necesario que dicho usuario pertenezca al grupo anteriormente mencionado, por ejemplo, otro funcionario de la empresa.<br><br>
						Si el registro corresponde a una Persona jurídica, persona física o empresa unipersonal actuando con apoderado el trámite le requerirá <b>Certificado Notarial</b>.<br><br>
						<b>Condiciones del CERTIFICADO NOTARIAL</b>:<br><br>
						* Vigencia 30 días.<br>
						* <a href="<%=Parameters.EXTERNAL_URL%>/docs/anexos/MODELO_CERTIFICADO_NOTARIAL.pdf" target="_blank">Modelo</a>.<br>
						* Deberá certificar toda la información y los datos de las personas físicas o jurídicas declaradas en el formulario del trámite.<br><br>
						<b>Nota</b>: Se deberá escriturar en la sección Representantes/apoderados del trámite, todos los representantes (por Contrato Social o Estatutos) y/o apoderados que
						figuren como tales en el Certificado Notarial.					
						b) Escriturar en la Sesión Representantes, todos los representantes (por Contrato Social o Estatutos) y/o apoderados que figuren como tales en el Certificado Notarial.<br></li>
						<br>								
					</ol>                    
				</div>				
			</div>
			
			</form>
			
			<ul class="form-action-buttons">
				<li class="action-buttons-primary">
					<ul>
						<li>
							<button class="btn-lg btn-primario" onclick="controlarPasos()">Continuar al paso siguiente &gt;&gt;</button>
						</li>						
					</ul>
				</li>				
			</ul>							

        </div>
    </div>
	
</body>

</html>