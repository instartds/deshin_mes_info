package foren.unilite.modules.z_yp;

import java.io.DataOutputStream;
import java.io.File;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.human.hpa.Hpa900rkrServiceImpl;
import foren.unilite.modules.matrl.mms.Mms210skrvServiceImpl;
import foren.unilite.modules.z_mit.S_pmp110ukrv_mitServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_ypClipReportController	extends UniliteCommonController {
 @InjectLogger
	public static Logger logger;
	final static String CRF_PATH = "Clipreport4/Z_yp/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "s_pmp110ukrv_ypService" )			//20210830 추가
	private S_pmp110ukrv_ypServiceImpl s_pmp110ukrv_ypService;

	@Resource( name = "s_pmp111ukrv_ypService" )
	private S_pmp111ukrv_ypServiceImpl s_pmp111ukrv_ypService;

	@Resource( name = "s_sof100skrv_ypService" )			//20210915 추가
	private S_sof100skrv_ypServiceImpl s_sof100skrv_ypService;

	/**
	 * 친환경 라벨 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmp111clrkrv_yp.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp111clrkrv_ypPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		 ClipReportDoc doc = new ClipReportDoc();

		  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		  CodeDetailVO cdo = null;

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String crfFile = null;

			crfFile = CRF_PATH + "s_pmp111clrkrv_yp.crf";

			String[] orderNumArry		= param.get("ORDER_NUM").toString().split(",");
			String[] sernoArry			= param.get("SERNO").toString().split(",");
			String[] lotnoArry			= param.get("LOT_NO").toString().split(",");
			String[] prodtYearArry		= param.get("PRODT_YEAR").toString().split(",");
			String[] labelqArry			= param.get("LABEL_Q").toString().split(",");
			String[] originArry			= param.get("ORIGIN").toString().split(",");
			String[] prdcerCertNoArry	= param.get("PRDCER_CERT_NO").toString().split(",");


			List<Map> orderNumSeqList = new ArrayList<Map>();

			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();

				Object SELECT_ORDER_NUM 	 =  orderNumArry[i];
				Object SELECT_SERNO 		 =  sernoArry[i];
				Object SELECT_LOT_NO   		 =  lotnoArry[i];
				Object SELECT_PRODTYEAR 	 =  prodtYearArry[i];
				Object SELECT_LABEL_Q  		 =  labelqArry[i];
				Object SELECT_ORIGIN 		 =  originArry[i];
				Object SELECT_PRDCER_CERT_NO =  prdcerCertNoArry[i];

				map.put("ORDER_NUM", SELECT_ORDER_NUM);
				map.put("SERNO"	, SELECT_SERNO);
				map.put("LOT_NO"   , SELECT_LOT_NO);
				map.put("PRODT_YEAR", SELECT_PRODTYEAR);
				map.put("LABEL_Q"  , SELECT_LABEL_Q);
				map.put("ORIGIN", SELECT_ORIGIN);
				map.put("PRDCER_CERT_NO"  , SELECT_PRDCER_CERT_NO);
				orderNumSeqList.add(map);
			}

			param.put("ORDER_NUM_PARAMS", orderNumSeqList);


		//Image 경로 
		  String imagePath = doc.getImagePath();

		  //Main Report
		  List<Map<String, Object>> report_data = s_pmp111ukrv_ypService.greenLabelClipPrintList(param);


		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		  String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		  Map<String, Object> rMap = new HashMap<String, Object>();
		  rMap.put("success", "true");
		  rMap.put("resultKey", resultKey);
		  return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 배송분류표 라벨 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmp111clrkrv_yp2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp111clrkrv_yp2Print( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		 ClipReportDoc doc = new ClipReportDoc();

		  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		  CodeDetailVO cdo = null;

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String crfFile = null;

			crfFile = CRF_PATH + "s_pmp111clrkrv_yp2.crf";

			String[] orderNumArry	= param.get("ORDER_NUM").toString().split(",");
			String[] sernoArry		= param.get("SER_NO").toString().split(",");
			String[] packQtyArry	= param.get("PACK_QTY").toString().split(",");
			String[] expDateArry	= param.get("EXP_DATE").toString().split(",");
			String[] prodtYearArry	= param.get("PRODT_YEAR").toString().split(",");
			String[] labelqArry		= param.get("LABEL_Q").toString().split(",");
			String[] orderQArry		= param.get("ORDER_Q").toString().split(",");
			String[] originArry		= param.get("ORIGIN").toString().split(",");

			List<Map> orderNumSeqList = new ArrayList<Map>();
			double packQty = 0;
			int labelQ = 0;
			double remainQ = 0;
			double qtyPerBox	= 0;
			String qtyPerBoxStr = "";
			String extDate = "";

			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();

				Object SELECT_ORDER_NUM 	=  orderNumArry[i];
				Object SELECT_SERNO 		=  sernoArry[i];
				Object SELECT_PACK_QTY 		=  packQtyArry[i];
				Object SELECT_EXP_DATE		=  expDateArry[i];
				Object SELECT_PRODT_YEAR 	=  prodtYearArry[i];
				Object SELECT_LABEL_Q  		=  labelqArry[i];
				Object SELECT_ORDER_Q  		=  orderQArry[i];
				Object SELECT_ORIGIN  		=  originArry[i];
				map.put("ORDER_NUM"  , SELECT_ORDER_NUM);
				map.put("SER_NO"	     , SELECT_SERNO);
				map.put("PACK_QTY"   , SELECT_PACK_QTY);
				map.put("REMAIN_Q"   , 0);
				map.put("EXP_DATE"   , SELECT_EXP_DATE);
				map.put("PRODT_YEAR"  , SELECT_PRODT_YEAR);
				map.put("LABEL_Q"	, SELECT_LABEL_Q);
				map.put("ORDER_Q"    , SELECT_ORDER_Q);
				map.put("ORIGIN"    , SELECT_ORIGIN);

				remainQ = ObjUtils.parseDouble(map.get("ORDER_Q"));
				labelQ  = Integer.parseInt(String.valueOf(SELECT_LABEL_Q));
				packQty = Integer.parseInt(String.valueOf(SELECT_PACK_QTY)) ;
				for(int j=0; j < labelQ; j++){
					if(remainQ / packQty >= 1){
            			qtyPerBox = packQty;
            			remainQ = remainQ - packQty;
            			//qtyPerBoxStr = ObjUtils.getSafeString(qtyPerBox);
            			qtyPerBoxStr = String.format("%.2f", qtyPerBox) ;

            		}else{

            			qtyPerBox = remainQ % packQty ;
            			qtyPerBox = Math.round(qtyPerBox * 100d) / 100d;  //소수 둘째자리 반올림
            			qtyPerBoxStr = String.format("%.2f", qtyPerBox) ;
            		}

					map.put("QTY_PER_BOX"    , qtyPerBoxStr);
					map.put("QTY_BOX",Integer.toString((j+1)) + '/' + (String) (SELECT_LABEL_Q ));
					s_pmp111ukrv_ypService.insertLogDetails(map);
				}
				orderNumSeqList.add(map);
			}

			param.put("ORDER_NUM_PARAMS", orderNumSeqList);


		//Image 경로 
		  String imagePath = doc.getImagePath();

		  //Main Report
		  List<Map<String, Object>> report_data = s_pmp111ukrv_ypService.deliveryLabelClipPrintList(param);


		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		  String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		  Map<String, Object> rMap = new HashMap<String, Object>();
		  rMap.put("success", "true");
		  rMap.put("resultKey", resultKey);
		  return ViewHelper.getJsonView(rMap);
	}







	/**
	 * 친환경(소) (s_pmp110ukrv_yp)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmp110clukrv_yp.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_pmp110clukrv_yp(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + "s_pmp111clrkrv_yp.crf";
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] grLabelQ					= param.get("GR_LABEL_Q").toString().split(",");
		String[] wkordNumList				= param.get("WKORD_NUM").toString().split(",");
		param.put("WKORD_NUM", wkordNumList);
		List<Map<String, Object>> rtnList	= s_pmp110ukrv_ypService.makeGreen01Label(param);
		int labelQ							= 0;
		Map insertMap						= new HashMap();

		for(Map rtnListMap : rtnList ){
			for(int k=0; k<wkordNumList.length; k++){
				if(( ObjUtils.getSafeString(wkordNumList[k]).equals(ObjUtils.getSafeString(rtnListMap.get("WKORD_NUM"))))){
					labelQ = ObjUtils.parseInt(grLabelQ[k]);
				}
			}
			for(int j=0; j<labelQ; j++){
				insertMap.put("COMP_NAME"		, rtnListMap.get("COMP_NAME"));
				insertMap.put("COMP_CERF_CODE"	, rtnListMap.get("COMP_CERF_CODE"));
				insertMap.put("TELEPHON"		, rtnListMap.get("TELEPHON"));
				insertMap.put("ADDR"			, rtnListMap.get("ADDR"));
				insertMap.put("ITEM_NAME"		, rtnListMap.get("ITEM_NAME"));
				insertMap.put("PRODT_PERSON"	, rtnListMap.get("PRODT_PERSON"));
				insertMap.put("PRODT_YEAR"		, rtnListMap.get("PRODT_YEAR"));
				insertMap.put("SALE_UNIT"		, rtnListMap.get("SALE_UNIT"));
				insertMap.put("CUSTOM_NAME"		, rtnListMap.get("CUSTOM_NAME"));
				insertMap.put("CENTER"			, rtnListMap.get("CENTER"));
				insertMap.put("BARCODE"			, rtnListMap.get("BARCODE"));
				insertMap.put("MANAGE_NO"		, rtnListMap.get("MANAGE_NO"));
				s_pmp110ukrv_ypService.insertPrintData(insertMap);
			}
		}
		//Main Report 데이터 정제
		List<Map<String, Object>> report_data = s_pmp110ukrv_ypService.getGreen02Label(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	/**
	 * 배송분류표 라벨 출력 (s_pmp110ukrv_yp)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_pmp110clukrv_yp2.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_pmp110clukrv_yp2(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + "s_pmp111clrkrv_yp2.crf";
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] labelQList					= param.get("LABEL_Q").toString().split(",");
		String[] packQtyList				= param.get("PACK_QTY").toString().split(",");
		String[] wkordNumList				= param.get("WKORD_NUM").toString().split(",");
		param.put("WKORD_NUM", wkordNumList);
		String qtyFormat					= (String) param.get("QTY_FORMAT");
		int qtyFormatLength					= qtyFormat.substring(5+1).length(); //소수점 지정을 위한 값구하기
		int labelQ							= 0;
		double packQty						= 0;
		double remainQ						= 0;
		double qtyPerBox					= 0;
		List<Map<String, Object>> rtnList	= s_pmp110ukrv_ypService.makeDeliveryLabel(param);
		Map insertMap						= new HashMap();
		for(Map rtnListMap : rtnList ){
			for(int k=0; k<wkordNumList.length; k++){
				if(( ObjUtils.getSafeString(wkordNumList[k]).equals(ObjUtils.getSafeString(rtnListMap.get("WKORD_NUM"))))){
					labelQ	= ObjUtils.parseInt(labelQList[k]);
					packQty	= ObjUtils.parseDouble(packQtyList[k]);
				}
			}
			remainQ = ObjUtils.parseDouble(rtnListMap.get("WKORD_Q"));
			for(int j=0; j<labelQ; j++){
				if(remainQ / packQty >= 1){
					qtyPerBox	= packQty;
					remainQ	= remainQ - packQty;
				}else{
					qtyPerBox = remainQ % packQty ;
					qtyPerBox = Math.round(qtyPerBox * 100d) / 100d;  //소수 둘째자리 반올림
				}
				insertMap.put("CUSTOM_NAME"		, rtnListMap.get("CUSTOM_NAME"));
				insertMap.put("ITEM_NAME"		, rtnListMap.get("ITEM_NAME"));
				insertMap.put("SPEC"			, rtnListMap.get("SPEC"));
				insertMap.put("ORDER_Q"			, String.format("%." + qtyFormatLength + "f", qtyPerBox));
				insertMap.put("BOX_Q"			, (j+1) + "/" + labelQ);
				insertMap.put("DELIVERY_DATE"	, rtnListMap.get("DELIVERY_DATE"));
				insertMap.put("ORDER_DATE"		, rtnListMap.get("ORDER_DATE"));
				insertMap.put("PACK_DATE"		, rtnListMap.get("PACK_DATE"));
				insertMap.put("STORAGE_METHOD"	, rtnListMap.get("STORAGE_METHOD"));
				insertMap.put("EXP_DATE"		, rtnListMap.get("EXP_DATE"));
				insertMap.put("CAR_NUMBER"		, rtnListMap.get("CAR_NUMBER"));
				insertMap.put("ORIGIN"			, rtnListMap.get("ORIGIN"));
				insertMap.put("PRODT_YEAR"		, rtnListMap.get("PRODT_YEAR"));
				insertMap.put("QUALITY_GRADE"	, rtnListMap.get("QUALITY_GRADE"));
				insertMap.put("SUPPLIER"		, rtnListMap.get("SUPPLIER"));
				insertMap.put("PRE_WORK_DATE"	, rtnListMap.get("PRE_WORK_DATE"));
				s_pmp110ukrv_ypService.insertPrint2Data(insertMap);
			}
		}
		//Main Report 데이터 정제
		List<Map<String, Object>> report_data = s_pmp110ukrv_ypService.getDeliveryLabel(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	/**
	 * 거래명세서 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_sof100clrkrv_yp.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_sof100clrkrv_yp(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param = _req.getParameterMap();
		String resultKey = "";

		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		String crfFile		= CRF_PATH + "s_sof100clrkrv_yp.crf";
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data =  s_sof100skrv_ypService.selectPrintList(param);



		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	/**
	 * 납품서 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_sof100clrkrv_yp2.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_sof100clrkrv_yp2(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param = _req.getParameterMap();
		String resultKey = "";

		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		String crfFile		= CRF_PATH + "s_sof100clrkrv_yp2.crf";
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data =  s_sof100skrv_ypService.selectPrintList2(param);



		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	/**
	 * 납품서확인서 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_yp/s_sof100clrkrv_yp3.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_sof100clrkrv_yp3(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param = _req.getParameterMap();
		String resultKey = "";

		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		String crfFile		= CRF_PATH + "s_sof100clrkrv_yp3.crf";
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data =  s_sof100skrv_ypService.selectPrintList3(param);



		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}