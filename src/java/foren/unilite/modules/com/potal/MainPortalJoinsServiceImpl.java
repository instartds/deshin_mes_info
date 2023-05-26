package foren.unilite.modules.com.potal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.menu.MenuItemModel;
import foren.unilite.com.menu.MenuNode;
import foren.unilite.com.menu.MenuTree;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;

@Service("mainPortalJoinsService")
public class MainPortalJoinsServiceImpl extends TlabAbstractCommonServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(MainPortalServiceImpl.class);
	
	@Resource(name="tlabMenuService")
	TlabMenuService menuService ;
	
	/**
	 * 전자결재 Portlet
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public Map<String, Object>  selectAprv(Map param, LoginVO user) throws Exception {
		Map<String, Object> aprv = (Map<String, Object>)  super.commonDao.select("mainPortalJoinsServiceImpl.aprv", param);
		Map<String, Object> card = (Map<String, Object>)  super.commonDao.select("mainPortalJoinsServiceImpl.card", param);
		Map<String, Object> slip = (Map<String, Object>)  super.commonDao.select("mainPortalJoinsServiceImpl.slip", param);
		Map<String, Object> info = (Map<String, Object>)  super.commonDao.select("mainPortalJoinsServiceImpl.aprvinfo", param);
		aprv.putAll(card);
		aprv.putAll(slip);
		aprv.putAll(info);
		return  aprv;
	}
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<MenuItemModel>  selectLink(Map param, LoginVO user) throws Exception {
		String[]	arrPgmId = ObjUtils.getSafeString(param.get("PGM_ID")).split(",");
		List<MenuItemModel> rList = new ArrayList<MenuItemModel>();
		if(arrPgmId != null)	{
			for(String pgmId : arrPgmId)	{
				MenuTree meneTree = menuService.getMenuTree(user.getCompCode());
				MenuNode node = meneTree.getNodeByMenuID(pgmId);
				if(node != null) rList.add(node.getData());
			}
		}
		return  rList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectBoard(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rList = super.commonDao.list("mainPortalJoinsServiceImpl.selectBoard", param);
		if(rList == null || rList.size() != 10)	{
			int type1 =0, type2=0;
			if(rList != null)	{
				for(Map<String, Object> tmp : rList )	{
					if("1".equals(ObjUtils.getSafeString(tmp.get("TYPE_FLAG"))))	type1++;
					else type2++;
				}
			}
			for(int i=0; i < (5-type1); i++){
				Map<String, Object> rMap = new HashMap();
				rMap.put("TITLE", "&nbsp");
				rMap.put("UPDATE_DB_TIME", "&nbsp");
				rMap.put("TYPE_FLAG", "1");
				rList.add(rMap);
			}
			for(int i=0; i < (5-type2); i++){
				Map<String, Object> rMap2 = new HashMap();
				rMap2.put("TITLE", "&nbsp");
				rMap2.put("UPDATE_DB_TIME", "&nbsp");
				rMap2.put("TYPE_FLAG", "2");
				rList.add(rMap2);
			}
		}
		return  rList;
	}
	
	
	
	
}
