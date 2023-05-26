package foren.unilite.modules.z_yp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "s_eis300skrv_ypService" )
public class S_eis300skrv_ypServiceImpl extends TlabAbstractServiceImpl {
	
	/**
	 * 매출현황 조회
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_yp" )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {
		List<Map<String, Object>> resultList = super.commonDao.list("s_eis300skrv_ypServiceImpl.selectList", param);
		double totAmtYear	= 0;
		double totAmt		= 0;
		double totAmt1		= 0;
		double totAmt2		= 0;
		double totAmt3		= 0;
		double totAmt4		= 0;
		double totAmt5		= 0;
		double totAmt6		= 0;
		double totAmt7		= 0;
		double totAmt8		= 0;
		double totAmt9		= 0;
		double totAmt10	= 0;
		double totAmt11	= 0;
		double totAmt12	= 0;
		
		for(Map resultData: resultList) {
			totAmtYear	= totAmtYear	+ ObjUtils.parseDouble(resultData.get("AMT_YEAR"));
			totAmt		= totAmt		+ ObjUtils.parseDouble(resultData.get("AMT"));
			totAmt1		= totAmt1		+ ObjUtils.parseDouble(resultData.get("AMT1"));
			totAmt2		= totAmt2		+ ObjUtils.parseDouble(resultData.get("AMT2"));
			totAmt3		= totAmt3		+ ObjUtils.parseDouble(resultData.get("AMT3"));
			totAmt4		= totAmt4		+ ObjUtils.parseDouble(resultData.get("AMT4"));
			totAmt5		= totAmt5		+ ObjUtils.parseDouble(resultData.get("AMT5"));
			totAmt6		= totAmt6		+ ObjUtils.parseDouble(resultData.get("AMT6"));
			totAmt7		= totAmt7		+ ObjUtils.parseDouble(resultData.get("AMT7"));
			totAmt8		= totAmt8		+ ObjUtils.parseDouble(resultData.get("AMT8"));
			totAmt9		= totAmt9		+ ObjUtils.parseDouble(resultData.get("AMT9"));
			totAmt10	= totAmt10		+ ObjUtils.parseDouble(resultData.get("AMT10"));
			totAmt11	= totAmt11		+ ObjUtils.parseDouble(resultData.get("AMT11"));
			totAmt12	= totAmt12		+ ObjUtils.parseDouble(resultData.get("AMT12"));
		}
		for(Map resultData: resultList) {
			if(totAmtYear == 0){
				resultData.put("RATE_YEAR"	, 0);
			} else {
				resultData.put("RATE_YEAR"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT_YEAR"))	/ totAmtYear * 100 *100) /100.0);
			}
			if(totAmt == 0){
				resultData.put("RATE"	, 0);
			} else {
				resultData.put("RATE"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT"))	/ totAmt * 100 *100) /100.0);
			}
			if(totAmt1 == 0){
				resultData.put("RATE1"	, 0);
			} else {
				resultData.put("RATE1"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT1"))	/ totAmt1 * 100 *100) /100.0);
			}
			if(totAmt2 == 0){
				resultData.put("RATE2"	, 0);
			} else {
				resultData.put("RATE2"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT2"))	/ totAmt2 * 100 *100) /100.0);
			}
			if(totAmt3 == 0){
				resultData.put("RATE3"	, 0);
			} else {
				resultData.put("RATE3"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT3"))	/ totAmt3 * 100 *100) /100.0);
			}
			if(totAmt4 == 0){
				resultData.put("RATE4"	, 0);
			} else {
				resultData.put("RATE4"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT4"))	/ totAmt4 * 100 *100) /100.0);
			}
			if(totAmt5 == 0){
				resultData.put("RATE5"	, 0);
			} else {
				resultData.put("RATE5"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT5"))	/ totAmt5 * 100 *100) /100.0);
			}
			if(totAmt6 == 0){
				resultData.put("RATE6"	, 0);
			} else {
				resultData.put("RATE6"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT6"))	/ totAmt6 * 100 *100) /100.0);
			}
			if(totAmt7 == 0){
				resultData.put("RATE7"	, 0);
			} else {
				resultData.put("RATE7"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT7"))	/ totAmt7 * 100 *100) /100.0);
			}
			if(totAmt8 == 0){
				resultData.put("RATE8"	, 0);
			} else {
				resultData.put("RATE8"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT8"))	/ totAmt8 * 100 *100) /100.0);
			}
			if(totAmt9 == 0){
				resultData.put("RATE9"	, 0);
			} else {
				resultData.put("RATE9"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT9"))	/ totAmt9 * 100 *100) /100.0);
			}
			if(totAmt10 == 0){
				resultData.put("RATE10"	, 0);
			} else {
				resultData.put("RATE10"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT10"))	/ totAmt10 * 100 *100) /100.0);
			}
			if(totAmt11 == 0){
				resultData.put("RATE11"	, 0);
			} else {
				resultData.put("RATE11"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT11"))	/ totAmt11 * 100 *100) /100.0);
			}
			if(totAmt12 == 0){
				resultData.put("RATE12"	, 0);
			} else {
				resultData.put("RATE12"	, Math.round(ObjUtils.parseDouble(resultData.get("AMT12"))	/ totAmt12 * 100 *100) /100.0);
			}
		}

		return resultList;
	}
	
}
