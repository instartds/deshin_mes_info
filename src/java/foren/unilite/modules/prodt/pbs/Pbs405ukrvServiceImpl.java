package foren.unilite.modules.prodt.pbs;

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

@Service("pbs405ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Pbs405ukrvServiceImpl  extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 *  설비별 표준CAPA 등록 - 조회
	 * @param param 
	 * @return
	 * @throws Exception
	 */	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("pbs405ukrvServiceImpl.selectList", param);
	}


	/**
	 *  설비별 표준CAPA 등록 - 메인저장
	 * @param param 
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if (dataListMap.get("method").equals("insertList")) {			//추가
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateList")) {		//수정
					updateList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteList")) {		//삭제
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}


	/**
	 *  설비별 표준CAPA 등록 - 추가
	 * @param param 
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "prodt" )
	public Integer insertList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
//		try {
		for (Map param : paramList) {
			List<Map> chkList = (List) super.commonDao.list("pbs405ukrvServiceImpl.selectList", param);
			if (chkList.size() > 0) {
				 for(Map chk : chkList) {
					 throw new UniDirectValidateException("중복되는 자료가 입력되었습니다."
								+ "\n작업장: "+ ObjUtils.getSafeString(chk.get("TREE_NAME"))+ "" 
								+ "\n설비 : "+ ObjUtils.getSafeString(chk.get("EQU_CODE")));
				}
			} else {
				super.commonDao.insert("pbs405ukrvServiceImpl.insertList", param);
			}
		}
//		} catch (Exception e) {
//			throw new UniDirectValidateException(this.getMessage("8114", user));
//		}
		return 0;
	}


	/**
	 *  설비별 표준CAPA 등록- 수정
	 * @param param 
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("pbs405ukrvServiceImpl.updateList", param);
		}
		return 0;
	}


	/**
	 *  설비별 표준CAPA 등록 - 삭제
	 * @param param 
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "prodt" )
	public Integer deleteList(List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
//			try {
				super.commonDao.delete("pbs405ukrvServiceImpl.deleteList", param);
//			} catch (Exception e) {
//				throw new UniDirectValidateException(this.getMessage("547", user));
//			}
		}
		return 0;
	}
}
