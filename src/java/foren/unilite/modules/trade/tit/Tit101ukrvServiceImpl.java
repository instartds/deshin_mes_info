package foren.unilite.modules.trade.tit;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service( "tit101ukrvService" )
public class Tit101ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger           logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "salesCommonService" )
    private SalesCommonServiceImpl SalesUtil;
    @Resource( name = "fileMnagerService" )
    private FileMnagerService      fileMnagerService;
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "trade" )
    public List<Map<String, Object>> selectReffMaster( Map param ) throws Exception {
        return super.commonDao.list("tit101ukrvServiceImpl.selectReffMaster", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "trade" )
    public List<Map<String, Object>> selectMasterList( Map param ) throws Exception {
        return super.commonDao.list("tit101ukrvServiceImpl.selectMasterList", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "trade" )
    public List<Map<String, Object>> selectDetailList( Map param ) throws Exception {
        return super.commonDao.list("tit101ukrvServiceImpl.selectDetailList", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "trade" )
    public Object prevList( Map param ) throws Exception {
        param.put("PASS_SER_NO", param.get("PASS_SER_NO") == "" || param.get("PASS_SER_NO") == null ? "ZZZZZZZZZZZZZZ" : param.get("PASS_SER_NO"));
        return super.commonDao.select("tit101ukrvServiceImpl.prevList", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "trade" )
    public Object nextList( Map param ) throws Exception {
        param.put("PASS_SER_NO", param.get("PASS_SER_NO") == "" || param.get("PASS_SER_NO") == null ? "ZZZZZZZZZZZZZZ" : param.get("PASS_SER_NO"));
        return super.commonDao.select("tit101ukrvServiceImpl.nextList", param);
    }
    
    //선적참조 detail 참조..
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "trade" )
    public List<Map<String, Object>> selectShippingList( Map param ) throws Exception {
        return super.commonDao.list("tit101ukrvServiceImpl.selectShippingList", param);
    }    
    
    /**
     * 수입통관정보 저장
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "trade")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        //logger.debug("[saveAll] paramMaster:" + paramMaster);
        //logger.debug("[saveAll] paramDetail:" + paramList);

        
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();          

        //2.선적마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

        dataMaster.put("KEY_VALUE", keyValue);
        dataMaster.put("COMP_CODE", user.getCompCode());

        if (ObjUtils.isEmpty(dataMaster.get("PASS_SER_NO") )) {
            dataMaster.put("OPR_FLAG", "N");
        } else {
            dataMaster.put("OPR_FLAG", "U");
        }

        super.commonDao.insert("tit101ukrvServiceImpl.insertLogMaster", dataMaster);
        
        //3.선적디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if(paramList != null)   {
        	List<Map> updateList = null;
        	
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");
    
                if(param.get("method").equals("insertDetail")) {
                    param.put("data", insertLogDetails(dataList, keyValue, "N") );  
                } else if(param.get("method").equals("updateDetail")) {
                    param.put("data", insertLogDetails(dataList, keyValue, "U") );  
                //    updateList = (List<Map>)param.get("data");
                } else if(param.get("method").equals("deleteDetail")) {
                    param.put("data", insertLogDetails(dataList, keyValue, "D") );  
                }
            }
        //    if(updateList != null) this.updateDetail(updateList, user, dataMaster);
        }

        //4.선적저장 Stored Procedure 실행
        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("KeyValue", keyValue);
        spParam.put("LangCode", user.getLanguage());
        
        List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("tit101ukrvServiceImpl.USP_TRADE_TIT101UKR2", spParam);
        String errorDesc = "";
        String passSerNo = "";
        
        if(ObjUtils.isNotEmpty(returnData)){
            errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
            passSerNo = ObjUtils.getSafeString(returnData.get(0).get("PASS_SER_NO"));
        }
        
        if(errorDesc != null && !errorDesc.isEmpty()){
            dataMaster.put("PASS_SER_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        } else {
            //선적번호 마스터에 SET
            dataMaster.put("PASS_SER_NO", passSerNo);
            //선적번호 그리드에 SET
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");    
                if(param.get("method").equals("insertDetail")) {
                    List<Map> datas = (List<Map>)param.get("data");
                    for(Map data: datas){
                        data.put("PASS_SER_NO", passSerNo);
                    }
                }
            }
        }
        /*
        super.commonDao.queryForObject("tit101ukrvServiceImpl.USP_TRADE_TIT101UKR", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

        if(errorDesc != null && !errorDesc.isEmpty()){
            dataMaster.put("PASS_SER_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        } else {
            //선적번호 마스터에 SET
            dataMaster.put("PASS_SER_NO", ObjUtils.getSafeString(spParam.get("PassSerNo")));
            //선적번호 그리드에 SET
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");    
                if(param.get("method").equals("insertDetail")) {
                    List<Map> datas = (List<Map>)param.get("data");
                    for(Map data: datas){
                        data.put("PASS_SER_NO", ObjUtils.getSafeString(spParam.get("PassSerNo")));
                    }
                }
            }
        }
        */
        
        //5.선적마스터 정보 + 선적디테일 정보 결과셋 리턴
        //마스터정보가 없을 경우에도 작성
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    /**
     * 수입통관Master  입력
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> insertMaster(List<Map> params, LoginVO user) throws Exception {
        
        return params;
    }
    
    /**
     * 수입통관Master  수정
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> updateMaster(List<Map> params, LoginVO user) throws Exception {
        return params;
    }
    
    /**
     * 수입통관Master  삭제
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public void deleteMaster(List<Map> params, LoginVO user) throws Exception {
    
    }
    
    /**
     * 수입통관Detail  입력
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
        
        return params;
    }
    
    /**
     * 수입통관Detail  수정
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public Integer updateDetail(List<Map> params, LoginVO user, Map<String, Object> mapData) throws Exception {
    	int i = 0 ;
		logger.debug("[mapData]" + mapData);
		 for(Map param :params )	{
			if(i == 0 &&  param.get("SAVE_FLAG").equals("Y")){
				param.put("EP_DATE", mapData.get("EP_DATE"));
				param.put("EP_NO", mapData.get("EP_NO"));
				param.put("ED_DATE", mapData.get("ED_DATE"));
				param.put("ED_NO", mapData.get("ED_NO"));
				param.put("REPORTOR", mapData.get("REPORTOR"));
				param.put("VESSEL_NATION_CODE", mapData.get("VESSEL_NATION_CODE"));
				param.put("VESSEL_NM", mapData.get("VESSEL_NM"));
				param.put("DEVICE_NO", mapData.get("DEVICE_NO"));
				param.put("DEVICE_PLACE", mapData.get("DEVICE_PLACE"));
				param.put("INSPECT_TYPE", mapData.get("INSPECT_TYPE"));
				param.put("EXAM_TXT", mapData.get("EXAM_TXT"));
				param.put("PACKING_TYPE", mapData.get("PACKING_TYPE"));
				param.put("TOT_PACKING_COUNT", mapData.get("TOT_PACKING_COUNT"));
				param.put("GROSS_WEIGHT", mapData.get("GROSS_WEIGHT"));
				param.put("WEIGHT_UNIT", mapData.get("WEIGHT_UNIT"));
				super.commonDao.update("tit101ukrvServiceImpl.updateDetail", param);
			}
		 }
		 return 0;
    }
    
    /**
     * 수입통관Detail  삭제
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
    
    }
    
    /**
     * 수입통관Detail 로그정보 저장
     */
    public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
        for(Map param: params)      {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", oprFlag);
            
            super.commonDao.insert("tit101ukrvServiceImpl.insertLogDetail", param);
        }       

        return params;
    }
    
}
