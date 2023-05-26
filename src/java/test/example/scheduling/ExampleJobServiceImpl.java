package test.example.scheduling;

import java.net.Inet4Address;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import test.example.cmm.ExampleAbstractServiceImpl;

import foren.framework.utils.ConfigUtil;

public class ExampleJobServiceImpl extends ExampleAbstractServiceImpl implements ExampleJobService {

    private static final Logger logger = LoggerFactory.getLogger(ExampleJobServiceImpl.class);
    
    /**
     * 여러 Instance 가 돌때 하나의 Host에서만 Job이 수행 하도록 함.
     * 
     * @return
     */
    private boolean checkIP() {
        boolean chk = false;
        
        String syncServerIP = ConfigUtil.getString("example.SyncServerIP", "N/A");
        String hostIP = null;
        try {
            hostIP = Inet4Address.getLocalHost().getHostAddress();
            // logger.debug("Host IP : " + hostIP ) ;
            if(hostIP != null) {
                if(hostIP.equals(syncServerIP)) {
                    chk = true;
                }
            }
        } catch (Exception e) {
            
        }
        return chk;
        
    }
    
    
    
    public void excuteJob() {
        if(checkIP()) {
            logger.debug("\n\n >>>>>>>>>>>> JOB start >>>>>>>");
            try {
                logger.debug("Do something.");
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
            logger.debug("\n >>>>>>>>>>>> JOB Finish >>>>>>>");
        } else {
            logger.debug(" excuteJob triggered  but host IP not equal with parameter of the configuration. so it is skipped. ");
        }
    }
}
