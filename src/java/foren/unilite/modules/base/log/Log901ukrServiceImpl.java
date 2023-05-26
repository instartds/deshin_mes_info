package foren.unilite.modules.base.log;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("log901ukrService")
public class Log901ukrServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * <pre>
	 * 배치 및 인터페이스 LOG조회
	 * </pre>
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	

	@SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "log")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("log901ukrServiceImpl.selectList", param);
	}

    /**
     * <pre>
     * 배치 정보를 조회해옴.
     * </pre>
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public Object getCronTask( Map param ) throws Exception {
        return super.commonDao.select("log901ukrServiceImpl.getCronTask", param);
    }
}
