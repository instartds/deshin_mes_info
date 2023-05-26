package foren.unilite.modules.com.report;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileOutputStream;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperPrint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.clipsoft.clipreport.export.option.PDFOption;
import com.clipsoft.clipreport.oof.OOFDocument;
import com.clipsoft.clipreport.server.service.ClipReportExport;

import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.report.CommonReportServiceImpl;
import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.jasperreport.JasperRenderer;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl.*;
import foren.unilite.com.service.impl.TlabCodeService;

public class ReportUtils {
	public static   Logger	logger	= LoggerFactory.getLogger(ReportUtils.class);
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	public final static String FAX_FILE = "fax";


	@Resource(name="commonReportService")
	private CommonReportServiceImpl commonReportService;


	/**
	 * report에 삽입될 image path :(Real path) : WEB-INF/report/image/*.png
	 *                        url :http://domain:port/report/images/) (ReportController 에서 정의)
	 * @param personNumb
	 * @return
	 */
	public static String getImagePath(HttpServletRequest request) {
		  String imgUrl = "http://"+request.getServerName();
		  if(ObjUtils.isNotEmpty(request.getServerPort())) {
		   imgUrl +=":"+request.getServerPort();
		  }
		  if(ObjUtils.isNotEmpty(request.getContextPath())) {
		   imgUrl +="/"+request.getContextPath();
		  }
		  imgUrl +="/report/images/";
		return imgUrl;
	}

	public static boolean savePdf(JasperFactory jParam, String fileSerial) throws Exception{
		boolean r = true;
		JasperPrint jasperPrint = JasperRenderer.generateReport(jParam);
        JasperExportManager.exportReportToPdfFile(jasperPrint ,"C:/FaxClient/SendDoc" + File.separatorChar + jParam.getPrintFileName()+"_"+fileSerial+".pdf");
        r = false;
		return r;
	}
	public static String nvl(Object object) {
		return object == null ? "" : object.toString();
	}
	/**
	 * 레포트에서 공통적인 매개변수 필드 사용관련
	 *  S_FSET_Q                         format관련
	 *  S_FSET_P                         format관련
	 *  S_FSET_I                         format관련
	 *  S_FSET_O                         format관련
	 *  S_FSET_R                         format관련
	 *  sChkValue1_company               회사명
	 *  sChkValue2_page                  페이지번호 인쇄여부
	 *  sChkValue3_decide
	 *  sChkValue4_printDate
	 *  sChkValue5_coverYn
	 *  sTxtValue1_chgPrintDate          출력일
	 *  sTxtValue2_fileTitle             출력타이틀
	 *  FrToDate
	 *  sSan(1)_no                       결재란 갯수
	 *  sSan(2)_po                       결재란 위치
	 *  sSan(3)_title1                                           결재란1컬럼타이틀
	 *  sSan(4)_title2                                           결재란2컬럼타이틀
	 *  sSan(5)_title3                                           결재란3컬럼타이틀
	 *  sSan(6)_title4                                           결재란4컬럼타이틀
	 *  sSan(7)_title5                                           결재란5컬럼타이틀
	 *  sSan(8)_title6                                           결재란6컬럼타이틀
	 *  sSan(9)_title7                                           결재란7컬럼타이틀
	 *  sSan(10)_title8                                         결재란8컬럼타이틀
	 */


