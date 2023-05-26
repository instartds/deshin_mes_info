package foren.unilite.modules.accnt.axt;

import java.util.Map;

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
import foren.framework.model.NavigatorInfo;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

/**
 * <pre>
 * 프로그램명 : 작업지시조정 
 * 작 성 자 : (주)포렌 개발실
 * </pre>
 */
@Controller
public class AxtController extends UniliteCommonController {
    
    private final Logger           logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String            JSP_PATH = "/accnt/axt/";
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl       comboService;
    
    @Resource( name = "axt100ukrService" )
    private Axt100ukrServiceImpl   axt100ukrService;
    
    @Resource( name = "axt110skrService" )
    private Axt110skrServiceImpl   axt110skrService;
    
    @Resource( name = "axt120skrService" )
    private Axt120skrServiceImpl   axt120skrService;
    
    @Resource( name = "axt130skrService" )
    private Axt130skrServiceImpl   axt130skrService;
    
    @Resource( name = "axt140skrService" )
    private Axt140skrServiceImpl   axt140skrService;
    
    @Resource( name = "axt150skrService" )
    private Axt150skrServiceImpl   axt150skrService;
    
    @Resource( name = "axt160skrService" )
    private Axt160skrServiceImpl   axt160skrService;
    
    @Resource( name = "axt170skrService" )
    private Axt170skrServiceImpl   axt170skrService;
    
    @Resource( name = "axt180skrService" )
    private Axt180skrServiceImpl   axt180skrService;

    @Resource( name = "axt190skrService" )
    private Axt190skrServiceImpl   axt190skrService;
    
    /**
     * 거래처별물품대등록
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt100ukr.do", method = RequestMethod.GET )
    public String axt100ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("PGM_ID", "axt100ukr");
        
        return JSP_PATH + "axt100ukr";
    }
    
    /**
     * SK대비표 조회
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt110skr.do" )
    public String axt110skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt110skr";
    }
    
    /**
     * 거래처별 월별 미지급명세서 조회
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt120skr.do" )
    public String axt120skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt120skr";
    }
    
    /**
     * 거래처별 미지급금 현금송금 명세서 조회
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt130skr.do" )
    public String axt130skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt130skr";
    }
    
    /**
     * 대출금현황 조회
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt140skr.do" )
    public String axt140skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt140skr";
    }

    /**
     * 만기일별어음명세서 조회
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt150skr.do" )
    public String axt150skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt150skr";
    }

    /**
     * 입출금현황명세서 조회
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt160skr.do" )
    public String axt160skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt160skr";
    }

    /**
     * 자금현황 등록
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt150ukr.do", method = RequestMethod.GET )
    public String axt150ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("PGM_ID", "axt150ukr");
        
        return JSP_PATH + "axt150ukr";
    }
    
//    @RequestMapping( value = "/accnt/axt150ukr.do" )
//    public String axt150ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
//        final String[] searchFields = {};
//        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//        LoginVO session = _req.getSession();
//        Map<String, Object> param = navigator.getParam();
//        String page = _req.getP("page");
//        
//        param.put("S_COMP_CODE", loginVO.getCompCode());
//        
//        return JSP_PATH + "s_hum510skr_kva";
//    }
    
    
    
    
    /**
     * 자금현황명세서 조회
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt170skr.do" )
    public String axt170skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt170skr";
    }

    /**
     * 퇴직급여 충당금설정 명세서 조회
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt180skr.do" )
    public String axt180skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt180skr";
    }

    /**
     * 영업일보-입금현황
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "unused" )
    @RequestMapping( value = "/accnt/axt190skr.do" )
    public String axt190skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "axt190skr";
    }
}