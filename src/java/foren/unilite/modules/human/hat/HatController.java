package foren.unilite.modules.human.hat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;

/**
 * 프로그램명 : 작업지시조정 작 성 자 : (주)포렌 개발실
 */
@Controller
public class HatController extends UniliteCommonController {
    
    private final Logger               logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String                JSP_PATH = "/human/hat/";
    
    /**
     * 서비스 연결
     */
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl           comboService;
    
    @Resource( name = "hat520skrService" )
    private Hat520skrServiceImpl       hat520skrService;
    
    @Resource( name = "hat200ukrService" )
    private Hat200ukrServiceImpl       hat200ukrService;
    
    @Resource( name = "hat550skrService" )
    private Hat550skrServiceImpl       hat550skrService;

    @Resource( name = "hat500ukrService" )
    private Hat500ukrServiceImpl       hat500ukrService;
    
    @Resource( name = "hat506ukrService" )
    private Hat506ukrServiceImpl       hat506ukrService;

    @Resource( name = "hat520ukrService" )
    private Hat520ukrServiceImpl       hat520ukrService;
    
    @Resource( name = "hat501ukrService" )
    private Hat501ukrServiceImpl       hat501ukrService;
    
    @Resource( name = "hat503ukrService" )
    private Hat503ukrServiceImpl       hat503ukrService;
    
    @Resource( name = "s_hat500ukr_shpService" )
    private s_Hat500ukr_shpServiceImpl s_hat500ukr_shpService;
    
    @Resource( name = "hat510ukrService" )
    private Hat510ukrServiceImpl       hat510ukrService;
    
    //    @Resource(name="hat520ukrService")
    //    private Hat520ukrServiceImpl hat520ukrService;
    
    @Resource( name = "hat600ukrService" )
    private Hat600ukrServiceImpl       hat600ukrService;
    
    @Resource( name = "hat910skrServiceImpl" )
    private Hat910skrServiceImpl       hat910skrServiceImpl;
    
    @Resource( name = "hat920rkrServiceImpl" )
    private Hat920rkrServiceImpl       hat920rkrServiceImpl;
    
    @Resource( name = "hat930skrServiceImpl" )
    private Hat930skrServiceImpl       hat930skrServiceImpl;
        
