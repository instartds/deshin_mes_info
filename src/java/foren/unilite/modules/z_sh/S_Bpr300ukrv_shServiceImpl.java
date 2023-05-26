package foren.unilite.modules.z_sh;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;

@Service("s_bpr300ukrv_shService")
public class S_Bpr300ukrv_shServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
     * 채번코드1 콤보 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> getCode_1(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("s_bpr300ukrv_shServiceImpl.getCode_1", param);

    }

	/**
     * 채번코드2 콤보 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> getCode_2(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("s_bpr300ukrv_shServiceImpl.getCode_2", param);

    }

	/**
     * 소분류1 콤보 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> getSmallCode_1(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("s_bpr300ukrv_shServiceImpl.getSmallCode_1", param);

    }
	/**
     * 소분류2 콤보 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> getSmallCode_2(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("s_bpr300ukrv_shServiceImpl.getSmallCode_2", param);

    }
	/**
     * 소분류3 콤보 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> getSmallCode_3(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("s_bpr300ukrv_shServiceImpl.getSmallCode_3", param);

    }
	/**
     * 소분류4 콤보 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> getSmallCode_4(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("s_bpr300ukrv_shServiceImpl.getSmallCode_4", param);

    }
	/**
	 * 품목계정에 따른 품목코드 자동채번 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_sh", value = ExtDirectMethodType.STORE_READ)
	public Object selectAutoItemCode(Map param) throws Exception {
		return super.commonDao.select("s_bpr300ukrv_shServiceImpl.selectAutoItemCode", param);
	}

	/**
	 * 채번 후 추가시 채번테이블에 insert 또는 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_sh")
    public String saveAutoItemCode(Map param) throws Exception {

        String rtnV = "";

		super.commonDao.update("s_bpr300ukrv_shServiceImpl.saveAutoItemCode", param);

        rtnV = "Y";
        return rtnV;
    }

}
