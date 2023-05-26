package foren.unilite.modules.accnt.agj;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "agj240skrService" )
public class Agj240skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 전표 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "Accnt", value = ExtDirectMethodType.STORE_BUFFERED )
    public Map<String, Object> selectList( Map param/* , ExtDirectStoreReadRequest req */) throws Exception {
        
        Map<String, Object> rMap = new HashMap();
        
        Map<String, Object> rTotal = new HashMap();
        List<Map<String, Object>> rList = new ArrayList();
        if (ObjUtils.parseBoolean(param.get("Init"), false)) {
            Map<String, Object> tmp = new HashMap<String, Object>();
            tmp.put("Init", true);
            rList.add(tmp);
            rTotal.put("total", 0);
        } else {
            rList = (List)super.commonDao.list("agj240skrServiceImpl.selectList", param);
            /*rTotal = (Map<String, Object>) super.commonDao.select("agj240skrServiceImpl.selectListSummary", param);
            if(rList != null && rList.size() > 0 && rTotal!=null)   {
                Map<String, Object> firstMap = rList.get(0);
                firstMap.putAll(rTotal);
            }*/            
        }
        int total = 0;
        if (rList.size() > 0) {
            Map<String, Object> tmpMap = (Map<String, Object>)rList.get(0);
            total = ObjUtils.parseInt(tmpMap.get("TOTAL"));
        }
        rMap.put("data", rList);
        rMap.put("total", total);
        
        //return rList;
        return rMap;
    }
    
    /**
     * Excel 다운로드를 위해.
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    public List selectExcelList( Map param ) throws Exception {
        return (List)super.commonDao.list("agj240skrServiceImpl.selectList", param);
    }
    
    /**
     * 각주 조회
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object getPostIt( Map param ) throws Exception {
        return super.commonDao.select("agj240skrServiceImpl.getPostIt", param);
    }
    
    /**
     * 각주 수정
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object updatePostIt( Map param ) throws Exception {
        return super.commonDao.select("agj240skrServiceImpl.updatePostIt", param);
    }
    
    /**
     * 각주 삭제
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object deletePostIt( Map param ) throws Exception {
        return super.commonDao.select("agj240skrServiceImpl.deletePostIt", param);
    }
    
}
