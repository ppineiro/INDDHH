package ddhh.manejoXML.apiaXml;

import java.awt.Desktop;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.SyncFailedException;
import java.util.Scanner;

import com.dogma.busClass.BusClassException;


/**
 * Métodos útiles para el manejo de archivos
 *
 */
public class FileIOHelper {
	
	/**
	 * Reads a text file to the end
	 * @param pathFile
	 * @return
	 * @throws IOException
	 */
	public static String readFile(String pathFile) 
	throws IOException {
		File f = null;
		FileReader r = null;
		
		try{
		  	StringBuffer strBuf = new StringBuffer();
		  	
		  	f = new File(pathFile);
		  	r = new FileReader(f);
		  	int c;
			while ((c = r.read()) != -1) {
				strBuf.append((char)c);
			}
			return strBuf.toString();
		} finally {
        	if (r != null){
         		r.close();
        	}
      	}
	}
	
	/**
	 * Reads a text file to the end
	 * @param pathFile
	 * @return
	 * @throws IOException
	 */
	public static String readFileWithEncoding(String pathFile, String encoding) 
	throws IOException {
		 	StringBuilder text = new StringBuilder();
		    String NL = System.getProperty("line.separator");
		    FileInputStream fis = new FileInputStream(pathFile);
		    Scanner scanner = new Scanner(fis, encoding);
		    try {
		      while (scanner.hasNextLine()){
		        text.append(scanner.nextLine() + NL);
		      }
		    }
		    finally{
		      scanner.close();
		      fis.close();
		    }
		    return text.toString();
		    
	}


	/**
	 * Reads a text file, using an input stream
	 * @param is
	 * @return
	 * @throws IOException
	 */
	public static String readFile(InputStream is) 
	throws IOException {
		InputStreamReader isr = null;
		try{
			isr = new InputStreamReader(is);
			
		  	StringBuffer strBuf = new StringBuffer();
		  	
		  	int c;
			while ((c = isr.read()) != -1) {
				strBuf.append((char)c);
			}
			return strBuf.toString();
		} finally {
        	if (isr != null){
         		isr.close();
        	}
      	}
	}
	

	/**
	 * Saves the data to the disk in the given file
	 * @param str
	 * @param pathFile
	 * @throws IOException
	 */
	public static void saveFile(String str, String pathFile) 
	throws IOException {
		FileWriter o = null;
		try{
			o = new FileWriter(pathFile, false);
			o.write(str);
			o.flush();
		}finally{
			if (o!= null){
				o.close();
			}
		}
	}
	

	/**
	 * Appends the data in the disk, at the given file
	 * @param str
	 * @param pathFile
	 * @throws IOException
	 */
	public static void appendFile(String str, String pathFile) 
	throws IOException {
		FileWriter o = null;
		try{
			o = new FileWriter(pathFile, true);
			o.write(str);
			o.flush();
		}finally{
			if (o!= null){
				o.close();
			}
		}
	}

	public static void copyFile(String sourceFile, String destFile, boolean createDirs) throws IOException {
		if (createDirs) {
			File file = new File(destFile);
			File dir = file.getParentFile();
			
			if (! dir.exists()) {
				dir.mkdirs();
			}
			
			if (! file.exists()) {
				file.createNewFile();
			}
		}
		
		FileIOHelper.copyFile(sourceFile,destFile);
	}
	
	/**
	 * Copies the source file into the output file
	 * @param sourceFile
	 * @param targetFile
	 * @throws IOException
	 */
	public static void copyFile(File sourceFile, File destFile) throws IOException {
			
		FileInputStream in = new FileInputStream(sourceFile);
		FileOutputStream out = new FileOutputStream(destFile);
	
		try {
			in.getFD().sync();
		} catch (SyncFailedException sfe) {}
	
		byte[] buffer = new byte[8 * 1024];
		int count = 0;
		do {
			out.write(buffer, 0, count);
			count = in.read(buffer, 0, buffer.length);
		} while (count != -1);

		try {
			out.getFD().sync();
		} catch (SyncFailedException sfe) {}

		in.close();
		out.flush();
		out.close();
	}
	
	
	/**
	 * Copies an inputStream into an outputStream
	 * @param in
	 * @param out
	 * @throws IOException
	 */
	public static final void copyInputStream(InputStream in, OutputStream out)
	throws IOException
	{
		byte[] buffer = new byte[1024];
		int len;

		while((len = in.read(buffer)) >= 0)
			out.write(buffer, 0, len);

		in.close();
		out.close();
	}
	
