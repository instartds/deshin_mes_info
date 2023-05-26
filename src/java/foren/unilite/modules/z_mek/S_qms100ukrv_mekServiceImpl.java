package foren.unilite.modules.z_mek;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_qms100ukrv_mekService")
public class S_qms100ukrv_mekServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 품질업무일보등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_qms100ukrv_mekServiceImpl.selectList1", param);
	}
	
	/**
	 * 품질업무일보등록 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mek")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete(deleteList, user);
			if(insertList != null) this.insert(insertList, user);
			if(updateList != null) this.update(updateList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// INSERT
	public Integer insert(List<Map> paramList, LoginVO user) throws Exception {
		try {
			for(Map param : paramList )	{
				super.commonDao.update("s_qms100ukrv_mekServiceImpl.insert", param);
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer update(List<Map> paramList, LoginVO user) throws Exception {
		try {
			for(Map param : paramList )	{
				super.commonDao.update("s_qms100ukrv_mekServiceImpl.update", param);
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// DELETE
	public Integer delete(List<Map> paramList, LoginVO user) throws Exception {
		try {
			for(Map param : paramList )	{
				super.commonDao.update("s_qms100ukrv_mekServiceImpl.delete", param);
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	/**
	 * 품질업무일보등록 출력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPrintList(Map param) throws Exception {
		return super.commonDao.list("s_qms100ukrv_mekServiceImpl.selectPrintList", param);
	}
	
}
