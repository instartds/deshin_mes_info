package foren.unilite.modules.template.popup;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;

/**
 * 프로그램명 : Tempate팝업 
 * 작 성 자 : (주)포렌 개발실
 */

@Controller
public class TemplatePopupController extends UniliteCommonController {

	private final Logger		logger		= LoggerFactory.getLogger(this.getClass());
	final static String			JSP_PATH	= "/template/popup/";
	
	
	/**
	 * Joins 템플릿 팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/app/Unilite/app/popup/templatePopup.do")
	public String templatePopupWin() throws Exception {

		return JSP_PATH + "templatePopupWin";
	}
}