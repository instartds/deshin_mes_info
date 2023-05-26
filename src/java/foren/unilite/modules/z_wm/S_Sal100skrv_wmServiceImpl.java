package foren.unilite.modules.z_wm;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("s_sal100skrv_wmService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_Sal100skrv_wmServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 판매현황 조회(WM)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_sal100skrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 초기화 시, 사용자의 창고정보 가져오는 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("s_sal100skrv_wmServiceImpl.userWhcode", param);
	}
}