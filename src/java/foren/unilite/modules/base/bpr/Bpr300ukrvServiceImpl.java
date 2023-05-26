package foren.unilite.modules.base.bpr;

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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.combo.ComboItemModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.z_yp.S_bcm100ukrv_ypModel;
import foren.unilite.utils.ExtFileUtils;

@Service("bpr300ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Bpr300ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	private  TlabCodeService tlabCodeService ;

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	public final static String FILE_TYPE_OF_PHOTO = "base";

	/**
	 * 품목계정에 따른 품목코드 자동채번 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public Object selectAutoItemCode(Map param) throws Exception {
		return super.commonDao.select("bpr300ukrvService.selectAutoItemCode", param);
	}

	/**
	 * 채번 확정시 채번테이블에 insert 또는 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public String saveAutoItemCode(Map param) throws Exception {
		String rtnV = "";
		super.commonDao.update("bpr300ukrvService.saveAutoItemCode", param);
		rtnV = "Y";
		return rtnV;
	}
	/**
	 * 품목계정에 따른 품목기본설정 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public Object selectItemAccountInfo(Map param) throws Exception {
		return super.commonDao.select("bpr300ukrvService.selectItemAccountInfo", param);
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
		if(!"".equals(findType)) {
			Map searchType = (Map) super.commonDao.select("bpr300ukrvService.selectSearchType", param);
			if(!ObjUtils.isEmpty(searchType)) param.put("QRY_TYPE", searchType.get("REF_CODE1"));
		}
		return  super.commonDao.list("bpr300ukrvService.selectList", param);
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

		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");

				} else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");

				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
			if(insertList != null) this.insertDetail(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail(updateList, user, paramMaster);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 사업장별 품목정보 입력
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,group = "base")
	public Integer insertDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> addDivList = null;
		 Map addParam = new HashMap();
		 String allDiv = (String) dataMaster.get("ALL_DIV");
	   	 String selDivCode = (String) dataMaster.get("SEL_DIV_CODE");
	   	 int insertChk = 0;
		 addParam.put("COMP_CODE", user.getCompCode());
		 addParam.put("SEL_DIV_CODE", selDivCode);

		if(allDiv.equals("Y")){
			 addDivList =  super.commonDao.list("bpr300ukrvService.selectDivList", addParam);
		 }

		for(Map param :paramList ) {
			super.commonDao.update("bpr300ukrvService.insert", param);
			//선택 사업장 제외한 나머지 사업장에 품목 정보 insert
			if(addDivList != null){
					for(Map addParams : addDivList){
						param.put("ADD_DIV_CODE", addParams.get("ADD_DIV_CODE"));
						super.commonDao.update("bpr300ukrvService.allDivInsert", param);
				   }
			 }
		}

		 return 0;
	}

	/**
	 * 사업장별 품목정보 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {

		Map compCodeMap = new HashMap();

		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		 for(Map param :paramList ) {
			 if(!param.get("ITEM_ACCOUNT_ORG").toString().equals(param.get("ITEM_ACCOUNT").toString())){
				 logger.debug(param.get("ITEM_ACCOUNT_ORG") + "===============ITEM_ACCOUNT different=========" + param.get("ITEM_ACCOUNT"));
				 List chkExnum = (List) super.commonDao.list("bpr300ukrvService.checkExnum", param);
				 if(chkExnum.size() > 0) {
					 throw new UniDirectValidateException(this.getMessage("54736", user)); //  '해당품목의 결의전표정보가 존재합니다. 품목계정정보를 변경할 수 없습니다.
				 }
			 }

//				 Map chkItemMap = (Map) super.commonDao.select("bpr300ukrvService.checkItemCode", param);
//				 if(ObjUtils.parseInt(chkItemMap.get("CNT")) > 0) {
				 super.commonDao.insert("bpr300ukrvService.update", param);
//				 }else {
//					 super.commonDao.update("bpr300ukrvService.insert", param);
//				 }

		 }
		 return 0;
	}

	/**
	 * 사업장별 품목정보 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster ) throws Exception {
		try {
			Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");
			String allDiv					= (String) dataMaster.get("ALL_DIV");
			String selDivCode				= (String) dataMaster.get("SEL_DIV_CODE");
			int otherDivChk					= 0 ;
			List<Map> deleteDivList			= null;
			Map delParam					= new HashMap();
			delParam.put("COMP_CODE"	, user.getCompCode());
			delParam.put("SEL_DIV_CODE"	, selDivCode);
			if(allDiv.equals("Y")){
				deleteDivList =  super.commonDao.list("bpr300ukrvService.selectDivList", delParam);
			}

			//20210428 추가: 삭제전, BOM 등록여부 확인로직 추가
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List) super.commonDao.list("bpr300ukrvService.checkCompCode", compCodeMap);

			for(Map param : paramList) {
				//20210428 추가: 삭제전, BOM 등록여부 확인로직 추가
				for (Map checkCompCode : chkList) {
					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					List chkChildList = (List) super.commonDao.list("bpr300ukrvService.checkChildCode", param);
					if (chkChildList.size() > 0) {
						throw new UniDirectValidateException(this.getMessage("547",user)+ "[품목코드:"+ ObjUtils.getSafeString(param.get("ITEM_CODE"))+ "]");
					} else {
						param.put("COMP_CODE", user.getCompCode());
						delParam.put("ITEM_CODE", param.get("ITEM_CODE"));
		
						super.commonDao.delete("bpr300ukrvService.delete", param);
						super.commonDao.delete("bpr300ukrvService.delete2", param);
						if(deleteDivList != null){
							for(Map delParams : deleteDivList){
								delParam.put("DIV_CODE", delParams.get("ADD_DIV_CODE"));
								super.commonDao.delete("bpr300ukrvService.delete", delParam);
							}
						}
					}
				}
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
		return super.commonDao.list("bpr300ukrvService.getItemInfo", param);
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
				super.commonDao.insert("bpr300ukrvService.itemInfoInsert", param);
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
			super.commonDao.update("bpr300ukrvService.itemInfoUpdate", param);
		}
		return 0;
	}

	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemInfoDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("bpr300ukrvService.itemInfoDelete", param);
				ExtFileUtils.delFile(param.get("FILE_PATH") + "/" + param.get("FILE_ID") + '.' + param.get("FILE_EXT"));
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}



	/**
	 * 품목이력관리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getItemHistory( Map param ) throws Exception {
		return super.commonDao.list("bpr300ukrvService.getItemHistory", param);
	}

	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll3( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		if (paramList != null) {
			List<Map> insertList = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("itemHistoryInsert")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if (insertList != null) this.itemHistoryInsert(insertList, user, dataMaster);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
	public Integer itemHistoryInsert( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("bpr300ukrvService.itemHistoryInsert", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
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
				super.commonDao.update("bpr300ukrvService.photoModified", spParam);
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

		Map rec = (Map)super.commonDao.select("bpr300ukrvService.selectFileInfo", param);
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
	 * 품목 관련 파일 다운로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
	public Object getItemInfoFileDown( Map param ) throws Exception {
		return (Map) super.commonDao.select("bpr300ukrvService.getItemInfoFileDown", param);
	}
	
	/**
	 * 제조부문 목록 콤보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base")
	public List<ComboItemModel> selectListCbm700(Map param) throws Exception {
		return  super.commonDao.list("bpr300ukrvService.selectListCbm700", param);
	}
}