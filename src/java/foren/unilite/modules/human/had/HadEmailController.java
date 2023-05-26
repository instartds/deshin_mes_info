package foren.unilite.modules.human.had;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.email.EmailModel;
import foren.unilite.modules.com.email.EmailSendServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class HadEmailController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/human/had/";
	
	/**
	 * 서비스 연결
	 */
	@Resource(name="emailSendService")
	private EmailSendServiceImpl emailSendService;
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@Resource(name="had890ukrService")
	private Had890ukrServiceImpl had890ukrService;
	
	@Resource(name="had840rkrService")
	private Had840rkrServiceImpl had840rkrService;
	
	
	@RequestMapping(value="/human/had890ukr_email.do", method=RequestMethod.POST)
	public ModelAndView had890ukr_email_pdf( HttpServletRequest request , @RequestParam String data, LoginVO user)throws Exception{
		
		// return data
		Map<String,Object> rv = new HashMap<String,Object>();
		
		// 전송 결과 count
		int totalCount = 0, sucessCount = 0, failureCount = 0;
		// server에 저장할 경로
		String Root_Path = ConfigUtil.getUploadBasePath("EmailSalary")+"/";
		// 파일 생성
		File filePath = new File(Root_Path);
		if(!filePath.exists())	{
			filePath.mkdir();
		}
		
		// 받아온 data
		Gson gson = new Gson();
		Had890ukrModel[] had890ukrModelArray = gson.fromJson(data, Had890ukrModel[].class);
		
		// 이메일 제목
		String title = had890ukrModelArray[0].getTITLE();
		
		//smtp 파일 정보 수집
		logger.debug("smtp 서버 정보 수집");
		Map smtp = had890ukrService.selectSmtpInfo(user.getCompCode());
		logger.debug("smtp 서버 정보 : " + smtp.toString());
		
		
		//루프 돌면서 메일 전송
		logger.debug("메일 전송 루프 시작");
		totalCount = had890ukrModelArray.length;
		List<Map<String,Object>> rvList = new ArrayList<Map<String,Object>>();
		
		for (Had890ukrModel mParam : had890ukrModelArray) {
			Map fparam = new HashMap();
			
			fparam.put("S_COMP_CODE", user.getCompCode());
			fparam.put("S_USER_ID", user.getUserID());
			fparam.put("YEAR_YYYY", mParam.getYEAR_YYYY());
			fparam.put("DIV_CODE", mParam.getDIV_CODE());
			fparam.put("RETR_TYPE", mParam.getHALFWAY_TYPE());
			fparam.put("HALFWAY_TYPE", mParam.getHALFWAY_TYPE());
			fparam.put("PERSON_NUMB", mParam.getPERSON_NUMB());
			fparam.put("FR_DEPT_CODE", mParam.getDEPT_CODE());
			fparam.put("TO_DEPT_CODE", mParam.getDEPT_CODE());
			fparam.put("FRRETIREDATE", mParam.getFRRETIREDATE());
			fparam.put("TORETIREDATE", mParam.getTORETIREDATE());
			fparam.put("TREE_CD", mParam.getDEPT_CODE());
			fparam.put("DEPT_CODE", mParam.getDEPT_CODE());
			fparam.put("DEPT_NAME", mParam.getDEPT_NAME());
			fparam.put("NAME", mParam.getNAME());
			fparam.put("EMAIL_ADDR", mParam.getEMAIL_ADDR());
			
			// 파일명
			String fname = mParam.getYEAR_YYYY() + "_" + mParam.getHALFWAY_TYPE_NM() + "원천징수영수증"+ ".pdf";
			
			logger.debug("첨부파일 생성 시작");
			File f = makePdfFile(fparam,  fname, Root_Path, (String)smtp.get("EMAIL_PWD") , user, request );
			logger.debug("첨부파일 생성 종료");
			// 보내는이 정보
			EmailModel emailModel = new EmailModel();
			emailModel.setFROM((String)smtp.get("SEND_USER_NAME"));
			emailModel.setSUBJECT(title);
			emailModel.setTEXT("첨부파일을 참고하세요. <br>" + (String)mParam.getCOMMENTS());
			// 받는이 정보
			emailModel.setTO(mParam.getEMAIL_ADDR()); 
			emailModel.setFILE(Root_Path + fname);
			Map smtpInfo = new HashMap();
			
			smtpInfo.put("SERVER_NAME", smtp.get("SERVER_NAME"));
			smtpInfo.put("SERVER_PROT", smtp.get("SERVER_PROT"));
			smtpInfo.put("SEND_USER_NAME", smtp.get("SEND_USER_NAME"));
			smtpInfo.put("SEND_PASSWORD", smtp.get("SEND_PASSWORD"));
			
			String errorMessage = emailSendService.sendMailAsync(emailModel, smtpInfo);

			if ("".equals(errorMessage)){
				fparam.put("SEND_RESULT", "성공" );
				fparam.put("SEND_MSG",  "" );
				sucessCount++;
			} else {
				fparam.put("SEND_RESULT",  "실패" );
				
				if(errorMessage.indexOf(":") > -1)	{
					errorMessage = errorMessage.substring(errorMessage.indexOf(":")+1, errorMessage.length());
				}
				fparam.put("SEND_MSG", errorMessage);
				failureCount++;
			}
			had890ukrService.updateLog(fparam);
			rvList.add(fparam);
		}
		rv.put("sendList", rvList);
		
		String rvMessage = "[이메일 전송 작업 결과]\n" 
							+ "    전송요청 건수 : "+ String.valueOf(totalCount) + " 건\n"
							+ "    전송 성공     : " + String.valueOf(sucessCount) + " 건\n"
							+ "    전송 실패     : " + String.valueOf(failureCount)+ " 건";
		
		rv.put("sendSummary", rvMessage);
		return ViewHelper.getJsonView(rv);
	}
	
	
	private File makePdfFile(Map param, String fileName, String filePath, String userPassword, LoginVO user, HttpServletRequest request) throws Exception {
		
		String	CRF_PATH	= "Clipreport4/human/";
		
		ClipReportDoc doc = new ClipReportDoc();
		
		//Image 경로 
		String imagePath = doc.getImagePath();

		//로고, 스탬프 패스 추가
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
		
		//Main Report
		List<Map<String, Object>> report_data = new ArrayList<Map<String, Object>>();
		
		//Sub Report use data
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		
		List<Map<String, Object>> subReport_data1 = new ArrayList<Map<String, Object>>();
		
		String crfFile = "";
		if (Integer.parseInt((String) param.get("YEAR_YYYY")) <= 2020) {

			crfFile = CRF_PATH + "had840clrkr_2020.crf";
			
			report_data		= had840rkrService.selectList2020_Query1(param);
			subReport_data1 = had840rkrService.selectList2020_Query2(param);
		}
		
		//Sub Report
		subReportMap.put("REPORT_FILE", "subReport2");
		subReportMap.put("DATA_SET", "SQLDS2"); 
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);
		
		 
		return doc.exportPDFFile(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request , fileName, filePath, userPassword);
	}
}
