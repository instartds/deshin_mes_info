package foren.unilite.modules.human.ham;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ham400skrService")
public class Ham400skrServiceImpl extends TlabAbstractServiceImpl {
	/**
	 * 자료목록조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		String date = (String) param.get("DATE");
		String date2 = (String) param.get("DATE2");
		String sYear = date.substring(0,4);
		String sMonth = date.substring(4,6);		
		String tYear = date2.substring(0,4);
		String tMonth = date2.substring(4,6);
			
		// 기간의 월차수
		int diff = (Integer.parseInt(tYear)-Integer.parseInt(sYear))*12+Integer.parseInt(tMonth)-Integer.parseInt(sMonth);
		diff = Math.abs(diff);

		// 초기값 설정
		String sfJoin = sYear + sMonth + "01";
		String stJoin;
		if (sMonth == "12") {
			stJoin = (Integer.parseInt(sYear) + 1) + "01" + "01";
		} else {
			if (Integer.parseInt(sMonth) >= 9) {
				stJoin = sYear + (Integer.parseInt(sMonth) + 1) + "01";
			} else {
				stJoin = sYear + "0" + (Integer.parseInt(sMonth) + 1) + "01";
			}
		}		
		
		param.put("diff", diff);		
		param.put("sYear", sYear);
		param.put("sMonth", sMonth);		
		param.put("stJoin", stJoin);
		param.put("sfJoin", sfJoin);
				
		return (List) super.commonDao.list("ham400skrServiceImpl.selectList", param);
	}
}
