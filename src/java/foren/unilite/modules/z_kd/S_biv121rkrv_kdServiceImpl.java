package foren.unilite.modules.z_kd;

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

@Service("s_biv121rkrv_kdService")
public class S_biv121rkrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * print
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> printList(Map param) throws Exception {
		return (List) super.commonDao.list("s_biv121rkrv_kdServiceImpl.printList", param);
	}
	
	@Transactional(readOnly = true)
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
    public List<Map<String, Object>> printList1(Map param) throws Exception {
        return (List) super.commonDao.list("s_biv121rkrv_kdServiceImpl.printList1", param);
    }
	
	@Transactional(readOnly = true)
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
    public List<Map<String, Object>> printList2(Map param) throws Exception {
        return (List) super.commonDao.list("s_biv121rkrv_kdServiceImpl.printList2", param);
    }

}
