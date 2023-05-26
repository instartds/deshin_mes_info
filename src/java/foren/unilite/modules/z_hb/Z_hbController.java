package foren.unilite.modules.z_hb;

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
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class Z_hbController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_hb/";
	public final static String FILE_TYPE_OF_PHOTO = "stampPhoto";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@RequestMapping(value = "/z_hb/s_mpo502ukrv_hb.do",method = RequestMethod.GET)
	public String s_mpo502ukrv_hb(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("mpo502ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		List<CodeDetailVO> gsOrderPrsn = codeInfo.getCodeList("M201", "", false);	//구매담당 정보 조회
		model.addAttribute("gsOrderPrsn", "");
		model.addAttribute("gsOrderPrsnYN", "N");
		for(CodeDetailVO map : gsOrderPrsn)	{

			if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode4())) 	{
				model.addAttribute("gsOrderPrsn", map.getCodeNo());
				model.addAttribute("gsOrderPrsnYN", "Y");
			}
		}

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//화폐단위(기본화폐단위설정
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsApproveYN = codeInfo.getCodeList("M008", "", false);		//발주승인 방식
		for(CodeDetailVO map : gsApproveYN)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsApproveYN", map.getCodeNo());
				model.addAttribute("gsM008Ref3", map.getRefCode3());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());   //재고합산유형:Lot No. 합산

		cdo = codeInfo.getCodeInfo("M101", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

		List<CodeDetailVO> gsCusomItemYn = codeInfo.getCodeList("B911", "", false);		//품목팝업 거래처단가에 등록된 것만 가져오도록 설정 여부
		for(CodeDetailVO map : gsCusomItemYn)	{
			if("s_mpo502ukrv_hb".equals(map.getCodeName()))	{
				model.addAttribute("gsCusomItemYn", map.getRefCode1());
			}
		}

		return JSP_PATH + "s_mpo502ukrv_hb";
	}

	@RequestMapping(value = "/z_hb/s_sof130rkrv_hb.do")
	public String s_sof130rkrv_hb(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsLabelCustom = codeInfo.getCodeList("S105", "", false);		//라벨거래처
		for(CodeDetailVO map : gsLabelCustom)	{
			if("Y".equals(map.getRefCode2()))	{
				model.addAttribute("gsLabelCustomCode", map.getRefCode1());
				model.addAttribute("gsLabelCustomName", map.getCodeName());
			}
		}

		return JSP_PATH + "s_sof130rkrv_hb";
	}

	/**
	 * 근태일괄등록(S)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_hb/s_hat900ukr_hb.do",method = RequestMethod.GET)
	public String s_hat900ukr_hb(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
		
		return JSP_PATH + "s_hat900ukr_hb";
	}


}
