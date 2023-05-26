
package foren.unilite.modules.accnt.ass;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.accnt.aba.Aba410ukrServiceImpl;
import foren.unilite.modules.accnt.ass.Ass100ukrServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;


/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AssController extends UniliteCommonController {
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@Resource(name="ass100ukrService")
	private Ass100ukrServiceImpl ass100ukrService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/ass/";
	
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	
	/**
	 * 고정자산대장조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/ass600skr.do")
	public String ass600skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");	
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH + "ass600skr";
	}
	/**
	 * add by zhongshl
	 * 고정자산대장조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/ass600rkr.do")
	public String ass600rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");	
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH + "ass600rkr";
	}
	/**
	 * 자산변동내역조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/ass700skr.do")
	public String ass700skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");	
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
				
		
		return JSP_PATH + "ass700skr";
	}
	@RequestMapping(value="/accnt/ass300ukr.do")
	public String ass300ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("costPoolCombo", comboService.getHumanCostPool(param));
		
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}	
		
		List<Map<String, Object>> getAccntBasicInfo = accntCommonService.fnGetAccntBasicInfo(param, loginVO);		// AMT_POINT 관련			
		if(ObjUtils.isNotEmpty(getAccntBasicInfo)) {
			model.addAttribute("getAccntBasicInfo",getAccntBasicInfo.get(0).get("AMT_POINT"));
		} else {
			model.addAttribute("getAccntBasicInfo", "");
		}
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		cdo = codeInfo.getCodeInfo("A151", "1");	//자산코드 자동채번(Y)/수동채번(N)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}
		
		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보		
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}			 
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");
		
		return JSP_PATH+"ass300ukr";
	}
	
	@RequestMapping(value="/accnt/ass310ukr.do")
	public String ass310ukr(	)throws Exception{
		return JSP_PATH+"ass310ukr";
	}
	
	@RequestMapping(value="/accnt/ass500ukr.do")
	public String ass500ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}		
		return JSP_PATH+"ass500ukr";
	}
	/**
	 * 고정자산기본정보등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/ass100ukr.do",method = RequestMethod.GET)
	public String ass100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
	
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		List<Map<String, Object>> getRefSubCode = ass100ukrService.sAutoNoYN_sGapBase(param);		// 자동채번유무 & 회계기준사용(1:K-GAAP, 2:K-IFRS)	
		model.addAttribute("getRefSubCode",ObjUtils.toJsonStr(getRefSubCode));	
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		
		
		return JSP_PATH + "ass100ukr";
	}
	
}
