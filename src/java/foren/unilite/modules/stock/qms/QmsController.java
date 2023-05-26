package foren.unilite.modules.stock.qms;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.equip.esa.EsaExcelServiceImpl;
import foren.unilite.modules.prodt.pmr.Pmr350skrvServiceImpl;

@Controller
public class QmsController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/stock/qms/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="qmsExcelService")
	private QmsExcelServiceImpl qmsExcelService;

	@Resource( name = "qms400ukrvService")				//20200929 추가
	private Qms400ukrvServiceImpl qms400ukrvService;


	/**
	 * 자주검사등록 (qms400ukrv) - 20200928 추가: 신규 개발
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/qms400ukrv.do")
	public String qms400ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		LoginVO session = _req.getSession();
//		String page = _req.getP("page");

		//동적 그리드 구현(공통코드(p03)에서 컬럼 가져오는 로직)
		Gson gson = new Gson();
		String colData = gson.toJson(qms400ukrvService.selectColumns(loginVO));
		model.addAttribute("colData", colData);

		return JSP_PATH + "qms400ukrv";
	}

	@RequestMapping(value = "/stock/qms701skrv.do")
	public String qms701skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "qms701skrv";
	}

	@RequestMapping(value = "/stock/qms701ukrv.do")
	public String qms701ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "qms701ukrv";
	}

	@RequestMapping(value = "/stock/qms600ukrv.do")
	public String qms600ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));
		//20200422 추가
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P000", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInputFlag",cdo.getRefCode1());	// 출하검사 후 자동입고여부

		cdo = codeInfo.getCodeInfo("B090", "PC");	//생산실적과 출하검사 LOT 연계 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1());		//입력형태(Y/E/N)
			model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2());		//필수입력(Y/N)
			model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3());		//품목계정(필수Y,문자열)
		}

		//20200423 추가
		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell", cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}
		return JSP_PATH + "qms600ukrv";
	}

	/**
	 * 작업실적 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/qms450ukrv.do")
	public String qms450ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "qms450ukrv";
	}

	/**
	 * 검사미완료현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/qms600skrv.do", method = RequestMethod.GET)
	public String qms600skrv() throws Exception {
		return JSP_PATH + "qms600skrv";
	}

	/**
	 * 품질검사현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/qms610skrv.do", method = RequestMethod.GET)
	public String qms610skrv() throws Exception {
		return JSP_PATH + "qms610skrv";
	}

	/**
	 * 코팅검사성적서출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/qms702skrv.do")
	public String qms702skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("qms702skrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "qms702skrv";
	}

	/**
	 * 바코드검사 체크리스트
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/qms703skrv.do")
	public String qms703skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("qms703skrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "qms703skrv";
	}

	@RequestMapping(value = "/stock/qms703skrvExcelDown.do")
	public ModelAndView qms703skrvExcelDown(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = qmsExcelService.makeExcel(paramMap);
		String title = "라벨링 및 포장검사 성적서";

		return ViewHelper.getExcelDownloadView(wb, title);
	}
}