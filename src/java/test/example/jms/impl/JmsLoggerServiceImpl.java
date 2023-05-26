package test.example.jms.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import test.example.jms.JmsLoggerService;
import test.example.jms.docs.GenResDoc;
import test.example.jms.model.JMSLogVO;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * @Class Name : JmsLoggerService.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Jul 11, 2012
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jul 11, 2012 by SangJoon Kim: initial version
 * </pre>
 */
@Service("JmsLoggerService")
public class JmsLoggerServiceImpl extends TlabAbstractServiceImpl implements
		JmsLoggerService {

	private static final Logger logger = LoggerFactory
			.getLogger(JmsLoggerServiceImpl.class);

	@Override
	public void logSent(JMSLogVO msg) {
		super.commonDao
				.insert("JmsLoggerServiceImpl.insertSendLog", msg);
	}

	@Override
	public void logReceive(JMSLogVO msg) {
		super.commonDao.insert("JmsLoggerServiceImpl.insertReceiveLog",
				msg);

	}

	@Override
	public void logReceived(JMSLogVO msg) {
		super.commonDao.update("JmsLoggerServiceImpl.updateReceivedLog",
				msg);

	}

	@Override
	public void logGenRes(GenResDoc genRes) {
		super.commonDao.update("JmsLoggerServiceImpl.logGenRes", genRes);

	}

}
