package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "agb260skrService" )
public class Agb260skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 부서목록 조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getAllDeptList( Map param ) throws Exception {			// 부서전체목록
        Map rtnMap = (Map)super.commonDao.select("agb260skrServiceImpl.getGubun", param);
        param.put("GUBUN", rtnMap.get("SUB_CODE"));
        return  super.commonDao.list("agb260skrServiceImpl.getAllDeptList", param);
    }
    
    /**
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> getDeptCodeColumn( Map param ) throws Exception {		// 부서목록(조회 할때마다 & 탭변경 할때마다)
        Map rtnMap = (Map)super.commonDao.select("agb260skrServiceImpl.getGubun", param);
        param.put("GUBUN", rtnMap.get("SUB_CODE"));
        return super.commonDao.list("agb260skrServiceImpl.getDeptCodeColumn", param);
    }

    /**
     * 메인조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        Map rtnMap = (Map)super.commonDao.select("agb260skrServiceImpl.getGubun", param);
        param.put("GUBUN", rtnMap.get("SUB_CODE"));        
        return super.commonDao.list("agb260skrServiceImpl.selectList", param);
    }
    
    /**
     * 부서명 가져오기
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> dept( Map param ) throws Exception {
        return super.commonDao.list("agb260skrServiceImpl.dept", param);
        
    }
}