    /**
     * 일근태현황조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hat520skr.do" )
    public String hat520skrv( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hat520skrService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        List<CodeDetailVO> formatList = codeInfo.getCodeList("H235");
        String dutyNumFormat = "0.0";
        String dutyTimeFormat = "0.00";
        if(formatList != null) {
        	for(CodeDetailVO codeVO: formatList) {
        		if(codeVO != null)	{
	        		if("hat520skr".equals(codeVO.getRefCode1()) && "DUTY_NUM".equals(codeVO.getRefCode2())) {
	        			if(codeVO.getRefCode3() != null)	{
	        				if("0".equals(codeVO.getRefCode3())) {
	        					dutyNumFormat = "0,000";
	        				} else {
	        					dutyNumFormat = "0,000."+GStringUtils.rPad("", Integer.valueOf(codeVO.getRefCode3()),"0");
	        				}
	        			}
	        		}
	        		if("hat520skr".equals(codeVO.getRefCode1()) && "DUTY_TIME".equals(codeVO.getRefCode4())) {
	        			if(codeVO.getRefCode5() != null)	{
	        				if("0".equals(codeVO.getRefCode5())) {
	        					dutyTimeFormat = "0,000";
	        				} else {
	        					dutyTimeFormat = "0,000."+GStringUtils.rPad("", Integer.valueOf(codeVO.getRefCode5()),"0");
	        				}
	        			}
	        		}
        		}
        	}
        }
        
        model.addAttribute("DUTY_NUM_FORMAT", dutyNumFormat);
        model.addAttribute("DUTY_TIME_FORMAT", dutyTimeFormat);
        
        return JSP_PATH + "hat520skr";
    }
    
    @RequestMapping( value = "/human/hat410skr.do" )
    public String hat410skr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_DEPT_LIST", comboService.getDeptList(param));
        
        return JSP_PATH + "hat410skr";
    }
    
    @RequestMapping( value = "/human/hat540skr.do" )
    public String hat540skr() throws Exception {
        return JSP_PATH + "hat540skr";
    }
    
    @RequestMapping( value = "/human/hat540rkr.do" )
    public String hat540rkr() throws Exception {
        return JSP_PATH + "hat540rkr";
    }
    
    @RequestMapping( value = "/human/hat550skr.do" )
    public String hat550skr( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hat550skrService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        return JSP_PATH + "hat550skr";
    }
    
    @RequestMapping( value = "/human/hat400ukr.do" )
    public String hat400ukr() throws Exception {
        return JSP_PATH + "hat400ukr";
    }
    
    @RequestMapping( value = "/human/hat420ukr.do" )
    public String hat420ukr() throws Exception {
        return JSP_PATH + "hat420ukr";
    }
    
    @RequestMapping( value = "/human/hat502ukr.do" )
    public String hat502ukr() throws Exception {
        return JSP_PATH + "hat502ukr";
    }
    
    @RequestMapping( value = "/human/hat500ukr.do" )
    public String hat500ukr( LoginVO loginVO, ModelMap model ) throws Exception {
    	
        Gson gson = new Gson();
        String dutyRule = hat500ukrService.getDutyRule(loginVO.getCompCode());
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("DUTY_RULE", dutyRule);
        param.put("PAY_CODE", "0");
        String colData = gson.toJson(hat500ukrService.getDutycode(param));
        model.addAttribute("dutyRule", dutyRule);
        model.addAttribute("colData", colData);
        
        List<ComboItemModel> attendList = hat500ukrService.getComboList(param);
        model.addAttribute("COMBO_ATTEND", attendList);

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        boolean gsBUseColHidden = false;
        
        List<CodeDetailVO> gsUseColHidden = codeInfo.getCodeList("H175", "", false);
        for (CodeDetailVO map : gsUseColHidden) {
            if ("18".equals(map.getCodeNo()) && "Y".equals(map.getRefCode1())) {
            	gsBUseColHidden = true;
            }
        }
        model.addAttribute("gsBUseColHidden", gsBUseColHidden);
        
        return JSP_PATH + "hat500ukr";
    }
    
    @RequestMapping( value = "/human/hat506ukr.do" )
    public String hat506ukr( LoginVO loginVO, ModelMap model ) throws Exception {
    	
        Gson gson = new Gson();
        String dutyRule = hat506ukrService.getDutyRule(loginVO.getCompCode());
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("DUTY_RULE", dutyRule);
        param.put("PAY_CODE", "0");
        String colData = gson.toJson(hat506ukrService.getDutycode(param));
        model.addAttribute("dutyRule", dutyRule);
        model.addAttribute("colData", colData);
        
        List<ComboItemModel> attendList = hat506ukrService.getComboList(param);
        model.addAttribute("COMBO_ATTEND", attendList);

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        boolean gsBUseColHidden = false;
        
        List<CodeDetailVO> gsUseColHidden = codeInfo.getCodeList("H175", "", false);
        for (CodeDetailVO map : gsUseColHidden) {
            if ("18".equals(map.getCodeNo()) && "Y".equals(map.getRefCode1())) {
            	gsBUseColHidden = true;
            }
        }
        model.addAttribute("gsBUseColHidden", gsBUseColHidden);
        
        return JSP_PATH + "hat506ukr";
    }
    
    @RequestMapping( value = "/human/s_hat500ukr_shp.do" )
    public String s_hat500ukr_shp( LoginVO loginVO, ModelMap model ) throws Exception {
        return JSP_PATH + "s_hat500ukr_shp";
    }
    
    /**
     * SECOM 근태 등록(극동)
     * 
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/human/hat501ukr.do" )
    public String hat501ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String dutyRule = hat501ukrService.getDutyRule(loginVO.getCompCode());
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("DUTY_RULE", dutyRule);
        param.put("PAY_CODE", "0");
        //        String colData = gson.toJson(DevFreeUtils.getOrDefault(hat501ukrService.getDutycode(param), ""));
        model.addAttribute("dutyRule", dutyRule);
        //        model.addAttribute("colData", colData);
        return JSP_PATH + "hat501ukr";
    }
    
    /**
     * SECOM 근태 등록(극동)
     * 
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/human/hat503ukr.do" )
    public String hat503ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String dutyRule = hat503ukrService.getDutyRule(loginVO.getCompCode());
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("DUTY_RULE", dutyRule);
        param.put("PAY_CODE", "0");
        //        String colData = gson.toJson(DevFreeUtils.getOrDefault(hat501ukrService.getDutycode(param), ""));
        model.addAttribute("dutyRule", dutyRule);
        //        model.addAttribute("colData", colData);
        
        param.put("S_USER_ID", loginVO.getUserID());
		model.addAttribute("gsActivFlag", hat503ukrService.gsActivFlag(param));
        
        return JSP_PATH + "hat503ukr";
    }
    
    /**
     * SECOM 근태 등록(코베아)
     * 
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hat505ukr.do" )
    public String hat505ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        String dutyRule = hat501ukrService.getDutyRule(loginVO.getCompCode());
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("DUTY_RULE", dutyRule);
        param.put("PAY_CODE", "0");
        model.addAttribute("dutyRule", dutyRule);
        return JSP_PATH + "hat505ukr";
    }
    
    @RequestMapping( value = "/human/hat510ukr.do" )
    public String hat510ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String dutyRule = hat510ukrService.getDutyRule(loginVO.getCompCode());
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("DUTY_RULE", dutyRule);
        param.put("PAY_CODE", "0");
        String colData = gson.toJson(hat500ukrService.getDutycode(param));
        model.addAttribute("dutyRule", dutyRule);
        model.addAttribute("colData", colData);
        
        Map<String, String> param2 = new HashMap<String, String>();
        param2.put("S_COMP_CODE", loginVO.getCompCode());
        List<ComboItemModel> attendList = hat500ukrService.getComboList(param2);
        model.addAttribute("COMBO_ATTEND", attendList);
        
        return JSP_PATH + "hat510ukr";
    }
    
    @RequestMapping( value = "/human/getDutycode.do" )
    public ModelAndView getDutycode( @RequestParam Map<String, String> param ) throws Exception {
        Gson gson = new Gson();
        String dutyList = gson.toJson(hat500ukrService.getDutycode(param));
        return ViewHelper.getJsonView(dutyList);
    }
    
    @RequestMapping( value = "/human/getPostName.do" )
    public ModelAndView getPostName( @RequestParam Map<String, String> param ) throws Exception {
        Map post_name = hat510ukrService.getPostName(param);
        return ViewHelper.getJsonView(post_name);
    }
    
    @RequestMapping( value = "/human/hat520ukr.do" )
    public String hat520ukr(LoginVO loginVO, ModelMap model ) throws Exception {
    	Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        List<ComboItemModel> attendList = hat520ukrService.getComboList(param);
        model.addAttribute("COMBO_ATTEND", attendList);
        
        return JSP_PATH + "hat520ukr";
    }
    
    //    @RequestMapping(value="/human/getDutyList.do")
    //    public ModelAndView getDutyList(@RequestParam Map<String, String> param)throws Exception{
    //        List<Map<String, Object>> dutyList = hat520ukrService.getDutyList(param);
    //        return ViewHelper.getJsonView(dutyList);
    //    }
    
    //    @RequestMapping(value="/human/getComboList.do")
    //    public ModelAndView getComboList(@RequestParam Map<String, String> param)throws Exception{
    //        List<Map<String, Object>> dutyList = hat510ukrService.getComboList(param);
    //        return ViewHelper.getJsonView(dutyList);
    //    }
    
    //    @RequestMapping(value="/human/getWorkTeam.do")
    //    public ModelAndView getWorkteam(@RequestParam Map<String, String> param)throws Exception{
    //        String workTeam = hat520ukrService.getWorkTeam(param);
    //        return ViewHelper.getJsonView(workTeam);
    //    }
    //    
    
    @RequestMapping( value = "/human/hat600ukr.do" )
    public String hat600ukr(LoginVO loginVO, ModelMap model ) throws Exception {
    	
    	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        String flagPGM_YN = "N";
        CodeDetailVO flagPGMVO = codeInfo.getCodeInfo("H234", "1");
        if(flagPGMVO != null) {
        		flagPGM_YN = ObjUtils.getSafeString(flagPGMVO.getRefCode1(), "N");
        }
        model.addAttribute("FLAG_PGM_YN", flagPGM_YN);
        
        return JSP_PATH + "hat600ukr";
    }
    /*
     * @RequestMapping(value="/human/doTotalWorkHat600ukr.do") public ModelAndView doTotalWorkHat600ukr(@RequestParam Map<String, String> param, LoginVO loginVO)throws Exception{ param.put("S_COMP_CODE", loginVO.getCompCode()); String result = hat600ukrService.doTotalWork(param); return ViewHelper.getJsonView(result); }
     */
    
