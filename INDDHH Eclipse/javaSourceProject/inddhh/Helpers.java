package inddhh;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Helpers {

	public static boolean validarEmail(String email) {
		String emailPattern = "^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@" + "[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$";
		Pattern pattern = Pattern.compile(emailPattern);
		
		if (email != null) {
			Matcher matcher = pattern.matcher(email);
			if (matcher.matches()) {
				return true;
			} else {
				return false;
			}
		}
		
		return false;
	}
}
