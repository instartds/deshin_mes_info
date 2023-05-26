package foren.unilite.modules.z_jw;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.hat.Hat501ukrServiceImpl;
import foren.unilite.modules.sales.sof.Sof100ukrvServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_jwController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_jw/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

	@Resource( name = "hat501ukrService" )
	private Hat501ukrServiceImpl		hat501ukrService;

	@Resource(name="s_bpr300ukrv_jwService")
	private S_bpr300ukrv_jwServiceImpl s_bpr300ukrv_jwService;
	
	@Resource(name="s_bpr910ukrv_jwService")
	private S_bpr910ukrv_jwServiceImpl s_bpr910ukrv_jwService;	
	
	@Resource(name="s_bpr910skrv_jwService")
	private S_bpr910skrv_jwServiceImpl s_bpr910skrv_jwService;		

	@Resource( name = "s_hat500ukr_jwService" )
	private S_hat500ukr_jwServiceImpl		s_hat500ukr_jwService;

	@Resource( name = "s_hat501ukr_jwService" )
	private S_hat501ukr_jwServiceImpl		s_hat501ukr_jwService;

	@Resource( name = "s_hbo300ukr_jwService" )
	private S_Hbo300ukr_jwServiceImpl		s_hbo300ukr_jwService;

	@Resource( name = "s_agj270skr_jwService" )
	private S_Agj270skr_jwServiceImpl		s_agj270skr_jwService;

	@Resource( name = "s_agj270skr_jwExcelService" )
	private S_Agj270skr_jwExcelServiceImpl		s_agj270skr_jwExcelService;

	@Resource( name = "s_sof100ukrv_jwService" )
	private S_Sof100ukrv_jwServiceImpl   s_sof100ukrv_jwService;
	
	@Resource( name = "s_pmp141skrv_jwService" )
	private S_Pmp141skrv_jwServiceImpl   s_pmp141skrv_jwService;


	/**
	 * 지급결의 등록(JW) (s_map100ukrv_jw)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_map100ukrv_jw.do",method = RequestMethod.GET)
	public String s_map100ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M502", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());	//선지급사용여부 조회
		else model.addAttribute("gsAdvanUseYn",'N');

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}
		cdo = codeInfo.getCodeInfo("M101", "4");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType1",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M101", "5");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType2",cdo.getRefCode1());

		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1)	{
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode5()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

		List<CodeDetailVO> gsList2 = codeInfo.getCodeList("M302", "", false);
		Object list2= "";
		for(CodeDetailVO map : gsList2)	{
			if("Y".equals(map.getRefCode5()))	{
				if(list2.equals("")){
				list2 =  map.getCodeNo();
				}else{
					list2 = list2 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList2", list2);

		List<CodeDetailVO> AccountType = codeInfo.getCodeList("M302");
		if(!ObjUtils.isEmpty(AccountType))	model.addAttribute("AccountType",ObjUtils.toJsonStr(AccountType));

		List<CodeDetailVO> BillType = codeInfo.getCodeList("A022");
		if(!ObjUtils.isEmpty(BillType))	model.addAttribute("BillType",ObjUtils.toJsonStr(BillType));

		return JSP_PATH + "s_map100ukrv_jw";
	}

	/**
	 * 입고단가 일괄조정(JW) (s_map300ukrv_jw)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_map300ukrv_jw.do")
	public String s_map300ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		return JSP_PATH + "s_map300ukrv_jw";
	}

	/**
	 * 자재입고등록(JW)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_mms510ukrv_jw.do",method = RequestMethod.GET)
	public String s_mms510ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
//		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M103", "", false);		//입고유형
		for(CodeDetailVO map : gsInoutTypeDetail)	{
				model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
		}

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsn)	{

			if(loginVO.getDivCode().equals(map.getRefCode1()))	{
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}

		List<CodeDetailVO> cdList = codeInfo.getCodeList("M103");	//기표대상여부관련
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));


		cdo = codeInfo.getCodeInfo("M102", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());	//과입고허용률\

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리



		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);		//처리방법 분류
		for(CodeDetailVO map : gsProcessFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);		//검사프로그램사용여부
		for(CodeDetailVO map : gsInspecFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInspecFlag", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M024", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsMap100UkrLink",	cdo.getCodeName());		//링크프로그램정보(지급결의등록)


		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	//재고합산유형:Lot No. 합산

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형:창고 Cell. 합산

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M503", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsOScmYn",StringUtils.isBlank(cdo.getRefCode1())?"N":cdo.getRefCode1());

		if(StringUtils.isNotBlank(cdo.getRefCode1()) && "Y".equalsIgnoreCase(cdo.getRefCode1())){
			cdo = codeInfo.getCodeInfo("B605", "1");
			if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsDbName",StringUtils.isBlank(cdo.getRefCode3())?null:cdo.getRefCode3()+"..");
		}

		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

		List<CodeDetailVO> gsQ008Sub = codeInfo.getCodeList("Q008", "", false);		//가입고사용여부 관련
		for(CodeDetailVO map : gsQ008Sub)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsQ008Sub", map.getCodeNo());
			}
		}

		//출력라벨 선택을 위한 로직
		List<CodeDetailVO> gsSelectLabel = codeInfo.getCodeList("B706", "", false);
		for(CodeDetailVO map : gsSelectLabel)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSelectLabel", map.getCodeNo());
			}
		}

		//라벨출력을 위한 작업자 가져오는 로직
		List<CodeDetailVO> gsWorker = codeInfo.getCodeList("B705", "", false);
		for(CodeDetailVO map : gsWorker)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsWorker", map.getCodeName());
			}
		}

		//20181126 추가: 라벨출력을 위해 LOT 이니셜 확인
		List<CodeDetailVO> gsLotInitail = codeInfo.getCodeList("Z011", "", false);
		for(CodeDetailVO map : gsLotInitail)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsLotInitail", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("Z012", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_mms510ukrv_jw".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "s_mms510ukrv_jw";
	}

	@RequestMapping(value = "/z_jw/s_mpo200ukrv_jw.do",method = RequestMethod.GET)
	public String s_mpo200ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<CodeDetailVO> gsApproveYN = codeInfo.getCodeList("M008", "", false);		//발주승인 방식
		for(CodeDetailVO map : gsApproveYN) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
				model.addAttribute("gsApproveYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsExchgRegYNList = codeInfo.getCodeList("B081", "", false);		//대체품목 등록여부
		for(CodeDetailVO map : gsExchgRegYNList) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}else{
				model.addAttribute("gsExchgRegYN", "N");
			}
		}
		return JSP_PATH + "s_mpo200ukrv_jw";
	}

	@RequestMapping(value = "/z_jw/s_mpo501ukrv_jw.do",method = RequestMethod.GET)
	public String s_mpo501ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

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
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	//재고합산유형:Lot No. 합산

		cdo = codeInfo.getCodeInfo("M101", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_mpo501ukrv_jw".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}


		return JSP_PATH + "s_mpo501ukrv_jw";
	}

	/**
	 * 외주입고 등록(JW) (s_otr120ukrv_jw)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_otr120ukrv_jw.do")
	public String s_otr120ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		/*cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	 재고상태관리(+/-) */

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);
		for(CodeDetailVO map : gsInspecFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInspecFlag", map.getCodeNo());						/* 검사프로그램 사용여부  */
			}
		}

		cdo = codeInfo.getCodeInfo("M102", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("glPerCent",cdo.getRefCode1());	/* 발주량 대비 입고율 */

		cdo = codeInfo.getCodeInfo("M503", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmLinkFlag",cdo.getRefCode1());	/* 입고등록(SCM연계) 사용여부 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	/* 재고합산유형 : 창고 Cell 합산 */

		List<CodeDetailVO> gsCheckMath = codeInfo.getCodeList("M031", "", false);
		for(CodeDetailVO map : gsCheckMath)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCheckMath", map.getCodeNo());						/* 검사프로그램 사용여부  */
			}
		}

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());						/* 화폐단위  */
			}
		}

		List<CodeDetailVO> gsQ008Sub = codeInfo.getCodeList("Q008", "", false);		//가입고사용여부 관련
		for(CodeDetailVO map : gsQ008Sub)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsQ008Sub", map.getCodeNo());
			}
		}

		//출력라벨 선택을 위한 로직
		List<CodeDetailVO> gsSelectLabel = codeInfo.getCodeList("B706", "", false);
		for(CodeDetailVO map : gsSelectLabel)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSelectLabel", map.getCodeNo());
			}
		}

		//라벨출력을 위한 작업자 가져오는 로직
		List<CodeDetailVO> gsWorker = codeInfo.getCodeList("B705", "", false);
		for(CodeDetailVO map : gsWorker)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsWorker", map.getCodeName());
			}
		}

		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

		//20181126 추가: 라벨출력을 위해 LOT 이니셜 확인
		List<CodeDetailVO> gsLotInitail = codeInfo.getCodeList("Z011", "", false);
		for(CodeDetailVO map : gsLotInitail)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsLotInitail", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("Z012", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_otr120ukrv_jw".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "s_otr120ukrv_jw";
	}

	/**
	 * 작업지시 등록(JW)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmp101ukrv_jw.do")
	public String s_pmp101ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		cdo = codeInfo.getCodeInfo("P005", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoNo", cdo.getRefCode1());	 // 생산자동채번유무

		cdo = codeInfo.getCodeInfo("P000", "3");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsBadInputYN",cdo.getRefCode1());  // 자동입고시 불량입고 반영여부

		cdo = codeInfo.getCodeInfo("P121", "01");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChildStockPopYN",cdo.getRefCode1());  // 자재부족팝업 호출여부

		int i = 0;
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);	// BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))	{
				model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());

				i++;  // RecordCount
			}
		}
		if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

		cdo = codeInfo.getCodeInfo("B090", "PA");	//							  // LOT 관리기준 설정 재고와 작업지시 LOT 연계여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		cdo = codeInfo.getCodeInfo("P000", "4");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsGoodsInputYN",cdo.getRefCode1());  // 긴급작지시 상품입력 가능여부

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:의뢰번호(txtOrderNum) lock,disable

		cdo = codeInfo.getCodeInfo("P513", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAllowableRate",cdo.getRefCode1());	  //Y:의뢰번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("Z012", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_pmp101ukrv_jw".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "s_pmp101ukrv_jw";
	}

	/**
	 * 작업지시현황 조회(JW)(작업지시별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmp120skrv_jw.do")
	public String pmp120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "s_pmp120skrv_jw";
	}

	/**
	 * 작업실적 등록(JW)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmr100ukrv_jw.do")
	public String s_pmr100ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		cdo = codeInfo.getCodeInfo("B090", "PB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1()); // 작업지시와 생산실적LOT 연계여부 설정 값 알기

		cdo = codeInfo.getCodeInfo("P000", "6");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsChkProdtDateYN",cdo.getRefCode1()); // 작업실적 등록시 착수예정일 체크여부

		cdo = codeInfo.getCodeInfo("P100", "1");	 										  // 생산완료시점 (100%)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("glEndRate",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B084", "D");	 										  // 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("P601", "Y");	 										  // 금형타발수사용
		if(!ObjUtils.isEmpty(cdo) && "Y".equals(cdo.getRefCode1())){
			model.addAttribute("gsMoldPunchQ_Yn", cdo.getRefCode1());
		}else {
			model.addAttribute("gsMoldPunchQ_Yn", "N");
		}

		//출력라벨 선택을 위한 로직
		List<CodeDetailVO> gsSelectLabel = codeInfo.getCodeList("B706", "", false);
		for(CodeDetailVO map : gsSelectLabel)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSelectLabel", map.getCodeNo());
			}
		}

		//20181126 추가: 라벨출력을 위해 LOT 이니셜 확인
		List<CodeDetailVO> gsLotInitail = codeInfo.getCodeList("Z011", "", false);
		for(CodeDetailVO map : gsLotInitail)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsLotInitail", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("Z012", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_pmr100ukrv_jw".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "s_pmr100ukrv_jw";
	}

	/**
	 * 검사 등록(JW) (s_pms401ukrv_jw)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pms401ukrv_jw.do",method = RequestMethod.GET)
	public String s_pms401ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P000", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInputFlag",cdo.getRefCode1());	// 출하검사 후 자동입고여부



		cdo = codeInfo.getCodeInfo("B090", "PC");							//생산실적과 출하검사 LOT 연계 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());		//입력형태(Y/E/N)
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());		//필수입력(Y/N)
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());		//품목계정(필수Y, 문자열)
		}

		return JSP_PATH + "s_pms401ukrv_jw";
	}

	/**
	 * 생산계획등록(작업장별)(JW) (s_ppl100ukrv_jw)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_ppl100ukrv_jw.do")
	public String s_ppl100ukrv_jw (ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));


		cdo = codeInfo.getCodeInfo("S048", "PP");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageTimeYN",			cdo.getRefCode1());

		return JSP_PATH + "s_ppl100ukrv_jw";
	}

	/**
	 * 품목정보등록(통합)(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_bpr300ukrv_jw.do")
	public String s_bpr300ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B073", "1").getRefCode1());
		//model.addAttribute("UseByDate",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("B108", "B005").getRefCode3());
		String precision = null;
		String formatWithPrecision = "0,000.";
		List<CodeDetailVO> configList = this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeList("B108", "", false);
		for(CodeDetailVO map : configList)	{
			if("bpr100ukrv".equals(map.getRefCode1()))	{
				if("REIM".equals(map.getRefCode2()))	{
					precision = map.getRefCode3();

					int intPrecision = ObjUtils.parseInt(precision);
					for(int i=0; i<intPrecision; i++ )	{
						formatWithPrecision+="0";
					}
					model.addAttribute("REIM_Precision", map.getRefCode3());
					model.addAttribute("REIM_PrecisionFormat",formatWithPrecision);
				}
			}
		}
		if(precision == null)	{
			model.addAttribute("REIM_Precision", 2);
		}

		model.addAttribute("COMBO_PROG_WORK_CODE", s_bpr300ukrv_jwService.getProgWorkCode(param)); //공정

		return JSP_PATH + "s_bpr300ukrv_jw";
	}
	
	/**
	 * 개발REVISION 등록(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_bpr910ukrv_jw.do")
	public String s_bpr910ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_bpr910ukrv_jw";
	}	
	
	@RequestMapping( value = "/fileman/downloadRevInfoImage/{fid}" )
	public ModelAndView downloader( @PathVariable( "fid" ) String fid, LoginVO user ) throws Exception {
		logger.debug("inlineViewer fid:{}", fid);
		FileDownloadInfo fdi = s_bpr910ukrv_jwService.getFileInfo(user, fid);
		if (fdi != null) {
			fdi.setInLineYn(false);
		}
		return ViewHelper.getFileDownloadView(fdi);
	}
		
	
	@RequestMapping( value = "/fileman/downloadRevFile/{pgmId}/{selItemCode}/{seRevNo}/{seFileType}/{specialYn}" )
	public ModelAndView downloadItemFlie( @PathVariable( "pgmId" ) String pgmId, @PathVariable( "selItemCode" ) String selItemCode, @PathVariable( "seRevNo" ) String seRevNo, @PathVariable( "seFileType" ) String seFileType, @PathVariable( "specialYn" ) String specialYn, LoginVO user, HttpServletRequest request ) throws Exception {
		if (pgmId == null) {
			throw new UniDirectValidateException("프로그램 정보가 없습니다.");
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", user.getCompCode());
		if(specialYn.equals("true")){
			selItemCode = selItemCode.replace("^^^", "#");
		}
		param.put("ITEM_CODE", selItemCode);
		param.put("REV_NO", seRevNo);
		param.put("FILE_TYPE", seFileType);
		param.put("lang", user.getLanguage());
		param.put("pgmId", pgmId);
		Map<String, Object> fileDownInfo = (Map<String, Object>) s_bpr910ukrv_jwService.getItemInfoFileDown(param);

		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		logger.debug("[[Download_Full_Path]] :" + drive + (String) fileDownInfo.get("FILE_PATH")  + File.separator + (String) fileDownInfo.get("FILE_ID") + "." + (String) fileDownInfo.get("FILE_EXT"));
		FileDownloadInfo file = new FileDownloadInfo(drive + (String) fileDownInfo.get("FILE_PATH")  + File.separator, (String) fileDownInfo.get("FILE_ID") + "." + (String) fileDownInfo.get("FILE_EXT"));
		file.setOriginalFileName( (String) fileDownInfo.get("CERT_FILE"));


		if (file.getFile() == null) {
			throw new UniDirectValidateException("다운로드할 파일이 없습니다.");
		}
		return ViewHelper.getFileDownloadView(file);
	}	
	
	/**
	 * 개발REVISION 조회(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_bpr910skrv_jw.do")
	public String s_bpr910skrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_bpr910skrv_jw";
	}		

	/**
	 * 작업호기/시간 관리(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmp170ukrv_jw.do")
	public String s_pmp170ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "s_pmp170ukrv_jw";
	}

	/**
	 * SECOM 근태등록(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_hat500ukr_jw.do")
	public String s_hat500ukr_jw(LoginVO loginVO,ModelMap model) throws Exception {
		String dutyRule = hat501ukrService.getDutyRule(loginVO.getCompCode());
		Map<String, String> param = new HashMap<String, String>();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("DUTY_RULE", dutyRule);
		param.put("PAY_CODE", "0");
		model.addAttribute("dutyRule", dutyRule);
		Gson gson = new Gson();
		String colData = gson.toJson(s_hat500ukr_jwService.selectDutycode(loginVO.getCompCode()));
		model.addAttribute("colData", colData);

		return JSP_PATH + "s_hat500ukr_jw";
	}

	/**
	 * SECOM 근태등록(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_hat501ukr_jw.do")
	public String s_hat501ukr_jw(LoginVO loginVO,ModelMap model) throws Exception {
		String dutyRule = hat501ukrService.getDutyRule(loginVO.getCompCode());
		Map<String, String> param = new HashMap<String, String>();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("DUTY_RULE", dutyRule);
		param.put("PAY_CODE", "0");
		model.addAttribute("dutyRule", dutyRule);
		Gson gson = new Gson();
		String colData = gson.toJson(s_hat501ukr_jwService.selectDutycode(loginVO.getCompCode()));
		model.addAttribute("colData", colData);

		return JSP_PATH + "s_hat501ukr_jw";
	}

	/**
	 * 급여정보조회(S)(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_hpa900skr_jw.do")
	public String s_hpa900skr_jw(LoginVO loginVO,ModelMap model) throws Exception {
		return JSP_PATH + "s_hpa900skr_jw";
	}

	/**
	 * 상여기초자료등록(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_hbo300ukr_jw.do")
	public String s_hbo300ukr_jw(LoginVO loginVO,ModelMap model) throws Exception {
		return JSP_PATH + "s_hbo300ukr_jw";
	}

	/**
	 * 급여보고서출력(S)(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_hpa910rkr_jw.do")
	public String s_hpa910rkr_jw(LoginVO loginVO,ModelMap model) throws Exception {
		return JSP_PATH + "s_hpa910rkr_jw";
	}

	/**
	 * 제조지시서출력(제이월드)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmp130rkrv_jw.do")
	public String s_pmp130rkrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("Z012", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_pmp130rkrv_jw".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "s_pmp130rkrv_jw";
	}

	/**
	 * 테스트
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_test999ukrv_jw.do",method = RequestMethod.GET)
	public String s_test999ukrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_test999ukrv_jw";
	}

	/**
	 * 전표출력(지출결의서)
	 *
	 * @return
	 * @throws Exception
	 */
	//@SuppressWarnings( { "unused" } )
	@RequestMapping( value = "/z_jw/s_agj270skr_jw.do", method = RequestMethod.GET )
	public String s_agj270skr_jw( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {

		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());

		//CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		//CodeDetailVO cdo = null;



		return JSP_PATH + "s_agj270skr_jw";
	}

	@ResponseBody
	@RequestMapping(value = "/z_jw/s_agj270skr_jwExcelDown.do")
	public ModelAndView s_agj270skr_jwDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response, LoginVO loginVO) throws Exception{
		Map<String, Object> paramMap = _req.getParameterMap();
		logger.debug("[excel]");
		Workbook wb = s_agj270skr_jwExcelService.makeExcel(paramMap, loginVO );
		String title = "지출결의서";

		return ViewHelper.getExcelDownloadView(wb, title);
	}

	/** New출고등록(개별)(s_str105ukrv_jw) - 바코드
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_str105ukrv_jw.do")
	public String s_str105ukrv_jw (String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))	model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");	//자동채번여부(출고번호)정보 조회
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

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");


		cdo = codeInfo.getCodeInfo("S116", "str103ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");	//LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false);	//출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInoutAutoYN", map.getCodeNo());
				if(map.getCodeNo().equals("1") || map.getCodeNo().equals("3")){
					model.addAttribute("gsInoutAutoYN", "Y");
				}else{
					model.addAttribute("gsInoutAutoYN", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsInoutAutoYN", "Y");

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvstatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvstatus", "+");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
		for(CodeDetailVO map : gsCreditYn)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCreditYn", map.getCodeNo());
				if(map.getCodeNo().equals("2")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
			if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");	//멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefWhCode",cdo.getRefCode1());
		}else {
			model.addAttribute("gsRefWhCode", "1");
		}

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("S048", "SI");	//시/분/초 필드 처리여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsManageTimeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsManageTimeYN", "N");
		}
		cdo = codeInfo.getCodeInfo("S120", "1");	//셀 자동LOT 배정여부(Y/N)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("useLotAssignment",cdo.getRefCode1());
		}else {
			model.addAttribute("useLotAssignment", "N");
		}
		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		cdo = codeInfo.getCodeInfo("B703", "01");	//선입선출 사용여부 체크
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsFifo",cdo.getRefCode1());
		}else {
			model.addAttribute("gsFifo", "N");
		}



		return JSP_PATH + "s_str105ukrv_jw";
	}

	@RequestMapping(value = "/z_jw/s_mpo150rkrv_jw.do")
	public String s_mpo150rkrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_mpo501ukrv_jw".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "s_mpo150rkrv_jw";
}


	/**
	 * 수주등록(JW)
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_sof100ukrv_jw.do",method = RequestMethod.GET)
	public String s_sof100ukrv_jw( LoginVO loginVO, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S026", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:수주번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsBalanceOut = codeInfo.getCodeList("WB06", "", false);				 //B/OUT 체크
		for(CodeDetailVO map : gsBalanceOut) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsBalanceOut", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		List<CodeDetailVO> gsProdtDtAutoYN = codeInfo.getCodeList("S031", "", false);
		for(CodeDetailVO map : gsProdtDtAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProdtDtAutoYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("S035", "", false);
		for(CodeDetailVO map : gsSaleAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSaleAutoYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S037", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSof100ukrLink",	cdo.getCodeName());

		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());				//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "4");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSsa100UkrLink",	cdo.getCodeName());				//매출등록 링크 PGM ID

		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);
		for(CodeDetailVO map : gsProcessFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsCondShowFlag = codeInfo.getCodeList("S043", "", false);
		for(CodeDetailVO map : gsCondShowFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCondShowFlag", map.getCodeNo());				//Y:수주내역의 할인율,할인율일괄적용,해당행 visible
			}
		}

		List<CodeDetailVO> gsDraftFlag = codeInfo.getCodeList("S044", "", false);
		for(CodeDetailVO map : gsDraftFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				if(map.getCodeNo().equals("1")){
					model.addAttribute("gsDraftFlag", "Y");					//Y:수주승인관련 필드
				}else{
					model.addAttribute("gsDraftFlag", "N");					//N:자동승인관련 필드
				}
			}
		}

		cdo = codeInfo.getCodeInfo("S045", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp1AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp1AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S045", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp2AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp2AmtInfo,lblApp3AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsTimeYN",			cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S061", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmUseYN",		cdo.getRefCode1());				//Y:SCM연계탭 enable

		cdo = codeInfo.getCodeInfo("B078", "10");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPjtCodeYN",		cdo.getRefCode1());				//Y:수주검색팝업에 txtPlanNum enable

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPointYn",			cdo.getRefCode1());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
			model.addAttribute("gsUnitChack",		cdo.getRefCode2());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPriceGubun",		cdo.getRefCode1());		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			cdo.getRefCode2());		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			cdo.getRefCode3());		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}


		List<CodeDetailVO> gsOrderTypeSaleYN = codeInfo.getCodeList("S044", "", false);
	    List<Map<String, Object>>  listOrderTypeSaleYN = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOrderTypeSaleYN)	{
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			aMap.put("REF_CODE1", map.getRefCode1());
			listOrderTypeSaleYN.add(aMap);
		}
		model.addAttribute("gsOrderTypeSaleYN", listOrderTypeSaleYN);

        List<CodeDetailVO> gsProdSaleQ_WS03 = codeInfo.getCodeList("WS03", "", false);
        for(CodeDetailVO map : gsProdSaleQ_WS03) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsProdSaleQ_WS03", map.getCodeNo());
            } else {
                model.addAttribute("gsProdSaleQ_WS03", "N");
            }
        }

		List<CodeDetailVO> salesPrsn = codeInfo.getCodeList("S010", "", false);
		List<Map> divPrsn = new ArrayList<Map>();
		for(CodeDetailVO map : salesPrsn)	{
				Map rMap = new HashMap();
				rMap.put("value",map.getCodeNo());
				rMap.put("text", map.getCodeName());
				rMap.put("option",map.getRefCode1());
				divPrsn.add(rMap);
		}
		model.addAttribute("divPrsn", divPrsn);

        //SRM 데이터수신 사용여부 확인 (공통코드 S146의 SUB_CODE = '1'의 REF_CODE1)
		cdo = codeInfo.getCodeInfo("S146", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseReceiveSrmYN", cdo.getRefCode1());     // 생산자동채번유무

		List<CodeDetailVO> gsSalesPrsn = codeInfo.getCodeList("S010", "", false);//로그인 유저와 같은 영업담당자 가져오기
		for(CodeDetailVO map : gsSalesPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode5()))	{
				model.addAttribute("gsSalesPrsn",map.getCodeNo());
			}
		}

		//영업납기리드타임 관련
	    Map<String, Object> tempParam = new HashMap<String, Object>();
	    tempParam.put("S_COMP_CODE", loginVO.getCompCode());
	    Map tempMap = (Map) s_sof100ukrv_jwService.selectGsDvry(tempParam);

		model.addAttribute("gsDvryDate",tempMap.get("gsDvryDate"));

		tempParam.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(tempParam));
		//model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(tempParam));

		//20190607 SAMPLE코드 사용여부(B912)
		cdo = codeInfo.getCodeInfo("B912", "1");
		if(!ObjUtils.isEmpty(cdo)){
				model.addAttribute("gsSampleCodeYn", cdo.getRefCode1());
		} else {
				model.addAttribute("gsSampleCodeYn", "N");
		}

		//20190625 재료수량을 가용재고로 표시할지 여부(S513)
		cdo = codeInfo.getCodeInfo("S153", "1");
		if(!ObjUtils.isEmpty(cdo)){
				model.addAttribute("gsPStockYn", cdo.getRefCode1());
		} else {
				model.addAttribute("gsPStockYn", "N");
		}

		return JSP_PATH + "s_sof100ukrv_jw";
	}


	@RequestMapping(value = "/z_jw/s_biv361skrv_jw.do")
	public String s_biv361skrv_jw(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_biv361skrv_jw";
	}
	
	/**
	 * 자재예약/촐고현황 조회(JW)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmp141skrv_jw.do")
	public String s_pmp141skrv_jw(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "s_pmp141skrv_jw";
	}
}
