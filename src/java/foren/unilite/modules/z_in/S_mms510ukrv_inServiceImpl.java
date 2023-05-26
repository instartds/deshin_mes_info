package foren.unilite.modules.z_in;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.Doc;
import javax.print.DocFlavor;
import javax.print.DocPrintJob;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.SimpleDoc;
import javax.print.attribute.PrintServiceAttribute;
import javax.print.attribute.standard.PrinterName;

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

@Service("s_mms510ukrv_inService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_mms510ukrv_inServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 입고등록(SP+통합)-> 입고내역 조회 
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {

		return super.commonDao.list("s_mms510ukrv_inServiceImpl.selectList", param);
	}
	/**
	 * 입고등록(SP+통합)-> 입고내역  DETAIL 조회 
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_inServiceImpl.selectList2", param);
	}
	
	/**
	 * 입고등록(SP+통합)-> 입고번호 검색
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectinoutNoMasterList(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_inServiceImpl.selectinoutNoMasterList", param);
	}

	/**
	 * 입고등록(SP+통합)-> 미입고참조
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectnoReceiveList(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_inServiceImpl.selectnoReceiveList", param);
	}
	
	/**
	 * 입고등록(SP+통합)-> 반품가능발주참조
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreturnPossibleList(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_inServiceImpl.selectreturnPossibleList", param);
	}
	
	/**
	 * 입고등록(SP+통합)-> 업체출고 참조(SCM)
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectScmRefList(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_inServiceImpl.selectScmRefList", param);
	}

	/**
	 * 입고등록(SP+통합)-> 접수결과참조
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectinspectResultList(Map param) throws Exception {
		List<Map<String, Object>> resultList = null;
		if(ObjUtils.getSafeString(param.get("WINDOW_FLAG")).equals("inspectResult")){	// 검사결과
			resultList = super.commonDao.list("s_mms510ukrv_inServiceImpl.selectinspectResultList1", param);
		}else{ // 무검사
			resultList = super.commonDao.list("s_mms510ukrv_inServiceImpl.selectinspectResultList2", param);
		}
		return resultList;
	}
	
	/**
	 * 단가 조회
	 */
	@Transactional(readOnly=true)
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnOrderPrice(Map param) throws Exception {	
		return  super.commonDao.select("s_mms510ukrv_inServiceImpl.fnOrderPrice", param);
	}
	
	/**
	 * userID에 따른 납품창고 
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("s_mms510ukrv_inServiceImpl.userWhcode", param);
	}
	
	/**
	 * 공급가액,부가세,합계금액관련
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object fnGetCalcTaxAmt(Map param) throws Exception {	
		return  super.commonDao.select("s_mms510ukrv_inServiceImpl.fnGetCalcTaxAmt", param);
	}
	
	/**
	 * 과세구분
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  taxType(Map param) throws Exception {	
		return  super.commonDao.select("s_mms510ukrv_inServiceImpl.taxType", param);
	}
	
	/**
	 * 입고등록(SP+통합)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @param CreateType 
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
		String autoLotNo = "N";
		int inoutSeq = ObjUtils.parseInt(dataMaster.get("MAX_SEQ"));
		if(inoutSeq == 0) {
			inoutSeq = 1;
		}
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
		for(Map paramData: paramList) {			
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				Double roofcount;
				
				if(!param.get("ORDER_UNIT").equals(param.get("STOCK_UNIT"))) {
					roofcount = ObjUtils.parseDouble(param.get("ORDER_UNIT_Q"));
					param.put("ORDER_UNIT_Q", 1);
					param.put("ORDER_UNIT_I", ObjUtils.parseDouble(param.get("ORDER_UNIT_I"))	/ roofcount);
					param.put("INOUT_Q"		, ObjUtils.parseDouble(param.get("INOUT_Q"))		/ roofcount);
					param.put("INOUT_I"		, ObjUtils.parseDouble(param.get("INOUT_I"))		/ roofcount);
					param.put("INOUT_FOR_O"	, ObjUtils.parseDouble(param.get("INOUT_FOR_O"))	/ roofcount);
					
					if(param.get("LOT_ASSIGNED_YN") == null){
						param.put("LOT_ASSIGNED_YN",'Y');
					}
					
					//lot_no 존재 확인
					if(ObjUtils.isEmpty(param.get("LOT_NO"))){
						autoLotNo = "Y";
					}
					
					if(oprFlag.equals("N")  && param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && param.get("PRICE_YN").equals("Y")){
						if(ObjUtils.parseDouble(param.get("ORDER_UNIT_FOR_P"))<= 0){
//							throw new  UniDirectValidateException("입고유형이 금액보정이 아닐때  구매단가가 0 이거나 0보다 작을 수 없습니다");
							throw new  UniDirectValidateException(this.getMessage("800004",user));
						}else{
							for(int i=0; i<roofcount; i++) {
								if(autoLotNo == "Y") {
									String newLotNo = (String) super.commonDao.select("s_mms510ukrv_inServiceImpl.fnGetLotNo", param);
									param.put("LOT_NO", newLotNo);
								}
								param.put("INOUT_SEQ", inoutSeq);
								
								param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.insertLogDetail", param));
								inoutSeq++;
							}
						}
					} else {
						if("N".equals(oprFlag) || "D".equals(oprFlag)){
							for(int i=0; i<roofcount; i++) {
								if(autoLotNo == "Y") {
									String newLotNo = (String) super.commonDao.select("s_mms510ukrv_inServiceImpl.fnGetLotNo", param);
									param.put("LOT_NO", newLotNo);
								}
								param.put("INOUT_SEQ", inoutSeq);
								
								param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.insertLogDetail", param));
								inoutSeq++;
							}
						}else{
							for(int i=0; i<roofcount; i++) {
								param.put("INOUT_SEQ", inoutSeq);
								
								param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.updateLogDetail", param));
								inoutSeq++;
							}
						}
					}
					
				} else {
					Double oderUnitQ	= ObjUtils.parseDouble(param.get("ORDER_UNIT_Q"));
					Double packQty		= ObjUtils.parseDouble(param.get("PACK_QTY"));
					Double orderUnitI	= ObjUtils.parseDouble(param.get("ORDER_UNIT_I"));
					Double inoutQ		= ObjUtils.parseDouble(param.get("INOUT_Q"));
					Double inoutI		= ObjUtils.parseDouble(param.get("INOUT_I"));
					Double inoutForO	= ObjUtils.parseDouble(param.get("INOUT_FOR_O"));
					roofcount			= ObjUtils.parseDouble(param.get("ORDER_UNIT_Q")) / ObjUtils.parseDouble(param.get("PACK_QTY"));
					
					for(int j = 0; j < roofcount; j++) {
						param.put("ORDER_UNIT_Q", packQty);
						param.put("ORDER_UNIT_I", orderUnitI	* packQty / oderUnitQ);
						param.put("INOUT_Q"		, inoutQ		* packQty / oderUnitQ);
						param.put("INOUT_I"		, inoutI		* packQty / oderUnitQ);
						param.put("INOUT_FOR_O"	, inoutForO		* packQty / oderUnitQ);
						
						if(j == Math.ceil(roofcount) - 1) {
							param.put("ORDER_UNIT_Q", oderUnitQ - (j * packQty));
							param.put("ORDER_UNIT_I", orderUnitI	- (j * orderUnitI	* packQty / oderUnitQ));
							param.put("INOUT_Q"		, inoutQ		- (j * inoutQ		* packQty / oderUnitQ));
							param.put("INOUT_I"		, inoutI		- (j * inoutI		* packQty / oderUnitQ));
							param.put("INOUT_FOR_O"	, inoutForO		- (j * inoutForO	* packQty / oderUnitQ));
						}
						
						if(param.get("LOT_ASSIGNED_YN") == null){
							param.put("LOT_ASSIGNED_YN",'Y');
						}
						
						//lot_no 존재 확인
						if(ObjUtils.isEmpty(param.get("LOT_NO"))){
							autoLotNo = "Y";
						}
						
						if(oprFlag.equals("N")  && param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && param.get("PRICE_YN").equals("Y")){
							if(ObjUtils.parseDouble(param.get("ORDER_UNIT_FOR_P"))<= 0){
//								throw new  UniDirectValidateException("입고유형이 금액보정이 아닐때  구매단가가 0 이거나 0보다 작을 수 없습니다");
								throw new  UniDirectValidateException(this.getMessage("800004",user));
							}else{
								if(autoLotNo == "Y") {
									String newLotNo = (String) super.commonDao.select("s_mms510ukrv_inServiceImpl.fnGetLotNo", param);
									param.put("LOT_NO", newLotNo);
								}
								param.put("INOUT_SEQ", inoutSeq);
								
								param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.insertLogDetail", param));
								inoutSeq++;
							}
						} else {
							if("N".equals(oprFlag) || "D".equals(oprFlag)){
								if(autoLotNo == "Y") {
									String newLotNo = (String) super.commonDao.select("s_mms510ukrv_inServiceImpl.fnGetLotNo", param);
									param.put("LOT_NO", newLotNo);
								}
								param.put("INOUT_SEQ", inoutSeq);
								
								param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.insertLogDetail", param));
								inoutSeq++;
							}else{
								param.put("INOUT_SEQ", inoutSeq);
								
								param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.updateLogDetail", param));
								inoutSeq++;
							}
						}
					}
				}
			}
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue"	, keyValue);
		spParam.put("LangCode"	, user.getLanguage());
		spParam.put("CreateType", dataMaster.get("CREATE_LOC"));

	    super.commonDao.queryForObject("s_mms510ukrv_inServiceImpl.spReceiving", spParam);
		
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(ErrorDesc)){
//			dataMaster.put("INOUT_NUM", "");
			String[] messsage = ErrorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
		    logger.debug("[INOUT_NUM 뭐냐뭐냐뭐냐뭐냐" + ObjUtils.getSafeString(spParam.get("InOutNum")));
			//마스터에 SET
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			//그리드에 SET
			for(Map param: paramList)  {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
					}
				}
			}		
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	
	/**
	 * 입고등록(SP+통합)-> detail 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @param CreateType 
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		
		for(Map paramData: paramList) {			
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				
				if(param.get("LOT_ASSIGNED_YN") == null){
					param.put("LOT_ASSIGNED_YN",'Y');
				}
				
				if(oprFlag.equals("N")  && param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && param.get("PRICE_YN").equals("Y")){
					if(ObjUtils.parseInt(param.get("ORDER_UNIT_FOR_P"))<= 0){
//						throw new  UniDirectValidateException("입고유형이 금액보정이 아닐때  구매단가가 0 이거나 0보다 작을 수 없습니다");
						throw new  UniDirectValidateException(this.getMessage("800004",user));
					}else{
						param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.insertLogDetail", param));
					}
				} else {
					if("N".equals(oprFlag) || "D".equals(oprFlag)){
						param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.insertLogDetail", param));
					}else{
						param.put("data", super.commonDao.insert("s_mms510ukrv_inServiceImpl.updateLogDetail", param));
					}
				}
			}
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("CreateType", dataMaster.get("CREATE_LOC"));

	    super.commonDao.queryForObject("s_mms510ukrv_inServiceImpl.spReceiving", spParam);
		
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(ErrorDesc)){
//			dataMaster.put("INOUT_NUM", "");
			String[] messsage = ErrorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
		    logger.debug("[INOUT_NUM 뭐냐뭐냐뭐냐뭐냐" + ObjUtils.getSafeString(spParam.get("InOutNum")));
			//마스터에 SET
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			//그리드에 SET
			for(Map param: paramList)  {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
					}
				}
			}		
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 입고 Detail 입력
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			Map<String, Object> checkSerNo =  (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkSerNo", param);
			if(!ObjUtils.isEmpty(checkSerNo))	{
				Map<String, Object> autoSerNo =  (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.autoSerNo", param);
				param.put("SER_NO", ObjUtils.getSafeString(autoSerNo.get("SER_NO")));
			}
			beforeSaveDetail(param, user, "insert");
			super.commonDao.insert("s_mms510ukrv_inServiceImpl.insertDetail", param);
		}		

		return params;
	}
	
	/**
	 * 입고 Detail 수정
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			beforeSaveDetail(param, user, "update");
			super.commonDao.insert("s_mms510ukrv_inServiceImpl.updateDetail", param);
		}		
		return params;
	}
	
	/**
	 *입고 Detail 삭제
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map<String, Object> param : params)	{
			/*수주승인단계 - 체크*/
			checkStatus( param,  user);
			/*수주 진행정보 체크*/
			checkProgress(param, "Detail", user);
			/*견적확정정보 조회 & 견적정보 Update*/
			checkEstimate(param, user);
			/*SCM연계정보 조회 체크*/
			String oScmYn = this.getScm(param);
			if("Y".equals(oScmYn))	{
				checkScm(param, user);
			}		
			super.commonDao.delete("s_mms510ukrv_inServiceImpl.deleteDetail", param);
		}
		super.commonDao.delete("s_mms510ukrv_inServiceImpl.checkDeleteAllDetail", params.get(0)); 
	}
	
	/**
	 * 디테일 데이타 저장(Insert,Update) 전 확인
	 */
	private void beforeSaveDetail(Map param, LoginVO user, String saveMode) throws Exception	{
		if("Y".equals(ObjUtils.getSafeString(param.get("gsDraftFlag"))))	{
			Map<String, Object> itemInfo = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.itemInfo", param);
			if(!ObjUtils.isEmpty(itemInfo))	{
				throw new  UniDirectValidateException(this.getMessage("54445", user));	/* 54445:존재하지 않는 품목입니다. 품목정보를 확인하세요(영업공통) */
			}else {
				if("N".equals(itemInfo.get("USE_YN")))	{
					throw new  UniDirectValidateException(this.getMessage("54444", user));	 /* 54444:사용불가 품목입니다.품목정보의 사용유무를 확인하세요.(영업공통) */
				}
			}
		}
		//데이타 비교
		if("update".equals(saveMode)) {
			checkCompare(param, user);
		}
		//견적 확인
		if(!ObjUtils.isEmpty(param.get("ESTI_NUM")))	{
			checkEstimateDetail(param, user, saveMode);
		}
		//SCM 연계 확인
		String oScmYn = this.getScm(param);
		if("Y".equals(oScmYn))	{
			checkScm(param, user);
		}		
	}

	private void checkCompare(Map<String, Object> param, LoginVO user) throws Exception {
		Map<String, Object> checkDetailData = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkDetailData", param);
		int sCase=0;
		
		if(!ObjUtils.isEmpty(checkDetailData))	{
			double saleQ =  ObjUtils.parseDouble(checkDetailData.get("SALE_Q"));
			String orderStatus =  ObjUtils.getSafeString(checkDetailData.get("ORDER_STATUS"));
			String accountYnc =  ObjUtils.getSafeString(checkDetailData.get("ACCOUNT_YNC"));
			String priceYn =  ObjUtils.getSafeString(checkDetailData.get("PRICE_YN"));
			double orderP =  ObjUtils.parseDouble(checkDetailData.get("ORDER_P"));			
			String itemCode =  ObjUtils.getSafeString(checkDetailData.get("ITEM_CODE"));
			double orderQ =  ObjUtils.parseDouble(checkDetailData.get("ORDER_Q"));
			String dvryDate =  ObjUtils.getSafeString(checkDetailData.get("DVRY_DATE"));
			String taxType =  ObjUtils.getSafeString(checkDetailData.get("TAX_TYPE"));
			String orderUnit =  ObjUtils.getSafeString(checkDetailData.get("ORDER_UNIT"));
			String saleCustCd =  ObjUtils.getSafeString(checkDetailData.get("SALE_CUST_CD"));
			String dvryCustCd =  ObjUtils.getSafeString(checkDetailData.get("DVRY_CUST_CD"));
			String outDivCode =  ObjUtils.getSafeString(checkDetailData.get("OUT_DIV_CODE"));			
			double transRate =  ObjUtils.parseDouble(checkDetailData.get("TRANS_RATE"));		
			String prodEndDate =  ObjUtils.getSafeString(checkDetailData.get("PROD_END_DATE"));			
			double prodQ =  ObjUtils.parseDouble(checkDetailData.get("PROD_Q"));			
			double issueReqQ =  ObjUtils.parseDouble(checkDetailData.get("ISSUE_REQ_Q"));	
			double outStockQ =  ObjUtils.parseDouble(checkDetailData.get("OUTSTOCK_Q"));
			double returnQ =  ObjUtils.parseDouble(checkDetailData.get("RETURN_Q"));
			double reqIssueQty =  ObjUtils.parseDouble(checkDetailData.get("REQ_ISSUE_QTY"));
			String maxPubNum =  ObjUtils.getSafeString(checkDetailData.get("MAX_PUB_NUM"));		
			
			if(saleQ > 0)	{
		             if( !orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) 
			            &&
			            (!accountYnc.equals(param.get("ACCOUNT_YNC"))  || 
					    (!priceYn.equals(param.get("PRICE_YN")) && priceYn.equals("1")) ||
					    (orderP != ObjUtils.parseDouble(param.get("ORDER_P")) && priceYn.equals("1"))) 
				        &&
			            (
		                    itemCode.equals(param.get("ITEM_CODE")) &&
		                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
		                    dvryDate.equals(param.get("DVRY_DATE")) &&	
		                    taxType.equals(param.get("TAX_TYPE")) &&	
		                    orderUnit.equals(param.get("ORDER_UNIT")) &&	
		                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&	
		                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&	
		                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&	
		                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
		                    prodEndDate.equals(param.get("PROD_END_DATE")) &&	
		                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q")) 		               
			            )){
		            	 	sCase = 6;
		              }else if(
		                 	!orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) && 
		                 	itemCode.equals(param.get("ITEM_CODE")) &&
		                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
		                    orderP == ObjUtils.parseDouble(param.get("ORDER_P")) &&
		                    dvryDate.equals(param.get("DVRY_DATE")) &&
		                    priceYn.equals(param.get("PRICE_YN")) &&
		                    taxType.equals(param.get("TAX_TYPE")) &&	
		                    orderUnit.equals(param.get("ORDER_UNIT")) &&	
		                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&	
		                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&	
		                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&	
		                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
		                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
		                    accountYnc.equals(param.get("ACCOUNT_YNC")) &&
		                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))) {
		                    
		            	    sCase = 5;
		               }else if(
		                 	!orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) && 
		                 	(!itemCode.equals(param.get("ITEM_CODE")) ||
		                    orderQ != ObjUtils.parseDouble(param.get("ORDER_Q")) ||
		                    orderP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
		                    !dvryDate.equals(param.get("DVRY_DATE")) ||
		                    !priceYn.equals(param.get("PRICE_YN")) ||
		                    !taxType.equals(param.get("TAX_TYPE")) ||	
		                    !orderUnit.equals(param.get("ORDER_UNIT")) ||	
		                    !saleCustCd.equals(param.get("SALE_CUST_CD")) ||	
		                    !dvryCustCd.equals(param.get("DVRY_CUST_CD")) ||	
		                    !outDivCode.equals(param.get("OUT_DIV_CODE")) ||	
		                    transRate != ObjUtils.parseDouble(param.get("TRANS_RATE")) ||
		                    !prodEndDate.equals(param.get("PROD_END_DATE")) ||
		                    !accountYnc.equals(param.get("ACCOUNT_YNC")) ||
		                    prodQ != ObjUtils.parseDouble(param.get("PROD_Q")))){
		            	   
		            	   	sCase = 4;
		               }else if(
		            		 orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) 
			            	 &&
				             (!accountYnc.equals(param.get("ACCOUNT_YNC"))  || 
					         (!priceYn.equals(param.get("PRICE_YN")) && priceYn.equals("1") ) ||
					         (orderP != ObjUtils.parseDouble(param.get("ORDER_P")) && priceYn.equals("1"))) 
				             &&
			                 (
		                    itemCode.equals(param.get("ITEM_CODE")) &&
		                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
		                    dvryDate.equals(param.get("DVRY_DATE")) &&	
		                    taxType.equals(param.get("TAX_TYPE")) &&	
		                    orderUnit.equals(param.get("ORDER_UNIT")) &&	
		                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&	
		                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&	
		                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&	
		                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
		                    prodEndDate.equals(param.get("PROD_END_DATE")) &&	
		                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q")) 		               
			                )){
		            	   sCase = 3;
		             }else if(
		                 	orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) && 
		                 	(!itemCode.equals(param.get("ITEM_CODE")) ||
		                    orderQ != ObjUtils.parseDouble(param.get("ORDER_Q")) ||
		                    orderP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
		                    !dvryDate.equals(param.get("DVRY_DATE")) ||
		                    !priceYn.equals(param.get("PRICE_YN")) ||
		                    !taxType.equals(param.get("TAX_TYPE")) ||	
		                    !orderUnit.equals(param.get("ORDER_UNIT")) ||	
		                    !saleCustCd.equals(param.get("SALE_CUST_CD")) ||	
		                    !dvryCustCd.equals(param.get("DVRY_CUST_CD")) ||	
		                    !outDivCode.equals(param.get("OUT_DIV_CODE")) ||	
		                    transRate != ObjUtils.parseDouble(param.get("TRANS_RATE")) ||
		                    !prodEndDate.equals(param.get("PROD_END_DATE")) ||
		                    !accountYnc.equals(param.get("ACCOUNT_YNC")) ||
		                    prodQ != ObjUtils.parseDouble(param.get("PROD_Q")))){
		            	 	
		            	 	sCase = 2;
		             } else {
		            	 	sCase = 1;
		             }
			}
	
	        if("1".equals(priceYn))	{ 
	        	if(
        			orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) && 
                 	itemCode.equals(param.get("ITEM_CODE")) &&
                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
                    dvryDate.equals(param.get("DVRY_DATE")) &&
                    priceYn.equals(param.get("PRICE_YN")) &&
                    taxType.equals(param.get("TAX_TYPE")) &&	
                    orderUnit.equals(param.get("ORDER_UNIT")) &&	
                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&	
                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&	
                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&	
                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
                    accountYnc.equals(param.get("ACCOUNT_YNC")) &&
                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q")) 	){
	        		
	        		sCase = 0;
	        	}
	            
	        }
	        if(sCase != 0)	{
	        	if(!(sCase == 1 || sCase == 3 ||((sCase == 5 || sCase == 6) && orderQ > issueReqQ))){
		        	throw new  UniDirectValidateException(this.getMessage("54460", user));	 
		        }
	        }
	        
	        if(outStockQ > 0 || returnQ > 0) {
	        	if(ObjUtils.parseDouble(param.get("OUTSTOCK_Q")) < outStockQ )	{
	        		throw new  UniDirectValidateException(this.getMessage("54461", user));	
	        	}
	        	if(itemCode.equals(param.get("ITEM_CODE")))	{
	        		throw new  UniDirectValidateException(this.getMessage("54431", user));	
	        	}
	        }
	        
	        if("N".equals(orderStatus) && "Y".equals(param.get("ORDER_STATUS")))	{
	        	if((orderQ + returnQ - outStockQ) == 0 )	{
	        		throw new  UniDirectValidateException(this.getMessage("54440", user));	// 54440:해당 수주건에 대해 강제마감할 자료가 없습니다.(완납) 
	        	}
	        }
	        
	        if(sCase > 0)	{
	        	if(!(sCase == 1 || sCase == 3 || ((sCase == 5 || sCase ==6) && (reqIssueQty > 0 ))))	{
	        		Map<String, Object> checkSaleQ = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkSaleQ", param);
	        		if(!ObjUtils.isEmpty(checkSaleQ))	{
	        			throw new  UniDirectValidateException(this.getMessage("54494", user));	
	        		}
	        	}
	        }	
	        
	        if(orderP != ObjUtils.parseDouble(param.get("ORDER_P")))	{
	        	if(maxPubNum != null && !"".equals(maxPubNum))	{
	        		throw new  UniDirectValidateException(this.getMessage("54483", user));
	        	}
	        }

	        if(outStockQ > 0)	{
		        List<Map<String, Object>> checkListSSA110 = (List<Map<String, Object>>)super.commonDao.list("s_mms510ukrv_inServiceImpl.checkSSA110", param);
		        if(ObjUtils.isEmpty(checkListSSA110))	{
		        	throw new  UniDirectValidateException(this.getMessage("54400", user));
		        } else 	{
		        	
		        	for(Map<String, Object> checkSSA110 : checkListSSA110)	{
		        		int sFlg = 0;
		        		Map mapfCompute = new HashMap();
		        		double saleP = ObjUtils.parseDouble(checkSSA110.get("SALE_P"));
		        		String ssa110_priceYn = ObjUtils.getSafeString(checkSSA110.get("PRICE_YN"));
		        		if("N".equals(accountYnc) && "Y".equals(param.get("ACCOUNT_YNC")) &&  saleP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
		        		   "Y".equals(accountYnc) && "N".equals(param.get("ACCOUNT_YNC")) &&  saleP == ObjUtils.parseDouble(param.get("ORDER_P")) ||
		        		   !ssa110_priceYn.equals(param.get("PRICE_YN")) && "1".equals(ssa110_priceYn)
		        		  )	{
		        			Map ssa110Param = new HashMap();
		        			ssa110Param.put("TAX_TYPE", checkSSA110.get("TAX_TYPE"));
		        			ssa110Param.put("M_TAX_TYPE", checkDetailData.get("M_TAX_TYPE"));
		        			ssa110Param.put("WON_CALC_BAS", checkDetailData.get("WON_CALC_BAS"));
		        			ssa110Param.put("VAT_RATE", checkDetailData.get("VAT_RATE"));
		        			ssa110Param.put("TRANS_RATE", checkSSA110.get("TRANS_RATE"));
		        			ssa110Param.put("SALE_Q", checkSSA110.get("SALE_Q"));
		        			
		        			double dParam_Unit_P = 0.0;
		        			if("N".equals(param.get("ACCOUNT_YNC")))	{
		        				dParam_Unit_P = 0;
		        			}else {
		        				dParam_Unit_P = ObjUtils.parseDouble(param.get("ORDER_P"));
		        			}
		        			
		        			sFlg = 1;
		        		}else if( !ssa110_priceYn.equals(param.get("PRICE_YN")))	{
		        			sFlg = 2;
		        		}
		        		
		        		
		        		if(sFlg != 0)	{
		        			Map<String, Object> paramSRQ100 = new HashMap<String, Object>();
		        			paramSRQ100.put("S_COMP_CODE", param.get("S_COMP_CODE"));
		        			paramSRQ100.put("ACCOUNT_YNC", param.get("ACCOUNT_YNC"));
		        			paramSRQ100.put("OUT_DIV_CODE", param.get("OUT_DIV_CODE"));
		        			paramSRQ100.put("ORDER_NUM", param.get("ORDER_NUM"));
		        			paramSRQ100.put("SER_NO", param.get("SER_NO"));
		        			paramSRQ100.put("INOUT_NUM", checkSSA110.get("INOUT_NUM"));
		        			paramSRQ100.put("INOUT_SEQ", checkSSA110.get("INOUT_SEQ"));
		        			
		        			if(sFlg == 1)	{
		        				paramSRQ100.put("INOUT_FOR_P", mapfCompute.get("dParamP"));
		        				paramSRQ100.put("INOUT_FOR_O", mapfCompute.get("dParamI"));
		        				paramSRQ100.put("ORDER_UNIT_P", mapfCompute.get("dParam_Unit_P"));
		        				paramSRQ100.put("ORDER_UNIT_O", mapfCompute.get("dParam_Unit_I"));
		        				paramSRQ100.put("INOUT_TAX_AMT", mapfCompute.get("dParam_Unit_T"));
		        			}
		        			
		        			super.commonDao.update("s_mms510ukrv_inServiceImpl.updateBTR100", paramSRQ100);
		        		}
		        	}
	        			
	        	}
	        }
	        
	        if(issueReqQ > 0)	{
	        	List<Map<String, Object>> checkListSRQ100 = (List<Map<String, Object>>)super.commonDao.list("s_mms510ukrv_inServiceImpl.checkSRQ100", param);
		        
		        if(ObjUtils.isEmpty(checkListSRQ100))	{
		        	throw new  UniDirectValidateException(this.getMessage("54400", user));
		        }else {	
		        	for(Map<String, Object> checkSRQ100 : checkListSRQ100)	{
		        		int sFlg = 0;
		        		Map mapfCompute = new HashMap();


		        		if(ObjUtils.parseDouble(param.get("ORDER_P")) != ObjUtils.parseDouble(checkSRQ100.get("ORDER_P")) )	{
		        			Map ssa110Param = new HashMap();
		        			ssa110Param.put("TAX_TYPE", checkSRQ100.get("TAX_TYPE"));
		        			ssa110Param.put("M_TAX_TYPE", checkDetailData.get("M_TAX_TYPE"));
		        			ssa110Param.put("WON_CALC_BAS", checkDetailData.get("WON_CALC_BAS"));
		        			ssa110Param.put("VAT_RATE", checkDetailData.get("VAT_RATE"));
		        			ssa110Param.put("TRANS_RATE", checkSRQ100.get("TRANS_RATE"));
		        			ssa110Param.put("SALE_Q", checkSRQ100.get("ISSUE_REQ_QTY"));
		        			
		        			double dParam_Unit_P = ObjUtils.parseDouble(param.get("ORDER_P"));
		        			
		        			sFlg = 1;
		        		}else if( !priceYn.equals(ObjUtils.getSafeString(checkSRQ100.get("PRICE_YN"))))	{
		        			sFlg = 2;
		        		}else if(!accountYnc.equals(ObjUtils.getSafeString(checkSRQ100.get("ACCOUNT_YNC"))))	{
		        			sFlg = 3;
		        		}
		        		
		        		
		        		if(sFlg != 0)	{
		        			Map<String, Object> paramSRQ100 = new HashMap<String, Object>();
		        			paramSRQ100.put("S_COMP_CODE", param.get("S_COMP_CODE"));
		        			paramSRQ100.put("ACCOUNT_YNC", param.get("ACCOUNT_YNC"));
		        			paramSRQ100.put("DIV_CODE", param.get("DIV_CODE"));
		        			paramSRQ100.put("ORDER_NUM", param.get("ORDER_NUM"));
		        			paramSRQ100.put("SER_NO", param.get("SER_NO"));
		        			paramSRQ100.put("INOUT_NUM", checkSRQ100.get("INOUT_NUM"));
		        			paramSRQ100.put("INOUT_SEQ", checkSRQ100.get("INOUT_SEQ"));
		        			
		        			if(sFlg == 1)	{
		        				paramSRQ100.put("ISSUE_REQ_PRICE", mapfCompute.get("dParam_Unit_P"));
		        				paramSRQ100.put("ISSUE_REQ_AMT", mapfCompute.get("dParam_Unit_I"));
		        				paramSRQ100.put("ISSUE_REQ_TAX_AMT", mapfCompute.get("dParam_Unit_T"));
		        			}
		        			
		        			super.commonDao.update("s_mms510ukrv_inServiceImpl.updateSRQ100", paramSRQ100);
		        		}
		        	}
		        }
	        }
		}
	}
	
	/**
	 * 견적확정정보 조회 & 견적정보 Update
	 */
	private void checkEstimate(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> params = super.commonDao.list("s_mms510ukrv_inServiceImpl.checkEstimate", param);
		
		if(!ObjUtils.isEmpty(params))	{
			Map<String, Object> cfrmData = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkEstimateConfirm", params.get(0));
		
			if(!ObjUtils.isEmpty(cfrmData))	{
				if(!"2".equals(cfrmData.get("CONFIRM_FLAG")))	{
					throw new  UniDirectValidateException(this.getMessage("54458", user));	/* 54458:이미 취소되었거나 확정되지 않았습니다. */
				}
				for(Map<String, Object> estiParam : params)	{					
					super.commonDao.update("s_mms510ukrv_inServiceImpl.updateEstimateConfirm", estiParam);
				}
			}else {
				throw new  UniDirectValidateException(this.getMessage("54400", user));	/* 54400:이미 삭제된 자료입니다.(영업공통) */
			}
		}
	}
	
	/**
	 * 견적확정정보 조회 & 견적정보 Update - 수주정보 Detail 저장시 사용
	 */
	private void checkEstimateDetail(Map param, LoginVO user, String saveMode) throws Exception {
		Map<String, Object> cfrmData = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkEstiDetail", param);
		if(!ObjUtils.isEmpty(cfrmData))	{
			if(!"2".equals(cfrmData.get("CONFIRM_FLAG")))	{
				throw new  UniDirectValidateException(this.getMessage("54458", user));	/* 54458:이미 취소되었거나 확정되지 않았습니다. */
			}
			
			if("update".equals(saveMode))	param.put("SES100T_ORDER_Q", cfrmData.get("ORDER_Q"));
			else  param.put("SES100T_ORDER_Q", 0);
			
			super.commonDao.update("s_mms510ukrv_inServiceImpl.updateEstimateDetailConfirm", param);
			
		}else {
			throw new  UniDirectValidateException(this.getMessage("54400", user));	/* 54400:이미 삭제된 자료입니다.(영업공통) */
		}
	}

	/**
	 * SCM연계정보 조회 체크
	 */
	private void checkScm(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> params = super.commonDao.list("s_mms510ukrv_inServiceImpl.checkSCM", param);
		if(!ObjUtils.isEmpty(params))	{
			Map<String, Object> baseData = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkSCMDetail", param);
			
			if(!ObjUtils.isEmpty(baseData))	{
				if(ObjUtils.isEmpty(baseData.get("DB_NAME")))	{
					throw new  UniDirectValidateException(this.getMessage("68022", user));	/*  68022:B605(=SCM연계정보)의 관련3[DataBase명] 이 누락되어있습니다.*/
				}
				
				if(ObjUtils.isEmpty(baseData.get("COMP_CODE")))	{
					throw new  UniDirectValidateException(this.getMessage("68023", user));	/* 68023:B605(=SCM연계정보)의 관련4[법인코드] 가 누락되어있습니다. */
				}
				
				if(ObjUtils.isEmpty(baseData.get("DIV_CODE")))	{
					throw new  UniDirectValidateException(this.getMessage("68024", user));	/* 68024:B605(=SCM연계정보)의 관련5[사업장코드] 가 누락되어있습니다.*/
				}

				for(Map<String, Object> scmParam : params)	{	
					scmParam.putAll(baseData);
					Map<String, Object> dData = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkSCMDelete", scmParam);
					if(ObjUtils.isEmpty(dData))	{
						throw new  UniDirectValidateException(this.getMessage("54400", user));	/* 54400:이미 삭제된 자료입니다.(영업공통) */
					}else {
						String controlStatus = ObjUtils.getSafeString(dData.get("CONTROL_STATUS"));
						if("2".equals(controlStatus))	{
							throw new  UniDirectValidateException(this.getMessage("54614", user));/* 54614:입고된 발주는 수정할수 없습니다. [수정불가] */
						} else if("3".equals(controlStatus))	{
							throw new  UniDirectValidateException(this.getMessage("54483", user));/* 54483:계산서처리된 자료입니다. 확인하시기 바랍니다. */
						} else if("8".equals(controlStatus))	{
							throw new  UniDirectValidateException(this.getMessage("68025", user));/* 68025:수입참조된 자료는 수정 및 삭제가 불가능 합니다. */
						} else if("9".equals(controlStatus))	{
							throw new  UniDirectValidateException(this.getMessage("54100", user));/* 54100:이미 마감된 자료 입니다. */
						} else if("1".equals(controlStatus) || "7".equals(controlStatus))	{
							super.commonDao.update("s_mms510ukrv_inServiceImpl.updateSCM", scmParam);
						}
						
					}
				}
			}else {
				throw new  UniDirectValidateException(this.getMessage("68021", user));	/* 68021:B605(=SCM연계정보)공통코드가 등록되어 있지 않거나 관련 참조값이 누락되어있습니다. */
			}
		}
	}
	
	/**
	 * 수주등록(SCM연계) 사용여부 값 조회
	 */
	private String  getScm(Map param)  throws Exception {
		Map<String, Object> scm = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.getSCM", param);
		String r = "N";
		if(!ObjUtils.isEmpty(scm))	{
			r = ObjUtils.getSafeString(scm.get("REF_CODE1"));
		}
		return  r;
	}
	
	/**
	 * 수주승인단계 - 사용
	 */
	private void  checkStatus(Map param, LoginVO user)  throws Exception {
		Map<String, Object> obj = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkStatus", param);
		String r = "";
		if(!ObjUtils.isEmpty(obj))	{
			r = ObjUtils.getSafeString(obj.get("STATUS"));
			if(!"1".equals(r) && !"5".equals(r) )	{
				throw new  UniDirectValidateException(this.getMessage("55442", user));	/* 55442:수주승인이 진행된 건은 수정/삭제할 수 없습니다.*/
			}
		}
	}
	
	/**
	 * 수주 진행정보 체크
	 */
	private void  checkProgress(Map param, String type, LoginVO user)  throws Exception {
		Map<String, Object> obj = null;
		if("Master".equals(type))	{
			obj = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkProgressMaster", param);
		}else {
			obj = (Map<String, Object>)super.commonDao.select("s_mms510ukrv_inServiceImpl.checkProgressDetail", param);
		}
		
		if(ObjUtils.isEmpty(obj))	{
			throw new  UniDirectValidateException(this.getMessage("54400", user));	/* 54400:이미 삭제된 자료입니다.(영업공통)*/
		} else {
			if(ObjUtils.parseInt(obj.get("ISSUE_REQ_Q")) > 0)	{
				throw new  UniDirectValidateException(this.getMessage("54460", user));	/* 54460:출하지시가 진행중인 수주내역을 수정/삭제할 수 없습니다.*/
			}
			
			if(ObjUtils.parseInt(obj.get("SALE_Q")) > 0)	{
				throw new  UniDirectValidateException(this.getMessage("54412", user));	/* 54460:출고가 진행중인 수주내역은 삭제가 불가능합니다.(수주내역 삭제시)*/
			}
			
			if(ObjUtils.parseInt(obj.get("RETURN_Q")) > 0)	{
				throw new  UniDirectValidateException(this.getMessage("54446", user));	/* 54446:반품이 진행된 수주내역은 삭제할 수 없습니다.*/
			}
		}
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_jw")
    public String printAllLogic(List<Map> paramList) throws Exception {

        
        String rtnV = "";

        
        
        String ZPLString = "";
        
        String ipAdr = "";
        int port = 0;
        

        String itemCode = "";	
        
        
        String itemName = "";		//제품명		Item Name
        String spec = "";			//규격		Spec
        
        Double trnsRate = 0.0;		//입수
        String strTrnsRate ="";		//입수(string)
        String stockUnit = "";		//재고단위
        
        
        String inoutDate = "";		//입고일자		In. Date
        String endDate = "";		//유효기간		Exp. Date

        String lotNo = "";
        
        Double orderUnitQ = 0.0;
        String qtyFormat = "0";
        
        String DataMatrix = "";
        
        //0.00    "0.00"
        
/*    소켓      
        Socket clientSocket = new Socket(ipAdr,port);
        
		for(Map paramData: paramList) {	
			

			
	        itemCode = nvl(paramData.get("ITEM_CODE"));
	        itemName = nvl(paramData.get("ITEM_NAME"));
	        spec = nvl(paramData.get("SPEC"));
	        inoutDate = nvl(paramData.get("DUMMY_INOUT_DATE")).substring(0, 4) + nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6) + nvl(paramData.get("DUMMY_INOUT_DATE")).substring(6, 8);
	        endDate = nvl(paramData.get("DUMMY_END_DATE")).substring(0, 4) + nvl(paramData.get("DUMMY_END_DATE")).substring(4, 6) + nvl(paramData.get("DUMMY_END_DATE")).substring(6, 8);
	        
	        lotNo = nvl(paramData.get("LOT_NO"));
	        
	        DataMatrix = itemCode + "|" + lotNo + "|" + String.format("%."+ nvl(paramData.get("ORDER_UNIT_Q")) +"f",orderUnitQ);
	        
	        
            ZPLString += "^XA";
            ZPLString += "^SEE:UHANGUL.DAT^FS";
            ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
            ZPLString +="^PW555";		//라벨 가로 크기관련
            
            
            ZPLString +="^FO130,43^A1N,21,21^FD"+itemName+"^FS";
            
            
            
            
            
            
            DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
            byte[] dataTest = ZPLString.getBytes("EUC-KR"); 
//            byte[] dataTest = ZPLString.getBytes("UTF-8"); 
            outToServer.write(dataTest);
		}

        

        clientSocket.close();
        
        */
        
        
        PrintService psZebra = null;
        String sPrinterName = null;
        PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
        
//        PrintService services = PrintServiceLookup.lookupDefaultPrintService();
        logger.info("######  sPrinterName : {}", services);
        logger.debug("@@@@@@@@@@sPrinterName 뭐냐@@@@@@@@@@@@@ : " + services);
        
        for (int i = 0; i < services.length; i++) {
            
            PrintServiceAttribute attr = services[i].getAttribute(PrinterName.class);
            sPrinterName = ((PrinterName) attr).getValue();
            logger.info("######  sPrinterName : {}", sPrinterName);
            logger.debug("@@@@@@@@@@@@sPrinterName 뭐냐@@@@@@@@@@@@ : " + sPrinterName);
//            if (sPrinterName.equals("\\\\192.168.0.242\\zt230_1")) {
//            if (sPrinterName.equals("ZDesigner ZT230-200dpi ZPL")) {
//            if (sPrinterName.equals("zt230test")) {

//          if (sPrinterName.equals("\\\\192.168.0.186\\zt230_test1")) {
            
            if (sPrinterName.equals("ZDesigner ZT230-200dpi ZPL")) {
//            if (sPrinterName.equals("zt230_1")) {
                psZebra = services[i];
                break;
            }
        }
        
        if (psZebra == null) {
            System.out.println("@@@@@@@@@@@@@@@Zebra printer is not found.");
            return rtnV;
        }
        DocPrintJob job = psZebra.createPrintJob();

		for(Map paramData: paramList) {	
			itemCode = nvl(paramData.get("ITEM_CODE"));
	        itemName = nvl(paramData.get("ITEM_NAME"));
	        
	        
	        
	        spec = nvl(paramData.get("SPEC"));
	        
	        trnsRate = ObjUtils.parseDouble(paramData.get("TRNS_RATE"));
	        strTrnsRate = String.format("%.0f",trnsRate);;
	        stockUnit = nvl(paramData.get("STOCK_UNIT"));
	        
	        
	        inoutDate = nvl(paramData.get("DUMMY_INOUT_DATE")).substring(0, 4)+ "-" + nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6) +  "-" +nvl(paramData.get("DUMMY_INOUT_DATE")).substring(6, 8);
	        endDate = nvl(paramData.get("DUMMY_END_DATE")).substring(0, 4) +  "-" +nvl(paramData.get("DUMMY_END_DATE")).substring(4, 6) +  "-" +nvl(paramData.get("DUMMY_END_DATE")).substring(6, 8);
	        
	        lotNo = nvl(paramData.get("LOT_NO"));
	        
	        qtyFormat = ObjUtils.getSafeString(paramData.get("QTY_FORMAT"));
	        
	        orderUnitQ = ObjUtils.parseDouble(paramData.get("ORDER_UNIT_Q"));
	        
	        DataMatrix = itemCode + "|" + lotNo + "|" + String.format("%."+ nvl(paramData.get("QTY_FORMAT")) +"f",orderUnitQ);
//	        
//	        
	        
//	        ZPLString += "^XA~SD1.0^FO40,190^A0N,25,25^FD"+"2"+"^FS^XZ";
//	        
//	        ZPLString += "^XA~SD15.0^XZ";
            ZPLString += "^XA";
            ZPLString += "^SEE:UHANGUL.DAT^FS";
//            ZPLString += "^CW1,E:MALGUNBD.TTF^CI28^FS";	//맑은고딕 볼드
            ZPLString += "^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
//            ZPLString += "^CW3,E:TIMESBD.TTF^CI26^FS";	//TIMES NEW ROMAN 볼드
            ZPLString +="^PW550";		//라벨 가로 크기관련

            ZPLString +="^LH45,20^FS";

//            연한것
//            ZPLString +="^FO0,20^GFA,05760,05760,00020,:Z64:";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
//            ZPLString +="eJztlj1ywyAQhREzNFQpspfgFDqCi3Af1zmFygynjCwhWHafNNguUoRtzKDPj7f8LBgzYsSIEX8QNqVF9jmiT9mX1vgRWFzjq+0LDy7dm764xSxGVYJu5xrBXS4l3kc5pDsx8BSjGtge3KKGjfFW+/zBMYN0cMzgYY8bJNIGN6nvxuC0KxE3aHdnlht8cPmncD4LcYMuGyOWiM/fPeeIPvhv/r7k8QtHebyJJRwO/yxh2uyZxypzTjTY5/IHJhPqxBRbbAKLLV+5kqbjeovkJs7Ne6tuecu5WbYaLrem4qq2IIf17oAz51zNyF1yVc8Bf75Tb10Gpbd+11wJVDy6ufYEv63nAOdlKTLNfrnmgD/EEdALbcV6ilMl1TTnrerpGm1UieYHoIYFnAOc75zmADgC06duBrNdDoiTXRPgLOAcmD4P0iVW/o4IgJMXV7a3dHAWpOtAGh6lAVYX2SOwamg13rSnOGxPpRGBPf2O2BZXchbMsgNpIHvydXBhT22WE3toWGRPyp3YQ88rtPfQ7Mlhz+zJYXv3HrJ3cjRetffO0Xji5L56NFCh6i5AYPZQAUL1FtZRXG+lvbM6qriTuiy7JnA00LXxxPVSYy5cjSVzROoB7REH9BBHnLt1clkvIA74g1yvHvCHuNirB/ylTr0RI0b8v/gF2ku//A==:055F";
//            ZPLString +="^PQ1,0,1,Y";
            if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("01")){
            	
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("02")){
//          진한것  
	            ZPLString +="^FO0,20^GFA,05760,05760,00020,:Z64:";
	            ZPLString +="eJztljFSwzAQRS00jEpV1DoAh9BROIp8FHoOgY/ikqGidBFYSGzLq92vIMgwk2G8TZyXb+n/jbNK1+211157XUndPNOjZIHoXcroq15K5o7sULJ4ZNRzZNKJDZzZE6JJLScWnJejD87m5Yg4WxDfxKxsVNsSvaltC+ZXxswEwOLKmJkE2PHd61PRGTOv9MBN27klnpu2s8Bwg35ZiHfQLcZCqZv4K//csSBh2c+yTofFl2G6uPpnurjmTFvgtH5csIO4gS0Tt8ZkXeC6KQdadCbH9LmBBVM6l3U2t9flK8OZ0hVXA7hSOsddoXvP6CpOka4Hul7qPNDdAl13r3Vdd6d1uSxgrTorRkJN5y7QecAqul6y0M4k4s/4WZbKyVZlpJlRo/fUFsUqukkyVwzAuTxgAbQ+YjZIJk+BhfUCmQqTt1rQFgfiesACiBZBWxLQkY5rQDQLYjgQw4MYAViOgCVgmbRlAyxbwByw7AELIEYEMRKwLI/9Thxu39gbrsOeb7QXGu0RtoesICateGAFfbnICnr20HN2XT+N39pDQ+kPBpCyVxlAaN5Ke3C2JnA0gRgdiHHJ8YKOksrxstX2L02xVh1ioZFFzsZG3Q9ZukBXsLFRd4ZRo26vvfb63/UJk2m6OQ==:481B";
				ZPLString +="^PQ1,0,1,Y";
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("03")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("04")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("05")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("06")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("07")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("08")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("09")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("10")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("11")){
                
            }else if(nvl(paramData.get("DUMMY_INOUT_DATE")).substring(4, 6).equals("12")){
                
            }
//            ZPLString +="^FO15,50^GFA,03584,03584,00016,:Z64:";
//            ZPLString +="eJztVrtuwzAMtA0I0NpBe+Cpn+FP6BD9T0Z9Rkd9ZmOJ4uOsRnXaoUMYIDZxPd6RdhlN0yv+X8whmtznlDUc77FJvqz3uEi+w/EqeSrBqSu4FCh0VSBEW+A95fLR6ntY+rra8izgE8XNlI/xo+aN3gw0uBnIKWsDRZ6+G/9SXTC+VRfcPV1uZO9KMhvZv0iZYu9DX33KN30NxHOEN91Wp+nOpOPb5MkH90U33HctNPNcQi1EssVAD2f+0vib5Sfm73eCu4Iv/NzqnQP8Pn7i1zvHz73+ZYdPOSnJi5csf/4R38ubXyYx4k9voC/Bk+jjUkn3pyJbvjj5lm9yn87xw4GfAb+afAV+BNyrFdDDzQrRLxqFbIAuvgDfAY7th8H4D+3D+CPg0P6M7SXbvgMc7Qe0n9MnyBv7R3lrD+QRX4AfwB78AhzsrWAf7SU7/ZG8A/yk/BwBB3kH9jrdP5SPMJ0n5DX8hPyo++138g+f/d/La/oz8hPgKK/Tzqtn5PEfE+Vxr3TsG3ncO+O9YXGQx72C8se1edj6aF9iUqcnOkH5JOef/fcvAI58xPn0RScwxFfgR+Qr+Z2P+JAP+mf5Gfof8V9xKr4APQQ5yg==:2E97";
//            ZPLString +="^PQ1,0,1,Y";
			
//          ZPLString += "~SD1.0^FO40,190^A0N,50,50^FD"+"2"+"^FS";
//          ZPLString += "~SD15.0";
            ZPLString +="^FO0,0^GB500,370,4^FS";
            
            ZPLString +="^FO0,50^GB500,0,4^FS";
            ZPLString +="^FO0,120^GB500,0,4^FS";
            ZPLString +="^FO0,170^GB500,0,4^FS";
            ZPLString +="^FO0,220^GB500,0,4^FS";
            ZPLString +="^FO0,270^GB500,0,4^FS";
            
            ZPLString +="^FO150,50^GB0,220,4^FS";
            
            ZPLString +="^FO120,5^ATN,8,8^FD"+"Item Description"+"^FS";
            
//            ZPLString +="^FO30,100^AGSN,200,200^FD"+"2"+"^FS";
            
            
         //   ZPLString +="~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0";
            
            
            
            
            
//            ZPLString += "^CW2,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
            ZPLString +="^FO20,75^A1N,25,25^FD"+"Item Name"+"^FS";
            
//            if("ABCDEFGHIJKLMNOPQRSTUVWXYZ".length() > 22){
//	            ZPLString +="^FO180,65^A0N,25,25^FD"+"ABCDEFGHIJKLMNOPQRSTUVWXYZ".substring(0, 22)+"^FS";
//	            ZPLString +="^FO180,90^A0N,25,25^FD"+"ABCDEFGHIJKLMNOPQRSTUVWXYZ".substring(22)+"^FS";
//            }   
//            itemName = "PHIẾU XUẤT KHO KIÊM VẬN CHUYỂN ABCDEFG 12345 !@#$%";
//            itemName = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//            itemName = "가나다라마바사아자차카타파하가나다라마바사아자차카타파하";
//            itemName = "PHIẾUPHIẾUPHIẾUPHIẾUPHIẾUPHIẾU";
//            itemName = "ABCDEFGHIJKLMNOPHIẾUPHIẾUPHIẾU";
//            String itemName2 = "가나다라마바사아자차카타파하";
//            if(itemName.getBytes().length > 21){
            if(itemName.length() > 17){
	            ZPLString +="^FO180,65^A1N,25,25^FD"+itemName.substring(0, 17)+"^FS";
//	            ZPLString +="^FO180,90^A3N,25,25^FD"+"안녕 ABCDEFG"+"^FS";
	            ZPLString +="^FO180,90^A1N,25,25^FD"+itemName.substring(17)+"^FS";
            }else{
	            ZPLString +="^FO180,75^A1N,25,25^FD"+itemName+"^FS";
            }
            ZPLString +="^FO20,137^A1N,25,25^FD"+"Spec"+"^FS";
            ZPLString +="^FO180,137^A1N,25,25^FD"+spec+ "*" + strTrnsRate + stockUnit + "^FS";
            
            ZPLString +="^FO20,187^A1N,25,25^FD"+"In.Date"+"^FS";
            ZPLString +="^FO180,187^A1N,25,25^FD"+inoutDate+"^FS";
            
            ZPLString +="^FO20,237^A1N,25,25^FD"+"Exp.Date"+"^FS";
            ZPLString +="^FO180,237^A1N,25,25^FD"+endDate+"^FS";

            ZPLString +="^FO45,285^BXN,4,200^FD"+DataMatrix+"^FS";
            ZPLString +="^FO170,290^AUN,25,25^FD"+lotNo+"^FS";
            
            
//            ZPLString +="^XA";
//            ZPLString +="^LH100,100^FS";
//            ZPLString +="^FXSHIPPING LABEL^FS";
//            ZPLString +="^FO10,10^GB470,280,4^FS";
//            ZPLString +="^FO10,190^GB470,4,4^FS";
//            ZPLString +="^FO10,80^GB240,2,2^FS";
//            ZPLString +="^FO250,10^GB2,100,2^FS";
//            ZPLString +="^FO250,110^GB226,2,2^FS";
//            ZPLString +="^FO250,60^GB226,2,2^FS";
//            ZPLString +="^FO156,190^GB2,95,2^FS";
//            ZPLString +="^FO312,190^GB2,95,2^FS";
//            ZPLString +="^XZ";
            
            ZPLString +="^XZ";
		}
        byte[] by = ZPLString.getBytes("UTF-8");
        DocFlavor flavor = DocFlavor.BYTE_ARRAY.AUTOSENSE;//TEXT_HTML_UTF_8;// .AUTOSENSE;
        Doc doc = new SimpleDoc(by, flavor, null);
        job.print(doc, null);
        
        
        
        rtnV = "Y";
        
        return rtnV;
    } 
	/**
     * 라벨프린트 ip정보 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_jw")       
    public Map checkIpAddr(Map param) throws Exception {
        
        return (Map) super.commonDao.select("s_mms510ukrv_inServiceImpl.checkIpAddr", param);
        
    }
    
    public static String nvl(Object object) {
		return object == null ? "" : ObjUtils.getSafeString(object);
	}
	
}
