package foren.unilite.modules.trade.tit;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service( "tit100ukrvService" )
public class Tit100ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger           logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "salesCommonService" )
    private SalesCommonServiceImpl SalesUtil;
    @Resource( name = "fileMnagerService" )
    private FileMnagerService      fileMnagerService;
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "trade" )
    public List<Map<String, Object>> selectList2( Map param ) throws Exception {
        return super.commonDao.list("tit100ukrvServiceImpl.selectList2", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_POST, group = "trade" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public ExtDirectFormPostResult syncMaster( Tit100ukrvModel param, LoginVO user, BindingResult result ) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateString = sdf.format(new Date());
        //1.로그테이블에서 사용할 Key 생성		
        String keyValue = getLogKey();
        param.setKEY_VALUE(keyValue);
        param.setCOMP_CODE(user.getCompCode());
        param.setUPDATE_DB_USER(user.getUserID());
        if (param.getPASS_SER_NO() == "" || param.getPASS_SER_NO() == null) {
            Map<String, Object> spParam1 = new HashMap<String, Object>();
            spParam1.put("COMP_CODE", user.getCompCode());
            spParam1.put("DATE", dateString);
            String auto_numString = super.commonDao.select("tit100ukrvServiceImpl.auto_num", spParam1).toString();
            param.setPASS_SER_NO(auto_numString);
            param.setOPR_FLAG("N");
        } else if (param.getOPR_FLAG() == "" || param.getOPR_FLAG() == null) {
            param.setOPR_FLAG("U");
        }
        super.commonDao.insert("tit100ukrvServiceImpl.insertLogMaster", param);
        Map<String, Object> spParam = new HashMap<String, Object>();
        
        spParam.put("KeyValue", keyValue);
        spParam.put("LangCode", user.getLanguage());
        spParam.put("OPR_FLAG", param.getOPR_FLAG());
        super.commonDao.queryForObject("tit100ukrvServiceImpl.spTit100ukr", spParam);
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        
        if ("0;".equals(errorDesc)) {
            
        } else {
            String[] messsage = errorDesc.split(";");
            throw new UniDirectValidateException(this.getMessage(messsage[0], user));
        }
        return extResult;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "trade" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("tit100ukrvServiceImpl.selectList", param);
    }
    
    
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "trade" )
    public Object prevList( Map param ) throws Exception {
        param.put("PASS_SER_NO", param.get("PASS_SER_NO") == "" || param.get("PASS_SER_NO") == null ? "ZZZZZZZZZZZZZZ" : param.get("PASS_SER_NO"));
        return super.commonDao.select("tit100ukrvServiceImpl.prevList", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "trade" )
    public Object nextList( Map param ) throws Exception {
        param.put("PASS_SER_NO", param.get("PASS_SER_NO") == "" || param.get("PASS_SER_NO") == null ? "ZZZZZZZZZZZZZZ" : param.get("PASS_SER_NO"));
        return super.commonDao.select("tit100ukrvServiceImpl.nextList", param);
    }
    
    @ExtDirectMethod( group = "trade", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> update( List<Map> params, LoginVO user ) throws Exception {
        return null;
    }
    
    @ExtDirectMethod( group = "trade", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> delete( List<Map> params, LoginVO user ) throws Exception {
        
        return null;
    }
    
    @ExtDirectMethod( group = "trade", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> insert( List<Map> params, LoginVO user ) throws Exception {
        return null;
    }
    
    
    /**
     * 수입통관정보 저장
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
                param.put("data", super.commonDao.insert("tit100ukrvServiceImpl.insertLogMaster", param));
            }
        }   
        //수입통관등록 Stored Procedure 실행
        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("KeyValue", keyValue);
        spParam.put("LangCode", user.getLanguage());

        super.commonDao.queryForObject("sco110ukrvServiceImpl.USP_SALES_Sco110ukr", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        
        //수입통관번호 채번
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
                
        if(!ObjUtils.isEmpty(errorDesc)){
            dataMaster.put("PASS_SER_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        } else {
            dataMaster.put("PASS_SER_NO", ObjUtils.getSafeString(spParam.get("PassSerNo")));
            //수입통관번호 그리드에 SET
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");    
                if(param.get("method").equals("insertDetail")) {
                    List<Map> datas = (List<Map>)param.get("data");
                    for(Map data: datas){
                        data.put("PASS_SER_NO", ObjUtils.getSafeString(spParam.get("PassSerNo")));
                    }
                }
            }
        }
        paramList.add(0, paramMaster);      
        return  paramList;

    }
    
    /**
     * 수입통관  입력
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
        
        return params;
    }
    
    /**
     * 수입통관  수정
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
     * 수입통관  삭제
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
    
    }
    
}
