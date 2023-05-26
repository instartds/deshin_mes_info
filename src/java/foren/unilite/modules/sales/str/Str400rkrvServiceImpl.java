package foren.unilite.modules.sales.str;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("str400rkrvServiceImpl")
public class Str400rkrvServiceImpl  extends TlabAbstractServiceImpl {
	/**
	 * 거래명세서 목록 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("str400rkrvServiceImpl.mainReport", param); 
	}
	
	/**
	 * 거래명세서 목록 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("str400rkrvServiceImpl.subReport", param); 
	}
	
	/**
	 * 거래명세서 목록 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	public List<Map<String, Object>>  getTransactionReceipt(Map param) throws Exception {
	
		return  super.commonDao.list("str400rkrvServiceImpl.getTransactionReceipt", param); 
	}
}
