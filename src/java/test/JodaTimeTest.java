package test;

import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JodaTimeTest {
    private final static Logger logger = LoggerFactory.getLogger(JodaTimeTest.class);
    public static void main(String args[]) throws Exception {
        String fmt = "yyyy/MM/dd HH:mm:ss.SSS";
        DateTime today = new DateTime();
        logger.debug("Format {} = {}", fmt, new DateTime().toString(fmt)+"/"+(Math.round(Math.random()*10000)));
        for(int i = 0 ; i < 100; i++){}
        logger.debug("Format {} = {}", fmt, new DateTime().toString(fmt));
    }
}
