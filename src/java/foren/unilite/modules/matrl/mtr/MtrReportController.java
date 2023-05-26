package foren.unilite.modules.matrl.mtr;

import java.util.ArrayList;
import java.util.HashMap;
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
public class MtrReportController extends UniliteCommonController {
	
	@InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());
    
    @RequestMapping(value = "/mtr/mtr170rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView mtr170rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {
       };
       
       // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
		param.put("VIEW_OPT", param.get("VIEW_OPT")==null?"1":param.get("VIEW_OPT"));
		param.put("ITEM_LEVEL1", param.get("ITEM_LEVEL1")==null?"":param.get("ITEM_LEVEL1"));
		param.put("ITEM_LEVEL2", param.get("ITEM_LEVEL2")==null?"":param.get("ITEM_LEVEL2"));
		param.put("ITEM_LEVEL3", param.get("ITEM_LEVEL3")==null?"":param.get("ITEM_LEVEL3"));
		param.put("CREATE_LOC",  param.get("CREATE_LOC")==null?"":param.get("CREATE_LOC"));
		param.put("EXPENSE_YN", param.get("EXPENSE_YN")==null?"N":param.get("EXPENSE_YN"));
		param.put("INOUT_PRSN", param.get("INOUT_PRSN")==null?"":param.get("INOUT_PRSN"));
//		return  super.commonDao.list("mtr170skrvServiceImpl.selectList", param);
        
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf  = jasperService.createJasperFactory("mtr170rkr","mtr170rkr", param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
    	jf.setList(jasperService.selectList("mtr170skrvServiceImpl.selectList", param));
    	jf.addParam("YYYYMM", param.get("BASIS_YYYYMM"));
    	if("1".equals(param.get("GUBUN"))){
    		jf.addParam("TITLE1", "품목코드");
    		jf.addParam("TITLE2", "품목명");
    	} else {
    		jf.addParam("TITLE1", "거래처코드");
    		jf.addParam("TITLE2", "거래처명");
    	}
        return ViewHelper.getJasperView(jf);
    }
    
    
}
