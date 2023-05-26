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



@Service("s_pmp200ukrv_kdService")
public class S_pmp200ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	

	
	
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectAgreePrsn(Map param) throws Exception {
		return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.selectAgreePrsn", param);
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.selectOrderNumMaster", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.selectEstiList", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> orderApply(Map param) throws Exception {
		return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.orderApply", param);		// 참조 팝업 적용버튼 클릭시
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> orderApply2(Map param) throws Exception {
		return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.orderApply2", param);		// 참조 팝업 적용버튼 클릭시2
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
        return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.selectGwData", param);
    }
    
    /**
     * 
     * 기안번호 검색
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectDraftNo(Map param) throws Exception {
        return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.selectDraftNo", param);
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
        return super.commonDao.list("s_pmp200ukrv_kdServiceImpl.makeDraftNum", param);
    }
	
	/**
     * 접수등록(통합) 저장
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
     logger.debug("[saveAll] paramDetail:" + paramList);

     //1.로그테이블에서 사용할 KeyValue 생성
     String keyValue = getLogKey();      
       
     //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
     List<Map> dataList = new ArrayList<Map>();
     List<List<Map>> resultList = new ArrayList<List<Map>>();
     
     for(Map paramData: paramList) {   
      
         dataList = (List<Map>) paramData.get("data");
         String oprFlag = "N";
         if(paramData.get("method").equals("insertDetail")) oprFlag="N";
         if(paramData.get("method").equals("updateDetail")) oprFlag="U";
         if(paramData.get("method").equals("deleteDetail")) oprFlag="D";
   
         for(Map param:  dataList) {
           param.put("KEY_VALUE", keyValue);
           param.put("OPR_FLAG", oprFlag);
           param.put("data", super.commonDao.insert("s_pmp200ukrv_kdServiceImpl.insertLogMaster", param));
         }
     }
   //4.매출저장 Stored Procedure 실행
           Map<String, Object> spParam = new HashMap<String, Object>();

           spParam.put("KeyValue", keyValue);
           spParam.put("LangCode", user.getLanguage());

           super.commonDao.queryForObject("s_pmp200ukrv_kdServiceImpl.spReceiving", spParam);
           
           String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
           
           //출하지시 마스터 출하지시 번호 update
           Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

           if(!ObjUtils.isEmpty(errorDesc)){
               dataMaster.put("OUTSTOCK_NUM", "");
               String[] messsage = errorDesc.split(";");
               throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
           } else {
               dataMaster.put("OUTSTOCK_NUM", ObjUtils.getSafeString(spParam.get("OUTSTOCK_NUM")));
               for(Map param: paramList) {
                   dataList = (List<Map>)param.get("data");    
                   if(param.get("method").equals("insertDetail")) {
                       List<Map> datas = (List<Map>)param.get("data");
                       for(Map data: datas){
                           data.put("OUTSTOCK_NUM", ObjUtils.getSafeString(spParam.get("OUTSTOCK_NUM")));
                       }
                   }
               }
           }
     
     paramList.add(0, paramMaster);
     return  paramList;
    }
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
    public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        return 0;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
    public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        
        return 0;
    } 
    
    
    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
    public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
        
        return 0;
    }
}
