package foren.unilite.modules.z_kd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_bpr100ukrv_kdService")
public class S_bpr100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	/**
	 * 품목정보 조회
	 * 
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_bpr100ukrv_kdService.selectDetailList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user)
			throws Exception {

		// Map<String, Object> dataMaster = (Map<String, Object>)
		// paramMaster.get("data");
		// Map<String, Object> rMap;
		//
		// if(ObjUtils.isEmpty(dataMaster.get("REQUEST_NUM"))) {
		// rMap = (Map<String, Object>)
		// super.commonDao.queryForObject("gre100ukrvServiceImpl.insert",
		// dataMaster);
		// dataMaster.put("REQUEST_NUM", rMap.get("REQUEST_NUM"));
		// }else {
		// super.commonDao.update("gre100ukrvServiceImpl.update", dataMaster);
		// }
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>) dataListMap.get("data");
				} else if (dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>) dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>) dataListMap.get("data");
				}
			}
			if (deleteList != null)
				this.deleteDetail(deleteList, user);
			if (insertList != null)
				this.insertDetail(insertList, user);
			if (updateList != null)
				this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer insertDetail(List<Map> paramList, LoginVO user)
			throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list(
					"s_bpr100ukrv_kdService.checkCompCode", compCodeMap);
			for (Map param : paramList) {
				for (Map checkCompCode : chkList) {
					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					// Map chkItemMap = (Map)
					// super.commonDao.select("s_bpr100ukrv_kdService.checkItemCode",
					// param);
					// if(ObjUtils.parseInt(chkItemMap.get("CNT")) > 0) {
					// super.commonDao.insert("s_bpr100ukrv_kdService.updateDetail",
					// param);
					// }else {
					super.commonDao.update("s_bpr100ukrv_kdService.insertDetail",
							param);
				}
				if (!ObjUtils.isEmpty(param.get("IMAGE_FID"))) {
					fileMnagerService.confirmFile(user,
							ObjUtils.getSafeString(param.get("IMAGE_FID")));
					// }
				}

				// (수주등록의)엑셀 참조 업로드에서 폼목 등록으로 연결된 자료의 경우
				if (!ObjUtils.isEmpty(param.get("_EXCEL_JOBID"))) {
					super.commonDao.delete("s_bpr100ukrv_kdService.deleteSOF112T",
							param);

				}
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}

		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateDetail(List<Map> paramList, LoginVO user)
			throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list(
				"s_bpr100ukrv_kdService.checkCompCode", compCodeMap);
		for (Map param : paramList) {
			for (Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				Map chkItemMap = (Map) super.commonDao.select(
						"s_bpr100ukrv_kdService.checkItemCode", param);
				if (ObjUtils.parseInt(chkItemMap.get("CNT")) > 0) {
					super.commonDao.insert("s_bpr100ukrv_kdService.updateDetail",
							param);
				} else {
					super.commonDao.update("s_bpr100ukrv_kdService.insertDetail",
							param);
				}
				if (!ObjUtils.isEmpty(param.get("IMAGE_FID"))) {
					fileMnagerService.confirmFile(user,
							ObjUtils.getSafeString(param.get("IMAGE_FID")));
				}
			}
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList, LoginVO user)
			throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list(
				"s_bpr100ukrv_kdService.checkCompCode", compCodeMap);
		for (Map param : paramList) {
			for (Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				List chkChildList = (List) super.commonDao.list(
						"s_bpr100ukrv_kdService.checkChildCode", param);
				if (chkChildList.size() > 0) {
					throw new UniDirectValidateException(this.getMessage("547",
							user)
							+ "[품목코드:"
							+ ObjUtils.getSafeString(param.get("ITEM_CODE"))
							+ "]");
				} else {
					try {
						super.commonDao.delete(
								"s_bpr100ukrv_kdService.deleteDetail", param);
						if (!ObjUtils.isEmpty(param.get("IMAGE_FID"))) {
							fileMnagerService.deleteFile(user, ObjUtils
									.getSafeString(param.get("IMAGE_FID")));
						}
					} catch (Exception e) {
						throw new UniDirectValidateException(this.getMessage(
								"547", user));
					}
				}
			}
		}
		return 0;
	}


}
