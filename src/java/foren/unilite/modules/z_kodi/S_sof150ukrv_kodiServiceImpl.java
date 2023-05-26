package foren.unilite.modules.z_kodi;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.utils.ExtFileUtils;

@Service("s_sof150ukrv_kodiService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_sof150ukrv_kodiServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	//20191107 품목정보 팝업 관련로직 추가
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	public final static String FILE_TYPE_OF_PHOTO = "base";

	//20190722 뱃지기능 추가
	@Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;

	/**
	 * 수주대응 등록 - 메인 데이터 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		if("Y".equals(param.get("LINK_FLAG"))) {
			//20190722 뱃지기능 추가
			super.commonDao.update("s_sof150ukrv_kodiServiceImpl.deleteAlert", param);
			tlabBadgeService.reload();
		}
		return  super.commonDao.list("s_sof150ukrv_kodiServiceImpl.selectList", param);
	}
	/**
	 * 미생물내역 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("s_sof150ukrv_kodiServiceImpl.selectList1", param);
	}
	
	/**
	 * 자재소요량 및 현재고 (품목)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  stockList (Map param) throws Exception {
		return  super.commonDao.list("s_sof150ukrv_kodiServiceImpl.stockList", param);
	}
	
	/**
	 * 자재소요량 및 현재고 (내용물)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  stockList2 (Map param) throws Exception {
		return  super.commonDao.list("s_sof150ukrv_kodiServiceImpl.stockList2", param);
	}







	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);

		//20190722 뱃지기능 추가
		tlabBadgeService.reload();
		return paramList;
	}

	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		/* 데이터 insert */
		try {
			for(Map param : paramList )	{	
				super.commonDao.insert("s_sof150ukrv_kodiServiceImpl.insertList", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}

		return 0;
	}

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			for(Map param :paramList )	{	
				super.commonDao.update("s_sof150ukrv_kodiServiceImpl.updateList", param);
				if(!param.get("REASON2_OLD").equals(param.get("REASON2"))) {
				//20190722 뱃지기능 추가
				super.commonDao.update("s_sof150ukrv_kodiServiceImpl.updateAlert", param);
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}

		return 0;
	}

	/**삭제**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList )	{
			try {
				super.commonDao.delete("s_sof150ukrv_kodiServiceImpl.deleteList", param);

			}catch(Exception e)	{
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		 }
		 return 0;
	}









	/**
	 * 품목 관련 파일 업로드 - 20191107 품목정보 팝업 관련로직 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getItemInfo( Map param ) throws Exception {
		return super.commonDao.list("s_sof150ukrv_kodiServiceImpl.getItemInfo", param);
	}
	
	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll2( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("itemInfoInsert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("itemInfoUpdate")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("itemInfoDelete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.itemInfoDelete(deleteList, user, dataMaster);
			if (insertList != null) this.itemInfoInsert(insertList, user, dataMaster);
			if (updateList != null) this.itemInfoUpdate(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoInsert( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("s_sof150ukrv_kodiServiceImpl.itemInfoInsert", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}
	
	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoUpdate( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("s_sof150ukrv_kodiServiceImpl.itemInfoUpdate", param);
		}
		return 0;
	}
	
	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("s_sof150ukrv_kodiServiceImpl.itemInfoDelete", param);
				ExtFileUtils.delFile(param.get("FILE_PATH") + "/" + param.get("FILE_ID") + '.' + param.get("FILE_EXT"));
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
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
	public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, Bpr300ukrvModel param, LoginVO user ) throws IOException, Exception {
		String keyValue	= getLogKey(); 
		String manageNo	= param.getMANAGE_NO();

		if (file != null && !file.isEmpty()) {
			logger.debug("File1 Name : " + file.getName());
			logger.debug("File1 Bytes: " + file.getSize());
			String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
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
				spParam.put("MANAGE_NO"		, manageNo				);

				spParam.put("CERT_FILE"		, file.getOriginalFilename());			//ORIGINAL_FILE_NAME  
				spParam.put("FILE_ID"		, keyValue					);			//FID
				spParam.put("MIME_TYPE"		, file.getContentType()		);			//MIME_TYPE
				spParam.put("FILE_EXT"		, fileExtension				);
				spParam.put("FILE_SIZE"		, file.getSize()			);
				spParam.put("FILE_PATH"		, path						);

				logger.debug("CERT_FILE : " + spParam.get("CERT_FILE"));
				logger.debug("CERT_NO 	: " + spParam.get("CERT_NO"));
				super.commonDao.update("s_sof150ukrv_kodiServiceImpl.photoModified", spParam);
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
		
		Map rec = (Map)super.commonDao.select("s_sof150ukrv_kodiServiceImpl.selectFileInfo", param);
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

	/**
	 * 첨부파일 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("s_sof150ukrv_kodiServiceImpl.getFileList", param);
	}
}