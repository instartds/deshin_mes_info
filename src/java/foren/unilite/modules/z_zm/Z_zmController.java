package foren.unilite.modules.z_zm;

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

@Controller
public class Z_zmController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_zm/";
	
	@Resource(name="UniliteComboServiceImpl")
    private ComboServiceImpl comboService;
	
	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;
	
	@RequestMapping(value = "/z_zm/s_bpr101ukrv_zm.do", method = RequestMethod.GET)
	public String s_bpr101ukrv_zm(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;	
		
		cdo = codeInfo.getCodeInfo("S242", "1");	//품목코드, 바코드 동기화 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsItemCodeSyncYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsItemCodeSyncYN", "N");
		}
		List<CodeDetailVO> binNumList = codeInfo.getCodeList("YP02", "", false);
		Object numList= "";
		for(CodeDetailVO map : binNumList)	{
			if("1".equals(map.getRefCode2()))	{
				if(numList.equals("")){
				numList =  map.getCodeNo();
				}else{
					numList = numList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("binNumList", numList);
		
		List<CodeDetailVO> itemAccount = codeInfo.getCodeList("B020", "", false);
		Object accountList= "";
		for(CodeDetailVO map : itemAccount)	{
			if("1".equals(map.getRefCode4()))	{
				if(accountList.equals("")){
				accountList =  map.getCodeNo();
				}else{
					accountList = accountList + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("itemAccount", accountList);
		return JSP_PATH + "s_bpr101ukrv_zm";
	}
	
	@RequestMapping(value = "/z_zm/s_bcm104ukrv_zm.do", method = RequestMethod.GET)
	public String bcm104ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
 		
		
		List<CodeDetailVO> cdList = codeInfo.getCodeList("B015");
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsCustomType",ObjUtils.toJsonStr(cdList));//거래처구분
		return JSP_PATH + "s_bcm104ukrv_zm";
	}

}
