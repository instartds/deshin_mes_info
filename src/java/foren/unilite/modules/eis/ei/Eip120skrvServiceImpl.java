package foren.unilite.modules.eis.ei;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "eip120skrvService" )
public class Eip120skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 공장별 사내불량현황 조회
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "eis" )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {;
		return  super.commonDao.list("eip120skrvServiceImpl.selectList", param);

	}

	/**
	 * 공장별 사내불량현황 조회 차트
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "eis" )
	public List<Map<String, Object>> selectChart( Map param ) throws Exception {
		return  super.commonDao.list("eip120skrvServiceImpl.selectChart", param);
	}

}
