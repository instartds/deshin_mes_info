package foren.unilite.modules.coop.sva;

import java.io.File;
import java.util.*;

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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class SvaReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    
    /**
     * 거래명세서
     * (거래건별 매출현황조회 - 영수증별 상세내역조회 )
     * @param _req
     * @return
     * @throws Exception
     */
   @RequestMapping(value = "/sva/sva220rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView sva220rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {
       };
       
       // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf  = jasperService.createJasperFactory("sva220rkr", param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        
        String posCode = ObjUtils.getSafeString(param.get("POS_CODE"));
        
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        
        	Map dataParam = new HashMap();
        	dataParam.put("S_COMP_CODE"	, user.getCompCode());
        	dataParam.put("S_COMP_NAME"	, user.getCompName());
        	dataParam.put("DIV_CODE"	, param.get("DIV_CODE"));
        	dataParam.put("ITEM_CODE"	, param.get("ITEM_CODE"));
        	dataParam.put("ITEM_NAME"	, param.get("ITEM_NAME"));
        	dataParam.put("INOUT_DATE_FR", param.get("INOUT_DATE_FR"));
        	dataParam.put("INOUT_DATE_TO", param.get("INOUT_DATE_TO"));             	
         if(posCode != null){
      	   String[] arry  = posCode.split(",");
      	   dataParam.put("POS_CODE" 	, arry);
         }
    	
    	jflist.addAll(jasperService.selectList("Sva220skrvService.selectList", dataParam));

    
    	jf.setList(jflist);


        return ViewHelper.getJasperView(jf);
    }
}
