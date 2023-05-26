package foren.unilite.modules.trade.tik;

import java.util.ArrayList;
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
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("tik100ukrvService")
public class Tik100ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
     * 
     * 대금정보 Detail 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectDetail(Map param) throws Exception {
        return super.commonDao.list("tik100ukrvServiceImpl.selectDetail", param);
    }
    
    /**
     * 
     * B/L 참조 창
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectBLList(Map param) throws Exception {
        return super.commonDao.list("tik100ukrvServiceImpl.selectBLList", param);
    }
    
    /**
     * 대금정보 저장
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        logger.debug("[saveAll] paramDetail:" + paramList);

        //1.로그테이블에서 사용할 KeyValue 생성
        String keyValue = getLogKey();                      
                
        //2.대금 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        
        for(Map paramData: paramList) {         
            
            dataList = (List<Map>) paramData.get("data");
            String oprFlag = "N";
            if(paramData.get("method").equals("insertDetail"))  oprFlag="N";
            if(paramData.get("method").equals("updateDetail"))  oprFlag="U";
            if(paramData.get("method").equals("deleteDetail"))  oprFlag="D";

            for(Map param:  dataList) {
                param.put("KEY_VALUE", keyValue);
                param.put("OPR_FLAG", oprFlag);
                param.put("data", super.commonDao.insert("tik100ukrvServiceImpl.insertLogDetail", param));
            }
        }   
        //대금등록 Stored Procedure 실행
        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("KeyValue", keyValue);
        spParam.put("LangCode", user.getLanguage());

        super.commonDao.queryForObject("tik100ukrvServiceImpl.USP_TRADE_TIK100UKR", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        
        //대금번호 채번
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
                
//      if(errorDesc != null){
//          dataMaster.put("COLL_NUM", "");
//          throw new Exception(errorDesc);     //에러가 있으면 에러 띄움
//      } else {
//          dataMaster.put("COLL_NUM", ObjUtils.getSafeString(spParam.get("CollectNum")));
//      }                                       //에러 없으면 대금번호set
    //  if(errorDesc.isEmpty())){
        if(!ObjUtils.isEmpty(errorDesc)){
            dataMaster.put("NEGO_SER_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        } else {
            dataMaster.put("NEGO_SER_NO", ObjUtils.getSafeString(spParam.get("NegoNo")));
            //대금번호 그리드에 SET
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");    
                if(param.get("method").equals("insertDetail")) {
                    List<Map> datas = (List<Map>)param.get("data");
                    for(Map data: datas){
                        data.put("NEGO_SER_NO", ObjUtils.getSafeString(spParam.get("NegoNo")));
                    }
                }
            }
        }
        paramList.add(0, paramMaster);      
        return  paramList;

    }
    
    /**
     * 대금 Detail 입력
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
        
        return params;
    }
    
    /**
     * 대금 Detail 수정
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
        return params;
    }
    
    /**
     * 대금 Detail 삭제
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
    
    }
}
