package foren.unilite.modules.z_kocis;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "s_bor120ukrvService_KOCIS" )
public class S_Bor120ukrvServiceImpl_KOCIS extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    public final static String FILE_TYPE_OF_PHOTO = "z_kocis";
    
    /**
     * 사업장정보 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "base" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("s_bor120ukrvServiceImpl_KOCIS.selectList", param);
    }
    
    /**
     * add by Chen.Rd
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "base" )
    public List<Map<String, Object>> selectByDivCodeAndCompCode( Map param ) throws Exception {
        return super.commonDao.list("s_bor120ukrvServiceImpl_KOCIS.selectByDivCodeAndCompCode", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> insertMulti( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            String orgZipCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
            String orgRepreNo = ObjUtils.getSafeString(param.get("REPRE_NO"));
            String orgCompanyNum = ObjUtils.getSafeString(param.get("COMPANY_NUM"));
            String orgTaxNum = ObjUtils.getSafeString(param.get("TAX_NUM"));
            
            if (!ObjUtils.isEmpty(param.get("ZIP_CODE"))) {
                param.put("ZIP_CODE", ObjUtils.getSafeString(param.get("ZIP_CODE")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("REPRE_NO"))) {
                param.put("REPRE_NO", ObjUtils.getSafeString(param.get("REPRE_NO")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("COMPANY_NUM"))) {
                param.put("COMPANY_NUM", ObjUtils.getSafeString(param.get("COMPANY_NUM")).replaceAll("\\-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("TAX_NUM"))) {
                param.put("TAX_NUM", ObjUtils.getSafeString(param.get("TAX_NUM")).replace("-", ""));
            }
            super.commonDao.insert("s_bor120ukrvServiceImpl_KOCIS.insert", param);
            
            param.put("ZIP_CODE", orgZipCode);
            param.put("REPRE_NO", orgRepreNo);
            param.put("COMPANY_NUM", orgCompanyNum);
            param.put("TAX_NUM", orgTaxNum);
        }
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> updateMulti( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            String orgZipCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
            String orgRepreNo = ObjUtils.getSafeString(param.get("REPRE_NO"));
            String orgCompanyNum = ObjUtils.getSafeString(param.get("COMPANY_NUM"));
            String orgTaxNum = ObjUtils.getSafeString(param.get("TAX_NUM"));
            
            if (!ObjUtils.isEmpty(param.get("ZIP_CODE"))) {
                param.put("ZIP_CODE", ObjUtils.getSafeString(param.get("ZIP_CODE")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("REPRE_NO"))) {
                param.put("REPRE_NO", ObjUtils.getSafeString(param.get("REPRE_NO")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("COMPANY_NUM"))) {
                param.put("COMPANY_NUM", ObjUtils.getSafeString(param.get("COMPANY_NUM")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("TAX_NUM"))) {
                param.put("TAX_NUM", ObjUtils.getSafeString(param.get("TAX_NUM")).replace("-", ""));
            }
            int r = super.commonDao.update("s_bor120ukrvServiceImpl_KOCIS.update", param);
            
            param.put("ZIP_CODE", orgZipCode);
            param.put("REPRE_NO", orgRepreNo);
            param.put("COMPANY_NUM", orgCompanyNum);
            param.put("TAX_NUM", orgTaxNum);
        }
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> deleteMulti( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            int r = super.commonDao.update("s_bor120ukrvServiceImpl_KOCIS.delete", param);
        }
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteMulti")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertMulti")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("updateMulti")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteMulti(deleteList);
            if (insertList != null) this.insertMulti(insertList);
            if (updateList != null) this.updateMulti(updateList);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }

    /**
     * 직인이미지 업로드
     * 
     * @param file1
     * @return
     * @throws IOException
     */
    //public ExtDirectFormPostResult photoUploadFile(@RequestParam("photoFile") MultipartFile file, @RequestParam("PERSON_NUMB") String personNumb) throws IOException, Exception {
    @ExtDirectMethod( group = "hum", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult photoUploadFile1( @RequestParam( "photoFile" ) MultipartFile file, S_Hum100ukrModel_KOCIS param, LoginVO user ) throws IOException, Exception {
        
        String divCode = param.getDIV_CODE();
        
//      ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
        if (file != null && !file.isEmpty()) {
            logger.debug("getOriginalFilename Name : " + file.getOriginalFilename());
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
            
            if (!"jpg".equals(fileExtension)) {
                throw new UniDirectValidateException("jpg 파일로 올려주세요.");
            }
            
            String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO);
            if (file.getSize() > 0) {
                File tmpFile = new File(path);
                //폴더가 존재하지 않을 경우, 폴더 생성
                if(!tmpFile.exists()) {
                    tmpFile.mkdirs();
                }
                tmpFile = new File(path + "/" + divCode + '.' + fileExtension);
                file.transferTo(tmpFile);
                
                Map<String, Object> spParam = new HashMap<String, Object>();
                spParam.put("S_COMP_CODE"   , user.getCompCode());
                spParam.put("S_USER_ID"     , user.getUserID());
                spParam.put("DIV_CODE"      , param.getDIV_CODE());
                spParam.put("IMGE"          , ObjUtils.getSafeString(tmpFile));

                logger.debug("IMGE      : " + spParam.get("IMGE"));
                logger.debug("DIV_CODE  : " + spParam.get("DIV_CODE"));
                super.commonDao.update("s_bor120ukrvServiceImpl_KOCIS.photoModified1", spParam);
            }
            
        } else {
            throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
        return extResult;
    }

    /**
     * 로고이미지 업로드
     * 
     * @param file1
     * @return
     * @throws IOException
     */
    //public ExtDirectFormPostResult photoUploadFile(@RequestParam("photoFile") MultipartFile file, @RequestParam("PERSON_NUMB") String personNumb) throws IOException, Exception {
    @ExtDirectMethod( group = "hum", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult photoUploadFile2( @RequestParam( "photoFile" ) MultipartFile file, S_Hum100ukrModel_KOCIS param, LoginVO user ) throws IOException, Exception {
        
        String divCode = param.getDIV_CODE() + "_logo";
        
//      ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
        if (file != null && !file.isEmpty()) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
            
            if (!"jpg".equals(fileExtension)) {
                throw new UniDirectValidateException("jpg 파일로 올려주세요.");
            }
            
            String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO);
            if (file.getSize() > 0) {
                File tmpFile = new File(path);
                //폴더가 존재하지 않을 경우, 폴더 생성
                if(!tmpFile.exists()) {
                    tmpFile.mkdirs();
                }
                tmpFile = new File(path + "/" + divCode + '.' + fileExtension);
                file.transferTo(tmpFile);
                
                Map<String, Object> spParam = new HashMap<String, Object>();
                spParam.put("S_COMP_CODE"   , user.getCompCode());
                spParam.put("S_USER_ID"     , user.getUserID());
                spParam.put("DIV_CODE"      , param.getDIV_CODE());
                spParam.put("LOGO_IMGE"     , ObjUtils.getSafeString(tmpFile));

                logger.debug("LOGO_IMGE : " + spParam.get("LOGO_IMGE"));
                logger.debug("DIV_CODE  : " + spParam.get("DIV_CODE"));
                super.commonDao.update("s_bor120ukrvServiceImpl_KOCIS.photoModified2", spParam);
            }
            
        } else {
            throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
        return extResult;
    }    
}
