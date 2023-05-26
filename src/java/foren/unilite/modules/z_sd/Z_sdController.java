package foren.unilite.modules.z_sd;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;
import foren.unilite.modules.human.hpa.Hpa950skrServiceImpl;

@Controller
public class Z_sdController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_sd/";
	
	@Resource(name="UniliteComboServiceImpl")
    private ComboServiceImpl comboService;
	
	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

    @Resource( name = "hpa950skrService" )
    private Hpa950skrServiceImpl hpa950skrService;

    @Resource( name = "s_hum920skr_sdcService" )
    private S_Hum920skr_sdcServiceImpl s_hum920skr_sdcService;

    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
    
	
	
	
	/**
	 * 퇴직급여내역조회(sd)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sd/s_hrt705skr_sd.do",method = RequestMethod.GET)
	public String s_hrt705skr_sd(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		return JSP_PATH + "s_hrt705skr_sd";
	}
	   
    
    /**
     * add By Chen.Rd
     * 지급대장
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_sd/s_hpa901rkr_sd.do" )
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

        return JSP_PATH + "s_hpa901rkr_sd";
    }
    
    /**
     *  경력증명서 출력
     */
    @RequestMapping( value = "/z_sd/s_hum970rkr_sd.do" )
    public String s_hum970rkr_sd( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        return JSP_PATH + "s_hum970rkr_sd";
    }

    /**
     *  급여계산
     */
    @RequestMapping( value = "/z_sd/s_hpa340ukr_sdc.do" )
    public String s_hpa340ukr_sdc( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
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

        return JSP_PATH + "s_hpa340ukr_sdc";
    }

    /**
     * add By Chen.Rd
     * 지급대장
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_sd/s_hpa902rkr_sdc.do" )
    public String s_hpa902rkr_sdc( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        //Gson gson = new Gson();
        //String colData = gson.toJson(hpa950skrService.selectColumns(loginVO));
        //model.addAttribute("colData", colData);

        //S_COMP_CODE 가져오기
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));

        //List<Map<String, Object>> getCostPoolName = hpa950skrService.getCostPoolName(param);
        //model.addAttribute("getCostPoolName", ObjUtils.toJsonStr(getCostPoolName));

        return JSP_PATH + "s_hpa902rkr_sdc";
    }

    /**
     * add By Chen.Rd
     * 지급대장
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_sd/s_hum990skr_sdc.do" )
    public String s_hum990skr_sdc( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "s_hum990skr_sdc";
    }

    /**
     * 정원및현원관리
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_sd/s_hum991ukr_sdc.do" )
    public String s_hum991ukr_sdc( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "s_hum991ukr_sdc";
    }

    /**
     * 사원조회(S)
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_sd/s_hum920skr_sdc.do" )
    public String s_hum920skr_sdc( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));
        
        List<Map<String, Object>> gsLicenseTab = s_hum920skr_sdcService.checkLicenseTab(param);		// 버스 재입사관리, 면허기타 Tab 사용여부
        model.addAttribute("gsLicenseTab", ObjUtils.toJsonStr(gsLicenseTab));
        
        List<Map<String, Object>> gsOnlyHuman = s_hum920skr_sdcService.checkOnlyHuman(param);			// 급여/고정공제 tab 사용못하는 인사담당자 id 여부	
        model.addAttribute("gsOnlyHuman", ObjUtils.toJsonStr(gsOnlyHuman));
        
        model.addAttribute("CostPool", humanCommonService.getCostPool(param));					// H175 subCode 10의 Y/N Check
        
        return JSP_PATH + "s_hum920skr_sdc";
    }
    
    @RequestMapping( value = "/z_sd/s_hbs211ukr_sdc.do", method = RequestMethod.GET )
    public String bcm200ukrv() throws Exception {
        return JSP_PATH + "s_hbs211ukr_sdc";
    }
    
}
