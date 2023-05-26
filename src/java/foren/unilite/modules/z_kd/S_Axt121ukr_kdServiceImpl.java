package foren.unilite.modules.z_kd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

//@Service( "axt120skrService" )
//public class Axt120skrServiceImpl extends TlabAbstractServiceImpl {
//    private final Logger logger = LoggerFactory.getLogger(this.getClass());
//
//    /**
//     * 가족사항조회
//     *
//     * @param param
//     * @return
//     * @throws Exception
//     */
//    @SuppressWarnings( { "rawtypes", "unchecked" } )
//    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
//    public List<Map<String, Object>> selectList( Map param ) throws Exception {
//
//        return super.commonDao.list("axt120skrService.selectList", param);
//    }
//}


@Service( "s_axt121ukr_kdService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class S_Axt121ukr_kdServiceImpl extends TlabAbstractServiceImpl {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 거래처별  월별 지급 등록 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public List<Map<String, Object>> selectList( Map param, LoginVO loginVO ) throws Exception {
        param.put("LANG_TYPE", loginVO.getLanguage());

    	logger.debug("===========================================================");



        return super.commonDao.list("s_axt121ukr_kdService.selectList", param);
    }

    /**
    *
    * 선택한 거래처, 전표년월에 해당하는 전표 금액 값 및 지불 금액 가져오기
    * @param param
    * @return
    * @throws Exception
    */
   @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
   public List<Map<String, Object>> fnGetAmtI(Map param) throws Exception {
       return super.commonDao.list("s_axt121ukr_kdService.selectFnGetAmt", param);
   }

    /**
	 * 거래처별  월별 지급 등록 -> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[[paramMaster]] :" + paramMaster);


		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("COMP_CODE", user.getCompCode());

				//dataMaster.put("OPR_FLAG", "N");
			Map<String, Object> spParam = new HashMap<String, Object>();
			spParam.put("COMP_CODE", user.getCompCode());
			spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
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
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
	    for(Map param : paramList )   {
            logger.debug("[[paramList]]" + param);
	    	super.commonDao.update("s_axt121ukr_kdService.insertDetail", param);
        }
		return 0;
	}


	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{

                 super.commonDao.delete("s_axt121ukr_kdService.deleteDetail", param);

		 }
		 return 0;
	}


	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			   logger.debug("[[paramList]]" + param);
			   int chk =  (int) super.commonDao.select ("s_axt121ukr_kdService.selectAxt120tChK", param);
			   logger.debug("[[chk]]" + chk);
                if(chk > 0){
                	super.commonDao.update("s_axt121ukr_kdService.updateDetail", param);
                }else{
                	super.commonDao.update("s_axt121ukr_kdService.insertDetail", param);
                }

		 }
		 return 0;
	}
}

