package foren.unilite.modules.equip.esa;
import java.security.acl.Group;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
@Service("esa200ukrvService")
public class Esa200ukrvServiceImpl extends TlabAbstractServiceImpl {
	public final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 소요품목등록 부품코드별 단가 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equip")
    public Object checkAsP(Map param) throws Exception {
        return super.commonDao.select("esa200ukrvServiceImpl.checkAsP", param);
    }
	
	/**
	 * A/S 접수결과등록 메인폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("esa200ukrvServiceImpl.selectForm", param);
	}
	
	
	/**
	 * A/S발생품목등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList1(Map param) throws Exception {
		return super.commonDao.list("esa200ukrvServiceImpl.selectList1", param);
	}

	/**
	 * A/S발생품목등록 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOtherOrderList(Map param) throws Exception {
		return super.commonDao.list("esa200ukrvServiceImpl.selectOtherOrderList", param);
	}
	
	/**
	 * 소요품목등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList2(Map param) throws Exception {
		return super.commonDao.list("esa200ukrvServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(group="equip",value=ExtDirectMethodType.STORE_READ)
	public List<Map> selectSubGrid(Map param) throws Exception{
		return super.commonDao.list("esa200ukrvServiceImpl.selectSubGrid",param);
	}
	/**
	 * 투입인원등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList3(Map param) throws Exception {
		return super.commonDao.list("esa200ukrvServiceImpl.selectList3", param);
	}
	/**
	 * 기타경비등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList4(Map param) throws Exception {
		return super.commonDao.list("esa200ukrvServiceImpl.selectList4", param);
	}
	
	
	/**
	 * A/S 접수결과등록 메인폼 저장
	 * @param dataMaster
	 * @param user
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "equip")
	public ExtDirectFormPostResult syncForm(Esa100ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("esa200ukrvServiceImpl.updateMaster", dataMaster);
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("resultData", dataMaster);
		return extResult;
	}
	
	/**
	 * A/S발생품목등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			
			if(paramData.get("method").equals("insertDetail1"))	
				this.insertDetail1(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateDetail1"))	
				this.updateDetail1(dataList, dataMaster, user);
			if(paramData.get("method").equals("deleteDetail1"))
				this.deleteDetail1(dataList, dataMaster, user);
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception{
		for(Map param :paramList )	{
			super.commonDao.insert("esa200ukrvServiceImpl.insertDetail1", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail1", paramMaster);
		
		return ;
	}
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail1(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.update("esa200ukrvServiceImpl.updateDetail1", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail1", paramMaster);
		return;
	}

	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail1(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.delete("esa200ukrvServiceImpl.deleteDetail1", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail1", paramMaster);
		return;
	}
	
	
	
	
	
	/**
	 * 소요품목등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			
			if(paramData.get("method").equals("insertDetail2"))	
				this.insertDetail2(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateDetail2"))	
				this.updateDetail2(dataList, dataMaster, user);
			if(paramData.get("method").equals("deleteDetail2"))
				this.deleteDetail2(dataList, dataMaster, user);
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception{
		for(Map param :paramList )	{
			super.commonDao.insert("esa200ukrvServiceImpl.insertDetail2", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail2", paramMaster);
		
		return ;
	}
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail2(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.update("esa200ukrvServiceImpl.updateDetail2", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail2", paramMaster);
		return;
	}

	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail2(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.delete("esa200ukrvServiceImpl.deleteDetail2", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail2", paramMaster);
		return;
	}
	
	
	/**
	 * 투입인원등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			
			if(paramData.get("method").equals("insertDetail3"))	
				this.insertDetail3(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateDetail3"))	
				this.updateDetail3(dataList, dataMaster, user);
			if(paramData.get("method").equals("deleteDetail3"))
				this.deleteDetail3(dataList, dataMaster, user);
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception{
		for(Map param :paramList )	{
			super.commonDao.insert("esa200ukrvServiceImpl.insertDetail3", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail3", paramMaster);
		
		return ;
	}
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail3(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.update("esa200ukrvServiceImpl.updateDetail3", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail3", paramMaster);
		return;
	}

	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail3(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.delete("esa200ukrvServiceImpl.deleteDetail3", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail3", paramMaster);
		return;
	}
	
	
	
	
	/**
	 * 기타경비등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			
			if(paramData.get("method").equals("insertDetail4"))	
				this.insertDetail4(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateDetail4"))	
				this.updateDetail4(dataList, dataMaster, user);
			if(paramData.get("method").equals("deleteDetail4"))
				this.deleteDetail4(dataList, dataMaster, user);
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception{
		for(Map param :paramList )	{
			super.commonDao.insert("esa200ukrvServiceImpl.insertDetail4", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail4", paramMaster);
		
		return ;
	}
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail4(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.update("esa200ukrvServiceImpl.updateDetail4", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail4", paramMaster);
		return;
	}

	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail4(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.delete("esa200ukrvServiceImpl.deleteDetail4", param);
		}
		super.commonDao.update("esa200ukrvServiceImpl.updateMasterDetail4", paramMaster);
		return;
	}
	
	
}

