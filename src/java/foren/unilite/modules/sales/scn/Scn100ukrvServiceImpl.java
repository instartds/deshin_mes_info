package foren.unilite.modules.sales.scn;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bcm.Bcm105ukrvModel;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;
import foren.unilite.utils.ExtFileUtils;

@Service("scn100ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Scn100ukrvServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "sales";

	/**조회팝업 쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> searchPopupList(Map param,LoginVO user) throws Exception {
		return  super.commonDao.list("scn100ukrvServiceImpl.searchPopupList", param);
	}

	/**SCN100T Master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "sales")
	public Object selectList1(Map param, LoginVO user) throws Exception {
		return  super.commonDao.select("scn100ukrvServiceImpl.selectList1", param);
	}

	/** SCN110T detail data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList2(Map param,LoginVO user) throws Exception {
		return  super.commonDao.list("scn100ukrvServiceImpl.selectList2", param);
	}



	/**계약 마스터 데이터 저장로직
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
	public ExtDirectFormPostResult saveMaster( Scn100ukrvModel dataMaster, LoginVO user, BindingResult result) throws Exception {
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		
		if (ObjUtils.isEmpty(dataMaster.getCONT_NUM())) {
			Map contNumMap = new HashMap();
			contNumMap = (Map<String, Object>) super.commonDao.select("scn100ukrvServiceImpl.getContNum", dataMaster);
			dataMaster.setCONT_NUM((String) contNumMap.get("CONT_NUM"));
		}
		
		super.commonDao.update("scn100ukrvServiceImpl.saveMaster", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("CONT_NUM", dataMaster.getCONT_NUM());
		return extResult;
	}



	/**계약 디테일 데이터 저장로직
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("S_COMP_CODE", user.getCompCode());
		dataMaster.put("S_USER_ID"	, user.getUserID());
		if (ObjUtils.isEmpty(dataMaster.get("CONT_NUM"))) {
			Map contNumMap = new HashMap();
			contNumMap = (Map<String, Object>) super.commonDao.select("scn100ukrvServiceImpl.getContNum", dataMaster);
			dataMaster.put("CONT_NUM", (String) contNumMap.get("CONT_NUM"));
		}
		super.commonDao.update("scn100ukrvServiceImpl.saveMaster", dataMaster);
		
		if(paramList != null) {
			List<Map> insertDetail2 = null;
			List<Map> updateDetail2 = null;
			List<Map> deleteDetail2 = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail2")) {
					insertDetail2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail2")) {
					updateDetail2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteDetail2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertDetail2 != null) this.insertDetail2(insertDetail2, user, dataMaster);
			if(updateDetail2 != null) this.updateDetail2(updateDetail2, user, dataMaster);
			if(deleteDetail2 != null) this.deleteDetail2(deleteDetail2, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		try {
			for(Map param : paramList ) {
				if(ObjUtils.isEmpty(param.get("CONT_NUM"))) {
					param.put("CONT_NUM", paramMaster.get("CONT_NUM"));
				}
				super.commonDao.insert("scn100ukrvServiceImpl.insertDetail2", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {	
			super.commonDao.update("scn100ukrvServiceImpl.updateDetail2", param);
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList ) {
			try {
				super.commonDao.delete("scn100ukrvServiceImpl.deleteDetail2", param);
				//DETAIL DATA가 없으면 MASTER DATA 삭제
				int detailCount = (int) super.commonDao.select("scn100ukrvServiceImpl.checkDetailData", param);
				if(detailCount == 0) {
					super.commonDao.delete("scn100ukrvServiceImpl.deleteDetail1", param);
				}
			}catch(Exception e) {
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}










	/**
	 * 첨부 파일 업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "sales", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getAttachmentsInfo( Map param ) throws Exception {
		return super.commonDao.list("scn100ukrvServiceImpl.getAttachmentsInfo", param);
	}

	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "sales" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAttachments( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		if (paramList != null) {
			List<Map> attachmentsInsert = null;
			List<Map> attachmentsUpdate = null;
			List<Map> attachmentsDelete = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("attachmentsInsert")) {
					attachmentsInsert = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("attachmentsUpdate")) {
					attachmentsUpdate = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("attachmentsDelete")) {
					attachmentsDelete = (List<Map>)dataListMap.get("data");
				}
			}
			if (attachmentsDelete != null) this.attachmentsDelete(attachmentsDelete, user, dataMaster);
			if (attachmentsInsert != null) this.attachmentsInsert(attachmentsInsert, user, dataMaster);
			if (attachmentsUpdate != null) this.attachmentsUpdate(attachmentsUpdate, user, dataMaster);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "sales" )
	public Integer attachmentsInsert( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("scn100ukrvServiceImpl.attachmentsInsert", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}

		return 0;
	}

	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "sales" )
	public Integer attachmentsUpdate( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("scn100ukrvServiceImpl.attachmentsUpdate", param);
		}
		return 0;
	}

	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "sales" )
	public Integer attachmentsDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("scn100ukrvServiceImpl.attachmentsDelete", param);
				ExtFileUtils.delFile(param.get("FILE_PATH") + "/" + param.get("FILE_ID") + '.' + param.get("FILE_EXT"));

			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}


	/**
	 * 첨부 파일 업로드
	 *
	 * @param file1
	 * @return
	 * @throws IOException
	 */
	@ExtDirectMethod( group = "sales", value = ExtDirectMethodType.FORM_POST )
	public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, Scn100ukrvModel param, LoginVO user ) throws IOException, Exception {
		String keyValue	= getLogKey();
		String divCode	= param.getDIV_CODE();
		String manageNo	= param.getMANAGE_NO();
		int seq			= param.getSEQ();

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
				spParam.put("S_COMP_CODE"	, user.getCompCode());
				spParam.put("S_USER_ID"		, user.getUserID());
				spParam.put("DIV_CODE"		, divCode);
				spParam.put("CUSTOM_CODE"	, param.getCUSTOM_CODE());
				spParam.put("MANAGE_NO"		, manageNo);
				spParam.put("SEQ"			, seq);
				
				spParam.put("FILE_TYPE"		, param.getFILE_TYPE());

				spParam.put("CERT_FILE"		, file.getOriginalFilename());			//ORIGINAL_FILE_NAME
				spParam.put("FILE_ID"		, keyValue					);			//FID
				spParam.put("MIME_TYPE"		, file.getContentType()		);			//MIME_TYPE
				spParam.put("FILE_EXT"		, fileExtension				);
				spParam.put("FILE_SIZE"		, file.getSize()			);
				spParam.put("FILE_PATH"		, path						);

				logger.debug("CERT_FILE : " + spParam.get("CERT_FILE"));
				logger.debug("CERT_NO 	: " + spParam.get("CERT_NO"));
				super.commonDao.update("scn100ukrvServiceImpl.attachmentsModified", spParam);
			}

		} else {
			throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
		return extResult;
	}


	/**
	 * 첨부 파일 다운로드
	 */
	public FileDownloadInfo getFileInfo( LoginVO user, String fid ) throws Exception {
//		String filePath = ConfigUtil.getString("common.upload.temp");
		Map<String, Object> param = new HashMap<String, Object>();
		FileDownloadInfo rv = null;
		param.put("fid", fid);

		Map rec = (Map)super.commonDao.select("scn100ukrvServiceImpl.selectFileInfo", param);
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
	 * 첨부 파일 다운로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "sales", value = ExtDirectMethodType.STORE_READ )
	public Object selectFileInfo( Map param ) throws Exception {
		return (Map) super.commonDao.select("scn100ukrvServiceImpl.selectFileInfo", param);
	}
}
