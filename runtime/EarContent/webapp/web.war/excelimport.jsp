<%@page contentType="text/html;charset=UTF-8"%><%@page import="java.io.InputStream"%><%@page import="java.util.List"%><%@page import="nexcore.framework.core.util.BaseUtils"%><%@page import="nexcore.framework.online.channel.web.helper.MultipartRequestWrapper"%><%@page import="com.star.nexcore.file.FileResource"%><%@page import="com.star.nexcore.file.FileResourceManager"%><%@page import="org.apache.commons.fileupload.FileItem"%><%@page import="org.apache.commons.fileupload.util.Streams"%><%@ page import="java.util.*"%><%@ page import="java.io.*"%><%@ page import="org.apache.commons.fileupload.*"%><%@ page import="org.apache.commons.fileupload.disk.*"%><%@ page import="org.apache.commons.fileupload.servlet.*"%><%@ page import="org.apache.poi.ss.usermodel.*"%><%
	FileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload upload = new ServletFileUpload(factory);
	@SuppressWarnings("unchecked")
	List<FileItem> items = (List<FileItem>) upload.parseRequest(request);
	int i = items.size()-1;
	FileItem item = items.get(i);
	if (item.isFormField()) {
		//String name = item.getFieldName();
		//String value = item.getString();
	} else {
		String fileName = item.getName();
		String fileType = fileName.substring(fileName.lastIndexOf(".")+1,fileName.length());
		fileType = fileType.toLowerCase();
		
		if((!"xls".equals(fileType) && !"xlsx".equals(fileType))||"jsp".equals(fileType) || "exe".equals(fileType)){
			out.println("<script>alert('엑셀 파일이 아닙니다.');</script>");
			return;
		}
		
		InputStream uploadedStream = item.getInputStream();

		Workbook wb = WorkbookFactory.create(uploadedStream);
		Sheet sheet = wb.getSheetAt(0);

		out.print("[");

		int r = 0;
		List<String> titles = new ArrayList<String>();

		for (Row row : sheet) {
			if (r == 0) {
				for (Cell cell : row)
					titles.add(cell.getStringCellValue());
			} else {
				if (r > 1)
					out.print(",");

				out.print("{");

				int c = 0;

				for (Cell cell : row) {
					if (c > 0)
						out.print(",");

					String id = titles.get(c);
					String value = "";
					int type = cell.getCellType();
					
					out.print("\"");
					out.print(id);//id.replace("\\", "\\\\").replace("\"", "\\\"") // TODO: json encoding
					out.print("\"");
					out.print(":");
					out.print("\"");
					
					switch(type){
	                
	                case Cell.CELL_TYPE_BLANK: 
	                    break;
	                    
	                case Cell.CELL_TYPE_NUMERIC:
	                	cell.setCellType(Cell.CELL_TYPE_STRING);
	                	out.print(cell.getStringCellValue());
	                    break;
	                    
	                case Cell.CELL_TYPE_STRING: 
	                    out.print(cell.getStringCellValue()); 
	                    break;
	                    
	                case Cell.CELL_TYPE_ERROR:
	                	out.print(cell.getErrorCellValue()); 
	                    break; 
	                    
	                case Cell.CELL_TYPE_BOOLEAN:
	                	out.print(cell.getBooleanCellValue()); 
	                    break; 
	                    
	                case Cell.CELL_TYPE_FORMULA: 
	                	out.print(cell.getCellFormula()); 
	                    break; 
	                } 
					
					out.print("\"");

					c++;
				}

				out.print("}");
			}

			r++;
		}

		out.print("]");

		uploadedStream.close();

		// item.delete(); // TODO: file remove
	}
%>
