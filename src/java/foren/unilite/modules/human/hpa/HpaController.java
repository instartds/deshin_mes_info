package foren.unilite.modules.human.hpa;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;

/**
 * 프로그램명 : 작업지시조정 작 성 자 : (주)포렌 개발실
 */
@Controller
@SuppressWarnings( "rawtypes" )
public class HpaController extends UniliteCommonController {
 
    private final Logger           logger   = LoggerFactory.getLogger(this.getClass());

    final static String            JSP_PATH = "/human/hpa/";

    /**
     * 서비스 연결
     */
    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
    
    @Resource( name = "hpa300ukrService" )
    private Hpa300ukrServiceImpl   hpa300ukrService;

    @Resource( name = "hpa330ukrService" )
    private Hpa330ukrServiceImpl   hpa330ukrService;

    @Resource( name = "hpa870skrService" )
    private Hpa870skrServiceImpl   hpa870skrService;

    @Resource( name = "hpa340ukrService" )
    private Hpa340ukrServiceImpl   hpa340ukrService;

    @Resource( name = "hpa350ukrService" )
    private Hpa350ukrServiceImpl   hpa350ukrService;

    @Resource( name = "hpa351ukrService" )
    private Hpa351ukrServiceImpl   hpa351ukrService;

    @Resource( name = "hpa600ukrService" )
    private Hpa600ukrServiceImpl   hpa600ukrService;

    @Resource( name = "hpa620ukrService" )
    private Hpa620ukrServiceImpl   hpa620ukrService;

    @Resource( name = "hpa930rkrService" )
    private Hpa930rkrServiceImpl   hpa930rkrService;

    @Resource( name = "hpa940ukrService" )
    private Hpa940ukrServiceImpl   hpa940ukrService;

    @Resource( name = "hpa950skrService" )
    private Hpa950skrServiceImpl   hpa950skrService;
    
    @Resource( name = "hpa950ukrService" )
    private Hpa950ukrServiceImpl   hpa950ukrService;

    @Resource( name = "hpa955skrService" )
    private Hpa955skrServiceImpl   hpa955skrService;
    
    @Resource( name = "hpa956skrService" )
    private Hpa956skrServiceImpl   hpa956skrService;

    @Resource( name = "hpa960ukrService" )
    private Hpa960ukrServiceImpl   hpa960ukrService;

    @Resource( name = "hpa971ukrService" )
    private Hpa971ukrServiceImpl   hpa971ukrService;
    
    @Resource( name = "hpa990ukrService" )
    private Hpa990ukrServiceImpl   hpa990ukrService;

    @Resource( name = "hpa991ukrService" )
    private Hpa991ukrServiceImpl   hpa991ukrService;

    @Resource( name = "hpa994ukrService" )
    private Hpa994ukrServiceImpl   hpa994ukrService;

    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl       comboService;
    
    @Resource( name = "hpa740ukrService" )
    private Hpa740ukrServiceImpl       hpa740ukrService;
    
    @Resource( name = "HpaExcelService" )
    private HpaExcelServiceImpl   HpaExcelService;
    
    @Resource( name = "hpa302ukrService" )
    private Hpa302ukrServiceImpl   hpa302ukrService;

    @Resource( name = "hpa972ukrService" )
    private Hpa972ukrServiceImpl   hpa972ukrService;
    
