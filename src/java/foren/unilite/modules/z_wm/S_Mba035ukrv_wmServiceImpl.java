package foren.unilite.modules.z_wm;

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
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_mba035ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Mba035ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 기획상품단가 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_mba035ukrv_wmServiceImpl.selectList", param);
	}



	/**
	 * 기획상품단가 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList, user);
			if(insertList != null) this.insertList(insertList, user);
			if(updateList != null) this.updateList(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**
	 * 기획상품단가 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer insertList(List<Map> paramList, LoginVO user) throws Exception {
		String errMsg = "";
		try {
			for(Map param :paramList) {
				//신규 등록 전, 기 등록된 데이터와 적용 시작일 비교
				String checkData = (String) super.commonDao.select("s_mba035ukrv_wmServiceImpl.checkData", param);
				if (!checkData.equals("N")) {
					errMsg = "(등록된 데이터 보다 적용 시작일이 빠른 데이터는 등록할 수 없습니다.)";
					throw new UniDirectValidateException("");
				}
				//20210225 추가: 서로 다른 품목코드에 동일한 상품코드 들어갈 수 없도록 체크하는 로직 추가
				String checkData2 = (String) super.commonDao.select("s_mba035ukrv_wmServiceImpl.checkData2", param);
				if (!checkData2.equals("N")) {
					errMsg = "(서로 다른 품목코드에 동일한 상품코드를 입력할 수 없습니다.)";
					throw new UniDirectValidateException("");
				}
				super.commonDao.insert("s_mba035ukrv_wmServiceImpl.insertList", param);
			}
		} catch(Exception e){
			throw new UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		return 0;
	}

	/**
	 * 기획상품단가 수정 (update)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
		String errMsg = "";
		try {
			for(Map param :paramList ) {
				//20210225 추가: 서로 다른 품목코드에 동일한 상품코드 들어갈 수 없도록 체크하는 로직 추가
				String checkData2 = (String) super.commonDao.select("s_mba035ukrv_wmServiceImpl.checkData2", param);
				if (!checkData2.equals("N")) {
					errMsg = "(서로 다른 품목코드에 동일한 상품코드를 입력할 수 없습니다.)";
					throw new UniDirectValidateException("");
				}
				super.commonDao.update("s_mba035ukrv_wmServiceImpl.updateList", param);
			}
		} catch(Exception e){
			throw new UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		return 0;
	}

	/**
	 * 기획상품단가 삭제 (delete)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer deleteList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			try {
				super.commonDao.delete("s_mba035ukrv_wmServiceImpl.deleteList", param);
			}catch(Exception e) {
				throw new UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}
}