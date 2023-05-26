package foren.unilite.modules.z_novis;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
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


@Service("s_ppl102ukrv_novisService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_ppl102ukrv_novisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 생산계획일 컬럼셋팅관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_novis", value = ExtDirectMethodType.STORE_READ)
	public Object getPlanDay(Map param) throws Exception {
		return super.commonDao.select("s_ppl102ukrv_novisServiceImpl.getPlanDay", param);
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

		super.commonDao.update("s_ppl102ukrv_novisServiceImpl.saveAutoItemCode", param);

        rtnV = "Y";
        return rtnV;
    }
	
	/**
	 * 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_novis")
	public List<Map> selectList1(Map param) throws Exception{
		return super.commonDao.list("s_ppl102ukrv_novisServiceImpl.selectList1", param);
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
			
			for(int i = 1; i<12; i++){
				String strI = Integer.toString(i);
				param.put("PROG_CODE", param.get("PROG_CODE"+strI));
				param.put("PROG_STATUS", param.get("PROG_STATUS"+strI));
				param.put("PRODT_PLAN_DATE", param.get("PRODT_PLAN_DATE"+strI));
				
				/*Map<String, Object> spParam = new HashMap<String, Object>();
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
				Date dateGet = new Date();
				String dateGetString = dateFormat.format(dateGet);
				spParam.put("COMP_CODE", user.getCompCode());
				spParam.put("DIV_CODE", user.getDivCode());
				spParam.put("TABLE_ID", "S_PPL100T_NOVIS");
				spParam.put("PREFIX", "P");
				spParam.put("BASIS_DATE", dateGetString);
				spParam.put("AUTO_TYPE", "1");
				super.commonDao.queryForObject("s_ppl102ukrv_novisServiceImpl.spAutoNum", spParam);
				
				param.put("WK_PLAN_NUM", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));*/
				
				
				//공정코드 값이 있을때만 insert
				if(ObjUtils.isNotEmpty(param.get("PROG_CODE"+strI))){
					super.commonDao.insert("s_ppl102ukrv_novisServiceImpl.insertDetail", param);
				}
			}
		}
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void updateDetail1(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			for(int i = 1; i<12; i++){
				String strI = Integer.toString(i);
				param.put("PROG_CODE", param.get("PROG_CODE"+strI));
				param.put("PROG_STATUS", param.get("PROG_STATUS"+strI));
				param.put("PRODT_PLAN_DATE", param.get("PRODT_PLAN_DATE"+strI));
				param.put("PRODT_DATE", param.get("PRODT_DATE"+strI));
				
				param.put("WK_PLAN_NUM", param.get("WK_PLAN_NUM"+strI));
				
				//생산계획번호가 없고 공정코드가 빈값이면 패스
				if(ObjUtils.isNotEmpty(param.get("WK_PLAN_NUM"+strI)) && ObjUtils.isEmpty(param.get("PROG_CODE"+strI))){
					//생산계획번호가 있고 공정코드가 빈값이면 delete
					 super.commonDao.delete("s_ppl102ukrv_novisServiceImpl.deleteDetail", param);
				}else if(ObjUtils.isNotEmpty(param.get("WK_PLAN_NUM"+strI)) && ObjUtils.isNotEmpty(param.get("PROG_CODE"+strI))){
					//생산계획번호가 있고 공정코드가 있으면 update
					super.commonDao.update("s_ppl102ukrv_novisServiceImpl.updateDetail", param);
				}else if(ObjUtils.isEmpty(param.get("WK_PLAN_NUM"+strI)) && ObjUtils.isNotEmpty(param.get("PROG_CODE"+strI))){
					//생산계획번호가 없고 공정코드가 있으면  insert
					super.commonDao.insert("s_ppl102ukrv_novisServiceImpl.insertDetail", param);
				}
			}
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void deleteDetail1(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			for(int i = 1; i<12; i++){
				String strI = Integer.toString(i);
				param.put("WK_PLAN_NUM", param.get("WK_PLAN_NUM"+strI));
				 super.commonDao.delete("s_ppl102ukrv_novisServiceImpl.deleteDetail", param);
			}
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
		return super.commonDao.list("s_ppl102ukrv_novisServiceImpl.selectList2", param);
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
			super.commonDao.insert("s_ppl102ukrv_novisServiceImpl.insertDetail_100T", param);
			super.commonDao.update("s_ppl102ukrv_novisServiceImpl.insertDetail_200T", param);
		}
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("s_ppl102ukrv_novisServiceImpl.updateDetail_100T", param);
			super.commonDao.update("s_ppl102ukrv_novisServiceImpl.updateDetail_200T", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_novis")
	public void deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList ) {
			 super.commonDao.delete("s_ppl102ukrv_novisServiceImpl.deleteDetail_100T", param);
			 super.commonDao.delete("s_ppl102ukrv_novisServiceImpl.deleteDetail_200T", param);
		 }
		 return;
	}

}
