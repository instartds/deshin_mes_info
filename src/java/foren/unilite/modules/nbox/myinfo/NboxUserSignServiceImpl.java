package foren.unilite.modules.nbox.myinfo;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxUserSignService")
public class NboxUserSignServiceImpl extends TlabAbstractServiceImpl implements NboxUserSignService  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public final static String FILE_TYPE_OF_SIGN = "sign";
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map select(Map param) throws Exception {
		logger.debug("\n nboxUserSignService.select: {}", param );
		
		Map rv = new HashMap();
		Map record = (Map)super.commonDao.select("nboxUserSignService.select", param);
		
		rv.put("records", record);
		return rv;
	}	
	
	/**
	 * fid의 정보 가져오기
	 * @param fid
	 * @return
	 */
	public Map<String, Object> selectByFID(String fid) throws Exception {
		logger.debug("\n nboxUserSignService.selectByFID: {}", fid );
		
		Map param = new HashMap();
		param.put("FID", fid);
		
		Map record = (Map)super.commonDao.select("nboxUserSignService.selectByFID", param);
		return record;
	}	
	
	/**
	 * sign 파일 가져 오기
	 * @param fid
	 * @return
	 * @throws Exception 
	 */
	public File getUserSignImage(String fid) throws Exception {
		logger.debug("\n getUserSignImage.fid: {}", fid );
		String filePath = ConfigUtil.getString("nbox.upload.path")+ "/" + FILE_TYPE_OF_SIGN + "/";

		Map signRecord = (Map)selectByFID(fid);
		File photo = new File(filePath, fid + "." + signRecord.get("UploadFileExtension"));
		return photo;
	}  
	
	/**
	 * upload
	 * @param fid
	 * @return
	 * @throws Exception 
	 */	
	@ExtDirectMethod(group = "nbox", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult upload(@RequestParam("sign") MultipartFile file, LoginVO login) throws IOException, Exception {
		
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		if (file != null && !file.isEmpty()) {
			
			logger.debug("pictureUploadFile File Name : " + file.getName());
			logger.debug("pictureUploadFile File Bytes : " + file.getSize());
			
			if (file.getSize() > 0){
				String fid = ObjUtils.getTimeOrderUUID();
				
				String filePath = ConfigUtil.getString("nbox.upload.path")+ "/" + FILE_TYPE_OF_SIGN + "/";
				String fileExtension =FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
				
				File tmpFile = new File( filePath + "/"  + fid +'.' + fileExtension);
				file.transferTo(tmpFile);
				
				Map<String,Object> param = new HashMap<String,Object>();
				
				param.put("FID", fid);
				param.put("UploadFileName", file.getOriginalFilename());
				param.put("UploadFileExtension", fileExtension);
				param.put("FileSize", file.getSize());
				param.put("UploadContentType", file.getContentType());
				param.put("UploadPath", filePath);
				param.put("S_COMP_ID", login.getCompCode());
				param.put("S_USER_ID", login.getUserID());
				
				super.commonDao.insert("nboxUserSignService.insert", param);
				
			}
		}
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
		return extResult;
		
	}

}
