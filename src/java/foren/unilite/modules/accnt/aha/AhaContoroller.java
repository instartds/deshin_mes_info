package foren.unilite.modules.accnt.aha;

import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.Workbook;
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
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.busevaluation.gra.GraExcelServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.popup.PopupServiceImpl;


@Controller
public class AhaContoroller extends UniliteCommonController {
	
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@Resource(name="popupService")
	private PopupServiceImpl popupService;
	
	@Resource(name="aha990ukrService")
	private Aha990ukrServiceImpl aha990ukrService;

	@Resource(name="ahaExcelService")
	private AhaExcelServiceImpl ahaExcelService;
	
	@Resource(name="graExcelService")
    private GraExcelServiceImpl excelService;
	
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/accnt/aha/";	

	/**
	 * 관리항목별전표조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/aha990ukr.do")
	public String aha990ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		Map selectDefaultTaxYM = (Map)aha990ukrService.selectDefaultTaxYM(param);
		model.addAttribute("selectDefaultTaxYM", selectDefaultTaxYM.get("TAX_YYYYMM"));		
		
		return JSP_PATH + "aha990ukr";
	}
	
//	@RequestMapping(value = "/accnt/aha990ukr_print.do")
//		public  ModelAndView aha990ukr_print( ExtHtttprequestParam _req) throws Exception {
//		
//	       Workbook wb = ahaExcelService.selectList(_req.getParameterMap());
//	       String title = "원천징수이행상황신고서";
//	       return ViewHelper.getExcelDownloadView(wb, title);
//	}
	
	@RequestMapping(value = "/accnt/aha995skr.do")
	public String aha995skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
//		//신고사업장 정보 가져오기
//		Map param1 = new HashMap();
//		param1.put("DIV_CODE", loginVO.getDivCode());
//		param1.put("S_COMP_CODE", loginVO.getCompCode());
//		Map billDivMap = (Map) accntCommonService.fnGetBillDivCode(param1);
//		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");

		return JSP_PATH + "aha995skr";
	}	
	@RequestMapping(value = "/accnt/aha996skr.do")
    public String aha996skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE",loginVO.getCompCode());
        
        return JSP_PATH + "aha996skr";
    }   
	
	//원친징수이행상황신고서 파일생성
	@RequestMapping(value="/accnt/createWithholdingFile.do", method = RequestMethod.POST)
	public ModelAndView  fileDown2(ExtHtttprequestParam req, LoginVO user) throws Exception {

		Map<String, Object> spParam = req.getParameterMap();	

		spParam.put("COMP_CODE", user.getCompCode());		
		
		Map<String, Object>  spResult = aha990ukrService.createWithholdingFile(spParam, user);
		
		String returnText = (String) spResult.get("RETURN_TEXT");
		//String fileName = (String) spResult.get("COMPANY_NUM");
		String errorDesc = (String) spResult.get("ERROR_DESC");

		if(!ObjUtils.isEmpty(errorDesc)){			
		    throw new  UniDirectValidateException(errorDesc);		
		}	
		
		String fileName = spParam.get("WORK_DATE") + ".201";
		
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegaplusAccntFile"), fileName); // 파일명 및 파일이 생길 경로지정..
        FileOutputStream fos = new FileOutputStream(fInfo.getFile()); // txt파일을 경로에 생성..
        
        String data = returnText;
        logger.info("data :: \n" + data);
        String[] sdata = data.split("\r");
        logger.info("sdata.length " + sdata.length);
        for (int i = 0; i < sdata.length; i++) {
            fos.write(sdata[i].getBytes("euckr"));  //국세청 자료 신고용 ansi용 파일 저장..
            fos.write("\r\n".getBytes());
        }
        fos.close();
//		File dir = new File(ConfigUtil.getUploadBasePath("omegaplusAccntFile"));	//디렉토리 create
//		if(!dir.exists())  dir.mkdir(); 										//디렉토리 없을시 디렉토리 생성
//		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegaplusAccntFile"), fileName);	//파일명 및 파일이 생길 경로 지정..
//		
//		FileOutputStream fos = new FileOutputStream(fInfo.getFile());	//txt파일을 경로에 생성..
//	    String data = returnText;
//	    
//		byte[] bytesArray = data.getBytes();
//	    fos.write(bytesArray);
//	    
//	    fos.flush();
//	    fos.close(); 
//	    fInfo.setStream(fos);
	  
	    return ViewHelper.getFileDownloadView(fInfo);
	
	}
	@RequestMapping(value="/accnt/excelDown.do")
    public  ModelAndView excelDown( ExtHtttprequestParam _req) throws Exception {
        
//	    Workbook wb = excelService.selectList(_req.getParameterMap());
        Workbook wb = ahaExcelService.makeExcel(_req.getParameterMap());
        String title = "원천징수이행상황신고서";
        return ViewHelper.getExcelDownloadView(wb, title);
    }
	
	
}
