package foren.unilite.modules.z_kodi;

import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
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
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.hat.Hat520skrServiceImpl;
import foren.unilite.modules.matrl.mpo.Mpo250skrvServiceImpl;
import foren.unilite.modules.prodt.pmr.Pmr100ukrvServiceImpl;

@Controller
public class Z_kodiController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_kodi/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

    @Resource( name = "s_hat510ukr_kodiService" )
    private S_hat510ukr_kodiServiceImpl       s_hat510ukr_kodiService;

    @Resource( name = "s_mpo250ukrv_kodiService" )
    private S_mpo250ukrv_kodiServiceImpl       s_mpo250ukrv_kodiService;

    @Resource( name = "s_pmr350skrv_kodiService" )
    private S_pmr350skrv_kodiServiceImpl       s_pmr350skrv_kodiService;

    @Resource( name = "s_mpo270skrv_kodiService" )
    private S_mpo270skrv_kodiServiceImpl       s_mpo270skrv_kodiService;

    @Resource( name = "s_pms300ukrv_kodiService" )
    private S_pms300ukrv_kodiServiceImpl       s_pms300ukrv_kodiService;

    @Resource( name = "s_pms402ukrv_kodiService" )
    private S_pms402ukrv_kodiServiceImpl       s_pms402ukrv_kodiService;

    @Resource( name = "s_pms403ukrv_kodiService" )
    private S_pms403ukrv_kodiServiceImpl       s_pms403ukrv_kodiService;

    @Resource( name = "s_pms410ukrv_kodiService" )
    private S_pms410ukrv_kodiServiceImpl       s_pms410ukrv_kodiService;

	@Resource( name = "s_pmr830skrv_kodiService" )
	private S_pmr830skrv_kodiServiceImpl s_pmr830skrv_kodiService;

	@Resource( name = "s_pmp286skrv_kodiService" )
	private S_pmp286skrv_kodiServiceImpl s_pmp286skrv_kodiService;


	/**
	 * 수주대응 조회 (s_sof150ukrv_kodi)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kodi/s_sof150ukrv_kodi.do")
	public String s_sof150ukrv_kodi(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_sof150ukrv_kodi";
	}

	@RequestMapping(value = "/z_kodi/s_mpo250ukrv_kodi.do")
	public String s_mpo250ukrv_kodi(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_ORDER_WEEK", s_mpo250ukrv_kodiService.getOrderWeek(param));


		return JSP_PATH + "s_mpo250ukrv_kodi";
	}

	@RequestMapping(value = "/z_kodi/s_pmr820skrv_kodi.do")
	public String s_pmr820skrv_kodi(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_pmr820skrv_kodi";
	}

	@RequestMapping(value = "/z_kodi/s_pmr830skrv_kodi.do")
	public String s_pmr830skrv_kodi(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		Gson gson = new Gson();
        String colData = gson.toJson(s_pmr830skrv_kodiService.selectBadcodes(loginVO.getCompCode()));
        String colData2 = gson.toJson(s_pmr830skrv_kodiService.selectBadcodeRemarks(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        model.addAttribute("colData2", colData2);

		return JSP_PATH + "s_pmr830skrv_kodi";
	}


	@RequestMapping(value = "/z_kodi/s_pmr320skrv_kodi.do")
	public String s_pmr320skrv_kodi(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_pmr320skrv_kodi";
	}

	@RequestMapping(value = "/z_kodi/s_pmr350skrv_kodi.do")
	public String s_pmr350skrv_kodi(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		Gson gson = new Gson();
        String colData = gson.toJson(s_pmr350skrv_kodiService.selectBadcodes(loginVO.getCompCode()));
        model.addAttribute("colData", colData);

		return JSP_PATH + "s_pmr350skrv_kodi";
	}

	@RequestMapping(value = "/z_kodi/s_mpo270skrv_kodi.do")
	public String s_mpo270skrv_kodi(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.MONTH, -6);

        String strDate = sdf.format(cal.getTime());
        String strdateF = "01";
        String strDateR = strDate.substring(0,6).concat(strdateF);

		model.addAttribute("gsDateFr", strDateR);

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_mpo270skrv_kodi";
	}


    /**
     * 근태월보
     *
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/z_kodi/s_hat510ukr_kodi.do" )
    public String s_hat510ukr_kodi(LoginVO loginVO, ModelMap model ) throws Exception {
    	Map param = new HashMap();
        Gson gson = new Gson();
        String colData = gson.toJson(s_hat510ukr_kodiService.selectDutycode(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        return JSP_PATH + "s_hat510ukr_kodi";
    }
	/**
	 * 공정/출하접수 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kodi/s_pms300ukrv_kodi.do",method = RequestMethod.GET)
	public String s_pms300ukrv_kodi(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "s_pms300ukrv_kodi";
	}
	/**
	 * 공정검사 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kodi/s_pms402ukrv_kodi.do",method = RequestMethod.GET)
	public String s_pms402ukrv_kodi(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		 model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P000", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInputFlag",cdo.getRefCode1());	// 출하검사 후 자동입고여부

		cdo = codeInfo.getCodeInfo("B090", "PC");	//생산실적과 출하검사 LOT 연계 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}
		param.put("DIV_CODE", loginVO.getDivCode());
		model.addAttribute("COMBO_TEST_CODE", s_pms402ukrv_kodiService.getTestCode(param));
		cdo = codeInfo.getCodeInfo("B084", "D");	 										  // 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		return JSP_PATH + "s_pms402ukrv_kodi";
	}
	/**
	 * 출고검사등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kodi/s_pms403ukrv_kodi.do",method = RequestMethod.GET)
	public String s_pms403ukrv_kodi(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		 model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P000", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInputFlag",cdo.getRefCode1());	// 출하검사 후 자동입고여부

		cdo = codeInfo.getCodeInfo("B090", "PC");	//생산실적과 출하검사 LOT 연계 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}
		param.put("DIV_CODE", loginVO.getDivCode());
		model.addAttribute("COMBO_TEST_CODE", s_pms403ukrv_kodiService.getTestCode(param));
		cdo = codeInfo.getCodeInfo("B084", "D");	 										  // 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		return JSP_PATH + "s_pms402ukrv_kodi";
	}
	/**
	 * 접수현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kodi/s_pms410ukrv_kodi.do",method = RequestMethod.GET)
	public String s_pms410ukrv_kodi(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "s_pms410ukrv_kodi";
	}

    /**
     * 난다 라벨 출력
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/z_kodi/s_pmr910rkrv_kodi.do")
	public String s_pmr910rkrv_kodi(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_pmr910rkrv_kodi";
	}

	/**
	 * 수입정수및검사현황(코디)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kodi/s_mms200skrv_kodi.do")
	public String mms120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("mms110ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "s_mms200skrv_kodi";
	}


	/**
	 * 믹싱 타정 이력현황(화성) -20210721 신규
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kodi/s_pmp286skrv_kodi.do")
	public String s_pmp286skrv_kodi(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_pmp286skrv_kodi";
	}
}
