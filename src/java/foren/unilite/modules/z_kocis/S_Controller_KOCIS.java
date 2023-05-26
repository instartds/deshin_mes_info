package foren.unilite.modules.z_kocis;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
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
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;
import foren.unilite.modules.human.HumanUtils;
import foren.unilite.modules.human.hat.Hat520skrServiceImpl;
import foren.unilite.modules.human.hbs.Hbs020ukrServiceImpl;
import foren.unilite.modules.human.hpa.Hpa994ukrServiceImpl;
import foren.unilite.multidb.cubrid.fn.CommonServiceImpl_KOCIS_CUBRID;
 
@Controller
public class S_Controller_KOCIS extends UniliteCommonController {
    
    final static String                    JSP_PATH           = "/z_kocis/";
    public final static String             FILE_TYPE_OF_PHOTO = "employeePhoto";
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl               comboService;
    
    @Resource( name = "commonServiceImpl_KOCIS_CUBRID" )
    private CommonServiceImpl_KOCIS_CUBRID commonServiceImpl_KOCIS_CUBRID;
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl         accntCommonService;
    
    @Resource( name = "s_Afb300ukrService_KOCIS" )
    private S_Afb300ukrServiceImpl_KOCIS   s_Afb300ukrService_KOCIS;
    @Resource( name = "s_Afb400ukrService_KOCIS" )
    private S_Afb400ukrServiceImpl_KOCIS   s_Afb400ukrService_KOCIS;
    @Resource( name = "s_Afb410ukrService_KOCIS" )
    private S_Afb410ukrServiceImpl_KOCIS   s_Afb410ukrService_KOCIS;
    @Resource( name = "s_afb500skrService_KOCIS" )
    private S_Afb500skrServiceImpl_KOCIS   s_afb500skrService_KOCIS;
    @Resource( name = "s_afb510skrService_KOCIS" )
    private S_Afb510skrServiceImpl_KOCIS   s_afb510skrService_KOCIS;
    @Resource( name = "s_afb520ukrkocisService" )
    private S_Afb520ukrkocisServiceImpl  s_afb520ukrkocisService;
    @Resource( name = "s_afb540skrService_KOCIS" )
    private S_Afb540skrServiceImpl_KOCIS   s_afb540skrService_KOCIS;
    @Resource( name = "s_afb555skrService_KOCIS" )
    private S_Afb555skrServiceImpl_KOCIS   s_afb555skrService_KOCIS;
    @Resource( name = "s_afb560skrService_KOCIS" )
    private S_Afb560skrServiceImpl_KOCIS   s_afb560skrService_KOCIS;
    //	@Resource(name="s_ass100ukrService_KOCIS")
    //	private S_Ass300ukrServiceImpl_KOCIS s_ass300ukrService_KOCIS;
    
    @Resource( name = "s_afb600skrService_KOCIS" )
    private S_Afb600skrServiceImpl_KOCIS   s_afb600skrService_KOCIS;
    @Resource( name = "s_afb600ukrService_KOCIS" )
    private S_Afb600ukrServiceImpl_KOCIS   s_afb600ukrService_KOCIS;

    @Resource( name = "s_afb700ukrkocisService" )
    private S_Afb700ukrkocisServiceImpl   s_afb700ukrkocisService;
    
    @Resource( name = "s_afs100ukrService_KOCIS" )
    private S_Afs100ukrServiceImpl_KOCIS   s_afs100ukrService_KOCIS;
    
    @Resource( name = "s_bor120ukrvService_KOCIS" )
    private S_Bor120ukrvServiceImpl_KOCIS  s_bor120ukrvService_KOCIS;
    @Resource( name = "s_bcm100ukrvService_KOCIS" )
    private S_Bcm100ukrvServiceImpl_KOCIS  s_bcm100ukrvService_KOCIS;
    
    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl         humanCommonService;
    
    @Resource( name = "s_hum100ukrService_KOCIS" )
    private S_Hum100ukrServiceImpl_KOCIS   s_hum100ukrService_KOCIS;
    
    @Resource( name = "s_hum290ukrService_KOCIS" )
    private S_Hum290ukrServiceImpl_KOCIS   s_hum290ukrService_KOCIS;
    
