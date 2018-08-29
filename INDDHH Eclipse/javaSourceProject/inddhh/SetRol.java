package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class SetRol extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		Entity currEnt = this.getCurrentEntity();
		String rol = this.getParameter("rol").getValueAsString();
		String loginUsuario = this.getParameter("usuario").getAttribute().getValueAsString();
		
		this.getCurrentProcess().setRol(rol, loginUsuario);
	}

}
