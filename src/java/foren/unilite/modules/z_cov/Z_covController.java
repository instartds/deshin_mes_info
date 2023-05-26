package foren.unilite.modules.z_cov;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.eis.em.Ems100skrvServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;

@Controller
public class Z_covController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_cov/";
	
	@Resource(name="UniliteComboServiceImpl")
    private ComboServiceImpl comboService;
	
	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;
	
    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
    
    @RequestMapping(value = "/z_cov/s_pmp200rkrv_cov.do")
	public String s_pmp200rkrv_cov(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "s_pmp200rkrv_cov";
	}
}
