package foren.unilite.modules.z_kd;

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
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("s_opo100ukrv_kdService")
public class S_opo100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
		
	/**
	 * 
	 * 외주발주내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)			/* 조회 */
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_opo100ukrv_kdService.selectMpoList", param);
	}

	/**
	 * 
	 * 수주정보검색 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("s_opo100ukrv_kdService.selectDetailList", param);		/* 검색 */
	}
	
	/**
	 * 
	 * 외주긴급발주 발주번호 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumList(Map param) throws Exception {
		return super.commonDao.list("s_opo100ukrv_kdService.selectOrderNumList", param);
	}
	
	/**
     * 
     * 발주요청등록 참조
     * @param param
     * @return
     * @throws Exception
     */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectMre100tList(Map param) throws Exception {
        return super.commonDao.list("s_opo100ukrv_kdService.selectMre100tList", param);
    }
	
	/**
     * 
     * 마스터 기안상태 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectGwData(Map param) throws Exception {
        return super.commonDao.list("s_opo100ukrv_kdService.selectGwData", param);
    }
    
    /**
     *  기안버튼 눌렀을때 번호생성(UPDATE)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 기안버튼 눌렀을때 번호생성(UPDATE) */
    public List<Map<String, Object>> makeDraftNum(Map param) throws Exception {
        return super.commonDao.list("s_opo100ukrv_kdService.makeDraftNum", param);
    }
	
	/**
	 * 외주 긴급발주등록(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.발주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("ORDER_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("s_opo100ukrv_kdService.insertLogMaster", dataMaster);
//		super.commonDao.insert("mpo501ukrvServiceImpl.insertLogMaster", dataMaster);
		
		
		//3.발주디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insertDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "N") );	
				} else if(param.get("method").equals("updateDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "U") );	
				} else if(param.get("method").equals("deleteDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "D") );	
				}
			}
		}

		//4.발주저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_opo100ukrv_kdService.spPurchaseOutOrder", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		System.out.println("==========errorDesc===============" + errorDesc);
		
		if(!ObjUtils.isEmpty(errorDesc)){
		    dataMaster.put("ORDER_NUM", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));						
		} else {
            //마스터에 SET
            dataMaster.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
            //그리드에 SET
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");    
                if(param.get("method").equals("insertDetail")) {
                    List<Map> datas = (List<Map>)param.get("data");
                    for(Map data: datas){
                        data.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
                    }
                }
            }   
		}
		
		//5.발주마스터 정보 + 발주디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
     * Detail 입력
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
        return;
    }

    
    /**
     * Detail 수정
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        return;
    }
    
    /**
     * Detail 삭제
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
    public void deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
        return;
    }
	
	
	/**
	 * 발주등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params) {
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
//			super.commonDao.insert("mpo501ukrvServiceImpl.insertLogDetail", param);
			super.commonDao.insert("s_opo100ukrv_kdService.insertLogDetail", param);
		}
		return params;
	}
	
	//외주PL참조
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectReferList(Map param) throws Exception {
        return super.commonDao.list("s_opo100ukrv_kdService.selectReferList", param);
    }
	
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> fnGetReferData(Map param) throws Exception {
        return super.commonDao.list("s_opo100ukrv_kdService.fnGetReferData", param);
    }
    
    /**
     *  최근단가
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> fnGetLastPriceInfo(Map param) throws Exception {
        return super.commonDao.list("s_opo100ukrv_kdService.fnGetLastPriceInfo", param);
    }
}
