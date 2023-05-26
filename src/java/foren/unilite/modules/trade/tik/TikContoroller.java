package foren.unilite.modules.trade.tik;

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
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class TikContoroller extends UniliteCommonController {
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/trade/tik/";
	
	@RequestMapping(value = "/trade/tik110skrv.do")
	public String tik110skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;		
		
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		return JSP_PATH + "tik110skrv";
	}
	
	@RequestMapping(value = "/trade/tik100ukrv.do")
    public String tik100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;        
        
        model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
        model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
        model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
        
        return JSP_PATH + "tik100ukrv";
    }
}
