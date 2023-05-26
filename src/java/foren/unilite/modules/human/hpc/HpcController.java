package foren.unilite.modules.human.hpc;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

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
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;
import foren.unilite.modules.human.hpa.Hpa950skrServiceImpl;

/**
 * 프로그램명 : 작업지시조정 작 성 자 : (주)포렌 개발실
 */
@Controller
@SuppressWarnings( "rawtypes" )
public class HpcController extends UniliteCommonController {
 
    private final Logger           logger   = LoggerFactory.getLogger(this.getClass());

    final static String            JSP_PATH = "/human/hpc/";

    /**
     * 서비스 연결
     */
    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;

   
    @Resource( name = "hpc950ukrService" )
    private Hpc950ukrServiceImpl   hpc950ukrService;

    @Resource( name = "hpc952ukrService" )
    private Hpc952ukrServiceImpl   hpc952ukrService;
    
    @Resource( name = "hpcExcelService" )
    private HpcExcelServiceImpl   HpcExcelService;
    
    /**
     * 홈텍스-원천징수이행상황전자신고
     *
     * @param _req
     * @param loginVO
     * @param listOp
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpc950ukr.do" )
    public String hpa990ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

        param.put("S_COMP_CODE", loginVO.getCompCode());

        //원천징수 년월 가져오기 (HBS130T)
        Map selectDefaultTaxYM = (Map)hpc950ukrService.selectDefaultTaxYM(param);
        model.addAttribute("selectDefaultTaxYM", ObjUtils.getSafeString(selectDefaultTaxYM.get("TAX_YYYYMM")));
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        cdo = codeInfo.getCodeInfo("H239", "10");
        if (!ObjUtils.isEmpty(cdo)) {
        	model.addAttribute("gsPayDateOpt", ObjUtils.getSafeString(cdo.getRefCode1(), "2")); //1:귀속연월,지급연월 동일  2:귀속연월,지급연월+1
        } else {
        	model.addAttribute("gsPayDateOpt", "2");
        }

        return JSP_PATH + "hpc950ukr";
    }

    
  //원친징수이행상황신고서 파일생성
  	@RequestMapping(value="/human/hpc950ukrcreateFileDown.do", method = RequestMethod.POST)
  	public ModelAndView  fileDown2(ExtHtttprequestParam req, LoginVO user) throws Exception {

  		Map<String, Object> spParam = req.getParameterMap();	

  		spParam.put("COMP_CODE", user.getCompCode());		
  		
  		Map<String, Object>  spResult = hpc950ukrService.createFileExec(spParam, user);
  		
  		String returnText = (String) spResult.get("RETURN_TEXT");
  		String errorDesc = (String) spResult.get("ERROR_DESC");

  		if(!ObjUtils.isEmpty(errorDesc)){			
  		    throw new  UniDirectValidateException(errorDesc);		
  		}	
  		
  		String fileName = spParam.get("WORK_DATE") + ".201";
  		
  		File dir = new File("C:/txtFile");
  		if(!dir.exists())  dir.mkdir();
          FileDownloadInfo fInfo = new FileDownloadInfo("C:/txtFile", fileName);

  		
  		//FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegaplusAccntFile"), fileName); // 파일명 및 파일이 생길 경로지정..
          FileOutputStream fos = new FileOutputStream(fInfo.getFile()); // txt파일을 경로에 생성..
          
          
          String data = returnText;
          if(data != null)	{
	          logger.info("data :: \n" + data);
	          String[] sdata = data.split("\r");
	          logger.info("sdata.length " + sdata.length);
	          for (int i = 0; i < sdata.length; i++) {
	              fos.write(sdata[i].getBytes("euckr"));  //국세청 자료 신고용 ansi용 파일 저장..
	              fos.write("\r\n".getBytes());
	          }
          } 
          fos.flush();
          fos.close();
          fInfo.setStream(fos);
  	  
  	    return ViewHelper.getFileDownloadView(fInfo);
  	
  	}
  	
  	 @RequestMapping( value = "/human/hpc952ukr.do" )
     public String hpa994ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
         //S_COMP_CODE 가져오기
         final String[] searchFields = {};
         NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
         LoginVO session = _req.getSession();
         Map<String, Object> param = navigator.getParam();
         String page = _req.getP("page");

         param.put("S_COMP_CODE", loginVO.getCompCode());

         //소속지점 콤보 가져오는 쿼리 호출
         model.addAttribute("getBussOfficeCode", hpc952ukrService.getBussOfficeCode(param));

         return JSP_PATH + "hpc952ukr";
     }
  	 
 	@ResponseBody
 	@RequestMapping(value = "/human/hpc950ukrExcelDown.do")
 	public ModelAndView hpa990ukrDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	
 		Map<String, Object> paramMap = _req.getParameterMap();
 		Workbook wb = HpcExcelService.makeExcel(paramMap);
         String title = "원천징수이행전자신고서";
         
         return ViewHelper.getExcelDownloadView(wb, title);
 	}
}
