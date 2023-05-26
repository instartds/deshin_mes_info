package foren.unilite.modules.z_yp;

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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_bpr300ukrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_bpr300ukrv_ypServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private  TlabCodeService tlabCodeService ;
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 사업장별 품목정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		
		String findType = ObjUtils.getSafeString(param.get("QRY_TYPE"));
		if(!"".equals(findType))	{
			Map searchType = (Map) super.commonDao.select("s_bpr300ukrv_ypServiceImpl.selectSearchType", param); 
			if(!ObjUtils.isEmpty(searchType)) param.put("QRY_TYPE", searchType.get("REF_CODE1"));
		}
		return  super.commonDao.list("s_bpr300ukrv_ypServiceImpl.selectList", param);
	}


	
	
	
	/**
	 * 사업장별 품목정보 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
		
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				
				} else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");}
				
				else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	
	/**
	 * 사업장별 품목정보 입력
	 */
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)
	public Integer insertDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{
			if(param.get("ITEM_CODE").equals("자동채번")){
				//대분류 정보가 없을 때는 ITEM_CODE = "60" + 순번(4자리)
				String firstChar = "60";
				if (ObjUtils.isNotEmpty(param.get("ITEM_LEVEL1"))) {
					//대분류 정보가 있을 때는 ITEM_CODE = 대분류코드(2자리) + 순번(4자리)
					firstChar = ObjUtils.getSafeString(param.get("ITEM_LEVEL1")).substring(0, 2);
				}
				param.put("FIRST_CHAR", firstChar);
				String itemCode = (String) super.commonDao.select("s_bpr300ukrv_ypServiceImpl.getItemCode", param);
				
				//신규 채번된 ITEM_CODE param에 입력
				param.put("ITEM_CODE", itemCode);
			}
			super.commonDao.delete("s_bpr300ukrv_ypServiceImpl.insert", param);
		}
		return 0;
	}

	
	/**
	 * 사업장별 품목정보 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		 for(Map param :paramList )	{	
			 if(!param.get("ITEM_ACCOUNT_ORG").toString().equals(param.get("ITEM_ACCOUNT").toString())){
				 logger.debug(param.get("ITEM_ACCOUNT_ORG") + "===============ITEM_ACCOUNT different=========" + param.get("ITEM_ACCOUNT"));
				 List chkExnum = (List) super.commonDao.list("s_bpr300ukrv_ypServiceImpl.checkExnum", param);
				 if(chkExnum.size() > 0)	{
					 throw new UniDirectValidateException(this.getMessage("54736", user)); //  '해당품목의 결의전표정보가 존재합니다. 품목계정정보를 변경할 수 없습니다.
				 }
			 }

//				 Map chkItemMap = (Map) super.commonDao.select("s_bpr300ukrv_ypServiceImpl.checkItemCode", param);
//				 if(ObjUtils.parseInt(chkItemMap.get("CNT")) > 0)	{
				 super.commonDao.insert("s_bpr300ukrv_ypServiceImpl.update", param);
//				 }else {
//					 super.commonDao.update("s_bpr300ukrv_ypServiceImpl.insert", param);
//				 }
				
		 }
		 return 0;
	} 

	
	/**
	 * 사업장별 품목정보 삭제
	 */
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		try {
			for(Map param :paramList )	{
				param.put("COMP_CODE", user.getCompCode());
				super.commonDao.delete("s_bpr300ukrv_ypServiceImpl.delete", param);
				super.commonDao.delete("s_bpr300ukrv_ypServiceImpl.delete2", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("547", user));
		}
		return 0;
	}
	
}
