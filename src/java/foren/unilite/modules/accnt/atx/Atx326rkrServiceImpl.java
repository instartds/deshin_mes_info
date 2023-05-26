package foren.unilite.modules.accnt.atx;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "atx326rkrService" )
public class Atx326rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectPrintList1( Map param ) throws Exception {
		return super.commonDao.list("atx326rkrServiceImpl.selectPrintList1", param);
	}
	
	@ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectPrintDetail1( Map param ) throws Exception {
		return super.commonDao.list("atx326rkrServiceImpl.selectPrintDetail1", param);
	}
	
	@ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectPrintList2( Map param ) throws Exception {
		return super.commonDao.list("atx326rkrServiceImpl.selectPrintList2", param);
	}
}
