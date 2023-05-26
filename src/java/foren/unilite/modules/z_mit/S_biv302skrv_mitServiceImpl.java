package foren.unilite.modules.z_mit;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_biv302skrv_mitService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_biv302skrv_mitServiceImpl  extends TlabAbstractServiceImpl {
	
	@Resource( name = "externalDAO_MIT" )
    protected ExternalDAO_MIT externalDAO;
	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
		
		if(param.get("ITEM_ACCOUNT")!= null && ObjUtils.isNotEmpty(param.get("ITEM_ACCOUNT")))	{
			ArrayList<String> pITEM_ACCOUNT = (ArrayList<String>) param.get("ITEM_ACCOUNT");
			if(  pITEM_ACCOUNT.size() > 0 )	{
				param.put("ITEM_ACCOUNT_LIST", getItemAccountList(param.get("ITEM_ACCOUNT")));
			} 
		}
    	List<Map<String, Object>> r = externalDAO.list("s_biv302skrv_mitServiceImpl.selectMasterList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}
	
	
	/**
	 * 본사 사업장 정보 (본사 DB)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getDivCode(Map param) throws Exception {
		return (List<ComboItemModel>)super.commonDao.list("s_biv302skrv_mitServiceImpl.selectDivCode", param);
	}
	

	/**
	 * 본사 창고 정보 (본사 DB)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getWhCode(Map param) throws Exception {
		return (List<ComboItemModel>)super.commonDao.list("s_biv302skrv_mitServiceImpl.selectWhCode", param);
	}
	
	
	private String getItemAccountList(Object items)	{
		ArrayList<String> pITEM_ACCOUNT = (ArrayList<String>) items;
		StringBuilder itemAccountList = new StringBuilder();
		if( pITEM_ACCOUNT.size() > 0 )	{
			for(String itemAccount : pITEM_ACCOUNT) {
				itemAccountList.append("'"+itemAccount+"'");
				if(!itemAccount.equals(pITEM_ACCOUNT.get(pITEM_ACCOUNT.size()-1)))	{
					itemAccountList.append(",");
				}
			}
		} 
		return itemAccountList.toString();
	}
	
	
	
}