    @RequestMapping( value = "/human/hat200ukr.do" )
    public String hat200ukr( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hat200ukrService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        
        Map closeDateMap = hat200ukrService.fnCheckCloseMonth(loginVO);
        String closeDate = "";
        if(closeDateMap != null )	{
        	closeDate = ObjUtils.getSafeString(closeDateMap.get("CLOSE_DATE"), "");
        }
        model.addAttribute("CLOSE_DATE", closeDate);
        
        Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//특정부서 콤보
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        List<CodeDetailVO> formatList = codeInfo.getCodeList("H235");
        String dutyNumFormat = "0.0";
        String dutyTimeFormat = "0.00";
        if(formatList != null) {
        	for(CodeDetailVO codeVO: formatList) {
        		if(codeVO != null)	{
	        		if("hat200ukr".equals(codeVO.getRefCode1()) && "DUTY_NUM".equals(codeVO.getRefCode2())) {
	        			if(codeVO.getRefCode3() != null)	{
	        				if("0".equals(codeVO.getRefCode3())) {
	        					dutyNumFormat = "0,000";
	        				} else {
	        					dutyNumFormat = "0,000."+GStringUtils.rPad("", Integer.valueOf(codeVO.getRefCode3()),"0");
	        				}
	        			}
	        		}
	        		if("hat200ukr".equals(codeVO.getRefCode1()) && "DUTY_TIME".equals(codeVO.getRefCode4())) {
	        			if(codeVO.getRefCode5() != null)	{
	        				if("0".equals(codeVO.getRefCode5())) {
	        					dutyTimeFormat = "0,000";
	        				} else {
	        					dutyTimeFormat = "0,000."+GStringUtils.rPad("", Integer.valueOf(codeVO.getRefCode5()),"0");
	        				}
	        			}
	        		}
        		}
        	}
        }
        
        model.addAttribute("DUTY_NUM_FORMAT", dutyNumFormat);
        model.addAttribute("DUTY_TIME_FORMAT", dutyTimeFormat);
        
        
        return JSP_PATH + "hat200ukr";
    }
    
