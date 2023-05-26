package foren.unilite.modules.z_kd;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "s_afn100skr_kdService" )
public class S_Afn100skr_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@SuppressWarnings( { "unchecked", "rawtypes" } )
	@ExtDirectMethod( group = "z_kd", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {
		return (List)super.commonDao.list("s_afn100skr_kdServiceImpl.selectList", param);
	}

}
