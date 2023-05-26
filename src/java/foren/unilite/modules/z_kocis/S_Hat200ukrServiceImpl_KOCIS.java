package foren.unilite.modules.z_kocis;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("s_hat200ukrService_KOCIS")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Hat200ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 근무조현황 목록 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		List dutyCode = (List)super.commonDao.list("hat520skrServiceImpl.selectDutycode" ,loginVO.getCompCode());
		param.put("DUTY_CODE", dutyCode);
		List vrecord2 = (List)super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.vrecord2" ,param);
		param.put("VRECORD2", vrecord2);
		
		//날짜 첫일, 말일 계산
		String yyyymm = (String) param.get("DUTY_YYYYMM");
		int yyyy = Integer.parseInt(yyyymm.substring(0, 4));
		int mm = Integer.parseInt(yyyymm.substring(4,6));
		Calendar cal = Calendar.getInstance();
		cal.set(yyyy, mm-1, 1);		
		int lastDay = cal.getActualMaximum(cal.DATE);
		
		String sDate = yyyymm+"01";
		String eDate = yyyymm+String.valueOf(lastDay);		
		String diff = String.valueOf(Integer.parseInt(eDate)-Integer.parseInt(sDate));
		param.put("sDate", sDate);
		param.put("eDate", eDate);
		param.put("diff", diff);
		
		
		List list = (List) super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.selectList", param);
				
		return (List) super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.selectList", param);
	}
	
	/**
	 * 월근무 하단 폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList2(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.selectList2", param);
	}
	
	
	/**
	 * 월근무 등록,수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateHat200(List<Map> param, LoginVO loginVO) throws Exception {
		List<Map> dutyCode = (List)super.commonDao.list("hat520skrServiceImpl.selectDutycode" ,loginVO.getCompCode());
		
		
		Map fnHat200SetMap = new HashMap();
		fnHat200SetMap.put("DUTY_YYYYMM", param.get(0).get("DUTY_YYYYMM"));
		fnHat200SetMap.put("PAY_PROV_FLAG", param.get(0).get("PAY_PROV_FLAG"));
		fnHat200SetMap.put("S_COMP_CODE", loginVO.getCompCode());		
		List<Map> fnHat200Set = (List)super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.fnHat200Set" ,fnHat200SetMap);
		
		
		for(int x=0; x< param.size();x++){			
			List<Map> paramList = new ArrayList<Map>();
			Map map2 = new HashMap();
			
			for(int i=0; i<dutyCode.size(); i++){
				Map map = new HashMap();
				String index = (String) dutyCode.get(i).get("SUB_CODE");
				Object DUTY_NUM =  param.get(x).get("DUTY_NUM"+index);
				Object DUTY_TIME =  param.get(x).get("DUTY_TIME"+index);
				
				map.put("DUTY_CODE", index);
				map.put("DUTY_NUM", DUTY_NUM);
				map.put("DUTY_TIME", DUTY_TIME);			
				
				paramList.add(map);
			}

			map2.put("FLAG", param.get(x).get("FLAG"));
			map2.put("USER_ID", loginVO.getUserID());
			map2.put("DUTY_YYYYMM", param.get(x).get("DUTY_YYYYMM"));
			map2.put("DUTY_FROM", param.get(x).get("DUTY_FROM"));
			map2.put("DUTY_TO", param.get(x).get("DUTY_TO"));
			map2.put("DIV_CODE", param.get(x).get("DIV_CODE"));
			map2.put("DEPT_CODE", param.get(x).get("DEPT_CODE"));
			map2.put("DEPT_CODE2", param.get(x).get("DEPT_CODE2"));
			map2.put("PERSON_NUMB", param.get(x).get("PERSON_NUMB"));
			map2.put("PAY_PROV_FLAG", param.get(x).get("PAY_PROV_FLAG"));
			map2.put("REMARK", param.get(x).get("REMARK"));
			map2.put("COMP_CODE", loginVO.getCompCode());
			
			map2.put("PAY_STRT_DT", fnHat200Set.get(0).get("PAY_STRT_DT"));
			map2.put("PAY_END_DT", fnHat200Set.get(0).get("PAY_END_DT"));
			
			map2.put("paramList", paramList);
			super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.update", map2);
			System.out.println(map2.toString());

		}
		
		//sp호출 따로하기 위해 분리
		for(int x=0; x< param.size();x++){            
            List<Map> paramList = new ArrayList<Map>();
            Map map2 = new HashMap();

            map2.put("FLAG", param.get(x).get("FLAG"));
            map2.put("USER_ID", loginVO.getUserID());
            map2.put("DUTY_YYYYMM", param.get(x).get("DUTY_YYYYMM"));
            map2.put("DUTY_FROM", param.get(x).get("DUTY_FROM"));
            map2.put("DUTY_TO", param.get(x).get("DUTY_TO"));
            map2.put("DIV_CODE", param.get(x).get("DIV_CODE"));
            map2.put("DEPT_CODE", param.get(x).get("DEPT_CODE"));
            map2.put("DEPT_CODE2", param.get(x).get("DEPT_CODE2"));
            map2.put("PERSON_NUMB", param.get(x).get("PERSON_NUMB"));
            map2.put("PAY_PROV_FLAG", param.get(x).get("PAY_PROV_FLAG"));
            map2.put("REMARK", param.get(x).get("REMARK"));
            map2.put("COMP_CODE", loginVO.getCompCode());
            
            map2.put("PAY_STRT_DT", fnHat200Set.get(0).get("PAY_STRT_DT"));
            map2.put("PAY_END_DT", fnHat200Set.get(0).get("PAY_END_DT"));
            
            map2.put("paramList", paramList);
            super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.update2", map2);
		}

		return param;
	}

	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteHat200")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateHat200")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteHat200(deleteList, user);
			if(updateList != null) this.updateHat200(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 월근무 삭제
	 * @param deleteList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map> deleteHat200(List<Map> deleteList,LoginVO loginVO) throws Exception {		
		List<Map> dutyCode = (List)super.commonDao.list("hat520skrServiceImpl.selectDutycode" ,loginVO.getCompCode());
		List paramList = new ArrayList();
		
		for(int i=0; i<dutyCode.size(); i++){
			String index = (String) dutyCode.get(i).get("SUB_CODE");			
			paramList.add(index);
		}
		
		for(Map param :deleteList )	{
			if(param.get("FLAG").equals("U")){
				param.put("paramList", paramList);
				param.put("COMP_CODE",  loginVO.getCompCode());
				param.put("PERSON_NUMB",param.get("PERSON_NUMB"));
				param.put("DUTY_YYYYMM", param.get("DUTY_YYYYMM"));
				param.put("USER_ID", loginVO.getUserID());
				super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.delete", param);
//				System.out.println(paramList.toString());
				System.out.println(deleteList.toString());
			}			
		}		
		
		return deleteList;
	}
	
	/**
	 * 일수,시간 write 가능 여부 체크
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> wirteCheck(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("s_hat200ukrServiceImpl_KOCIS.wirteCheck", param);
	}	
	
}