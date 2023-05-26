package foren.unilite.modules.accnt.afs;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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
import foren.unilite.modules.base.bor.Bor120ukrvServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.utils.AES256DecryptoUtils;

@Controller
public class AfsReportController extends UniliteCommonController {
    @InjectLogger
    private final Logger          logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "bor120ukrvService" )
    private Bor120ukrvServiceImpl bor120ukrvService;
    
    @RequestMapping( value = "/afs/afs520rkr.do", method = RequestMethod.GET )
    public ModelAndView afs520rkr( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "top_Payment" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        String comp_code = user.getCompCode();
        param.put("COMP_CODE", comp_code);
        
        //        String div_code = user.getDivCode();
        //        param.put("DIV_CODE", div_code);
        
        String[] arr = param.get("ACCNT_DIV_CODE").toString().split(",");
        
        List list = Arrays.asList(arr);
        param.put("ACCNT_DIV_CODE", list);
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf = jasperService.createJasperFactory("afs520rkr", param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        //多营业区id进行排序
        if (arr != null && arr.length > 0) {
            int[] idArr = new int[arr.length];
            for (int i = 0; i < arr.length; i++)
                idArr[i] = Integer.valueOf(arr[i]);
            Arrays.sort(idArr);
            Map divMap = new HashMap<String, Object>();
            divMap.put("DIV_CODE", idArr[0]);
            divMap.put("S_COMP_CODE", param.get("S_COMP_CODE"));
            List<Map<String, Object>> divList = bor120ukrvService.selectList(divMap);
            String suffix = "";
            if (arr.length > 1) suffix = " 외 " + ( arr.length - 1 ) + "개 사업장";
            jf.addParam("DIV_NAME", "어음구분 :   " + divList.get(0).get("DIV_NAME") + suffix);
        } else {
            jf.addParam("DIV_NAME", "");
        }
        
        // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)          
        //jf.addParam("pos_IMAGE_PATH", ConfigUtil.getUploadBasePath(PosController.FILE_TYPE_OF_PHOTO) + File.separator);
        jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        jf.addParam("COMP_NAME", user.getCompName());
        
        //加入时间区间参数
        String date = param.get("AC_DATE").toString();
        StringBuffer strBuf = new StringBuffer(date);
        strBuf.insert(4, '.');
        strBuf.insert(7, '.');
        jf.addParam("AC_DATE", strBuf.toString());
        // Primary data source
        jf.setList(jasperService.selectList("afs520skrServiceImpl.selectList", param));
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        // sub report data sources
        
        // 레포트 자체의 SQL 사용시에만 사용 
        //super.jasperService.setDbConnection(jParam);
        
        //jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
        // jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
        // jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/afs/afs510rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView afs510rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "top_Payment" };
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        String fileName = "afs510rkr";
        if ("1".equals(param.get("CHK_TERM"))) {
            fileName = "afs511rkr";
        }
        
        JasperFactory jf = jasperService.createJasperFactory("afs510rkr", fileName, param);   // "폴더명" , "파일명" , "파라미터
        String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
        if (accntDivCode != null) {
            String[] arry = accntDivCode.split(",");
            param.put("ACCNT_DIV_CODE", arry);
        }
        String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
        if (accntDivName != null) {
            String[] arry1 = accntDivName.split(",");
            param.put("ACCNT_DIV_NAME", arry1);
        }
        
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        List<Map<String, Object>> list = jasperService.selectList("afs510rkrServiceImpl.selectListToPrint", param);
        
        param.put("PGM_ID", "afs510rkr");
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        
        jflist.addAll(list);
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * 예차입금현황표
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/afs/afs530rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView afs530rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "top_Payment" };
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        String comp_code = user.getCompCode();
        param.put("COMP_CODE", comp_code);
        
        String[] arr = param.get("ACCNT_DIV_CODE").toString().split(",");
        
        List list = Arrays.asList(arr);
        param.put("ACCNT_DIV_CODE", list);
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf = jasperService.createJasperFactory("afs530rkr", param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)          
        //jf.addParam("pos_IMAGE_PATH", ConfigUtil.getUploadBasePath(PosController.FILE_TYPE_OF_PHOTO) + File.separator);
        //	        jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        
        jf.addParam("AC_DATE_FR", param.get("AC_DATE_FR"));
        jf.addParam("AC_DATE_TO", param.get("AC_DATE_TO"));
        jf.addParam("COMP_NAME", user.getCompName());
        
        List<Map<String, Object>> rsltList = jasperService.selectList("afs530skrServiceImpl.selectList", param);
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (!ObjUtils.isEmpty(rsltList)) {
            for (Map rsltMap : rsltList) {
                String accntNum = (String)rsltMap.get("BANK_ACCOUNT");
                if (ObjUtils.isNotEmpty(accntNum)) {
                    rsltMap.put("BANK_ACCOUNT", decrypto.getDecrypto("1", accntNum));
                } else {
                    rsltMap.put("BANK_ACCOUNT", "");
                }
            }
        }
        
        jf.setList(rsltList);
        
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        // sub report data sources
        
        // 레포트 자체의 SQL 사용시에만 사용 
        //super.jasperService.setDbConnection(jParam);
        
        //jf.addSubDS("DS_SUB01", jasperService.selectList("afs530skrServiceImpl.DS_SUB01", param));
        
        return ViewHelper.getJasperView(jf);
    }
}
