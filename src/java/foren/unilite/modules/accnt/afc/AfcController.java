package foren.unilite.modules.accnt.afc;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import foren.unilite.modules.accnt.AccntCommonServiceImpl;

/**
 *    프로그램명 : 결산관리
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AfcController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/afc/";

	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;


	/**
	 * 전년도실적입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afc100ukr.do",method = RequestMethod.GET)
	public String afc100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월	
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));	
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "afc100ukr";
	}

}
