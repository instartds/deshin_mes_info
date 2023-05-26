package foren.unilite.modules.z_hs;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_pmp200rkrv_hsService")
public class S_Pmp200rkrv_hsServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 제품라벨출력 그리드조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("s_pmp200rkrv_hsServiceImpl.selectList", param);
	}
	
	/**
	 * 라벨 출력쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectPrint(Map param) throws Exception {
		
		return  super.commonDao.list("s_pmp200rkrv_hsServiceImpl.selectPrint", param);
	}
	
}
