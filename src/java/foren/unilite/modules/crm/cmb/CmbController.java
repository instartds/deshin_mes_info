package foren.unilite.modules.crm.cmb;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.menu.ProgramAuthModel;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class CmbController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/crm/cmb/";
	
//	/**
//	 * 서비스 연결
//	 */
	
//	@Resource(name="cmb100ukrvService")
//	private Cmb100ukrvServiceImpl cmb100ukrvService;
//	
//	@Autowired
//	private Cmb200skrvService cmb200skrvService;
	
	@RequestMapping(value="/cm/cmd100skrv.do")
	public String cmd100skrv( ModelMap model	)throws Exception{
		 return "/crm/calendar/calendar";
	}
	@RequestMapping(value="/cm/cmb200skrv.do")
	public String cmb200skrv( ModelMap model, ProgramAuthModel auth	)throws Exception{
		return JSP_PATH+"cmb200skrv";
	}
	
	@RequestMapping(value="/cm/cmb210skrv.do")
	public String cmb210skrv(	)throws Exception{
		return JSP_PATH+"cmb210skrv";
	}

	@RequestMapping(value="/cm/cmb100ukrv.do")
	public String cmb100ukrv( LoginVO loginVO, ModelMap model , ExtHtttprequestParam eReq)throws Exception{
		return JSP_PATH+"cmb100ukrv";
	}

	@RequestMapping(value="/cm/cmb200ukrv.do",method = RequestMethod.GET)
	public String cmb200ukrv( LoginVO loginVO, ModelMap model)throws Exception{
		return JSP_PATH+"cmb200ukrv";
	}
}
