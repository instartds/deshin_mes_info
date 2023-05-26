package foren.unilite.modules.stock.qtr;

import java.util.ArrayList;
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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class QtrController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/stock/qtr/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@RequestMapping(value = "/stock/qtr100ukrv.do",method = RequestMethod.GET)
	public String qtr100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))   model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);		//화폐단위
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:입출고번호자동채번(txtOrderNum) lock,disable

		/*List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);	//수불처구분
		List<Map<String, Object>>  listInoutCodeType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsInoutCodeType)	{
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			listInoutCodeType.add(aMap);
		}
		model.addAttribute("gsInoutCodeType", listInoutCodeType);

		*/
		List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);		//수불처구분
		for(CodeDetailVO map : gsInoutCodeType)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInoutCodeType", map.getCodeNo());
			}
		}


		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준설정
		else if(ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN","N");

		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);		//BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsSumTypeCell","N");
		
		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
        if(!ObjUtils.isEmpty(inoutPrsn))    model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		List<CodeDetailVO> gsOutDetailType = codeInfo.getCodeList("M104", "", false);	//
		List<Map<String, Object>>  listOutDetailType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOutDetailType)	{
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("GOOD_BAD", map.getRefCode4());
			listOutDetailType.add(aMap);
		}
		model.addAttribute("gsOutDetailType", listOutDetailType);


		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCheckStockYn",cdo.getRefCode1());	//재고상태관리
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsCheckStockYn","+");

		return JSP_PATH + "qtr100ukrv";
	}




}
