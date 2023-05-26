package foren.unilite.modules.z_yp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "s_eis000skrv_ypService" )
public class S_eis000skrv_ypServiceImpl extends TlabAbstractServiceImpl {
	
	/**
	 * 매출현황 조회
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_yp" )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {
		
		return super.commonDao.list("s_eis000skrv_ypServiceImpl.selectList", param);
	}
	
}
