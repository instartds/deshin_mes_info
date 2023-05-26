package foren.unilite.modules.stock.qba;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import oracle.jdbc.proxy.annotation.GetDelegate;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("qba120ukrvService")
public class Qba120ukrvServiceImpl extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/*
	 * 분류별시험항목등록 조회
	 * */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("qba120ukrvServiceImpl.selectList", param);
	}

	
	/*
	 * 분류별시험항목등록 입력
	 * */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "stock" )
    public List<Map> insertMulti( List<Map> paramList, LoginVO user ) throws Exception {
        
        for (Map param : paramList) {        	        	
            super.commonDao.insert("qba120ukrvServiceImpl.insertMulti", param);
        }        
        return paramList;
    }
	
	/*
	 * 분류별시험항목등록 수정
	 * */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "stock" )
	public List<Map> updateMulti( List<Map> paramList, LoginVO user ) throws Exception {
		
		for (Map param : paramList) {        	           
			super.commonDao.update("qba120ukrvServiceImpl.updateMulti", param);
		}        
		return paramList;
	}
	
	/*
	 * 분류별시험항목등록 삭제
	 * */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "stock" )
	public List<Map> deleteMulti( List<Map> paramList, LoginVO user ) throws Exception {
		
		for (Map param : paramList) {        	           
			super.commonDao.delete("qba120ukrvServiceImpl.deleteMulti", param);
		}        
		return paramList;
	}
	
	/*
	 * 분류별시험항목등록 saveAll
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
	
	/**
	 * 품목 대분류
     * 20190307
     * 정일훈
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getItemLevel1(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("qba120ukrvServiceImpl.getItemLevel1", param);

	}
	
	/**
     * 시험항목
     * 20190307
     * 정일훈
     * @param param(S_COMP_CODE)
     * @return
     * @throws Eception
     * */
	public List<ComboItemModel> getTestCode(Map param) throws Exception{
		return (List<ComboItemModel>) super.commonDao.list("qba120ukrvServiceImpl.getTestCode", param);
	}
	
}
