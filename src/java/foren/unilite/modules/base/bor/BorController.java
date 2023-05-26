package foren.unilite.modules.base.bor;

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

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

/**
 *    프로그램명 : 통합문서 관리
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class BorController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/base/bor/";
	
	@Resource(name="accntCommonService")
    private AccntCommonServiceImpl accntCommonService;
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	/**
	 * 회사정보 등록 jsp controller
	 * @param login
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/base/bor100ukrv.do",method = RequestMethod.GET)
	public String bor100ukrv(LoginVO login, ModelMap model	) throws Exception{	
		return JSP_PATH+"bor100ukrv";
	}
	
	/** 회사정보등록 (bor101ukrv)
	 * 
	 * 대상테이블 변경 (bsa100t -> bsa100g) && table replication
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/base/bor101ukrv.do",method = RequestMethod.GET)
	public String bor101ukrv(LoginVO login, ModelMap model	) throws Exception{	
		return JSP_PATH + "bor101ukrv";
	}	
	
	/**
	 * 사업장정보 등록 jsp controller

	 * @param login
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/base/bor120ukrv.do",method = RequestMethod.GET)
	public String bor120ukrv(LoginVO login, ModelMap model	) throws Exception{	
		return JSP_PATH+"bor120ukrv";
	}	

	/**
	 * 부서관리 jsp controller

	 * @param login
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/base/bor130ukrv.do",method = RequestMethod.GET)
	public String bor130ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
        param.put("PGM_ID", "bor130ukrv");
        param.put("SHEET_ID", "bor130ukrvGrid");
        List<Map<String, Object>> useColList = accntCommonService.getUseColList(param);     //프로그램별 사용 컬럼 관련            
        model.addAttribute("useColList",ObjUtils.toJsonStr(useColList));    
		
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		return JSP_PATH+"bor130ukrv";
	}	
	
	/**
	 * 법인등록

	 * @param login
	 * @param model
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "/base/bor140ukrv.do")
	public String bor140ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");		
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		Gson gson = new Gson();
		//String deptData = gson.toJson(bor140ukrvService.userDept(loginVO));
		//model.addAttribute("deptData", deptData);
		
		return JSP_PATH + "bor140ukrv";
	}	
	
	/**
     * 인사/재무 부서코드 매핑

     * @param login
     * @param model
     * @return
     * @throws Exception
     */ 
    @RequestMapping(value = "/base/bor150ukrv.do")
    public String bor150ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        return JSP_PATH + "bor150ukrv";
    }
	
}
