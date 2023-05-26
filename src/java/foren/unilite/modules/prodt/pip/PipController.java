package foren.unilite.modules.prodt.pip;

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
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class PipController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/prodt/pip/";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	
	/**
	 * 절단최적화계산
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pip100ukrv.do")
	public String pip100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P514", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsBasisNum",cdo.getRefCode1());		/* 절단 최적화 실행 회수 : 기준값 */

		cdo = codeInfo.getCodeInfo("P514", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsMaxNum",cdo.getRefCode2());		/* 절단 최적화 실행 회수 : 최대실행값 */

		return JSP_PATH + "pip100ukrv";
	}
	
}
