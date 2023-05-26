package foren.unilite.modules.accnt.agj;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("agj280ukrService")
public class Agj280ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 전표이력일괄삭제
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "agj")
	public void insertMaster(Map spParam, LoginVO user) throws Exception {
		

		Map query1 = (Map) super.commonDao.select("agj280ukrServiceImpl.query1", spParam);
		
		// 쿼리 값 숫자형으로 변환
		BigDecimal bd = (BigDecimal) query1.get("DEL_DATE");
		int rsTemp1 = bd.intValue();
		
		//초기 TODAY_DATE 값 호출
		String toDate = (String) spParam.get("TODAY_DATE");
		int toDate1 = Integer.parseInt(toDate);
		
		// TODAY_DATE(화면에서 보낸날짜) 에서 쿼리 값 만큼 뺀다
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date date = dateFormat.parse(toDate);
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);	
		cal.add(Calendar.DATE, -1 * rsTemp1 + 1);
		String fromDate = dateFormat.format(cal.getTime());
		
		int fromDate1 = Integer.parseInt(fromDate);
		
		// 파라미터로 받은 값 연산 하기 위해 형변환
		int FR_AC_DATE = Integer.parseInt((String) spParam.get("AC_DATE_FR"));
		int TO_AC_DATE = Integer.parseInt((String) spParam.get("AC_DATE_TO"));
		
		// 수정삭제가능 기간을 구함
		if(FR_AC_DATE < fromDate1 && TO_AC_DATE < fromDate1 || FR_AC_DATE > toDate1 && TO_AC_DATE > toDate1){
			fromDate1 = 0;
			toDate1 = 0;
			throw new  UniDirectValidateException(this.getMessage("55303", user));
		}else{
			if(FR_AC_DATE >= fromDate1 && FR_AC_DATE <= toDate1){
				fromDate1 = FR_AC_DATE;
			}
			if(TO_AC_DATE >= fromDate1 && TO_AC_DATE <= toDate1){
				toDate1 = TO_AC_DATE;
			}
		}
		
		spParam.put("fromDate1", fromDate1);
		spParam.put("toDate1", toDate1);
		
		String slipDivi = (String) spParam.get("SLIP_DIVI");  // 전표구분 1:회계 ,2:결의
	
		List<Map> query2 = null;
		List<Map<String, Object>>newData  = new ArrayList();
		
		// 전표구분에 따라서 데이터를 가져옴
		if(slipDivi.equals("1")){
			query2 = (List<Map>) super.commonDao.list("agj280ukrServiceImpl.query2", spParam);
			//query2 = (Map) super.commonDao.select("agj280ukrServiceImpl.query2", spParam);
		}else{
			query2 = (List<Map>) super.commonDao.list("agj280ukrServiceImpl.query3", spParam);
			//query2 = (Map) super.commonDao.select("agj280ukrServiceImpl.query3", spParam);
		}
		
		if(query2.size() == 0){
			throw new  UniDirectValidateException(this.getMessage("54601", user));  // 해당 자료가 존재하지 않습니다.
		}
		else{
			for(int i = 0; i < query2.size(); i++){
			
				Map mergeData = new HashMap(); 
				
				mergeData.put("SLIP_DIVI", slipDivi);
				mergeData.put("S_COMP_CODE", user.getCompCode());
				
				if(slipDivi.equals("1")){
					mergeData.put("AC_DATE", query2.get(i).get("AC_DATE"));
					mergeData.put("SLIP_NUM", query2.get(i).get("SLIP_NUM"));
				}
				else{
					mergeData.put("EX_DATE", query2.get(i).get("EX_DATE"));
					mergeData.put("EX_NUM", query2.get(i).get("EX_NUM"));
				}
				super.commonDao.select("agj280ukrServiceImpl.query4", mergeData);
			}
		}
	}
}
