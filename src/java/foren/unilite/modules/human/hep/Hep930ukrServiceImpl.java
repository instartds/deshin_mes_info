package foren.unilite.modules.human.hep;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hep930ukrService")
public class Hep930ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
	 * 평가관리 - 직급코드 콤보박스 ( 일반직2급, 일반직3급 합침 )
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getAbilCodeList(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("hep930ukrServiceImpl.getAbilCodeList", param);
        
    }
	/**
     * 평가관리 - 등급별인원수 계산 관련 배분기준조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "hep", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> calcRatingSelectList(Map param) throws Exception {
        return super.commonDao.list("hep930ukrServiceImpl.calcRatingSelectList", param);
    }
	
    /**
     * 평가관리 - 등급별인원수 계산 관련 배분기준생성
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hep")
    public String calcRatingCreate(Map param, LoginVO user) throws Exception {
        String reV = "";
                
        reV = "Y";

        try{
            super.commonDao.update("hep930ukrServiceImpl.calcRatingCreate", param);
        
        }catch(Exception e){
            reV = "N";
        }
        return reV;
            
    } 
    /**
     * 평가관리 - 등급별인원수 계산 관련 저장
     * 
     * **/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hep")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> calcRatingSaveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        if(paramList != null)   {
            List<Map> updateList = null;   
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("calcRatingUpdate")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                }
            }
            if(updateList != null) this.calcRatingUpdate(updateList, user);             
        }
        paramList.add(0, paramMaster);
        return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hep")
    public void calcRatingUpdate(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            
            for(int i=0; i<5; i++){
                if(i==0){
                    param.put("MERITS_CLASS", "S");
                    param.put("APLC_NUM",param.get("S_GRADE"));
                    super.commonDao.update("hep930ukrServiceImpl.calcRatingUpdate", param);
                    
                }else if(i==1){
                    param.put("MERITS_CLASS", "A");
                    param.put("APLC_NUM",param.get("A_GRADE"));
                    super.commonDao.update("hep930ukrServiceImpl.calcRatingUpdate", param);
                    
                }else if(i==2){
                    param.put("MERITS_CLASS", "B");
                    param.put("APLC_NUM",param.get("B_GRADE"));
                    super.commonDao.update("hep930ukrServiceImpl.calcRatingUpdate", param);
                    
                }else if(i==3){
                    param.put("MERITS_CLASS", "C");
                    param.put("APLC_NUM",param.get("C_GRADE"));
                    super.commonDao.update("hep930ukrServiceImpl.calcRatingUpdate", param);
                    
                }else if(i==4){
                    param.put("MERITS_CLASS", "D");
                    param.put("APLC_NUM",param.get("D_GRADE"));
                    super.commonDao.update("hep930ukrServiceImpl.calcRatingUpdate", param);
                    
                }
            }
        }
         return;
    } 
    
    
    /**
     * 평가관리 - 평가대상자 생성
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hep")
    public String personCreate(Map param, LoginVO user) throws Exception {
        String reV = "";
        reV = "Y";
        
        String perC = "Y";

        try{
            perC = (String) super.commonDao.select("hep930ukrServiceImpl.personCheck", param);
            
            if(perC == "N"){
                reV = "PN";
            }else{
                super.commonDao.update("hep930ukrServiceImpl.personCreate", param);
                
                
            }
            
            //super.commonDao.update("hep930ukrServiceImpl.personCreate", param);
        
        }catch(Exception e){
            reV = "N";
        }
        return reV;
            
    } 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
	/**
	 * 평가관리조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hep", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("hep930ukrServiceImpl.selectList", param);
    }
	


	/**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hep")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)   {
            List<Map> updateList = null;    
           
            for(Map dataListMap: paramList) {
            	
                if(dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                }
            }
            if(updateList != null) this.updateDetail(updateList, user, paramMaster);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hep")
    public void updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {

        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        
        if(dataMaster.get("buttonFlag").equals("refBtn3")){
            for(Map param :paramList )  {
                /* 평가점수계산버튼 누를시 HEP930T에 각점수 항목 계산해서 UPDATE */
                super.commonDao.update("hep930ukrServiceImpl.updateDetail1", param);
            }
        
            /* 평가점수계산버튼 누를시 HEP930T 에 저장 후 그 데이터를 토대로 순위와 등급 생성 시키는 프로세스*/
            super.commonDao.update("hep930ukrServiceImpl.mainCalcRating", dataMaster);
        }else{
            for(Map param :paramList )  {
                /* HEP930T에 최종등급, 조정등급, 조정사유 UPDATE */
                if(ObjUtils.isNotEmpty(param.get("ADJU_MERITS_CLASS"))){
                    if(ObjUtils.isEmpty(param.get("ADJU_RESN"))){
                        throw new  UniDirectValidateException("등급조정한 데이터의 조정사유를 입력 해주세요.");
                    }
                }
                super.commonDao.update("hep930ukrServiceImpl.updateDetail2", param);
            }
        }
        
        
         return;
    } 
    
    
    

    @ExtDirectMethod(group = "hep", value = ExtDirectMethodType.STORE_READ)        // 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("hep930ukrServiceImpl.selectExcelUploadSheet1", param);
    }
    
    @ExtDirectMethod(group = "hep", value = ExtDirectMethodType.STORE_READ)     // 엑셀 적용 사번에 해당하는 데이터 포함
    public List<Map<String, Object>> selectExcelUploadApply(Map param) throws Exception {
        return super.commonDao.list("hep930ukrServiceImpl.selectExcelUploadApply", param);
    }
    
    public void excelValidate(String jobID, Map param) {                            // 엑셀 Validate
        logger.debug("validate: {}", jobID);
        super.commonDao.update("hep930ukrServiceImpl.excelValidate", param);
    }
    
    
    
}
