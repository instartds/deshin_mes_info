package foren.unilite.modules.crm.cmb;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.crm.cmb.model.CalendarModel;

@Service("calendarService")
public class CalendarServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "crm")
	public List<Map<String, Object>> read(Map param, LoginVO user) throws Exception {
		
		
		
//		String groupCode = (String) super.commonDao.select("calendarServiceImpl.getGroupCode", param);
//		param.put("GROUP_CODE" , groupCode);
		//param.put("DEPT_CODE" , user.getDeptCode());
		 
//		logger.debug("IMPL >>> " + param.toString());
		List<Map<String, Object>> dataList = (List) super.commonDao.list("calendarServiceImpl.getEventList", param);	
		
		for(Map<String, Object> data : dataList )	{
			//data.put("startDate", cvDate((Date)data.get("startDate")));
			//data.put("endDate", cvDate((Date)data.get("endDate")));
			//data.put("startDate", cvDate((Date)data.get("startDate")));
			//data.put("endDate", cvDate((Date)data.get("endDate")));
			data.put("allDay", Boolean.TRUE);
		}
		//logger.debug(dataList.toString());
		return dataList;
	}
	
	private String cvDate(Date dtj) {
		DateTime dt = new DateTime(dtj);
		 DateTimeFormatter fmt = ISODateTimeFormat.dateTime();
		 return fmt.print(dt);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "crm")
	public List<Map<String, Object>> create(Map param) throws Exception {
		return null;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "crm")
	public Integer updatePlan(Map param) throws Exception {
		logger.debug("startDate {}, {}", param.get("startDate").getClass(), param.get("startDate"));
		logger.debug("param : {}" , param);
		return (Integer) super.commonDao.update("calendarServiceImpl.upadtePlanDate", param );
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "crm")
	public List<Map<String, Object>> destroy(Map param) throws Exception {
		return null;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "crm")
	public List<CalendarModel> readCalendars() {

//		ImmutableList.Builder<Calendar> builder = ImmutableList.builder();
//
//		builder.add(new Calendar(1, "Home", 2));
//		builder.add(new Calendar(2, "Work", 22));
//		builder.add(new Calendar(3, "School", 7));
//
//		return builder.build();
		return (List<CalendarModel>) super.commonDao.list("calendarServiceImpl.getCalendarList");
	}
	
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "crm")
	public List<Map<String, Object>> read2(Map param, LoginVO user) throws Exception {
		
		
		
//		String groupCode = (String) super.commonDao.select("calendarServiceImpl.getGroupCode", param);
//		param.put("GROUP_CODE" , groupCode);
		//param.put("DEPT_CODE" , user.getDeptCode());
		 
//		logger.debug("IMPL >>> " + param.toString());
		List<Map<String, Object>> dataList = (List) super.commonDao.list("calendarServiceImpl.getEventList2", param);	
		
		for(Map<String, Object> data : dataList )	{
			//data.put("startDate", cvDate((Date)data.get("startDate")));
			//data.put("endDate", cvDate((Date)data.get("endDate")));
			//data.put("startDate", cvDate((Date)data.get("startDate")));
			//data.put("endDate", cvDate((Date)data.get("endDate")));
			data.put("allDay", Boolean.TRUE);
		}
		//logger.debug(dataList.toString());
		return dataList;
	}
}
