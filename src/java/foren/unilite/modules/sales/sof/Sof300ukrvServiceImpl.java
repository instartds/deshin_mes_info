package foren.unilite.modules.sales.sof;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sof300ukrvService")
public class Sof300ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수주승인조회(상단) 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("sof300ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 수주승인조회(하단) 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  detailList(Map param) throws Exception {
	
		return  super.commonDao.list("sof300ukrvServiceImpl.detailList", param);
	}
	
}
