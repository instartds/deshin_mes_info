package foren.unilite.modules.sales.sea;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sea100skrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Sea100skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 견적현황조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectMaster(Map param, LoginVO user) throws Exception {
		List<Map> masterList = super.commonDao.list("sea100skrvServiceImpl.selectMaster", param);
		List<Map> detailList;
		if(masterList.size() > 0) {
			for(Map masterParam: masterList) {
				masterParam.put("S_COMP_CODE", user.getCompCode());
				detailList = super.commonDao.list("sea100skrvServiceImpl.selectDetail", masterParam);
				if(detailList.size() > 0) {
					for(Map detailParam: detailList) {
						if(detailParam.get("BASE_AMT") != null) {
							masterParam.put("BASE_AMT"			, detailParam.get("SUM_BASE_AMT"));
							masterParam.put("BASE_SOURCE_COST"	, ((BigDecimal)masterParam.get("BASE_AMT")).subtract((BigDecimal)ObjUtils.nvlObj(masterParam.get("BASE_PROD_COST"), new BigDecimal(0))));
						}
						if(detailParam.get("SPEC_AMT") != null) {
							masterParam.put("SPEC_AMT"			, detailParam.get("SUM_SPEC_AMT"));
							masterParam.put("SPEC_SOURCE_COST"	, ((BigDecimal)masterParam.get("SPEC_AMT")).subtract((BigDecimal)ObjUtils.nvlObj(masterParam.get("SPEC_PROD_COST"), new BigDecimal(0))));
						}
					}
				}
			}
		}
		return masterList;
	}

	/**
	 * 견적현황 임가공비 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea100skrvServiceImpl.selectDetail", param);
	}

}