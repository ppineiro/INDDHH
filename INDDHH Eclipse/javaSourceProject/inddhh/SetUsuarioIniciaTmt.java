package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;

public class SetUsuarioIniciaTmt extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		String iniciante = this.getCurrentUser().getLogin();
		
		this.getCurrentEntity().getAttribute("INDDHH_INICIANTE_TMT_STR").setValue(iniciante);
	}

}
