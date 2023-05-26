package foren.unilite.modules.equip.equ;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import oracle.sql.CharacterSet;

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
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.utils.ExtFileUtils;

@Service("equ200ukrvService")
public class Equ200ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	public final static String FILE_TYPE_OF_PHOTO = "equip";
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "equip")
	public Object selectListForForm(Map param) throws Exception {
		return  super.commonDao.select("equ200ukrvServiceImpl.selectListForForm", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "equip")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("equ200ukrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateDetail")) {
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
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
    public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
        for(Map param : paramList ) {
            super.commonDao.insert("equ200ukrvServiceImpl.insertDetail", param);
        }   
        return;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            super.commonDao.update("equ200ukrvServiceImpl.updateDetail", param);
        }
         return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
    public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
         for(Map param :paramList ) {
             super.commonDao.delete("equ200ukrvServiceImpl.deleteDetail", param);
         }
         return;
    }
	
	
	
	
	
	
	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult uploadPhoto( @RequestParam( "fileUpload" ) MultipartFile file, Equ200ukvrModel param, LoginVO login ) throws IOException, Exception {
        
        if (file != null && !file.isEmpty()) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
            
            if (!"jpg".equals(fileExtension) && !"png".equals(fileExtension) && !"bmp".equals(fileExtension)) {
                throw new UniDirectValidateException(new String("jpg, png, bmp 파일로 올려주세요."));
            }
            
            String path = ConfigUtil.getUploadBasePath(ConfigUtil.getString("common.upload.equipmentPhoto", "/EquipmentPhoto/"));
            logger.debug("################### fileUpload path : "+path);
            if (file.getSize() > 0) {
            	File dir = new File(path);
            	if(!dir.exists()) {
            		dir.mkdir(); 
            	}
            	String fileName =   login.getCompCode()+param.getDIV_CODE()+param.getEQU_CODE() + '.' + fileExtension;
            	
                File tmpFile = new File(path + "/"+fileName);
                file.transferTo(tmpFile);
                
                param.setFILE_NAME(fileName);
                param.setS_COMP_CODE(login.getCompCode());
                param.setS_USER_ID(login.getUserID());
                param.setFILE_TYPE(fileExtension);
                super.commonDao.update("equ200ukrvServiceImpl.updatePhoto", param);
            }
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
        return extResult;
        
    }
	
	
	
	/**
	 * 품목 관련 파일 업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getEquInfo( Map param ) throws Exception {
		return super.commonDao.list("equ200ukrvServiceImpl.getEquInfo", param);
	}

	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "equip" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll2( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("equInfoInsert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("equInfoUpdate")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("equInfoDelete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.equInfoDelete(deleteList, user, dataMaster);
			if (insertList != null) this.equInfoInsert(insertList, user, dataMaster);
			if (updateList != null) this.equInfoUpdate(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "equip" )
	public Integer equInfoInsert( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("equ200ukrvServiceImpl.equInfoInsert", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}

		return 0;
	}

	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "equip" )
	public Integer equInfoUpdate( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("equ200ukrvServiceImpl.equInfoUpdate", param);
		}
		return 0;
	}

	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "equip" )
	public Integer equInfoDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("equ200ukrvServiceImpl.equInfoDelete", param);
                ExtFileUtils.delFile(param.get("FILE_PATH") + "/" + param.get("FILE_ID") + '.' + param.get("FILE_EXT"));

			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}



	/**
	 * 품목 관련 파일 다중 업로드
	 *
	 * @param file1
	 * @return
	 * @throws IOException
	 */
	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.FORM_POST )
	public ExtDirectFormPostResult photoUploadFile2( @RequestParam( "photoFile" ) ArrayList<MultipartFile> file, Equ200ukvrModel param,  LoginVO user) throws IOException, Exception {
		
//		String manageNo	= param.getMANAGE_NO();

		if (file != null && !file.isEmpty()) {
			for(int i=0; i<file.size(); i++ ){
				String keyValue	= getLogKey();
				logger.debug("File1 Name : " + file.get(i).getName());
				logger.debug("File1 Bytes: " + file.get(i).getSize());
				String fileExtension = FileUtil.getExtension(file.get(i).getOriginalFilename()).toLowerCase();
	
				//화면단에서 체크하도록 수정
	//			if (!"jpg".equals(fileExtension)) {
	//				throw new UniDirectValidateException("jpg 파일로 올려주세요.");
	//			}
	
				String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO, true);
				if (file.get(i).getSize() > 0) {
					File tmpFile = new File(path);
					//폴더가 존재하지 않을 경우, 폴더 생성
					if(!tmpFile.exists()) {
						tmpFile.mkdirs();
					}
					tmpFile = new File(path + "/" + keyValue + '.' + fileExtension);
					file.get(i).transferTo(tmpFile);
					
					String equCode = "";
					int tempIndex = 0;
					equCode = file.get(i).getOriginalFilename();
					
					tempIndex = equCode.indexOf(" ");
					
					if(tempIndex == 7){
						equCode = equCode.substring(0, tempIndex) + "-0";
					}else{
						equCode = equCode.substring(0, tempIndex);
					}
					
//					file.get(i).getOriginalFilename()
					
	
					Map<String, Object> spParam = new HashMap<String, Object>();
					spParam.put("S_COMP_CODE"	, user.getCompCode()	);
					spParam.put("S_USER_ID"		, user.getUserID()		);
					

					spParam.put("DIV_CODE"		, "01"	);
					spParam.put("EQU_CODE"		, equCode	);
					spParam.put("FILE_TYPE"		, "01"	);
//					spParam.put("MANAGE_NO"		, manageNo				);		max +1 숫자
					
//					spParam.put("DIV_CODE"		, param.getDIV_CODE()	);
//					spParam.put("EQU_CODE"		, param.getEQU_CODE()	);
//					spParam.put("FILE_TYPE"		, param.getFILE_TYPE()	);
//					spParam.put("MANAGE_NO"		, manageNo				);
	
					spParam.put("CERT_FILE"		, file.get(i).getOriginalFilename());			//ORIGINAL_FILE_NAME
					spParam.put("FILE_ID"		, keyValue					);			//FID
					spParam.put("MIME_TYPE"		, file.get(i).getContentType()		);			//MIME_TYPE
					spParam.put("FILE_EXT"		, fileExtension				);
					spParam.put("FILE_SIZE"		, file.get(i).getSize()			);
					spParam.put("FILE_PATH"		, path						);
	
					logger.debug("CERT_FILE : " + spParam.get("CERT_FILE"));
					logger.debug("CERT_NO 	: " + spParam.get("CERT_NO"));
					super.commonDao.insert("equ200ukrvServiceImpl.equInfoInsertMulti", spParam);
				}

			}
		} else {
			throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
		return extResult;
	}	
	
	

	/**
	 * 품목 관련 파일 업로드
	 *
	 * @param file1
	 * @return
	 * @throws IOException
	 */
	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.FORM_POST )
	public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, Equ200ukvrModel param,  LoginVO user) throws IOException, Exception {
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
				spParam.put("DIV_CODE"		, param.getDIV_CODE()	);
				spParam.put("EQU_CODE"		, param.getEQU_CODE()	);
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
				super.commonDao.update("equ200ukrvServiceImpl.photoModified", spParam);
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

		Map rec = (Map)super.commonDao.select("equ200ukrvServiceImpl.selectFileInfo", param);
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
	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.STORE_READ )
	public Object getItemInfoFileDown( Map param ) throws Exception {
		return (Map) super.commonDao.select("equ200ukrvServiceImpl.getItemInfoFileDown", param);
	}
	
    /**
     *  스페어 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)      // spare 조회
    public List<Map<String, Object>> selectListSpare(Map param) throws Exception {
        return super.commonDao.list("equ200ukrvServiceImpl.selectListSpare", param);
    }
	
	
    
    /**
     *  SPARE 저장
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAllSpare(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteSpare")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateSpare")) {
                       updateList = (List<Map>)dataListMap.get("data");    
                   } else if(dataListMap.get("method").equals("insertSpare")) {
                       insertList = (List<Map>)dataListMap.get("data");    
                   } 
               }           
               if(deleteList != null) this.deleteSpare(deleteList, user);
               if(updateList != null) this.updateSpare(updateList, user); 
               if(insertList != null) this.insertSpare(insertList, user);             
           }
           paramList.add(0, paramMaster);
               
           return  paramList;
   }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")          // INSERT
    public void insertSpare(List<Map> paramList, LoginVO user) throws Exception {
        Map compCodeMap = new HashMap();
        for(Map param :paramList ) {   
            super.commonDao.update("equ200ukrvServiceImpl.insertSpare", param);
        }
        return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")          // UPDATE
    public void updateSpare(List<Map> paramList, LoginVO user) throws Exception {
        Map compCodeMap = new HashMap();
        for(Map param :paramList ) {   
            super.commonDao.update("equ200ukrvServiceImpl.updateSpare", param);
        }
        return;
    } 
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")                        // DELETE
    public void deleteSpare(List<Map> paramList,  LoginVO user) throws Exception {
        Map compCodeMap = new HashMap();
        for(Map param :paramList ) {   
            super.commonDao.update("equ200ukrvServiceImpl.deleteSpare", param);
        }
        return;
    }
    
    
}
