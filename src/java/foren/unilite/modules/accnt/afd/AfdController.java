package foren.unilite.modules.accnt.afd;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

/**
 * 프로그램명 : 작업지시조정 작 성 자 : (주)포렌 개발실
 */
@Controller
public class AfdController extends UniliteCommonController {
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
    
    private final Logger           logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String            JSP_PATH = "/accnt/afd/";
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl       comboService;
    
    @Resource( name = "afd650ukrService" )
    private Afd650ukrServiceImpl   afd650ukrService;
    
    @Resource( name = "afd660skrService" )
    private Afd660skrServiceImpl   afd660skrService;
    
    /**
     * 총계정원장
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/afd510skr.do" )
    public String afd510skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "afd510skr";
    }
    
    /**
     * 예적금등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/afd500ukr.do" )
    public String afd500ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
        if(getStDt != null && getStDt.size() > 0)	{
        	model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt.get(0)));
        } else {
        	model.addAttribute("getStDt", "{}");
        }
        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for (CodeDetailVO map : gsMoneyUnit) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        } /* 주화폐단위 */
        
        return JSP_PATH + "afd500ukr";
    }
    
    /**
     * 예적금미수수익명세
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/afd520skr.do" )
    public String afd520skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
    	
    	final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
    	param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
        if(getStDt != null && getStDt.size() > 0)	{
        	model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt.get(0)));
        } else {
        	model.addAttribute("getStDt", "{}");
        }
        return JSP_PATH + "afd520skr";
    }
    
    /**
     * 차입금등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/afd600ukr.do" )
    public String afd600ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
        model.addAttribute("getChargeCode", ObjUtils.toJsonStr(getChargeCode));
        
        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
        for (CodeDetailVO map : gsMoneyUnit) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
            }
        } /* 주화폐단위 */
        
        Map<String, Object>	amtPoint = (Map<String, Object>)accntCommonService.fnGetAmtPoint(param);
        if(amtPoint != null)	{
        	model.addAttribute("gsAmtPoint", amtPoint.get("AMT_POINT"));
        }else {
        	
        	model.addAttribute("gsAmtPoint", "");
        }
        return JSP_PATH + "afd600ukr";
    }
    
    @RequestMapping( value = "/accnt/afd530skr.do" )
    public String afd530skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "afd530skr";
    }
    
    @RequestMapping( value = "/accnt/afd610skr.do" )
    public String afd610skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
        model.addAttribute("getChargeCode", ObjUtils.toJsonStr(getChargeCode));
        
        return JSP_PATH + "afd610skr";
    }
    
    @RequestMapping( value = "/accnt/afd630skr.do" )
    public String afd630skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        return JSP_PATH + "afd630skr";
    }
    
    @RequestMapping( value = "/accnt/afd650ukr.do" )
    public String afd650ukr( LoginVO loginVO, ModelMap model ) throws Exception {

        return JSP_PATH + "afd650ukr";
    }
    
    /**
     * 차입금상환계획 조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/afd660skr.do" )
    public String afd660skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode", ObjUtils.toJsonStr(getChargeCode));
        
        return JSP_PATH + "afd660skr";
    }
    
    /**
     * 차입금상환계획 등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/afd660ukr.do" )
    public String afd660ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        
        List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);       // ChargeCode관련         
        model.addAttribute("getChargeCode", ObjUtils.toJsonStr(getChargeCode));
        
        return JSP_PATH + "afd660ukr";
    }

    /**
     * 차입금상환계획 등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/accnt/afd670ukr.do" )
    public String afd670ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        return JSP_PATH + "afd670ukr";
    }
}
