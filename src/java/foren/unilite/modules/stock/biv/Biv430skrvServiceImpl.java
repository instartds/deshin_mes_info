package foren.unilite.modules.stock.biv;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biv430skrvService")		/////////////////////////// jsp의 스토어에서 정의한 쿼리 호출부분 이름 같아야함.
public class Biv430skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 매입처별 제품별 매입현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bid")			//////////////////////////// 메인 쿼리 호출
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("biv430skrvServiceImpl.selectList", param);	//////////////////////////// xml에서 쿼리 정의한 이름과 같아야함.
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		//////////////////////////// 창고초기화 쿼리
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("biv430skrvServiceImpl.userWhcode", param);	
	}
	
}
