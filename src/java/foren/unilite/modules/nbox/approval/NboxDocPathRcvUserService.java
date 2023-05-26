package foren.unilite.modules.nbox.approval;

import java.util.List;
import java.util.Map;

import foren.framework.model.LoginVO;

public interface NboxDocPathRcvUserService {

	public boolean save( LoginVO user, String PathID,  String RcvType, List<Map<String, Object>> dataList) throws Exception;
}