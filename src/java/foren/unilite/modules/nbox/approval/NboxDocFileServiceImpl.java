package foren.unilite.modules.nbox.approval;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxDocFileService")
public class NboxDocFileServiceImpl extends TlabAbstractServiceImpl implements NboxDocFileService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	public String insertFile(LoginVO user, FileUploadModel file) throws Exception {
		String filePath = ConfigUtil.getString("nbox.upload.temp");
		String fid = ObjUtils.getTimeOrderUUID();
		Map<String,Object> param = new HashMap<String,Object>();
		
		file.saveAs(filePath, fid + ".bin");

		logger.debug("fid : " + fid + ", contentType = {}, fileName : {} ", file.getContentType(), file.getOriginalFileName());
		FileUtils.writeStringToFile(new File(filePath, fid + ".txt"), file.getOriginalFileName());

		param.put("FID", fid);
		param.put("UploadFileName", file.getOriginalFileName());
		param.put("UploadFileExtension", file.getFileExt());
		param.put("FileSize", file.getFileSize());
		param.put("UploadContentType", file.getContentType());
		param.put("UploadPath", filePath);
		param.put("CompanyID", user.getCompCode());
		param.put("InsertUserID", user.getUserID());
		
		super.commonDao.insert("nboxDocFileService.insert", param);
		return fid;
	}
	
	/**
	 * 하나의 파일 정보 조회
	 */
	public FileDownloadInfo getFileInfo( LoginVO user, String fid) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();
		FileDownloadInfo rv = null;;
		param.put("FID", fid);

		Map rec= (Map)super.commonDao.select("nboxDocFileService.select", param);
		if(rec != null) {
			rv = new FileDownloadInfo((String) rec.get("UploadPath"), fid+".bin");
			rv.setOriginalFileName((String) rec.get("UploadFileName"));
			String extString = rec.get("UploadFileExtension").toString();
			if(extString.toLowerCase().equals("txt"))
				rv.setContentType("application/octet-stream");
			else
				rv.setContentType((String) rec.get("UploadContentType"));
			
			logger.debug("\n UploadContentType: {}", (String)rv.getContentType() );
			logger.info("FileDownLoad >> {}",user.getUserID() +", fid : " + fid +", Filename:" +  rec.get("UploadFileName") );
		}
		
		return rv;
	}
	
	public List<Map<String, Object>> getByDocumentID(Map param) throws Exception {
		logger.debug("\n selectFiles: {}", param );
		return super.commonDao.list("nboxDocFileService.getByDocumentID", param);
	}
	
	
	
	/**
	 * 하나 또는 여러개의 의 파일 정보 등록 확인 처리(템프->정규)
	 */
	public boolean confirmFile( LoginVO user, String DocumentID, String[] ADDFID) throws Exception{
		boolean rv = false;
		Map<String,Object> param = new HashMap<String,Object>();
		
		String filePath = ConfigUtil.getString("nbox.upload.path")+ "/" + user.getCompCode() + "/" + user.getUserID() + "/";
			
		if( ADDFID.length > 0) {
			for(String fid : ADDFID) {
				param.put("FID", fid);
				param.put("DocumentID", DocumentID);
				param.put("UploadPath", filePath);
				
				_confirmOneFile(param);
			}
		} 
		
		return true;
	}
	
	private boolean _confirmOneFile(Map<String, Object> param) throws Exception{
		Map rec= (Map)super.commonDao.select("nboxDocFileService.select", param);
		
		FileUtil.CheckAndMakeDir((String)param.get("UploadPath"));
		FileUtil.moveFile((String)rec.get("UploadPath") + (String)rec.get("FID") + ".bin", 
				(String)param.get("UploadPath") + (String)param.get("FID") + ".bin");
		FileUtil.moveFile((String)rec.get("UploadPath") + (String)rec.get("FID") + ".txt", 
				(String)param.get("UploadPath") + (String)param.get("FID") + ".txt");
		
		super.commonDao.insert("nboxDocFileService.update", param);
		
		return true;
	}
	
	
	/**
	 * 하나의 파일 정보 삭제
	 */
	public boolean deleteFile( LoginVO user, String[] DELFID) throws Exception {
		Map<String, String> param = new HashMap<String, String>();
		
		if( DELFID.length > 0) {
			for(String fid : DELFID) {
				param.put("FID", fid);
				_deleteOneFile(param);
			}
		}
		
		return true;
	}
	
	private boolean _deleteOneFile( Map<String, String> param) throws Exception{
		Map rec= (Map)super.commonDao.select("nboxDocFileService.select", param);
		String fid = (String)rec.get("FID");
		
		super.commonDao.delete("nboxDocFileService.delete", param);
		FileUtil.delFile((String)rec.get("UploadPath"), fid + ".bin");
		FileUtil.delFile((String)rec.get("UploadPath"), fid + ".txt");
		
		return true;
	}

}
