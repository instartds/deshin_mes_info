package foren.unilite.modules.base.bsb;

import java.io.File;
import java.io.FileOutputStream;
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
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class BsbController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/base/bsb/";
	
	
	
	
	/** 배지-연계프로그램정보
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bsb010ukrv.do", method = RequestMethod.GET)
	public String bsb010ukrv() throws Exception {
		return JSP_PATH + "bsb010ukrv";
	}
	
	/** 배지-담당자정보
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bsb020ukrv.do", method = RequestMethod.GET)
	public String bsb020ukrv() throws Exception {
		return JSP_PATH + "bsb020ukrv";
	}
	
		
}
