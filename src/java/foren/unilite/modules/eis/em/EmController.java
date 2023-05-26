package foren.unilite.modules.eis.em;

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
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class EmController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/eis/em/";

	@Resource(name="UniliteComboServiceImpl")
    private ComboServiceImpl comboService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;

	@Resource(name="ems100skrvService")
	private Ems100skrvServiceImpl ems100skrvService;



	/**
	 * 금형수리현황모니터링
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eis/emp100skrv.do" )
	public String emp100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "emp100skrv";
	}
	/**
	 * 원자재창고모니터링
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eis/emi100skrv.do" )
	public String emi100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "emi100skrv";
	}

	/**
	 * 제품창고모니터링
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eis/emi110skrv.do" )
	public String emi110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "emi110skrv";
	}
	/**
	 * 자재예약현황 모니터링
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eis/emp110skrv.do" )
	public String emp110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "emp110skrv";
	}
	/**
	 * 출하지시현황 모니터링
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eis/ems100skrv.do" )
	public String ems100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "ems100skrv");
		
		String nextPgmId = ems100skrvService.selectNextPgmId(param);
		Integer interval = ems100skrvService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		return JSP_PATH + "ems100skrv";
	}
	/**
	 * 작업진행현황 모니터링
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eis/emp120skrv.do" )
	public String emp120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "emp120skrv");

		String nextPgmId = ems100skrvService.selectNextPgmId(param);
		Integer interval = ems100skrvService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		return JSP_PATH + "emp120skrv";
	}
}
