package foren.unilite.modules.sales.str;

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
@SuppressWarnings({ "rawtypes", "unchecked" })
public class StrReportController  extends UniliteCommonController {
	@InjectLogger
	public static Logger logger  ;// = LoggerFactory.getLogger(this.getClass());
	private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

	
	/**
	 * 거래명세서
	 * @param _req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/str/str400rkrPrint.do", method = RequestMethod.GET)
	public ModelAndView str400rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
		String[] subReportFileNames = {
		};

		// Report와 SQL용 파라미터 구성
		Map param = _req.getParameterMap();
		param.put("COMP_CODE", user.getCompCode());

		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용			
		JasperFactory jf  = jasperService.createJasperFactory("str400rkr", param);
		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		jf.setSubReportFiles(subReportFileNames);

		/* String imgUrl = "http://"+request.getServerName();
		if(ObjUtils.isNotEmpty(request.getServerPort())) {
			imgUrl +=":"+request.getServerPort();
		}
		if(ObjUtils.isNotEmpty(request.getContextPath())) {
			imgUrl +="/"+request.getContextPath();
		}
		imgUrl +="/sales/stampPhoto/";

		// 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)
		jf.addParam("IMAGE_PATH", imgUrl);*/

		jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));

		// Primary data source
		logger1.debug("jasper String : " + param.get("INOUT_NUM").toString());

		String[] arry = ObjUtils.getSafeString(param.get("INOUT_NUM")).split(",");
//		for(int i = 0; arry.length <= i; i++){
//			arry[i] = arry[i];
//		}
		List<String> dataList = new ArrayList<String>();

		for(String inOutNum : arry){
			((List<String>) dataList).add(inOutNum);
		}

		List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
//		List<String> inoutNumList = null;
//			for (int i = 0 ; arry.length > i ; i++){
//				List<Map<String, Object>> inoutNumListl;
//				inoutNumListl.add(arry[i]);
//			}
		Map dataParam = new HashMap();
		dataParam.put("DIV_CODE", param.get("DIV_CODE"));
		dataParam.put("INOUT_NUM", arry);
		dataParam.put("OUTPUT_CONTROL", param.get("OUTPUT_CONTROL"));
		dataParam.put("DEPT_CODE", param.get("DEPT_CODE"));
		dataParam.put("USER_ID", param.get("USER_ID"));
		dataParam.put("COMP_CODE", param.get("COMP_CODE"));
		jflist.addAll(jasperService.selectList("str400rkrvServiceImpl.selectPrimaryDataList", dataParam));
//		if(param.get("OUTPUT_CONTROL") == "1"){
//			dataParam.put("OUTPUT_CONTROL",'A');
//		}
//		else if(param.get("OUTPUT_CONTROL") == "1"){
//			dataParam.put("OUTPUT_CONTROL",'B');
//		}
//		logger1.debug("jasper arry : " + arry[i]);

		jf.setList(jflist);

		// sub report data sources
		// 레포트 자체의 SQL 사용시에만 사용 
		//super.jasperService.setDbConnection(jParam);
		
		//jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
		//jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
		//jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

		return ViewHelper.getJasperView(jf);
	}

	/**
	* @param _req
	* @param zhongshl
	* @param request
	* @param reportType
	* @return
	* @throws Exception
	*/
	@RequestMapping(value = "/str/str400rkrPrint1.do", method = RequestMethod.GET)
	public ModelAndView str400rkrPrint1(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
		String[] subReportFileNames = {
		};

		// Report와 SQL용 파라미터 구성
		Map param = _req.getParameterMap();
		param.put("COMP_CODE", user.getCompCode());
		
		
		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용			
		JasperFactory jf  = jasperService.createJasperFactory("str400rkr","str400rkr1", param);
		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		jf.setSubReportFiles(subReportFileNames);
		jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
		
		List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
		jflist.addAll(jasperService.selectList("str400rkrvServiceImpl.selectPrintList", param));
		jf.setList(jflist);

		return ViewHelper.getJasperView(jf);
	}
}
