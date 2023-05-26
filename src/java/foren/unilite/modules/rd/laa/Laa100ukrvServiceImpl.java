package foren.unilite.modules.rd.laa;

import java.util.ArrayList;
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


@Service("laa100ukrvService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class Laa100ukrvServiceImpl  extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/** 성분정보 조회
	 */
	@ExtDirectMethod(group = "laa", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("laa100ukrvServiceImpl.selectList", param);
	}



	/** 성분정보 입력 (saveAll)
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "laa" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		if (paramList != null) {
			for (Map param : paramList) {
				dataList = (List<Map>)param.get("data");
				
				if (param.get("method").equals("insertMulti")) {
					param.put("data", insertMulti(dataList, user));
				} else if (param.get("method").equals("updateMulti")) {
					param.put("data", updateMulti(dataList, user));
				} else if (param.get("method").equals("deleteMulti")) {
					param.put("data", deleteMulti(dataList, user));
				}
			}
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "laa" )
	public List<Map> insertMulti( List<Map> paramList, LoginVO user ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.insert("laa100ukrvServiceImpl.insertMulti", param);
		}		
		return paramList;
	}
	
	/**성분정보 수정
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "laa" )
	public List<Map> updateMulti( List<Map> paramList, LoginVO user ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("laa100ukrvServiceImpl.updateMulti", param);
		}
		return paramList;
	}

	/** 성분정보 삭제
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "laa" )
	public List<Map> deleteMulti( List<Map> paramList, LoginVO user ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.delete("laa100ukrvServiceImpl.deleteMulti", param);
		}
		return paramList;
	}
}
