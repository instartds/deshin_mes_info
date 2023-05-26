package foren.unilite.modules.human.hpb;

import java.io.FileOutputStream;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

@Controller
public class HpbController extends UniliteCommonController {
    
    @Resource( name = "UniliteComboServiceImpl" )
    private ComboServiceImpl     comboService;
    
    @Resource( name = "hpb100ukrService" )
    private Hpb100ukrServiceImpl hpb100ukrService;
    
    @Resource( name = "hpb200ukrService" )
    private Hpb200ukrServiceImpl hpb200ukrService;
    
    @Resource( name = "hpb210ukrService" )
    private Hpb210ukrServiceImpl hpb210ukrService;
    
    @Resource( name = "hpb300ukrService" )
    private Hpb300ukrServiceImpl hpb300ukrService;
    
    @Resource( name = "hpb500ukrService" )
    private Hpb500ukrServiceImpl hpb500ukrService;
    
    private final Logger         logger   = LoggerFactory.getLogger(this.getClass());
    
    final static String          JSP_PATH = "/human/hpb/";
    
    /**
     * 사업소득자등록
     * 
     * @return
     * @throws Exception
     */
    
    @RequestMapping( value = "/human/hpb100ukr.do" )
    public String hpb100ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        cdo = codeInfo.getCodeInfo("H175", "41");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAutoCode", cdo.getRefCode1());
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        String deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        model.addAttribute("deptData", deptData);
        
        return JSP_PATH + "hpb100ukr";
    }
    
    /**
     * 사업기타소득 엑셀업로드
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpb120ukr.do" )
    public String hpb120ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        String deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        model.addAttribute("deptData", deptData);
        
        return JSP_PATH + "hpb120ukr";
    }
    
    /**
     * 계정상세등록
     * 
     * @return
     * @throws Exception
     */
    
    @RequestMapping( value = "/human/hpb110ukr.do" )
    public String hpb110ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        String deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        model.addAttribute("deptData", deptData);
        
        return JSP_PATH + "hpb110ukr";
    }
    
    /*	*//**
           * 관리항목등록
           * 
           * @return
           * @throws Exception
           */
    
    /*
     * @RequestMapping(value = "/human/hpb200ukr.do") public String hpb200ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception { return JSP_PATH + "hpb200ukr"; }
     */
    /**
     * 기타소득자등록
     * 
     * @return
     * @throws Exception
     */
    
    @RequestMapping( value = "/human/hpb200ukr.do" )
    public String hpb200ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        cdo = codeInfo.getCodeInfo("H175", "41");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAutoCode", cdo.getRefCode1());
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        String deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        model.addAttribute("deptData", deptData);
        
        return JSP_PATH + "hpb200ukr";
    }
    
    /**
     * 기타소득내역등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpb210ukr.do" )
    public String hpb201ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        String deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        model.addAttribute("deptData", deptData);
        
        return JSP_PATH + "hpb210ukr";
    }
    
    /**
     * 이자배당내역등록
     * 
     * @return
     * @throws Exception
     */
    
    @RequestMapping( value = "/human/hpb300ukr.do" )
    public String hpb300ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        cdo = codeInfo.getCodeInfo("H175", "41");
        if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAutoCode", cdo.getRefCode1());
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        String deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        model.addAttribute("deptData", deptData);
        
        return JSP_PATH + "hpb300ukr";
    }
    
    /**
     * 기준코드등록
     * 
     * @return
     * @throws Exception
     */
    
    @RequestMapping( value = "/human/hpb310ukr.do" )
    public String hpb310ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        String deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        model.addAttribute("deptData", deptData);
        
        return JSP_PATH + "hpb310ukr";
    }
    
    @RequestMapping( value = "/human/hpb400rkr.do" )
    public String hpb400rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo("MASTER");
        CodeDetailVO cdo = null;
        String RefCode1 = "";
        cdo = codeInfo.getCodeInfo("H165", "1");	//대소문자 구분
        if (!ObjUtils.isEmpty(cdo)) {
            RefCode1 = cdo.getRefCode1();
        }
        String deptData = "";
        if (RefCode1.equals("Y")) {
            deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        } else {
            deptData = "";
        }
        model.addAttribute("deptData", deptData);
        return JSP_PATH + "hpb400rkr";
    }
    
    /**
     * 소득별신고자료 생성
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpb500ukr.do" )
    public String hpb500ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        Gson gson = new Gson();
        String deptData = gson.toJson(hpb100ukrService.userDept(loginVO));
        model.addAttribute("deptData", deptData);
        Map<String, Object> hometaxId = hpb500ukrService.getHometaxId(param);
        if (hometaxId != null) {
            model.addAttribute("hometaxId", hometaxId.get("HOMETAX_ID"));
        }
        
        return JSP_PATH + "hpb500ukr";
    }
    
    /**
     * 소득별신고자료 조회
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpb510skr.do" )
    public String hpb510skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        return JSP_PATH + "hpb510skr";
    }
    
    /**
     * 기본정보 등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpb010ukr.do" )
    public String hpb010ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "hpb010ukr";
        
    }
    
    /**
     * 전표마감등록
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpb020ukr.do" )
    public String hpb020ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "hpb020ukr";
    }
    
    @RequestMapping( value = "/human/hpb030ukr.do" )
    public String hpb030ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        return JSP_PATH + "hpb030ukr";
    }
    
    /**
     * 소득별신고자료 프로시져
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/fileDown.do" )
    public ModelAndView fileDown( ExtHtttprequestParam _req, LoginVO user ) throws Exception {
    		Map param = _req.getParameterMap();
    		FileDownloadInfo fInfo = null;
    		String dataFlag = ObjUtils.getSafeString(param.get("MEDIUM_TYPE"));
    		
    		//거주자사업소득
    		if("1".equals(dataFlag))	{
    			fInfo = hpb500ukrService.doBatchResidentBusiness(param);
    			logger.debug("download File Info : "+ fInfo.getPath());
    		}
    		//거주자기타소득
    		if("2".equals(dataFlag))	{
    			fInfo = hpb500ukrService.doBatchResidentEtc(param);
    			logger.debug("download File Info : "+ fInfo.getPath());
    		}
    		//비거주자사업기타소득
    		if("3".equals(dataFlag))	{
    			fInfo = hpb500ukrService.doBatchNonResidentBusinesEtc(param);
    			logger.debug("download File Info : "+ fInfo.getPath());
    		}
    		//이자,배당소득
    		if("4".equals(dataFlag))	{
    			fInfo = hpb500ukrService.doBatchInterest(param);
    			logger.debug("download File Info : "+ fInfo.getPath());
    		}
    		
    	    return ViewHelper.getFileDownloadView(fInfo);
    	
    }
}
