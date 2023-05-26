package foren.unilite.modules.stock.biv;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biv700skrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Biv700skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 집약전개 조회 (품목)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
	public List<Map<String, Object>> selectMasterList(Map<String, Object> param) throws Exception {
		return super.commonDao.list("biv700skrvServiceImpl.selectMasterList", param);
	}



	/**
	 * 집약전개 조회 (BOM)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
	public List<Map<String, Object>> selectDetailList(Map<String, Object> param) throws Exception {
		if("0".equals(param.get("OPTSEL"))) {
			return super.commonDao.list("biv700skrvServiceImpl.selectDetailList", param);
		} else {
			Map map = (Map) super.commonDao.select("biv700skrvServiceImpl.selectDetailList", param);
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			if(ObjUtils.isNotEmpty(map)) {
				param.put("ITEM_CODE", map.get("ITEM_CODE"));
				selectDetailList2(param, list);
			}
			return list;
		}
	}

	/**
	 * 집약전개 조회2 (BOM)
	 * @param param 검색항목
	 * @param list
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
	public List<Map<String, Object>> selectDetailList2(Map<String, Object> param, List<Map<String, Object>> list) throws Exception {
		List<Map<String, Object>> tempList = super.commonDao.list("biv700skrvServiceImpl.selectDetailList2", param);
		if(tempList != null && tempList.size()>0){
			for(Map<String, Object> map : tempList){
				list.add(map);
				param.put("ITEM_CODE", map.get("ITEM_CODE"));
				selectDetailList2(param, list);
			}
		}
		return list;
	}

	/**
	 * 공정별 생산 현황조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
	public List<Map<String, Object>> selectDetailChildList1(Map<String, Object> param) throws Exception {
		return super.commonDao.list("biv700skrvServiceImpl.selectDetailChildList1", param);
	}

	/**
	 * 예약출고 lot현황
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
	public List<Map<String, Object>> selectDetailChildList2(Map<String, Object> param) throws Exception {
		return super.commonDao.list("biv700skrvServiceImpl.selectDetailChildList2", param);
	}

	/**
	 * 품목lot이력
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpr")
	public List<Map<String, Object>> selectDetailChildList3(Map<String, Object> param) throws Exception {
		return super.commonDao.list("biv700skrvServiceImpl.selectDetailChildList3", param);
	}
}