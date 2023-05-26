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

@Service("s_biv305skrv_mitService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_biv305skrv_mitServiceImpl  extends TlabAbstractServiceImpl {
	
	@Resource( name = "externalDAO_MIT" )
    protected ExternalDAO_MIT externalDAO;
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		StringBuilder errorMessage = new StringBuilder("");
		Object r = externalDAO.select("s_biv305skrv_mitServiceImpl.userWhcode", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
		
		if(param.get("ITEM_ACCOUNT")!= null && ObjUtils.isNotEmpty(param.get("ITEM_ACCOUNT")))	{
			ArrayList<String> pITEM_ACCOUNT = (ArrayList<String>) param.get("ITEM_ACCOUNT");
			if(  pITEM_ACCOUNT.size() > 0 )	{
				param.put("ITEM_ACCOUNT_LIST", getItemAccountList(param.get("ITEM_ACCOUNT")));
			} 
		}
    	List<Map<String, Object>> r = externalDAO.list("s_biv305skrv_mitServiceImpl.selectMasterList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster2(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
		
		if(param.get("ITEM_ACCOUNT")!= null && ObjUtils.isNotEmpty(param.get("ITEM_ACCOUNT")))	{
			String[] pITEM_ACCOUNT = (String[])param.get("ITEM_ACCOUNT");
			if( pITEM_ACCOUNT.length > 0 )	{
				param.put("ITEM_ACCOUNT_LIST", getItemAccountList(param.get("ITEM_ACCOUNT")));
			} 
		}
		
    	List<Map<String, Object>> r = externalDAO.list("s_biv305skrv_mitServiceImpl.selectMasterList2", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster3(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
		if(param.get("ITEM_ACCOUNT")!= null && ObjUtils.isNotEmpty(param.get("ITEM_ACCOUNT")))	{
			String[] pITEM_ACCOUNT = (String[])param.get("ITEM_ACCOUNT");
			if( pITEM_ACCOUNT.length > 0 )	{
				param.put("ITEM_ACCOUNT_LIST", getItemAccountList(param.get("ITEM_ACCOUNT")));
			} 
		}
		
    	List<Map<String, Object>> r = externalDAO.list("s_biv305skrv_mitServiceImpl.selectMasterList3", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster4(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
		
		if(param.get("ITEM_ACCOUNT")!= null && ObjUtils.isNotEmpty(param.get("ITEM_ACCOUNT")))	{
			String[] pITEM_ACCOUNT = (String[])param.get("ITEM_ACCOUNT");
			if( pITEM_ACCOUNT.length > 0 )	{
				param.put("ITEM_ACCOUNT_LIST", getItemAccountList(param.get("ITEM_ACCOUNT")));
			} 
		}
		
		
    	List<Map<String, Object>> r = externalDAO.list("s_biv305skrv_mitServiceImpl.selectMasterList4", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster5(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
		
		String[] pITEM_ACCOUNT = (String[])param.get("ITEM_ACCOUNT");
		if( pITEM_ACCOUNT!= null && pITEM_ACCOUNT.length > 0 )	{
			param.put("ITEM_ACCOUNT_LIST", getItemAccountList(param.get("ITEM_ACCOUNT")));
		} 
		
    	List<Map<String, Object>> r = externalDAO.list("s_biv305skrv_mitServiceImpl.selectMasterList5", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}
	
	/**
	 * 대리점 사업장 정보 (본사 DB)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getDivCode(Map param) throws Exception {
		return (List<ComboItemModel>)super.commonDao.list("s_biv305skrv_mitServiceImpl.selectDivCode", param);
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
