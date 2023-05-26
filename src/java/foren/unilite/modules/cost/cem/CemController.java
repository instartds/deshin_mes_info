package foren.unilite.modules.cost.cem;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class CemController extends UniliteCommonController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String JSP_PATH = "/cost/cem/";

	/**
	 * 품목별 제조경비 집계현황
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cem100skrv.do")
	public String cem100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cem100skrv";
	}

}