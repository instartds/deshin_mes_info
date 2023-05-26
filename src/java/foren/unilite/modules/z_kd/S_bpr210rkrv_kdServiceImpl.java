package foren.unilite.modules.z_kd;

import java.io.DataOutputStream;
import java.net.Socket;
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

@Service("s_bpr210rkrv_kdService")
public class S_bpr210rkrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	
    /**
     * 참조정보
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public List<Map<String, Object>>  referenceInfo(Map param) throws Exception {    
        
        return super.commonDao.list("s_bpr210rkrv_kdServiceImpl.referenceInfo", param);
        
    }
 
    
	/**
	 * 라벨출력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> printList(Map param) throws Exception{
		return super.commonDao.list("s_bpr210rkrv_kdServiceImpl.printList", param);
	}
    
    
}
