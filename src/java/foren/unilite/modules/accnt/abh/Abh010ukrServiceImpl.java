package foren.unilite.modules.accnt.abh;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.com.ext.CalendarModel;


@SuppressWarnings({"rawtypes", "unchecked", "unused"})
@Service("abh010ukrService")
public class Abh010ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>> read(Map param, LoginVO user) throws Exception {
		
//		String groupCode = (String) super.commonDao.select("abh010ukrServiceImpl.getGroupCode", param);
//		param.put("GROUP_CODE" , groupCode);
//		param.put("DEPT_CODE" , user.getDeptCode());
		 
//		logger.debug("IMPL >>> " + param.toString());
		List<Map<String, Object>> dataList = (List) super.commonDao.list("abh010ukrServiceImpl.getCalendarData", param);	
		
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
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public List<Map<String, Object>> create(Map param) throws Exception {
		return null;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updatePlan(Map param) throws Exception {
		logger.debug("startDate {}, {}", param.get("startDate").getClass(), param.get("startDate"));
		logger.debug("param : {}" , param);
		return (Integer) super.commonDao.update("abh010ukrServiceImpl.upadtePlanDate", param );
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public List<Map<String, Object>> destroy(Map param) throws Exception {
		return null;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<CalendarModel> readCalendars() {

//		ImmutableList.Builder<Calendar> builder = ImmutableList.builder();
//
//		builder.add(new Calendar(1, "Home", 2));
//		builder.add(new Calendar(2, "Work", 22));
//		builder.add(new Calendar(3, "School", 7));
//
//		return builder.build();
		return (List<CalendarModel>) super.commonDao.list("abh010ukrServiceImpl.getCalendarList");
	}
	
	
	
	
	
	//달력 생성 - 기존 데이터 존재유무 확인
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>> checkCalendarData (Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> dataList = (List) super.commonDao.list("abh010ukrServiceImpl.checkCalendarData", param);	

		return dataList;
	}

	//신규달력 생성 - 기존 데이터 삭제 후, INSERT
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt")
    public int createCalendarData (Map param, LoginVO user) throws Exception {
        super.commonDao.update("abh010ukrServiceImpl.createCalendarData", param);

        return 0;
    }
    
	//복사달력 생성 - 복사대상 존재여부 확인, 기존 데이터 삭제 후, INSERT
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt")
    public int copyCalendarData (Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> dataList = (List) super.commonDao.list("abh010ukrServiceImpl.checkOriCalendarData", param);	
		if(dataList.isEmpty()) {					//복사원본 사업장에 달력이 없을 경우(생성사업장에 달력이 존재하지 않습니다.)
			throw new  UniDirectValidateException(this.getMessage("54241", user));
			
		} else { 
			super.commonDao.update("abh010ukrServiceImpl.copyCalendarData", param);
		}

        return 0;
    }
}

