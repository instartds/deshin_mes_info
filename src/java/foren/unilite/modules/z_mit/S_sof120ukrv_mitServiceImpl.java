package foren.unilite.modules.z_mit;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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

@Service("s_sof120ukrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_sof120ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * 수주데이터 조회
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_sof120ukrv_mitServiceImpl.selectDetailList", param);
	}



	/**
	 * 저장!!!!
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> insertDetail = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
			if(insertDetail != null) this.updateDetail(insertDetail, user, dataMaster);
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList) {
			if("Y".equals(param.get("CHECK_YN"))) {
				param.put("CONFIRM_YN", paramMaster.get("CONFIRM_YN"));
				super.commonDao.update("s_sof120ukrv_mitServiceImpl.updateDetail", param);
			}
		}
		return 0;
	}

	/**삭제**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList) {
			 try {
				super.commonDao.delete("s_sof120ukrv_mitServiceImpl.deleteDetail", param);
			} catch(Exception e) {
					throw new UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}





	/**
	 *출고예정표(MIT) 출력로직 추가 - 20191205
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  printList(Map param) throws Exception {
		return  super.commonDao.list("s_sof120ukrv_mitServiceImpl.printList", param);
	}
}