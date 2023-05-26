package foren.unilite.modules.human.hcn;

import java.util.HashMap;
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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class HcnController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/human/hcn/";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource( name = "hcn100ukrService" )
    private Hcn100ukrServiceImpl   hcn100ukrService;
	
	@Resource( name = "hcn100skrService" )
    private Hcn100skrServiceImpl   hcn100skrService;
	
	/**
	 *  상담이력등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hcn100ukr.do")
	public String hcn100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		Map param = new HashMap();
		param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
		
		Map checkCnlnGrp = (Map)hcn100ukrService.checkCnlnGrp(param);
		
		if(ObjUtils.isNotEmpty(checkCnlnGrp)){
	        model.addAttribute("checkCnlnGrp", checkCnlnGrp.get("GROUP_CODE"));
		}else{
		    model.addAttribute("checkCnlnGrp", 'X');
		}
		
		return JSP_PATH+"hcn100ukr";
	}
	/**
     *  상담이력현황
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/human/hcn100skr.do")
    public String hcn100skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        Map param = new HashMap();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        
        Map checkCnlnGrp = (Map)hcn100skrService.checkCnlnGrp(param);
        
        if(ObjUtils.isNotEmpty(checkCnlnGrp)){
            model.addAttribute("checkCnlnGrp", checkCnlnGrp.get("GROUP_CODE"));
        }else{
            model.addAttribute("checkCnlnGrp", 'X');
        }
        
        return JSP_PATH+"hcn100skr";
    }
}
