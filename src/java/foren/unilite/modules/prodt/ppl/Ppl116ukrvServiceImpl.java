package foren.unilite.modules.prodt.ppl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.ext.CalendarModel;

@Service("ppl116ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ppl116ukrvServiceImpl  extends TlabAbstractServiceImpl {

	@Resource(name = "tlabCodeService")
	protected TlabCodeService tlabCodeService;
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<CalendarModel> readCalendars() {
		return (List<CalendarModel>) super.commonDao.list("ppl116ukrvService.getCalendarList");
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> getEventList(Map param, LoginVO user) throws Exception {
		
		List<Map<String, Object>> titleList = (List) super.commonDao.list("ppl116ukrvService.selectTitle", param);
		String title = "";
		
		for(Map<String, Object> titleObj : titleList)	{
			if(!"".equals(title))	{
				title += " + '/' + ";
			}
			title += ObjUtils.getSafeString(titleObj.get("REF_CODE3"));
		}
		if("".equals(title))	{
			title = "WKORD_NUM + '/' + ITEM_NAME";
		}
		param.put("title", title);
		List<Map<String, Object>> dataList = (List) super.commonDao.list("ppl116ukrvService.getEventList", param);
		for(Map<String, Object> data : dataList ) {
			data.put("allDay", Boolean.TRUE);
		}
		//logger.debug(dataList.toString());
		return dataList;
	}

	/**
	 * 카렌더정보수정 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public Object  updateDetail(Map param, LoginVO user) throws Exception {
		String status = (String) super.commonDao.select("ppl116ukrvService.checkClose", param);
		if("8".equals(status))	{
			throw new  UniDirectValidateException("마감된 일정은 수정할 수 없습니다.");
		}
		super.commonDao.update("ppl116ukrvService.updateDetail", param);
		return param;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<CalendarModel> selectHolydayList(Map param, LoginVO user) {
		return (List<CalendarModel>) super.commonDao.list("ppl116ukrvService.selectHolydayList", param);
	}
	
}