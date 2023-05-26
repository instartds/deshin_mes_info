package foren.unilite.modules.human.hxt;

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
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class HxtController extends UniliteCommonController {
    
    private final Logger         logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String          JSP_PATH = "/human/hxt/";
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl     comboService;
    
    @Resource( name = "hxt120skrServiceImpl" )
    private Hxt120skrServiceImpl hxt120skrServiceImpl;
    
    /**
     * <pre>
     * 차량관리
     * </pre>
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hxt100ukr.do" )
    public String hxt100ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hxt100ukr";
    }
    
    /**
     * <pre>
     * 성금등록
     * </pre>
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hxt110ukr.do" )
    public String hxt110ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hxt110ukr";
    }
    
    /**
     * <pre>
     * 성금 납부금액 내역서 조회
     * </pre>
     * 
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hxt120skr.do" )
    public String hxt120skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hxt120skr";
    }
}