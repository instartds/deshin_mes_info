package foren.unilite.modules.z_mit;

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

@Service("s_etv130skrv_mitService")
public class S_Etv130skrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 기간 작업지시, 실적 집계 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_BUFFERED, group = "z_mit" )		//STORE_READ  일때  page, start, limit 값 못가져옴..
	public Map<String, Object> selectList( Map param) throws Exception {

		Map<String, Object> rMap = new HashMap();
	        
        Map<String, Object> rTotal = new HashMap();
        List<Map<String, Object>> rList = new ArrayList();

        rList = (List)super.commonDao.list("s_etv130skrv_mitServiceImpl.selectList", param);

        int total = 0;
        if (rList.size() > 0) {
            Map<String, Object> tmpMap = (Map<String, Object>)rList.get(0);
            total = ObjUtils.parseInt(tmpMap.get("TOTAL"));
        }
        rMap.put("data", rList);
        rMap.put("total", total);

        return rMap;
		
	}	
	
	/**
	 * 공지사항 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectContents(Map param) throws Exception {
		return super.commonDao.list("s_etv130skrv_mitServiceImpl.selectContents", param);
	}	
	
	/**
	 * 당일 실적처리현황 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */	

	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_BUFFERED, group = "z_mit" )		//STORE_READ  일때  page, start, limit 값 못가져옴..
	public Map<String, Object> selectList1( Map param) throws Exception {

		Map<String, Object> rMap = new HashMap();
	        
        Map<String, Object> rTotal = new HashMap();
        List<Map<String, Object>> rList = new ArrayList();

        rList = (List)super.commonDao.list("s_etv130skrv_mitServiceImpl.selectList1", param);

        int total = 0;
        if (rList.size() > 0) {
            Map<String, Object> tmpMap = (Map<String, Object>)rList.get(0);
            total = ObjUtils.parseInt(tmpMap.get("TOTAL"));
        }
        rMap.put("data", rList);
        rMap.put("total", total);

        return rMap;
		
	}		
	
	/**
	 * 다음 프로그램 조회
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_BUFFERED, group = "z_mit" )		//STORE_READ  일때  page, start, limit 값 못가져옴..
	public String selectNextPgmId(Map param) throws Exception {
        String nextPgmId = (String)super.commonDao.select("s_etv130skrv_mitServiceImpl.selectNextPgmId", param);

        return nextPgmId;
		
	}	
	/**
	 * 다음 프로그램 조회
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_BUFFERED, group = "z_mit" )		//STORE_READ  일때  page, start, limit 값 못가져옴..
	public Integer selectNextPgmInterval(Map param) throws Exception {
        Integer interval = (Integer)super.commonDao.select("s_etv130skrv_mitServiceImpl.selectNextPgmInterval", param);

        return interval;
		
	}	
	/**
	 * 날짜 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectCaldate(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_etv130skrv_mitServiceImpl.selectCaldate" ,comp_code);
	}	
	
}
