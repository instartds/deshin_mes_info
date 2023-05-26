package foren.unilite.modules.crm.cmd;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.framework.model.LoginVO;
import foren.unilite.com.UniliteCommonController;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class CmdController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/crm/cmd/";

	@RequestMapping(value="/cm/cmd100ukrv.do",method = RequestMethod.GET)
	public String cmd100ukrv(LoginVO loginVO, ModelMap model	)throws Exception{
		return JSP_PATH+"cmd100ukrv";
	}
	@RequestMapping(value="/app/Unilite/app/calendar/eventEditor.do",method = RequestMethod.GET)
	public String cmd100ukrvWin(LoginVO loginVO, ModelMap model	)throws Exception{
		return JSP_PATH+"cmd100ukrvWin";
	}	
	
}
