package foren.unilite.modules.stock.btr;

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
public class BtrController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/stock/btr/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="btr130skrvService")	//20210803 추가
	private Btr130skrvServiceImpl btr130skrvService;


	@RequestMapping(value = "/stock/btr100ukrv.do")
	public String btr100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* �����°�(+/-) */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* ���� ����̵�LOT ���迩�� */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* ����ջ����� : Lot No. �ջ� */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* ����ջ����� : â�� Cell �ջ� */

		cdo = codeInfo.getCodeInfo("B041", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutotype",cdo.getRefCode1());

		return JSP_PATH + "btr100ukrv";
	}

	/**
	 * 정규 재고이동 요청등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/btr101ukrv.do")
	public String btr101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		model.addAttribute("COMBO_GW_STATUS", comboService.fnGetGwStatus(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* �����°�(+/-) */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* ���� ����̵�LOT ���迩�� */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	   /* ����ջ����� : Lot No. �ջ� */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	  /* ����ջ����� : â�� Cell �ջ� */

		cdo = codeInfo.getCodeInfo("B041", "3");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());
//		if(!ObjUtils.isEmpty(cdo)){
//			model.addAttribute("GW_URL",cdo.getCodeName());
//		}else {
//			model.addAttribute("GW_URL", "");
//		}

		List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("I014", "", false);//가용재고 체크여부
		for(CodeDetailVO map : gsUsePabStockYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsUsePabStockYn", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
		for(CodeDetailVO map : gsGwYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsGwYn", map.getCodeNo());
			}
		}

		return JSP_PATH + "btr101ukrv";
	}

	@RequestMapping(value = "/stock/btr110ukrv.do",method = RequestMethod.GET)
	public String btr110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* 재고상태관리(+/-) */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}																					/* 주화폐단위 */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* 재고와 재고이동LOT 연계여부 */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

		cdo = codeInfo.getCodeInfo("B041", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutotype",cdo.getRefCode1());

		return JSP_PATH + "btr110ukrv";
	}

	/**
	 * 정규 재고이동출고 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/btr111ukrv.do",method = RequestMethod.GET)
	public String btr111ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
//		model.addAttribute("CSS_TYPE", "-large2");					//20201116 주석: 정규는 키오스크 형태 사용하지 않음 - btr112urkv를 키오스크 화면으로 사용
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		model.addAttribute("COMBO_WH_LIST2", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST2", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* 재고상태관리(+/-) */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}																				   /* 주화폐단위 */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* 재고와 재고이동LOT 연계여부 */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	   /* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	  /* 재고합산유형 : 창고 Cell 합산 */

		cdo = codeInfo.getCodeInfo("B041", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B256", "1");	//추가항목 필드셋:
		if(ObjUtils.isNotEmpty(cdo)){
			model.addAttribute("gsSetField", cdo.getCodeName().toUpperCase());
		}

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn)); // 담당자

		List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("I014", "", false);//가용재고 체크여부
		for(CodeDetailVO map : gsUsePabStockYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsUsePabStockYn", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
		for(CodeDetailVO map : gsGwYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsGwYn", map.getCodeNo());
			}
		}

		return JSP_PATH + "btr111ukrv";
	}

	@RequestMapping(value = "/stock/btr120ukrv.do",method = RequestMethod.GET)
	public String btr120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* �����°�(+/-) */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}																					/* ��ȭ����� */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* ���� ����̵�LOT ���迩�� */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* ����ջ����� : Lot No. �ջ� */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* ����ջ����� : â�� Cell �ջ� */

		cdo = codeInfo.getCodeInfo("B041", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutotype",cdo.getRefCode1());

		return JSP_PATH + "btr120ukrv";
	}

	/**
	 * 정규 재고이동입고 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/btr121ukrv.do",method = RequestMethod.GET)
	public String btr121ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		model.addAttribute("COMBO_WH_LIST2", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST2", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* �����°�(+/-) */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}																				   /* ��ȭ����� */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* ���� ����̵�LOT ���迩�� */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	   /* ����ջ����� : Lot No. �ջ� */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	  /* ����ջ����� : â�� Cell �ջ� */

		cdo = codeInfo.getCodeInfo("B041", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

		return JSP_PATH + "btr121ukrv";
	}

	@RequestMapping(value = "/stock/btr901ukrv.do")
	public String btr901ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));	//20210405 추가

		//20200407 추가
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		//20210405 추가: 재고합산유형  - 창고 Cell 합산 
		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B090", "IC");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3());
		} else {
			model.addAttribute("gsLotNoInputMethod"	, "N");
			model.addAttribute("gsLotNoEssential"	, "N");
			model.addAttribute("gsEssItemAccount"	, "");
		}

		return JSP_PATH + "btr901ukrv";
	}

	@RequestMapping(value = "/stock/btr150ukrv.do")
	public String btr150ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "btr150ukrv";
	}

	@RequestMapping(value = "/stock/btr160ukrv.do")
	public String btr160ukrv() throws Exception {
		return JSP_PATH + "btr160ukrv";
	}

	@RequestMapping(value = "/stock/btr171ukrv.do")
	public String btr171ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("I001", "7");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("sApplyYN",cdo.getRefCode1());	/* LOT관리여부 */

		cdo = codeInfo.getCodeInfo("I001", "8");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("sCellWhCode",cdo.getRefCode1());	/* Cell관리여부 */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

		return JSP_PATH + "btr171ukrv";
	}

	@RequestMapping(value = "/stock/btr910skrv.do")
	public String btr910skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoYN",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCellCodeYN",cdo.getRefCode1());

		return JSP_PATH + "btr910skrv";
	}

	/**
	 * 재고이동요청현황 출력 (btr160rkrv) - 20201130 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/btr160rkrv.do")
	public String btr160rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoYN",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCellCodeYN",cdo.getRefCode1());

		return JSP_PATH + "btr160rkrv";
	}

	@RequestMapping(value = "/stock/btr160skrv.do")
	public String btr160skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoYN",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCellCodeYN",cdo.getRefCode1());

		return JSP_PATH + "btr160skrv";
	}

	@RequestMapping(value = "/stock/btr130skrv.do")
	public String btr130skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		//20191202 추가
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoYN",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCellCodeYN",cdo.getRefCode1());

		//20200320 추가: 링크할 프로그램 명, 경로, ID 가져오는 공통코드 추가 후 조회
		cdo = codeInfo.getCodeInfo("M515", "1");
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsLink1_Name"	, cdo.getCodeName());
			model.addAttribute("gsLink1_Path"	, cdo.getRefCode1());
			model.addAttribute("gsLink1_Id"		, cdo.getRefCode2());
		} else {
			model.addAttribute("gsLink1_Name"	, "");
			model.addAttribute("gsLink1_Path"	, "");
			model.addAttribute("gsLink1_Id"		, "");
		}
		//20210803 추가: 조회 시, 사용하는 VIEW 존재여부 체크 (ORDER_LOT_V_SITE)
		String existFlag;
		existFlag = (String) btr130skrvService.gsExistsSiteVeiw(param);
		model.addAttribute("gsExistsSiteVeiw"	, existFlag);
		return JSP_PATH + "btr130skrv";
	}

	/**
	 * 재고이동명세서 출력 (btr130rkrv) - 20201207 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/btr130rkrv.do")
	public String btr130rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);				//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getDivCode().equals(map.getRefCode1()) && (ObjUtils.isNotEmpty(map.getRefCode10()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode10().toUpperCase()))) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}

		return JSP_PATH + "btr130rkrv";
	}

	@RequestMapping(value = "/stock/btr140skrv.do")
	public String btr140skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		//20200220 추가
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoYN",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCellCodeYN",cdo.getRefCode1());

		return JSP_PATH + "btr140skrv";
	}

	@RequestMapping(value = "/stock/btr171skrv.do")
	public String btr171skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "btr171skrv";
	}

	/**
	 * 재고이동출고 등록 (키오스크용)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/btr112ukrv.do",method = RequestMethod.GET)
	public String btr112ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("CSS_TYPE", "-large2");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		model.addAttribute("COMBO_WH_LIST2", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST2", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* 재고상태관리(+/-) */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}																				   /* 주화폐단위 */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* 재고와 재고이동LOT 연계여부 */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	   /* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	  /* 재고합산유형 : 창고 Cell 합산 */

		cdo = codeInfo.getCodeInfo("B041", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B256", "1");	//추가항목 필드셋:
		if(ObjUtils.isNotEmpty(cdo)){
			model.addAttribute("gsSetField", cdo.getCodeName().toUpperCase());
		}

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn)); // 담당자

		List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("I014", "", false);//가용재고 체크여부
		for(CodeDetailVO map : gsUsePabStockYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsUsePabStockYn", map.getCodeNo());
			}
		}
		List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
		for(CodeDetailVO map : gsGwYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsGwYn", map.getCodeNo());
			}
		}
		return JSP_PATH + "btr112ukrv";
	}

	/**
	 * 재고이동현황 조회 (btr200skrv) - 20210208 추가: 신규
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/btr200skrv.do")
	public String btr200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		param.put("S_COMP_CODE"					, loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoYN",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCellCodeYN",cdo.getRefCode1());

		return JSP_PATH + "btr200skrv";
	}
}