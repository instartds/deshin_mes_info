package foren.unilite.modules.z_mit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("s_str130ukrv_mitService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class S_str130ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;



	/**
	 * 생산실적 데이터 조회(main grid)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return super.commonDao.list("s_str130ukrv_mitServiceImpl.selectList", param);
	}

	/**
	 * 바코드 리딩 / 입고된 데이터(east grid)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2 (Map param) throws Exception {
		return super.commonDao.list("s_str130ukrv_mitServiceImpl.selectList2", param);
	}


	/**
	 * 창고조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  deptWhcode(Map param) throws Exception {	
		return  super.commonDao.select("s_str130ukrv_mitServiceImpl.deptWhcode", param);
	}



	/**
	 * 바코드 입력 시 관련정보 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getBarcodeInfo (Map param) throws Exception {
		return super.commonDao.list("s_str130ukrv_mitServiceImpl.getBarcodeInfo", param);
	}








	/**
	 * 입고정보(BARCODE) 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll2] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
				
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");

			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail2"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail2"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail2"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("data", super.commonDao.insert("s_str130ukrv_mitServiceImpl.insertLogMaster", param));
			}
		}
		//입고등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_str130ukrv_mitServiceImpl.spReceiving", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
				
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			String[] messsage = errorDesc.split(";");
			if(messsage.length == 1){
				throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}else{
				throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);
			}
		} else {
			//20191126 추가: USP_SALES_S_STR130UKRV_MIT 호출하는 로직 추가
			super.commonDao.queryForObject("s_str130ukrv_mitServiceImpl.spReceiving2", spParam);

			String errorDesc2 = ObjUtils.getSafeString(spParam.get("ErrorDesc2"));

			if(!ObjUtils.isEmpty(errorDesc2)){
				dataMaster.put("INOUT_NUM", "");
				String[] messsage = errorDesc.split(";");
				if(messsage.length == 1){
					throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
				}else{
					throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);
				}
			} else {
				dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
				//수주번호 그리드에 SET
				for(Map param: paramList) {
					dataList = (List<Map>)param.get("data");	
					if(param.get("method").equals("insertDetail")) {
						List<Map> datas = (List<Map>)param.get("data");
						for(Map data: datas){
							data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
						}
					}
				}
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	/**
	 * 입고 Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail2(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	/**
	 * 입고 Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail2 (List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	/**
	 * 입고 Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail2 (List<Map> params, LoginVO user) throws Exception {
	}

	@ExtDirectMethod(group = "zmit")
	public Map<String, Object>  execWhin(Map<String, Object> param)	{
		super.commonDao.queryForObject("s_str130ukrv_mitServiceImpl.spProdtWh1350in_mit", param);
		return param;
	}
}
