package foren.unilite.modules.prodt.pms;

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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.common.SynergyTalkServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("pms430ukrvService")
public class Pms430ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	@Resource(name="synergyTalkService")
	private SynergyTalkServiceImpl synergyTalkService;

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public String sendMsg(Map param, LoginVO user) throws Exception {
		String rtnV = "";

		String keyValue = getLogKey();
		param.put("S_PGM_ID", "pms430ukrv");

		Map<String, Object> badDataParam = (Map<String, Object>) super.commonDao.select("pms430ukrvServiceImpl.selectBadData", param);
		if(ObjUtils.isEmpty(badDataParam)){
			rtnV = "N";
		}else{
			param.putAll(badDataParam);

			String msgText = "";

			msgText = synergyTalkService.syTalkMessageMake(param, keyValue, user);

			synergyTalkService.synergyTalkSendTest(keyValue);

			rtnV = "Y";
		}
		return rtnV;
	}


	/**
	 * 수주정보 Master 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("pms430ukrvServiceImpl.selectMaster", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("pms430ukrvServiceImpl.selectDetail", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCheckItem(Map param) throws Exception {
		return super.commonDao.list("pms430ukrvServiceImpl.selectCheckItem", param);
	}

	/**
	 *
	 * 수주정보검색 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("pms430ukrvServiceImpl.selectOrderNumMaster", param);
	}

	/**
	 *
	 * 접수참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("pms430ukrvServiceImpl.selectEstiList", param);
	}

	/**
	 * 검사등록(통합) 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        logger.debug("[saveAll] paramDetail:" + paramList);

        //1.로그테이블에서 사용할 KeyValue 생성
        String keyValue = getLogKey();

        //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();

        for(Map paramData: paramList) {

            dataList = (List<Map>) paramData.get("data");
            String oprFlag = "N";
            if(paramData.get("method").equals("insertDetail"))  oprFlag="N";
            if(paramData.get("method").equals("updateDetail"))  oprFlag="U";
            if(paramData.get("method").equals("deleteDetail"))  oprFlag="D";

            for(Map param:  dataList) {
                param.put("KEY_VALUE", keyValue);
                param.put("OPR_FLAG", oprFlag);
                param.put("data", super.commonDao.insert("pms430ukrvServiceImpl.insertLogMaster", param));
            }
        }

        //4.매출저장 Stored Procedure 실행
        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("KeyValue", keyValue);
        spParam.put("LangCode", user.getLanguage());

        super.commonDao.queryForObject("pms430ukrvServiceImpl.spReceiving", spParam);

        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

        //출하지시 마스터 출하지시 번호 update
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

        if(!ObjUtils.isEmpty(errorDesc)){
            dataMaster.put("INSPEC_NUM", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        } else {
            dataMaster.put("INSPEC_NUM", ObjUtils.getSafeString(spParam.get("INSPEC_NUM")));
        }

      paramList.add(0, paramMaster);
      return  paramList;
     }

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
    public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        return 0;
    }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
    public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {

        return 0;
    }


    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
    public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {

        return 0;
    }

    /**
     * 불량내역등록(통합) 저장
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
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
        List<List<Map>> resultList = new ArrayList<List<Map>>();

        for(Map paramData: paramList) {

            dataList = (List<Map>) paramData.get("data");
            String oprFlag = "N";
            if(paramData.get("method").equals("insertDetail2"))  oprFlag="N";
            if(paramData.get("method").equals("updateDetail2"))  oprFlag="U";
            if(paramData.get("method").equals("deleteDetail2"))  oprFlag="D";

            for(Map param:  dataList) {
                param.put("KEY_VALUE", keyValue);
                param.put("OPR_FLAG", oprFlag);
                param.put("data", super.commonDao.insert("pms430ukrvServiceImpl.insertLogMaster2", param));
            }
        }

        //4.매출저장 Stored Procedure 실행
        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("KeyValue", keyValue);
        spParam.put("LangCode", user.getLanguage());

        super.commonDao.queryForObject("pms430ukrvServiceImpl.spReceiving", spParam);

        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

        //출하지시 마스터 출하지시 번호 update
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

        if(!ObjUtils.isEmpty(errorDesc)){
            dataMaster.put("INSPEC_NUM", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        } else {
            dataMaster.put("INSPEC_NUM", ObjUtils.getSafeString(spParam.get("INSPEC_NUM")));
        }

      paramList.add(0, paramMaster);
      return  paramList;
     }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
    public Integer insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        return 0;
    }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
    public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {

        return 0;
    }


    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
    public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {

        return 0;
    }
}
