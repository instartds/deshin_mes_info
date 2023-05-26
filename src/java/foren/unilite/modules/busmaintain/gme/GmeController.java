package foren.unilite.modules.busmaintain.gme;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.busoperate.GopCommonServiceImpl;

@Controller
public class GmeController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_maintain/gme/";
	

	@RequestMapping(value = "/bus_maintain/gme100ukrv.do", method = RequestMethod.GET)
	public String gme100ukrv() throws Exception {
		return JSP_PATH + "gme100ukrv";
	}
	
	@RequestMapping(value = "/bus_maintain/gme200ukrv.do", method = RequestMethod.GET)
	public String gme200ukrv() throws Exception {
		return JSP_PATH + "gme200ukrv";
	}
	
	@RequestMapping(value = "/bus_maintain/gme300ukrv.do", method = RequestMethod.GET)
	public String gme300ukrv() throws Exception {
		return JSP_PATH + "gme300ukrv";
	}
	
	@RequestMapping(value = "/bus_maintain/gme100skrv.do", method = RequestMethod.GET)
	public String gme100skrv() throws Exception {
		return JSP_PATH + "gme100skrv";
	}
	
	@RequestMapping(value = "/bus_maintain/gme200skrv.do", method = RequestMethod.GET)
	public String gme200skrv() throws Exception {
		return JSP_PATH + "gme200skrv";
	}

}
