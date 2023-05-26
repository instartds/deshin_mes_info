package foren.unilite.modules.human.hpa;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.email.EmailModel;
import foren.unilite.modules.com.email.EmailSendServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class HpaEmailController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/human/hpa/";
	
	/**
	 * 서비스 연결
	 */
	
	
	@Resource(name="hpa940ukrService")
	private Hpa940ukrServiceImpl hpa940ukrService;

	@Resource(name="emailSendService")
    private EmailSendServiceImpl emailSendService;
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@Resource(name="hpa900rkrService")
	private Hpa900rkrServiceImpl hpa900rkrService; 

	
	@RequestMapping(value="/human/hpa940ukr_mail.do", method=RequestMethod.POST)
	public ModelAndView hpa940ukr_mail(@RequestParam String data)throws Exception{
		Hpa940ukrYearModel hpa940ukrYearModel = new Hpa940ukrYearModel();
		Hpa940ukrWorkModel hpa940ukrWorkModel = new Hpa940ukrWorkModel();
		List<Hpa940ukrCode1Model> code1 = null;
		List<Hpa940ukrCode2Model> code2 = null;
		List<Hpa940ukrCode3Model> code3 = null;
		logger.debug("data : " + data.toString());
		
		Map<String,Object> rv = new HashMap<String,Object>();
		int totalCount = 0, sucessCount = 0, failureCount = 0;
		//스트링 파라미터 -> vo
		Gson gson = new Gson();
		Hpa940ukrModel[] hpa940ukrModelArray = gson.fromJson(data, Hpa940ukrModel[].class);
		
		String Root_Path=ConfigUtil.getUploadBasePath("EmailSalary")+"/";
		File filePath = new File(Root_Path);
		if(!filePath.exists())	{
			filePath.mkdir();
		}
		String title = hpa940ukrModelArray[0].getTITLE();
		
		//smtp 파일 정보 수집
		logger.debug("smtp 서버 정보 수집");
		Hpa940ukrSmtpModel smtp = hpa940ukrService.selectSmtpInfo(hpa940ukrModelArray[0].getS_COMP_CODE());
		smtp.setFROM_ADDR(hpa940ukrModelArray[0].getFROM_ADDR());
		logger.debug("smtp 서버 정보 : " + smtp.toString());
		
		
		//루프 돌면서 메일 전송
		logger.debug("메일 전송 루프 시작");
		 
	      int result = 0;
	      totalCount = hpa940ukrModelArray.length;
	      List<Map<String,Object>> rvList = new ArrayList<Map<String,Object>>();
	      
	      for (int i = 0; i < hpa940ukrModelArray.length; i ++) {
	    	  String work_yn = hpa940ukrModelArray[i].getWORK_YN();
	    	  String year_yn = hpa940ukrModelArray[i].getYEAR_YN();
	    	  
	    	  logger.debug("Send data : " + hpa940ukrModelArray[i].toString());
	    	  
	    	  Hpa940ukrEmailModel hpa940ukrEmailModel= hpa940ukrService.selectEmailList(hpa940ukrModelArray[i]);
	    	  
	    	  logger.debug("년월차 데이터 수집");
	    	  if(year_yn.equals("Y")) {
	    		  hpa940ukrYearModel = hpa940ukrService.selectYearInfo(hpa940ukrModelArray[i]);
	    		  
	    		  if(hpa940ukrYearModel != null)
	    			  logger.debug("hpa940ukrYearModel : " + hpa940ukrYearModel.toString());
	    		  else
	    			  logger.debug("hpa940ukrYearModel null");
	    	  }
	    	  
	    	  logger.debug("1. 근태 데이터 수집");
	    	  if(work_yn.equals("Y")) {
	    		  code1 = hpa940ukrService.selectCode1(hpa940ukrModelArray[i]);
	    		  if(code1 != null)
	    			  logger.debug("code1 : " + code1.toString());
	    		  else
	    			  logger.debug("code1 null");
	    	  }
	    	  
	    	  
	    	  logger.debug("2. 지금내역  수집");
    		  code2 = hpa940ukrService.selectCode2(hpa940ukrModelArray[i]);
    		  if(code2 != null)
    			  logger.debug("code2 : " + code2.toString());
    		  else
    			  logger.debug("code2 null");

    		  
    		  logger.debug("3. 공제내역  수집");
    		  code3 = hpa940ukrService.selectCode3(hpa940ukrModelArray[i]);
    		  if(code3 != null)
    			  logger.debug("code3 : " + code3.toString());
    		  else
    			  logger.debug("code3 null");

    		  
	    	  
	    	  //htm 파일 생성
	    	  MakeHtml makeHtml = new MakeHtml(hpa940ukrEmailModel, hpa940ukrYearModel, code1, code2, code3, hpa940ukrModelArray[i]);
	    	  
	    	  //String fname= Root_Path + hpa940ukrModelArray[i].getPAY_YYYYMM()+ "_" + hpa940ukrModelArray[i].getSUPP_NAME() + "_" + hpa940ukrModelArray[i].getNAME()+ "(" + hpa940ukrEmailModel.getPERSON_NUMB() + ")"+ ".htm";
	    	  String fname= Root_Path + hpa940ukrModelArray[i].getPAY_YYYYMM()+ "_" + "(" + hpa940ukrEmailModel.getPERSON_NUMB() + ")"+ ".htm";
	    	  
	    	  logger.debug("첨부파일 생성 시작");
	    	  File f = new File(fname);
	    	  if(f.isFile()) {
	    		  f.delete();
	    		  logger.debug("파일존재");
	    		  File f2 = new File(fname);
	    		  FileUtils.writeStringToFile(f2, makeHtml.getHtml(), "EUC-KR");
	    	  }else
	    	  {
	    		  File f2 = new File(fname);
	    		  FileUtils.writeStringToFile(f2, makeHtml.getHtml(), "EUC-KR");
	    	  }
	    	  logger.debug("첨부파일 생성 종료");
	  		
	  		
	    	  //sendMail_custom(title, smtp, hpa940ukrModelArray[i].getEMAIL_ADDR(), fname );
	    	  
	    	  
	    	  EmailModel emailModel = new EmailModel();
	    	  emailModel.setFROM(hpa940ukrModelArray[i].getFROM_ADDR());
	    	  emailModel.setSUBJECT(title);
	    	  emailModel.setTEXT("첨부파일을 참고하세요. ");
	    	  //emailModel.setTO("hhmw12.synergy@gmail.com"); //hpa940ukrModelArray[i].getEMAIL_ADDR()
	    	  emailModel.setTO(hpa940ukrModelArray[i].getEMAIL_ADDR()); 
	    	  emailModel.setFILE(fname);
	    	  Map smtpInfo = new HashMap();
	    	  /*smtpInfo.put("SERVER_NAME", "smtp.gmail.com");
	    	  smtpInfo.put("SERVER_PROT", "587");
	    	  smtpInfo.put("SEND_USER_NAME", "hhmw12.synergy@gmail.com");
	    	  smtpInfo.put("SEND_PASSWORD", "uniForen1!");*/
	    	  smtpInfo.put("SERVER_NAME", smtp.getSERVER_NAME());
	    	  smtpInfo.put("SERVER_PROT", smtp.getSERVER_PROT());
	    	  smtpInfo.put("SEND_USER_NAME", smtp.getSEND_USER_NAME());
	    	  smtpInfo.put("SEND_PASSWORD", smtp.getSEND_PASSWORD());
	    	  Map<String,Object> rvMap = new HashMap<String,Object>();
	    	  try{
	    		  emailSendService.sendMail(emailModel, smtpInfo);
	    		  rvMap.put("PERSON_NUMB", hpa940ukrModelArray[i].getPERSON_NUMB() );
	    		  rvMap.put("SEND_RESULT", "SUCCESS" );
	    		  rvMap.put("SEND_MSG",  "" );
	    		  sucessCount++;
	    	  } catch (Exception e){
	    		  logger.error(e.toString());
	    		  e.printStackTrace();
	    		  rvMap.put("PERSON_NUMB", hpa940ukrModelArray[i].getPERSON_NUMB() );
	    		  rvMap.put("SEND_RESULT",  "FAILURE" );
	    		  String message = e.getMessage();
	    		  if(message.indexOf(":") > -1)	{
	    			  message = message.substring(message.indexOf(":")+1, message.length());
	    		  }
	    		  rvMap.put("SEND_MSG", message);	    		  
	    		  failureCount++;
	    	  }
	    	  rvList.add(rvMap);
	      }
	      rv.put("sendList", rvList);
	      
	      String rvMessage = "[이메일 전송 작업 결과]\n" 
	      					+ "    전송요청 건수 : "+ String.valueOf(totalCount) + " 건\n"
	    		  			+ "    전송 성공     : " + String.valueOf(sucessCount) + " 건\n"
	    	    		  	+ "    전송 실패     : " + String.valueOf(failureCount)+ " 건";
	      
	      rv.put("sendSummary", rvMessage);
		return ViewHelper.getJsonView(rv);
	}
	
	
	@RequestMapping(value="/human/hpa940ukr_email_pdf.do", method=RequestMethod.POST)
	public ModelAndView hpa940ukr_email_pdf( HttpServletRequest request , @RequestParam String data, LoginVO user)throws Exception{
		
		Map<String,Object> rv = new HashMap<String,Object>();
		int totalCount = 0, sucessCount = 0, failureCount = 0;
		
		Gson gson = new Gson();
		Hpa940ukrModel[] hpa940ukrModelArray = gson.fromJson(data, Hpa940ukrModel[].class);
		
		String Root_Path=ConfigUtil.getUploadBasePath("EmailSalary")+"/";
		File filePath = new File(Root_Path);
		if(!filePath.exists())	{
			filePath.mkdir();
		}
		String title = hpa940ukrModelArray[0].getTITLE();
		
		//smtp 파일 정보 수집
		logger.debug("smtp 서버 정보 수집");
		Hpa940ukrSmtpModel smtp = hpa940ukrService.selectSmtpInfo(hpa940ukrModelArray[0].getS_COMP_CODE());
		smtp.setFROM_ADDR(hpa940ukrModelArray[0].getFROM_ADDR());
		logger.debug("smtp 서버 정보 : " + smtp.toString());
		
		
		//루프 돌면서 메일 전송
		logger.debug("메일 전송 루프 시작");
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(hpa940ukrModelArray[0].getS_COMP_CODE());
		CodeDetailVO codeDetail = codeInfo.getCodeInfo("B259", "1");
		String dispYearPay = "N";
		if("KDG".equals(ObjUtils.getSafeString(codeDetail.getRefCode1())) )	{
			dispYearPay = "Y";
		}
		
		Map<String,Object> initParam = new HashMap<String,Object>();
		
		initParam.put("S_COMP_CODE", hpa940ukrModelArray[0].getS_COMP_CODE());
		initParam.put("DATE_FR", hpa940ukrModelArray[0].getPAY_YYYYMM());
		initParam.put("DATE_TO", hpa940ukrModelArray[0].getPAY_YYYYMM());
		initParam.put("SUPP_TYPE", hpa940ukrModelArray[0].getSUPP_TYPE());
		
		hpa900rkrService.createReportData(initParam);
		
		int result = 0;
		totalCount = hpa940ukrModelArray.length;
		List<Map<String,Object>> rvList = new ArrayList<Map<String,Object>>();
		
		for (Hpa940ukrModel hpa940ukrModel : hpa940ukrModelArray) {
			String year_yn = hpa940ukrModel.getYEAR_YN();
			String work_yn = hpa940ukrModel.getWORK_YN();
			
			Map fparam = new HashMap();
			fparam.put("S_COMP_CODE", hpa940ukrModel.getS_COMP_CODE());
			fparam.put("DIV_CODE", hpa940ukrModel.getDIV_CODE());
			fparam.put("PERSON_NUMB", hpa940ukrModel.getPERSON_NUMB());
			fparam.put("DATE_FR", hpa940ukrModel.getPAY_YYYYMM());
			fparam.put("DATE_TO", hpa940ukrModel.getPAY_YYYYMM());
			fparam.put("PAY_YYYYMM", hpa940ukrModel.getPAY_YYYYMM());
			fparam.put("SUPP_TYPE", hpa940ukrModel.getSUPP_TYPE());
			fparam.put("DISP_YEAR_PAY", dispYearPay);
			fparam.put("SUPP_TOTAL_I", ("N".equals(hpa940ukrModel.getDETAIL_ZERO()) ? "Y" : "N"));
			fparam.put("OPTYN1", ("Y".equals(year_yn) ? "1" : "0"));
			fparam.put("MEMO", hpa940ukrModel.getCOMMENTS());
			fparam.put("S_USER_ID", user.getUserID());
			
			Hpa940ukrEmailModel hpa940ukrEmailModel= hpa940ukrService.selectEmailList(hpa940ukrModel);
			
			String fname=   hpa940ukrModel.getPAY_YYYYMM()+ "_" + "(" + hpa940ukrModel.getPERSON_NUMB() + ")"+ ".pdf";
			
			logger.debug("첨부파일 생성 시작");
			File f = makePdfFile(fparam,  fname, Root_Path, hpa940ukrEmailModel.getEMAIL_PWD() , user, request, work_yn );
			logger.debug("첨부파일 생성 종료");
			
			EmailModel emailModel = new EmailModel();
			emailModel.setFROM(hpa940ukrModel.getFROM_ADDR());
			emailModel.setSUBJECT(title);
			emailModel.setTEXT("첨부파일을 참고하세요. ");
			
			emailModel.setTO(hpa940ukrModel.getEMAIL_ADDR()); 
			emailModel.setFILE(Root_Path + fname);
			Map smtpInfo = new HashMap();
			
			smtpInfo.put("SERVER_NAME", smtp.getSERVER_NAME());
			smtpInfo.put("SERVER_PROT", smtp.getSERVER_PROT());
			smtpInfo.put("SEND_USER_NAME", smtp.getSEND_USER_NAME());
			smtpInfo.put("SEND_PASSWORD", smtp.getSEND_PASSWORD());
			Map<String,Object> rvMap = new HashMap<String,Object>();
			
			rvMap.put("S_COMP_CODE"	, user.getCompCode());
			rvMap.put("PAY_YYYYMM"	, hpa940ukrModel.getPAY_YYYYMM());
    		rvMap.put("SUPP_TYPE"	, hpa940ukrModel.getSUPP_TYPE());
			rvMap.put("PERSON_NUMB"	, hpa940ukrModel.getPERSON_NUMB());
			rvMap.put("DIV_CODE"	, hpa940ukrModel.getDIV_CODE());
			rvMap.put("NAME"		, hpa940ukrModel.getNAME());
			rvMap.put("DEPT_CODE"	, hpa940ukrModel.getDEPT_CODE());
			rvMap.put("DEPT_NAME"	, hpa940ukrModel.getDEPT_NAME());
			rvMap.put("EMAIL_ADDR"	, hpa940ukrModel.getEMAIL_ADDR());
			rvMap.put("S_USER_ID"	, user.getUserID());
			

    	    String  errorMessage = emailSendService.sendMailAsync(emailModel, smtpInfo);
    	    
	    	if ("".equals(errorMessage)){
				rvMap.put("SEND_RESULT", "성공" );
				rvMap.put("SEND_MSG",  "" );
				sucessCount++;
			} else {
				rvMap.put("PERSON_NUMB", hpa940ukrModel.getPERSON_NUMB() );
				rvMap.put("SEND_RESULT",  "실패" );
				
				if(errorMessage.indexOf(":") > -1)	{
					errorMessage = errorMessage.substring(errorMessage.indexOf(":")+1, errorMessage.length());
				}
				rvMap.put("SEND_MSG", errorMessage);
				failureCount++;
			}
	    	hpa940ukrService.updateLog(rvMap);
			rvList.add(rvMap);
		}
		rv.put("sendList", rvList);
		
		String rvMessage = "[이메일 전송 작업 결과]\n" 
							+ "    전송요청 건수 : "+ String.valueOf(totalCount) + " 건\n"
							+ "    전송 성공     : " + String.valueOf(sucessCount) + " 건\n"
							+ "    전송 실패     : " + String.valueOf(failureCount)+ " 건";
		
		rv.put("sendSummary", rvMessage);
		return ViewHelper.getJsonView(rv);
	}
	
	private String sendMail_custom(String title, Hpa940ukrSmtpModel vo, String addr, String fname) throws MessagingException {
		String host = vo.getSERVER_NAME();
        String username = vo.getSEND_USER_NAME();
        String password = vo.getSEND_PASSWORD();
        String port = vo.getSERVER_PROT();
        String sslUseYn = vo.getSSL_USE_YN();
        
        if(sslUseYn.equals("1")) {
        	sslUseYn = "true";
        }
        else {
        	sslUseYn = "false";
        }
        
        // 메일 내용
        String to = addr;
        String subject = title;
        String body = "첨부파일을 참고하세요. ";
         
        //properties 설정
        Properties props = new Properties();
        props.put("mail.smtp.auth", ConfigUtil.getProperty("common.emailSender.auth"));
        props.put("mail.smtp.ssl.enable", sslUseYn);
        props.put("mail.smtp.starttls.enable", ConfigUtil.getProperty("common.emailSender.starttls"));
        props.put("mail.smtp.debug", ConfigUtil.getProperty("common.emailSender.debug"));
        props.put("mail.smtp.quitwait", ConfigUtil.getProperty("common.emailSender.quitwait"));
        // 메일 세션
        Session session = Session.getDefaultInstance(props);
        MimeMessage msg = new MimeMessage(session);
        //MimeMessageHelper message = new MimeMessageHelper(msg, false, "utf-8");
        
        BodyPart messageBodyPart = new MimeBodyPart();
        
        //messageBodyPart.setText(body);
        messageBodyPart.setContent(body, "text/html; charset=utf-8");
        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(messageBodyPart);
        
        messageBodyPart = new MimeBodyPart();
        File file = new File(fname);
        FileDataSource fds = new FileDataSource(file);
        messageBodyPart.setDataHandler(new DataHandler(fds));
        messageBodyPart.setFileName(fds.getName());
        multipart.addBodyPart(messageBodyPart);
        
        
        // 메일 관련
        msg.setSubject(subject, "utf-8");
        //msg.setText(body);
        msg.setContent(multipart, "text/html; charset=UTF-8");
        msg.setFrom(new InternetAddress(username));
        msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
 
        // 발송 처리
        Transport transport = session.getTransport(ObjUtils.getSafeString(ConfigUtil.getProperty("common.emailSender.protocol")));
        logger.debug("prop:"+props.toString());
        
        transport.connect(host, Integer.parseInt(port), username, password);
        transport.sendMessage(msg, msg.getAllRecipients());
        transport.close(); 
        
        return "success";
	}
	
	
	
	
	private String sendMail_gmail(Hpa940ukrSmtpModel hpa940ukrSmtpModel, String fname) throws MessagingException {
		String host = "smtp.gmail.com";
		String username ="";
		
		if(hpa940ukrSmtpModel.getFROM_ADDR().equals(""))
			username = "jokingboy@gmail.com";
		else 
			username = hpa940ukrSmtpModel.getFROM_ADDR();
        
        String password = "------";
         
        // 메일 내용
        String to = "jokingboy@naver.com";
        String subject = "지메일을 사용한 발송 테스트입니다.";
        String body = "내용 무";
         
        //properties 설정
        Properties props = new Properties();
        props.put("mail.smtps.auth", "true");
        // 메일 세션
        Session session = Session.getDefaultInstance(props);
        MimeMessage msg = new MimeMessage(session);
 
        BodyPart messageBodyPart = new MimeBodyPart();
        
        messageBodyPart.setText("테스트용 메일의 내용입니다.");
        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(messageBodyPart);
        
        messageBodyPart = new MimeBodyPart();
        File file = new File("e:/test.htm");
        FileDataSource fds = new FileDataSource(file);
        messageBodyPart.setDataHandler(new DataHandler(fds));
        messageBodyPart.setFileName(fds.getName());
        multipart.addBodyPart(messageBodyPart);
        
        
        // 메일 관련
        msg.setSubject(subject);
        //msg.setText(body);
        msg.setContent(multipart);
        msg.setFrom(new InternetAddress(username));
        msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
 
        // 발송 처리
        Transport transport = session.getTransport("smtps");
        transport.connect(host, username, password);
        transport.sendMessage(msg, msg.getAllRecipients());
        transport.close(); 
        
        return "success";
	}
	
	private String sendMail_naver() throws Exception {
		
		String host = "smtp.naver.com";
        final String username = "jokingboy";
        final String password = "----";
        int port=465;
         
        // 메일 내용
        String to = "jokingboy@naver.com";
        String from = "jokingboy22@naver.com";
        String subject = "네이버를 사용한 발송 테스트입니다.";
        String body = "내용 무";
         
        Properties props = System.getProperties();
         
         
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.trust", host);
          
        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
            String un=username;
            String pw=password;
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(un, pw);
            }
        });
        session.setDebug(true); //for debug
          
        Message mimeMessage = new MimeMessage(session);
        mimeMessage.setFrom(new InternetAddress(from));
        mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
        mimeMessage.setSubject(subject);
        mimeMessage.setText(body);
        logger.debug("send email============================");
        
        Transport.send(mimeMessage);
		return "success";
	}
	
	
	private File makePdfFile(Map param, String fileName, String filePath, String userPassword, LoginVO user, HttpServletRequest request, String work_yn ) throws Exception {
		String	CRF_PATH	= "Clipreport4/human/";
		ClipReportDoc doc = new ClipReportDoc();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		String reportfile = CRF_PATH + "hpa915kr.crf";
		if("N".equals(work_yn)) {
			reportfile = CRF_PATH + "hpa916kr.crf";
		}
		
		List<Map<String, Object>> report_data = hpa900rkrService.selectListPrint56(param);

		//Sub Report
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("SUB_SECTION1", "SQLDS2");

		List<Map<String, Object>> subReport_data = hpa900rkrService.selectSubListPrint56(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);
		
		 
		return doc.exportPDFFile(reportfile, "JDBC1", "SQLDS1", param,   report_data,  subReports,  request , fileName, filePath, userPassword ) ;
	}
	

}
