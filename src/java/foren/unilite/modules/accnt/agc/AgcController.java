package foren.unilite.modules.accnt.agc;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

/**
 * <pre>
 * 프로그램명 : 결산관리
 * 작 성 자 : (주)포렌 개발실
 * </pre>
 */
@Controller
public class AgcController extends UniliteCommonController {
    
    private final Logger           logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String            JSP_PATH = "/accnt/agc/";
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
    
    @Resource( name = "agc310ukrService" )
    private Agc310ukrServiceImpl   agc310ukrService;
    
    @Resource( name = "agc360ukrService" )
    private Agc360ukrServiceImpl   agc360ukrService;
    
    @Resource( name = "agc210skrService" )
    private Agc210skrServiceImpl   agc210skrService;
    
    /**
     * 합계잔액시산표
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc100skr.do" )
    public String agc100skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false);
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));

        return JSP_PATH + "agc100skr";
    }
    
    /**
     * 합계잔액시산표
     * 
     * @return
     * @throws Exception add by zhongshl
     */
    @RequestMapping( value = "/accnt/agc100rkr.do" )
    public String agc100rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
		model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("agc100rkr".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
		return JSP_PATH + "agc100rkr";
    }
    
    /**
     * 경비명세서
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc110skr.do" )
    public String agc110skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        return JSP_PATH + "agc110skr";
    }
    
    /**
     * add by zhongshl 경비명세서
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc110rkr.do" )
    public String agc110rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("agc110rkr".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
        return JSP_PATH + "agc110rkr";
    }
    
    /**
     * 재무제표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc130skr.do" )
    public String agc130skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false);
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> fnGetSession = accntCommonService.fnGetSession(param);    //기수
        model.addAttribute("fnGetSession", ObjUtils.toJsonStr(fnGetSession));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        cdo = codeInfo.getCodeInfo("A137", "1");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAssets", cdo.getRefCode1());  // 자산
        else if (ObjUtils.isEmpty(cdo)) model.addAttribute("gsAssets", "1999");
        
        cdo = codeInfo.getCodeInfo("A137", "2");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsDebt", cdo.getRefCode1());        // 부채
        else if (ObjUtils.isEmpty(cdo)) model.addAttribute("gsDebt", "5000");
        
        return JSP_PATH + "agc130skr";
    }
    
    /**
     * 재무제표
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc130rkr.do" )
    public String agc130rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false);
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("agc130rkr".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> fnGetSession = accntCommonService.fnGetSession(param);    //기수
        model.addAttribute("fnGetSession", ObjUtils.toJsonStr(fnGetSession));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        cdo = codeInfo.getCodeInfo("A137", "1");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAssets", cdo.getRefCode1());  // 자산
        else if (ObjUtils.isEmpty(cdo)) model.addAttribute("gsAssets", "1999");
        
        cdo = codeInfo.getCodeInfo("A137", "2");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsDebt", cdo.getRefCode1());        // 부채
        else if (ObjUtils.isEmpty(cdo)) model.addAttribute("gsDebt", "5000");
        
        return JSP_PATH + "agc130rkr";
    }
    
    /**
     * 재무제표(copy)
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc135skr.do" )
    public String agc135skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false);
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> fnGetSession = accntCommonService.fnGetSession(param);    //기수
        model.addAttribute("fnGetSession", ObjUtils.toJsonStr(fnGetSession));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        cdo = codeInfo.getCodeInfo("A137", "1");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAssets", cdo.getRefCode1());  // 자산
        else if (ObjUtils.isEmpty(cdo)) model.addAttribute("gsAssets", "1999");
        
        cdo = codeInfo.getCodeInfo("A137", "2");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsDebt", cdo.getRefCode1());        // 부채
        else if (ObjUtils.isEmpty(cdo)) model.addAttribute("gsDebt", "5000");
        
        return JSP_PATH + "agc135skr";
    }
    
    /**
     * 재무제표(copy)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc135rkr.do" )
    public String agc135rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false);
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> fnGetSession = accntCommonService.fnGetSession(param);    //기수
        model.addAttribute("fnGetSession", ObjUtils.toJsonStr(fnGetSession));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        cdo = codeInfo.getCodeInfo("A137", "1");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAssets", cdo.getRefCode1());  // 자산
        else if (ObjUtils.isEmpty(cdo)) model.addAttribute("gsAssets", "1999");
        
        cdo = codeInfo.getCodeInfo("A137", "2");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsDebt", cdo.getRefCode1());        // 부채
        else if (ObjUtils.isEmpty(cdo)) model.addAttribute("gsDebt", "5000");
        
        return JSP_PATH + "agc135rkr";
    }
    
    /**
     * 사업장별재무제표
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc150skr.do" )
    public String agc150skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc150skr";
    }
    
    /**
     * <pre>
     * add by Chen.RD 사업장별재무제표
     * 
     * <pre>
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc150rkr.do" )
    public String agc150rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("agc150rkr".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc150rkr";
    }
    
    /**
     * 프로젝트별재무제표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc160skr.do" )
    public String agc160skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc160skr";
    }

    /**
     * <pre>
     * add by Chen.RD 사업장별재무제표
     * 
     * <pre>
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc160rkr.do" )
    public String agc160rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("agc160rkr".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc160rkr";
    }
    
    /**
     * 프로젝트별재무제표
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc165skr.do" )
    public String agc165skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc165skr";
    }
    
    /**
     * 월별재무제표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc170skr.do" )
    public String agc170skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc170skr";
    }
    
    /**
     * 월별재무제표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc170rkr.do" )
    public String agc170rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("agc170rkr".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc170rkr";
    }
    
    /**
     * 공시용재무제표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc180skr.do" )
    public String agc180skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> fnGetSession = accntCommonService.fnGetSession(param);    //기수
        model.addAttribute("fnGetSession", ObjUtils.toJsonStr(fnGetSession));
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc180skr";
    }
    
    /**
     * 공시용재무제표(2)
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc190skr.do" )
    public String agc190skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> fnGetSession = accntCommonService.fnGetSession(param);    //기수
        model.addAttribute("fnGetSession", ObjUtils.toJsonStr(fnGetSession));
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc190skr";
    }
    
    @RequestMapping( value = "/accnt/agc330ukr.do" )
    public String agc330ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc330ukr";
    }
    
    /**
     * 부서별손익계산서
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc200skr.do" )
    public String agc200skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc200skr";
    }
    
    /**
     * 결산부속명세서 출력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc210skr.do" )
    public String agc210skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        return JSP_PATH + "agc210skr";
    }
    
    /**
     * 결산부속명세서 Excel 다운로드
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc210excel.do" )
    public ModelAndView agc210excel( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        /*
         * Job ID 생성
         */
        String jobId = makeJobID();
        
