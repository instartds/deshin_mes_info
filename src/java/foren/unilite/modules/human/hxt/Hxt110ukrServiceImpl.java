package foren.unilite.modules.human.hxt;

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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.DevFreeUtils;

/**
 * <pre>
 * 성금등록
 * </pre>
 * 
 * @author 박종영
 */
@Service( "hxt110ukrService" )
public class Hxt110ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 성금등록 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Transactional( readOnly = true )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return (List)super.commonDao.list("hxt110ukrServiceImpl.selectList", param);
    }
    
    
    /**
     * sp후 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Transactional( readOnly = true )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public List<Map<String, Object>> spSelect( Map param ) throws Exception {
        return (List)super.commonDao.list("hxt110ukrServiceImpl.spSelect", param);
    }
    
    /**
     * 성금등록 저장
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        List<Map> insertList = null;
        List<Map> updateList = null;
        List<Map> deleteList = null;
        
        if (paramList != null) {
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateList")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteList(deleteList);
            if (insertList != null) this.insertList(insertList, user);
            if (updateList != null) this.updateList(updateList);
        }
        
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 선택된 행을 추가함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertList( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.insert("hxt110ukrServiceImpl.insertList", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(DevFreeUtils.errorMsg(e.getMessage()));
        }
        return paramList;
    }
    
    /**
     * 선택된 행을 수정함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateList( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("hxt110ukrServiceImpl.updateList", param);
        }
        return paramList;
    }
    
    /**
     * 
     * 선택된 행을 삭제함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteList( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.delete("hxt110ukrServiceImpl.deleteList", param);
        }
        return paramList;
    }
    
	/**
	 * 성금등록 SP호출
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public Object  insertMaster(Map spParam, LoginVO user) throws Exception {

		super.commonDao.queryForObject("hxt110ukrServiceImpl.spReceiving", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}else{
			return true;
		}		
	}
    
}
