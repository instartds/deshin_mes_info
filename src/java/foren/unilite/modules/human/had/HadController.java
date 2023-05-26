package foren.unilite.modules.human.had;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;
import foren.unilite.com.tags.ComboItemModel;

@Controller
public class HadController extends UniliteCommonController {
    
    private final Logger         logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String          JSP_PATH = "/human/had/";
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl     comboService;
    
    @Resource( name = "had616ukrService" )
    private Had616ukrServiceImpl had616ukrService;
    
    @Resource( name = "had617ukrService" )
    private Had617ukrServiceImpl had617ukrService;
    
    @Resource( name = "had618ukrService" )
    private Had618ukrServiceImpl had618ukrService;

    @Resource( name = "had619ukrService" )
    private Had619ukrServiceImpl had619ukrService;

    @Resource( name = "had620ukrService" )
    private Had620ukrServiceImpl had620ukrService;
    
    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
    
    @Resource( name = "had820ukrService" )
    private Had820ukrServiceImpl had820ukrService;
    
    @RequestMapping( value = "/human/had880skr.do" )
    public String had880skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "had880skr";
    }
    
    @RequestMapping( value = "/human/had890ukr.do" )
    public String had890ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "had890ukr";
    }
    
    @RequestMapping( value = "/human/had810skr.do" )
    public String had810skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "had810skr";
    }
    
    @RequestMapping( value = "/human/had421skr.do" )
    public String had421skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        return JSP_PATH + "had421skr";
    }
    
    @RequestMapping( value = "/human/had421rkr.do" )
    public String had421rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        return JSP_PATH + "had421rkr";
    }
    
    @RequestMapping( value = "/human/had860skr.do" )
    public String had860skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        return JSP_PATH + "had860skr";
    }
    
    @RequestMapping( value = "/human/had800skr.do" )
    public String had800skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "had800skr";
    }
    
    @RequestMapping( value = "/human/had200ukr.do" )
    public String had200ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "had200ukr";
    }
    
    @RequestMapping( value = "/human/had210ukr.do" )
    public String had210ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "had210ukr";
    }
    
    @RequestMapping( value = "/human/had612ukr.do" )
    public String had612ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
        
        return JSP_PATH + "had612ukr";
    }
    
    @RequestMapping( value = "/human/had616ukr.do" )
    public String had616ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        //Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        Map param = new HashMap();
        String year = "2016";
        
        param.put("YEAR_YYYY", year);
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        model.addAttribute("YEAR_YYYY", year);
        Map authMap = (Map)had616ukrService.selectAuth(param);
        model.addAttribute("AUTH_YN", ObjUtils.isNotEmpty(authMap) ? authMap.get("AUTH_YN") : "N");
        model.addAttribute("USE_AUTH", ObjUtils.isNotEmpty(authMap) ? authMap.get("USE_AUTH") : "N");
        model.addAttribute("PERSON_NUMB", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NUMB") : loginVO.getPersonNumb());
        
        List<ComboItemModel> relCode = comboService.getComboList("AU", "H117", loginVO, null, null, false);
        
        ComboItemModel self = new ComboItemModel();
        self.setText("(본인)");
        self.setValue("0");
        self.setSearch("0본인");
        relCode.add(0, self);
        
        model.addAttribute("relCode", relCode);
        
        return JSP_PATH + "had616ukr";
    }
    
    @RequestMapping( value = "/human/had617ukr.do" )
    public String had617ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Map param = new HashMap();
        String year = "2017";
        param.put("YEAR_YYYY", year);
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        model.addAttribute("YEAR_YYYY", year);
        Map authMap = (Map)had617ukrService.selectAuth(param);
        model.addAttribute("AUTH_YN", ObjUtils.isNotEmpty(authMap) ? authMap.get("AUTH_YN") : "N");
        model.addAttribute("USE_AUTH", ObjUtils.isNotEmpty(authMap) ? authMap.get("USE_AUTH") : "N");
        model.addAttribute("PERSON_NUMB", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NUMB") : loginVO.getPersonNumb());
        model.addAttribute("PERSON_NAME", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NAME") : loginVO.getUserName());

        List<ComboItemModel> relCode = comboService.getComboList("AU", "H117", loginVO, null, null, false);
        
        ComboItemModel self = new ComboItemModel();
        self.setText("(본인)");
        self.setValue("0");
        self.setSearch("0본인");
        relCode.add(0, self);
        
        model.addAttribute("relCode", relCode);
        
        return JSP_PATH + "had617ukr";
    }
    
    @RequestMapping( value = "/human/had618ukr.do" )
    public String had618ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Map param = new HashMap();
        String year = "2018";
        param.put("YEAR_YYYY", year);
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        model.addAttribute("YEAR_YYYY", year);
        Map authMap = (Map)had618ukrService.selectAuth(param);
        model.addAttribute("AUTH_YN", ObjUtils.isNotEmpty(authMap) ? authMap.get("AUTH_YN") : "N");
        model.addAttribute("USE_AUTH", ObjUtils.isNotEmpty(authMap) ? authMap.get("USE_AUTH") : "N");
        model.addAttribute("PERSON_NUMB", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NUMB") : loginVO.getPersonNumb());
        model.addAttribute("PERSON_NAME", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NAME") : loginVO.getUserName());

        List<ComboItemModel> relCode = comboService.getComboList("AU", "H117", loginVO, null, null, false);
        
        ComboItemModel self = new ComboItemModel();
        self.setText("(본인)");
        self.setValue("0");
        self.setSearch("0본인");
        relCode.add(0, self);
        
        model.addAttribute("relCode", relCode);
        
        return JSP_PATH + "had618ukr";
    }
    
    @RequestMapping( value = "/human/had619ukr.do" )
    public String had619ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Map param = new HashMap();
        String year = "2019";
        param.put("YEAR_YYYY", year);
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        model.addAttribute("YEAR_YYYY", year);
        Map authMap = (Map)had619ukrService.selectAuth(param);
        model.addAttribute("AUTH_YN", ObjUtils.isNotEmpty(authMap) ? authMap.get("AUTH_YN") : "N");
        model.addAttribute("USE_AUTH", ObjUtils.isNotEmpty(authMap) ? authMap.get("USE_AUTH") : "N");
        model.addAttribute("PERSON_NUMB", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NUMB") : loginVO.getPersonNumb());
        model.addAttribute("PERSON_NAME", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NAME") : loginVO.getUserName());

        List<ComboItemModel> relCode = comboService.getComboList("AU", "H117", loginVO, null, null, false);
        
        ComboItemModel self = new ComboItemModel();
        self.setText("(본인)");
        self.setValue("0");
        self.setSearch("0본인");
        relCode.add(0, self);
        
        model.addAttribute("relCode", relCode);
        
        return JSP_PATH + "had619ukr";
    }

    @RequestMapping( value = "/human/had620ukr.do" )
    public String had620ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Map param = new HashMap();
        String year = "2020";
        param.put("YEAR_YYYY", year);
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        model.addAttribute("YEAR_YYYY", year);
        Map authMap = (Map)had620ukrService.selectAuth(param);
        model.addAttribute("AUTH_YN", ObjUtils.isNotEmpty(authMap) ? authMap.get("AUTH_YN") : "N");
        model.addAttribute("USE_AUTH", ObjUtils.isNotEmpty(authMap) ? authMap.get("USE_AUTH") : "N");
        model.addAttribute("PERSON_NUMB", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NUMB") : loginVO.getPersonNumb());
        model.addAttribute("PERSON_NAME", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NAME") : loginVO.getUserName());

        List<ComboItemModel> relCode = comboService.getComboList("AU", "H117", loginVO, null, null, false);
        
        ComboItemModel self = new ComboItemModel();
        self.setText("(본인)");
        self.setValue("0");
        self.setSearch("0본인");
        relCode.add(0, self);
        
        model.addAttribute("relCode", relCode);
        
        return JSP_PATH + "had620ukr";
    }

    @RequestMapping( value = "/human/had621ukr.do" )
    public String had621ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        Map param = new HashMap();
        String year = "2021";
        param.put("YEAR_YYYY", year);
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        model.addAttribute("YEAR_YYYY", year);
        Map authMap = (Map)had620ukrService.selectAuth(param);
        model.addAttribute("AUTH_YN", ObjUtils.isNotEmpty(authMap) ? authMap.get("AUTH_YN") : "N");
        model.addAttribute("USE_AUTH", ObjUtils.isNotEmpty(authMap) ? authMap.get("USE_AUTH") : "N");
        model.addAttribute("PERSON_NUMB", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NUMB") : loginVO.getPersonNumb());
        model.addAttribute("PERSON_NAME", ObjUtils.isNotEmpty(authMap) ? authMap.get("PERSON_NAME") : loginVO.getUserName());

        List<ComboItemModel> relCode = comboService.getComboList("AU", "H117", loginVO, null, null, false);
        
        ComboItemModel self = new ComboItemModel();
        self.setText("(본인)");
        self.setValue("0");
        self.setSearch("0본인");
        relCode.add(0, self);
        
        model.addAttribute("relCode", relCode);
        
        return JSP_PATH + "had621ukr";
    }
    
    @RequestMapping( value = "/human/had605ukr.do" )
    public String had605ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        Map sparam = new HashMap();
        
        sparam.put("S_COMP_CODE", loginVO.getCompCode());
        sparam.put("S_USER_ID", loginVO.getUserID());
        Map fnGetTaxAdjustmentYear = humanCommonService.fnGetAdjustmentStdDate(sparam);
        model.addAttribute("taxAdjustmentYear", fnGetTaxAdjustmentYear.get("SYS_YEAR"));

        return JSP_PATH + "had605ukr";
    }
    
    @RequestMapping( value = "/human/had700ukr.do" )
    public String had700ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        return JSP_PATH + "had700ukr";
    }
    @RequestMapping( value = "/human/had820ukr.do" )
    public String had820ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        
        List<CodeDetailVO> adjustmentStdDate = codeInfo.getCodeList("H154", "", false);	
        for (CodeDetailVO map : adjustmentStdDate) {
            if ("Y".equals(map.getRefCode1())) {
                model.addAttribute("stdDate", map.getCodeName());
            }
        }
        Map param = _req.getParameterMap();
        Map billDivMap = had820ukrService.getBillDiv(param);
        if(billDivMap != null)	{
        	model.addAttribute("billDivCode", billDivMap.get("BILL_DIV_CODE"));
        } else {
        	model.addAttribute("billDivCode", "");
        }
        return JSP_PATH + "had820ukr";
    }
    
    @RequestMapping(value="/human/buildTaxSumitTxt", method = RequestMethod.POST)
	public  ModelAndView buildTaxSumitTxt( ExtHtttprequestParam _req, LoginVO user) throws Exception {
		Map param = _req.getParameterMap();
		FileDownloadInfo fInfo = null;
		String dataFlag = ObjUtils.getSafeString(param.get("DATA_FLAG"));
		Integer calYear = Integer.parseInt(ObjUtils.getSafeString(param.get("CAL_YEAR")));
		
		//	연말정산 신고자료 생성 로직
		//	2019년도 귀속 연말정산까지는 SELECT한 데이터를 자바소스에서 컬럼별로 사이즈에 맞추어 작성했으나
		//	2020년도 이후는 USP_HUMAN_HAD820UKR 프로시져에서 내용 작성된 채로 SELECT 함.
		if (calYear <= 2019) {
			if("optMedical".equals(dataFlag))	{
				fInfo = had820ukrService.doMedicalBatch(param);
				logger.debug("download File Info : " + fInfo.getPath());
			}
			if("optWorkPay".equals(dataFlag))	{
				fInfo = had820ukrService.doBatch(param);
				logger.debug("download File Info : " + fInfo.getPath());
			}
		}
		else {
			if("optMedical".equals(dataFlag)) {
				param.put("BATCH_TYPE", "M");
			}
			else {
				param.put("BATCH_TYPE", "W");
			}
			fInfo = had820ukrService.doBatch2020(param, user);
		}
		
		return ViewHelper.getFileDownloadView(fInfo);
	}
    
    @RequestMapping( value = "/human/had830ukr.do" )
    public String had830ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "had830ukr";
    }
    
    /**
     * add Chen.Rd
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/had840rkr.do" )
    public String had840rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "had840rkr";
    }
    
    /**
     * add Chen.Rd
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/had850rkr.do" )
    public String had850rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "had850rkr";
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/had900rkr.do" )
    public String had900rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "had900rkr";
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/had910rkr.do" )
    public String had910rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "had910rkr";
    }
    
    @RequestMapping( value = "/human/hadpdfupload.do" )
    public String hadpdfupload( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "hadpdfupload";
    }
    
    @RequestMapping( value = "/human/had950ukr.do" )
    public String had950ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        return JSP_PATH + "had950ukr";
    }
}