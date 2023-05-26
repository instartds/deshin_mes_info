package foren.unilite.modules.z_kd;

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
import foren.unilite.com.service.impl.TlabMenuService;


@Service("s_pda010rkrv_kdService")
public class S_pda010rkrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	
	/**
	 *  Location조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
    public List<Map<String, Object>> selectList1(Map param) throws Exception {
        return super.commonDao.list("s_pda010rkrv_kdService.selectList1", param);
    }

    /**
     *  금형조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
    public List<Map<String, Object>> selectList2(Map param) throws Exception {
        return super.commonDao.list("s_pda010rkrv_kdService.selectList2", param);
    }

    /**
     *  품목Lot조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
    public List<Map<String, Object>> selectList3(Map param) throws Exception {
        return super.commonDao.list("s_pda010rkrv_kdService.selectList3", param);
    }
}
