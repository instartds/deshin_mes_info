package foren.unilite.modules.human.hum;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hum250skrService")
public class Hum250skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 기간별 인원현황 목록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectDataList(Map param) throws Exception {
		String strAnnDateFrom = (String)param.get("ANN_DATE_FROM");
		String strAnnDateTo   = (String)param.get("ANN_DATE_TO");
		
		// 조회 월집합
		List calDateList = new ArrayList<Map>();
		
		// 시작 년월
		int annDateFrom      = Integer.parseInt(strAnnDateFrom);
		int annDateFromYear  = Integer.parseInt(strAnnDateFrom.substring(0, 4));
		int annDateFromMonth = Integer.parseInt(strAnnDateFrom.substring(4, 6));
		
		// 종료 년월
		int annDateTo      = Integer.parseInt(strAnnDateTo);
		int annDateToYear  = Integer.parseInt(strAnnDateTo.substring(0, 4));
		int annDateToMonth = Integer.parseInt(strAnnDateTo.substring(4, 6));
		
		// 두 기간 사이의 월수 구하기
		int dateItv = (annDateToYear - annDateFromYear) * 12 + (annDateToMonth - annDateFromMonth);
		
		for (int i = 0; i <= dateItv; i++) {
			Map calDate = new HashMap();
			
			DateFormat format = new SimpleDateFormat("yyyyMM");
			Date date = format.parse(String.valueOf(strAnnDateFrom));

			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);

			calendar.add(Calendar.MONTH, i);
			String dateMontFrom = format.format(calendar.getTime());
			
			calendar.add(Calendar.MONTH, 1);
			String dateMontTo = format.format(calendar.getTime());
			
			calDate.put("YEAR", dateMontFrom.substring(0, 4));
			calDate.put("MONTH", dateMontFrom.substring(4, 6));
			calDate.put("DATE_MONT_FROM", dateMontFrom+"01");
			calDate.put("DATE_MONT_TO", dateMontTo+"01");
			
			calDateList.add(calDate);
		}
		
		param.put("CAL_DATE_LIST", calDateList);
		
		return (List) super.commonDao.list("hum250skrServiceImpl.selectDataList", param);
	}
	
	
}
