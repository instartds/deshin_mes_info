package foren.unilite.modules.z_jw;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.z_yp.S_bcm100ukrv_ypModel;
import foren.unilite.utils.ExtFileUtils;

@Service("s_bpr910ukrv_jwService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_bpr910ukrv_jwServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private  TlabCodeService tlabCodeService ;
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	public final static String FILE_TYPE_OF_PHOTO = "base";	
	
	/**
	 * 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {		

		return  super.commonDao.list("s_bpr910ukrv_jwService.selectList", param);
	}

	
	/**
	 * 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
					
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				
				} else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");}
				
				else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList, user);
			if(insertList != null) this.insertList(insertList, user);
			if(updateList != null) this.updateList(updateList, user);	
		

		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	/**
	 * 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer insertList(List<Map> paramList,  LoginVO user) throws Exception {
		String errMsg = "";		
		try {
			for(Map param :paramList )	{

				super.commonDao.insert("s_bpr910ukrv_jwService.insertList", param);				

			}
			 
		} catch(Exception e){
			throw new  UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		return 0;
	}

	
	/**
	 *  수정 (update)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
			 super.commonDao.update("s_bpr910ukrv_jwService.updateList", param);
		 }
		 return 0;
	} 

	
	/**
	 *  삭제 (delete)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		try {

			for(Map param :paramList )	{

				super.commonDao.delete("s_bpr910ukrv_jwService.deleteList", param);
				super.commonDao.delete("s_bpr910ukrv_jwService.deleteList1", param);

			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("547", user));
		}
		return 0;		

	}
	

	/**
	 * 품목 관련 파일 업로드
	 *
	 * @param file1
	 * @return
	 * @throws IOException
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.FORM_POST )
	public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, S_bpr910ukrv_jwModel param, LoginVO user ) throws IOException, Exception {
		String keyValue	= getLogKey();

		if (file != null && !file.isEmpty()) {
			logger.debug("File1 Name : " + file.getName());
			logger.debug("File1 Bytes: " + file.getSize());
			String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();

			//화면단에서 체크하도록 수정
//			if (!"jpg".equals(fileExtension)) {
//				throw new UniDirectValidateException("jpg 파일로 올려주세요.");
//			}

			String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO, true);
			if (file.getSize() > 0) {
				File tmpFile = new File(path);
				//폴더가 존재하지 않을 경우, 폴더 생성
				if(!tmpFile.exists()) {
					tmpFile.mkdirs();
				}
				tmpFile = new File(path + "/" + keyValue + '.' + fileExtension);
				file.transferTo(tmpFile);

				Map<String, Object> spParam = new HashMap<String, Object>();
				spParam.put("S_COMP_CODE"	, user.getCompCode()	);
				spParam.put("S_USER_ID"		, user.getUserID()		);
				spParam.put("ITEM_CODE"		, param.getITEM_CODE()	);
				spParam.put("FILE_TYPE"		, param.getFILE_TYPE()	);
				spParam.put("REV_NO"		, param.getREV_NO()	);

				spParam.put("CERT_FILE"		, file.getOriginalFilename());			//ORIGINAL_FILE_NAME
				spParam.put("FILE_ID"		, keyValue					);			//FID
				spParam.put("MIME_TYPE"		, file.getContentType()		);			//MIME_TYPE
				spParam.put("FILE_EXT"		, fileExtension				);
				spParam.put("FILE_SIZE"		, file.getSize()			);
				spParam.put("FILE_PATH"		, path						);

				logger.debug("CERT_FILE : " + spParam.get("CERT_FILE"));
				logger.debug("CERT_NO 	: " + spParam.get("CERT_NO"));
				super.commonDao.update("s_bpr910ukrv_jwService.photoModified", spParam);
			}

		} else {
			throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
		return extResult;
	}	
	
	/**
	 * 품목 관련 파일 다운로드
	 */
	public FileDownloadInfo getFileInfo( LoginVO user, String fid ) throws Exception {
//		String filePath = ConfigUtil.getString("common.upload.temp");
		Map<String, Object> param = new HashMap<String, Object>();
		FileDownloadInfo rv = null;;
		param.put("fid", fid);

		Map rec = (Map)super.commonDao.select("s_bpr910ukrv_jwService.selectFileInfo", param);
		if (rec != null) {
			//업로드 한 파일 확장자 확인하여 해당 확장자 검색
			String oriFileName	= (String)rec.get("ORIGINAL_FILE_NAME");			//등록된 원래 파일명
			int fileExtension	= oriFileName.lastIndexOf( "." );
			String fileExt		= oriFileName.substring( fileExtension + 1 );		//확장자

			rv = new FileDownloadInfo((String)rec.get("PATH"), fid + "." + fileExt);
			rv.setOriginalFileName(oriFileName);
			rv.setContentType((String)rec.get("MIME_TYPE"));

			logger.info("FileDownLoad >> {}", user.getUserID() + ", fid : " + fid + ", Filename:" + rec.get("ORIGINAL_FILE_NAME"));
		}
		return rv;
	}	
	
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getItemInfoFileDown( Map param ) throws Exception {
		return (Map) super.commonDao.select("s_bpr910ukrv_jwService.getItemInfoFileDown", param);
	}	

	



}
