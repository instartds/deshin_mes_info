package foren.unilite.modules.human.ham;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("ham810ukrService")
public class Ham810ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 컬럼 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list(
				"ham810ukrServiceImpl.selectColumns", loginVO.getCompCode());
	}
	/**
	 * 일용직급여등록 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("ham810ukrServiceImpl.selectList", param);
	}
	/**
	 *추가
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "ham")
	public List<Map> insertList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			
			//super.commonDao.update("ham810ukrServiceImpl.insertList", param);
			int result = super.commonDao.update("ham810ukrServiceImpl.insertList", param);
			//logger.debug(aa+"");
			if(result== -1){
				throw new Exception("이미마감된자료입니다.");
				//break;
			}
		}
		return paramList;
	}
	
	/**
	 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "ham")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("ham810ukrServiceImpl.updateList", param);
		}
		return paramList;
	}
	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "ham")
	public List<Map> deleteList(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("ham810ukrServiceImpl.deleteList", param);
		}
		return paramList;
	}
	// sync All
	@ExtDirectMethod(group = "ham")
	public Integer syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
}