	/**Dado el path de un archivo obtiene su nombre
	 * 
	 * @param path
	 * @return
	 */
	public  static String getFileNameFromPath (String path) {
		int idx2 = path.lastIndexOf("/");
		int idx1 = path.lastIndexOf("\\");
		
		int idx = Math.max(idx1, idx2);

		if (idx != -1) {
			return path.substring(idx+1);
		} else {
			return path;
		}
	}
	
	
	/**
	 * Deletes the given directory
	 * @param dir
	 * @throws IOException
	 */
	public static void deleteDir(String dir) throws IOException {
		File fdir = new File(dir);
		
		String[] files = fdir.list();
		if (files != null) {
			for (int i = 0; i < files.length; i++) {
				String filePath = dir + File.separator + files[i];
				File fPath = new File(filePath);
				if (fPath.isFile()) {
					fPath.delete();
				} else if (fPath.isDirectory()) {
					FileIOHelper.deleteDir(filePath);
				}
			}
		}
		
		fdir.delete();
	}
	
	/**
	 * Copies the source file into the output file
	 * @param sourceFile
	 * @param targetFile
	 * @throws IOException
	 */
	public static void copyFile(String sourceFile, String targetFile) throws IOException {
		FileInputStream fis = new FileInputStream(sourceFile);
		FileOutputStream fos = new FileOutputStream(new File(targetFile));
		
		byte[] buffer = new byte[1024*1024];
		
		int len = fis.read(buffer); 
		while (len != -1) {
			fos.write(buffer, 0, len);
			len = fis.read(buffer);
		}

		fis.close();
		fos.flush();
		fos.close();
	}

	
	/**
	 * Moves the source file into the output file
	 * @param sourceFile
	 * @param targetFile
	 * @throws IOException
	 */
	public static void moveFile(String sourceFile, String targetFile) throws IOException {
		FileInputStream fis = new FileInputStream(sourceFile);
		FileOutputStream fos = new FileOutputStream(new File(targetFile));
		
		byte[] buffer = new byte[1024*1024];
		
		int len = fis.read(buffer); 
		while (len != -1) {
			fos.write(buffer, 0, len);
			len = fis.read(buffer);
		}

		fis.close();
		fos.flush();
		fos.close();
		
		File f = new File(sourceFile);
		f.delete();
	}
	
	/**
	 * Borrado de archivo
	 * @param fileName
	 * @throws IOException
	 */
	public static void deleteFile(String fileName) throws IOException {
		File f = new File(fileName);
		if (f.exists()) {
			f.delete();
		}
	}
	
	/**
	 * Deletes the given directory
	 * @param dir
	 * @throws IOException
	 */
	public static void copyDir(String source, String target) throws IOException {
		File sdir = new File(source);
		
		String[] files = sdir.list();
		if (files != null) {
			for (int i = 0; i < files.length; i++) {
				File auxFile = new File(source + "/" + files[i]);
				if (auxFile.isFile()) {
					// Copy the file
					FileIOHelper.copyFile(source + "/" + files[i], target + "/" + files[i]);
				} else if (auxFile.isDirectory()) {
					// Copy the directory, and recursivly copy the files
					new File(target + "/" + files[i]).mkdirs();
					FileIOHelper.copyDir(source + "/" + files[i], target + "/" + files[i]);
				}
			}
		}
	}

    /**
     * Gets the size of a file in bytes
     * @param output
     * @return
     */
	public static long getSizeInBytes(String output) {
		File faux = new File(output);
		if (faux.exists() && faux.isFile()) {
			return faux.length();
		}
		
		return -1;
	}
	
	/**
	 * Abre una ventana para visualizar el contenido de un archivo usando el rpograma
	 * por defecto
	 * @param archivo
	 * @throws BusClassException
	 */
	public static void openFile(String archivo,String path) throws IOException{
		FileInputStream in = new FileInputStream(archivo);
		FileOutputStream out = new FileOutputStream(path);

		byte[] buffer = new byte[8 * 1024];
		int count = 0;
		do {
			out.write(buffer, 0, count);
			count = in.read(buffer, 0, buffer.length);	
		} while (count != -1); 

		in.close();
		out.close();

		File f = new File(path);
		if(f.exists()){
			Desktop.getDesktop().open(f);
		}

	}
	
	/**
	 * Dado un string con el path de un archivo, obtiene el array de bytes que lo representa
	 * @param archivo
	 * @return
	 * @throws Exception
	 */
	public static byte[] getFileToByte(String archivo) throws Exception {
		try {
			FileInputStream fis = null;

			fis = new FileInputStream(archivo);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			int b;

			while ((b = fis.read()) != -1) {
				baos.write(b);
			}

			byte[] fileData = baos.toByteArray();

			return fileData;

		} catch (Exception e) {
			throw new Exception(e.getMessage());					
		}
	}
	
	public static void getFileFromByte(byte[] data, String archivo) throws Exception {
		
		OutputStream out = new FileOutputStream(archivo);
		out.write(data);
		out.close();
	}
	

}
