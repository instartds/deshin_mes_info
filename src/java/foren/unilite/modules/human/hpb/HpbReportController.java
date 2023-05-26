package foren.unilite.modules.human.hpb;

import java.util.ArrayList;
import java.util.Calendar;
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
import foren.unilite.utils.AES256DecryptoUtils;

@Controller
public class HpbReportController extends UniliteCommonController {
    @InjectLogger
    public static Logger logger;                                                                                        // = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 현급출납장 출력
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hpb400rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView hpb400rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        
        String[] subReportFileNames = {};
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용     
        
        String rptType = param.get("REPORT_TYPE").toString();//출력선택
        String medType = param.get("MEDIUM_TYPE").toString();//신고서종류
        String fileName = "";
        String strQuery = "hpb400rkrService.";
        String strSubQuery1 = "hpb400rkrService.";
        String strSubQuery2 = "hpb400rkrService.";
        String titleName = "";
        if (!rptType.equals("3")) //0,1,2
        {
            switch (medType) {
                case "1":
                    if (rptType.equals("0")) {
                        fileName = "hpb400rkr1";
                        subReportFileNames = new String[] { "hpb400rkr1sub1", "hpb400rkr1sub2" };
                        strQuery += "selectList1";
                        strSubQuery1 += "selectList1sub1";
                        strSubQuery2 += "selectList1sub2";
                    } else {
                        fileName = "hpb400rkr2";
                        strQuery += "selectList2";
                    }
                break;
                case "2":
                    if (rptType.equals("0")) {
                        fileName = "hpb400rkr3";
                        subReportFileNames = new String[] { "hpb400rkr3sub1", "hpb400rkr3sub2" };
                        strQuery += "selectList3";
                        strSubQuery1 += "selectList3sub1";
                        strSubQuery2 += "selectList3sub2";
                    } else {
                        fileName = "hpb400rkr4";
                        strQuery += "selectList4";
                    }
                break;
                case "3":
                    if (rptType.equals("0")) {
                        fileName = "hpb400rkr5";
                        subReportFileNames = new String[] { "hpb400rkr5sub1", "hpb400rkr5sub2" };
                        strQuery += "selectList5";
                        strSubQuery1 += "selectList5sub1";
                        strSubQuery2 += "selectList5sub2";
                    } else {
                        fileName = "hpb400rkr7";
                        strQuery += "selectList7";
                    }
                break;
                case "4":
                    fileName = "hpb400rkr6";
                    strQuery += "selectList6";
                break;
                
            }
        } else {
            fileName = "hpb400rkr8";
            strQuery += "selectList8";
            
        }
        JasperFactory jf = jasperService.createJasperFactory("hpb400rkr", fileName, param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        jf.addParam("RECE_DATE", param.get("RECE_DATE"));
        jf.addParam("TITLE", rptType);
        //        jf.addParam("SUPP_DATE_FR", param.get("SUPP_DATE_FR"));
        //        jf.addParam("SUPP_DATE_TO", param.get("SUPP_DATE_TO"));
        
        Calendar cal = Calendar.getInstance();
        cal.set(cal.YEAR, Integer.parseInt(param.get("SUPP_DATE_TO").toString().substring(0, 4)));
        cal.set(cal.MONTH, Integer.parseInt(param.get("SUPP_DATE_TO").toString().substring(4, 6)) - 1);
        Integer lastDay = cal.getActualMaximum(cal.DAY_OF_MONTH);
        
        jf.addParam("SUPP_DATE_FR", param.get("SUPP_DATE_FR").toString().substring(0, 6) + "01");
        jf.addParam("SUPP_DATE_TO", param.get("SUPP_DATE_TO").toString().substring(0, 6) + lastDay.toString());
        jf.addParam("TITLE", rptType);
        jf.addParam("INCOME_NAME", param.get("TITLE_NAME"));
        jf.addParam("P_COMP_NAME", param.get("S_COMP_NAME"));
        
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        // Primary data source
        List<Map<String, Object>> rsltList = jasperService.selectList(strQuery, param);
        if (!ObjUtils.isEmpty(rsltList)) {
            for (Map rsltMap : rsltList) {
                String repreNum = (String)rsltMap.get("REPRE_NUM");
                if (ObjUtils.isNotEmpty(repreNum)) {
                    repreNum = decrypto.getDecrypto("1", repreNum);
                    if (repreNum.length() == 13) {
                        repreNum = repreNum.substring(0, 6) + "-" + repreNum.substring(6, 13);
                    }
                    rsltMap.put("REPRE_NUM", repreNum);
                } else {
                    rsltMap.put("REPRE_NUM", "");
                }
            }
        }
        jflist.addAll(rsltList);
        //    	jflist.addAll(jasperService.selectList(strQuery, param));
        
        if (subReportFileNames.length > 0) {
            List<Map<String, Object>> rsltSubList1 = jasperService.selectList(strSubQuery1, param);
            if (!ObjUtils.isEmpty(rsltSubList1)) {
                for (Map rsltSubMap1 : rsltSubList1) {
                    String repreNum1 = (String)rsltSubMap1.get("REPRE_NUM");
                    if (ObjUtils.isNotEmpty(repreNum1)) {
                        repreNum1 = decrypto.getDecrypto("1", repreNum1);
                        if (repreNum1.length() == 13) {
                            repreNum1 = repreNum1.substring(0, 6) + "-" + repreNum1.substring(6, 13);
                        }
                        rsltSubMap1.put("REPRE_NUM", repreNum1);
                    } else {
                        rsltSubMap1.put("REPRE_NUM", "");
                    }
                }
            }
            jf.addSubDS("DS_SUB01", rsltSubList1);
            
            List<Map<String, Object>> rsltSubList2 = jasperService.selectList(strSubQuery2, param);
            if (!ObjUtils.isEmpty(rsltSubList2)) {
                for (Map rsltSubMap2 : rsltSubList2) {
                    String repreNum2 = (String)rsltSubMap2.get("REPRE_NUM");
                    if (ObjUtils.isNotEmpty(repreNum2)) {
                        repreNum2 = decrypto.getDecrypto("1", repreNum2);
                        if (repreNum2.length() == 13) {
                            repreNum2 = repreNum2.substring(0, 6) + "-" + repreNum2.substring(6, 13);
                        }
                        rsltSubMap2.put("REPRE_NUM", repreNum2);
                    } else {
                        rsltSubMap2.put("REPRE_NUM", "");
                    }
                }
            }
            jf.addSubDS("DS_SUB02", rsltSubList2);
            
            //    		jf.addSubDS("DS_SUB01", jasperService.selectList(strSubQuery1, param));	
            //    		jf.addSubDS("DS_SUB02", jasperService.selectList(strSubQuery2, param));	
        }
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    
}
