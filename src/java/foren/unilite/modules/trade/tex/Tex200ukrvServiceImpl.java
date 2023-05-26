package foren.unilite.modules.trade.tex;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;



@Service("tex200ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Tex200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("tex200ukrvService.selectMasterList", param);
	}

	/**
	 * Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("tex200ukrvService.selectDetailList", param);
	}



	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> masterUpdateList = null;
			List<Map> detailInsertList = null;
			List<Map> detailUpdateList = null;
			List<Map> detailDeleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateMaster")) {
					masterUpdateList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					detailDeleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					detailInsertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					detailUpdateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(masterUpdateList != null) this.updateMaster(masterUpdateList, user);
			if(detailDeleteList != null) this.deleteDetail(detailDeleteList, user);
			if(detailInsertList != null) this.insertDetail(detailInsertList, user);
			if(detailUpdateList != null) this.updateDetail(detailUpdateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	/**
	 * Master 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateMaster(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			 super.commonDao.update("tex200ukrvService.updateMaster", param);
		}
		return 0;
	}

	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
			for(Map param : paramList ) {
				super.commonDao.update("tex200ukrvService.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("tex200ukrvService.updateDetail", param);
		}
		return 0;
	}

	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			try {
				super.commonDao.delete("tex200ukrvService.deleteDetail", param);
			}catch(Exception e) {
					throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}
}