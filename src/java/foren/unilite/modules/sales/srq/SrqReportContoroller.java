package foren.unilite.modules.sales.srq;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

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

@Controller
public class SrqReportContoroller extends UniliteCommonController {

	/**
     * 发货指示输出
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/srq/srq200rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView selectReportList(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        String[] subReportFileNames = {
        		"top_Payment"
        };
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf  = jasperService.createJasperFactory("srq200rkr", param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

        jflist.addAll(jasperService.selectList("srq200rkrvServiceImpl.selectList", param));
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        jf.addParam("P_S_COMP_NAME", user.getCompCode());
        jf.addParam("DIV_CODE", param.get("DIV_CODE"));
        jf.addParam("CUSTOM_NAME", param.get("CUSTOM_NAME"));
        jf.addParam("Instructions", param.get("Instructions"));      
        jf.addParam("COUNT_DATE", param.get("COUNT_DATE"));
        jf.setList(jflist);

        return ViewHelper.getJasperView(jf);

    }
}
