package foren.unilite.modules.equip.eqt;

import java.io.File;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.human.hum.HumController;

@Controller
public class EqtCrystalReportController extends UniliteCommonController {
	@InjectLogger
	public static   Logger  logger  ;
	final static String            RPT_PATH           = "/WEB-INF/Reports2011/Equit";
	public final static String     FILE_TYPE_OF_PHOTO = "EquipmentPhoto";
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@RequestMapping(value = "/equit/eqt220crkrv.do", method = RequestMethod.GET)
	public ModelAndView eqt220crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		 CrystalReportDoc cDoc = new CrystalReportDoc();
		 CrystalReportFactory clientDoc = null;
	     Map param = _req.getParameterMap();
	     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	     String sql="";
	     
	     ReportUtils.setCreportPram(user, param, dao);
         ReportUtils.setCreportSanctionParam(param, dao);
	     
	     String imagePath = "C:" + ConfigUtil.getUploadBasePath(this.FILE_TYPE_OF_PHOTO) + File.separator;
	        File directory = new File(imagePath);
	        if (!directory.exists()) {
	            directory.mkdirs();
	        }
	        param.put("EQUIP_IMAGE_PATH", imagePath);
	        
	        
	     param.put("IMG_NAME", "");
         param.put("IMG_NAME1", ""); 
         param.put("IMG_NAME2", ""); 
         
         
         Map<String, String> mainImagesMap = new HashMap<String, String>();
         mainImagesMap = (Map) dao.select("eqt220rkrvServiceImpl.images_main", param);
	     if(ObjUtils.isNotEmpty(mainImagesMap)){
	         param.put("IMG_NAME", mainImagesMap.get("IMG_NAME")); 
	     }
	     
         Map<String, String> subImagesMap = new HashMap<String, String>();
      	 subImagesMap = (Map) dao.select("eqt220rkrvServiceImpl.images_sub", param);
	     if(ObjUtils.isNotEmpty(subImagesMap)){
	         param.put("IMG_NAME1", subImagesMap.get("IMG_NAME1")); 
	         param.put("IMG_NAME2", subImagesMap.get("IMG_NAME2")); 
	     }
	     
	     
	     try{
	         sql = dao.mappedSqlString("eqt220rkrvServiceImpl.printList", param);
	         List subReports = new ArrayList();
	         
	         Map<String, String> subMap = new HashMap<String, String>();
	         subMap.put("NAME", "eqr200t_sub.rpt");
	         subMap.put("SQL", dao.mappedSqlString("eqt220rkrvServiceImpl.eqr200t_sub", param));
	         subReports.add(subMap);
	         
	         Map<String, String> subMap2 = new HashMap<String, String>();
	         subMap2.put("NAME", "eqt200t_sub.rpt");
	         subMap2.put("SQL", dao.mappedSqlString("eqt220rkrvServiceImpl.eqt200t_sub", param));
	         subReports.add(subMap2);
	         
	         Map<String, String> subMap3 = new HashMap<String, String>();
             subMap3.put("NAME", "san_top_sub.rpt");
	         subMap3.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	         subReports.add(subMap3);
	        
	         clientDoc = cDoc.generateReport(RPT_PATH+"/eqt220rkrv", "eqt220rkrv", param, sql, subReports, request);
	     }catch (Throwable e2) {
	         e2.printStackTrace();
	     }
	     clientDoc.setPrintFileName("eqt220crkrv");
	     clientDoc.setReportType(reportType);
	     return ViewHelper.getCrystalReportView(clientDoc);
	}
}
