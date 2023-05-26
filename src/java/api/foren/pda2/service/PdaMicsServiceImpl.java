package api.foren.pda2.service;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.foren.pda2.dto.micsDto.Pds510ukrvPackDTO;
import api.foren.pda2.dto.micsDto.Pds600ukrvPackDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
 
@SuppressWarnings("unchecked")
@Service("pdaMicsService")
public class PdaMicsServiceImpl extends TlabAbstractServiceImpl {
	
	/* 바코드 데이터 조회 */
	public Map<String, Object> getBarcodeData(Map<String,Object> params, LoginVO user) throws Exception {
		
		String pgmId = (String) params.get("PGM_ID");
		
		// 유효한 바코드 인지 check
		switch(pgmId){
			// 패킹 등록
			case "pds510ukrv":
				super.commonDao.queryForObject("pdaMicsService.spCallCheckPds510ukrv", params);
				break;
			// 패킹 출고
			case "pds600ukrv":
				super.commonDao.queryForObject("pdaMicsService.spCallCheckPds600ukrv", params);
				break;
		}
		
		String ErrorDesc = ObjUtils.getSafeString(params.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
		}
		// 바코드 데이터 조회
		return (Map<String, Object>) super.commonDao.select("pdaMicsService.getBarcodeData",params);
	}
	
	/* 월별 출하지시서 조회 */
	public List<Map<String, Object>> searchListPds510ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaMicsService.searchListPds510ukrvSub1",params);
	}
	
	/* 메인 조회 */
	public List<Map<String, Object>> searchListPds510ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaMicsService.searchListPds510ukrvMain",params);
	}
	
	/* 패킹 조회  */
	public List<Map<String, Object>> searchListPds510ukrvSub2(Map<String,Object> params){
		return super.commonDao.list("pdaMicsService.searchListPds510ukrvSub2",params);
	}
	/* 제품 리스트 조회 */
	public List<Map<String, Object>> searchListPds510ukrvSub3(Map<String,Object> params){
		return super.commonDao.list("pdaMicsService.searchListPds510ukrvSub3",params);
	}
	/* 패킹번호 리스트 조회 */
	public List<Map<String, Object>> searchListPds600ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaMicsService.searchListPds600ukrvMain",params);
	}
	
	
	
	/**
	 * 제품 패킹 & 패킹삭제 & 전체삭제 & 확정
	 * @param saveDTO
	 * @param user
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePds510ukrvPack(Pds510ukrvPackDTO saveDTO, LoginVO user) throws Exception {

		Map<String, Object> params = new HashMap<>();
		String flag = "";

		// dto -> map 변환
		for(Field field :saveDTO.getClass().getDeclaredFields()){
			field.setAccessible(true);
			params.put(field.getName(), field.get(saveDTO));
			
			// flag 값 세팅
			if("flag".equals(field.getName())) flag = (String) field.get(saveDTO);
		}
		// user ID set
		params.put("S_USER_ID", user.getUserID());
		
		
		switch(flag){
			// 패킹 제품 저장
			case "I":
				super.commonDao.insert("pdaMicsService.savePds510ukrvPack", params);
				break;
			// 패킹 제품 삭제
			case "D":
				super.commonDao.delete("pdaMicsService.deletePds510ukrvPack", params);
				break;
				
			// 패킹 제품 전체삭제
			case "A":
				super.commonDao.delete("pdaMicsService.deleteAllPds510ukrvPack", params);
				break;
				
			// 패킹 제품 확정
			case "S":
				super.commonDao.queryForObject("pdaMicsService.spCallPds510ukrv", params);
				break;
		}
		
		String ErrorDesc = ObjUtils.getSafeString(params.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
		}
	}
	
	
	/**
	 * 제품 패킹 & 패킹삭제  & 확정
	 * @param saveDTO
	 * @param user
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePds600ukrvPack(Pds600ukrvPackDTO saveDTO, LoginVO user) throws Exception {

		Map<String, Object> params = new HashMap<>();
		String flag = "";

		// dto -> map 변환
		for(Field field :saveDTO.getClass().getDeclaredFields()){
			field.setAccessible(true);
			params.put(field.getName(), field.get(saveDTO));
			
			// flag 값 세팅
			if("flag".equals(field.getName())) flag = (String) field.get(saveDTO);
		}
		// user ID set
		params.put("S_USER_ID", user.getUserID());
		
		
		switch(flag){
			// 패킹 제품 저장
			case "I":
				super.commonDao.insert("pdaMicsService.savePds600ukrvPack", params);
				break;
				
			// 패킹 제품 삭제
			case "D":
				super.commonDao.delete("pdaMicsService.deletePds600ukrvPack", params);
				break;
				
			// 패킹 제품 확정
			case "S":
				// 로그테이블에서 사용할 KeyValue 생성
				String keyValue = getLogKey();
				params.put("KEY_VALUE", keyValue);
				
				super.commonDao.queryForObject("pdaMicsService.spCallPds600ukrv", params);
				break;
		}
		
		String ErrorDesc = ObjUtils.getSafeString(params.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
		}
	}

}
