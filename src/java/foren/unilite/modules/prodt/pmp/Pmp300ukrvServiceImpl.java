package foren.unilite.modules.prodt.pmp;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;


@Service("pmp300ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Pmp300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 메인그리드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("pmp300ukrvServiceImpl.selectList", param);
	}

	/**
	 * 메인그리드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> updateMaster(Map param) throws Exception{
		return super.commonDao.list("pmp300ukrvServiceImpl.selectList", param);
	}

	/**
	 * 메인그리드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> insertMaster(Map param) throws Exception{
		return super.commonDao.list("pmp300ukrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateMaster(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> deleteMaster(List<Map> params, LoginVO user) throws Exception {
		return null;
	}

	/**
	 * 메인그리드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> deleteMaster(Map param) throws Exception{
		return super.commonDao.list("pmp300ukrvServiceImpl.selectList", param);
	}

	/**
	 * 비가동등록(pmp300ukrv)
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();

		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertMaster"))	oprFlag="N";
			if(paramData.get("method").equals("updateMaster"))	oprFlag="U";
			if(paramData.get("method").equals("deleteMaster"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);

				if(dataMaster.get("TYPE")!=null) {
					if(dataMaster.get("TYPE").equals("A"))
					{
						//EQU600T
						//param.put("data", super.commonDao.insert("pmp300ukrvServiceImpl.insertLogDetail", param));
					}else if (dataMaster.get("TYPE").equals("B")) {
						//L_EQR200T
						//param.put("data", super.commonDao.insert("pmp300ukrvServiceImpl.insertLogDetail2", param));
					}else if (dataMaster.get("TYPE").equals("C")) {
						if(oprFlag.equals("N")){
							//비가동등록(EQU600T_INSERT)
							param.put("data", super.commonDao.insert("pmp300ukrvServiceImpl.insertMaster", param));
						}else if(oprFlag.equals("U")){
							//비가동등록(EQU600T_UPDATE)
							logger.debug("###################22222222222222222"+oprFlag.equals("N"));
							param.put("data", super.commonDao.insert("pmp300ukrvServiceImpl.updateMaster", param));
						}else if(oprFlag.equals("D")){
							//비가동등록(EQU600T_DELETE)
							logger.debug("###################22222222222222222"+oprFlag.equals("N"));
							param.put("data", super.commonDao.insert("pmp300ukrvServiceImpl.deleteMaster", param));
						}
					}
				}
			}
		}

		paramList.add(0, paramMaster);
		return  paramList;

	}

}
