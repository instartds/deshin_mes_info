package foren.unilite.modules.z_wm;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_map200ukrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Map200ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 계산서 유형 변경 시, 세액 가져오는 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRefCode2(Map param) throws Exception {
		return super.commonDao.list("s_map200ukrv_wmServiceImpl.selectRefCode2", param);
	}

	/**
	 * 신고사업장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object billDivCode(Map param) throws Exception {
		return super.commonDao.select("s_map200ukrv_wmServiceImpl.billDivCode", param);
	}

	/**
	 * 지급결의등록 -> 매입내역조회(마스터)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_map200ukrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 지급결의등록 -> 매입내역조회(상세)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_map200ukrv_wmServiceImpl.selectList2", param);
	}//grid





	/**
	 * 지급결의등록(master) -> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");
		String keyValue					= (String) dataMaster.get("KEY_VALUE");

		//log data(master) 생성
		List<Map> mDataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			String oprFlag	= "N";
			mDataList		= (List<Map>) paramData.get("data");

			if("N".equals(dataMaster.get("ENTRY_YN"))) {
				oprFlag = "N";
			} else if(paramData.get("method").equals("deleteDetail")) {
				oprFlag = "D";
			} else {
				oprFlag = "U";
			}
			for(Map param: mDataList) {
				param.put("KEY_VALUE"	, keyValue);
				param.put("OPR_FLAG"	, oprFlag);
				super.commonDao.insert("s_map200ukrv_wmServiceImpl.insertLogForm", param);
			}
		};

		//저장 SP 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		super.commonDao.queryForObject("s_map200ukrv_wmServiceImpl.spBuy", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(ObjUtils.isNotEmpty(errorDesc)) {
			String[] messsage = errorDesc.split(";");
			if(messsage.length == 1){
				throw new UniDirectValidateException(this.getMessage(messsage[0], user));
			}else{
				throw new UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);
			}
		}

		paramList.add(0, paramMaster);
		return paramList;
	}

	/**
	 * master 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * master 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * master 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}



	/**
	 * 지급결의등록(상세) -> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue					= getLogKey();
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		List<Map> lDataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			String oprFlag	= "N";

			if("N".equals(dataMaster.get("ENTRY_YN"))) {
				if(paramData.get("method").equals("updateDetail2")) {
					lDataList = (List<Map>) paramData.get("data");
				}
				oprFlag = "N";
			} else {
				lDataList = (List<Map>) paramData.get("data");
				if(paramData.get("method").equals("deleteDetail2")) {
					oprFlag = "D";
				} else {
					oprFlag = "U";
				}
			}
			for(Map param: lDataList) {
				param.put("KEY_VALUE"	, keyValue);
				param.put("OPR_FLAG"	, oprFlag);
				super.commonDao.insert("s_map200ukrv_wmServiceImpl.insertLogDetail", param);
			}
		}
		dataMaster.put("KEY_VALUE", keyValue);
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail2(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail2(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}
}