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
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.z_yp.S_bcm100ukrv_ypModel;
import foren.unilite.utils.ExtFileUtils;

@Service("s_bpr300ukrv_jwService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_bpr300ukrv_jwServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private  TlabCodeService tlabCodeService ;
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	public final static String FILE_TYPE_OF_PHOTO = "base";
	
	
	/**
	 * 공정코드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getProgWorkCode(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("s_bpr300ukrv_jwService.getProgWorkCode", param);

	}
	
	
	/**
	 * 사업장별 품목정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		
		String findType = ObjUtils.getSafeString(param.get("QRY_TYPE"));
		if(!"".equals(findType))	{
			Map searchType = (Map) super.commonDao.select("s_bpr300ukrv_jwService.selectSearchType", param); 
			if(!ObjUtils.isEmpty(searchType)) param.put("QRY_TYPE", searchType.get("REF_CODE1"));
		}
		return  super.commonDao.list("s_bpr300ukrv_jwService.selectList", param);
	}


	
	
	
	/**
	 * 사업장별 품목정보 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
		
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				
				} else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");}
				
				else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	/**
	 * 사업장별 품목정보 입력
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer insertDetail(List<Map> paramList,  LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 
			if(ObjUtils.isEmpty(param.get("ITEM_CODE"))){
				if(ObjUtils.isEmpty(param.get("STANDARD_ITEM_CODE")) && ObjUtils.isEmpty(param.get("PROG_REMARK"))){
					 
					Map getBaseCode1 = (Map) super.commonDao.select("s_bpr300ukrv_jwService.getBaseCode1", param); 
					if(ObjUtils.isEmpty(getBaseCode1) || ObjUtils.isNotEmpty(getBaseCode1.get("ERROR"))){
						throw new UniDirectValidateException("대분류에 따른 구분자가 없습니다.");
					}else{
						param.put("ITEM_CODE", getBaseCode1.get("BASECODE"));
					}
				}else if(ObjUtils.isNotEmpty(param.get("STANDARD_ITEM_CODE")) && ObjUtils.isEmpty(param.get("PROG_REMARK"))){
					Map getBaseCode2 = (Map) super.commonDao.select("s_bpr300ukrv_jwService.getBaseCode2", param);

					param.put("ITEM_CODE", getBaseCode2.get("BASECODE"));
					 
				}else if(ObjUtils.isNotEmpty(param.get("STANDARD_ITEM_CODE")) && ObjUtils.isNotEmpty(param.get("PROG_REMARK"))){

					param.put("ITEM_CODE", ObjUtils.getSafeString(param.get("STANDARD_ITEM_CODE")) + "-" + ObjUtils.getSafeString(param.get("PROG_REMARK")));
				}
				 
			}
			 
			super.commonDao.insert("s_bpr300ukrv_jwService.insert", param);						 
		}
		return 0;
	}

	
	/**
	 * 사업장별 품목정보 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		 for(Map param :paramList )	{	
			 if(!param.get("ITEM_ACCOUNT_ORG").toString().equals(param.get("ITEM_ACCOUNT").toString())){
				 logger.debug(param.get("ITEM_ACCOUNT_ORG") + "===============ITEM_ACCOUNT different=========" + param.get("ITEM_ACCOUNT"));
				 List chkExnum = (List) super.commonDao.list("s_bpr300ukrv_jwService.checkExnum", param);
				 if(chkExnum.size() > 0)	{
					 throw new UniDirectValidateException(this.getMessage("54736", user)); //  '해당품목의 결의전표정보가 존재합니다. 품목계정정보를 변경할 수 없습니다.
				 }
			 }

//				 Map chkItemMap = (Map) super.commonDao.select("s_bpr300ukrv_jwService.checkItemCode", param);
//				 if(ObjUtils.parseInt(chkItemMap.get("CNT")) > 0)	{
				 super.commonDao.update("s_bpr300ukrv_jwService.update", param);
//				 }else {
//					 super.commonDao.update("s_bpr300ukrv_jwService.insert", param);
//				 }
				
		 }
		 return 0;
	} 

	
	/**
	 * 사업장별 품목정보 삭제
	 */
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		try {
			 for(Map param :paramList )	{
				param.put("COMP_CODE", user.getCompCode());			
				super.commonDao.delete("s_bpr300ukrv_jwService.delete", param);
				super.commonDao.delete("s_bpr300ukrv_jwService.delete2", param);
			 }
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("547", user));
		}
		return 0;
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 품목 관련 파일 업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getItemInfo( Map param ) throws Exception {
		return super.commonDao.list("s_bpr300ukrv_jwService.getItemInfo", param);
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
				super.commonDao.insert("s_bpr300ukrv_jwService.itemInfoInsert", param);
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
			super.commonDao.update("s_bpr300ukrv_jwService.itemInfoUpdate", param);
		}
		return 0;
	}
	
	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("s_bpr300ukrv_jwService.itemInfoDelete", param);
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
	public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, S_bpr300ukrv_jwModel param, LoginVO user ) throws IOException, Exception {
		String keyValue	= getLogKey(); 
		String manageNo	= param.getMANAGE_NO();
		
		if (file != null && !file.isEmpty()) {
			logger.debug("File1 Name : " + file.getName());
			logger.debug("File1 Bytes: " + file.getSize());
			String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
			
			//화면단에서 체크하도록 수정
//			if (!"jpg".equals(fileExtension)) {
//				throw new UniDirectValidateException("jpg 파일로 올려주세요.");
//			}
			
			String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO);
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
				super.commonDao.update("s_bpr300ukrv_jwService.photoModified", spParam);
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
		
		Map rec = (Map)super.commonDao.select("s_bpr300ukrv_jwService.selectFileInfo", param);
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

}
