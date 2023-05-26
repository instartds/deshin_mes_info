package foren.unilite.modules.sales.str;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("str412ukrvService")
public class Str412ukrvServiceImpl  extends TlabAbstractServiceImpl {	
	/**
	 * 
	 * 전자거래명세서 발행 MASTER(출고) - 센드빌 MASTER 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectSendBillMaster(Map param) throws Exception {	
		return  super.commonDao.list("str412ukrvServiceImpl.selectSendBillMaster", param); 
	}
	
	/**
	 * 
	 * 전자거래명세서 발행(출고) - 웹캐시 MASTER 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  WebCashMaster(Map param) throws Exception {	
		return  super.commonDao.list("str412ukrvServiceImpl.WebCashMaster", param); 
	}
	
	/**
	 * 
	 * 전자거래명세서 발행(출고) Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {	
		return  super.commonDao.list("str412ukrvServiceImpl.selectDetail", param); 
	}
	
	/**
	 * 
	 * 연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  getGsBillYN(Map param) throws Exception {	
		return  super.commonDao.list("str412ukrvServiceImpl.getGsBillYN", param); 
	}
}
