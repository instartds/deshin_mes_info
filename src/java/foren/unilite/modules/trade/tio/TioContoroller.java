package foren.unilite.modules.trade.tio;

import java.util.HashMap;
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
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class TioContoroller extends UniliteCommonController {
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="tio100ukrvService")
	private Tio100ukrvServiceImpl tio100ukrvService;

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/trade/tio/";

	@RequestMapping(value = "/trade/tio110skrv.do")
	public String tio110skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "tio110skrv";
	}
	@RequestMapping(value = "/trade/tio100ukrv.do")
	public String tio100ukrv(ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		//DefaultMoney
		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}
		// AutoNumber
		CodeDetailVO cdo = codeInfo.getCodeInfo("T100", "10");
		if(!ObjUtils.isEmpty(cdo)){
			String refCodeString = cdo.getRefCode1();
			if(!ObjUtils.isEmpty(refCodeString)){
				refCodeString = refCodeString.toUpperCase();
			}
			model.addAttribute("gsAutoNumber",refCodeString);
		}
		//批准与否的设置
		List<CodeDetailVO> gsOrderYn = codeInfo.getCodeList("T080", "", false);
		for(CodeDetailVO map : gsOrderYn)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsOrderYn", map.getCodeNo());
			}
		}
		//rsManageLotNo
		CodeDetailVO cdoLotNo = codeInfo.getCodeInfo("B090", "TA");
		if(!ObjUtils.isEmpty(cdoLotNo)){
			model.addAttribute("MNG_LOT",cdoLotNo.getRefCode1());
			model.addAttribute("ESS_YN",cdoLotNo.getRefCode2());
			model.addAttribute("ESS_ACCOUNT",cdoLotNo.getRefCode3());
		}

		//발주승인단계 사용 유무 1:사용 2: 미사용
        List<CodeDetailVO> gsOrderConfirm = codeInfo.getCodeList("T080", "", false);     //수입오퍼승인방식
        for(CodeDetailVO map : gsOrderConfirm)   {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsOrderConfirm", map.getCodeNo());
            }
        }

        List<CodeDetailVO> agreePrsn = codeInfo.getCodeList("M201", "", false);   //구매담당 정보 조회
        model.addAttribute("agreePrsn", "");
        for(CodeDetailVO map : agreePrsn) {
            if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode4())) {
                model.addAttribute("agreePrsn", map.getRefCode1());
                model.addAttribute("importPrsn", map.getCodeNo());
            }
        }

        CodeDetailVO cdoGwFlag = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
        if(!ObjUtils.isEmpty(cdoGwFlag)) model.addAttribute("groupUrl", cdoGwFlag.getCodeName());


		//수입환산금액 원미만계산
        List<CodeDetailVO> gsTradeCalcMethod = codeInfo.getCodeList("T125", "", false);
        for(CodeDetailVO map : gsTradeCalcMethod)   {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsTradeCalcMethod", map.getCodeNo());
            }
        }


		return JSP_PATH + "tio100ukrv";
	}
}

