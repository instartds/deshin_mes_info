package foren.unilite.modules.human.hbs;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hbs810ukrService")
public class Hbs810ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 입사구비서류 등록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return (List) super.commonDao.list("hbs810ukrServiceImpl.selectList1", param);
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return (List) super.commonDao.list("hbs810ukrServiceImpl.selectList2", param);
	}
	/**
	 *추가 또는 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public int updateHbst810t(String paramStr) throws Exception {
		
		Gson gson = new Gson();
		Hbs810ukrModel[] hbs810ukrModelArray = gson.fromJson(paramStr, Hbs810ukrModel[].class);
		int result = 0;
		for (int i = 0; i < hbs810ukrModelArray.length; i ++) {
			String chk = hbs810ukrModelArray[i].getCHK();
			logger.debug(chk);
			if (chk.equals("true")) {
				result = super.commonDao.insert("hbs810ukrServiceImpl.updateList", hbs810ukrModelArray[i]);
			}else{
				result = super.commonDao.insert("hbs810ukrServiceImpl.deleteList", hbs810ukrModelArray[i]);
		}

		}
   
		return result;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public int updateHbst810t_2(String paramStr) throws Exception {
		return 0;
	}
	
/*	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")
	public List<Map> updateHbst810t(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			logger.debug(param+"");
			if (param.get("CHK").toString().equals("true")) {
				super.commonDao.update("hbs810ukrServiceImpl.updateList", param);
			} else {
				super.commonDao.update("hbs810ukrServiceImpl.deleteList", param);
			}
			param.put("CHK", "0");
		}
		return paramList;
	}*/
	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL,group = "hbs")
	public Integer syncAll(List<Map> paramList) throws Exception {
		logger.debug("syncAll:" + paramList);
		
		return  0;
	}

}
