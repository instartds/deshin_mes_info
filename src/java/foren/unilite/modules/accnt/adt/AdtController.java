package foren.unilite.modules.accnt.adt;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.unilite.com.UniliteCommonController;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AdtController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/adt/";

	
	/**
	 * 총계정원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/adt100ukr.do")
	public String adt100ukr(	)throws Exception{
		return JSP_PATH+"adt100ukr";
	}
	
	@RequestMapping(value="/accnt/adt400ukr.do")
	public String adt400ukr(	)throws Exception{
		return JSP_PATH+"adt400ukr";
	}
	
	@RequestMapping(value="/accnt/adt500ukr.do")
	public String adt500ukr(	)throws Exception{
		return JSP_PATH+"adt500ukr";
	}
}
