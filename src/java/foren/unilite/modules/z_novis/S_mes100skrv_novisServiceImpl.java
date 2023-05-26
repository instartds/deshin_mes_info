package foren.unilite.modules.z_novis;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_mes100skrv_novisService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_mes100skrv_novisServiceImpl extends TlabAbstractServiceImpl{

private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 노비스바이오 대쉬보드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList() throws Exception{
		return super.commonDao.list("s_mes100skrv_novisServiceImpl.selectList");
		
//		logger.debug("Service Called Successfully!");
//		
//		Random r = new Random();
//		
//		Map<String, Object> chartData = new HashMap<String, Object>();
//		chartData.put("Chart1", r.nextInt(100));
//		chartData.put("Chart2", r.nextInt(100));
//		
//		List<Map> list = new ArrayList<Map>();
//		list.add(chartData);
//		
//		return list;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> qtyList() throws Exception{
		return super.commonDao.list("s_mes100skrv_novisServiceImpl.qtyList");
	}
	
	/**
	 * 노비스바이오 대쉬보드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectProductionCnt() throws Exception{
		return super.commonDao.list("s_mes100skrv_novisServiceImpl.selectProductionCnt");
	}
	
	/**
	 * 노비스바이오 대쉬보드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectProductionCnt2(Map param) throws Exception{
		return super.commonDao.list("s_mes100skrv_novisServiceImpl.selectProductionCnt2", param);
	}
	
	/**
	 * 노비스바이오 대쉬보드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectPagenation(Map param) throws Exception{
		return super.commonDao.list("s_mes100skrv_novisServiceImpl.selectPagenation", param);
	}
	
	/**
	 * 노비스바이오 대쉬보드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectCboItemInfo(Map param) throws Exception{
		return super.commonDao.list("s_mes100skrv_novisServiceImpl.selectCboItemInfo", param);
	}
	
	/**
	 * 노비스바이오 대쉬보드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectPageData(Map param) throws Exception{
		return super.commonDao.list("s_mes100skrv_novisServiceImpl.selectPageData", param);
	}
	
	/**
	 * 노비스바이오 대쉬보드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY)
	public int mergeItem(Map param) throws Exception{
		return super.commonDao.insert("s_mes100skrv_novisServiceImpl.mergeItem", param);
	}
}