	public static void setCreportPram(LoginVO user, Map param,TlabAbstractDAO dao) {
		param.put("user_name", user.getUserName());
	      Map formatParam = (Map) dao.select("commonReportServiceImpl.getCReportFormatParam", param);
	      if(formatParam != null){
	    	  param.put("S_FSET_Q", nvl(formatParam.get("FORMAT_QTY2")));
	    	  param.put("S_FSET_P", nvl(formatParam.get("FORMAT_PRICE2")));
	    	  param.put("S_FSET_I", nvl(formatParam.get("FORMAT_IN2")));
	    	  param.put("S_FSET_O", nvl(formatParam.get("FORMAT_OUT2")));
	    	  param.put("S_FSET_R",nvl(formatParam.get("FORMAT_RATE2")));
	      }else{
	    	  param.put("S_FSET_Q", "0");
	    	  param.put("S_FSET_P", "0");
	    	  param.put("S_FSET_I", "0");
	    	  param.put("S_FSET_O", "0");
	    	  param.put("S_FSET_R", "0");
	      }
	      if("Y".equals(param.get("PT_COMPANY_YN"))){
	    	  param.put("sChkValue1_company", user.getCompName());
	      }else{
	    	  param.put("sChkValue1_company", "");
	      }
	      if("Y".equals(param.get("PT_PAGENUM_YN"))){
	    	  param.put("sChkValue2_page", "TRUE");
	      }else{
	    	  param.put("sChkValue2_page", "");
	      }
	      param.put("sChkValue3_decide", "");
	      param.put("sChkValue4_printDate", "");
	      param.put("sChkValue5_coverYn", "");
	      if("Y".equals(param.get("PT_OUTPUTDATE_YN"))){
	          if(ObjUtils.isEmpty(param.get("PT_OUTPUTDATE"))){
    	    	  SimpleDateFormat matter1=new SimpleDateFormat("yyyy-MM-dd");
    		      String str = matter1.format(new Date());
    		      param.put("sTxtValue1_chgPrintDate", str);
	          }else{
                  param.put("sTxtValue1_chgPrintDate", param.get("PT_OUTPUTDATE"));
	          }
	      }else{
	    	  param.put("sTxtValue1_chgPrintDate", "");
	      }


	      if(ObjUtils.isEmpty(param.get("PT_TITLENAME"))){
	          param.put("sTxtValue2_fileTitle", nvl(param.get("sTxtValue2_fileTitle")));
	      }else{
	          param.put("sTxtValue2_fileTitle",param.get("PT_TITLENAME"));
	      }


	      param.put("FrToDate", "");



	      Map tempMap1 = (Map) dao.select("commonReportServiceImpl.getReportId", param);
	      if(ObjUtils.isNotEmpty(tempMap1)){
		      param.put("RPT_ID1", tempMap1.get("RPT_ID1"));
		      param.put("RPT_ID2", tempMap1.get("RPT_ID2"));
		      param.put("RPT_ID3", tempMap1.get("RPT_ID3"));
		      param.put("RPT_ID4", tempMap1.get("RPT_ID4"));
		      param.put("RPT_ID5", tempMap1.get("RPT_ID5"));
		      param.put("RPT_ID6", tempMap1.get("RPT_ID6"));
		      param.put("RPT_ID7", tempMap1.get("RPT_ID7"));
		      //20200708 추가: 직인 이미지 공통코드에서 가져와서 출력하도록 수정 - default = company_steamp.png
		      param.put("RPT_ID8", tempMap1.get("RPT_ID8"));
	      }else{
	    	  param.put("RPT_ID1", "");
		      param.put("RPT_ID2", "");
		      param.put("RPT_ID3", "");
		      param.put("RPT_ID4", "");
		      param.put("RPT_ID5", "");
		      param.put("RPT_ID6", "");
		      param.put("RPT_ID7", "");
		      //20200708 추가: 직인 이미지 공통코드에서 가져와서 출력하도록 수정 - default = company_steamp.png
		      param.put("RPT_ID8", "");
	      }
	}

