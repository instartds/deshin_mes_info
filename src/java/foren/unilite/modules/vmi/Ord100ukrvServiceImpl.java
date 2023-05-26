package foren.unilite.modules.vmi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;

@Service("ord100ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ord100ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "vmi")
	public List<Map<String, Object>>  selectList(Map param,LoginVO user) throws Exception {
		param.put("S_USER_ID", user.getUserID());
		param.put("S_COMP_CODE", user.getCompCode());
		return  super.commonDao.list("ord100ukrvServiceImpl.selectList", param);
	}



	/**
	 * 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "vmi")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramDetail:" + paramList);
		//1.주문번호, 순번 채번
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("S_COMP_CODE", user.getCompCode());
		//확정되지 않은 품목의 주문번호 존재 시, 해당 주문번호 사용 - 존재여부 체크
		Map getNum		= (Map) commonDao.select("ord100ukrvServiceImpl.getSoNum", dataMaster);
		String soNum	= (String) getNum.get("SO_NUM");
		int soSeq		= (int) getNum.get("SO_SEQ");

		//2.주문마스터 SOF200T에 저장
		dataMaster.put("SO_NUM", soNum);
		//주문순번이 0이면 MASTER 데이터가 없으므로 insert
		if(soSeq == 0) {
			super.commonDao.insert("ord100ukrvServiceImpl.insertMaster", dataMaster);
		} else {
			//20190830 추가: 최종 등록한 주문일자로 MASTER Data의 주문일 update
			dataMaster.put("SO_NUM", soNum);
			super.commonDao.update("ord100ukrvServiceImpl.updateMaster", dataMaster);
		}

		//3.주문디테일 SOF220T에 저장
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");

				if(param.get("method").equals("updateDetail")) {
					param.put("data", updateDetail(dataList, user, soNum, soSeq, ObjUtils.getSafeString(dataMaster.get("CUSTOM_CODE"))));
				} /*else if(param.get("method").equals("insertDetail")) {
					param.put("data", insertDetail(dataList, user) );
				} else if(param.get("method").equals("deleteDetail")) {
					deleteDetail(dataList, user);
				}*/
			}
		}

		//수주번호 마스터에 SET
		dataMaster.put("SO_NUM", ObjUtils.getSafeString(soNum));

		//5.수주마스터 정보 + 수주디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);

		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "vmi")
	public List<Map> updateDetail(List<Map> params, LoginVO user, String soNum, int soSeq, String customCode) throws Exception {
		for(Map param: params) {
			soSeq = soSeq + 1;
			param.put("SO_NUM"		, soNum);
			param.put("SO_SEQ"		, soSeq);
			param.put("CUSTOM_CODE"	, customCode);
			//체크한 데이터만 저장 처리
			if("Y".equals(param.get("SAVE_FLAG"))) {
				super.commonDao.update("ord100ukrvServiceImpl.insertDetail", param);
			}
		}
		return params;
	}
}
