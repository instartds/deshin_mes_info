package foren.unilite.modules.human.hpa;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hpa980rkrService")
public class Hpa980rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";

	/**
	 * 입금의뢰서,지출결의서 마감 여부 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {

		param.put("COMP_CODE", user.getCompCode());
        return super.commonDao.list("hpa980rkrServiceImpl.selectClosedChk", param);
    }




}
