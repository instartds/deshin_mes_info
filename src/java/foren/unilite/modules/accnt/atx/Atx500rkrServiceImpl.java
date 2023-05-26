package foren.unilite.modules.accnt.atx;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("atx500rkrService")
public class Atx500rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 내국신용장.구매확인 전자발급명세서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	//데이터 조회
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPrintMaster(Map param) throws Exception {
		return super.commonDao.list("atx500ukrServiceImpl.selectListInit", param);
	}
	//합계 조회
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPrintDetail(Map param) throws Exception {
		return super.commonDao.list("atx500ukrServiceImpl.selectPrintDetail", param);
	}

}
