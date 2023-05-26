package foren.unilite.modules.base.bpr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("bpr201ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Bpr201ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 품목표준공수 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr201ukrvServiceImpl.selectList", param);
	}
	
	
	
	
	
	/**
	 * 품목표준공수 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
//			List<Map> insertList = null;
//			List<Map> updateList = null;
//			List<Map> deleteList = null;
		
			for(Map dataListMap: paramList) {
				for(Map param: (List<Map>)dataListMap.get("data")) {
					if("N".equals(param.get("QUERY_FLAG"))) {
						this.insertList(param, user);
						
					} else if("U".equals(param.get("QUERY_FLAG"))) {
						this.updateList(param, user);
						
					} else {
						this.deleteList(param, user);
					}
				}
//				if(dataListMap.get("method").equals("deleteList")) {
//					deleteList = (List<Map>)dataListMap.get("data");
//				
//				} else if(dataListMap.get("method").equals("insertList")) {
//					insertList = (List<Map>)dataListMap.get("data");}
//				
//				else if(dataListMap.get("method").equals("updateList")) {
//					updateList = (List<Map>)dataListMap.get("data");
//				} 
			}			
//			if(deleteList != null) this.deleteList(deleteList, user);
//			if(insertList != null) this.insertList(insertList, user);
//			if(updateList != null) this.updateList(updateList, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	
	/**
	 * 품목표준공수 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer insertList(Map param,  LoginVO user) throws Exception {
		String errMsg = "";		
		try {
//			for(Map param :paramList )	{
//				신규 등록 전, 기 등록된 데이터와 적용 시작일 비교
				String checkData = (String) super.commonDao.select("bpr201ukrvServiceImpl.checkData", param);
				
				if (checkData.equals("N")) {
					super.commonDao.insert("bpr201ukrvServiceImpl.insertList", param);
					
				} else {
					errMsg = "(등록된 데이터 보다 적용 시작일이 빠른 데이터는 등록할 수 없습니다.)";
					throw new  UniDirectValidateException("");
				}
//			}
			 
		} catch(Exception e){
			throw new  UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		return 0;
	}

	
	/**
	 * 품목표준공수 수정 (update)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateList(Map param, LoginVO user) throws Exception {
//		for(Map param :paramList )	{
			super.commonDao.update("bpr201ukrvServiceImpl.updateList", param);
//		}
		return 0;
	} 

	
	/**
	 * 품목표준공수 삭제 (delete)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer deleteList(Map param,  LoginVO user) throws Exception {
//		 for(Map param :paramList )	{
			try {
				super.commonDao.delete("bpr201ukrvServiceImpl.deleteList", param);
				 
			} catch(Exception e)	{
					throw new  UniDirectValidateException(this.getMessage("547",user));
			}	
//		 }
		 return 0;
	}
}
