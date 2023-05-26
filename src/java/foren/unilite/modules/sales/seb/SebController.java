package foren.unilite.modules.sales.seb;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.framework.model.LoginVO;
import foren.unilite.com.UniliteCommonController;

@Controller
public class SebController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/sales/seb/";


	/**
	 * 견적기준정보등록 (seb100ukrv) - 20210628 신규 생성
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/seb100ukrv.do", method = RequestMethod.GET)
	public String seb100ukrv() throws Exception {
		return JSP_PATH + "seb100ukrv";
	}
}