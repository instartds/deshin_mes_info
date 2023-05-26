package foren.unilite.modules.base.bpl;

import java.util.HashMap;
import java.util.List;
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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class BplController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/base/bpl/";
	@RequestMapping(value = "/base/bpl100skrv.do", method = RequestMethod.GET)
	public String bpl100skrv() throws Exception {
		return JSP_PATH + "bpl100skrv";
	}
	@RequestMapping(value = "/base/bpl110skrv.do", method = RequestMethod.GET)
	public String bpl110skrv() throws Exception {
		return JSP_PATH + "bpl110skrv";
	}
	@RequestMapping(value = "/base/bpl120ukrv.do", method = RequestMethod.GET)
	public String bpl120ukrv() throws Exception {
		return JSP_PATH + "bpl120ukrv";
	}
	@RequestMapping(value = "/base/bpl130ukrv.do", method = RequestMethod.GET)
 	public String bpl130ukrv() throws Exception {
		return JSP_PATH + "bpl130ukrv";
	}

}