    @RequestMapping( value = "/human/hat200skr.do" )
    public String hat200skr( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hat520skrService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        
        Map map = new HashMap();
        model.addAttribute("COMBO_DEPTS2", comboService.fnGetauthDepts(loginVO,map));//특정부서 콤보
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        List<CodeDetailVO> formatList = codeInfo.getCodeList("H235");
        String dutyNumFormat = "0,000.0";
        String dutyTimeFormat = "0,000.00";
        if(formatList != null) {
        	for(CodeDetailVO codeVO: formatList) {
        		if(codeVO != null)	{
	        		if("hat200skr".equals(codeVO.getRefCode1()) && "DUTY_NUM".equals(codeVO.getRefCode2())) {
	        			if(codeVO.getRefCode3() != null)	{
	        				if("0".equals(codeVO.getRefCode3())) {
	        					dutyNumFormat = "0,000";
	        				} else {
	        					dutyNumFormat = "0,000."+GStringUtils.rPad("", Integer.valueOf(codeVO.getRefCode3()),"0");
	        				}
	        			}
	        		}
	        		if("hat200skr".equals(codeVO.getRefCode1()) && "DUTY_TIME".equals(codeVO.getRefCode4())) {
	        			if(codeVO.getRefCode5() != null)	{
	        				if("0".equals(codeVO.getRefCode5())) {
	        					dutyTimeFormat = "0,000";
	        				} else {
	        					dutyTimeFormat = "0,000."+GStringUtils.rPad("", Integer.valueOf(codeVO.getRefCode5()),"0");
	        				}
	        			}
	        		}
        		}
        	}
        }
        
        model.addAttribute("DUTY_NUM_FORMAT", dutyNumFormat);
        model.addAttribute("DUTY_TIME_FORMAT", dutyTimeFormat);
        
        return JSP_PATH + "hat200skr";
    }
    