	public static void setCreportSanctionParam(Map param, TlabAbstractDAO dao) {
        if(param.get("RPT_ID") == null){
	    	  param.put("RPT_ID",param.get("PGM_ID"));
	    }
		param.put("sChkValue0_sanctionYN",nvl(param.get("PT_SANCTION_YN")));

		/**
		 * clip 레포트 결재란 관련
		 */
		Map clipSanctionMap = (Map) dao.select("commonReportServiceImpl.getSanctionInfo", param);

		if(ObjUtils.isNotEmpty(clipSanctionMap)){
			param.put("PT_SANCTION_NO", nvl(clipSanctionMap.get("PT_SANCTION_NO")));
	    	param.put("PT_SANCTION_NM1", nvl(clipSanctionMap.get("PT_SANCTION_NM1")));
	    	param.put("PT_SANCTION_NM2", nvl(clipSanctionMap.get("PT_SANCTION_NM2")));
	    	param.put("PT_SANCTION_NM3", nvl(clipSanctionMap.get("PT_SANCTION_NM3")));
	    	param.put("PT_SANCTION_NM4", nvl(clipSanctionMap.get("PT_SANCTION_NM4")));
	    	param.put("PT_SANCTION_NM5", nvl(clipSanctionMap.get("PT_SANCTION_NM5")));
	    	param.put("PT_SANCTION_NM6", nvl(clipSanctionMap.get("PT_SANCTION_NM6")));
	    	param.put("PT_SANCTION_NM7", nvl(clipSanctionMap.get("PT_SANCTION_NM7")));
	    	param.put("PT_SANCTION_NM8", nvl(clipSanctionMap.get("PT_SANCTION_NM8")));
	    	param.put("PT_SANCTION_NO_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NO_SEC")));
	    	param.put("PT_SANCTION_NM1_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NM1_SEC")));
	    	param.put("PT_SANCTION_NM2_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NM2_SEC")));
	    	param.put("PT_SANCTION_NM3_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NM3_SEC")));
	    	param.put("PT_SANCTION_NM4_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NM4_SEC")));
	    	param.put("PT_SANCTION_NM5_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NM5_SEC")));
	    	param.put("PT_SANCTION_NM6_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NM6_SEC")));
	    	param.put("PT_SANCTION_NM7_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NM7_SEC")));
	    	param.put("PT_SANCTION_NM8_SEC", nvl(clipSanctionMap.get("PT_SANCTION_NM8_SEC")));
		}else{
	    	param.put("PT_SANCTION_NO", "");
	    	param.put("PT_SANCTION_NM1", "");
	    	param.put("PT_SANCTION_NM2", "");
	    	param.put("PT_SANCTION_NM3", "");
	    	param.put("PT_SANCTION_NM4", "");
	    	param.put("PT_SANCTION_NM5", "");
	    	param.put("PT_SANCTION_NM6", "");
	    	param.put("PT_SANCTION_NM7", "");
	    	param.put("PT_SANCTION_NM8", "");
	    	param.put("PT_SANCTION_NO_SEC", "");
	    	param.put("PT_SANCTION_NM1_SEC", "");
	    	param.put("PT_SANCTION_NM2_SEC", "");
	    	param.put("PT_SANCTION_NM3_SEC", "");
	    	param.put("PT_SANCTION_NM4_SEC", "");
	    	param.put("PT_SANCTION_NM5_SEC", "");
	    	param.put("PT_SANCTION_NM6_SEC", "");
	    	param.put("PT_SANCTION_NM7_SEC", "");
	    	param.put("PT_SANCTION_NM8_SEC", "");
		}




	      Map map = (Map) dao.select("commonReportServiceImpl.getCReportSanctionParam", param);
	      if(map != null){
	    	  param.put("sSan(1)_no","");
		      param.put("sSan(2)_po", "");
		      param.put("sSan(3)_title1", nvl(map.get("PT_SANCTION_NM1")));
		      param.put("sSan(4)_title2", nvl(map.get("PT_SANCTION_NM2")));
		      param.put("sSan(5)_title3", nvl(map.get("PT_SANCTION_NM3")));
		      param.put("sSan(6)_title4", nvl(map.get("PT_SANCTION_NM4")));
		      param.put("sSan(7)_title5", nvl(map.get("PT_SANCTION_NM5")));
		      param.put("sSan(8)_title6", nvl(map.get("PT_SANCTION_NM6")));
		      param.put("sSan(9)_title7", nvl(map.get("PT_SANCTION_NM7")));
		      param.put("sSan(10)_title8", nvl(map.get("PT_SANCTION_NM8")));
	      }else{
	    	  param.put("sSan(1)_no", "");
		      param.put("sSan(2)_po", "");
		      param.put("sSan(3)_title1", "");
		      param.put("sSan(4)_title2", "");
		      param.put("sSan(5)_title3", "");
		      param.put("sSan(6)_title4", "");
		      param.put("sSan(7)_title5", "");
		      param.put("sSan(8)_title6", "");
		      param.put("sSan(9)_title7", "");
		      param.put("sSan(10)_title8", "");
	      }
	}

	  /*clipReport 프로퍼티 경로 가져오기
	   * omegaPlus.xml clipReport 설정이 있어야하고, context별로 가져옴, 없으면 upload/default)
	   */
	public static String clipReportPropertyPath(HttpServletRequest request){
		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		String basePath = ConfigUtil.getString("common.clipreport.basePath");
		String configPath = ConfigUtil.getString("common.clipreport.configPath") ;
		if(basePath != null)	{
			basePath = basePath.replace("/",File.separator);
		}
		if(configPath != null)	{
			configPath = configPath.replace("/",File.separator);
		}
		return  drive +   basePath + contextName +  configPath +  "clipreport4.properties";
	}

	 /*clipReport 프로퍼티 Logo경로 가져오기
	   */
	public static void clipReportLogoPath(Map param, TlabAbstractDAO dao,HttpServletRequest request){
		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		String basePath = ConfigUtil.getString("common.clipreport.basePath");
		String configPath = ConfigUtil.getString("common.clipreport.configPath") ;
		if(basePath != null)	{
			basePath = basePath.replace("/",File.separator);
		}
		if(configPath != null)	{
			configPath = configPath.replace("/",File.separator);
		}
		param.put("logoImagePath", drive +   basePath + contextName +  configPath +  "images\\company_logo.png");  ;
	}

	/*clipReport 프로퍼티 법인도장경로 가져오기
	   */
	public static void clipReportSteampPath(Map param, TlabAbstractDAO dao,HttpServletRequest request){
		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		String basePath = ConfigUtil.getString("common.clipreport.basePath");
		String configPath = ConfigUtil.getString("common.clipreport.configPath") ;
		if(basePath != null)	{
			basePath = basePath.replace("/",File.separator);
		}
		if(configPath != null)	{
			configPath = configPath.replace("/",File.separator);
		}
		//20200708 추가: 직인 이미지 공통코드에서 가져와서 출력하도록 수정 - default = company_steamp.png
		if(ObjUtils.isNotEmpty(param.get("RPT_ID8"))) {
			param.put("steampImagePath", drive +   basePath + contextName +  configPath +  "images\\" + param.get("RPT_ID8"));
		} else {
			param.put("steampImagePath", drive +   basePath + contextName +  configPath +  "images\\company_steamp.png");
		}
	}

	//FAX전송을 위한 클립리포트 PDF파일 FAX전송 서비스 폴더로 복사
	public static void clipReportPdfCopy(File localFileSave, String copyPath, Map param, Map authInfo, TlabAbstractDAO dao, LoginVO user )throws Exception {

			 FileInputStream fis = new FileInputStream(localFileSave);

			 NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication(null, (String) authInfo.get("AUTH1"), (String) authInfo.get("AUTH2"));
			 //String copyPath = "smb://121.170.176.149/pdf_test/111111111122222223333333333333.pdf";
			 //smb://WIN-J6HC0BBQBRN/uploadTest/temp/2021-03-22_거래명세서_오메가+.pdf
	  		 SmbFile sDestFile = null;

	  		 sDestFile = new SmbFile(copyPath, auth);
	  		 SmbFileOutputStream smbfos = new SmbFileOutputStream(sDestFile);

	  		 BufferedInputStream bin = new BufferedInputStream(fis);
			 BufferedOutputStream bout = new BufferedOutputStream(smbfos);

			 int data = 0;
			 byte[] buffer = new byte[1024];
			 while((data = bin.read(buffer, 0, 1024)) != -1) {
				 bout.write(buffer, 0, data);
			 }

			 bout.close();
			 bin.close();

			 fis.close();
			 smbfos.close();

			 Thread.sleep(8000);
			 param.put("COMP_CODE", user.getCompCode());
			 param.put("USER_ID", user.getUserID());

			 dao.update("commonReportServiceImpl.insertFaxMeta", param);
			 dao.update("commonReportServiceImpl.insertFaxMsg" , param);
			 dao.update("commonReportServiceImpl.insertFaxLog" , param);

	}

}
