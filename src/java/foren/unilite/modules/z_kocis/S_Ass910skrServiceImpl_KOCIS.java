package foren.unilite.modules.z_kocis;

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
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_ass910skrService_KOCIS")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Ass910skrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
//	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  미술품내역 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return (List) super.commonDao.list("s_ass910skrServiceImpl_KOCIS.selectList", param);
	}
	
	
	
	/**
	 * 점검내역 초기화 버튼 이벤트
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)	{
			List<Map> buttonInsertList1 = null;
			
			for(Map dataListMap: paramList) {
				buttonInsertList1 = (List<Map>)dataListMap.get("data");	
			}		
			if(buttonInsertList1 != null) this.insertDetail1(buttonInsertList1, user);}
		
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	/**
	 * 점검내역 초기화 버튼(초기화)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail1 (List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param : paramList )	{	
			try {
				super.commonDao.update("s_ass910skrServiceImpl_KOCIS.insertDetail1", param);
				
			} catch(Exception e) {
	 			throw new  UniDirectValidateException("초기화 작업 중 오류가 발생했습니다. \n 관리자에게 문의하시기 바랍니다.");
			}	
		}	
			
		return 0;
	}	

}
