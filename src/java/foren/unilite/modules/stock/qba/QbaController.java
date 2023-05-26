package foren.unilite.modules.stock.qba;

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
import foren.unilite.com.tags.ComboService;
import foren.unilite.modules.com.combo.ComboServiceImpl;


@Controller
public class QbaController extends UniliteCommonController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String  JSP_PATH = "/stock/qba/";

	@Resource(name="qba120ukrvService")
	private Qba120ukrvServiceImpl qba120ukrvService;

	/*20190304
	 * qba100ukrv(시험항목등록)
	 * */
	@RequestMapping(value = "/stock/qba100ukrv.do")
	public String qba100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "qba100ukrv";
	}

	/*20190307
	 * qba120ukrv(분류별시험항목등록)
	 * */
	@RequestMapping(value = "/stock/qba120ukrv.do")
	public String qba120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_TEST_GROUP", qba120ukrvService.getItemLevel1(param));
		model.addAttribute("COMBO_TEST_CODE", qba120ukrvService.getTestCode(param));

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "qba120ukrv";
	}

	/*20190807
	 * qba200ukrv(수입검사장비 설정)
	 * */
	@RequestMapping(value = "/stock/qba200ukrv.do")
	public String qba200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "qba200ukrv";
	}

	/*20190809
	 * qba210ukrv(수입검사장비 설정)
	 * */
	@RequestMapping(value = "/stock/qba210ukrv.do")
	public String qba210ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "qba210ukrv";
	}

	/*20190814
	 * qba300ukrv(공정검사기준 설정)
	 * */
	@RequestMapping(value = "/stock/qba300ukrv.do")
	public String qba300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "qba300ukrv";
	}

	/*20200819
	 * qba220ukrv(수입검사장비 설정)
	 * */
	@RequestMapping(value = "/stock/qba220ukrv.do")
	public String qba220ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "qba220ukrv";
	}

	/*20200819
	 * qba110ukrv(시험항목등록)
	 * */
	@RequestMapping(value = "/stock/qba110ukrv.do")
	public String qba110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "qba110ukrv";
	}
}
