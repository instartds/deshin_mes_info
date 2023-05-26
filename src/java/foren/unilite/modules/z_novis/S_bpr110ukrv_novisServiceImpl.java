package foren.unilite.modules.z_novis;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;


@Service("s_bpr110ukrv_novisService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_bpr110ukrv_novisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 품목코드 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_novis", value = ExtDirectMethodType.STORE_READ)
	public Object selectCheckItemCode(Map param) throws Exception {
		return super.commonDao.select("s_bpr110ukrv_novisServiceImpl.selectCheckItemCode", param);
	}
	
	/**
	 * 품목계정에 따른 품목코드 자동채번 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_novis", value = ExtDirectMethodType.STORE_READ)
	public Object selectAutoItemCode(Map param) throws Exception {
		return super.commonDao.select("s_bpr110ukrv_novisServiceImpl.selectAutoItemCode", param);
	}
	
	/**
	 * 채번 후 추가시 채번테이블에 insert 또는 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
    public String saveAutoItemCode(Map param) throws Exception {

        String rtnV = "";

		super.commonDao.update("s_bpr110ukrv_novisServiceImpl.saveAutoItemCode", param);

        rtnV = "Y";
        return rtnV;
    }
	
	/**
     * 채번코드2 콤보 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> getCode_2(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("s_bpr110ukrv_novisServiceImpl.getCode_2", param);
        
    }

	/**
     * 채번코드3 콤보 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> getCode_3(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("s_bpr110ukrv_novisServiceImpl.getCode_3", param);
        
    }
    
	/**
	 * 대표품목코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_novis")
	public List<Map> selectList1(Map param) throws Exception{
		return super.commonDao.list("s_bpr110ukrv_novisServiceImpl.selectList1", param);
	}



	/**
	 * 대표품목코드 등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_novis")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail1")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail1")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail1(deleteList, user);
			if(insertList != null) this.insertDetail1(insertList, user);
			if(updateList != null) this.updateDetail1(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void insertDetail1(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.insert("s_bpr110ukrv_novisServiceImpl.insertDetail_100T", param);
			super.commonDao.update("s_bpr110ukrv_novisServiceImpl.insertDetail_200T", param);
		}
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void updateDetail1(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("s_bpr110ukrv_novisServiceImpl.updateDetail_100T", param);
			super.commonDao.update("s_bpr110ukrv_novisServiceImpl.updateDetail_200T", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void deleteDetail1(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList ) {
			 super.commonDao.delete("s_bpr110ukrv_novisServiceImpl.deleteDetail_100T", param);
			 super.commonDao.delete("s_bpr110ukrv_novisServiceImpl.deleteDetail_200T", param);
		 }
		 return;
	}


	/**
	 * 제품품목코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_novis")
	public List<Map> selectList2(Map param) throws Exception{
		return super.commonDao.list("s_bpr110ukrv_novisServiceImpl.selectList2", param);
	}



	/**
	 * 제품품목코드 등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_novis")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail2(deleteList, user);
			if(insertList != null) this.insertDetail2(insertList, user);
			if(updateList != null) this.updateDetail2(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void insertDetail2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.insert("s_bpr110ukrv_novisServiceImpl.insertDetail_100T", param);
			super.commonDao.update("s_bpr110ukrv_novisServiceImpl.insertDetail_200T", param);
		}
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("s_bpr110ukrv_novisServiceImpl.updateDetail_100T", param);
			super.commonDao.update("s_bpr110ukrv_novisServiceImpl.updateDetail_200T", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList ) {
			 super.commonDao.delete("s_bpr110ukrv_novisServiceImpl.deleteDetail_100T", param);
			 super.commonDao.delete("s_bpr110ukrv_novisServiceImpl.deleteDetail_200T", param);
		 }
		 return;
	}

}
