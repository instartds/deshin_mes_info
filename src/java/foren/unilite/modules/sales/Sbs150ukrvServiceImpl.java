package foren.unilite.modules.sales;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("sbs150ukrvService")
public class Sbs150ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(group = "sbs")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	/**
	 * 배송처 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sbs")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("sbs150ukrvServiceImpl.selectList", param);
	}

	/**
	 * 거래처 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sbs")
	public List<Map<String, Object>>  customCodeList(Map param) throws Exception {
		return  super.commonDao.list("sbs150ukrvServiceImpl.customCodeList", param);
	}
	
	/**
	 * 배송처 입력
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sbs")
	public List<Map>  insertMulti(List<Map> paramList) throws Exception {
		
		int r = 0;


		for(Map param :paramList )	{

		    	r = super.commonDao.update("sbs150ukrvServiceImpl.insertMulti", param);

		}
		

		return  paramList;
	}
	
	/**
	 * 배송처 수정
	 * @param paramList
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "sbs")
	public List<Map>  updateMulti(List<Map> paramList,  LoginVO loginVO) throws Exception {
		int r = 0;


		for(Map param :paramList )	{
		    	r = super.commonDao.update("sbs150ukrvServiceImpl.updateMulti", param);
		}


		return  paramList;
	}
	
	/**
	 * 배송처 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sbs")
	public List<Map>  deleteMulti(List<Map> paramList) throws Exception {
		int r = 0;
		
		for(Map param :paramList )	{
				  r = super.commonDao.delete("sbs150ukrvServiceImpl.deleteMulti", param);
		}

		return  paramList;
	}
	

}