    @Resource( name = "s_hum920skrService_KOCIS" )
    private S_Hum920skrServiceImpl_KOCIS   s_hum920skrService_KOCIS;
    
    @Resource( name = "hpa994ukrService" )
    private Hpa994ukrServiceImpl           hpa994ukrService;
    
    @Resource( name = "hat520skrService" )
    private Hat520skrServiceImpl           hat520skrService;
    
    @Resource( name = "s_hpa330ukrService_KOCIS" )
    private S_Hpa330ukrServiceImpl_KOCIS   s_hpa330ukrService_KOCIS;
    
    @Resource( name = "s_hpa950skrService_KOCIS" )
    private S_Hpa950skrServiceImpl_KOCIS   s_hpa950skrService_KOCIS;
    
    @Resource( name = "s_hpa955skrService_KOCIS" )
    private S_Hpa955skrServiceImpl_KOCIS   s_hpa955skrService_KOCIS;
    
    @Resource( name = "s_hpa340ukrService_KOCIS" )
    private S_Hpa340ukrServiceImpl_KOCIS   s_hpa340ukrService_KOCIS;
    
    @Resource( name = "s_hpa350ukrService_KOCIS" )
    private S_Hpa350ukrServiceImpl_KOCIS   s_hpa350ukrService_KOCIS;
    
    @Resource( name = "s_hbs920ukrService_KOCIS" )
    private S_Hbs920ukrServiceImpl_KOCIS   s_hbs920ukrService_KOCIS;
    
    @Resource( name = "s_hrt110ukrService_KOCIS" )
    private S_Hrt110ukrServiceImpl_KOCIS   s_hrt110ukrService_KOCIS;
    
    @Resource( name = "s_hrt506ukrService_KOCIS" )
    private S_Hrt506ukrServiceImpl_KOCIS   s_hrt506ukrService_KOCIS;
    
