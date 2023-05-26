package foren.unilite.modules.accnt.afb;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
import foren.unilite.com.validator.UniDirectValidateException;



@Service("afb110ukrService")
public class Afb110ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
     * 예산총액/잔액  관련
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> spAccntGetPossibleBudgAmt110(Map param , LoginVO user) throws Exception {
        return super.commonDao.list("afb110ukrServiceImpl.spAccntGetPossibleBudgAmt110_1", param);
    }
	/**
	 * checkSelect
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> checkSelect(Map param) throws Exception {
		return super.commonDao.list("afb110ukrServiceImpl.checkSelect", param);
	}
	
	/**
	 * Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		if(param.get("gsReset").equals("Y")){
			return super.commonDao.list("afb110ukrServiceImpl.selectNewList", param);
		}else{
			if(super.commonDao.list("afb110ukrServiceImpl.checkSelect", param).isEmpty()){
				return super.commonDao.list("afb110ukrServiceImpl.selectNewList", param);
			}else{
				return super.commonDao.list("afb110ukrServiceImpl.selectList", param);
			}
		}
	}
	
	/**
	 * fnGetResultRate
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnGetResultRate(Map param) throws Exception {
		return super.commonDao.list("afb110ukrServiceImpl.fnGetResultRate", param);
	}
	
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
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
			if(deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
			if(insertList != null) this.updateDetail(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		return;
	}	
	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(dataMaster.get("gsReset").equals("Y")){
			super.commonDao.delete("afb110ukrServiceImpl.deleteReset", dataMaster);
			super.commonDao.update("afb110ukrServiceImpl.updateReset", dataMaster);
		}
		
		String saveMonth = (String) dataMaster.get("saveMonth");
		DateFormat transFormat = new SimpleDateFormat("yyyyMM");

		for(Map param :paramList )	{
			Date td = null;
			td = transFormat.parse(saveMonth);
			
			Calendar calcMonth = Calendar.getInstance();
			calcMonth.setTime(td);
			for(int i=1; i<13; i++){
				if(i != 1){
					calcMonth.add(Calendar.MONTH, 1);
				}
				String changeYM = transFormat.format(calcMonth.getTime());
				param.put("BUDG_YYYYMM", changeYM);
				String changeM = changeYM.substring(4);
				param.put("BUDG_CONF_I", param.get(changeM));
				
				
				List<Map> beforeSaveCheck = (List<Map>) super.commonDao.list("afb110ukrServiceImpl.spAccntGetPossibleBudgAmt110_1", param);
				if(ObjUtils.isNotEmpty(beforeSaveCheck)){
				    if(ObjUtils.parseFloat(ObjUtils.getSafeString(param.get(changeM))) < ObjUtils.parseFloat(ObjUtils.getSafeString(beforeSaveCheck.get(0).get("ACTUAL_I")))){
				        throw new  UniDirectValidateException(this.getMessage("실적 금액보다 작은 금액은 입력될 수 없습니다.", user));
				    }
				}
				
				float rsAmtI = 0;
				float rsBudgI = 0;
				double budgConfI = 0;
				budgConfI = (double) Integer.parseInt(param.get(changeM).toString());
				
				List<Map> beforeSave = (List<Map>) super.commonDao.list("afb110ukrServiceImpl.beforeSave", param);
				if(!beforeSave.isEmpty()){
					rsAmtI = ObjUtils.parseFloat(ObjUtils.getSafeString(beforeSave.get(0).get("AC_AMT_I")));
					rsBudgI = ObjUtils.parseFloat(ObjUtils.getSafeString(beforeSave.get(0).get("BUDG_I")));

				}else{
					rsAmtI = 0;
					rsBudgI = 0;
				}
				
				if(budgConfI != 0 || rsAmtI != 0 || rsBudgI != 0){
//					super.commonDao.delete("afb110ukrServiceImpl.deleteDetail", param);
					super.commonDao.update("afb110ukrServiceImpl.updateDetail", param);
				}else if(budgConfI == 0){
					super.commonDao.delete("afb110ukrServiceImpl.deleteDetail", param);
				}
			}
		 }		 
		 return;
	} 
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 return;
	}
	
	/**
     * 엑셀업로드 관련 중
     * @param jobID
     * @param param
     */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})  
    public void excelValidate(String jobID, Map param) throws Exception {
        logger.debug("validate: {}", jobID);
            
            List<Map> excelCheck = (List<Map>) super.commonDao.list("afb110ukrServiceImpl.beforeExcelCheck", param);
            
            if(!excelCheck.isEmpty()){
                for(Map excelLogParam : excelCheck )  {
                    if(param.get("DEPT_CODE_M").equals(excelLogParam.get("DEPT_CODE"))){
                        for(int i=1; i<13; i++){
                            
                            if(i < 10){
                                param.put("BUDG_YYYYMM", param.get("AC_YYYY") + "0"+ Integer.toString(i));
                                
                            }else{
                                param.put("BUDG_YYYYMM", param.get("AC_YYYY") + Integer.toString(i));
                            }
                            
                            
                            param.put("DEPT_CODE", excelLogParam.get("DEPT_CODE"));
                            param.put("ACCNT", excelLogParam.get("ACCNT"));
                         //   param.put("DEPT_NAME", excelLogParam.get("DEPT_NAME"));
                            
                            param.put("BUDG_CONF_I", excelLogParam.get("M"+ Integer.toString(i)));
                            param.put("ROWNUM", excelLogParam.get("_EXCEL_ROWNUM"));
                            
                            param.put("CAL_DIVI", "1");
                            
                            
                            super.commonDao.update("afb110ukrServiceImpl.excelValidate", param);
                        }
                    }
                }
            }
        
//            super.commonDao.update("afb110ukrServiceImpl.excelValidate", param);    
        
        
            return;
    }
	
}
