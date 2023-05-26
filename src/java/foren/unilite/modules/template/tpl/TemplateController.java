package foren.unilite.modules.template.tpl;

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
public class TemplateController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/template/tpl/";
	

	@RequestMapping(value = "/template/tpl100ukrv.do", method = RequestMethod.GET)
	public String tpl100ukrv() throws Exception {
		return JSP_PATH + "tpl100ukrv";
	}
	
	@RequestMapping(value = "/template/tpl101ukrv.do", method = RequestMethod.GET)
	public String tpl101ukrv() throws Exception {
		return JSP_PATH + "tpl101ukrv";
	}
	
	@RequestMapping(value = "/template/tpl102ukrv.do", method = RequestMethod.GET)
	public String tpl102ukrv() throws Exception {
		return JSP_PATH + "tpl102ukrv";
	}
	
	@RequestMapping(value = "/template/tpl103ukrv.do", method = RequestMethod.GET)
	public String tpl103ukrv() throws Exception {
		return JSP_PATH + "tpl103ukrv";
	}
	
	@RequestMapping(value = "/template/tpl104ukrv.do", method = RequestMethod.GET)
	public String tpl104ukrv() throws Exception {
		return JSP_PATH + "tpl104ukrv";
	}
	
	@RequestMapping(value = "/template/tpl105ukrv.do", method = RequestMethod.GET)
	public String tpl105ukrv() throws Exception {
		return JSP_PATH + "tpl105ukrv";
	}
	
	@RequestMapping(value = "/template/tpl106ukrv.do", method = RequestMethod.GET)
	public String tpl106ukrv() throws Exception {
		return JSP_PATH + "tpl106ukrv";
	}
	
	@RequestMapping(value = "/template/tpl107ukrv.do", method = RequestMethod.GET)
	public String tpl107ukrv() throws Exception {
		return JSP_PATH + "tpl107ukrv";
	}
	
    @RequestMapping(value = "/template/tpl200ukr.do", method = RequestMethod.GET)
    public String tpl200ukr() throws Exception {
        return JSP_PATH + "tpl200ukr";
    }

}