    @Resource(name="hbs020ukrService")
    private Hbs020ukrServiceImpl hbs020ukrService;
    
    
    private final Logger                   logger             = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 물품신청등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_ass300ukr_KOCIS.do" )
    public String s_ass300ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        cdo = codeInfo.getCodeInfo("A151", "1");									//자산코드 자동채번(Y)/수동채번(N)
        if (!ObjUtils.isEmpty(cdo)) {
            model.addAttribute("gsAutoType", cdo.getRefCode1());
        } else {
            model.addAttribute("gsAutoType", "N");
        }

        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        int i = 0;
        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보		
        for (CodeDetailVO map : gsMoneyUnit) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("gsMoneyUnit", map.getCodeNo());
                i++;
            }
        }
        if (i == 0) model.addAttribute("gsMoneyUnit", "KRW");
        
        return JSP_PATH + "s_ass300ukr_KOCIS";
    }
    
    /**
     * 물품변동내역등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_ass500ukr_KOCIS.do" )
    public String s_ass500ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_ass500ukr_KOCIS";
    }
    
    /**
     * 물품대장조회
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_ass600skr_KOCIS.do" )
    public String s_ass600skr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_ass600skr_KOCIS";
    }
    
	/**
	 * 물품처분내역조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kocis/s_ass700skr_KOCIS.do")
	public String s_ass700skr_KOCIS(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
		
		return JSP_PATH + "s_ass700skr_KOCIS";
	}
    
	/**
	 * 미술품등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kocis/s_ass900ukr_KOCIS.do")
	public String s_ass900ukr_KOCIS(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
		
		return JSP_PATH + "s_ass900ukr_KOCIS";
	}
    
	/**
	 * 미술품내역조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kocis/s_ass910skr_KOCIS.do")
	public String s_ass910skr_KOCIS(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
		
		return JSP_PATH + "s_ass910skr_KOCIS";
	}

    
    /**
     * 예산업무설정
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb300ukr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb300ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "s_afb300ukr_KOCIS";
    }
    
    /**
     * 예산코드등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb400ukr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb400ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "s_afb400ukr_KOCIS";
    }
    
    /**
     * 재외문화원별 예산코드 등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb410ukr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb410ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb410ukr_KOCIS";
    }
    
    /**
     * 예산총괄표(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb500skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb500skr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
    
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb500skr_KOCIS";
    }
    
    /**
     * 세출예산등록(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb503ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb503ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afb503ukr_kocis";
    }
    
    /**
     * 예산실적비교표(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb510skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb510skr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb510skr_KOCIS";
    }
    
    /**
     * 예산편성조회(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb511skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb511skr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb511skr_KOCIS";
    }
    
    /**
     * 비교수지예산표(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb520skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb520skr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb520skr_KOCIS";
    }
    /**
     * 세목조정등록(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb520ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb520ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
/*        List<Map<String, Object>> chargeInfoList = s_afb520ukrService_KOCIS.selectChargeInfo(param);    // ChargeCode 가져오기
        model.addAttribute("chargeInfoList",ObjUtils.toJsonStr(chargeInfoList));
        
        List<Map<String, Object>> budgNameList = s_afb520ukrService_KOCIS.selectBudgName(param);        // 부서목록 조회          
        model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));*/
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb520ukr_kocis";
    }
    /**
     * 예산집행현황 (KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb540skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb540skr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb540skr_KOCIS";
    }
    
    /**
     * 예산집행상세내역조회(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb555skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb555skr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
      
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb555skr_KOCIS";
    }
    
    /**
     * 세목조정내역조회(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb560skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb560skr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb560skr_KOCIS";
    }
    
    /**
     * 예산이월/불용액(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb530ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb530ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afb530ukr_kocis";
    }
    
    /**
     * 예산불용승인(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb570ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb570ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afb570ukr_kocis";
    }
    
    @RequestMapping( value = "/z_kocis/s_afb600skr_KOCIS.do" )
    public String s_afb600skr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        List<Map<String, Object>> budgNameList = s_afb600skrService_KOCIS.selectBudgName(param);        //부서목록 조회           
        model.addAttribute("budgNameList", ObjUtils.toJsonStr(budgNameList));
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb600skr_KOCIS";
    }
    
    /**
     * 예산기안(추산)등록
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    @RequestMapping( value = "/z_kocis/s_afb600ukr_KOCIS.do" )
    public String s_afb600ukr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        
        List budgNameList = commonServiceImpl_KOCIS_CUBRID.fnGetBudgLevelName(param);
        model.addAttribute("budgNameList", ObjUtils.toJsonStr(budgNameList));
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        Map selectCheck1Map = (Map)s_afb600ukrService_KOCIS.selectCheck1(param);
        model.addAttribute("gsIdMapping", selectCheck1Map.get("MAPPING"));
        model.addAttribute("gsLinkedGW", selectCheck1Map.get("GWIF"));
        model.addAttribute("gsConfirm", selectCheck1Map.get("CONFIRM"));
        model.addAttribute("gsConButtonYN", selectCheck1Map.get("CON_BUTTON_YN"));
        model.addAttribute("gsLineCopy", selectCheck1Map.get("LINE_COPY"));
        
        Map selectCheck2Map = (Map)s_afb600ukrService_KOCIS.selectCheck2(param);
        model.addAttribute("gsDrafter", selectCheck2Map.get("PERSON_NUMB"));
        model.addAttribute("gsDrafterNm", selectCheck2Map.get("NAME"));
        model.addAttribute("gsDeptCode", selectCheck2Map.get("DEPT_CODE"));
        model.addAttribute("gsDeptName", selectCheck2Map.get("DEPT_NAME"));
        model.addAttribute("gsDivCode", selectCheck2Map.get("DIV_CODE"));
        
        Map selectCheck3Map = (Map)s_afb600ukrService_KOCIS.selectCheck3(param);
        model.addAttribute("gsPathInfo1", selectCheck3Map.get("PATH_INFO_1"));
        model.addAttribute("gsPathInfo3", selectCheck3Map.get("PATH_INFO_3"));
        model.addAttribute("gsPathInfo4", selectCheck3Map.get("PATH_INFO_4"));
        
        Map selectCheck4Map = (Map)s_afb600ukrService_KOCIS.selectCheck4(param);
        model.addAttribute("selectCheck4", selectCheck4Map.get("SUB_CODE"));
        
        Map selectCheck5Map = (Map)s_afb600ukrService_KOCIS.selectCheck5(param);
        model.addAttribute("selectCheck5", selectCheck5Map.get("SUB_CODE"));
        
        return JSP_PATH + "s_afb600ukr_KOCIS";
    }
    
    /**
     * 지출결의등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/z_kocis/s_afb700ukr_kocis.do" )
    public String s_afb700ukr_kocis(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        /**
         * 문서서식구분 콤보 관련
         */
        List<CodeDetailVO> gsListA171 = codeInfo.getCodeList("A171", "", false);
        Object list1= "";
        for(CodeDetailVO map : gsListA171)  {
            if("0".equals(map.getRefCode2()) || "1".equals(map.getRefCode2()))  {
                if(list1.equals("")){
                list1 =  map.getCodeNo();
                }else{
                    list1 = list1 + ";" + map.getCodeNo();
                }
            }
        }
        model.addAttribute("gsListA171", list1);
        

        
        return JSP_PATH+"s_afb700ukr_kocis";
    }
    
    /**
     * 지출결의내역조회
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kocis/s_afb700skr_KOCIS.do",method = RequestMethod.GET)
    public String s_afb700skr_KOCIS(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
    
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        return JSP_PATH + "s_afb700skr_KOCIS";
    }
    /**
     * 지출등록대장 (KOCIS)
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kocis/s_afb710skr_KOCIS.do",method = RequestMethod.GET)
    public String s_afb710skr_KOCIS(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
    
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
            
        return JSP_PATH + "s_afb710skr_KOCIS";
    }
    /**
     * 기안(액)현황 (KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb730skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb730skr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb730skr_KOCIS";
    }
    
    /**
     * 지출정정결의 및 반납 결의(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb730ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb730ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afb730ukr_kocis";
    }
    
    /**
     * 이체결의(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb740ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb740ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afb740ukr_kocis";
    }
    
    /**
     * 이체결의(KOCIS)테스트
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb740ukr.do", method = RequestMethod.GET )
    public String s_afb740ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afb740ukr";
    }
    
    /**
     * 관서운영경비 출납 계산서(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb930skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb930skr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb930skr_KOCIS";
    }
    
    /**
     * 목별 지출명세서(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb940skr_KOCIS.do", method = RequestMethod.GET )
    public String s_afb940sk_KOCISr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb940skr_KOCIS";
    }
    
    /**
     * 수입결의내역조회(KOCIS)
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb800skr_KOCIS.do" )
    public String s_afb800skr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //param에 COMP_CODE 정보 추가
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afb800skr_KOCIS";
    }
    /**
     * 수입결의등록(KOCIS)
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/z_kocis/s_afb800ukr_kocis.do")
    public String s_afb800ukr_kocis(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
 
        return JSP_PATH+"s_afb800ukr_kocis";
    }
    /**
     * 관서운영경비잔액내역서(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb950ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb950ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afb950ukr_kocis";
    }
    
    /**
     * 년 마감(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb960ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb960ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb960ukr_kocis";
    }
    
    /**
     * 월 마감(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb970ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb970ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb970ukr_kocis";
    }
    
    /**
     * 월 마감(KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afb980ukr_kocis.do", method = RequestMethod.GET )
    public String s_afb980ukr_kocis( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        //CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        //CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_afb980ukr_kocis";
    }
    
    
    
    
    
    
    
    /**
     * 해외문화홍보원 - 재외문화원등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_bor120ukrv_KOCIS.do", method = RequestMethod.GET )
    public String s_bor120ukrv_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "s_bor120ukrv_KOCIS";
    }
    
    /**
     * 해외문화홍보원 - 거래처정보등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_bcm100ukrv_KOCIS.do", method = RequestMethod.GET )
    public String s_bcm100ukrv_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        cdo = codeInfo.getCodeInfo("B244", "10");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsHiddenField", cdo.getRefCode1());
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_bcm100ukrv_KOCIS";
    }
    
    /**
     * 해외문화홍보원 - 사용자정보등록
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kocis/s_bsa300ukrv_KOCIS.do", method = RequestMethod.GET)
    public String s_bsa300ukrv_KOCIS(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보

        return JSP_PATH + "s_bsa300ukrv_KOCIS";
    }
    
    /* 인사 */
    
    @SuppressWarnings( "rawtypes" )
    /**
     * 인사자료등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum100ukr_KOCIS.do" )
    public String s_hum100ukr_KOCIS( LoginVO loginVO, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        CodeDetailVO cdo = codeInfo.getCodeInfo("H102", "01");
        if (!ObjUtils.isEmpty(cdo)) {
            if ("Y".equals(ObjUtils.getSafeString(cdo.getRefCode1()))) {
                model.addAttribute("autoNum", "true");	//Y:여신잔액(txtRemainCredit) visible
            } else {
                model.addAttribute("autoNum", "false");	//Y:여신잔액(txtRemainCredit) visible
            }
        }
        Map param = new HashMap();
        //param.put("S_COMP_CODE", loginVO.getCompCode());
        //        model.addAttribute("BussOfficeCode", hpa994ukrService.getBussOfficeCode(param));
        
        List<Map<String, Object>> wageStd = s_hum100ukrService_KOCIS.fnHum100P2Codes(param);
        
        if (ObjUtils.isNotEmpty(wageStd)) {
            model.addAttribute("wageStd", ObjUtils.toJsonStr(wageStd));
        } else {
            model.addAttribute("wageStd", "[]");
        }
        
        model.addAttribute("costPoolCombo", comboService.getHumanCostPool(param));
        
        return JSP_PATH + "s_hum100ukr_KOCIS";
    }
    
    /**
     * 평정관리(개별/종합)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum290ukr_KOCIS.do" )
    public String s_hum290ukr_KOCIS( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        //final String[] searchFields = {};
        //NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        //Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
//        Gson gson = new Gson();
//        String colData = gson.toJson(s_hum290ukrService_KOCIS.selectColumns(loginVO.getCompCode()));
//        model.addAttribute("colData", colData);
        
        return JSP_PATH + "s_hum290ukr_KOCIS";
    }
    
    /**
     * 사원조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum920skr_KOCIS.do" )
    public String s_hum920skr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));
        
//        List<Map<String, Object>> gsLicenseTab = s_hum920skrService_KOCIS.checkLicenseTab(param);		// 버스 재입사관리, 면허기타 Tab 사용여부
//        model.addAttribute("gsLicenseTab", ObjUtils.toJsonStr(gsLicenseTab));
        
        List<Map<String, Object>> gsOnlyHuman = s_hum920skrService_KOCIS.checkOnlyHuman(param);			// 급여/고정공제 tab 사용못하는 인사담당자 id 여부	
        model.addAttribute("gsOnlyHuman", ObjUtils.toJsonStr(gsOnlyHuman));
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum920skr_KOCIS";
    }
    
    /**
     * 학력사항
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum302ukr_KOCIS.do" )
    public String s_hum302ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum302ukr_KOCIS";
    }
    
    /**
     * 교육연수사항등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum304ukr_KOCIS.do" )
    public String s_hum304ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum304ukr_KOCIS";
    }
    
    /**
     * 어학자격관리
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum305ukr_KOCIS.do" )
    public String s_hum305ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum305ukr_KOCIS";
    }
    
    /**
     * 해외출장등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum306ukr_KOCIS.do" )
    public String s_hum306ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum306ukr_KOCIS";
    }
    
    /**
     * 휴직산재관리
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum307ukr_KOCIS.do" )
    public String s_hum307ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum307ukr_KOCIS";
    }
    
    /**
     * 상벌사항관리
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hum312ukr_KOCIS.do" )
    public String s_hum312ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));			// 사업명
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum312ukr_KOCIS";
    }
    
    /**
     * 재직/경력증명서 출력
     */
    @RequestMapping( value = "/z_kocis/s_hum970rkr_KOCIS.do" )
    public String s_hum970rkr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
        return JSP_PATH + "s_hum970rkr_KOCIS";
    }
    
    /**
     * 재직/경력증명서 출력 (공공)
     */
    @RequestMapping( value = "/z_kocis/s_hum975rkr_KOCIS.do" )
    public String s_hum975rkr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        //final String[] searchFields = {};
        //NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        //Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        return JSP_PATH + "s_hum975rkr_KOCIS";
    }
    
    @RequestMapping( value = "/z_kocis/s_hat200ukr_KOCIS.do" )
    public String s_hat200ukr_KOCIS( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hat520skrService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        return JSP_PATH + "s_hat200ukr_KOCIS";
    }
    
    @RequestMapping( value = "/z_kocis/s_hat200skr_KOCIS.do" )
    public String s_hat200skr_KOCIS( LoginVO loginVO, ModelMap model ) throws Exception {
        Gson gson = new Gson();
        String colData = gson.toJson(hat520skrService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        return JSP_PATH + "s_hat200skr_KOCIS";
    }
    
    @RequestMapping( value = "/z_kocis/s_hpa700ukr_KOCIS.do" )
    public String s_hpa700ukr_KOCIS() throws Exception {
        return JSP_PATH + "s_hpa700ukr_KOCIS";
    }
    
    @RequestMapping( value = "/z_kocis/s_hpa330ukr_KOCIS.do" )
    public String s_hpa330ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
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
        
        return JSP_PATH + "s_hpa330ukr_KOCIS";
    }
    
	/**
	 * Navi버튼 활성화를 결정
	 * @param param
	 * @param loginVO
	 * @return 현재 사원의 전후로 데이터가 있는지 확인
	 * @throws Exception
	 */
	@RequestMapping(value="/z_kocis/checkAvailableNaviHpa330.do")
	public ModelAndView checkAvailableNavi(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		List<Map<String, Object>> result = s_hpa330ukrService_KOCIS.checkAvailableNavi(param);
		return ViewHelper.getJsonView(result);
	}
	
	/**
	 * 저장이 가능한 상태인지 확인함 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_kocis/checkUpdateAvailableHpa330.do")
	public ModelAndView checkUpdateAvailable(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		List<Map<String, Object>> result = s_hpa330ukrService_KOCIS.checkAvailableNavi(param);
		String result = s_hpa330ukrService_KOCIS.checkUpdateAvailable(param);
		return ViewHelper.getJsonView(result);
	}
	
	/**
	 * 전월의 데이터를 복사함
	 * @param param
	 * @param loginVO
	 * @return 현재 사원의 전후로 데이터가 있는지 확인
	 * @throws Exception
	 */
	@RequestMapping(value="/z_kocis/copyPrevData.do")
	public ModelAndView copyPrevData(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
//		param.put("S_COMP_CODE", loginVO.getCompCode());
		List<Map<String, Object>> result = s_hpa330ukrService_KOCIS.selectList1ForCopy(param);
		List<Map<String, Object>> result1 = s_hpa330ukrService_KOCIS.selectList2ForCopy(param);
		List<Map<String, Object>> result2 = s_hpa330ukrService_KOCIS.selectList3ForCopy(param);
		
		Map resultMap  = new HashMap<String, List<Map<String, Object>>>();
		resultMap.put("result", result);
		resultMap.put("result1", result1);
		resultMap.put("result2", result2);
		return ViewHelper.getJsonView(resultMap);
	}    
    
        
    @RequestMapping( value = "/z_kocis/s_hpa340ukr_KOCIS.do" )
    public String s_hpa340ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
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
        
        return JSP_PATH + "s_hpa340ukr_KOCIS";
    }
    
    /**
     * 급여내역일괄조정(s_hpa350ukr_KOCIS)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hpa350ukr_KOCIS.do" )
    public String s_hpa350ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
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
        String colData = gson.toJson(s_hpa350ukrService_KOCIS.selectColumns(loginVO));
        model.addAttribute("colData", colData);
        return JSP_PATH + "s_hpa350ukr_KOCIS";
    }
    
    /* 개인급여 내역 조회(hpa950skr)
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/z_kocis/s_hpa950skr_KOCIS.do")
    public String hpa950skr(ExtHtttprequestParam _req,LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{

        //S_COMP_CODE 가져오기
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE",loginVO.getCompCode());

        Gson gson = new Gson();
        String colData = gson.toJson(s_hpa950skrService_KOCIS.selectColumns(param));
        model.addAttribute("colData", colData);

        //조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));

        List<Map<String, Object>> getCostPoolName = s_hpa950skrService_KOCIS.getCostPoolName(param);                
        model.addAttribute("getCostPoolName",ObjUtils.toJsonStr(getCostPoolName));

        return JSP_PATH + "s_hpa950skr_KOCIS";
    }
    
    /*
     * 급여집계 내역 조회(s_hpa955skr_KOCIS)
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_hpa955skr_KOCIS.do" )
    public String s_hpa955skr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        //S_COMP_CODE 가져오기
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        Gson gson = new Gson();
        String colData = gson.toJson(s_hpa955skrService_KOCIS.selectColumns(param));
        model.addAttribute("colData", colData);
        
        //조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));
        
        List<Map<String, Object>> getCostPoolName = s_hpa955skrService_KOCIS.getCostPoolName(param);
        model.addAttribute("getCostPoolName", ObjUtils.toJsonStr(getCostPoolName));
        
        return JSP_PATH + "s_hpa955skr_KOCIS";
    }
    
    @RequestMapping( value = "/z_kocis/s_hbs920ukr_KOCIS.do" )
    public String s_hbs920ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        
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
        
        /**
         * colData 구하기 - fnInitBinding에서 호출해서 세팅(콤보 값이 변수로 넘어가야 함) String colData = ""; try{ colData = hbs920ukrService.selectCloseyymm(loginVO.getCompCode()); }catch(NullPointerException e){ } model.addAttribute("colData", colData);
         */
        
        return JSP_PATH + "s_hbs920ukr_KOCIS";
    }
    
    @RequestMapping( value = "/z_kocis/s_hrt110ukr_KOCIS.do" )
    public String s_hrt110ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        //String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "s_hrt110ukr_KOCIS";
    }
    
    @RequestMapping( value = "/z_kocis/s_hrt506ukr_KOCIS.do" )
    public String s_hrt506ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        return JSP_PATH + "s_hrt506ukr_KOCIS";
    }
    
	/**
	 * 지급총액 계산
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_kocis/fnSuppTotI.do")
	public ModelAndView fnRetireProcSTChangedSuppTotal(@RequestParam Map<String, String> param, LoginVO loginVO) throws Exception {
		param.put("S_USER_ID", loginVO.getUserID());
		Map result = s_hrt506ukrService_KOCIS.fnSuppTotI(param);
		return ViewHelper.getJsonView(result);
	}
    
    @RequestMapping( value = "/z_kocis/s_hrt700skr_KOCIS.do" )
    public String s_hrt700skr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        //		final String[] searchFields = {  };
        //		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        //		LoginVO session = _req.getSession();
        //		Map<String, Object> param = navigator.getParam();
        //		String page = _req.getP("page");
        //		
        //		param.put("S_COMP_CODE",loginVO.getCompCode());
        //		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
        //		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
        //		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
        //		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "s_hrt700skr_KOCIS";
    }
    
    /**
     * 비정규직 사원등록
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @RequestMapping( value = "/z_kocis/s_ham100ukr_KOCIS.do" )
    public String s_ham100ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        CodeDetailVO cdo = codeInfo.getCodeInfo("H102", "01");
        if (!ObjUtils.isEmpty(cdo)) {
            if ("Y".equals(ObjUtils.getSafeString(cdo.getRefCode1()))) {
                model.addAttribute("autoNum", "true");	//Y:여신잔액(txtRemainCredit) visible
            } else {
                model.addAttribute("autoNum", "false");	//Y:여신잔액(txtRemainCredit) visible
            }
        }
        Map param = new HashMap();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        //        model.addAttribute("BussOfficeCode", hpa994ukrService.getBussOfficeCode(param));
        
        model.addAttribute("costPoolCombo", comboService.getHumanCostPool(param));
        
        return JSP_PATH + "s_ham100ukr_KOCIS";
    }
    
    /**
     * 계좌정보등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kocis/s_afs100ukr_KOCIS.do", method = RequestMethod.GET )
    public String s_afs100ukr_KOCIS( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
        model.addAttribute("COMBO_SAVE_CODE", comboService.fnGetSaveCode(param));//계좌코드 콤보
        
        return JSP_PATH + "s_afs100ukr_KOCIS";
    }
    
    /**
     * 계좌잔액 조회(KOCIS)
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kocis/s_afs100skr_KOCIS.do",method = RequestMethod.GET)
    public String s_afs100skr_KOCIS(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
    
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
            
        return JSP_PATH + "s_afs100skr_KOCIS";
    }
    /**
     * 계좌현황 조회(KOCIS)
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/z_kocis/s_afs200skr_KOCIS.do",method = RequestMethod.GET)
    public String s_afs200skr_KOCIS(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
    
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        model.addAttribute("COMBO_DEPT_KOCIS", comboService.fnGetDeptKocis(param));//기관 콤보
            
        return JSP_PATH + "s_afs200skr_KOCIS";
    }
    
    
    
    
    
    /**
     * 사진업로드 관련
     * 
     * @return
     * @throws Exception
     */
	@RequestMapping(value="/uploads/images/{imageID}")
	public ModelAndView viewImage (@PathVariable("imageID")  String imageID, ModelMap model, HttpServletRequest request) throws Exception{
		
		File photo = S_Controller_KOCIS.getImage("z_kocis", imageID);
		
		//사진이 읽을 수 없거나 존재하지 않는 경우,
		if(photo == null || !photo.canRead()) {
		    //String path = request.getServletContext().getRealPath("/resources/images/human/");
		    String path = request.getServletContext().getRealPath(ConfigUtil.getString("commom.upload.image.no_img"));
			logger.info("path :: " + path);
			photo = new File( path, "noPhoto.png");
		}

		logger.debug("imageID :{}, File = {} ", imageID, photo.toPath());
		return ViewHelper.getImageView(photo);
	}


	/**
	 * ImageID로 img파일 가져 오기
	 * @param imageID
	 * @return
	 */
	public static File getImage(String imagePath, String imageID) {
		String path = ConfigUtil.getUploadBasePath(imagePath);


		File photo = new File(path, imageID+".jpg");
		
		return photo;
	}
	
	//인사기본자료등록 사진가져오기
	@RequestMapping(value="/uploads/employeePhoto_1/{personNumb}")
	public ModelAndView viewPhoto_KOCIS(@PathVariable("personNumb")  String personNumb, ModelMap model, HttpServletRequest request)throws Exception{
		File photo = S_Controller_KOCIS.getImage("employeePhoto", personNumb);
		if(photo == null || !photo.canRead()) {
//			String url = "/resources/images/human/noPhoto.png";
//			return new ModelAndView("redirect:"+url);
			//String path = request.getServletContext().getRealPath("/resources/images/human/");
			String path = request.getServletContext().getRealPath(ConfigUtil.getString("commom.upload.image.no_img"));
			photo = new File( path, "noPhoto.png");
		}

		logger.debug("personNumb :{}, File = {} ", personNumb, photo.toPath());
		return ViewHelper.getImageView(photo);
	}
	
    @RequestMapping(value = "/z_kocis/s_hbs010ukr_KOCIS.do")
    public String hbs010ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        return JSP_PATH + "s_hbs010ukr_KOCIS";
    }
    
    @RequestMapping(value = "/z_kocis/s_hbs020ukr_KOCIS.do")
    public String hbs020ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        // 급호봉 등록 탭의 컬럼 정보를 내려 받음
        Gson gson = new Gson();
        String colDataTab11 = gson.toJson(hbs020ukrService.getColumnData(loginVO.getCompCode()));
        int sub_length = hbs020ukrService.getSUB_LENGTH(loginVO.getCompCode());
        param.put("S_COMP_CODE",loginVO.getCompCode());
        model.addAttribute("wagesCodeList", hbs020ukrService.getWagesCode(param));  //입/퇴사자지급기준등록 수당코드 list
        model.addAttribute("bonusTypeCodeList", hbs020ukrService.getBonusTypeCode(param));  //상여자지급기준 등록 상여구분 list
        model.addAttribute("colDataTab11", colDataTab11);
        model.addAttribute("sub_length", sub_length);
        model.addAttribute("paymCombo", comboService.getPayList(param));
        
        //급여관리기준등록 hbs020ukrs1 연차계산방식 기준 가져오기
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("H194", "", false);   //자국화폐단위 정보     
        for(CodeDetailVO map : gsMoneyUnit) {
            if("Y".equals(map.getRefCode1())){
                model.addAttribute("yearCalculation", map.getCodeNo());
            }            
        }
        return JSP_PATH + "s_hbs020ukr_KOCIS";
    }
    
    @RequestMapping(value="/z_kocis/hbs020ukr5_1.do")
    public String hbs020ukr5_1(LoginVO loginVO, ModelMap model)throws Exception{
        
        return JSP_PATH+"hbs020ukrs5_1";
    }	

}
