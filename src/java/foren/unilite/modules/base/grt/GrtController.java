package foren.unilite.modules.base.grt;

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
public class GrtController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/base/grt/";
	

	@RequestMapping(value = "/base/grt100ukrv.do", method = RequestMethod.GET)
	public String grt100ukrv() throws Exception {
		return JSP_PATH + "grt100ukrv";
	}

	@RequestMapping(value = "/base/grt110ukrv.do", method = RequestMethod.GET)
	public String grt110ukrv() throws Exception {
		return JSP_PATH + "grt110ukrv";
	}
}
