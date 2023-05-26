package foren.unilite.modules.base.bdc;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

/**
 *    프로그램명 : 통합문서 관리
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class BdcController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/base/bdc/";
	public final static String EXT_DOWNLOAD_SERVLET = "/ext/filelist.do";
	
	@Resource(name="bdc100ukrvService")
	private Bdc100ukrvServiceImpl bdc100ukrvService;

	/**
	 * 통합문서관리 jsp controller

	 * @param login
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/base/bdc100ukrv.do",method = RequestMethod.GET)
	public String bdc100ukrv(LoginVO login, ModelMap model	) throws Exception{	
		
		//대분류 콤보 
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", login.getCompCode());

		model.addAttribute("BDC100ukv_DOC_LEVEL1", bdc100ukrvService.getDocLevel1(param));  
		model.addAttribute("BDC100ukv_DOC_LEVEL2", bdc100ukrvService.getDocLevel2(param));   
		model.addAttribute("BDC100ukv_DOC_LEVEL3", bdc100ukrvService.getDocLevel3(param));    
		
				
		return JSP_PATH+"bdc100ukrv";
	}
	
	@RequestMapping(value = "/base/bdc110ukrv.do", method = RequestMethod.GET)
	public String bdc110ukrv(LoginVO login,  ModelMap model) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", login.getCompCode());
		
		model.addAttribute("BDC100ukv_DOC_LEVEL1", bdc100ukrvService.getDocLevel1(param));  
		model.addAttribute("BDC100ukv_DOC_LEVEL2", bdc100ukrvService.getDocLevel2(param));   
		model.addAttribute("BDC100ukv_DOC_LEVEL3", bdc100ukrvService.getDocLevel3(param));    

		return JSP_PATH + "bdc110ukrv";
	}
	

	
	@RequestMapping(value="/base/bdc100ukrv_sample.do",method = RequestMethod.GET)
	public String bdc100ukrv_sample(LoginVO login, ModelMap model	) throws Exception{	
		
		//대분류 콤보 
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", login.getCompCode());

		model.addAttribute("BDC100ukv_DOC_LEVEL1", bdc100ukrvService.getDocLevel1(param));  
		model.addAttribute("BDC100ukv_DOC_LEVEL2", bdc100ukrvService.getDocLevel2(param));   
		model.addAttribute("BDC100ukv_DOC_LEVEL3", bdc100ukrvService.getDocLevel3(param));    
		
				
		return JSP_PATH+"bdc100ukrv_sample";
	}
	
	/**
	 * 외부사용자용 파일 다운 로더.
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ext/filelist.do", method = RequestMethod.GET)
	public String externalDownload( ModelMap model, String REF_ID) throws Exception {
		Map param = new HashMap();
		param.put("REF_ID", REF_ID);
		model.addAttribute("fileList", bdc100ukrvService.getExtFileList(param)); ;

		return "/ext/attachedFiles";
	}
	
	
	@RequestMapping(value = "/ext/extDownload.do")
	public ModelAndView extDownload(String REF_ID, String FID) throws Exception {
		
		Map param = new HashMap();
		param.put("REF_ID", REF_ID);
		param.put("FID", FID);
		
		FileDownloadInfo fdi = bdc100ukrvService.getFileInfo(param, FID);
		if(fdi != null) {
			fdi.setInLineYn(false);// (_req.getP("inline") == "N")? false : true  );
		}
		return ViewHelper.getFileDownloadView(fdi);
	}
}
