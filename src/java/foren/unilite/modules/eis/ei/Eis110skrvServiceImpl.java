package foren.unilite.modules.eis.ei;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "eis110skrvService" )
public class Eis110skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 매출현황 조회
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_yp" )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {;
		return  super.commonDao.list("eis110skrvServiceImpl.selectList", param);

	}

	/**
	 * 매출현황 조회
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_yp" )
	public List<Map<String, Object>> selectList2( Map param ) throws Exception {
		return  super.commonDao.list("eis110skrvServiceImpl.selectList2", param);
	}

	/**
	 * 매출현황 조회
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_yp" )
	public List<Map<String, Object>> selectList3( Map param ) throws Exception {
		return  super.commonDao.list("eis110skrvServiceImpl.selectList3", param);
	}

	/**
	 * 매출현황 조회
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_yp" )
	public List<Map<String, Object>> selectList4( Map param ) throws Exception {
		return  super.commonDao.list("eis110skrvServiceImpl.selectList4", param);
	}

}
