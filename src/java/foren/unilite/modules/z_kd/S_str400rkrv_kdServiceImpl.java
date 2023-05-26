package foren.unilite.modules.z_kd;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_str400rkrv_kdService")
public class S_str400rkrv_kdServiceImpl  extends TlabAbstractServiceImpl {
	/**
	 * 거래명세서 목록 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	public List<Map<String, Object>>  getTransactionReceipt(Map param) throws Exception {
	
		return  super.commonDao.list("s_str400rkrv_kdService.getTransactionReceipt", param); 
	}
}
