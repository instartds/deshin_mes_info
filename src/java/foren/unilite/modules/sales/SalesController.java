package foren.unilite.modules.sales;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.unilite.com.UniliteCommonController;

@Controller
public class SalesController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/sales/";

	
	@RequestMapping(value = "/sales/sbs150ukrv.do", method = RequestMethod.GET)
	public String bcm100ukrv() throws Exception {
		return JSP_PATH + "sbs150ukrv";
	}
	

}