    @RequestMapping( value = "/human/hat820rkr.do" )
    public String hat820rkr() throws Exception {
        return JSP_PATH + "hat820rkr";
    }
    
    @RequestMapping( value = "/human/hat530rkr.do" )
    public String hat530rkr() throws Exception {
        return JSP_PATH + "hat530rkr";
    }
    
    /**
     * 일근태등록확정
     * @param loginVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hat605ukr.do" )
    public String hat605ukr(LoginVO loginVO, ModelMap model) throws Exception {
    	
        return JSP_PATH + "hat605ukr";
    }
    
    //기간별 근태현황 분석표 조회
    @RequestMapping( value = "/human/hat850skr.do" )
    public String hat850skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hat850skr";
    }
    @RequestMapping( value = "/human/hat851skr.do" )
    public String hat851skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hat851skr";
    }
    @RequestMapping( value = "/human/s_hat851skr_kva.do" )
    public String s_hat851skr_kva( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "s_hat851skr_kva";
    }
    
    
    //인천(서울) 근태현황 조회
    @RequestMapping( value = "/human/hat870skr.do" )
    public String hat870skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hat870skr";
    }
    
    //야근자 보고서 조회
    @RequestMapping( value = "/human/hat880skr.do" )
    public String hat880skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hat880skr";
    }
    
    //근태대장 조회
    @RequestMapping( value = "/human/hat890skr.do" )
    public String hat890skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hat890skr";
    }
    
    //일일 근태대장 조회
    @RequestMapping( value = "/human/hat900skr.do" )
    public String hat900skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hat900skr";
    }
    
    // 부서별 식수현황 집계표 조회
    @RequestMapping( value = "/human/hat910skr.do" )
    public String hat910skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hat910skr";
    }
    
    // 부서별 식수현황 집계표 조회
    @RequestMapping( value = "/human/hat920rkr.do" )
    public String hat920rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hat920rkr";
    }
    
    @RequestMapping( value = "/human/hat930skr.do" )
    public String hat930skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = codeInfo.getCodeInfo("B609", "GW_URL");
        if(!ObjUtils.isEmpty(cdo))
        	model.addAttribute("groupUrl", cdo.getCodeName());
        else
        	model.addAttribute("groupUrl", "about:blank");

        return JSP_PATH + "hat930skr";
    }
}