    /*
     * 국민건강명세서조회(hpa100skr)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa100skr.do" )
    public String hpa100skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa100skr";
    }

    /*
     * 공제대장조회(hpa110skr)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa110skr.do" )
    public String hpa110skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa110skr";
    }

    @RequestMapping( value = "/human/hpa300ukr.do" )
    public String hpa300ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
    	
    	final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        
    	param.put("S_COMP_CODE", loginVO.getCompCode());
    	//건강보험에 노인장기요양보험 포함여부 조회
        Map<String, Object> healthInsure = hpa300ukrService.selectHealthInsurance(param);
        
        // 올해 년도
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date dateGet = new Date();
		String dateGetString = dateFormat.format(dateGet).substring(0,4);
		// default data 올해세팅
        param.put("BASE_YEAR", dateGetString);
        
        // 건강보험, 노인요양보험 요율 조회
        List<Map<String, Object>> insureRateList = hpa300ukrService.selectInsuranceRate(param);
    	
    	model.addAttribute("healthInsure", healthInsure.get("LCI_CALCU_RULE"));   // 노인장기요양보험 포함 여부
    	model.addAttribute("insureRateList", ObjUtils.toJsonStr(insureRateList)); // 요율
    	
        return JSP_PATH + "hpa300ukr";
    }

    @RequestMapping( value = "/human/hpa301ukr.do" )
    public String hpa301ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

        return JSP_PATH + "hpa301ukr";
    }

    @RequestMapping( value = "/human/hpa330ukr.do" )
    public String hpa330ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //지급구분에서 refcode1이 1인 데이터만 가져오기
        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
        Object list1 = "";
        for (CodeDetailVO map : gsList1) {
            if ("1".equals(map.getRefCode1())) {
                if (list1.equals("")) {
                    list1 = map.getCodeNo();
                } else {
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        return JSP_PATH + "hpa330ukr";
    }

    @RequestMapping( value = "/human/hpa340ukr.do" )
    public String hpa340ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //지급구분에서 refcode1이 1인 데이터만 가져오기
        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
        Object list1 = "";
        for (CodeDetailVO map : gsList1) {
            if ("1".equals(map.getRefCode1())) {
                if (list1.equals("")) {
                    list1 = map.getCodeNo();
                } else {
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        return JSP_PATH + "hpa340ukr";
    }

    /**
     * 시간외단가조정(hpa360skr)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa360skr.do" )
    public String hpa360skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa360skr";
    }

    @RequestMapping( value = "/human/hpa600ukr.do" )
    public String hpa600ukr() throws Exception {
        return JSP_PATH + "hpa600ukr";
    }

    @RequestMapping( value = "/human/hpa610ukr.do" )
    public String hpa610ukr() throws Exception {
        return JSP_PATH + "hpa610ukr";
    }

    /**
     * 년월차수당계산 프로시져
     */
    //  @RequestMapping(value = "/human/hpa600proc.do")
    //  public ModelAndView hpa600ukr(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
    //      Map result = hpa600ukrService.procHpa600(param, loginVO);
    //
    //      return ViewHelper.getJsonView(result);
    //  }

    /**
     * 년차생성 프로시져
     */
    //  @RequestMapping(value = "/human/hpa620proc.do")
    //  public ModelAndView hpa620ukr(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
    //      Map result = hpa620ukrService.procHpa620(param, loginVO);
    //      return ViewHelper.getJsonView(result);
    //  }

