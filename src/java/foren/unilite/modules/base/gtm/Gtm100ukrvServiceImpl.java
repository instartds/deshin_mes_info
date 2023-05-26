package foren.unilite.modules.base.gtm;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("gtm100ukrvService")
public class Gtm100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gtm100ukrvServiceImpl.selectList", param);
	}

	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  insert(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			for(int i=0 ; i <=20 ; i++)	{
				if(!"".equals(ObjUtils.getSafeString(param.get("R"+String.valueOf(i)))) &&  param.get("R"+String.valueOf(i)) != null )	{
					param.put("RUN_COUNT", String.valueOf(i)) ;
					
					String dutyFrTime = ObjUtils.getSafeString(param.get("DUTY_FR_TIME"));
					String dutyFrtimeOrg = dutyFrTime;
					dutyFrTime = dutyFrTime.replaceAll("\\:", "");		
					
					if(dutyFrTime.length() == 4 )		param.put("DUTY_FR_TIME", dutyFrTime ) ;
					else param.put("DUTY_FR_TIME", dutyFrTime.substring(0, 4) ) ;
						
					String dutyToTime = ObjUtils.getSafeString(param.get("DUTY_TO_TIME"));
					String dutyTotimeOrg = dutyToTime;
					dutyToTime = dutyToTime.replaceAll("\\:", "");					
					if(dutyToTime.length() == 4 )		param.put("DUTY_TO_TIME", dutyToTime ) ;
					else param.put("DUTY_TO_TIME", dutyToTime.substring(0, 4) ) ;
					
					
					//종점행
					String time = ObjUtils.getSafeString(param.get("R"+String.valueOf(i)));
					time = time.replaceAll("\\:", "");
					
					if(ObjUtils.isNotEmpty(time))	{
						if(time.length() == 4 )		param.put("DEPARTURE_TIME", time ) ; // param.put("DEPARTURE_TIME", time+"00" ) ;
						else 						param.put("DEPARTURE_TIME", time.substring(0, 4) );//param.put("DEPARTURE_TIME", time ) ;
						
						param.put("RUN_DIRECTION", "1" ) ;
						
						param.put("DEPARTURE_PLACE", ObjUtils.getSafeString(param.get("S"+String.valueOf(i))) ) ;
						param.put("DESTINATION_PLACE", ObjUtils.getSafeString(param.get("E"+String.valueOf(i))) ) ;
						logger.debug("!@!@!@!@!@  param.get(DUTY_FR_TIME) : "+param.get("DUTY_FR_TIME").toString());
						logger.debug("!@!@!@!@!@  param.get(DUTY_TO_TIME) : "+param.get("DUTY_TO_TIME").toString());
						super.commonDao.queryForObject("gtm100ukrvServiceImpl.save", param);
					}
					//기점행
					String timeB = ObjUtils.getSafeString(param.get("RB"+String.valueOf(i)));
					timeB = timeB.replaceAll("\\:", "");
					
					if(ObjUtils.isNotEmpty(timeB))	{
						if(timeB.length() == 4 )		param.put("DEPARTURE_TIME", timeB ) ;//param.put("DEPARTURE_TIME", timeB+"00" ) ;
						else 							param.put("DEPARTURE_TIME", timeB.substring(0, 4) ) ;//param.put("DEPARTURE_TIME", timeB ) ;
						
						
						param.put("RUN_DIRECTION", "2" ) ;
						param.put("DEPARTURE_PLACE", ObjUtils.getSafeString(param.get("BS"+String.valueOf(i))) ) ;
						param.put("DESTINATION_PLACE", ObjUtils.getSafeString(param.get("BE"+String.valueOf(i))) ) ;

						logger.debug("!@!@!@!@!@  param.get(DUTY_FR_TIME) : "+param.get("DUTY_FR_TIME").toString());
						logger.debug("!@!@!@!@!@  param.get(DUTY_TO_TIME) : "+param.get("DUTY_TO_TIME").toString());
						super.commonDao.queryForObject("gtm100ukrvServiceImpl.save", param);	
					}
					param.put("DUTY_FR_TIME", dutyFrtimeOrg ) ;
					param.put("DUTY_TO_TIME", dutyTotimeOrg ) ;
				}
			}
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  update(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			for(int i=0 ; i <=20 ; i++)	{
				
					String dutyFrTime = ObjUtils.getSafeString(param.get("DUTY_FR_TIME"));
					String dutyFrtimeOrg = dutyFrTime;
					dutyFrTime = dutyFrTime.replaceAll("\\:", "");		

					if(dutyFrTime.length() == 4 )		param.put("DUTY_FR_TIME", dutyFrTime ) ;
					else param.put("DUTY_FR_TIME", dutyFrTime.substring(0, 4) ) ;
						
					String dutyToTime = ObjUtils.getSafeString(param.get("DUTY_TO_TIME"));
					String dutyTotimeOrg = dutyToTime;
					dutyToTime = dutyToTime.replaceAll("\\:", "");					
					if(dutyToTime.length() == 4 )		param.put("DUTY_TO_TIME", dutyToTime ) ;
					else param.put("DUTY_TO_TIME", dutyToTime.substring(0, 4) ) ;
				
					param.put("RUN_COUNT", String.valueOf(i)) ;
					//종점행
					String time = ObjUtils.getSafeString(param.get("R"+String.valueOf(i)));
					time = time.replaceAll("\\:", "");
					logger.debug("##### runCount : "+ "R"+String.valueOf(i)+" / "+time +" " );
					
					if(ObjUtils.isNotEmpty(time))	{
						
						param.put("RUN_DIRECTION", "1" ) ;
						
						if(time.length() == 4 )		param.put("DEPARTURE_TIME", time ) ; // param.put("DEPARTURE_TIME", time+"00" ) ;
						else 						param.put("DEPARTURE_TIME", time.substring(0, 4) );//param.put("DEPARTURE_TIME", time ) ;
						
						param.put("DEPARTURE_PLACE", ObjUtils.getSafeString(param.get("S"+String.valueOf(i))) ) ;
						param.put("DESTINATION_PLACE", ObjUtils.getSafeString(param.get("E"+String.valueOf(i))) ) ;
						super.commonDao.queryForObject("gtm100ukrvServiceImpl.save", param);
					} else {
						if(ObjUtils.isEmpty(ObjUtils.getSafeString(param.get("S"+String.valueOf(i)))) 
								&& ObjUtils.isEmpty(ObjUtils.getSafeString(param.get("E"+String.valueOf(i)))) 
						)	{
							param.put("RUN_DIRECTION", "1" ) ;
							super.commonDao.queryForObject("gtm100ukrvServiceImpl.delete", param);
						}
					}
					//기점행
					String timeB = ObjUtils.getSafeString(param.get("RB"+String.valueOf(i)));
					timeB = timeB.replaceAll("\\:", "");
					logger.debug("##### runCount2 : "+ "RB"+String.valueOf(i)+" / "+timeB +" " );
					if(ObjUtils.isNotEmpty(timeB))	{
						param.put("RUN_DIRECTION", "2" ) ;

						if(timeB.length() == 4 )		param.put("DEPARTURE_TIME", timeB ) ;//param.put("DEPARTURE_TIME", timeB+"00" ) ;
						else 							param.put("DEPARTURE_TIME", timeB.substring(0, 4) ) ;//param.put("DEPARTURE_TIME", timeB ) ;
						
						param.put("DEPARTURE_PLACE", ObjUtils.getSafeString(param.get("BS"+String.valueOf(i))) ) ;
						param.put("DESTINATION_PLACE", ObjUtils.getSafeString(param.get("BE"+String.valueOf(i))) ) ;
						super.commonDao.queryForObject("gtm100ukrvServiceImpl.save", param);	
					} else {
						if(ObjUtils.isEmpty(ObjUtils.getSafeString(param.get("BS"+String.valueOf(i)))) 
								&& ObjUtils.isEmpty(ObjUtils.getSafeString(param.get("BE"+String.valueOf(i)))) 
						)	{
							param.put("RUN_DIRECTION", "2" ) ;
							super.commonDao.queryForObject("gtm100ukrvServiceImpl.delete", param);
						}
					}	
					
					param.put("DUTY_FR_TIME", dutyFrtimeOrg ) ;
					param.put("DUTY_TO_TIME", dutyTotimeOrg ) ;
			}
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  delete(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("gtm100ukrvServiceImpl.delete", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("delete")) {
					param.put("data", delete(dataList) );	
				}else if(param.get("method").equals("insert")) {
					param.put("data", insert(dataList) );	
				}else if(param.get("method").equals("update")) {
					param.put("data", update(dataList) );	
				} 
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}	
	
	@ExtDirectMethod(group = "busoperabasete", value = ExtDirectMethodType.STORE_MODIFY)
	public Object  copySchedule(Map param, LoginVO user) throws Exception {		
	
		String keyValue = getLogKey();	
		
		param.put("KEY_VALUE", keyValue);
		
		// 로그테이블 저장
		super.commonDao.update("gtm100ukrvServiceImpl.saveGWR100", param);	
		
		//프로시저실행
		super.commonDao.update("gtm100ukrvServiceImpl.opScheduleCopy", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(ObjUtils.isNotEmpty(errorDesc)){				
			String messsage = errorDesc.replaceAll("\\;", "");
			throw new  UniDirectValidateException(this.getMessage(messsage, user));
		}
		return param;
	}
	
	@ExtDirectMethod(group = "busoperabasete", value = ExtDirectMethodType.STORE_MODIFY)
	public Object  calculateTime(Map param, LoginVO user) throws Exception {		
	
		String keyValue = getLogKey();	
		
		param.put("KEY_VALUE", keyValue);
		
		// 로그테이블 저장
		super.commonDao.update("gtm100ukrvServiceImpl.saveGWR200", param);	
		
		//프로시저실행
		super.commonDao.update("gtm100ukrvServiceImpl.calculateTime", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(ObjUtils.isNotEmpty(errorDesc)){				
			String messsage = errorDesc.replaceAll("\\;", "");
			throw new  UniDirectValidateException(this.getMessage(messsage, user));
		}
		return param;
	}
	
	@ExtDirectMethod(group = "busoperate")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}

}
