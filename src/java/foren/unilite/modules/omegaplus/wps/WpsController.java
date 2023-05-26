package foren.unilite.modules.omegaplus.wps;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.omegaplus.settings.Bsa030ukrvServiceImpl;

@Controller
public class WpsController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/omegaplus/wps/";
	
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	/**
	 * 개발진행 조회
	 */
	@RequestMapping(value = "/omegaplus/wps100skrv.do", method = RequestMethod.GET)
	public String wps100skrv() throws Exception {
		return JSP_PATH + "wps100skrv";
	}
	
	/**
	 * 개발요청등록
	 */
	@RequestMapping(value = "/omegaplus/wps100ukrv.do", method = RequestMethod.GET)
	public String wps100ukrv(ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo("MASTER");
		CodeDetailVO cdo = codeInfo.getCodeInfo("B002", "1");
        if (cdo != null) {
            model.addAttribute("gbn", ObjUtils.getSafeString(cdo.getRefCode1()));
        }
		return JSP_PATH + "wps100ukrv";
	}
	
	/**
	 * 개발진행 조회(조건별)
	 */
	@RequestMapping(value = "/omegaplus/wps110skrv.do", method = RequestMethod.GET)
	public String wps110skrv() throws Exception {
		return JSP_PATH + "wps110skrv";
	}
	
	
	/**
	 * 개발등록
	 */
	@RequestMapping(value = "/omegaplus/wps110ukrv.do", method = RequestMethod.GET)
	public String wps110ukrv() throws Exception {
		return JSP_PATH + "wps110ukrv";
	}
	
	/**
	 * 테스트등록
	 */
	@RequestMapping(value = "/omegaplus/wps200ukrv.do", method = RequestMethod.GET)
	public String wps200ukrv() throws Exception {
		return JSP_PATH + "wps200ukrv";
	}
	
	@RequestMapping( value = "/omegaplus/downloadDeploy.do" )
    public ModelAndView downloadLangugeFile( ExtHtttprequestParam _req, LoginVO user ) throws Exception {
        
        Map param = _req.getParameterMap();
        
        List<Map<String, Object>> fileData = new ArrayList<Map<String, Object>>();//bsa030ukrvService.selectFiles(param);
        
        if (fileData == null) {
            throw new UniDirectValidateException("언어 정보가 없습니다.");
        }
        
        File dir = new File(ConfigUtil.getUploadBasePath("Lang"));
		if(!dir.exists())  dir.mkdir(); 
		String moduleInitial = ObjUtils.getSafeString(param.get("MODULE_INITIAL"),"");
		String lang = ObjUtils.getSafeString(param.get("LANG"),"");
		String strType = ObjUtils.getSafeString(param.get("TYPE"),"");
				
		String fileName = "";
		if("".equals(moduleInitial) || moduleInitial==null)	{
			fileName = "Common"+strType+"_"+lang+".properties";
		} else if("JS".equals(moduleInitial)) {
			fileName = "CommonJS"+strType+"_"+lang+".properties";
		} else {
			fileName = "Module"+strType+moduleInitial+"_"+lang+".properties";
		}
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("Lang"), fileName );
		logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
		FileOutputStream fos = new FileOutputStream(fInfo.getFile());
	    
		for(Map<String, Object> map : fileData)	{
			String data = "";
			data = GStringUtils.trim(ObjUtils.nvl(map.get("key1"),"")) + GStringUtils.trim(ObjUtils.nvl(map.get("value"),""));
		    data += "\n";
		    byte[] bytesArray = data.getBytes("UTF-8");
		    fos.write(bytesArray);
	   	}
		fos.flush();
	    fos.close(); 
	    fInfo.setStream(fos);
        return ViewHelper.getFileDownloadView(fInfo);
    }
		
}
