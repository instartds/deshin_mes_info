package foren.unilite.modules.trade.ten;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class TenController extends UniliteCommonController {
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl comboService;
    
    private final Logger     logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String      JSP_PATH = "/trade/ten/";
    
    @RequestMapping( value = "/trade/ten200ukrv.do", method = RequestMethod.GET )
    public String ten200ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        cdo = codeInfo.getCodeInfo("B244", "10");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsHiddenField", cdo.getRefCode1());
        return JSP_PATH + "ten200ukrv";
    }
    
}
