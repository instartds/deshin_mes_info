package foren.unilite.modules.vmi;

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


@Service("vmi210ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Vmi210ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 거래명세서 메인레포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("vmi210ukrvServiceImpl.mainReport", param);
	}

	/**
	 * 거래명세서 서브레포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("vmi210ukrvServiceImpl.subReport", param);
	}

	/**
	 * 거래명세서 서브레포트 신환
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReportShin(Map param) throws Exception {
		return  super.commonDao.list("vmi210ukrvServiceImpl.subReportShin", param);
	}

	/**
	 * 거래명세서 서브레포트 신환용 모품목 정보 가져오기
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReportShin_BomParentData(Map param) throws Exception {
		return  super.commonDao.list("vmi210ukrvServiceImpl.subReportShin_BomParentData", param);
	}

	/**
	 * 납품정보 search창 master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "vmi")
	public List<Map> selectSearchInfoMasterList(Map param) throws Exception{
		return super.commonDao.list("vmi210ukrvServiceImpl.selectSearchInfoMasterList", param);
	}

	/**
	 * 납품정보  search창 detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "vmi")
	public List<Map> selectSearchInfoDetailList(Map param) throws Exception{
		return super.commonDao.list("vmi210ukrvServiceImpl.selectSearchInfoDetailList", param);
	}

	/**
	 * 납품정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "vmi")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("vmi210ukrvServiceImpl.selectList", param);
	}

	/**
	 * 발주참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "vmi")
	public List<Map> selectReferOrderiList(Map param) throws Exception{
		return super.commonDao.list("vmi210ukrvServiceImpl.selectReferOrderiList", param);
	}
	/**
	 * 납품정보 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "vmi")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user, dataMaster);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "vmi")
	public void insertDetail(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		String issueNum = "";
		if(ObjUtils.isEmpty(dataMaster.get("ISSUE_NUM"))){
			Map<String, Object> spParam = new HashMap<String, Object>();
            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
            Date dateGet = new Date ();
            String dateGetString = dateFormat.format(dateGet);

            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
            spParam.put("TABLE_ID","VMI100T");
            spParam.put("PREFIX", "V");
            spParam.put("BASIS_DATE", dateGetString);
            spParam.put("AUTO_TYPE", "1");

			super.commonDao.queryForObject("vmi210ukrvServiceImpl.spAutoNum", spParam);
			issueNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
            dataMaster.put("ISSUE_NUM", issueNum);

		}else{
			issueNum = ObjUtils.getSafeString(dataMaster.get("ISSUE_NUM"));
		}
		for(Map param : paramList ) {
			param.put("ISSUE_NUM", issueNum);
			super.commonDao.insert("vmi210ukrvServiceImpl.insertDetail", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "vmi")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("vmi210ukrvServiceImpl.updateDetail", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "vmi")
	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList ) {
			 super.commonDao.delete("vmi210ukrvServiceImpl.deleteDetail", param);
		 }
		 return;
	}


	/**
	 * 입고등록_라벨_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport_label(Map param) throws Exception {
		return  super.commonDao.list("vmi210ukrvServiceImpl.mainReport_label", param);
	}

	/**
	 * 발주품목의 후공정 가져오는 쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport_label_afterProg(Map param) throws Exception {
		return  super.commonDao.list("vmi210ukrvServiceImpl.mainReport_label_afterProg", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "vmi")
	public void BomDataCreate(Map param) throws Exception {
			super.commonDao.update("vmi210ukrvServiceImpl.BomDataCreate", param);
			return;
	}

}
