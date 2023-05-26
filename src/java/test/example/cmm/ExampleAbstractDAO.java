package test.example.cmm;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;



import org.springframework.util.Assert;

import com.ibatis.sqlmap.client.SqlMapClient;

import foren.framework.dao.TlabAbstractDAO;

@Repository("ExampleAbstractDAO")
public class ExampleAbstractDAO extends TlabAbstractDAO {

	private Logger logger = LoggerFactory.getLogger(ExampleAbstractDAO.class);

	/**
	 * example package 가 별도의 db connection 을 쓴다면 setSuperSqlMapClient 을 새로 정의 한다.
	 */
//	@Resource(name = "sqlSessionFactory")
//	public void setSuperSqlMapClient(SqlSessionTemplate sqlSessionTemplate) {
//		//super.setSqlMapClient(sqlMapClient);
//		super.setSqlSessionTemplate(sqlSessionTemplate);
//	}
	@Resource(name = "sqlSessionFactory") 
	protected void setSuperSqlSessionFactory(SqlSessionFactory sqlSessionFactory) { 
		Assert.notNull(sqlSessionFactory, "sqlSessionFactory must be not null"); 
		super.setSqlSessionFactory(sqlSessionFactory); 
	} 
	@Resource(name = "sqlSessionTemplate") 
	protected void setSuperSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) { 
		Assert.notNull(sqlSessionTemplate, "SqlSessionTemplate must be not null"); 
		super.setSqlSessionTemplate(sqlSessionTemplate); 
	} 
}
