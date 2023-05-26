package foren.unilite.modules.accnt.agj;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.accnt.agj.Agj100ukrServiceImpl;



@Service("agj106ukrService")
public class Agj106ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="agj100ukrService")
	private Agj100ukrServiceImpl agj100ukrService;
	/**
	 * 결의전표등록(전표번호별) 이전 전표 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getPrevSlipNum(Map param) throws Exception {
		return super.commonDao.select("agj106ukServiceImpl.getPrevSlipNum", param);
	}

	/**
	 * 결의전표등록(전표번호별) 이후 전표 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getNextSlipNum(Map param) throws Exception {
		return super.commonDao.select("agj106ukrServiceImpl.getNextSlipNum", param);
	}
	
	@ExtDirectMethod(group = "Accnt")
	public  List<Map<String, Object>> selectSlipList(Map param) throws Exception {
		return super.commonDao.list("agj106ukrServiceImpl.selectSlipList", param);
	}	
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete(List<Map> params) throws Exception {
		return params;
	}
	

	@ExtDirectMethod(group = "Accnt")
	public Object slipUpdate(Map param) throws Exception {
		return super.commonDao.update("agj106ukrServiceImpl.slipUpdate", param);
	}
	
	@ExtDirectMethod(group = "Accnt")
	public Object draftNoUpdate(Map param) throws Exception {
		return super.commonDao.update("agj106ukrServiceImpl.draftNoUpdate", param);
	}
	
	
	/**
	 * 기안상태 콤보 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<ComboItemModel> fnGetA134MakeCombo(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("agj106ukrServiceImpl.fnGetA134MakeCombo", param);
	}
	 
}
