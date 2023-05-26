package foren.unilite.modules.base.bor;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("bor140ukrvService")
public class Bor140ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());
	//database replication을 위한 옵션
	private Boolean replication = Boolean.parseBoolean(ConfigUtil.getString("common.dataOption.replication", "false"));	//OmegaPlus.xml replication 설정값 default : false

	/**
	 *  관계사정보 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectDetailList(Map param) throws Exception {		
		
		return super.commonDao.list("bor140ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
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
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/**
	 * 추가를 위한 더미 메소드 
	 * 실제 동작은 form post를 통해서 이루어짐
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param :paramList ) {
				
				param.put("COMPANY_NUM"	 , param.get("COMPANY_NUM").toString().replace("-", ""));			/*사업자등록번호*/
				param.put("ZIP_CODE"	 , param.get("ZIP_CODE").toString().replace("-", ""));				/*회사주소 우편번호*/
				param.put("REPRE_NO"	 , param.get("REPRE_NO").toString().replace("-", ""));			/*주민등록번호*/
				
				super.commonDao.insert("bor140ukrvServiceImpl.insertList", param);
				if(replication){
	                super.commonDao.update("bor140ukrvRepServiceImpl.insertList", param);
	            }
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}
	
	
	/**
	 * 수정을 위한 더미 메소드 
	 * 실제 동작은 form post를 통해서 이루어짐
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			
			param.put("COMPANY_NUM"	 , param.get("COMPANY_NUM").toString().replace("-", ""));			/*사업자등록번호*/
			param.put("ZIP_CODE"	 , param.get("ZIP_CODE").toString().replace("-", ""));			/*회사주소 우편번호*/
			param.put("REPRE_NO"	 , param.get("REPRE_NO").toString().replace("-", ""));			/*주민등록번호*/
			
			super.commonDao.update("bor140ukrvServiceImpl.updateList", param);
			if(replication){
	            super.commonDao.update("bor140ukrvRepServiceImpl.updateList", param);
	        }
		 }
		 return 0;
	}
	
	
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {	
		for(Map param :paramList ) {
			super.commonDao.delete("bor140ukrvServiceImpl.deleteList", param);
			if(replication){
                super.commonDao.update("bor140ukrvRepServiceImpl.deleteList", param);
            }
		}
		
		return 0;
	}	

}
