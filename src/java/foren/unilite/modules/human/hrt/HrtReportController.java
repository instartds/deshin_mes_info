package foren.unilite.modules.human.hrt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.opensaml.xml.encryption.P;
import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
@Controller
public class HrtReportController extends UniliteCommonController{
	@InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
	
	 /**
     * 
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/human/hrt730rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView hrt730rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
            String[] subReportFileNames = { "top_Payment" };
           
            // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("hrt730rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
         
            // Primary data source
            jf.setList(jasperService.selectList("hrt730rkrServiceImpl.selectToPrint", param));
            
            // sub report data sources
            jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
            
            return ViewHelper.getJasperView(jf);
        }
       
       @RequestMapping(value = "/human/hrt510rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView hrt510rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = { "top_Payment" };
          
           // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           param.put("COMP_CODE", user.getCompCode());
           
           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           JasperFactory jf  = jasperService.createJasperFactory("hrt510rkr", param);
           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           jf.setSubReportFiles(subReportFileNames);
        
           // Primary data source
           List<Map<String, Object>> list = jasperService.selectList("hrt510rkrServiceImpl.selectMaster", param);
           
           // sub report data sources
           for(Map<String, Object> item:list){
        	   param.put("PERSON_NUMB", item.get("PERSON_NUMB"));
        	   List<Map<String, Object>> templist = jasperService.selectList("hrt510rkrServiceImpl.selectSubList", param);
        	   for(int i=0;i<templist.size();i++){
        		   for(Map.Entry<String, Object> entry : templist.get(i).entrySet()){
        			   item.put((i+1)+entry.getKey(), entry.getValue());
        		   }
        	   }
           }
           System.out.println("!@#"+new Gson().toJson(list));
           jf.setList(list);
           
           jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));

           
           return ViewHelper.getJasperView(jf);
       }
       
}
