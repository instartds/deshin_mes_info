package foren.unilite.modules.com.fileman;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "fileMnagerService" )
public class FileMnagerServiceImpl extends TlabAbstractServiceImpl implements FileMnagerService {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * <pre>
     * 파일을 업로드 합니다.
     * OmegaPlus.xml 파일의 설정된 경로에 저장합니다.
     * 파일을 BFL200T 테이블에 저장합니다.
     * </pre>
     * 
     * @param user Session 사용자정보
     * @param file 파일
     * @return
     * @throws Exception
     */
    public String insertFile( LoginVO user, FileUploadModel file ) throws Exception {
        String filePath = ConfigUtil.getString("common.upload.temp");
        String fid = ObjUtils.getTimeOrderUUID();
        Map<String, Object> param = new HashMap<String, Object>();
        
        file.saveAs(filePath, fid + ".bin");
        
        logger.debug("fid : " + fid + ", contentType = {}, fileName : {} ", file.getContentType(), file.getOriginalFileName());
        FileUtils.writeStringToFile(new File(filePath, fid + ".txt"), file.getOriginalFileName());
        
        param.put("FID", fid);
        param.put("ORIGINAL_FILE_NAME", file.getOriginalFileName());
        param.put("MIME_TYPE", file.getContentType());
        param.put("FILE_EXT", file.getFileExt());
        param.put("SIZE", file.getFileSize());
        param.put("S_USER_ID", user.getUserID());
        param.put("COMP_CODE", user.getCompCode());
        super.commonDao.insert("fileMnagerService.insertNewFile", param);
        return fid;
    }
    
    /**
     * <pre>
     * 파일을 업로드 합니다.
     * 파일을 BFL200T 테이블에 저장하지 않습니다.
     * </pre>
     * 
     * @param filePath 업로드될 파일 경로
     * @param file 파일
     * @return
     * @throws Exception
     */
    public String saveFile( String filePath, FileUploadModel file ) throws Exception {
        
        String fid = ObjUtils.getTimeOrderUUID();
        
        file.saveAs(filePath, fid + ".bin");
        
        logger.debug("fid : " + fid + ", contentType = {}, fileName : {} ", file.getContentType(), file.getOriginalFileName());
        FileUtils.writeStringToFile(new File(filePath, fid + ".txt"), file.getOriginalFileName());
        
        return fid;
    }
    
    /**
     * 하나의 파일 정보 조회
     */
    public FileDownloadInfo getFileInfo( LoginVO user, String fid ) throws Exception {
        String filePath = ConfigUtil.getString("common.upload.temp");
        Map<String, Object> param = new HashMap<String, Object>();
        FileDownloadInfo rv = null;;
        param.put("fid", fid);
        
        Map rec = (Map)super.commonDao.select("fileMnagerService.selectFileInfo", param);
        if (rec != null) {
            rv = new FileDownloadInfo(filePath, fid + ".bin");
            rv.setOriginalFileName((String)rec.get("ORIGINAL_FILE_NAME"));
            rv.setContentType((String)rec.get("MIME_TYPE"));
            
            logger.info("FileDownLoad >> {}", user.getUserID() + ", fid : " + fid + ", Filename:" + rec.get("ORIGINAL_FILE_NAME"));
        }
        
        return rv;
    }
    
