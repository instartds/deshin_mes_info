package foren.unilite.modules.com.potal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;

@Service("mainBoardService")
public class MainBoardServiceImpl extends TlabAbstractCommonServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(MainPortalServiceImpl.class);
	
	/**
	 * 운행정보
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  getGoplist(Map param) throws Exception {
		List<Map<String, Object>> rList = super.commonDao.list("mainBoardServiceImpl.goplist", param);
		if(rList.size() < 15 && rList.size() > 0)	{
			for(int i = rList.size()+1 ; i <= 15 ; i++)	{
				Map<String, Object> dMap = new HashMap();
				dMap.put("ROW_NUM", i);
				dMap.put("ROUTE_NUM", "");
				rList.add(dMap);
			}
		}
		return rList;
	}
	
	/**
	 * 근태정보
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  getGttlist(Map param) throws Exception {
		List<Map<String, Object>> rList = super.commonDao.list("mainBoardServiceImpl.gttlist", param);
		
		if(rList.size() < 100 && rList.size() > 0)	{
			Map m = rList.get(rList.size()-1);
			int i = ObjUtils.parseInt(m.get("ROW_NUM"))+1;
			for( ; i <= 100 ; i++)	{
				Map<String, Object> dMap = new HashMap();
				dMap.put("ROW_NUM", i);
				dMap.put("ROUTE_ROW_NUM", "");
				dMap.put("ROUTE_NUM", "");
				rList.add(dMap);
			}
		}
		return rList;
	}
	
	/**
	 * 공지사항
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  noticelist(Map param) throws Exception {
		List<Map<String, Object>> rList = super.commonDao.list("mainBoardServiceImpl.noticelist", param);
		return rList;
	}
	
	
}
