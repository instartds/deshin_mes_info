package foren.unilite.modules.sales.sgp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sgp200skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sgp200skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 주간 판매계획대 실적현황조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sgp")
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		//구분설정
		Map gubuns = (Map) super.commonDao.select("sgp200skrvServiceImpl.selectGubun", param);
		param.put("sGubun1", gubuns.get("GUBUN1"));
		param.put("sGubun2", gubuns.get("GUBUN2"));
		param.put("sGubun3", gubuns.get("GUBUN3"));
		
		//1주~10주 가져오기
		List<Map> calNos = super.commonDao.list("sgp200skrvServiceImpl.selectCalNo", param);
		param.put("calNos", calNos);
		for(int i=0; i < calNos.size(); i++){
			param.put("sWeek"+i, calNos.get(i).get("CAL_NO"));
			param.put("sYear"+i, calNos.get(i).get("SYEAR"));
		}

		return  super.commonDao.list("sgp200skrvServiceImpl.selectList", param);
	}
}
