package foren.unilite.modules.z_yg;

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

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.email.EmailModel;
import foren.unilite.modules.com.email.EmailSendServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class S_HpaEmail_ygController extends UniliteCommonController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String JSP_PATH = "/z_yg/";

	/**
	 * 서비스 연결
	 */


	@Resource(name="s_hpa940ukr_ygService")
	private S_Hpa940ukr_ygServiceImpl s_hpa940ukr_ygService;


	@Resource(name="emailSendService")
    private EmailSendServiceImpl emailSendService;



	@RequestMapping(value="/z_yg/s_hpa940ukr_ygmail.do", method=RequestMethod.POST)
	public ModelAndView s_hpa940ukr_ygmail(@RequestParam String data)throws Exception{
		S_Hpa940ukr_ygYearModel hpa940ukrYearModel = new S_Hpa940ukr_ygYearModel();
		S_Hpa940ukr_ygWorkModel hpa940ukrWorkModel = new S_Hpa940ukr_ygWorkModel();
		List<S_Hpa940ukr_ygCode1Model> code1 = null;
		List<S_Hpa940ukr_ygCode2Model> code2 = null;
		List<S_Hpa940ukr_ygCode3Model> code3 = null;
		logger.debug("data : " + data.toString());

		Map<String,Object> rv = new HashMap<String,Object>();
		int totalCount = 0, sucessCount = 0, failureCount = 0;
		//스트링 파라미터 -> vo
		Gson gson = new Gson();
		S_Hpa940ukr_ygModel[] hpa940ukrModelArray = gson.fromJson(data, S_Hpa940ukr_ygModel[].class);

		String Root_Path=ConfigUtil.getUploadBasePath("EmailSalary")+"/";
		File filePath = new File(Root_Path);
		if(!filePath.exists())	{
			filePath.mkdir();
		}
		String title = hpa940ukrModelArray[0].getTITLE();

		//smtp 파일 정보 수집
		logger.debug("smtp 서버 정보 수집");
		S_Hpa940ukr_ygSmtpModel smtp = s_hpa940ukr_ygService.selectSmtpInfo(hpa940ukrModelArray[0].getS_COMP_CODE());
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

	    	  S_Hpa940ukr_ygEmailModel hpa940ukrEmailModel= s_hpa940ukr_ygService.selectEmailList(hpa940ukrModelArray[i]);

	    	  logger.debug("년월차 데이터 수집");
	    	  if(year_yn.equals("Y")) {
	    		  hpa940ukrYearModel = s_hpa940ukr_ygService.selectYearInfo(hpa940ukrModelArray[i]);

	    		  if(hpa940ukrYearModel != null)
	    			  logger.debug("s_hpa940ukr_ygYearModel : " + hpa940ukrYearModel.toString());
	    		  else
	    			  logger.debug("s_hpa940ukr_ygYearModel null");
	    	  }

	    	  logger.debug("1. 근태 데이터 수집");
	    	  if(work_yn.equals("Y")) {
	    		  code1 = s_hpa940ukr_ygService.selectCode1(hpa940ukrModelArray[i]);
	    		  if(code1 != null)
	    			  logger.debug("code1 : " + code1.toString());
	    		  else
	    			  logger.debug("code1 null");
	    	  }


	    	  logger.debug("2. 지금내역  수집");
    		  code2 = s_hpa940ukr_ygService.selectCode2(hpa940ukrModelArray[i]);
    		  if(code2 != null)
    			  logger.debug("code2 : " + code2.toString());
    		  else
    			  logger.debug("code2 null");


    		  logger.debug("3. 공제내역  수집");
    		  code3 = s_hpa940ukr_ygService.selectCode3(hpa940ukrModelArray[i]);
    		  if(code3 != null)
    			  logger.debug("code3 : " + code3.toString());
    		  else
    			  logger.debug("code3 null");



	    	  //htm 파일 생성
    		  S_MakeHtml_yg makeHtml = new S_MakeHtml_yg(hpa940ukrEmailModel, hpa940ukrYearModel, code1, code2, code3, hpa940ukrModelArray[i]);

	    	  String fname= Root_Path + hpa940ukrEmailModel.getPERSON_NUMB() + ".htm";

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


	    	  //sendMail_naver();
	    	  //sendMail_gmail(smtp, fname);

	    	  //2020.09.02 ssl은 전송이 안돼서 주석 처리 sendMail_custom(title, smtp, hpa940ukrModelArray[i].getEMAIL_ADDR(), fname );



	    	  //result = super.commonDao.insert("hbs020ukrServiceImpl.insertList11", hbs020ukrModelArray[i]);
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
	    		  rvMap.put("SEND_RESULT", "성공" );
	    		  rvMap.put("SEND_MSG",  "" );
	    		  sucessCount++;
	    	  } catch (Exception e){
	    		  logger.error(e.toString());
	    		  e.printStackTrace();
	    		  rvMap.put("PERSON_NUMB", hpa940ukrModelArray[i].getPERSON_NUMB() );
	    		  rvMap.put("SEND_RESULT",  "실패" );
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

	      //2020.09.02 주석 처리 rv.put("success", Boolean.FALSE);
	      rv.put("sendSummary", rvMessage);
		return ViewHelper.getJsonView(rv);
	}


	private String sendMail_custom(String title, S_Hpa940ukr_ygSmtpModel vo, String addr, String fname) throws MessagingException {
		String host = vo.getSERVER_NAME();
        String username = vo.getSEND_USER_NAME();
        String password = vo.getSEND_PASSWORD();
        String port = vo.getSERVER_PROT();

        // 메일 내용
        String to = addr;
        String subject = title;
        String body = "첨부파일을 참고하세요. ";

        //properties 설정
        Properties props = new Properties();
        props.put("mail.smtp.auth", ConfigUtil.getProperty("common.emailSender.auth"));
        props.put("mail.smtp.starttls.enable", ConfigUtil.getProperty("common.emailSender.starttls"));
        props.put("mail.smtp.quitwait", ConfigUtil.getProperty("common.emailSender.quitwait"));
        // 메일 세션
        Session session = Session.getDefaultInstance(props);
        MimeMessage msg = new MimeMessage(session);

        BodyPart messageBodyPart = new MimeBodyPart();

        messageBodyPart.setText(body);
        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(messageBodyPart);

        messageBodyPart = new MimeBodyPart();
        File file = new File(fname);
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
        Transport transport = session.getTransport(ObjUtils.getSafeString(ConfigUtil.getProperty("common.emailSender.protocol")));
        logger.debug("prop:"+props.toString());

        transport.connect(host, Integer.parseInt(port), username, password);
        transport.sendMessage(msg, msg.getAllRecipients());
        transport.close();

        return "메일이 전송 되었습니다.";
	}




}
