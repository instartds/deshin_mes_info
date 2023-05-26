package foren.unilite.modules.rd.laa;

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
import foren.unilite.com.tags.ComboService;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;


@Controller
public class LaaController extends UniliteCommonController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String  JSP_PATH = "/rd/laa/";

	@Resource(name="rdCommonService")
	private RdCommonServiceImpl rdCommonService;


	/* 성분정보 등록 (laa100ukrv)
	 */
	@RequestMapping(value = "/rd/laa100ukrv.do")
	public String laa100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
//		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		//규제 공통코드 가져오는 로직(L001)
		param.put("MAIN_CODE", "L001");
		model.addAttribute("regulation",		rdCommonService.regurationList(param));		//중국규제

		return JSP_PATH + "laa100ukrv";
	}



	/* 원료별 성분 등록 (laa110ukrv)
	 */
	@RequestMapping(value = "/rd/laa110ukrv.do")
	public String laa110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
//		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		//규제 공통코드 가져오는 로직(L001)
		param.put("MAIN_CODE", "L001");
		model.addAttribute("regulation",		rdCommonService.regurationList(param));		//중국규제

		return JSP_PATH + "laa110ukrv";
	}



	/* 전성분 등록 (laa120skrv)
	 */
	@RequestMapping(value = "/rd/laa120skrv.do")
	public String laa120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
//		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		//규제 공통코드 가져오는 로직(L001)
		param.put("MAIN_CODE", "L001");
		model.addAttribute("regulation",		rdCommonService.regurationList(param));		//중국규제

		return JSP_PATH + "laa120skrv";
	}
}
