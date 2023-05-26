<%@page import="com.clipsoft.clipreport.oof.connection.OOFConnectionMemo"%>
<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%> 
<%@page import="com.clipsoft.clipreport.server.service.ReportUtil"%>
<%@page import="com.clipsoft.org.apache.commons.lang.StringEscapeUtils"%>
<%@ page language="java" contentType="javascript/jsonp; charset=UTF-8" pageEncoding="UTF-8"%>
<%
try{
	Throwable exceptions = (Throwable) request.getAttribute("javax.servlet.error.exception");
 

	String ftpPath = "D:/RPT_FTP";   //리포트서버의 ftp메인경로

	String rptname = request.getParameter("rptname");  //리포트명
	String stone = request.getParameter("stone");


	String crfParams = new String(request.getParameter("param").getBytes("8859_1"), "EUC-KR");
	//String data1 = request.getParameter("data1");
	//String data2 = request.getParameter("data2");
	String fileName = request.getParameter("file_name");    //xml데이터 파일명
	String company_num = request.getParameter("company_num");  //사업자번호(사업자별로 ftp폴더구분을위함)
	//String rptcnt = request.getParameter("rpt_cnt");  //리포트총갯수(메인 : 1, 메인+서브 : 2 메인+서브+서브 : 3....)

	String data = "";

	// json 테스트 데이터
	//data1 = "{\"root\" :  ["
	//						  +   "{\"CUSTOM_CODE\" : \"TEST121\",\"CUSTOM_NAME\" :\"TEST2222\"}, "
	//						  +   "{\"CUSTOM_CODE\" : \"TEST111\",\"CUSTOM_NAME\" :\"TEST2222\"}, "
	//						  +   "{\"CUSTOM_CODE\" : \"TEST111\",\"CUSTOM_NAME\" :\"TEST2222\"}  "
	//						  + "]"
	//	  + "}";

	// 리포트서버의 clipreport4.properties 파일위치
	String propertyPath = "C:/OmegaPlus/upload/clipreport4/clipreport4/clipreport4.properties";

	OOFDocument oof = OOFDocument.newOOF();
	OOFFile file = oof.addFile("crf.root", "%root%/crf/" + rptname);
	//file.addConectionFile("con1", "C:/Program Files/Apache Software Foundation/Tomcat 8.0/webapps/ClipReport4/jsonfile.json");

	//JSONParser parser = new JSONParser();
	//Object obj = parser.parse(new FileReader("C:/Program Files/Apache Software Foundation/Tomcat 8.0/webapps/ClipReport4/jsonfile.json"));
	//JSONObject jsonObject = (JSONObject) obj;

	// fileName = "C:/Program Files/Apache Software Foundation/Tomcat 8.0/webapps/ClipReport4/xmlfile.xml";


	//ftp로 전송받은 xml 데이터파일의 위치
	fileName = ftpPath + "/" + company_num + "/" + fileName;


	//xml 데이터파일을 읽어들임
	FileReader fr = new FileReader(fileName); //파일읽기객체생성
	BufferedReader br = new BufferedReader(fr); //버퍼리더객체생성

	String line = null; 
	while((line=br.readLine())!=null){ //라인단위 읽기
	//out.println(line + "<br>"); 
		data = data + line;
	}

	 
	// 화면단에서 넘겨주는 매개변수
	//file.addField("sCode", "test1");
	//file.addField("sName", "ADDDㅌ");
	String[] crfParams1 = crfParams.split("\\^");
	for(int a = 0; a<crfParams1.length; a++){
		//System.out.println(crfParams1[a]);
		//System.out.println(crfParams1[a].split(":"));
		String temp[] = crfParams1[a].split(":");
		String name  = temp[0];
		String value = temp[1];
		//System.out.println(crfParams2);	
		file.addField(name, value);
	}

	 
	 
	//data = "<root><data1><CUSTOM_CODE>SB001</CUSTOM_CODE><CUSTOM_NAME>테스트</CUSTOM_NAME></data1></root>";
	
	// 컨넥션 설정

	OOFConnectionMemo mc1 = file.addConnectionMemo("JDBC1", data);
	mc1.addContentParamXML("SQLDS1", "utf-8", "root/data1");

	OOFConnectionMemo mc2 = file.addConnectionMemo("JDBC1", data);
	mc2.addContentParamXML("SQLDS2", "utf-8", "root/data2");

	OOFConnectionMemo mc3 = file.addConnectionMemo("JDBC1", data);
	mc3.addContentParamXML("SQLDS3", "utf-8", "root/data3");

	OOFConnectionMemo mc4 = file.addConnectionMemo("JDBC1", data);
	mc4.addContentParamXML("SQLDS4", "utf-8", "root/data4");

	OOFConnectionMemo mc5 = file.addConnectionMemo("JDBC1", data);
	mc5.addContentParamXML("SQLDS5", "utf-8", "root/data5");

	OOFConnectionMemo mc6 = file.addConnectionMemo("JDBC1", data);
	mc6.addContentParamXML("SQLDS6", "utf-8", "root/data6");

	OOFConnectionMemo mc7 = file.addConnectionMemo("JDBC1", data);
	mc7.addContentParamXML("SQLDS7", "utf-8", "root/data7");

	OOFConnectionMemo mc8 = file.addConnectionMemo("JDBC1", data);
	mc8.addContentParamXML("SQLDS8", "utf-8", "root/data8");

	OOFConnectionMemo mc9 = file.addConnectionMemo("JDBC1", data);
	mc9.addContentParamXML("SQLDS9", "utf-8", "root/data9");

	OOFConnectionMemo mc10 = file.addConnectionMemo("JDBC1", data);
	mc10.addContentParamXML("SQLDS10", "utf-8", "root/data10");

	// 컨넥션 설정 (메인리포트)
	//OOFConnectionMemo mc = file.addConnectionMemo("JDBC" + "1", data);
	//mc.addContentParamXML("SQLDS1", "utf-8", "root/data" + "1");
	//mc.addContentParamJSON("SQLDS1", "utf-8", "root");

	// 컨넥션 설정 (서브리포트)
	//OOFConnectionMemo mc2 = file.addConnectionMemo("JDBC2", data2);
	//mc2.addContentParamJSON("SQLDS1", "utf-8", "root");


	// Key생성 및 리포트생성
	String resultKey =  ReportUtil.createReport(request, oof.toString(), "true", "false", "localhost", propertyPath);
 
	// 클라이언트로 해당Key Return
	out.println(stone + "(");
	out.println("{\"data\":{\"resultKey\":\""+resultKey+"\"}}");
	out.println(")");
} catch (Exception ex) {

	ex.printStackTrace(new java.io.PrintWriter(out));


	   //RequestDispatcher dispatcher = request.getRequestDispatcher("http://localhost:8080/ClipReport4/ErrorPage.jsp");

	   //dispatcher.forward(request, response);

}
%>
 