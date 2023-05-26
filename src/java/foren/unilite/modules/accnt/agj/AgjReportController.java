package foren.unilite.modules.accnt.agj;

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
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

import java.util.Random;
@Controller
public class AgjReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    
	  /**
	   * 전표 가로 1장모드
	   * @param _req
	   * @return
	   * @throws Exception
	   */
       @RequestMapping(value = "/agj/agj270rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView agj270rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
        		   //"agj270rkr_sub01",
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            param.put("COMP_NAME", user.getCompName());
            
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            
            JasperFactory jf = null;
            
            /* 전표 출력 */
            logger.debug("@@@@@@@@@@@@@@@@@ PRINT_TYPE : "+param.get("PRINT_TYPE"));
            if("P1".equals(param.get("PRINT_TYPE"))){
            	jf  = jasperService.createJasperFactory("agj270rkr", "agj270rkr_P1",  param);		// 세로 2장 모드 귀속부서와 귀속 사업장을 관리한다 ( 개발 중단 )
            }else if("P2".equals(param.get("PRINT_TYPE"))){
            	jf  = jasperService.createJasperFactory("agj270rkr", "agj270rkr_P2",  param);		// 세로 2장 모드 귀속부서와 귀속 사업장을 관리한다 ( 개발 중단 )
            }else if("P3".equals(param.get("PRINT_TYPE"))){
            	param.put("PT_TITLENAME", "전 표");
            	jf  = jasperService.createJasperFactory("agj270rkr", "agj270rkr_P3",  param);		// 세로 1장 모드 귀속부서와 귀속 사업장을 관리한다
            }else if("P4".equals(param.get("PRINT_TYPE"))){
            	param.put("PT_TITLENAME", "전 표");
            	jf  = jasperService.createJasperFactory("agj270rkr", "agj270rkr_P4",  param);		// 세로 1장 모드 귀속부서와 귀속 사업장을 관리 안한다
            }else if("L1".equals(param.get("PRINT_TYPE"))){
            	param.put("PT_TITLENAME", "전 표");
            	jf  = jasperService.createJasperFactory("agj270rkr", "agj270rkr_L1",  param);		// 가로 1장 모드 귀속부서와 귀속 사업장을 관리한다
            }else if("L2".equals(param.get("PRINT_TYPE"))){
            	param.put("PT_TITLENAME", "전 표");
            	jf  = jasperService.createJasperFactory("agj270rkr", "agj270rkr_L2",  param);		// 가로 1장 모드 귀속부서와 귀속 사업장을 관리 안한다
            }
            
            /* 분개장 출력 */
            
            
            /* 집계표 출력 */
            else if("S3".equals(param.get("PRINT_TYPE"))){
            	jf  = jasperService.createJasperFactory("agj270rkr", "agj270rkr_S3",  param);		// 집계표 출력 세로 ( 세로 or 여부 없음, 귀속부서 귀속 사업장 없음)
            }	
            
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            // Primary data source
            
            String acDate  = "";
            String keyDate = "";
            String keyNum  = "";
            
            if(ObjUtils.isNotEmpty(param.get("AC_DATE"))){
            	acDate = ObjUtils.getSafeString(param.get("AC_DATE"));      	
            }
            /*
            if(ObjUtils.isNotEmpty(param.get("KEY_DATE"))){
            	keyDate = ObjUtils.getSafeString(param.get("KEY_DATE"));      	
            }
            if(ObjUtils.isNotEmpty(param.get("KEY_NUM"))){
            	keyNum = ObjUtils.getSafeString(param.get("KEY_NUM"));      	
            }
            
            Random random = new Random();
            float KEY_VALUE = random.nextFloat();  		// 랜덤키 생성
*/            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

    
            	Map dataParam = new HashMap(); 	
            	
            	dataParam.put("S_COMP_CODE"	, param.get("COMP_CODE"));
            	dataParam.put("COMP_NAME"	, param.get("COMP_NAME"));
            	dataParam.put("SLIP_DIVI"	, param.get("SLIP_DIVI"));
            	dataParam.put("SLIP_NAME"	, param.get("SLIP_NAME"));
            	
            	dataParam.put("FR_AC_DATE"	, param.get("FR_AC_DATE"));		// 2016.10.17 전표 집계표 전표일자 FROM ~ TO 로 인해 추가
            	dataParam.put("TO_AC_DATE"	, param.get("TO_AC_DATE"));
            	
            	dataParam.put("PGM_ID"		, param.get("PGM_ID"));
            	
        		String[] arry  = acDate.split(",");
        	    dataParam.put("AC_DATE" 	, arry);
        	    
        	    dataParam.put("KEY_VALUE", param.get("KEY_VALUE"));
//        	    
//        	    String divCode = ObjUtils.getSafeString(param.get("DIV_CODE"));
//                if(divCode != null){
//                    String[] arry2 = divCode.split(",");
//                    dataParam.put("DIV_CODE" , arry2);
//                }

            	if(param.get("PRINT_TYPE").equals("S3")){
            		
/*            		for(Map tempParam : jflist ){
            	    	tempParam.put("KEY_VALUE", KEY_VALUE);
            	    	tempParam.put("AC_DATE", keyDate);
            	    	tempParam.put("SLIP_NUM", keyNum);
            	    	jflist.addAll(jasperService.selectList("agj270rkrServiceImpl.insertLogDetail", tempParam));
            	    }
            	    
            		*/
            		jflist.addAll(jasperService.selectList("agj270rkrServiceImpl.selectSheet", dataParam));
            	}else{
            		jflist.addAll(jasperService.selectList("agj270rkrServiceImpl.selectPrimaryDataList", dataParam));
            	}
            	
            	List<Map<String,Object>> decList = (List<Map<String,Object>>) jasperService.selectList("commonReportServiceImpl.fnInit", param);
            	jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
            	if(ObjUtils.isNotEmpty(decList)){
            	    jf.addParam("GUBUN_FLAG",  decList.get(0).get("GUBUN_FLAG"));
            	}
            
            jf.setList(jflist);

            return ViewHelper.getJasperView(jf);
        }
}
