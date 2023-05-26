package foren.unilite.modules.accnt.afb;

import java.util.HashMap;
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

@Service("afb500ukrService")
public class Afb500ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// BUDG_NAME컬럼수
	public List<Map<String, Object>>  selectBudgName(Map param) throws Exception {	
		return  super.commonDao.list("afb500ukrServiceImpl.selectBudgName", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		super.commonDao.list("afb500ukrServiceImpl.selectBudgName", param);
		return  super.commonDao.list("afb500ukrServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 저장전 DATACOUNT 검사
	public List<Map<String, Object>>  selectDataCnt(Map param) throws Exception {	
		return  super.commonDao.list("afb500ukrServiceImpl.selectDataCnt", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}			
			if(updateList != null) this.updateDetail(updateList, user);	
			if(insertList != null) this.insertDetail(insertList, user);	
			if(deleteList != null) this.deleteDetail(deleteList, user);		
		}
	 	paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			Map selectDataCount = (Map) super.commonDao.queryForObject("afb500ukrServiceImpl.selectDataCnt", param);
			Map selectbudgCloseFg = (Map) super.commonDao.queryForObject("afb500ukrServiceImpl.selectbudgCloseFg", param);
			if(ObjUtils.parseInt(selectDataCount.get("DATA_CNT")) > 1) {
				throw new  UniDirectValidateException(this.getMessage("55353", user));
			} else if(selectbudgCloseFg.isEmpty()) {
				throw new  UniDirectValidateException(this.getMessage("55354", user));
			} else if(selectbudgCloseFg.equals("Y")) {
				throw new  UniDirectValidateException(this.getMessage("55355", user));
			}  else {
				int i;
				String year = ObjUtils.getSafeString(param.get("AC_YYYY"));
				for(i = 1; i < 13; i++) {
					if(i < 10) {
						param.put("AC_YYYY", year + "0" + i);
						param.put("BUDG_I", param.get("BUDG_I" + "0" + i));
						if(param.get("BUDG_I" + "0" + i).equals("0")) {
							for(i = 1; i < 13; i++) {
								if(i < 10) {
									param.put("AC_YYYY", year + "0" + i);
								} else {
									param.put("AC_YYYY", year + i);
								}
								param.put("WORK_FLAG", "D");
								super.commonDao.update("afb500ukrServiceImpl.deleteDetail", param);
							}
						}
					} else {
						param.put("AC_YYYY", year + i);
						param.put("BUDG_I", param.get("BUDG_I" + i));
						if(param.get("BUDG_I" + i).equals("0")) {
							for(i = 1; i < 13; i++) {
								if(i < 10) {
									param.put("AC_YYYY", year + "0" + i);
								} else {
									param.put("AC_YYYY", year + i);
								}
								param.put("WORK_FLAG", "D");
								super.commonDao.update("afb500ukrServiceImpl.deleteDetail", param);
							}
						}
					}
					param.put("WORK_FLAG", "N");
					super.commonDao.update("afb500ukrServiceImpl.updateDetail", param);
				}
			}
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			Map selectDataCount = (Map) super.commonDao.queryForObject("afb500ukrServiceImpl.selectDataCnt", param);
			Map selectbudgCloseFg = (Map) super.commonDao.queryForObject("afb500ukrServiceImpl.selectbudgCloseFg", param);
			if(ObjUtils.parseInt(selectDataCount.get("DATA_CNT")) > 1) {
				throw new  UniDirectValidateException(this.getMessage("55353", user));
			} else if(selectbudgCloseFg.isEmpty()) {
				throw new  UniDirectValidateException(this.getMessage("55354", user));
			} else if(selectbudgCloseFg.equals("Y")) {
				throw new  UniDirectValidateException(this.getMessage("55355", user));
			}  else {
				int i;
				String year = ObjUtils.getSafeString(param.get("AC_YYYY"));
				for(i = 1; i < 13; i++) {
					if(i < 10) {
						param.put("AC_YYYY", year + "0" + i);
						param.put("BUDG_I", param.get("BUDG_I" + "0" + i));
						if(param.get("BUDG_I" + "0" + i).equals("0")) {
							for(i = 1; i < 13; i++) {
								if(i < 10) {
									param.put("AC_YYYY", year + "0" + i);
								} else {
									param.put("AC_YYYY", year + i);
								}
								param.put("WORK_FLAG", "D");
								super.commonDao.update("afb500ukrServiceImpl.deleteDetail", param);
							}
						}
					} else {
						param.put("AC_YYYY", year + i);
						param.put("BUDG_I", param.get("BUDG_I" + i));
						if(param.get("BUDG_I" + i).equals("0")) {
							for(i = 1; i < 13; i++) {
								if(i < 10) {
									param.put("AC_YYYY", year + "0" + i);
								} else {
									param.put("AC_YYYY", year + i);
								}
								param.put("WORK_FLAG", "D");
								super.commonDao.update("afb500ukrServiceImpl.deleteDetail", param);
							}
						}
					}
					param.put("WORK_FLAG", "U");
					super.commonDao.update("afb500ukrServiceImpl.updateDetail", param);
				}
			}
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// DELETE
	public Integer deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			Map selectDataCount = (Map) super.commonDao.queryForObject("afb500ukrServiceImpl.selectDataCnt", param);
			Map selectbudgCloseFg = (Map) super.commonDao.queryForObject("afb500ukrServiceImpl.selectbudgCloseFg", param);
			if(ObjUtils.parseInt(selectDataCount.get("DATA_CNT")) > 1) {
				throw new  UniDirectValidateException(this.getMessage("55353", user));
			} else if(selectbudgCloseFg.isEmpty()) {
				throw new  UniDirectValidateException(this.getMessage("55354", user));
			} else if(selectbudgCloseFg.equals("Y")) {
				throw new  UniDirectValidateException(this.getMessage("55355", user));
			}  else {
				int i;
				String year = ObjUtils.getSafeString(param.get("AC_YYYY"));
				for(i = 1; i < 13; i++) {
					if(i < 10) {
						param.put("AC_YYYY", year + "0" + i);
					} else {
						param.put("AC_YYYY", year + i);
					}
					param.put("WORK_FLAG", "D");
					super.commonDao.update("afb500ukrServiceImpl.deleteDetail", param);
				}
			}
		}
		return 0;
	} 
}
