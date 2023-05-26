package foren.unilite.modules.stock.qba;

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


@Service("qba110ukrvService")
public class Qba110ukrvServiceImpl  extends TlabAbstractServiceImpl{

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 시험항목등록 조회
	 */

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("qba110ukrvServiceImpl.selectList", param);
	}

	/**
	 * 시험항목등록 입력
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "stock" )
    public List<Map> insertMulti( List<Map> paramList, LoginVO user ) throws Exception {

        for (Map param : paramList) {
        	Map<String, String> chkUniqueCode = (Map<String, String>)super.commonDao.select("qba110ukrvServiceImpl.chkUniqueCODE", param);
        	if(ObjUtils.parseInt(chkUniqueCode.get("CNT")) >= 1){
        		throw new UniDirectValidateException("[시헝항목코드:" +ObjUtils.getSafeString(param.get("TEST_CODE")) + "]" + "\n이미 데이타가 존재합니다.");
        	}
            super.commonDao.insert("qba110ukrvServiceImpl.insertMulti", param);
        }
        return paramList;
    }

	/**
	 * 시험항목등록 수정
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "stock" )
	public List<Map> updateMulti( List<Map> paramList, LoginVO user ) throws Exception {

		for (Map param : paramList) {
			super.commonDao.update("qba110ukrvServiceImpl.updateMulti", param);
		}
		return paramList;
	}

	/**
	 * 시험항목등록 삭제
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "stock" )
	public List<Map> deleteMulti( List<Map> paramList, LoginVO user ) throws Exception {

		for (Map param : paramList) {
			super.commonDao.delete("qba110ukrvServiceImpl.deleteMulti", param);
		}
		return paramList;
	}

	/*
	 * saveAll
	 * */
    @ExtDirectMethod( group = "stock" )
    public Integer syncAll( Map param ) throws Exception {
        logger.debug("syncAll:" + param);
        return 0;
    }
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "stock" )
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
}
