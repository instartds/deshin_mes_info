package foren.unilite.modules.matrl.mms;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("mms100ukrvService")
public class Mms100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	@Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;

	/**
	 * 유효기간 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object selectExpirationdate(Map param) throws Exception {
		return super.commonDao.select("mms100ukrvServiceImpl.selectExpirationdate", param);
	}
	/**
	 * 수주정보 Master 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.FORM_LOAD)
	public Object a(Map param) throws Exception {
		return super.commonDao.select("mms100ukrvServiceImpl.a", param);
	}


	/**
	 *
	 * 접수등록 ->접수조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("mms100ukrvServiceImpl.selectMaster", param);
	}



	/**
	 *
	 * 접수등록 ->접수번호검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreceiptNumMasterList(Map param) throws Exception {
		return super.commonDao.list("mms100ukrvServiceImpl.selectreceiptNumMasterList", param);
	}

	/**
	 *
	 * 접수등록->발주참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectorderList(Map param) throws Exception {
		return super.commonDao.list("mms100ukrvServiceImpl.selectorderList", param);
	}
	/**
	 *
	 * 접수등록->거래처참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCustList(Map param) throws Exception {
		return super.commonDao.list("mms100ukrvServiceImpl.selectCustList", param);
	}
	/**
	 *
	 * 접수등록->거래처참조디테일
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCustDetailList(Map param) throws Exception {
		return super.commonDao.list("mms100ukrvServiceImpl.selectCustDetailList", param);
	}

	/**
	 *
	 * print
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printList(Map param) throws Exception {
		return super.commonDao.list("mms100ukrvServiceImpl.printList", param);
	}

	/**
	 *
	 * 접수등록->무역참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectcommerceList(Map param) throws Exception {
		return super.commonDao.list("mms100ukrvServiceImpl.selectcommerceList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  inspecQtyCheck(Map param) throws Exception {

		return  super.commonDao.list("mms100ukrvServiceImpl.inspecQtyCheck", param);
	}

	/**
	 *
	 * 접수등록->vmi(거래처납품참조)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectvmiList(Map param) throws Exception {
		return super.commonDao.list("mms100ukrvServiceImpl.selectvmiList", param);
	}

	/**
	 *
	 * userID에 따른 납품창고
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {

		return  super.commonDao.select("mms100ukrvServiceImpl.userWhcode", param);
	}

	/**
	 * 접수등록(통합) 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.접수등록 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		String saveFlag = null;
		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			
			double receiptQ = 0;
			double norReceiptQ = 0;
			double freeReceiptQ = 0;
			
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				if(ObjUtils.parseDouble(param.get("RECEIPT_Q")) ==0){
					throw new  UniDirectValidateException("접수량을 확인해 주십시오.");
				}
				norReceiptQ = ObjUtils.parseDouble(param.get("NOR_RECEIPT_Q"));
				freeReceiptQ = ObjUtils.parseDouble(param.get("FREE_RECEIPT_Q"));
				
				receiptQ = norReceiptQ + freeReceiptQ;
				
				if(oprFlag.equals("N") || oprFlag.equals("U") ){
					saveFlag = (String) param.get("SAVE_FLAG");
					if(ObjUtils.isEmpty(saveFlag)){
						saveFlag = "N";
					}
					if(saveFlag.equals("Y")){
						param.put("KEY_VALUE", keyValue);
						param.put("OPR_FLAG", oprFlag);
						param.put("RECEIPT_Q", receiptQ);
						param.put("data", super.commonDao.insert("mms100ukrvServiceImpl.insertLogMaster", param));
					}
				}else{
					param.put("KEY_VALUE", keyValue);
					param.put("OPR_FLAG", oprFlag);
					param.put("RECEIPT_Q", receiptQ);
					param.put("data", super.commonDao.insert("mms100ukrvServiceImpl.insertLogMaster", param));
				}

			}
		}

		//4.접수등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("mms100ukrvServiceImpl.spImportReceipt", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

		//접수등록 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("RECEIPT_NUM", "");
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		   // throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {

			/***** 자동입고 로직 시작 공통코드 M510 값에 따라 자동입고 등록  *****/
			int autoInputChk = 0;
			List<Map> autoInputList = new ArrayList<Map>();//자동입고 양품리스트(외주가 아닌 것)
			List<Map> autoInputOutList = new ArrayList<Map>();//자동입고 리스트(외주)
			List<Map> autoInputBeforeDeleteList = new ArrayList<Map>();//자동입고전 삭제리스트(외주가 아닌 것)
			List<Map> autoInputBeforeDeleteOutList = new ArrayList<Map>();//자동입고전 삭제리스트(외주)

			String autoInputKeyValue = "";
			String autoOutKeyValue = "";

			int k = 0;
			int l = 0;
			
			int iSeq = 0;			

			Map<String, Object> insertSpParam = new HashMap<String, Object>();
			String ErrorDesc = "";
			String createLoc = "2";
			String sInoutNum = "";
			
			Map<String, Object> autoInputParam = new HashMap<String, Object>();//자동입고 관련 파라미터
			
			autoInputParam.put("COMP_CODE", user.getCompCode());

			//자동입고 사용 여부 가져오기
			autoInputChk = (int) super.commonDao.select("mms100ukrvServiceImpl.autoInputCheck", autoInputParam);
			//자동입고 사용시
			if(autoInputChk > 0){
				List<Map> dataList2 = new ArrayList<Map>();
				int i = 0;
				int j = 0;	


				autoInputKeyValue = getLogKey(); //자동입고전 삭제key value(외주가 아닌 것)
				autoOutKeyValue 	= getLogKey(); //자동입고전 삭제key value(외주인 것)
				
				for(Map paramData: paramList) {
					dataList2 = (List<Map>) paramData.get("data");
					String oprFlag2 = "N";
					if(paramData.get("method").equals("insertDetail"))	oprFlag2="N";
					if(paramData.get("method").equals("updateDetail"))	oprFlag2="U";
					if(paramData.get("method").equals("deleteDetail"))	oprFlag2="D";
							//데이터가 신규이거나 수정일때만 자동입고 함
							if(oprFlag2.equals("N") || oprFlag2.equals("U")){	
								

								
								for(Map detailParam:  dataList2) {
										autoInputParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
										autoInputParam.put("RECEIPT_NUM", ObjUtils.getSafeString(spParam.get("RECEIPT_NUM")));//접수번호
										autoInputParam.put("RECEIPT_SEQ", ObjUtils.getSafeString(detailParam.get("RECEIPT_SEQ")));//접수순번
										autoInputParam.put("USER_ID", user.getUserID());	
										autoInputParam.put("INOUT_NUM", ObjUtils.getSafeString(detailParam.get("INOUT_NUM")));
										sInoutNum = ObjUtils.getSafeString(detailParam.get("INOUT_NUM"));
										
										if(oprFlag2.equals("U")){
											
											Map chkSeqMax = (Map) super.commonDao.select("mms100ukrvServiceImpl.selectSeqMax", autoInputParam);
											iSeq = ObjUtils.parseInt(chkSeqMax.get("INOUT_SEQ"));			
										
										}										

										//1.자동입고전 삭제(외주가 아닌 것)
										//1-1발주유형이 외주가 아닌 건에대하여 기존에 수불내역이 있으면 삭제
											autoInputBeforeDeleteList = super.commonDao.list("mms100ukrvServiceImpl.selectAutoInputBeforeDeletetList", autoInputParam);
											if(autoInputBeforeDeleteList.size() > 0){

												for(Map param:  autoInputBeforeDeleteList) {				
													k = k +1;
													param.put("KEY_VALUE", autoInputKeyValue);
													param.put("OPR_FLAG", "D");
													param.put("S_USER_ID", user.getUserID());													
													
													createLoc = (String) param.get("CREATE_LOC");
													
													super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);													
                                                    
												}
												
											}

											//2.자동입고전 삭제(외주)
											//2-1발주유형이 외주인 건 수불내역의 삭제할 건 조회
											autoInputBeforeDeleteOutList = super.commonDao.list("mms100ukrvServiceImpl.selectAutoInputBeforeDeletetOutList", autoInputParam);
											if(autoInputBeforeDeleteOutList.size() > 0){

												for(Map param:  autoInputBeforeDeleteOutList) {				
													l = l +1;
													param.put("KEY_VALUE", autoOutKeyValue);
													param.put("OPR_FLAG", "D");
													param.put("S_USER_ID", user.getUserID());
													
													createLoc = (String) param.get("CREATE_LOC");
													
													super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);

												}

											}

											//3.자동입고 (외주가 아닌 것)
											autoInputList = 	super.commonDao.list("mms100ukrvServiceImpl.selectAutoInputList", autoInputParam);
											if(autoInputList.size() > 0){
												 for(Map param:  autoInputList) {
													 i = i + 1;
													 k = k +1;
													 iSeq = iSeq + 1;
													param.put("KEY_VALUE", autoInputKeyValue);
													param.put("OPR_FLAG", "N");
													param.put("S_USER_ID", user.getUserID());													
													
													if(oprFlag2.equals("U")){
														param.put("INOUT_SEQ", iSeq);
														param.put("INOUT_NUM", sInoutNum);
													}else{
														param.put("INOUT_SEQ",i);
													}														

													if( param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && !param.get("INOUT_TYPE_DETAIL").equals("20")&& param.get("PRICE_YN").equals("Y")){
														if(ObjUtils.parseDouble(param.get("ORDER_UNIT_FOR_P"))<= 0){
						//									throw new  UniDirectValidateException("입고유형이 금액보정이 아닐때  구매단가가 0 이거나 0보다 작을 수 없습니다.");
															throw new  UniDirectValidateException(this.getMessage("800004",user));
														}else{
															 super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
														}
													}else{
															 super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
													}
													
												}

											}

											//4.자동입고 (외주)
											autoInputOutList = 	super.commonDao.list("mms100ukrvServiceImpl.selectAutoInputOutList", autoInputParam);
											if(autoInputOutList.size() > 0){//자동입고 key value(외주)
												for(Map param:  autoInputOutList) {
													j = j+1;
													l = l +1;
													iSeq = iSeq + 1;
													param.put("KEY_VALUE", autoOutKeyValue);
													param.put("OPR_FLAG", "N");
													param.put("S_USER_ID", user.getUserID());

													
													if(oprFlag2.equals("U")){
														param.put("INOUT_SEQ",iSeq);
														param.put("INOUT_NUM", sInoutNum);
													}else{
														param.put("INOUT_SEQ",j);
													}
													
													if( param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && param.get("PRICE_YN").equals("Y")){
														if(ObjUtils.parseInt(param.get("ORDER_UNIT_FOR_P"))<= 0){
						//									throw new  UniDirectValidateException("입고유형이 금액보정이 아닐때  구매단가가 0 이거나 0보다 작을 수 없습니다");
															throw new  UniDirectValidateException(this.getMessage("800004",user));
														}else{
															super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
														}
													}else{
															super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
													}													
													
												}

											}
								}//데이터 상태(N,U,D)에 따른 for문 끝
						 }
					}//그리드 데이터 전체에 대한 for문 끝

			}

			if(k > 0){
				//저장된 log데이터 저장프로시저 돌려서 입고 처리(외주 아닌 것)
				insertSpParam.put("KeyValue", autoInputKeyValue);
				insertSpParam.put("LangCode", user.getLanguage());
				insertSpParam.put("CreateType", createLoc);

				super.commonDao.queryForObject("mms510ukrvServiceImpl.spReceiving", insertSpParam);
				ErrorDesc = ObjUtils.getSafeString(insertSpParam.get("ErrorDesc"));
				if(!ObjUtils.isEmpty(ErrorDesc)){
				    throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
				}
			}
			if(l > 0){
				//저장된 log데이터 저장프로시저 돌려서 입고 처리(외주 인 것)
				insertSpParam.put("KeyValue", autoOutKeyValue);
				insertSpParam.put("LangCode", user.getLanguage());
				insertSpParam.put("CreateType", createLoc);

				super.commonDao.queryForObject("otr120ukrvServiceImpl.spOtr120ukrv", insertSpParam);
				ErrorDesc = ObjUtils.getSafeString(insertSpParam.get("ErrorDesc"));
				if(!ObjUtils.isEmpty(ErrorDesc)){
				    throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
				}
			}
			/*****자동입고 로직 종료*****/
			//마스터에 SET
			dataMaster.put("RECEIPT_NUM", ObjUtils.getSafeString(spParam.get("RECEIPT_NUM")));
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("RECEIPT_NUM", ObjUtils.getSafeString(spParam.get("RECEIPT_NUM")));
					}
				}
			}
		}

		tlabBadgeService.reload();
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	/**
	 * 입고량이 있는지 점검
	 * 检查数量
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  inOutQtyCheck(Map param) throws Exception {
		return  super.commonDao.list("mms100ukrvServiceImpl.inOutQtyCheck", param);
	}

	/**
	 * 첨부파일 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("mms100ukrvServiceImpl.getFileList", param);
	}
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertQMS101(Map param, LoginVO login) throws Exception {
			logger.debug("param:::"+param);
			logger.debug("param::::"+ ObjUtils.getSafeString(param.get("ADD_FIDS")));
			fileMnagerService.confirmFile(login, ObjUtils.getSafeString(param.get("ADD_FIDS")));
			String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");

			 for(String fid : fids)	{
				 param.put("FID", fid);
				 super.commonDao.insert("mms100ukrvServiceImpl.insertQMS101", param);
			 }
	}
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteQMS101(Map param, LoginVO login) throws Exception {
			fileMnagerService.deleteFile(login, ObjUtils.getSafeString(param.get("DEL_FIDS")));
			String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
			 for(String fid : fids)	{
				 param.put("FID", fid);
				 super.commonDao.update("mms100ukrvServiceImpl.deleteQMS101", param);
			 }
	}

	/**
	 * 시험의뢰서_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("mms100ukrvServiceImpl.mainReport", param);
	}

	/**
	 * 시험의뢰서_서브리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("mms100ukrvServiceImpl.subReport", param);
	}

	/**
	 *
	 * 라벨분할출력쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectLabelPrintList(Map param) throws Exception {
		return  super.commonDao.list("mms100ukrvServiceImpl.selectLabelPrintList", param);
	}

	/**
	 *
	 * 라벨분할출력_리포트 쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  partitionPrintList(Map param) throws Exception {
		return  super.commonDao.list("mms100ukrvServiceImpl.partitionPrintList", param);
	}
}
