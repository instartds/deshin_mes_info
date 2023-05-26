package foren.unilite.modules.z_yg;

import java.io.File;
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
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;
import foren.unilite.modules.human.HumanUtils;
import foren.unilite.modules.z_yg.S_Hpa940ukr_ygServiceImpl;
import foren.unilite.modules.human.hpa.Hpa940ukrSmtpModel;
import foren.unilite.modules.human.hpa.Hpa950skrServiceImpl;
import foren.unilite.modules.human.hpa.Hpa994ukrServiceImpl;

/**
 * 프로그램명 : 인사 - 인사관리 Controller 작 성 자 : (주)포렌 개발실
 */
@Controller
public class Z_ygController extends UniliteCommonController {
    @InjectLogger
    public static Logger           logger;                              //	= LoggerFactory.getLogger(this.getClass());
    
    final static String            JSP_PATH           = "/z_yg/";
    /*public final static String     FILE_TYPE_OF_PHOTO = "employeePhoto";*/
    
    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl       comboService;
    
    @Resource( name = "s_hum920skr_ygService" )
    private S_Hum920skr_ygServiceImpl   s_hum920skr_ygService;

    @Resource( name = "hpa950skrService" )
    private Hpa950skrServiceImpl   hpa950skrService;
    
    
    @Resource( name = "s_agj231rkr_ygService" )
    private S_Agj231rkr_ygServiceImpl   s_agj231rkr_ygService;
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
    
    @Resource( name = "s_hpa940ukr_ygService" )
    private S_Hpa940ukr_ygServiceImpl   s_hpa940ukr_ygService;
    
    
    @Resource( name = "s_agbExcel_ygService" )
    private S_AgbExcel_yglServiceImpl   s_agbExcel_ygService;
    
    @Resource( name = "s_hatExcel_ygService" )
    private S_HatExcel_ygServiceImpl   s_hatExcel_ygService;
   
    /**
     * 사원조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_yg/s_hum920skr_yg.do" )
    public String s_hum920skr_yg( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));
        
        List<Map<String, Object>> gsLicenseTab = s_hum920skr_ygService.checkLicenseTab(param);		// 버스 재입사관리, 면허기타 Tab 사용여부
        model.addAttribute("gsLicenseTab", ObjUtils.toJsonStr(gsLicenseTab));
        
        List<Map<String, Object>> gsOnlyHuman = s_hum920skr_ygService.checkOnlyHuman(param);			// 급여/고정공제 tab 사용못하는 인사담당자 id 여부	
        model.addAttribute("gsOnlyHuman", ObjUtils.toJsonStr(gsOnlyHuman));
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum920skr_yg";
        
        
    }
    
    /**
     * 재직/경력증명서 출력
     */
    @RequestMapping( value = "/z_yg/s_hum970rkr_yg.do" )
    public String s_hum970rkr_yg( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        return JSP_PATH + "s_hum970rkr_yg";
    }
    
    
    /**
     * 근태현황 리스트 출력
     */
    @RequestMapping( value = "/z_yg/s_hat531rkr_yg.do" )
    public String s_hat531rkr_yg( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        return JSP_PATH + "s_hat531rkr_yg";
    }
    
    /**
     * 연간년월차사용현황 조회
     */
    @RequestMapping( value = "/z_yg/s_hpa651skr_yg.do" )
    public String s_hpa651skr_yg() throws Exception {
        return JSP_PATH + "s_hpa651skr_yg";
    }
    
    /**
     * 급여지급조서 출력
     */
    @RequestMapping( value = "/z_yg/s_hpa900rkr_yg.do" )
    public String s_hpa900rkr_yg( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
    	 
    	Gson gson = new Gson();
        String colData = gson.toJson(hpa950skrService.selectColumns(loginVO));
        model.addAttribute("colData", colData);

        
        //S_COMP_CODE 가져오기
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());
       
        //조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));

        List<Map<String, Object>> getCostPoolName = hpa950skrService.getCostPoolName(param);
        model.addAttribute("getCostPoolName", ObjUtils.toJsonStr(getCostPoolName));

        return JSP_PATH + "s_hpa900rkr_yg";
    }
    
	/**
     * 지출집계표
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_yg/s_agj231rkr_yg.do")
    public String s_agj231rkr_yg(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
    
        return JSP_PATH + "s_agj231rkr_yg";
    }
    
    /**
     * 전표출력
     * 
     * @return
     * @throws Exception
     */
    //@SuppressWarnings( { "unused" } )
    @RequestMapping( value = "/z_yg/s_agj270skr_yg.do", method = RequestMethod.GET )
    public String agj270skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        

        
        return JSP_PATH + "s_agj270skr_yg";
    }
    
	/**
	 * 근태현황리스트
	 * @return
	 * @throws Exception
	 */
    @RequestMapping( value = "/z_yg/s_hat531skr_yg.do", method = RequestMethod.GET )
    public String s_hat531skr_yg( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "s_hat531skr_yg";
    }
    
	@ResponseBody
	@RequestMapping(value = "/z_yg/hat531skrvExcelDown.do")
	public ModelAndView hat531skrvDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = s_hatExcel_ygService.makeExcel(paramMap);
        String title = "근태현황리스트";
        
        return ViewHelper.getExcelDownloadView(wb, title);
	}
    
    
	/**
	 * 어음명세
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_yg/s_afn100skr_yg.do")
	public String s_afn100skr_yg()throws Exception{
		return JSP_PATH+"s_afn100skr_yg";
	}
	
	/**
	 * 급여명세서이메일전송
	 */
	@RequestMapping( value = "/z_yg/s_hpa940ukr_yg.do" )
    public String s_hpa940ukr_yg() throws Exception {
        return JSP_PATH + "s_hpa940ukr_yg";
    }
	
	private String sendMail_custom( String title, S_Hpa940ukr_ygSmtpModel vo, String addr, String fname ) throws MessagingException {
        String host = vo.getSERVER_NAME();
        String username = vo.getSEND_USER_NAME();
        String password = vo.getSEND_PASSWORD();

        // 메일 내용
        String to = addr;
        String subject = title;
        String body = "첨부파일을 참고하세요. ";

        //properties 설정
        Properties props = new Properties();
        props.put("mail.smtps.auth", "true");
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
        Transport transport = session.getTransport("smtps");
        transport.connect(host, username, password);
        transport.sendMessage(msg, msg.getAllRecipients());
        transport.close();

        return "success";
    }

	/**
	 * 경리과일보
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_yg/s_agb221rkr_yg.do")
	public String s_agb221rkr_yg()throws Exception{
		return JSP_PATH+"s_agb221rkr_yg";
	}
	
	@ResponseBody
	@RequestMapping(value = "/z_yg/s_agb221rkrExcelDown.do")
	public ModelAndView s_agb221rkrDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = s_agbExcel_ygService.makeExcel(paramMap);
        String title = "경리과일보";
        
        return ViewHelper.getExcelDownloadView(wb, title);
	}
	
	/**
	 * 입고현황 출력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yg/s_mtr130rkrv_yg.do")
	public String s_mtr130rkrv_yg(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);
		model.addAttribute("gsInOutPrsn", "");
		for(CodeDetailVO map : gsInOutPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode2()))	{
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		
		return JSP_PATH + "s_mtr130rkrv_yg";
	}
	
	/**
	 * 외상매입금내역출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "/z_yg/s_map130rkrv_yg.do")
    public String s_map130rkrv_yg(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "s_map130rkrv_yg";
    }
    

	
}
