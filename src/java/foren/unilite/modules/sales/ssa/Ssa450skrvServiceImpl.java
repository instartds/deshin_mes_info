package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa450skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ssa450skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 매출현황- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return (List) super.commonDao.list("ssa450skrvServiceImpl.selectList1", param);
	}

	/**
	 * 출력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  printList(Map param) throws Exception {
		if(ObjUtils.isNotEmpty(param.get("WH_CODE"))) {
			String[] whCode = param.get("WH_CODE").toString().split(",");
			param.put("WH_CODE" , whCode);
		}
		if(ObjUtils.isNotEmpty(param.get("WH_CELL_CODE"))) {
			String[] whCellCode	= param.get("WH_CELL_CODE").toString().split(",");
			param.put("WH_CELL_CODE", whCellCode);
		}
		return  super.commonDao.list("ssa450skrvServiceImpl.printList", param);
	}
}