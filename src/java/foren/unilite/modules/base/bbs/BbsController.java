package foren.unilite.modules.base.bbs;

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
public class BbsController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/base/bbs/";


	@RequestMapping(value = "/base/bbs010ukrv.do", method = RequestMethod.GET)
	public String bbs010ukrv() throws Exception {
		return JSP_PATH + "bbs010ukrv";
	}

	@RequestMapping(value = "/base/bbs020ukrv.do", method = RequestMethod.GET)
	public String bbs020ukrv() throws Exception {
		return JSP_PATH + "bbs020ukrv";
	}

	@RequestMapping(value = "/base/bbs888skrv.do", method = RequestMethod.GET)
	public String bbs990ukrv() throws Exception {
		return JSP_PATH + "bbs888skrv";
	}

	@RequestMapping( value = "/base/bbs021ukrv.do", method = RequestMethod.GET )
	public String bbs021ukrv() throws Exception {
		return JSP_PATH + "bbs021ukrv";
	}
}