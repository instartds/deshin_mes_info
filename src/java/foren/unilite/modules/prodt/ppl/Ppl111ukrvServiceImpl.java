package foren.unilite.modules.prodt.ppl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.utils.ExtFileUtils;



@Service("ppl111ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ppl111ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	public final static String FILE_TYPE_OF_PHOTO = "base";
	
	
	/**
	 * 
	 * 생산계획 등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("ppl111ukrvServiceImpl.selectDetailList", param);
	}

	/**
	 * 
	 * 판매계획 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRefList(Map param) throws Exception {
		return super.commonDao.list("ppl111ukrvServiceImpl.selectRefList", param);
	}

	/**
	 * 
	 * 수주정보 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("ppl111ukrvServiceImpl.selectEstiList", param);
	}
	
	
	/**
	 * Main Grid saveAll
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
				
		
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		
		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				String keyValue = getLogKey();
				
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);

				
				param.put("data", super.commonDao.insert("ppl111ukrvServiceImpl.insertLogMaster", param));
				
				
				//4.생산계획등록Stored Procedure 실행
				Map<String, Object> spParam = new HashMap<String, Object>();

				spParam.put("KeyValue", keyValue);
				spParam.put("LangCode", user.getLanguage());

				super.commonDao.queryForObject("ppl111ukrvServiceImpl.spProdtPlanForepart", spParam);
				
				String rtnWkPlanNum = ObjUtils.getSafeString(spParam.get("RtnWkPlanNum"));
				String errorDesc 	= ObjUtils.getSafeString(spParam.get("ErrorDesc"));
				
				//생산계획번호 리턴
				Map<String, Object> dataMaster1 = (Map<String, Object>) paramMaster.get("data");
				
				if(!ObjUtils.isEmpty(errorDesc)){
					logger.info("######  ppl111ukrvServiceImpl.spProdtPlanForepart  #######");
					logger.info("######  RtnWkPlanNum : {}", ObjUtils.getSafeString(spParam.get("RtnWkPlanNum")));
					logger.info("######  errorDesc : {}", errorDesc);

					String[] messsage = errorDesc.split(";");
				    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
				}
			}
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/* Main Grid directProxy */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// INSERT
	public Integer  insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
	
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// DELETE
	public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		Map compCodeMap = new HashMap();
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("ppl111ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("PRODT_PLAN_DATE_FR", dataMaster.get("PRODT_PLAN_DATE_FR"));
				 param.put("PRODT_PLAN_DATE_TO", dataMaster.get("PRODT_PLAN_DATE_TO"));
				 
				 super.commonDao.update("ppl111ukrvServiceImpl.deleteDetail", param);
			 }
		 }
		 return 0;
	}
	
	/* -- END Main Grid directProxy */
	
	
	/**
	 * 수주정보 참조, 판매계획 참조 생산계획등록 LogTable + SP 작업
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveRefAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.수주정보참조 로그테이블에 KEY_VALUE 업데이트
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("COMP_CODE", user.getCompCode());

		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");

			for(Map param:  dataList) {
				param.put("MRP_CONTROL_NUM", keyValue);
				param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				
				
				if(param.get("CHECK_YN").equals("S")){
					/* bParam(5) = "S" '영업수주참조  */
					param.put("data", super.commonDao.insert("ppl111ukrvServiceImpl.insertEstiListPlan", param));
				}else if(param.get("CHECK_YN").equals("M")){
				
					/* bParam(5) = "M"	'판매계획참조 */
					param.put("data", super.commonDao.insert("ppl111ukrvServiceImpl.insertRefListPlan", param));
				}
			}
		}
		
		Map<String, Object> spParam = new HashMap<String, Object>();
		
		spParam.put("KeyValue"  , keyValue);
		spParam.put("PadStockYn", dataMaster.get("PAD_STOCK_YN"));
		spParam.put("LangCode"  , user.getLanguage());
		
		super.commonDao.queryForObject("ppl111ukrvServiceImpl.spProdtPlan", spParam);			
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			
		}

		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/* -- MainGrid directProxy */

	/* 수주정보참조  directProxy */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertEstiDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateEstiDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteEstiDetail(List<Map> params, LoginVO user) throws Exception {
		
	}
	/* -- END 수주정보참조  directProxy */
	
	
	/* 판매계획정보참조 directProxy */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertRefDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateRefDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteRefDetail(List<Map> params, LoginVO user) throws Exception {
		
	}
	
	/* -- END 판매계획정보참조 directProxy */
	
	/**
	 * 품목 관련 파일 업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getItemInfo( Map param ) throws Exception {
		return super.commonDao.list("ppl111ukrvServiceImpl.getItemInfo", param);
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
				super.commonDao.insert("ppl111ukrvServiceImpl.itemInfoInsert", param);
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
			super.commonDao.update("ppl111ukrvServiceImpl.itemInfoUpdate", param);
		}
		return 0;
	}
	
	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("ppl111ukrvServiceImpl.itemInfoDelete", param);
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
				spParam.put("MANAGE_NO"		, manageNo				);

				spParam.put("CERT_FILE"		, file.getOriginalFilename());			//ORIGINAL_FILE_NAME  
				spParam.put("FILE_ID"		, keyValue					);			//FID
				spParam.put("MIME_TYPE"		, file.getContentType()		);			//MIME_TYPE
				spParam.put("FILE_EXT"		, fileExtension				);
				spParam.put("FILE_SIZE"		, file.getSize()			);
				spParam.put("FILE_PATH"		, path						);

				logger.debug("CERT_FILE : " + spParam.get("CERT_FILE"));
				logger.debug("CERT_NO 	: " + spParam.get("CERT_NO"));
				super.commonDao.update("ppl111ukrvServiceImpl.photoModified", spParam);
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
		
		Map rec = (Map)super.commonDao.select("ppl111ukrvServiceImpl.selectFileInfo", param);
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
		return super.commonDao.list("ppl111ukrvServiceImpl.getFileList", param);
	}
	
}
