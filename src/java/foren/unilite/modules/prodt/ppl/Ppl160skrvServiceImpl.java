package foren.unilite.modules.prodt.ppl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ppl160skrvService")
public class Ppl160skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		/*Date date=new SimpleDateFormat("yyyy-MM").parse(param.get("FR_DATE").toString()); 
		String []weekday=new String [7];
		weekday[0]="Sunday";
		weekday[1]="Monday";
		weekday[2]="Tuesday";
		weekday[3]="Wednesday";
		weekday[4]="Thursday";
		weekday[5]="Friday";
		weekday[6]="Saturday";
		String s=weekday[date.getDay()];*/
        
        String QUERY_TYPE=(String) param.get("QUERY_TYPE");
		if("1".equals(QUERY_TYPE)){
			return  super.commonDao.list("ppl160skrvServiceImpl.selectList", param);
		}else if("2".equals(QUERY_TYPE)){
			return  super.commonDao.list("ppl160skrvServiceImpl.selectList1", param);
		}
		return  super.commonDao.list("ppl160skrvServiceImpl.selectList2", param);

	}
	
}
