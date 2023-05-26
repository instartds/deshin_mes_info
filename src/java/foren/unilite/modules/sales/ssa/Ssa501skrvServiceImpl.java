package foren.unilite.modules.sales.ssa;

import java.io.File;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa501skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ssa501skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 매출실적집계표- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("ssa501skrvServiceImpl.selectList", param);
	}
}
