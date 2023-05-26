package foren.unilite.modules.matrl.man;

import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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

@Controller
public class ManController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/matrl/man/";
	public final static String FILE_TYPE_OF_PHOTO = "stampPhoto";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;



	/**
	 * 거래처별 입고금액 (man100skrv) - 20200312 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/man100skrv.do")
	public String man100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

//		(참고)
//		LoginVO session = _req.getSession();
//		String page = _req.getP("page");

//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		CodeDetailVO cdo = null;

//		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
//		if(ObjUtils.isNotEmpty(cdo)){
//			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
//				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
//			} else {
//				model.addAttribute("gsSiteCode", "STANDARD");
//			}
//		} else {
//			model.addAttribute("gsSiteCode", "STANDARD");
//		}
		return JSP_PATH + "man100skrv";
	}

	/**
	 * 구매마감내역 (man120skrv) - 20200319 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/man120skrv.do")
	public String man120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "man120skrv";
	}

	/**
	 * 월별 구매집계 (man110skrv) - 20200313 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/man110skrv.do")
	public String man110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());
		//20200410 추가: 조회조건 "창고(멀티)" 추가
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "man110skrv";
	}

	/**
	 * 월별 재고금액 (man200skrv) - 20200312 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/man200skrv.do")
	public String man200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());
		//20200410 추가: 조회조건 "창고(멀티)" 추가
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "man200skrv";
	}
}