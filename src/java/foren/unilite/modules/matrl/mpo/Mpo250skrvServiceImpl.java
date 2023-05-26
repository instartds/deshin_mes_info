package foren.unilite.modules.matrl.mpo;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;

@Service("mpo250skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Mpo250skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	/**
	 *  GETDATE 주차
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public Map getThisWeek(Map param) throws Exception{
		return (Map) super.commonDao.select("mpo250skrvServiceImpl.getThisWeek", param);
	}
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getOrderWeek(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("mpo250skrvServiceImpl.getOrderWeek", param);

	}
	/**
	 * 마스터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map> selectMasterList(Map param) throws Exception{
		return super.commonDao.list("mpo250skrvServiceImpl.selectMasterList", param);
	}

	/**
	 * 디테일 조회1
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map> selectDetailList1(Map param) throws Exception{
		return super.commonDao.list("mpo250skrvServiceImpl.selectDetailList1", param);
	}
	/**
	 * 디테일 조회2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map> selectDetailList2(Map param) throws Exception{
		return super.commonDao.list("mpo250skrvServiceImpl.selectDetailList2", param);
	}
}
