package foren.unilite.modules.prodt.pmr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmr820ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" }) // 노란줄 경고 무시
public class Pmr820ukrvServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("pmr820ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt") // 엑셀 업로드 조회
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("pmr820ukrvServiceImpl.selectExcelUploadSheet1", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) // Propagation.REQUIRED : 별도의 트랜잭션이 설정되어 있지 않으면 새로 생성하고 실행한다. 이미 트랜잭션이 설정되어 있다면 기존의 트랜잭션 내에서 로직을 실행한다. , rollbackFor={Exception.class} : 모든 예외에 대해서 전부 트랜잭션을 롤백
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}

			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt") // 마스터 그리드 업데이트
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("pmr820ukrvServiceImpl.updateDetail", param);
		}
		return;
	}
}