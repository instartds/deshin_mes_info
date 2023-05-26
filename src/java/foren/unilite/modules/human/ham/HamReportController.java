package foren.unilite.modules.human.ham;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
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
import foren.unilite.modules.human.hum.HumController;
import foren.unilite.utils.AES256DecryptoUtils;

@Controller
public class HamReportController extends UniliteCommonController {
    @InjectLogger
    public static Logger         logger;          // = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "ham910rkrService" )
    private Ham910rkrServiceImpl ham910rkrService;
    
    /**
     * 비정규직 인사기록 카드 출력(PDF) 단건
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/ham100ukrPrint.do", method = RequestMethod.GET )
    public ModelAndView ham100ukrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "ham100ukr_sub01" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("COMP_CODE", user.getCompCode());
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf = jasperService.createJasperFactory("ham100ukr", param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)          
        jf.addParam("HUMAN_IMAGE_PATH", ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator);
        
        // Primary data source
        jf.setList(jasperService.selectList("ham100ukrServiceImpl.select", param));
        
        // sub report data sources
        jf.addSubDS("DS_SUB01", jasperService.selectList("ham100ukrServiceImpl.select", param));
        
        // 레포트 자체의 SQL 사용시에만 사용 
        //super.jasperService.setDbConnection(jParam);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * 일용근로소득지급조서
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/ham/ham910rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView ham910rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        String[] subReportFileNames = new String[1];
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        
        JasperFactory jf = null;
        if (param.get("DOC_KIND").equals("0")) {
            jf = jasperService.createJasperFactory("ham910rkr", "ham911rkr", param);   // "폴더명" , "파일명" , "파라미터
            subReportFileNames[0] = "ham911rkr_sub01";
        } else if (param.get("DOC_KIND").equals("1")) {
            jf = jasperService.createJasperFactory("ham910rkr", "ham910rkr", param);
            subReportFileNames[0] = "ham910rkr_sub01";
        } else if (param.get("DOC_KIND").equals("2")) {
            jf = jasperService.createJasperFactory("ham910rkr", "ham910rkr", param);
            subReportFileNames[0] = "ham910rkr_sub01";
        }
        
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)        
        jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        // Primary data source
        
        String deptCode = ObjUtils.getSafeString(param.get("DEPT_CODE"));
        if (deptCode != null) {
            String[] arry = deptCode.split(",");
            param.put("DEPT_CODE", arry);
        }
        
        /* VB 로직 */
        String quarterType = "";
        String pMonth1 = "";
        String pMonth3 = "";
        String payYYYY = "";
        
        quarterType = ObjUtils.getSafeString(param.get("QUARTER_TYPE"));
        payYYYY = ObjUtils.getSafeString(param.get("PAY_YYYY"));
        
        if (quarterType == "1") {
            pMonth1 = payYYYY + "01";
            pMonth3 = payYYYY + "03";
        } else if (quarterType == "2") {
            pMonth1 = payYYYY + "04";
            pMonth3 = payYYYY + "06";
        } else if (quarterType == "3") {
            pMonth1 = payYYYY + "07";
            pMonth3 = payYYYY + "09";
        } else if (quarterType == "4") {
            pMonth1 = payYYYY + "10";
            pMonth3 = payYYYY + "12";
        }
        
        /* VB 로직 끝 */
        
        if (param.get("DOC_KIND").equals("0")) {
            
            List<Map<String, Object>> personNumb5 = ham910rkrService.checkPerson(param);
            
            List newData = new ArrayList();
            int size = personNumb5.size(); // int 5
            
            String temp = "";
            
            for (int i = 0; i < size; i++) {
                temp = (String)personNumb5.get(i).get("PERSON_NUMB");
                newData.add(temp);
            }
            
            param.put("strPer", newData);
            List<Map<String, Object>> list = jasperService.selectList("ham910rkrServiceImpl.fnHam911nQ_2", param);
            if (!ObjUtils.isEmpty(list)) {
                for (Map listMap : list) {
                    if (!ObjUtils.isEmpty(listMap.get("REPRE_NUM"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            String decryRepreNum = decrypto.decryto(listMap.get("REPRE_NUM").toString());
                            listMap.put("REPRE_NUM", decryRepreNum);
                            listMap.put("REPRE_NUM1", decryRepreNum.substring(0, 6));
                            listMap.put("REPRE_NUM2", decryRepreNum.substring(6));
                        } catch (Exception e) {
                            listMap.put("REPRE_NUM", "데이타 오류(" + listMap.get("REPRE_NUM").toString() + ")");
                        }
                    } else {
                        listMap.put("REPRE_NUM", "");
                    }
                }
            }
            if (list != null && list.size() > 0) {
                BigDecimal F_SumSupp = BigDecimal.ZERO, F_Tax_Exemption = BigDecimal.ZERO, F_SumInTax = BigDecimal.ZERO, F_SumLocalTax = BigDecimal.ZERO;
                for (Map map : list) {
                    F_SumSupp = F_SumSupp.add((BigDecimal)map.get("TOTAL_AMOUNT_I"));
                    F_Tax_Exemption = F_Tax_Exemption.add((BigDecimal)map.get("NON_TAX_I"));
                    F_SumInTax = F_SumInTax.add((BigDecimal)map.get("INC_AMOUNT_I"));
                    F_SumLocalTax = F_SumLocalTax.add((BigDecimal)map.get("LOC_AMOUNT_I"));
                }
                jf.addParam("F_SumSupp", F_SumSupp);
                jf.addParam("F_Tax_Exemption", F_Tax_Exemption);
                jf.addParam("F_SumInTax", F_SumInTax);
                jf.addParam("F_SumLocalTax", F_SumLocalTax);
                jf.addParam("F_Count", list.size());
            }
            jf.setList(list);
            List<Map<String, Object>> listSub = jasperService.selectList("ham910rkrServiceImpl.ds_sub01", param);
            if (!ObjUtils.isEmpty(listSub)) {
                for (Map decMap : listSub) {
                    if (!ObjUtils.isEmpty(decMap.get("REPRE_NUM"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("REPRE_NUM", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
                        } catch (Exception e) {
                            decMap.put("REPRE_NUM", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
                        }
                    } else {
                        decMap.put("REPRE_NUM", "");
                    }
                }
            }
            jf.addSubDS("DS_SUB01", listSub);
        }
        
        if (param.get("DOC_KIND").equals("1") || param.get("DOC_KIND").equals("2")) {
            jf.setList(jasperService.selectList("ham910rkrServiceImpl.fnHam910nQ", param));
            List<Map<String, Object>> listSub = jasperService.selectList("ham910rkrServiceImpl.ds_sub02", param);
            if (listSub == null || listSub.size() < 14) {
                int num = 0;
                if (listSub == null) {
                    listSub = new ArrayList<Map<String, Object>>();
                }
                num = listSub.size();
                for (int i = 1; i <= 14 - num; i++) {
                    listSub.add(new HashMap());
                }
                
            }
            jf.addSubDS("DS_SUB02", listSub);
        }
        
        return ViewHelper.getJasperView(jf);
    }
    
}
