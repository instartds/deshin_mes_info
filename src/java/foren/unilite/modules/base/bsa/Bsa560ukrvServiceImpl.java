package foren.unilite.modules.base.bsa;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "bsa560ukrvService" )
public class Bsa560ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 법인코드 콤보 만들기
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<ComboItemModel> getCompCode( Map param ) throws Exception {
        return (List<ComboItemModel>)super.commonDao.list("bsa560ukrvServiceImpl.getCompCode", param);
    }
    
    /**
     * 사용자별 법인 권한 등록 그리드1
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "bsa", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("bsa560ukrvServiceImpl.selectList", param);
    }
    
    /**
     * 사용자별 법인 권한 등록 그리드2
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "bsa", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList2( Map param ) throws Exception {
        return super.commonDao.list("bsa560ukrvServiceImpl.selectList2", param);
    }
    
    /**
     * 사용자별 법인 권한 등록 그리드3
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "bsa", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList3( Map param ) throws Exception {
        return super.commonDao.list("bsa560ukrvServiceImpl.selectList3", param);
    }
    
    /** 저장 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "bsa" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            //			List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } /*
                   * else if(dataListMap.get("method").equals("updateDetail")) { updateList = (List<Map>)dataListMap.get("data"); }
                   */
            }
            if (deleteList != null) this.deleteDetail(deleteList, user);
            if (insertList != null) this.insertDetail(insertList, user, paramMaster);
            //			if(updateList != null) this.updateDetail(updateList, user);				
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "matrl" )
    public Integer insertDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        try {
            Map compCodeMap = new HashMap();
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            compCodeMap.put("S_COMP_CODE", user.getCompCode());
            List<Map> chkList = (List<Map>)super.commonDao.list("bsa560ukrvServiceImpl.checkCompCode", compCodeMap);
            for (Map param : paramList) {
                for (Map checkCompCode : chkList) {
                    param.put("USER_ID_G1", dataMaster.get("USER_ID_G1"));
                    
                    super.commonDao.update("bsa560ukrvServiceImpl.insertDetail", param);
                }
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        
        return 0;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "matrl" )
    public Integer deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        Map compCodeMap = new HashMap();
        compCodeMap.put("S_COMP_CODE", user.getCompCode());
        List<Map> chkList = (List)super.commonDao.list("bsa560ukrvServiceImpl.checkCompCode", compCodeMap);
        for (Map param : paramList) {
            for (Map checkCompCode : chkList) {
                try {
                    super.commonDao.delete("bsa560ukrvServiceImpl.deleteDetail", param);
                    
                } catch (Exception e) {
                    throw new UniDirectValidateException(this.getMessage("547", user));
                }
            }
        }
        return 0;
    }
    
}
