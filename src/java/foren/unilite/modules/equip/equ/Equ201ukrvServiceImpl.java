package foren.unilite.modules.equip.equ;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.equip.eqt.Eqt200ukvrModel;
import foren.unilite.utils.ExtFileUtils;


@Service("equ201ukrvService")
public class Equ201ukrvServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map itemCode = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
    	public final static String FILE_TYPE_OF_PHOTO = "equip";
        
        
    	/**
    	 * 금형코드 자동채번 관련
    	 * @param param
    	 * @return
    	 * @throws Exception
    	 */
    	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
    	public Object autoEquCode(Map param) throws Exception {
    		return super.commonDao.select("equ201ukrvService.autoEquCode", param);
    	}

        
     
    	
    	/**
    	 * 파일 업로드
    	 * @param param
    	 * @return
    	 * @throws Exception
    	 */
    	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.STORE_READ )
    	public List<Map<String, Object>> getEquInfo( Map param ) throws Exception {
    		return super.commonDao.list("equ201ukrvService.getEquInfo", param);
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
//    			if (!"jpg".equals(fileExtension)) {
//    				throw new UniDirectValidateException("jpg 파일로 올려주세요.");
//    			}

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
    				super.commonDao.update("equ201ukrvService.photoModified", spParam);
    			}

    		} else {
    			throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
    		}
    		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
    		return extResult;
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
    				super.commonDao.insert("equ201ukrvService.equInfoInsert", param);
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
    			super.commonDao.update("equ201ukrvService.equInfoUpdate", param);
    		}
    		return 0;
    	}

    	/** 삭제 **/
    	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "equip" )
    	public Integer equInfoDelete( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
    		for (Map param : paramList) {
    			try {
    				super.commonDao.delete("equ201ukrvService.equInfoDelete", param);
                    ExtFileUtils.delFile(param.get("FILE_PATH") + "/" + param.get("FILE_ID") + '.' + param.get("FILE_EXT"));

    			} catch (Exception e) {
    				throw new UniDirectValidateException(this.getMessage("547", user));
    			}
    		}
    		return 0;
    	}
    	
    	
    	   
        /**
    	 * 이미지리스트 금형사진
    	 * @param param
    	 * @return
    	 * @throws Exception
    	 */
    	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    	public List<Map<String, Object>> imagesList1(Map param) throws Exception {
    		return super.commonDao.list("equ201ukrvService.imagesList1", param);
    	}
    	/**
    	 * 이미지리스트 부품사진
    	 * @param param
    	 * @return
    	 * @throws Exception
    	 */
    	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
    	public List<Map<String, Object>> imagesList2(Map param) throws Exception {
    		return super.commonDao.list("equ201ukrvService.imagesList2", param);
    	}
    	
    	
    	
    	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.FORM_POST )
        public ExtDirectFormPostResult uploadPhoto( @RequestParam( "fileUpload" ) MultipartFile file, Eqt200ukvrModel param, LoginVO login ) throws IOException, Exception {
            
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
                    Map<String, String> maxSerNo = new HashMap<String, String>();
                    maxSerNo = (Map) super.commonDao.select("eqt200ukrvServiceImpl.imagesMaxSerNo", param);
    	       	    if(ObjUtils.isNotEmpty(maxSerNo)){
    	                param.setSER_NO(ObjUtils.parseInt(maxSerNo.get("MAX_SER_NO"))+1);
    	       	    }else{
    	       	    	param.setSER_NO(1);
    	       	    }
    	       	    
                	String fileFid =   login.getCompCode()+param.getDIV_CODE()+param.getEQU_CODE() + param.getCTRL_TYPE() + ObjUtils.getSafeString(param.getSER_NO());
                	String fileName =   login.getCompCode()+param.getDIV_CODE()+param.getEQU_CODE() + param.getCTRL_TYPE() + ObjUtils.getSafeString(param.getSER_NO()) +'.' + fileExtension;
                    
                    File tmpFile = new File(path + "/"+fileName);
                    file.transferTo(tmpFile);
                    
                    param.setIMAGE_FID(fileFid);
                    param.setFILE_NAME(file.getOriginalFilename());		// 파일올릴당시 파일이름
                    param.setS_COMP_CODE(login.getCompCode());
                    param.setS_USER_ID(login.getUserID());
                    param.setFILE_TYPE(fileExtension);
                    super.commonDao.insert("eqt200ukrvServiceImpl.insertImages", param);
                }
            }
            ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
            return extResult;
        }
    	
    	
    	
    	
    	
    	/**
         *  금형 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectMaster(Map param) throws Exception {
            return super.commonDao.list("equ201ukrvService.selectMaster", param);
        }
    	
    	
        /**
         * 금형 저장
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveAllMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
  
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            dataMaster.put("COMP_CODE", user.getCompCode());
          
            if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteMaster")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateMaster")) {
                       updateList = (List<Map>)dataListMap.get("data");    
                   } else if(dataListMap.get("method").equals("insertMaster")) {
                       insertList = (List<Map>)dataListMap.get("data");    
                   } 
               }           
               if(deleteList != null) this.deleteMaster(deleteList, user);
               if(updateList != null) this.updateMaster(updateList, user); 
               if(insertList != null) this.insertMaster(insertList, user);             
           }
        
           paramList.add(0, paramMaster);
               
           return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
        public void insertMaster(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
            	param.put("EQU_CODE", ObjUtils.getSafeString(param.get("EQU_CODE_1")).toUpperCase()+ "-" + ObjUtils.getSafeString(param.get("EQU_CODE_2")));
            	param.put("EQU_SIZE_W", ObjUtils.nvl(param.get("EQU_SIZE_W"),'0'));
            	param.put("EQU_SIZE_L", ObjUtils.nvl(param.get("EQU_SIZE_L"),'0'));
            	param.put("EQU_SIZE_H", ObjUtils.nvl(param.get("EQU_SIZE_H"),'0'));
            	param.put("PRODT_O", ObjUtils.nvl(param.get("PRODT_O"),'0'));
            	param.put("WORK_Q", ObjUtils.nvl(param.get("WORK_Q"),'0'));

            	
                super.commonDao.update("equ201ukrvService.insertMaster", param);
            }
            return ;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
        public void updateMaster(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
            	param.put("EQU_SIZE_W", ObjUtils.nvl(param.get("EQU_SIZE_W"),'0'));
            	param.put("EQU_SIZE_L", ObjUtils.nvl(param.get("EQU_SIZE_L"),'0'));
            	param.put("EQU_SIZE_H", ObjUtils.nvl(param.get("EQU_SIZE_H"),'0'));
            	param.put("PRODT_O", ObjUtils.nvl(param.get("PRODT_O"),'0'));
            	param.put("WORK_Q", ObjUtils.nvl(param.get("WORK_Q"),'0'));
                super.commonDao.update("equ201ukrvService.updateMaster", param);
            }
            return ;
        }
        
        @ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
        public void deleteMaster(List<Map> paramList,  LoginVO user) throws Exception {
            for(Map param :paramList ) {
               super.commonDao.update("equ201ukrvService.deleteMaster", param);
            }
            return ;
        }
    	
    	
    	
    	
        /**
    	 * 코어코드 자동채번 관련
    	 * @param param
    	 * @return
    	 * @throws Exception
    	 */
    	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
    	public Object autoCoreCode(Map param) throws Exception {
    		return super.commonDao.select("equ201ukrvService.autoCoreCode", param);
    	}
    	
    	
        /**
         *  코어 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectSub(Map param) throws Exception {
            return super.commonDao.list("equ201ukrvService.selectSub", param);
        }
        
        /**
         * 코어 저장
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveAllSub(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
  
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            dataMaster.put("COMP_CODE", user.getCompCode());
          
            if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteSub")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateSub")) {
                       updateList = (List<Map>)dataListMap.get("data");    
                   } else if(dataListMap.get("method").equals("insertSub")) {
                       insertList = (List<Map>)dataListMap.get("data");    
                   } 
               }           
               if(deleteList != null) this.deleteSub(deleteList, user);
               if(updateList != null) this.updateSub(updateList, user); 
               if(insertList != null) this.insertSub(insertList, user);             
           }
        
           paramList.add(0, paramMaster);
               
           return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
        public void insertSub(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
            	param.put("CAVITY_Q", ObjUtils.nvl(param.get("CAVITY_Q"),'0'));
            	param.put("CORE_SIZE_W", ObjUtils.nvl(param.get("CORE_SIZE_W"),'0'));
            	param.put("CORE_SIZE_L", ObjUtils.nvl(param.get("CORE_SIZE_L"),'0'));
            	param.put("CORE_SIZE_H", ObjUtils.nvl(param.get("CORE_SIZE_H"),'0'));
            	param.put("CORE_SIZE_P", ObjUtils.nvl(param.get("CORE_SIZE_P"),'0'));
            	param.put("PRODT_WEIGHT", ObjUtils.nvl(param.get("PRODT_WEIGHT"),'0'));
            	param.put("RUNNER_WEIGHT", ObjUtils.nvl(param.get("RUNNER_WEIGHT"),'0'));
            	param.put("PRODT_SIZE_W", ObjUtils.nvl(param.get("PRODT_SIZE_W"),'0'));
            	param.put("PRODT_SIZE_L", ObjUtils.nvl(param.get("PRODT_SIZE_L"),'0'));
            	param.put("PRODT_SIZE_H", ObjUtils.nvl(param.get("PRODT_SIZE_H"),'0'));
            	param.put("PRODT_SIZE_P", ObjUtils.nvl(param.get("PRODT_SIZE_P"),'0'));
            	param.put("WORK_Q", ObjUtils.nvl(param.get("WORK_Q"),'0'));
            	param.put("CYCLE_TIME", ObjUtils.nvl(param.get("CYCLE_TIME"),'0'));
            	param.put("CAPA_Q", ObjUtils.nvl(param.get("CAPA_Q"),'0'));
            	param.put("PRODT_O", ObjUtils.nvl(param.get("PRODT_O"),'0'));
            	param.put("TOTAL_Q", ObjUtils.nvl(param.get("TOTAL_Q"),'0'));
            	param.put("AUDIT_Q", ObjUtils.nvl(param.get("AUDIT_Q"),'0'));
            	param.put("MAX_Q", ObjUtils.nvl(param.get("MAX_Q"),'0'));
                super.commonDao.update("equ201ukrvService.insertSub", param);
            }
            return ;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "equip")
        public void updateSub(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
                super.commonDao.update("equ201ukrvService.updateSub", param);
            }
            return ;
        }
        
        @ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
        public void deleteSub(List<Map> paramList,  LoginVO user) throws Exception {
            for(Map param :paramList ) {
               super.commonDao.update("equ201ukrvService.deleteSub", param);
            }
            return ;
        }
    	
        
        
        
        
        
        /**
         * 파일업로드 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @SuppressWarnings("unchecked")
        @ExtDirectMethod(group = "jim")
        public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
            param.put("S_COMP_CODE", login.getCompCode());
            return super.commonDao.list("equ201ukrvService.getFileList", param);
        }
        
        private void insertBDC101(Map param) throws Exception {
             String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");      
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.insert("equ201ukrvService.insertBDC101", param);
             }
        }
        
        private void deleteBDC101(Map param) throws Exception {
            String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.update("equ201ukrvService.deleteBDC101", param);
             }
        }
}
