package foren.unilite.modules.com.fileman;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bpr.Bpr300ukrvServiceImpl;
import foren.unilite.modules.sales.scn.Scn100ukrvServiceImpl;
import foren.unilite.modules.equip.equ.Equ200ukrvServiceImpl;

@Controller
public class FileMnagerController extends UniliteCommonController {

	private final Logger	  logger = LoggerFactory.getLogger(this.getClass());

	@Resource( name = "fileMnagerService" )
	private FileMnagerService fileMnagerService;

	@Resource( name = "bpr300ukrvService" )
	private Bpr300ukrvServiceImpl bpr300ukrvService;

	//20190718 추가
	@Resource( name = "scn100ukrvService" )
	private Scn100ukrvServiceImpl scn100ukrvService;

	//2019.08.13 장비(equ) 추가.
	@Resource( name = "equ200ukrvService")
	private Equ200ukrvServiceImpl equ200ukrvService;

	@RequestMapping( value = "/fileman/upload.do" )
	public ModelAndView upload( ExtHtttprequestParam _req, ListOp listOp, ModelMap model, LoginVO user ) throws Exception {

		List<FileUploadModel> files = _req.getAllFiles();
		Map<String, Object> rv = new HashMap<String, Object>();
		rv.put("jsonrpc", "2.0");
		rv.put("result", "");
		rv.put("success", Boolean.TRUE);
		try {
			//			String filePath = ConfigUtil.getString("common.upload.temp");
			if (!ObjUtils.isEmpty(files)) {
				for (FileUploadModel file : files) {
					rv.put("fid", fileMnagerService.insertFile(user, file));
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			rv.put("success", Boolean.FALSE);
		}

		return ViewHelper.getJsonView(rv);
	}

	/**
	 * <pre>
	 * csv 파일을 업로드 합니다.
	 * 파일을 BFL200T 테이블에 저장하지 않습니다.
	 * </pre>
	 *
	 * @param _req 업로드될 파일 경로
	 * @param user 파일
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/fileman/csvupload.do" )
	public ModelAndView csvupload( ExtHtttprequestParam _req, LoginVO user ) throws Exception {

		List<FileUploadModel> files = _req.getAllFiles();
		Map<String, Object> rv = new HashMap<String, Object>();
		rv.put("jsonrpc", "2.0");
		rv.put("result", "");
		rv.put("success", Boolean.TRUE);

		// 업로드된 파일목록
		List<String> fid = new ArrayList<String>();

		String filePath = ConfigUtil.getString("common.upload.csv");
		logger.info("filePath :: {}", filePath);
		try {
			//			String filePath = ConfigUtil.getString("common.upload.temp");
			if (!ObjUtils.isEmpty(files)) {
				for (FileUploadModel file : files) {
					fid.add(fileMnagerService.saveFile(filePath, file));
				}

				rv.put("fid", fid);
			} else {
				rv.put("msg", "선택된 파일이 없습니다.");
				rv.put("success", Boolean.FALSE);
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			rv.put("msg", e.getMessage());
			rv.put("success", Boolean.FALSE);
		}

		return ViewHelper.getJsonView(rv);
	}


	/**
	 * <pre>
	 * text 파일을 업로드 합니다.
	 * 파일을 BFL200T 테이블에 저장하지 않습니다.
	 * </pre>
	 *
	 * @param _req 업로드될 파일 경로
	 * @param user 파일
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/fileman/txtupload.do" )
	public ModelAndView txtupload( ExtHtttprequestParam _req, LoginVO user ) throws Exception {

		List<FileUploadModel> files = _req.getAllFiles();
		Map<String, Object> rv = new HashMap<String, Object>();
		rv.put("jsonrpc", "2.0");
		rv.put("result", "");
		rv.put("success", Boolean.TRUE);

		// 업로드된 파일목록
		List<String> fid = new ArrayList<String>();

		String filePath = ConfigUtil.getString("common.upload.txt");
		logger.info("filePath :: {}", filePath);
		try {
			//			String filePath = ConfigUtil.getString("common.upload.temp");
			if (!ObjUtils.isEmpty(files)) {
				for (FileUploadModel file : files) {
					fid.add(fileMnagerService.saveFile(filePath, file));
				}

				rv.put("fid", fid);
			} else {
				rv.put("msg", "선택된 파일이 없습니다.");
				rv.put("success", Boolean.FALSE);
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			rv.put("msg", e.getMessage());
			rv.put("success", Boolean.FALSE);
		}

		return ViewHelper.getJsonView(rv);
	}


	//	@RequestMapping(value = "/fileman/download.do")
	//	public ModelAndView download(ExtHtttprequestParam _req, LoginVO user) throws Exception {
	//
	//
	//		String fid = _req.getP("fid");
	//		logger.debug("fid:{}", fid);
	//		FileDownloadInfo fdi = fileMnagerService.getFileInfo(user, fid);
	//		if(fdi != null) {
	//			fdi.setInLineYn(true);// (_req.getP("inline") == "N")? false : true  );
	//			fdi.setInLineYn("N".equals(_req.getP("inline") ) ? false : true  );
	//		}
	//		return ViewHelper.getFileDownloadView(fdi);
	//	}

	@RequestMapping( value = "/fileman/view/{fid}" )
	public ModelAndView inlineViewer( @PathVariable( "fid" ) String fid, LoginVO user ) throws Exception {
		logger.debug("inlineViewer fid:{}", fid);
		FileDownloadInfo fdi = fileMnagerService.getFileInfo(user, fid);
		if (fdi != null) {
			fdi.setInLineYn(true);
		}
		return ViewHelper.getFileDownloadView(fdi);
	}

	@RequestMapping( value = "/fileman/download/{fid}" )
	public ModelAndView downloader( @PathVariable( "fid" ) String fid, LoginVO user ) throws Exception {
		logger.debug("inlineViewer fid:{}", fid);
		FileDownloadInfo fdi = fileMnagerService.getFileInfo(user, fid);
		if (fdi != null) {
			fdi.setInLineYn(true); // false 하면 다운로드로만 처리되나 이게 편할것 같음.
		}
		return ViewHelper.getFileDownloadView(fdi);
	}

	/**
	 * 엑셀 Template 파일 다운로드 - 박종영 - JOINS 프로젝트 사용
	 *
	 * @param fid 파일ID
	 * @param type 파일 타입(xls : 2003 버젼, xlsx : 2007 이후 버젼 )
	 * @param user 사용자정보
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/fileman/exceldown/{fid}/{type}" )
	public ModelAndView exceldown( @PathVariable( "fid" ) String fid, @PathVariable( "type" ) String type, LoginVO user ) throws Exception {
		logger.debug("inlineViewer fid:{} || type:{}", fid, type);
		FileDownloadInfo fdi = fileMnagerService.getExcelFileInfo(user, fid, type);
		if (fdi != null) {
			fdi.setInLineYn(true); // false 하면 다운로드로만 처리되나 이게 편할것 같음.
		}
		return ViewHelper.getFileDownloadView(fdi);
	}

	@RequestMapping( value = "/fileman/manual/{pgmId}" )
	public ModelAndView downloadwManual( @PathVariable( "pgmId" ) String pgmId, LoginVO user ) throws Exception {
		if (pgmId == null) {
			throw new UniDirectValidateException("프로그램 정보가 없습니다.");
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("lang", user.getLanguage());
		param.put("pgmId", pgmId);
		Map<String, Object> pgmInfo = (Map<String, Object>)fileMnagerService.getManualInfo(param);

		if (pgmInfo == null) {
			throw new UniDirectValidateException("프로그램 정보가 없습니다.");
		}

		if ("N".equals(pgmInfo.get("MANUAL_DISPLAY_YN"))) {
			throw new UniDirectValidateException("해당 프로그램의 도움말 정보가 없습니다.");
		}

		FileDownloadInfo file = new FileDownloadInfo(ConfigUtil.getUploadBasePath("manual") + File.separator + ObjUtils.getSafeString(pgmInfo.get("PATH")), pgmId + ".pdf");

		if (file.getFile() == null) {
			throw new UniDirectValidateException("해당 프로그램의 도움말 정보가 없습니다.");
		}
		return ViewHelper.getFileDownloadView(file);
	}

	@RequestMapping( value = "/fileman/downloadItemFile/{pgmId}/{selItemCode}/{manageNo}/{specialYn}" )
	public ModelAndView downloadItemFlie( @PathVariable( "pgmId" ) String pgmId, @PathVariable( "selItemCode" ) String selItemCode, @PathVariable( "manageNo" ) String manageNo,@PathVariable( "specialYn" ) String specialYn, LoginVO user, HttpServletRequest request ) throws Exception {
		if (pgmId == null) {
			throw new UniDirectValidateException("프로그램 정보가 없습니다.");
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", user.getCompCode());
		if(specialYn.equals("true")){
			selItemCode = selItemCode.replace("^^^", "#");
		}
		param.put("ITEM_CODE", selItemCode);
		param.put("MANAGE_NO", manageNo);
		param.put("lang", user.getLanguage());
		param.put("pgmId", pgmId);
		Map<String, Object> fileDownInfo = (Map<String, Object>) bpr300ukrvService.getItemInfoFileDown(param);

		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		logger.debug("[[Download_Full_Path]] :" + drive + (String) fileDownInfo.get("FILE_PATH")  + File.separator + (String) fileDownInfo.get("FILE_ID") + "." + (String) fileDownInfo.get("FILE_EXT"));
		FileDownloadInfo file = new FileDownloadInfo(drive + (String) fileDownInfo.get("FILE_PATH")  + File.separator, (String) fileDownInfo.get("FILE_ID") + "." + (String) fileDownInfo.get("FILE_EXT"));
		file.setOriginalFileName( (String) fileDownInfo.get("CERT_FILE"));


		if (file.getFile() == null) {
			throw new UniDirectValidateException("다운로드할 파일이 없습니다.");
		}
		return ViewHelper.getFileDownloadView(file);
	}

	/**
	 * 임대/유지보수 계약등록 첨부파일 다운로드
	 * 20190718 추가
	 * @param pgmId
	 * @param selItemCode
	 * @param manageNo
	 * @param user
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping( value = "/fileman/downloadFile/{divCode}/{customCode}/{manageNo}/{seq}" )
	public ModelAndView downloadFile( @PathVariable( "divCode" ) String divCode, @PathVariable( "customCode" ) String customCode, @PathVariable( "manageNo" ) String manageNo, @PathVariable( "seq" ) int seq, LoginVO user, HttpServletRequest request ) throws Exception {
//		if (pgmId == null) {
//			throw new UniDirectValidateException("프로그램 정보가 없습니다.");
//		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE"	, user.getCompCode());
		param.put("DIV_CODE"	, divCode);
		param.put("CUSTOM_CODE"	, customCode);
		param.put("MANAGE_NO"	, manageNo);
		param.put("SEQ"			, seq);
		param.put("lang"		, user.getLanguage());
//		param.put("pgmId"		, pgmId);
		Map<String, Object> fileDownInfo = (Map<String, Object>) scn100ukrvService.selectFileInfo(param);

		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		logger.debug("[[Download_Full_Path]] :" + drive + (String) fileDownInfo.get("PATH")  + File.separator + (String) fileDownInfo.get("FID") + "." + (String) fileDownInfo.get("FILE_EXT"));
		FileDownloadInfo file = new FileDownloadInfo(drive + (String) fileDownInfo.get("PATH")  + File.separator, (String) fileDownInfo.get("FID") + "." + (String) fileDownInfo.get("FILE_EXT"));
		file.setOriginalFileName( (String) fileDownInfo.get("ORIGINAL_FILE_NAME"));


		if (file.getFile() == null) {
			throw new UniDirectValidateException("다운로드할 파일이 없습니다.");
		}
		return ViewHelper.getFileDownloadView(file);
	}
	/**
	 * 장비대장등록 파일다운로드
	 * 20190813 추가
	 * @param pgmId
	 * @param divCode
	 * @param equCode
	 * @param manageNo
	 * @param user
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/fileman/downloadEquFile/{pgmId}/{divCode}/{equCode}/{fileType}/{manageNo}" )
	public ModelAndView downloadItemFlie2( @PathVariable( "pgmId" ) String pgmId,@PathVariable( "divCode" ) String divCode, @PathVariable( "equCode" ) String equCode, @PathVariable("fileType") String fileType,@PathVariable( "manageNo" ) String manageNo, LoginVO user, HttpServletRequest request ) throws Exception {
		if (pgmId == null) {
			throw new UniDirectValidateException("프로그램 정보가 없습니다.");
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("DIV_CODE", divCode);
		param.put("EQU_CODE", equCode);
		param.put("FILE_TYPE", fileType);
		param.put("MANAGE_NO", manageNo);
		param.put("lang", user.getLanguage());
		param.put("pgmId", pgmId);
		Map<String, Object> fileDownInfo = (Map<String, Object>) equ200ukrvService.getItemInfoFileDown(param);

		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		logger.debug("[[Download_Full_Path]] :" + drive + (String) fileDownInfo.get("FILE_PATH")  + File.separator + (String) fileDownInfo.get("FILE_ID") + "." + (String) fileDownInfo.get("FILE_EXT"));
		FileDownloadInfo file = new FileDownloadInfo(drive + (String) fileDownInfo.get("FILE_PATH")  + File.separator, (String) fileDownInfo.get("FILE_ID") + "." + (String) fileDownInfo.get("FILE_EXT"));
		file.setOriginalFileName( (String) fileDownInfo.get("CERT_FILE"));


		if (file.getFile() == null) {
			throw new UniDirectValidateException("다운로드할 파일이 없습니다.");
		}
		return ViewHelper.getFileDownloadView(file);
	}
	

	@RequestMapping( value = "/fileman/downloadApk/pda/apk" )
	public ModelAndView APKdownloader( LoginVO user ) throws Exception {
		
		FileDownloadInfo fdi = fileMnagerService.getApkInfo(user);
		if (fdi != null) {
			fdi.setInLineYn(false); // false 하면 다운로드로만 처리되나 이게 편할것 같음.
		}
		return ViewHelper.getFileDownloadView(fdi);
	}

}



