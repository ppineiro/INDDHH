package ddhh.manejoXML.apiaXml;

import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import com.dogma.Parameters;
import com.st.util.logger.FileLogger;
import com.st.util.logger.Logger;

public class LogParserApiaXML {

	public static Logger logger = null;
	
	static {
		Map<String,String> map = new HashMap<String,String>();
		map.put(FileLogger.PARAMETER_DIRECTORY,Parameters.LOG_DIRECTORY);
		map.put(FileLogger.PARAMETER_DISPLAY_TIME,Parameters.LOG_SHOW_TIME);
		map.put(FileLogger.PARAMETER_PREFIX,"LOG_PARSE_APIA_XML");
		map.put(FileLogger.PARAMETER_SUFFIX,".log");
		map.put(FileLogger.PARAMETER_PERIODICITY,"Daily");
		logger = new FileLogger(true,map);
		//logger.setVerboseLevel(FileLogger.ERROR);
		logger.setVerboseLevel(FileLogger.DEBUG);
	}
	
	private static String toString(Throwable t) {
		ByteArrayOutputStream bytes = new ByteArrayOutputStream();
	    PrintWriter writer = new PrintWriter(bytes,true);
	    t.printStackTrace(writer);
	    writer.close();
	    return bytes.toString();
	}
	
	public static void debug(String message) {
		LogParserApiaXML.logger.log(message, Logger.DEBUG);
	}
	
	public static void error(String message, Throwable t) {
		LogParserApiaXML.logger.log(message, Logger.ERROR);
		LogParserApiaXML.logger.log(LogParserApiaXML.toString(t), Logger.ERROR);
	}
}