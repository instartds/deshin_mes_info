package foren.unilite.modules.accnt.ass;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

@Controller
public class AssReportController extends UniliteCommonController {
	@InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 현급출납장 출력
     * @param _req
     * @return
     * @throws Exception
     */
   @RequestMapping(value = "/ass/ass600rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView ass600rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {
    		   "top_Payment"
       };
       // Report와 SQL용 파라미터 구성
        Map<String, Object> param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
       
        JasperFactory jf = jasperService.createJasperFactory("ass600rkr", "ass600rkr",  param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
       
        String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
        if(accntDivCode != null){
        	String[] arry = accntDivCode.split(",");
        	param.put("ACCNT_DIV_CODE" , arry);
        }
        
        String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
        if(accntDivName != null){
        	String[] arry1 = accntDivName.split(",");
        	param.put("ACCNT_DIV_NAME" , arry1);
        }
        
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
        String dateString = formatter.format(date);
        String term = dateString.substring(0, 4);
        jf.addParam("P_TERM", term+".01.01"+" ~ "+term+".12.31");
    	jflist.addAll(jasperService.selectList("ass600rkrServiceImpl.selectList", param));
       
        jf.setList(jflist);
        param.put("PGM_ID","ass600rkr");
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	

        return ViewHelper.getJasperView(jf);
    }
}
