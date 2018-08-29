package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Form;

public class CrearLinkGoogleMaps extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		Form currForm  = this.getCurrentForm();
		
		String calle = currEnt.getAttribute("").getValueAsString();
		String nroPuerta = currEnt.getAttribute("").getValueAsString();
		String ciudad = currEnt.getAttribute("").getValueAsString();
		String depto = currEnt.getAttribute("").getValueAsString();
		
		String link = crearLinkMaps(calle, nroPuerta, ciudad, depto);
		
		//currForm.getField("mapa").set(link);
		
	}
	
	private String crearLinkMaps(String calle, String nroPuerta, String ciudad, String depto) {
		String link = "";
		
		//Invocar servicio con direccion, ciudad y depto
		
		
		//Recorrer JSON en busca de coordenadas
		
		
		//Crear link http://maps.google.com/?q=lat,lon
		
				
		return link;
	}

}
