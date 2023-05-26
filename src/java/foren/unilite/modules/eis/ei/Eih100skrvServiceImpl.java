package foren.unilite.modules.eis.ei;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "eih100skrvService" )
public class Eih100skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 월별인원현황
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_yp" )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {

		return super.commonDao.list("eih100skrvServiceImpl.selectList", param);
	}

	/**
	 * 월별인원현황 차트 데이터
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_yp" )
	public List<Map<String, Object>> selectChartList( Map param ) throws Exception {

		return super.commonDao.list("eih100skrvServiceImpl.selectChartList", param);
	}


}