    @RequestMapping( value = "/human/hpa620ukr.do" )
    public String hpa620ukr( ModelMap model, LoginVO loginVO ) throws Exception {
        Gson gson = new Gson();
        String result = gson.toJson(hpa620ukrService.loadStdYyyy(loginVO));

        model.addAttribute("result", result);
        //급여관리기준등록 hbs020ukrs1 연차계산방식 기준 가져오기
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("H195", "", false);   //자국화폐단위 정보
        for (CodeDetailVO map : gsMoneyUnit) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("yearCalculation", map.getCodeNo());
            }
        }
        return JSP_PATH + "hpa620ukr";
    }

    @RequestMapping( value = "/human/hpa630ukr.do" )
    public String hpa630ukr() throws Exception {
        return JSP_PATH + "hpa630ukr";
    }

    @RequestMapping( value = "/human/hpa640ukr.do" )
    public String hpa640ukr() throws Exception {
        return JSP_PATH + "hpa640ukr";
    }

    /**
     * 급여내역일괄조정(hpa350ukr)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa350ukr.do" )
    public String hpa350ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //지급구분에서 refcode1이 1인 데이터만 가져오기
        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
        Object list1 = "";
        for (CodeDetailVO map : gsList1) {
            if ("1".equals(map.getRefCode1())) {
                if (list1.equals("")) {
                    list1 = map.getCodeNo();
                } else {
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        Gson gson = new Gson();
        String colData = gson.toJson(hpa350ukrService.selectColumns(loginVO));
        model.addAttribute("colData", colData);

        Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//특정부서 콤보

        return JSP_PATH + "hpa350ukr";
    }

    @RequestMapping( value = "/human/hpa351ukr.do" )
    public String hpa351ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //지급구분에서 refcode1이 1인 데이터만 가져오기
        List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
        Object list1 = "";
        for (CodeDetailVO map : gsList1) {
            if ("1".equals(map.getRefCode1())) {
                if (list1.equals("")) {
                    list1 = map.getCodeNo();
                } else {
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsList1", list1);

        Gson gson = new Gson();
        String colData = gson.toJson(hpa351ukrService.selectColumns(loginVO));
        model.addAttribute("colData", colData);
        return JSP_PATH + "hpa351ukr";
    }

    @RequestMapping( value = "/human/hpa650skr.do" )
    public String hpa650skr() throws Exception {
        return JSP_PATH + "hpa650skr";
    }

    @RequestMapping( value = "/human/hpa700ukr.do" )
    public String hpa700ukr() throws Exception {
        return JSP_PATH + "hpa700ukr";
    }
    
    
    @RequestMapping( value = "/human/hpa700rkr.do" )
    public String hpa700rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
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

        return JSP_PATH + "hpa700rkr";
    }
    

    /**
     * 년차현황 조회
     */
    @RequestMapping( value = "/human/hpa710skr.do" )
    public String hpa710skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa710skr";
    }

    /**
     * 월별 지급차수별 상여 지급대장 조회
     */
    @RequestMapping( value = "/human/hpa720skr.do" )
    public String hpa720skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa720skr";
    }
    /**
     * 년도별 연차 명세서 조회
     */
    @RequestMapping( value = "/human/hpa730skr.do" )
    public String hpa730skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());


        return JSP_PATH + "hpa730skr";
    }

    /*
     * 월지급/근태내역비교조회(hpa850skr)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa850skr.do" )
    public String hpa850skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());
        //지급목록(HBS300T 참조하여 콤보 가져오는 것)
        model.addAttribute("payList", comboService.getPayList(param));

        return JSP_PATH + "hpa850skr";
    }

    /*
     * 급여내역비교조회(hpa870skr)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa870skr.do" )
    public String hpa870skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hpa870skrService.selectColumns(loginVO));
        model.addAttribute("colData", colData);

        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa870skr";
    }

    /**
     * 월급여기초자료조회(hpa880skr)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa880skr.do" )
    public String hpa880skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa880skr";
    }

    @RequestMapping( value = "/human/hpa900rkr.do" )
    public String hpa900rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
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

		String yearPayYN = "N";
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsGubun = codeInfo.getCodeList("H175", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsGubun)	{
			if("32".equals(map.getCodeNo()) && "Y".equals(map.getRefCode1())) {
				yearPayYN = "Y";
			}
		}
		
		model.addAttribute("yearPayYN", yearPayYN);
		
        return JSP_PATH + "hpa900rkr";
    }

    /**
     * add By Chen.Rd
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa901rkr.do" )
    public String hpa901rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
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

        return JSP_PATH + "hpa901rkr";
    }

    /**
     * add By Chen.Rd
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa930rkr.do" )
    public String hpa930rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
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

        List<Map<String, Object>> listHideOption = hpa930rkrService.getRepreNumHideOption(param, loginVO);
        if(listHideOption.size() >= 1) {
        	model.addAttribute("bHideRepreNumOptions", listHideOption.get(0).get("SUB_CODE"));
        }
        else {
        	model.addAttribute("bHideRepreNumOptions", "N");
        }

        return JSP_PATH + "hpa930rkr";
    }

    /*
     * 개인급여 내역 조회(hpa950skr)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa950skr.do" )
    public String hpa950skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
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

        return JSP_PATH + "hpa950skr";
    }
    
    /*
     * 급여내역 업로드(hpa950ukr)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa950ukr.do" )
    public String hpa950ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData1 = gson.toJson(hpa950ukrService.selectColumns1(loginVO));
        model.addAttribute("colData1", colData1);
        
        String colData2 = gson.toJson(hpa950ukrService.selectColumns2(loginVO));
        model.addAttribute("colData2", colData2);

        //S_COMP_CODE 가져오기
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

       //조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
       model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));

       List<Map<String, Object>> getCostPoolName = hpa950ukrService.getCostPoolName(param);
       model.addAttribute("getCostPoolName", ObjUtils.toJsonStr(getCostPoolName));
       
       CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
       
       //지급구분에서 refcode1이 1인 데이터만 가져오기
       List<CodeDetailVO> gsList1 = codeInfo.getCodeList("H032", "", false);
       Object list1 = "";
       for (CodeDetailVO map : gsList1) {
           if ("1".equals(map.getRefCode1())) {
               if (list1.equals("")) {
                   list1 = map.getCodeNo();
               } else {
                   list1 = list1 + ";" + map.getCodeNo();
               }
           }
       }
       model.addAttribute("gsList1", list1);

        return JSP_PATH + "hpa950ukr";
    }

    /*
     * 급여집계 내역 조회(hpa955skr)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa955skr.do" )
    public String hpa955skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hpa955skrService.selectColumns(loginVO));
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

        List<Map<String, Object>> getCostPoolName = hpa955skrService.getCostPoolName(param);
        model.addAttribute("getCostPoolName", ObjUtils.toJsonStr(getCostPoolName));

        return JSP_PATH + "hpa955skr";
    }
    
    /*
     * 개인급여집계내역  조회(hpa956skr)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa956skr.do" )
    public String hpa956skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hpa956skrService.selectColumns(loginVO));
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

        List<Map<String, Object>> getCostPoolName = hpa956skrService.getCostPoolName(param);
        model.addAttribute("getCostPoolName", ObjUtils.toJsonStr(getCostPoolName));

        return JSP_PATH + "hpa956skr";
    }

    @RequestMapping( value = "/human/hpa940ukr.do" )
    public String hpa940ukr() throws Exception {
        return JSP_PATH + "hpa940ukr";
    }

    /**
     * add by Chen.Rd
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa970rkr.do" )
    public String hpa970rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
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
        return JSP_PATH + "hpa970rkr";
    }

    /**
     * add By thkim
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa980rkr.do" )
    public String hpa980rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
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

        return JSP_PATH + "hpa980rkr";
    }

    private String sendMail_custom( String title, Hpa940ukrSmtpModel vo, String addr, String fname ) throws MessagingException {
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

    private String sendMail_gmail( Hpa940ukrSmtpModel hpa940ukrSmtpModel, String fname ) throws MessagingException {
        String host = "smtp.gmail.com";
        String username = "";

        if (hpa940ukrSmtpModel.getFROM_ADDR().equals("")) username = "jokingboy@gmail.com";
        else username = hpa940ukrSmtpModel.getFROM_ADDR();

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
        int port = 465;

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
            String un = username;
            String pw = password;

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

    /**
     * Navi버튼 활성화를 결정
     *
     * @param param
     * @param loginVO
     * @return 현재 사원의 전후로 데이터가 있는지 확인
     * @throws Exception
     */
    @RequestMapping( value = "/human/checkAvailableNaviHpa330.do" )
    public ModelAndView checkAvailableNavi( @RequestParam Map<String, String> param, LoginVO loginVO ) throws Exception {
        param.put("S_COMP_CODE", loginVO.getCompCode());
        List<Map<String, Object>> result = hpa330ukrService.checkAvailableNavi(param);
        return ViewHelper.getJsonView(result);
    }

    /**
     * 저장이 가능한 상태인지 확인함
     *
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/checkUpdateAvailableHpa330.do" )
    public ModelAndView checkUpdateAvailable( @RequestParam Map<String, String> param, LoginVO loginVO ) throws Exception {
        param.put("S_COMP_CODE", loginVO.getCompCode());
        //		List<Map<String, Object>> result = hpa330ukrService.checkAvailableNavi(param);
        String result = hpa330ukrService.checkUpdateAvailable(param);
        return ViewHelper.getJsonView(result);
    }

    /**
     * 전월의 데이터를 복사함
     *
     * @param param
     * @param loginVO
     * @return 현재 사원의 전후로 데이터가 있는지 확인
     * @throws Exception
     */
    @RequestMapping( value = "/human/copyPrevData.do" )
    public ModelAndView copyPrevData( @RequestParam Map<String, String> param, LoginVO loginVO ) throws Exception {
        //		param.put("S_COMP_CODE", loginVO.getCompCode());
        List<Map<String, Object>> result = hpa330ukrService.selectList1ForCopy(param);
        List<Map<String, Object>> result1 = hpa330ukrService.selectList2ForCopy(param);
        List<Map<String, Object>> result2 = hpa330ukrService.selectList3ForCopy(param);

        Map resultMap = new HashMap<String, List<Map<String, Object>>>();
        resultMap.put("result", result);
        resultMap.put("result1", result1);
        resultMap.put("result2", result2);
        return ViewHelper.getJsonView(resultMap);
    }

    @RequestMapping( value = "/human/calcPay.do" )
    public ModelAndView calcPay( @RequestParam Map<String, String> param, LoginVO loginVO ) throws Exception {
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        Object result = hpa340ukrService.spCalcPay(param, loginVO);
        return ViewHelper.getJsonView(result);

    }

    /**
     * 주식매수선택권/우리사주인출금등록
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa960ukr.do" )
    public String hpa960ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        List<Map<String, Object>> getEmployRate = humanCommonService.getEmployRate(param);		//당기시작년월
        model.addAttribute("getEmployRate", ObjUtils.toJsonStr(getEmployRate));

        return JSP_PATH + "hpa960ukr";
    }

    @RequestMapping( value = "/human/hpa970ukr.do" )
    public String hpa970ukr() throws Exception {
        return JSP_PATH + "hpa970ukr";
    }

    /**
     * 월별 급여지급대장 집계표 조회(S)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa990skr.do" )
    public String hpa990skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //원천징수 년월 가져오기 (HBS130T)
        //		Map selectDefaultTaxYM = (Map)hpa990ukrService.selectDefaultTaxYM(param);
        //		model.addAttribute("selectDefaultTaxYM", selectDefaultTaxYM.get("TAX_YYYYMM"));

        return JSP_PATH + "hpa990skr";
    }

    /**
     * 홈텍스-원천징수이행상황전자신고
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa990ukr.do" )
    public String hpa990ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //원천징수 년월 가져오기 (HBS130T)
        Map selectDefaultTaxYM = (Map)hpa990ukrService.selectDefaultTaxYM(param);
        model.addAttribute("selectDefaultTaxYM", ObjUtils.getSafeString(selectDefaultTaxYM.get("TAX_YYYYMM")));

        return JSP_PATH + "hpa990ukr";
    }
    
	@ResponseBody
	@RequestMapping(value = "/human/hpa990ukrExcelDown.do")
	public ModelAndView hpa990ukrDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = HpaExcelService.makeExcel(paramMap);
        String title = "원천징수이행전자신고서";
        
        return ViewHelper.getExcelDownloadView(wb, title);
	}

    /**
     * 홈텍스-원천징수이행상황신고서세부(hpa991skr)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa991skr.do" )
    public String hpa991skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa991skr";
    }

    @RequestMapping( value = "/human/hpa991ukr.do" )
    public String hpa991ukr() throws Exception {
        return JSP_PATH + "hpa991ukr";
    }

    /**
     * 원천징수이행상황신고자료생성 프로시져
     */
    @RequestMapping( value = "/human/hpa991proc.do" )
    public ModelAndView hpa991ukr( @RequestParam Map<String, String> param, LoginVO loginVO ) throws Exception {
        //Map result = hpa991ukrService.createRetireFile(param, loginVO);
    	Map result = hpa991ukrService.checkProcedureExec(param, loginVO);

        return ViewHelper.getJsonView(result);
    }

    @RequestMapping( value = "/human/hpa994ukr.do" )
    public String hpa994ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        //S_COMP_CODE 가져오기
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //소속지점 콤보 가져오는 쿼리 호출
        model.addAttribute("getBussOfficeCode", hpa994ukrService.getBussOfficeCode(param));

        return JSP_PATH + "hpa994ukr";
    }

    @RequestMapping( value = "/human/hpa996ukr.do" )
    public String hpa996ukr() throws Exception {
        return JSP_PATH + "hpa996ukr";
    }

    /**
     * 사업소세(hpa997skr)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa997skr.do" )
    public String hpa997skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        return JSP_PATH + "hpa997skr";
    }

    /**
     * get TaxYM
     */
    @RequestMapping( value = "/human/getTaxYM.do" )
    public ModelAndView getTaxYM( @RequestParam Map<String, String> param, LoginVO loginVO ) throws Exception {
        Map result = hpa990ukrService.selectTaxYM(param);
        return ViewHelper.getJsonView(result);
    }
    


    /**
     * 통상임금내역 등록
     */
    @RequestMapping( value = "/human/hpa740ukr.do" )
    public String hpa740ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hpa740ukrService.selectWagescode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        
        return JSP_PATH + "hpa740ukr";
    }
    
    
	//원친징수이행상황신고서 파일생성
	@RequestMapping(value="/human/createWithholdingFile.do", method = RequestMethod.POST)
	public ModelAndView  fileDown2(ExtHtttprequestParam req, LoginVO user) throws Exception {

		Map<String, Object> spParam = req.getParameterMap();	

		spParam.put("COMP_CODE", user.getCompCode());		
		
		Map<String, Object>  spResult = hpa991ukrService.createWithholdingFile(spParam, user);
		
		String returnText = (String) spResult.get("RETURN_TEXT");
		String errorDesc = (String) spResult.get("ERROR_DESC");

		if(!ObjUtils.isEmpty(errorDesc)){			
		    throw new  UniDirectValidateException(errorDesc);		
		}	
		
		String fileName = spParam.get("WORK_DATE") + ".201";
		
		File dir = new File("C:/txtFile");
		if(!dir.exists())  dir.mkdir();
        FileDownloadInfo fInfo = new FileDownloadInfo("C:/txtFile", fileName);

		
		//FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegaplusAccntFile"), fileName); // 파일명 및 파일이 생길 경로지정..
        FileOutputStream fos = new FileOutputStream(fInfo.getFile()); // txt파일을 경로에 생성..
        
        String data = returnText;
        logger.info("data :: \n" + data);
        String[] sdata = data.split("\r");
        logger.info("sdata.length " + sdata.length);
        for (int i = 0; i < sdata.length; i++) {
            fos.write(sdata[i].getBytes("euckr"));  //국세청 자료 신고용 ansi용 파일 저장..
            fos.write("\r\n".getBytes());
        }
        
        fos.flush();
        fos.close();
        fInfo.setStream(fos);
	  
	    return ViewHelper.getFileDownloadView(fInfo);
	
	}
	
    /**
     * 국민연금/건강보험료/고용보험료 일괄적용
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa302ukr.do" )
    public String hum101ukr() throws Exception {
        return JSP_PATH + "hpa302ukr";
    }
    
    /**
     * 위택스-지방소득세신고자료
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa971ukr.do" )
    public String hpa971ukr() throws Exception {
        return JSP_PATH + "hpa971ukr";
    }

    /**
     * 급여이체리스트 조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa935skr.do" )
    public String hpa935skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

        return JSP_PATH + "hpa935skr";
    }

    /**
     * 위택스 - 지방소득세자료생성(hpa972ukr)
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa972ukr.do" )
    public String hpa972ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        model.addAttribute("getBussOfficeCode", hpa972ukrService.getBussOfficeCode(param));
        return JSP_PATH + "hpa972ukr";
    }

    /**
     * 근로소득간이지급명세서신고자료생성(신고자료 다운로드)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpa972ukrFileDown.do", method = RequestMethod.POST )
    public ModelAndView hpa972ukrFileDown( ExtHtttprequestParam _req) throws Exception {
    	Map param = _req.getParameterMap();
    	FileDownloadInfo fInfo = hpa972ukrService.doBatch(param);
		
		return ViewHelper.getFileDownloadView(fInfo);
	}

}