        String AC_DATE_FR = _req.getP("AC_DATE_FR");
        String AC_DATE_TO = _req.getP("AC_DATE_TO");
        String DIV_CODE = _req.getP("DIV_CODE");
        String ACCNT_CODE_FR = _req.getP("ACCNT_CODE_FR");
        String ACCNT_NAME_FR = _req.getP("ACCNT_NAME_FR");
        String ACCNT_CODE_TO = _req.getP("ACCNT_CODE_TO");
        String ACCNT_NAME_TO = _req.getP("ACCNT_NAME_TO");
        String START_DATE = _req.getP("START_DATE");
        
        Map<String, Object> param = new HashMap<String, Object>();
        
        param.put("COMP_CODE", loginVO.getCompCode());
        param.put("ST_DATE", START_DATE);
        param.put("FR_DATE", AC_DATE_FR);
        param.put("TO_DATE", AC_DATE_TO);
        param.put("DIV_CODE", DIV_CODE);
        param.put("FR_ACCNT", ACCNT_CODE_FR);
        param.put("TO_ACCNT", ACCNT_CODE_TO);
        param.put("ASST_TYPE", "1");
        param.put("KEY_VALUE", jobId);
        param.put("USERID", loginVO.getUserID());
        param.put("LANG_TYPE", loginVO.getLanguage());
        
        /**
         * <pre>
         * param.put(&quot;COMP_CODE&quot;, &quot;ZZ24&quot;);
         * param.put(&quot;ST_DATE&quot;, &quot;201601&quot;);
         * param.put(&quot;FR_DATE&quot;, &quot;20160101&quot;);
         * param.put(&quot;TO_DATE&quot;, &quot;20161231&quot;);
         * param.put(&quot;DIV_CODE&quot;, DIV_CODE);
         * param.put(&quot;FR_ACCNT&quot;, ACCNT_CODE_FR);
         * param.put(&quot;TO_ACCNT&quot;, ACCNT_CODE_TO);
         * param.put(&quot;ASST_TYPE&quot;, &quot;1&quot;);
         * param.put(&quot;KEY_VALUE&quot;, &quot;201701141536153578681&quot;);
         * param.put(&quot;USERID&quot;, loginVO.getUserID());
         * param.put(&quot;LANG_TYPE&quot;, loginVO.getLanguage());
         * </pre>
         */
        
        logger.info("param :: {}", param);
        
        /*******************************************************************************************
         * 0. Excel 다운로드 시작
         *******************************************************************************************/
        String excelFileName = "결속부속명세서";
        
        SXSSFWorkbook workbook = new SXSSFWorkbook();
        Sheet sheet = null;
        Row headerRow = null;
        Row row = null;
        
        String ACCNT_CD = "";
        int i = 0;
        
        DataFormat formet = workbook.createDataFormat();
        
