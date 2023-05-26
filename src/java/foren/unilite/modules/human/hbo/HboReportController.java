package foren.unilite.modules.human.hbo;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
@Controller
public class HboReportController extends UniliteCommonController {
	
		@Resource(name="hbo800rkrService")
		private Hbo800rkrServiceImpl hbo800rkrService;
	   /**
	    * 
	    * @param _req
	    * @param user
	    * @param request
	    * @param reportType
	    * @return
	    * @throws Exception
	    */
        @RequestMapping(value = "/hbo/hbo800rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView hbo800rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = new String[2];
           subReportFileNames[0]= "top_Payment";
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            
            JasperFactory jf = null;
            String docKind = param.get("DOC_KIND")+"";
            if("1".equals(docKind)){
         	   jf  = jasperService.createJasperFactory("hbo800rkr", "hbo800kr",  param);   // "폴더명" , "파일명" , "파라미터
         	   subReportFileNames[1]="hbo800kr_sub";
            }else if("2".equals(docKind)){
         	   jf  = jasperService.createJasperFactory("hbo800rkr", "hbo801kr",  param);
         	   subReportFileNames[1]="hbo801kr_sub";
            }else if("3".equals(docKind)){
          	   jf  = jasperService.createJasperFactory("hbo800rkr", "hbo802kr",  param);
          	   subReportFileNames[1]="hbo800kr_sub";
             }else if("4".equals(docKind)){
           	   jf  = jasperService.createJasperFactory("hbo800rkr", "hbo810kr",  param);
          	   subReportFileNames[1]="hbo810kr_sub";
             }
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
            jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
            
            hbo800rkrService.initPrintData(param,user);
            
            // Primary data source
            jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
            jf.addSubDS("DS_SUB02", jasperService.selectList("hbo800rkrServiceImpl.selectSubData", param));
            
            jf.setList(jasperService.selectList("hbo800rkrServiceImpl.selectMainData", param));

            return ViewHelper.getJasperView(jf);
        }

}
