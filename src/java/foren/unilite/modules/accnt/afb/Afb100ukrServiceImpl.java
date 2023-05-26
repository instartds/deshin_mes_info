package foren.unilite.modules.accnt.afb;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("afb100ukrService")
public class Afb100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 
	 * Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("afb100ukrServiceImpl.selectList", param);
	}	
	/**
	 * 
	 * fnGetResultRate
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnGetResultRate(Map param) throws Exception {
		return super.commonDao.list("afb100ukrServiceImpl.fnGetResultRate", param);
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
			if(insertList != null) this.insertDetail(insertList, user, paramMaster);
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
	
		String saveMonth = (String) dataMaster.get("saveMonth");
		DateFormat transFormat = new SimpleDateFormat("yyyyMM");
//		Date td = null;
//		td = transFormat.parse(saveMonth);
//		
//		Calendar calcMonth = Calendar.getInstance();
//		calcMonth.setTime(td);

        List<Map> beforeSaveCheck = (List<Map>) super.commonDao.list("afb100ukrServiceImpl.beforeSaveCheck", dataMaster);
   
        if(ObjUtils.isNotEmpty(beforeSaveCheck)){
            throw new  UniDirectValidateException(this.getMessage("이미 확정된 데이터가 있습니다. 저장이 불가능 합니다.", user));
        }
		
		
		
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
				param.put("BUDG_I", param.get(changeM));
				super.commonDao.delete("afb100ukrServiceImpl.deleteDetail", param);
				super.commonDao.update("afb100ukrServiceImpl.insertDetail", param);
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
     * 
     * 엑셀의 내용을 읽어옴
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("afb100ukrServiceImpl.selectExcelUploadSheet1", param);
    }
    
    public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("afb100ukrServiceImpl.excelValidate", param);
	}
	

}
