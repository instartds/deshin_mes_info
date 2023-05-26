package test.mybatis;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.unilite.com.UniliteCommonController;

@Controller
public class MyBatisTestController extends UniliteCommonController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @RequestMapping(value = "/test/test01.do", method = RequestMethod.GET)
    public String test01() throws Exception {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("id", "3");
        param.put("name", "1");
        param.put("age", 1);
        param.put("bigo", null);
        param.put("name_en", "name_en");//"bigo");
        super.jasperService.getDao().list("MyBatisTest.test01", param);
        
        super.jasperService.getDao().update("MyBatisTest.update01", param);
        
        SampleBean bean = new SampleBean("4", "test", "bean bigo",10);
        super.jasperService.getDao().update("MyBatisTest.update01", bean);
        
        
        super.jasperService.getDao().update("MyBatisTest.insert01", bean);
        return "!";
    }
    
    private class SampleBean {
        String id;
        String name;
        Integer age;
        String bigo;
        String name_en;
        
        public SampleBean(){
            
        }
        
        public SampleBean(String id, String name, String bigo, Integer age) {
            this.id = id;
            this.name = name;
            this.bigo = bigo;
            this.age = age;
        }
        public String getId() {
            return id;
        }
        public void setId(String id) {
            this.id = id;
        }
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public Integer getAge() {
            return age;
        }
        public void setAge(Integer age) {
            this.age = age;
        }
        public String getBigo() {
            return bigo;
        }
        public void setBigo(String bigo) {
            this.bigo = bigo;
        }
        public String getName_en() {
            return name_en;
        }
        public void setName_en(String name_en) {
            this.name_en = name_en;
        }
        
    }
}
