package foren.unilite.modules.human.hum;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hum280skrService")
public class Hum280skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 연간입퇴사자 목록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectDataList(Map param) throws Exception {
		String strAnnFrDate = (String)param.get("ANN_FR_DATE");
		String strAnnToDate = (String)param.get("ANN_TO_DATE");
		
		int annFrDate = Integer.parseInt(strAnnFrDate);
		int annToDate = Integer.parseInt(strAnnToDate);
		
		List<Map> calYearList = new ArrayList<Map>();
		
		// 조회 기준 년도 목록 추출
		for (int year = annFrDate; year <= annToDate; year++) {
			Map calYearMap = new HashMap();
			
			calYearMap.put("YEAR", String.valueOf(year));
			
			calYearList.add(calYearMap);
		}
		
		param.put("CAL_YEAR_LIST", calYearList);
		
		return (List) super.commonDao.list("hum280skrServiceImpl.selectDataList", param);
	}
}
