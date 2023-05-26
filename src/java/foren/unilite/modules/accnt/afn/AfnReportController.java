package foren.unilite.modules.accnt.afn;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class AfnReportController extends UniliteCommonController {
	@InjectLogger
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/afn/afn100rkr.do", method = RequestMethod.GET)
    public ModelAndView ipo100ra1(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {
    		   "top_Payment"
       };
       
       // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("COMP_CODE", user.getCompCode());
        
        //param.put("DIV_CODE", user.getDivCode());
        
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf  = jasperService.createJasperFactory("afn100rkr", param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)          
        //jf.addParam("pos_IMAGE_PATH", ConfigUtil.getUploadBasePath(PosController.FILE_TYPE_OF_PHOTO) + File.separator);
        jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        jf.addParam("COMP_NAME",user.getCompName());
        
        String fr_date = param.get("FR_DATE").toString();
        String to_date = param.get("TO_DATE").toString();
        //加入时间区间参数
        jf.addParam("DATEAREA", fr_date.substring(0, 4)+"."+fr_date.substring(4, 6)+"."+fr_date.substring(6)
        		+" ~ "+to_date.substring(0, 4)+"."+to_date.substring(4, 6)+"."+to_date.substring(6));
        // Primary data source
        List<Map<String, Object>> list = jasperService.selectList("afn100rkrService.selectList", param);
        jf.setList(list);
        // sub report data sources
        
        // 레포트 자체의 SQL 사용시에만 사용 
        //super.jasperService.setDbConnection(jParam);
        
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
       // jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
       // jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

        return ViewHelper.getJasperView(jf);
    }
}