    /**
     * <pre>
     * 엑셀 Template 파일 정보 조회
     * - JOINS 프로젝트 사용
     * </pre>
     * 
     * @author 박종영
     */
    @SuppressWarnings( "rawtypes" )
    public FileDownloadInfo getExcelFileInfo( LoginVO user, String fid, String type ) throws Exception {
        String mime_type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        
        if ("xls".equals(type)) {
            mime_type = "application/vnd.ms-excel";
        }
        // String filePath = "/home/asmanager/OmegaPlus/excelupload/template";
        // ConfigUtil.getString("common.upload.basePath") 를 기준으로 읽어온다라는 뜻.
        // common.upload.basePath 는 없을 수 없기 때문에 Nullpoint Exception 방지 차원에서 설정함.
        String filePath = ConfigUtil.getUploadBasePath("excel/template");
        FileDownloadInfo rv = null;
        
        logger.debug("FileDownLoad >> comp_code :: {}", user.getCompCode());
        
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("S_COMP_CODE", user.getCompCode());
        param.put("SUB_CODE", fid + "_" + type);
        
        Map rec = (Map)super.commonDao.select("fileMnagerService.selectTempExcelFile", param);
        if (rec != null) {
            String fileName = (String)rec.get("CODE_NAME");
            
            if (fileName != null && !fileName.equals("")) {
                rv = new FileDownloadInfo(filePath, fileName);
                rv.setOriginalFileName(fileName);
                rv.setContentType(mime_type);
                
                logger.debug("FileDownLoad >> user_id :: {}, fid :: {}, Filename :: {}", user.getUserID(), fid, rec.get("ORIGINAL_FILE_NAME"));
            }
        }
        
        return rv;
    }
    
    /**
     * 하나 또는 여러개의 의 파일 정보 등록 확인 처리(템프->정규)
     */
    public boolean confirmFile( LoginVO user, String fids ) throws Exception {
        boolean rv = false;
        if (fids != null) {
            Map<String, Object> param = new HashMap<String, Object>();
            
            if (fids.contains(",")) {
                String[] fidArray = fids.split(",");
                for (String fid : fidArray) {
                    param.put("FID", fid);
                    _confirmOneFile(param);
                }
            } else {
                param.put("FID", fids);
                _confirmOneFile(param);
            }
        }
        return true;
    }
    
    private boolean _confirmOneFile( Map<String, Object> param ) throws Exception {
        super.commonDao.insert("fileMnagerService.confirmFile", param);
        return true;
    }
    
    /**
     * 하나의 파일 정보 삭제
     */
    public boolean deleteFile( LoginVO user, String fids ) throws Exception {
        boolean rv = false;
        if (fids != null) {
            Map<String, String> param = new HashMap<String, String>();
            param.put("COMP_CODE", user.getCompCode());
            if (fids.contains(",")) {
                String[] fidArray = fids.split(",");
                for (String fid : fidArray) {
                    param.put("FID", fid);
                    _deleteOneFile(param);
                }
            } else {
                param.put("FID", fids);
                _deleteOneFile(param);
            }
        }
        return true;
    }
    
    private boolean _deleteOneFile( Map<String, String> param ) throws Exception {
        String filePath = ConfigUtil.getString("common.upload.temp");
        String fid = param.get("FID");
        
        super.commonDao.insert("fileMnagerService.deleteFile", param);
        FileUtil.delFile(filePath, fid + ".bin");
        FileUtil.delFile(filePath, fid + ".txt");
        return true;
    }
    
    public Object getManualInfo( Map param ) throws Exception {
        
        return (Map)super.commonDao.select("fileMnagerService.menualInfo", param);
    }

	/**
	 * PDA APK 다운로드 받기 위한 함수
	 * 공통코드 B612 서브코드 apk 코드명에 APK명 입력하고 
	 */
	public FileDownloadInfo getApkInfo( LoginVO user ) throws Exception {
		String filePath = ConfigUtil.getString("common.upload.basePath") + File.separator + JndiUtils.getEnv("CONTEXT_NAME", "default");
		Map<String, Object> param = new HashMap<String, Object>();
		FileDownloadInfo rv = null;

		param.put("S_COMP_CODE", "MASTER");
		param.put("SUB_CODE", "apk");
		
		Map rec = (Map)super.commonDao.select("fileMnagerService.selectApkInfo", param);
		if (rec != null) {
			rv = new FileDownloadInfo(filePath, (String)rec.get("CODE_NAME"));
			rv.setOriginalFileName((String)rec.get("CODE_NAME"));
			rv.setContentType("apk");
			
			logger.info("FileDownLoad >> {}", user.getUserID() + ", Filename:" + rec.get("CODE_NAME"));
		}
		
		return rv;
	}

}
