package foren.unilite.modules.z_rmgmt;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("z_rmgmtService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_rmgmtServiceImpl extends TlabAbstractServiceImpl{

	/**
	 * 공통코드 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>>selectCommInfo(Map param) throws Exception {
		return super.commonDao.list("z_rmgmtService.selectCommInfo", param);
	}
	
	/**
	 * 장비(믹서) 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>>selectEquInfo(Map param) throws Exception {
		return super.commonDao.list("z_rmgmtService.selectEquInfo", param);
	}
	
	/**
	 * 제조이력 조회 페이지 header 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>>selectHeaderInfo(Map param) throws Exception {
		return super.commonDao.list("z_rmgmtService.selectHeaderInfo", param);
	}
	
	/**
	 * 제조이력 조회 페이지 Aside 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>>selectAsideInfo(Map param) throws Exception {
		return super.commonDao.list("z_rmgmtService.selectAsideInfo", param);
	}
	
	/**
	 * 제조이력 조회 페이지 body 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object>selectBodyInfo(Map param, String sLoc) throws Exception {
		
	    //List<Map<String, Object>> mChk = super.commonDao.list("z_rmgmtService.selectChkRmgAnMaxDate",param);
		
		/*
		int iCnt = Integer.parseInt(ObjUtils.getSafeString(mChk.get(0).get("CNT")));
		String sMaxInsDt = ObjUtils.getSafeString(mChk.get(0).get("INSERT_DB_TIME"));
		
		param.put("CHK_DATA_CNT", iCnt);
		param.put("MAX_INSERT_DB_TIME", sMaxInsDt);
		*/
		Map<String, Object> mRtn = new HashMap<String, Object>();
		List<Map<String, Object>> lBodySeq = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> lBodyTop = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> lBodyTb = new ArrayList<Map<String,Object>>();	
		
		// 바코드로 스캔 시
		if("barcode".equals(sLoc)) {
			lBodySeq = super.commonDao.list("z_rmgmtService.selectBodySeq", param); 		//공정차수 조회
			lBodyTop = super.commonDao.list("z_rmgmtService.selectBodyTopInfo", param);   //공정차수별 설비 Setting 정보 조회
			lBodyTb = super.commonDao.list("z_rmgmtService.selectBodyTbInfo", param);
			
		// 빠른 검색 팝업으로 조회 시	
		}else if("popup".equals(sLoc)) {
			lBodySeq = super.commonDao.list("z_rmgmtService.selectBodySeq2", param); 		//공정차수 조회
			lBodyTop = super.commonDao.list("z_rmgmtService.selectBodyTopInfo2", param);   //공정차수별 설비 Setting 정보 조회
			lBodyTb = super.commonDao.list("z_rmgmtService.selectBodyTbInfo2", param);
		} 
		
		// 차수 존재시
		if(lBodySeq.size() > 0) {
			
			Map<String, Object> mSeqTopData = new HashMap<String, Object>();
			
			//공정 차수로 반복을 돌린다.
			for (Map<String, Object> mSeq : lBodySeq) {
				// 현재 공정 차수
				String sSeq = mSeq.get("WKORD_NUM_SEQ").toString();
				
				// 현재 공정 차수의 설비셋팅 정보 담을 list
				List<Map<String, Object>> lSeqBodyTop = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> mBodyTop : lBodyTop) {
					String sBodyTopSeq = mBodyTop.get("WKORD_NUM_SEQ").toString();
					
					if(sSeq.equals(sBodyTopSeq)) {
						lSeqBodyTop.add(mBodyTop);
					}
				}
				mSeqTopData.put(sSeq, lSeqBodyTop);
			}
			
			mRtn.put("bodyTop", mSeqTopData);
		}
		
		mRtn.put("bodyTb", lBodyTb);
		
		return mRtn;
	}
	
	/**
	 *  제조이력 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectProdHistory(Map param) throws Exception{
		
		return super.commonDao.list("z_rmgmtService.selectProdHistory", param);
	}
	
	/**
	 *  공정차수 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectWkordNum(Map param) throws Exception{
		
		return super.commonDao.list("z_rmgmtService.selectWkordNum", param);
	}
	
	/**
	 *  제조이력 중 해당 공정 원료조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectChildHistory(Map param) throws Exception{
		
		return super.commonDao.list("z_rmgmtService.selectChildHistory", param);
	}
	
	/**
	 * 내용물 변경 이력 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public List<Map> selectRmgmtHistDetail(Map param) throws Exception {
		return super.commonDao.list("z_rmgmtService.selectRmgmtHistDetail", param);
	}
	
	/**
	 * 제조이력 전제 저장
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	public void insRmgmt(Map param, LoginVO user) throws Exception {
		
		ObjectMapper mapper = new ObjectMapper(); 
		String jRmg = param.get("RMG").toString();
		String jRmgDetail = param.get("RMG_DETAIL").toString();
		String jRmgSeq = param.get("RMG_SEQ").toString();
		
		Map<String, String> mRmg = mapper.readValue(jRmg, Map.class);
		mRmg.put("S_COMP_CODE", user.getCompCode());
		mRmg.put("S_USER_ID", user.getUserID());
		super.commonDao.insert("z_rmgmtService.mergeRmg100t", mRmg);
		
		List<Map> lRmgDetail = Arrays.asList(mapper.readValue(jRmgDetail, Map[].class));
		
		// rmg110t 상세 내역 저장
		if(lRmgDetail.size() > 0) {
			super.commonDao.update("z_rmgmtService.delRmg110t", mRmg);
		}
		for (Map map : lRmgDetail) {
			map.put("S_COMP_CODE", user.getCompCode());
			map.put("S_USER_ID", user.getUserID());
			map.put("DIV_CODE", mRmg.get("DIV_CODE"));
			map.put("WKORD_NUM", mRmg.get("WKORD_NUM"));
			map.put("PROG_WORK_CODE", mRmg.get("PROG_WORK_CODE"));
			
			super.commonDao.insert("z_rmgmtService.insRmg110t", map);
		}
		// rmg110t 상세 내역 저장 End
		
		// rmg120t 공정 차수별 정보 저장.
		List<Map> lRmgSeq = Arrays.asList(mapper.readValue(jRmgSeq, Map[].class));
		if(lRmgSeq.size() > 0) {
			super.commonDao.update("z_rmgmtService.delRmg120t", mRmg);
		}
		for (Map map : lRmgSeq) {
			map.put("S_COMP_CODE", user.getCompCode());
			map.put("S_USER_ID", user.getUserID());
			map.put("DIV_CODE", mRmg.get("DIV_CODE"));
			map.put("WKORD_NUM", mRmg.get("WKORD_NUM"));
			map.put("PROG_WORK_CODE", mRmg.get("PROG_WORK_CODE"));
			
			super.commonDao.update("z_rmgmtService.insRmg120t", map);
		}
		// rmg120t 공정 차수별 정보 저장 End
	}
	
	
}