        // TITLE
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short)18);
        font.setBoldweight((short)Font.BOLDWEIGHT_BOLD);
        
        // Style 00 : 기본
        CellStyle style00 = workbook.createCellStyle();
        style00.setBorderBottom(CellStyle.BORDER_HAIR);
        style00.setBorderLeft(CellStyle.BORDER_HAIR);
        style00.setBorderRight(CellStyle.BORDER_HAIR);
        style00.setBorderTop(CellStyle.BORDER_HAIR);
        
        // Style 01 : 중앙정렬
        CellStyle style01 = workbook.createCellStyle();
        style01.setBorderBottom(CellStyle.BORDER_HAIR);
        style01.setBorderLeft(CellStyle.BORDER_HAIR);
        style01.setBorderRight(CellStyle.BORDER_HAIR);
        style01.setBorderTop(CellStyle.BORDER_HAIR);
        style01.setAlignment(CellStyle.ALIGN_CENTER);
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        
        // Style 02 : TITLE
        CellStyle style02 = workbook.createCellStyle();
        style02.setBorderBottom(CellStyle.BORDER_HAIR);
        style02.setBorderLeft(CellStyle.BORDER_HAIR);
        style02.setBorderRight(CellStyle.BORDER_HAIR);
        style02.setBorderTop(CellStyle.BORDER_HAIR);
        style02.setAlignment(CellStyle.ALIGN_CENTER);
        style02.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style02.setFont(font);
        
        // Style 03 : 숫자
        CellStyle style03 = workbook.createCellStyle();
        style03.setBorderBottom(CellStyle.BORDER_HAIR);
        style03.setBorderLeft(CellStyle.BORDER_HAIR);
        style03.setBorderRight(CellStyle.BORDER_HAIR);
        style03.setBorderTop(CellStyle.BORDER_HAIR);
        style03.setDataFormat(formet.getFormat("#,##0"));
        
        /*
         * Temp 테이블에서 전표 자동기표 으로 데이터를 저장 한다.
         */
        String errMsg = agc210skrService.accntAgc190Rkr(param);
        if (errMsg != null && errMsg.length() > 0) {
            throw new Exception(errMsg);
        }
        
        /*******************************************************************************************
         * 1. 현금 및 현금등가물 목록
         *******************************************************************************************/
        List<Map<String, Object>> list01 = agc210skrService.getWorkGubun01(param);
        
        if (list01.size() > 0) {
            try {
                sheet = workbook.createSheet("현금 및 현금등가물");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("현금 및 현금등가물-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)5));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("현금 및 현금등가물");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            
            headerRow.getCell(0).setCellValue("과목");
            headerRow.getCell(1).setCellValue("적요");
            headerRow.getCell(2).setCellValue("적요");
            headerRow.getCell(3).setCellValue("계좌번호");
            headerRow.getCell(4).setCellValue("금액");
            headerRow.getCell(5).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)2, (int)1, (short)2));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            // header 끝 .........................
            
            i = 2;
            String REMARK1 = null;
            String REMARK2 = null;
            
            for (Map<String, Object> map : list01) {
                ++i;
                row = sheet.createRow(i);
                
                REMARK1 = (String)map.get("REMARK1");
                REMARK2 = (String)map.get("REMARK2");
                if (REMARK1.equals(REMARK2)) {
                    row.createCell(0).setCellValue("");
                    row.createCell(1).setCellValue(REMARK1);
                    row.createCell(2).setCellValue(REMARK1);
                    
                    row.getCell(0).setCellStyle(style01);
                    row.getCell(1).setCellStyle(style01);
                    row.getCell(2).setCellStyle(style01);
                    
                    sheet.addMergedRegion(new CellRangeAddress(i, (short)i, (int)1, (short)2));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )
                    row.getCell(1).setCellStyle(style01);
                } else {
                    row.createCell(0).setCellValue((String)map.get("ACCNT_CD_NAME"));
                    row.createCell(1).setCellValue(REMARK1);
                    row.createCell(2).setCellValue(REMARK2);
                    
                    row.getCell(0).setCellStyle(style00);
                    row.getCell(1).setCellStyle(style00);
                    row.getCell(2).setCellStyle(style00);
                }
                
                if (map.get("BANK_ACCOUNT") == null || ( (String)map.get("BANK_ACCOUNT") ).length() == 0) {
                    row.createCell(3).setCellValue("");
                } else {
                    row.createCell(3).setCellValue(decrypto.getDecrypto("1", (String)map.get("BANK_ACCOUNT")));
                }
                row.createCell(4).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(5).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(3).setCellStyle(style00);
                row.getCell(4).setCellStyle(style03);  // 숫자
                row.getCell(5).setCellStyle(style00);
            }
        }
        
        /*******************************************************************************************
         * 2. 현금 및 현금등가물 목록
         *******************************************************************************************/
        List<Map<String, Object>> list02 = agc210skrService.getWorkGubun02(param);
        
        if (list02.size() > 0) {
            try {
                sheet = workbook.createSheet("단기금융상품 및 장기금융상품");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("단기금융상품 및 장기금융상품-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            headerRow.createCell(8);
            headerRow.createCell(9);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            headerRow.getCell(6).setCellStyle(style02);
            headerRow.getCell(7).setCellStyle(style02);
            headerRow.getCell(8).setCellStyle(style02);
            headerRow.getCell(9).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)9));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("단기금융상품 및 장기금융상품");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            headerRow.createCell(8);
            headerRow.createCell(9);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("구분");
            headerRow.createCell(1).setCellValue("구분");
            headerRow.createCell(2).setCellValue("거래처");
            headerRow.createCell(3).setCellValue("적요");
            headerRow.createCell(4).setCellValue("기산일");
            headerRow.createCell(5).setCellValue("만기일");
            headerRow.createCell(6).setCellValue("이율");
            headerRow.createCell(7).setCellValue("금액");
            headerRow.createCell(8).setCellValue("금액");
            headerRow.createCell(9).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            headerRow.getCell(6).setCellStyle(style01);
            headerRow.getCell(7).setCellStyle(style01);
            headerRow.getCell(8).setCellStyle(style01);
            headerRow.getCell(9).setCellStyle(style01);
            
            headerRow = sheet.createRow(3);
            headerRow.createCell(0).setCellValue("과목");
            headerRow.createCell(1).setCellValue("예금명");
            headerRow.createCell(2).setCellValue("거래처");
            headerRow.createCell(3).setCellValue("적요");
            headerRow.createCell(4).setCellValue("기산일");
            headerRow.createCell(5).setCellValue("만기일");
            headerRow.createCell(6).setCellValue("이율");
            headerRow.createCell(7).setCellValue("계약금액");
            headerRow.createCell(8).setCellValue("불입금액");
            headerRow.createCell(9).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            headerRow.getCell(6).setCellStyle(style01);
            headerRow.getCell(7).setCellStyle(style01);
            headerRow.getCell(8).setCellStyle(style01);
            headerRow.getCell(9).setCellStyle(style01);
            
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)2, (int)0, (short)1));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)2, (short)2));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)3, (short)3));   //거래처 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)4, (short)4));   //적요 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)5, (short)5));   //기산일 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)6, (short)6));   //만기일 ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)2, (int)7, (short)8));   //구분 ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)9, (short)9));   //적요 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 36 * 256);
            sheet.setColumnWidth(3, 36 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            sheet.setColumnWidth(6, 18 * 256);
            sheet.setColumnWidth(7, 18 * 256);
            sheet.setColumnWidth(8, 18 * 256);
            sheet.setColumnWidth(9, 18 * 256);
            // header 끝 .........................
            
            i = 3;
            row = null;
            
            for (Map<String, Object> map : list02) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("ACCNT_CD_NAME"));
                row.createCell(1).setCellValue((String)map.get("BANK_NAME"));
                row.createCell(2).setCellValue((String)map.get("ACCNT_NAME"));
                if (map.get("BANK_ACCOUNT") == null || ( (String)map.get("BANK_ACCOUNT") ).length() == 0) {
                    row.createCell(3).setCellValue("");
                } else {
                    row.createCell(3).setCellValue(decrypto.getDecrypto("1", (String)map.get("BANK_ACCOUNT")));
                }
                row.createCell(4).setCellValue((String)map.get("PUB_DATE"));
                row.createCell(5).setCellValue((String)map.get("EXP_DATE"));
                row.createCell(6).setCellValue(( (BigDecimal)map.get("INT_RATE") ).doubleValue());
                row.createCell(7).setCellValue(( (BigDecimal)map.get("EXP_AMT_I") ).doubleValue());
                row.createCell(8).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(9).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style00);
                row.getCell(3).setCellStyle(style00);
                row.getCell(4).setCellStyle(style00);
                row.getCell(5).setCellStyle(style00);
                row.getCell(6).setCellStyle(style03);  // 숫자
                row.getCell(7).setCellStyle(style03);  // 숫자
                row.getCell(8).setCellStyle(style03);  // 숫자
                row.getCell(9).setCellStyle(style00);
            }
        }
        
        /*******************************************************************************************
         * 3. 외상매출금
         *******************************************************************************************/
        List<Map<String, Object>> list03 = agc210skrService.getWorkGubun03(param);
        
        if (list03.size() > 0) {
            try {
                sheet = workbook.createSheet("외상매출금");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("외상매출금-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)5));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("외상매출금");
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("거래처");
            headerRow.createCell(1).setCellValue("적요");
            headerRow.createCell(2).setCellValue("금액");
            headerRow.createCell(3).setCellValue("거래처");
            headerRow.createCell(4).setCellValue("적요");
            headerRow.createCell(5).setCellValue("금액");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 36 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 36 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 36 * 256);
            sheet.setColumnWidth(4, 36 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            // header 끝 .........................
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list03) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("CUSTOM_NAME1"));
                row.createCell(1).setCellValue((String)map.get("REMARK1"));
                row.createCell(2).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(3).setCellValue((String)map.get("CUSTOM_NAME2"));
                row.createCell(4).setCellValue((String)map.get("REMARK2"));
                row.createCell(5).setCellValue(( (BigDecimal)map.get("AMT_I2") ).doubleValue());
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style03);  // 숫자
                row.getCell(3).setCellStyle(style00);
                row.getCell(4).setCellStyle(style00);
                row.getCell(5).setCellStyle(style03);  // 숫자
            }
        }
        
        /*******************************************************************************************
         * 4. 받을어음
         *******************************************************************************************/
        List<Map<String, Object>> list04 = agc210skrService.getWorkGubun04(param);
        
        if (list04.size() > 0) {
            try {
                sheet = workbook.createSheet("받을어음");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("받을어음-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            headerRow.getCell(6).setCellStyle(style02);
            headerRow.getCell(7).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)7));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("받을어음");
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("거래처");
            headerRow.createCell(1).setCellValue("금액");
            headerRow.createCell(2).setCellValue("어음번호");
            headerRow.createCell(3).setCellValue("만기일/지급일");
            headerRow.createCell(4).setCellValue("어음종류");
            headerRow.createCell(5).setCellValue("지급장소");
            headerRow.createCell(6).setCellValue("금액");
            headerRow.createCell(7).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            headerRow.getCell(6).setCellStyle(style01);
            headerRow.getCell(7).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 22 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            sheet.setColumnWidth(6, 18 * 256);
            sheet.setColumnWidth(7, 18 * 256);
            // header 끝 .........................
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list04) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("CUSTOM_NAME1"));
                row.createCell(1).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(2).setCellValue((String)map.get("NOTE_NUM"));
                row.createCell(3).setCellValue((String)map.get("EXP_DATE"));
                row.createCell(4).setCellValue((String)map.get("DC_DIVI"));
                row.createCell(5).setCellValue((String)map.get("BANK_NAME"));
                row.createCell(6).setCellValue(( (BigDecimal)map.get("OC_AMT_I") ).doubleValue());
                row.createCell(7).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style03);  // 숫자
                row.getCell(2).setCellStyle(style00);
                row.getCell(3).setCellStyle(style00);
                row.getCell(4).setCellStyle(style00);
                row.getCell(5).setCellStyle(style00);
                row.getCell(6).setCellStyle(style03);  // 숫자
                row.getCell(7).setCellStyle(style00);
            }
        }
        
        /*******************************************************************************************
         * 5. 받을어음
         *******************************************************************************************/
        List<Map<String, Object>> list05 = agc210skrService.getWorkGubun05(param);
        
        if (list05.size() > 0) {
            try {
                sheet = workbook.createSheet("지급어음");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("지급어음-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            headerRow.getCell(6).setCellStyle(style02);
            headerRow.getCell(7).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)7));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("지급어음");
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("거래처");
            headerRow.createCell(1).setCellValue("금액");
            headerRow.createCell(2).setCellValue("어음번호");
            headerRow.createCell(3).setCellValue("만기일/지급일");
            headerRow.createCell(4).setCellValue("어음종류");
            headerRow.createCell(5).setCellValue("지급장소");
            headerRow.createCell(6).setCellValue("금액");
            headerRow.createCell(7).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            headerRow.getCell(6).setCellStyle(style01);
            headerRow.getCell(7).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            sheet.setColumnWidth(6, 18 * 256);
            sheet.setColumnWidth(7, 18 * 256);
            // header 끝 .........................
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list05) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("CUSTOM_NAME1"));
                row.createCell(1).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(2).setCellValue((String)map.get("NOTE_NUM"));
                row.createCell(3).setCellValue((String)map.get("EXP_DATE"));
                row.createCell(4).setCellValue((String)map.get("DC_DIVI"));
                row.createCell(5).setCellValue((String)map.get("BANK_NAME"));
                row.createCell(6).setCellValue(( (BigDecimal)map.get("OC_AMT_I") ).doubleValue());
                row.createCell(7).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style03);  // 숫자
                row.getCell(2).setCellStyle(style00);
                row.getCell(3).setCellStyle(style00);
                row.getCell(4).setCellStyle(style00);
                row.getCell(5).setCellStyle(style00);
                row.getCell(6).setCellStyle(style03);  // 숫자
                row.getCell(7).setCellStyle(style00);
            }
        }
        /*******************************************************************************************
         * 6. 거래처별적요 : 미수금, 선급금 등
         *******************************************************************************************/
        List<Map<String, Object>> list06 = agc210skrService.getWorkGubun06(param);
        
        if (list06.size() > 0) {
            for (Map<String, Object> map : list06) {
                
                if (!ACCNT_CD.equals((String)map.get("ACCNT_CD"))) {
                    
                    try {
                        sheet = workbook.createSheet((String)map.get("ACCNT_CD_NAME"));
                    } catch (Exception e) {
                        logger.error(e.getMessage());
                        sheet = workbook.createSheet((String)map.get("ACCNT_CD_NAME") + "중복");
                    }
                    
                    // title 시작 .........................
                    headerRow = sheet.createRow(0);
                    headerRow.setHeight((short)800);      // 1000 이 행높이 50
                    
                    headerRow.createCell(0);
                    headerRow.createCell(1);
                    headerRow.createCell(2);
                    headerRow.createCell(3);
                    
                    headerRow.getCell(0).setCellStyle(style02);
                    headerRow.getCell(1).setCellStyle(style02);
                    headerRow.getCell(2).setCellStyle(style02);
                    headerRow.getCell(3).setCellStyle(style02);
                    
                    sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)3));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
                    headerRow.getCell(0).setCellValue((String)map.get("ACCNT_CD_NAME"));
                    
                    headerRow = sheet.createRow(1);
                    headerRow.createCell(0);
                    headerRow.createCell(1);
                    headerRow.createCell(2);
                    headerRow.createCell(3);
                    // title 끝 .........................
                    
                    // header 시작 .........................
                    headerRow = sheet.createRow(2);
                    headerRow.createCell(0).setCellValue("거래처");
                    headerRow.createCell(1).setCellValue("적요");
                    headerRow.createCell(2).setCellValue("금액");
                    headerRow.createCell(3).setCellValue("비고");
                    
                    headerRow.getCell(0).setCellStyle(style01);
                    headerRow.getCell(1).setCellStyle(style01);
                    headerRow.getCell(2).setCellStyle(style01);
                    headerRow.getCell(3).setCellStyle(style01);
                    
                    sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
                    sheet.setColumnWidth(1, 50 * 256);
                    sheet.setColumnWidth(2, 18 * 256);
                    sheet.setColumnWidth(3, 18 * 256);
                    // header 끝 .........................
                    
                    ACCNT_CD = (String)map.get("ACCNT_CD");
                    
                    i = 2;
                    row = null;
                }
                
                ++i;
                row = sheet.createRow(i);
                row.createCell(0).setCellValue((String)map.get("CUSTOM_NAME1"));
                row.createCell(1).setCellValue((String)map.get("REMARK1"));
                row.createCell(2).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(3).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style03);  // 숫자
                row.getCell(3).setCellStyle(style00);
                
            }
        }
        /*******************************************************************************************
         * 7. 미수수익
         *******************************************************************************************/
        List<Map<String, Object>> list07 = agc210skrService.getWorkGubun07(param);
        
        if (list07.size() > 0) {
            try {
                sheet = workbook.createSheet("미수수익");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("미수수익-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)4));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("미수수익");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("거래처");
            headerRow.createCell(1).setCellValue("적요");
            headerRow.createCell(2).setCellValue("");
            headerRow.createCell(3).setCellValue("금액");
            headerRow.createCell(4).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            // header 시작 .........................
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list07) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("SAVE_DESC"));
                if (map.get("BANK_ACCOUNT") == null || ( (String)map.get("BANK_ACCOUNT") ).length() == 0) {
                    row.createCell(1).setCellValue("");
                } else {
                    row.createCell(1).setCellValue(decrypto.getDecrypto("1", (String)map.get("BANK_ACCOUNT")));
                }
                row.createCell(2).setCellValue((String)map.get("REMARK"));
                row.createCell(3).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(4).setCellValue((String)map.get("EXP_DATE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style00);
                row.getCell(3).setCellStyle(style03);  // 숫자
                row.getCell(4).setCellStyle(style00);
            }
        }
        /*******************************************************************************************
         * 8. 선급비용
         *******************************************************************************************/
        List<Map<String, Object>> list08 = agc210skrService.getWorkGubun08(param);
        
        if (list08.size() > 0) {
            try {
                sheet = workbook.createSheet("선급비용");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("선급비용-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            headerRow.getCell(6).setCellStyle(style02);
            headerRow.getCell(7).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)7));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("선급비용");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("거래처");
            headerRow.createCell(1).setCellValue("적요");
            headerRow.createCell(2).setCellValue("원금");
            headerRow.createCell(3).setCellValue("기간");
            headerRow.createCell(4).setCellValue("이율");
            headerRow.createCell(5).setCellValue("적용일수");
            headerRow.createCell(6).setCellValue("금액");
            headerRow.createCell(7).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            headerRow.getCell(6).setCellStyle(style01);
            headerRow.getCell(7).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            sheet.setColumnWidth(6, 18 * 256);
            sheet.setColumnWidth(7, 18 * 256);
            // header 끝 .........................
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list08) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("CUSTOM_NAME1"));
                row.createCell(1).setCellValue((String)map.get("REMARK1"));
                row.createCell(2).setCellValue(( (BigDecimal)map.get("ORG_AMT_I") ).doubleValue());
                row.createCell(3).setCellValue((String)map.get("TERM"));
                row.createCell(4).setCellValue(( (BigDecimal)map.get("INTEREST") ).doubleValue());
                row.createCell(5).setCellValue(( (BigDecimal)map.get("APPLY_DAYS") ).doubleValue());
                row.createCell(6).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(7).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style03);  // 숫자
                row.getCell(3).setCellStyle(style00);
                row.getCell(4).setCellStyle(style03);  // 숫자
                row.getCell(5).setCellStyle(style03);  // 숫자
                row.getCell(6).setCellStyle(style03);  // 숫자
                row.getCell(7).setCellStyle(style00);
            }
        }
        /*******************************************************************************************
         * 9. 재고자산명세서
         *******************************************************************************************/
        List<Map<String, Object>> list09 = agc210skrService.getWorkGubun09(param);
        
        if (list09.size() > 0) {
            try {
                sheet = workbook.createSheet("재고자산명세서");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("재고자산명세서-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)5));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("재고자산명세서");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("과목");
            headerRow.createCell(1).setCellValue("기초잔액");
            headerRow.createCell(2).setCellValue("당기증가액");
            headerRow.createCell(3).setCellValue("당기감소액");
            headerRow.createCell(4).setCellValue("기말잔액");
            headerRow.createCell(5).setCellValue("타계정대체액");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            // header 끝 .........................
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list09) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("ACCNT_NAME"));
                row.createCell(1).setCellValue(( (BigDecimal)map.get("BASIC_AMT_I") ).doubleValue());
                row.createCell(2).setCellValue(( (BigDecimal)map.get("INCRE_AMT_I") ).doubleValue());
                row.createCell(3).setCellValue(( (BigDecimal)map.get("DECRE_AMT_I") ).doubleValue());
                row.createCell(4).setCellValue(( (BigDecimal)map.get("FINAL_AMT_I") ).doubleValue());
                row.createCell(5).setCellValue(( (BigDecimal)map.get("ALTER_AMT_I") ).doubleValue());
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style00);
                row.getCell(3).setCellStyle(style03);  // 숫자
                row.getCell(4).setCellStyle(style03);  // 숫자
                row.getCell(5).setCellStyle(style03);  // 숫자
            }
        }
        /*******************************************************************************************
         * 10. 예수금
         *******************************************************************************************/
        List<Map<String, Object>> list10 = agc210skrService.getWorkGubun10(param);
        
        if (list10.size() > 0) {
            try {
                sheet = workbook.createSheet("예수금");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("예수금-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)4));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("예수금");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("거래처");
            headerRow.createCell(1).setCellValue("기간");
            headerRow.createCell(2).setCellValue("적요");
            headerRow.createCell(3).setCellValue("금액");
            headerRow.createCell(4).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 36 * 256);
            sheet.setColumnWidth(2, 36 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            // header 끝 .........................
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list10) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("CUSTOM_NAME1"));
                row.createCell(1).setCellValue((String)map.get("TERM"));
                row.createCell(2).setCellValue((String)map.get("REMARK1"));
                row.createCell(3).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(4).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style00);
                row.getCell(3).setCellStyle(style03);  // 숫자
                row.getCell(4).setCellStyle(style00);
            }
        }
        /*******************************************************************************************
         * 11. 계정별묶음
         *******************************************************************************************/
        List<Map<String, Object>> list11 = agc210skrService.getWorkGubun11(param);
        
        if (list11.size() > 0) {
            try {
                sheet = workbook.createSheet("계정별묶음");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("계정별묶음-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)3));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("계정별묶음");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("거래처");
            headerRow.createCell(1).setCellValue("적요");
            headerRow.createCell(2).setCellValue("금액");
            headerRow.createCell(3).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 36 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list11) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("CUSTOM_NAME1"));
                row.createCell(1).setCellValue((String)map.get("ACCNT_NAME"));
                row.createCell(2).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(3).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style03);  // 숫자
                row.getCell(3).setCellStyle(style00);
            }
        }
        /*******************************************************************************************
         * 12. 유형자산
         *******************************************************************************************/
        List<Map<String, Object>> list12 = agc210skrService.getWorkGubun12(param);
        
        if (list12.size() > 0) {
            try {
                sheet = workbook.createSheet("유형자산");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("유형자산-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            headerRow.createCell(8);
            headerRow.createCell(9);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            headerRow.getCell(6).setCellStyle(style02);
            headerRow.getCell(7).setCellStyle(style02);
            headerRow.getCell(8).setCellStyle(style02);
            headerRow.getCell(9).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)9));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("유형자산");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            headerRow.createCell(6);
            headerRow.createCell(7);
            headerRow.createCell(8);
            headerRow.createCell(9);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("자산의구분");
            headerRow.createCell(1).setCellValue("수량");
            headerRow.createCell(2).setCellValue("취득가액");
            headerRow.createCell(3).setCellValue("당기증가");
            headerRow.createCell(4).setCellValue("당기감소");
            headerRow.createCell(5).setCellValue("기말잔액");
            headerRow.createCell(6).setCellValue("상각율");
            headerRow.createCell(7).setCellValue("감가상각충당금");
            headerRow.createCell(8).setCellValue("감가상각충당금");
            headerRow.createCell(9).setCellValue("차기말잔액");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            headerRow.getCell(6).setCellStyle(style01);
            headerRow.getCell(7).setCellStyle(style01);
            headerRow.getCell(8).setCellStyle(style01);
            headerRow.getCell(9).setCellStyle(style01);
            
            headerRow = sheet.createRow(3);
            headerRow.createCell(0).setCellValue("자산의구분");
            headerRow.createCell(1).setCellValue("수량");
            headerRow.createCell(2).setCellValue("취득가액");
            headerRow.createCell(3).setCellValue("당기증가");
            headerRow.createCell(4).setCellValue("당기감소");
            headerRow.createCell(5).setCellValue("기말잔액");
            headerRow.createCell(6).setCellValue("상각율");
            headerRow.createCell(7).setCellValue("당기상각");
            headerRow.createCell(8).setCellValue("상각액누계");
            headerRow.createCell(9).setCellValue("차기말잔액");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            headerRow.getCell(6).setCellStyle(style01);
            headerRow.getCell(7).setCellStyle(style01);
            headerRow.getCell(8).setCellStyle(style01);
            headerRow.getCell(9).setCellStyle(style01);
            
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)0, (short)0));   //자산의구분 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)1, (short)1));   //수량 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)2, (short)2));   //취득가액 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)3, (short)3));   //당기증가 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)4, (short)4));   //당기감소 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)5, (short)5));   //기말잔액 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)6, (short)6));   //삼각율 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)2, (int)7, (short)8));   //감가상각충당금 ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            sheet.addMergedRegion(new CellRangeAddress((int)2, (short)3, (int)9, (short)9));   //차기말잔액 ( 세로병합 - First Row, Last Row, First Col, Last Col  )
            
            sheet.setColumnWidth(0, 36 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            sheet.setColumnWidth(6, 10 * 256);
            sheet.setColumnWidth(7, 18 * 256);
            sheet.setColumnWidth(8, 18 * 256);
            sheet.setColumnWidth(9, 18 * 256);
            // header 끝 .........................
            
            i = 3;
            row = null;
            
            for (Map<String, Object> map : list12) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("ASST_NAME"));
                row.createCell(1).setCellValue((String)map.get("GUBUN"));
                row.createCell(2).setCellValue(( (BigDecimal)map.get("ACQ_AMT_I") ).doubleValue());
                row.createCell(3).setCellValue(( (BigDecimal)map.get("CUR_IN_AMT") ).doubleValue());
                row.createCell(4).setCellValue(( (BigDecimal)map.get("CUR_DEC_AMT") ).doubleValue());
                row.createCell(5).setCellValue(( (BigDecimal)map.get("FINAL_BALN_AMT") ).doubleValue());
                row.createCell(6).setCellValue((String)map.get("DRB_YEAR"));
                row.createCell(7).setCellValue(( (BigDecimal)map.get("CUR_DPR_AMT") ).doubleValue());
                row.createCell(8).setCellValue(( (BigDecimal)map.get("CUR_DPR_TOT") ).doubleValue());
                row.createCell(9).setCellValue(( (BigDecimal)map.get("DPR_BALN_AMT") ).doubleValue());
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style03);  // 숫자
                row.getCell(3).setCellStyle(style03);  // 숫자
                row.getCell(4).setCellStyle(style03);  // 숫자
                row.getCell(5).setCellStyle(style03);  // 숫자
                row.getCell(6).setCellStyle(style00);
                row.getCell(7).setCellStyle(style03);  // 숫자
                row.getCell(8).setCellStyle(style03);  // 숫자
                row.getCell(9).setCellStyle(style03);  // 숫자
            }
        }
        /*******************************************************************************************
         * 13. 감가상각비
         *******************************************************************************************/
        List<Map<String, Object>> list13 = agc210skrService.getWorkGubun13(param);
        
        if (list13.size() > 0) {
            try {
                sheet = workbook.createSheet("감가상각비");
            } catch (Exception e) {
                logger.error(e.getMessage());
                sheet = workbook.createSheet("감가상각비-중복");
            }
            
            // title 시작 .........................
            headerRow = sheet.createRow(0);
            headerRow.setHeight((short)800);      // 1000 이 행높이 50
            
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            
            headerRow.getCell(0).setCellStyle(style02);
            headerRow.getCell(1).setCellStyle(style02);
            headerRow.getCell(2).setCellStyle(style02);
            headerRow.getCell(3).setCellStyle(style02);
            headerRow.getCell(4).setCellStyle(style02);
            headerRow.getCell(5).setCellStyle(style02);
            
            sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)5));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
            headerRow.getCell(0).setCellValue("감가상각비");
            
            headerRow = sheet.createRow(1);
            headerRow.createCell(0);
            headerRow.createCell(1);
            headerRow.createCell(2);
            headerRow.createCell(3);
            headerRow.createCell(4);
            headerRow.createCell(5);
            // title 끝 .........................
            
            // header 시작 .........................
            headerRow = sheet.createRow(2);
            headerRow.createCell(0).setCellValue("자산과목");
            headerRow.createCell(1).setCellValue("취득가액");
            headerRow.createCell(2).setCellValue("당기상각액");
            headerRow.createCell(3).setCellValue("상각비누계");
            headerRow.createCell(4).setCellValue("차감기말잔액");
            headerRow.createCell(5).setCellValue("비고");
            
            headerRow.getCell(0).setCellStyle(style01);
            headerRow.getCell(1).setCellStyle(style01);
            headerRow.getCell(2).setCellStyle(style01);
            headerRow.getCell(3).setCellStyle(style01);
            headerRow.getCell(4).setCellStyle(style01);
            headerRow.getCell(5).setCellStyle(style01);
            
            sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
            sheet.setColumnWidth(1, 18 * 256);
            sheet.setColumnWidth(2, 18 * 256);
            sheet.setColumnWidth(3, 18 * 256);
            sheet.setColumnWidth(4, 18 * 256);
            sheet.setColumnWidth(5, 18 * 256);
            // header 끝 .........................
            
            i = 2;
            row = null;
            
            for (Map<String, Object> map : list13) {
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("ACCNT_NAME"));
                row.createCell(1).setCellValue(( (BigDecimal)map.get("ACQ_AMT_I") ).doubleValue());
                row.createCell(2).setCellValue(( (BigDecimal)map.get("CUR_DPR_AMT") ).doubleValue());
                row.createCell(3).setCellValue(( (BigDecimal)map.get("CUR_DPR_TOT") ).doubleValue());
                row.createCell(4).setCellValue(( (BigDecimal)map.get("DPR_BALN_AMT") ).doubleValue());
                row.createCell(5).setCellValue((String)map.get("REFERENCE"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style03);  // 숫자
                row.getCell(2).setCellStyle(style03);  // 숫자
                row.getCell(3).setCellStyle(style03);  // 숫자
                row.getCell(4).setCellStyle(style03);  // 숫자
                row.getCell(5).setCellStyle(style00);
            }
        }
        /*******************************************************************************************
         * 14. 단기/장기차입금
         *******************************************************************************************/
        List<Map<String, Object>> list14 = agc210skrService.getWorkGubun14(param);
        
        if (list14.size() > 0) {
            ACCNT_CD = "";
            
            for (Map<String, Object> map : list14) {
                if (!ACCNT_CD.equals((String)map.get("ACCNT_CD"))) {
                    try {
                        sheet = workbook.createSheet((String)map.get("ACCNT_CD_NAME"));
                    } catch (Exception e) {
                        logger.error(e.getMessage());
                        sheet = workbook.createSheet((String)map.get("ACCNT_CD_NAME") + "중복");
                    }
                    
                    // title 시작 .........................
                    headerRow = sheet.createRow(0);
                    headerRow.setHeight((short)800);      // 1000 이 행높이 50
                    
                    headerRow.createCell(0);
                    headerRow.createCell(1);
                    headerRow.createCell(2);
                    headerRow.createCell(3);
                    headerRow.createCell(4);
                    headerRow.createCell(5);
                    headerRow.createCell(6);
                    
                    headerRow.getCell(0).setCellStyle(style02);
                    headerRow.getCell(1).setCellStyle(style02);
                    headerRow.getCell(2).setCellStyle(style02);
                    headerRow.getCell(3).setCellStyle(style02);
                    headerRow.getCell(4).setCellStyle(style02);
                    headerRow.getCell(5).setCellStyle(style02);
                    headerRow.getCell(6).setCellStyle(style02);
                    
                    sheet.addMergedRegion(new CellRangeAddress((int)0, (short)0, (int)0, (short)6));   // ( 가로병합 - First Row, Last Row, First Col, Last Col  )
                    headerRow.getCell(0).setCellValue((String)map.get("ACCNT_CD_NAME"));
                    
                    headerRow = sheet.createRow(1);
                    headerRow.createCell(0);
                    headerRow.createCell(1);
                    headerRow.createCell(2);
                    headerRow.createCell(3);
                    headerRow.createCell(4);
                    headerRow.createCell(5);
                    headerRow.createCell(6);
                    // title 끝 .........................
                    
                    // header 시작 .........................
                    headerRow = sheet.createRow(2);
                    headerRow.createCell(0).setCellValue("차입처");
                    headerRow.createCell(1).setCellValue("과목");
                    headerRow.createCell(2).setCellValue("금액");
                    headerRow.createCell(3).setCellValue("이자율");
                    headerRow.createCell(4).setCellValue("기표일");
                    headerRow.createCell(5).setCellValue("만기일");
                    headerRow.createCell(6).setCellValue("비고");
                    
                    headerRow.getCell(0).setCellStyle(style01);
                    headerRow.getCell(1).setCellStyle(style01);
                    headerRow.getCell(2).setCellStyle(style01);
                    headerRow.getCell(3).setCellStyle(style01);
                    headerRow.getCell(4).setCellStyle(style01);
                    headerRow.getCell(5).setCellStyle(style01);
                    headerRow.getCell(6).setCellStyle(style01);
                    
                    sheet.setColumnWidth(0, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
                    sheet.setColumnWidth(1, 18 * 256);
                    sheet.setColumnWidth(2, 18 * 256);
                    sheet.setColumnWidth(3, 18 * 256);
                    sheet.setColumnWidth(4, 18 * 256);
                    sheet.setColumnWidth(5, 18 * 256);
                    sheet.setColumnWidth(6, 18 * 256);
                    // header 끝 .........................
                    
                    ACCNT_CD = (String)map.get("ACCNT_CD");
                    
                    i = 2;
                    row = null;
                    
                }
                
                ++i;
                row = sheet.createRow(i);
                
                row.createCell(0).setCellValue((String)map.get("CUSTOM_NAME1"));
                row.createCell(1).setCellValue((String)map.get("ACCNT_NAME"));
                row.createCell(2).setCellValue(( (BigDecimal)map.get("AMT_I1") ).doubleValue());
                row.createCell(3).setCellValue(( (BigDecimal)map.get("INT_RATE") ).doubleValue());
                row.createCell(4).setCellValue((String)map.get("PUB_DATE"));
                row.createCell(5).setCellValue((String)map.get("EXP_DATE"));
                row.createCell(6).setCellValue((String)map.get("REMARK1"));
                
                row.getCell(0).setCellStyle(style00);
                row.getCell(1).setCellStyle(style00);
                row.getCell(2).setCellStyle(style03);  // 숫자
                row.getCell(3).setCellStyle(style03);  // 숫자
                row.getCell(4).setCellStyle(style00);
                row.getCell(5).setCellStyle(style00);
                row.getCell(6).setCellStyle(style00);
            }
        }
        /*******************************************************************************************
         * 99. 삭제
         *******************************************************************************************/
        agc210skrService.multiDelete(param);
        
        return ViewHelper.getExcelDownloadView(workbook, excelFileName);
    }
    
    /**
     * 원가대체입력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unused" } )
    @RequestMapping( value = "/accnt/agc310ukr.do", method = RequestMethod.GET )
    public String agc310ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsGubunA093 = codeInfo.getCodeList("A093", "", false);       //재무제표양식차수
        for (CodeDetailVO map : gsGubunA093) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsGubunA093", map.getCodeNo());
            }
        }
        /**
         * 외주재고포함여부
         */
        Map bBizrefYN = (Map)agc310ukrService.bBizrefYN(param);
        //      model.addAttribute("bBizrefYN", bBizrefYN.get("bBizrefYN"));
        if (bBizrefYN.get("SUB_CODE").equals("")) {
            model.addAttribute("bBizrefYN", "2");
        } else {
            model.addAttribute("bBizrefYN", bBizrefYN.get("SUB_CODE"));
        }
        return JSP_PATH + "agc310ukr";
    }
    
    /**
     * 도금원가대체입력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unused" } )
    @RequestMapping( value = "/accnt/agc360ukr.do", method = RequestMethod.GET )
    public String agc360ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsGubunA093 = codeInfo.getCodeList("A093", "", false);       //재무제표양식차수
        for (CodeDetailVO map : gsGubunA093) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsGubunA093", map.getCodeNo());
            }
        }
        /**
         * 외주재고포함여부
         */
        Map bBizrefYN = (Map)agc310ukrService.bBizrefYN(param);
        //      model.addAttribute("bBizrefYN", bBizrefYN.get("bBizrefYN"));
        if (bBizrefYN.get("SUB_CODE").equals("")) {
            model.addAttribute("bBizrefYN", "2");
        } else {
            model.addAttribute("bBizrefYN", bBizrefYN.get("SUB_CODE"));
        }
        return JSP_PATH + "agc360ukr";
    }
    /**
     * 원가대체입력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc340ukr.do", method = RequestMethod.GET )
    public String agc340ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsGubunA093 = codeInfo.getCodeList("A093", "", false);       //재무제표양식차수
        for (CodeDetailVO map : gsGubunA093) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsGubunA093", map.getCodeNo());
            }
        }
        /*      *//**
                   * 외주재고포함여부
                   */
        /*
         * Map bBizrefYN = (Map)agc310ukrService.bBizrefYN(param); // model.addAttribute("bBizrefYN", bBizrefYN.get("bBizrefYN")); if(bBizrefYN.get("SUB_CODE").equals("")){ model.addAttribute("bBizrefYN", "2"); }else{ model.addAttribute("bBizrefYN", bBizrefYN.get("SUB_CODE")); }
         */
        return JSP_PATH + "agc340ukr";
    }
    
    /**
     * 사업원가자동기표
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc341ukr.do" )
    public String agc341ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        //param에 COMP_CODE 정보 추가
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "agc341ukr";
    }
    
    /**
     * 원가대체입력
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc350ukr.do", method = RequestMethod.GET )
    public String agc350ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsGubunA093 = codeInfo.getCodeList("A093", "", false);       //재무제표양식차수
        for (CodeDetailVO map : gsGubunA093) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsGubunA093", map.getCodeNo());
            }
        }
        /*      *//**
                   * 외주재고포함여부
                   */
        /*
         * Map bBizrefYN = (Map)agc310ukrService.bBizrefYN(param); // model.addAttribute("bBizrefYN", bBizrefYN.get("bBizrefYN")); if(bBizrefYN.get("SUB_CODE").equals("")){ model.addAttribute("bBizrefYN", "2"); }else{ model.addAttribute("bBizrefYN", bBizrefYN.get("SUB_CODE")); }
         */
        return JSP_PATH + "agc350ukr";
    }
    
    /**
     * 이익잉여금처분등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc120ukr.do", method = RequestMethod.GET )
    public String agc120ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsGubunA093 = codeInfo.getCodeList("A093", "", false);       //재무제표양식차수
        for (CodeDetailVO map : gsGubunA093) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsGubunA093", map.getCodeNo());
            }
        }
        
        return JSP_PATH + "agc120ukr";
    }
    
    /**
     * 자본변동표등록
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc125ukr.do", method = RequestMethod.GET )
    public String agc125ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsGubunA093 = codeInfo.getCodeList("A093", "", false);       //재무제표양식차수
        for (CodeDetailVO map : gsGubunA093) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsGubunA093", map.getCodeNo());
            }
        }
        
        return JSP_PATH + "agc125ukr";
    }

    /**
     * 현금흐름표등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc140ukr.do", method = RequestMethod.GET )
    public String agc140ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        List<Map<String, Object>> fnGetSession = accntCommonService.fnGetSession(param);    //기수
        model.addAttribute("fnGetSession", ObjUtils.toJsonStr(fnGetSession));
        return JSP_PATH + "agc140ukr";
    }

    /**
     * 현금흐름표등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/agc140rkr.do", method = RequestMethod.GET )
    public String agc140rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        List<Map<String, Object>> fnGetSession = accntCommonService.fnGetSession(param);    //기수
        model.addAttribute("fnGetSession", ObjUtils.toJsonStr(fnGetSession));

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("agc140rkr".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
        return JSP_PATH + "agc140rkr";
    }
    
    /**
     * 손이계산서
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/agc220skr.do" )
    public String agc220skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
        for (CodeDetailVO map : gsFinancialY) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsFinancialY", map.getCodeNo());
            }
        }
        List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);    //title
        model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "agc220skr";
    }
    
    public String makeJobID() {
        StringBuffer jobId = new StringBuffer(20);
        DateTime today = new DateTime();
        jobId.append(today.toString("yyyyMMddHHmmssSSS"));
        jobId.append(Math.round(Math.random() * 10000));
        return jobId.toString();
    }
    
    /**
	 * 외화환산평가
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agc400ukr.do")
	public String agc400ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH+"agc400ukr";
	}
	
}
