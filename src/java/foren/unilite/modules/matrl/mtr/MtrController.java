package foren.unilite.modules.matrl.mtr;

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
public class MtrController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/matrl/mtr/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@RequestMapping(value = "/matrl/mtr110skrv.do")
	public String mtr110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//구매담당 정보 조회
		model.addAttribute("gsInOutPrsn", "");
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getUserID().equals(map.getRefCode2())) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}

		//20200519 추가: 레포트 관련 데이터 조회  , 20200521 사용 안 함 -> 신규프로그램으로 대체
/*		List<CodeDetailVO> gsPrintInfo = codeInfo.getCodeList("M030", "", false);
		model.addAttribute("gsPrintInfo", "");
		for(CodeDetailVO map : gsPrintInfo) {
			if("mtr110skrv".equals(map.getCodeName())) {
				model.addAttribute("gsPrintUrl"	, ObjUtils.getSafeString(map.getRefCode8()));
				model.addAttribute("gsPrintPath", ObjUtils.getSafeString(map.getRefCode9()));
			}
		}*/
		
		List<CodeDetailVO> gaItemAccnt = codeInfo.getCodeList("B020", "", false);		//품목계정
		String gsItemAccnt = "";
		for(CodeDetailVO map : gaItemAccnt)	{
			if(!"10".equals(ObjUtils.nvl(map.getRefCode3(), "")) && !"20".equals(ObjUtils.nvl(map.getRefCode3(), ""))) {
				if(gsItemAccnt.length() < 1) {
					gsItemAccnt = map.getCodeNo().toString();
				}
				else {
					gsItemAccnt += "," + map.getCodeNo().toString();
				}
			}
		}
		model.addAttribute("gsItemAccnt", gsItemAccnt);

		return JSP_PATH + "mtr110skrv";
	}

	@RequestMapping(value = "/matrl/mtr114skrv.do")
	public String mtr114skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//구매담당 정보 조회
		model.addAttribute("gsInOutPrsn", "");
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getUserID().equals(map.getRefCode2())) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "mtr114skrv";
	}
	
	@RequestMapping(value = "/matrl/mtr111skrv.do")
	public String mtr111skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//구매담당 정보 조회
		model.addAttribute("gsInOutPrsn", "");
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode1())) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "mtr111skrv";
	}

	@RequestMapping(value = "/matrl/mtr112skrv.do")
	public String mtr112skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//구매담당 정보 조회
		model.addAttribute("gsInOutPrsn", "");
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode1())) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "mtr112skrv";
	}

	@RequestMapping(value = "/matrl/mtr113skrv.do")
	public String mtr113skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//구매담당 정보 조회
		model.addAttribute("gsInOutPrsn", "");
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode1())) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "mtr113skrv";
	}

	@RequestMapping(value = "/matrl/mtr130rkrv.do")
	public String mtr130rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//援щℓ?대떦 ?뺣낫 議고쉶
		model.addAttribute("gsInOutPrsn", "");
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getUserID().equals(map.getRefCode2())) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "mtr130rkrv";
	}

	@RequestMapping(value = "/matrl/mtr170rkrv.do")
	public String mtr170rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "mtr170rkrv";
	}

	@RequestMapping(value = "/matrl/mtr250skrv.do")
	public String mtr250skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "mtr250skrv";
	}

	@RequestMapping(value = "/matrl/mtr150skrv.do")
	public String mtr150skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "mtr150skrv";
	}

	@RequestMapping(value = "/matrl/mtr270skrv.do")
	public String mtr270skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "mtr270skrv";
	}

	@RequestMapping(value = "/matrl/mtr201ukrv.do",method = RequestMethod.GET)
	public String mtr201ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))   model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	   //화폐단위
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:의뢰번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);   //수불처구분
		List<Map<String, Object>>  listInoutCodeType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsInoutCodeType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			listInoutCodeType.add(aMap);
		}
		model.addAttribute("gsInoutCodeType", listInoutCodeType);

		cdo = codeInfo.getCodeInfo("B090", "MA");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준설정
		else if(ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN","N");

		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);	   //BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());  //재고합산유형
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsSumTypeCell","N");

		List<CodeDetailVO> gsOutDetailType = codeInfo.getCodeList("M104", "", false);   //
		List<Map<String, Object>>  listOutDetailType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOutDetailType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("GOOD_BAD", map.getRefCode4());
			listOutDetailType.add(aMap);
		}
		model.addAttribute("gsOutDetailType", listOutDetailType);

		return JSP_PATH + "mtr201ukrv";
	}

	/**
	 * 출고등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mtr200ukrp1v.do",method = RequestMethod.GET)
	public String mtr200ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "mtr200ukrp1v";
	}

	@RequestMapping(value = "/matrl/mtr200ukrv.do",method = RequestMethod.GET)
	public String mtr200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:입출고번호자동채번(txtOrderNum) lock,disable

		/*List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);	//수불처구분
		List<Map<String, Object>>  listInoutCodeType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsInoutCodeType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			listInoutCodeType.add(aMap);
		}
		model.addAttribute("gsInoutCodeType", listInoutCodeType);

		*/
		List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);		//수불처구분
		for(CodeDetailVO map : gsInoutCodeType) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsInoutCodeType", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준설정
		else if(ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN","N");

		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);		//BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsSumTypeCell","N");

		List<CodeDetailVO> gsOutDetailType = codeInfo.getCodeList("M104", "", false);	//
		List<Map<String, Object>>  listOutDetailType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOutDetailType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("GOOD_BAD", map.getRefCode4());
			listOutDetailType.add(aMap);
		}
		model.addAttribute("gsOutDetailType", listOutDetailType);

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCheckStockYn",cdo.getRefCode1());	//재고상태관리
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsCheckStockYn","+");

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("mtr202ukrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "mtr200ukrv";
	}

	/**
	 * 기타출고등록(LOT)
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mtr210ukrv.do",method = RequestMethod.GET)
	public String mtr210ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:입출고번호자동채번(txtOrderNum) lock,disable

		List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);		//수불처구분
		for(CodeDetailVO map : gsInoutCodeType) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsInoutCodeType", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준설정
		else if(ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN","N");

		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);		//BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsSumTypeCell","N");

		List<CodeDetailVO> gsOutDetailType = codeInfo.getCodeList("M104", "", false);	//
		List<Map<String, Object>>  listOutDetailType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOutDetailType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("GOOD_BAD", map.getRefCode4());
			listOutDetailType.add(aMap);
		}
		model.addAttribute("gsOutDetailType", listOutDetailType);

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCheckStockYn",cdo.getRefCode1());	//재고상태관리
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsCheckStockYn","+");

		return JSP_PATH + "mtr210ukrv";
	}

	/**
	 * 자재출고등록(바코드)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mtr202ukrv.do",method = RequestMethod.GET)
	public String mtr202ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:입출고번호자동채번(txtOrderNum) lock,disable

		List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);	//수불처구분
		List<Map<String, Object>>  listInoutCodeType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsInoutCodeType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			listInoutCodeType.add(aMap);
		}
		model.addAttribute("gsInoutCodeType", listInoutCodeType);

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준설정
		else if(ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN","N");

		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);		//BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsSumTypeCell","N");

		List<CodeDetailVO> gsOutDetailType = codeInfo.getCodeList("M104", "", false);	//
		List<Map<String, Object>>  listOutDetailType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOutDetailType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("GOOD_BAD", map.getRefCode4());
			listOutDetailType.add(aMap);
		}
		model.addAttribute("gsOutDetailType", listOutDetailType);

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCheckStockYn",cdo.getRefCode1());	//재고상태관리
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsCheckStockYn","+");


		cdo = codeInfo.getCodeInfo("B703", "02");	//선입선출(자재) 사용여부 체크
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsFifo",cdo.getRefCode1());
		}else {
			model.addAttribute("gsFifo", "N");
		}

		cdo = codeInfo.getCodeInfo("B090", "MD");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoMgntYn",cdo.getRefCode1());	//lot_no중복체크 품목제외 여부(y이면 lotno만 중복체크 n이면 lotno + 품목코드까지 해서 중복 체크)

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("mtr202ukrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		cdo = codeInfo.getCodeInfo("Z029", "1");
		if(!ObjUtils.isEmpty(cdo) && !ObjUtils.isEmpty(cdo.getRefCode1())){
			model.addAttribute("gsBarcodeGbn", cdo.getRefCode1());
		}else{
			model.addAttribute("gsBarcodeGbn", "|");
		}
		return JSP_PATH + "mtr202ukrv";
	}

	/**
	 * 작업지시별출고현황출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mtr260skrv.do")
	public String mtr260skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "mtr260skrv";
	}

	/**
	 * 작업실적별출고현황출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mtr280skrv.do")
	public String mtr280skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "mtr280skrv";
	}

	@RequestMapping(value = "/matrl/mtr290skrv.do")
	public String mtr290skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "mtr290skrv";
	}

	@RequestMapping(value = "/matrl/mtr220ukrv.do",method = RequestMethod.GET)
	public String mtr220ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:입출고번호자동채번(txtOrderNum) lock,disable

		/*List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);	//수불처구분
		List<Map<String, Object>>  listInoutCodeType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsInoutCodeType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			listInoutCodeType.add(aMap);
		}
		model.addAttribute("gsInoutCodeType", listInoutCodeType);

		*/
		List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);		//수불처구분
		for(CodeDetailVO map : gsInoutCodeType) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsInoutCodeType", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준설정
		else if(ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN","N");

		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);		//BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsSumTypeCell","N");

		List<CodeDetailVO> gsOutDetailType = codeInfo.getCodeList("M104", "", false);	//
		List<Map<String, Object>>  listOutDetailType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOutDetailType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("GOOD_BAD", map.getRefCode4());
			listOutDetailType.add(aMap);
		}
		model.addAttribute("gsOutDetailType", listOutDetailType);

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCheckStockYn",cdo.getRefCode1());	//재고상태관리
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsCheckStockYn","+");

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("mtr202ukrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "mtr220ukrv";
	}
}