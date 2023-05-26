package foren.unilite.modules.accnt.atx;

import java.io.*;
import java.lang.reflect.Array;
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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("atx210skrService")
public class Atx210skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	/**
	 * 전산매체 데이터 조회(세금계산서합계표)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<String> selectList(Map param) throws Exception {

		List<String>newData  = new ArrayList();
		
		try {  //예외 처리는 기본으로 해 줘야 한다
			//파일에서 스트림을 통해 주르륵 읽어들인다
			//일반적인 방법(한글이 임의로 인코딩 되어 깨어짐 - 아래 방법 사용)
			//BufferedReader txt  =  new BufferedReader(new FileReader(file));
			BufferedReader txt = new BufferedReader(new InputStreamReader(new FileInputStream((String) param.get("filePath")),"euc-kr"));

			//요 s에다가 한 줄씩 읽어 올거다
			String s;
			
			//반복한다! 언제까지? s에 앞서 읽어온 in이라는 문자 스트림에서 한 줄을 읽어 오는게 실패할 때까지!
			while ((s = txt.readLine()) != null) {
				newData.add(s);
			}
			//버퍼리더를 닫아 준다.
			txt.close();
			return newData;

		} catch (IOException e) {
			//혹시 입출력 에러가 발생했다면 어떤 에러인지 출력하고 끄자.
			return  (List<String>) e;
		}
	}

}
