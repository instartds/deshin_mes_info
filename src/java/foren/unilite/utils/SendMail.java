package foren.unilite.utils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import foren.framework.utils.ConfigUtil;

/**
 * <pre>
 * Apache Commons-Email은 Java Mail API를 근간으로 좀더 심플하게 메일을 보내는 방안을 제시한다.
 * Commons Email API는 메일 발송을 처리해주는 SimpleEmail, HtmlEmail과 같은 클래스를 제공하고 있으며, 
 * 이들 클래스를 사용하여 일반 텍스트메일, HTML 메일, 첨부 메일 등을 매우 간단(simple)하게 발송할 수 있다.
 * 
 * Email Sample Code는 다음과 같다.
 * 
 * <li>간단히 텍스트만 보내기</li>
 * <li>파일 첨부하기</li>
 * <li>URL을 통해 첨부하기</li>
 * <li>HTML 이메일 보내기</li>
 * <li>인증 처리하기</li>
 * 
 * commons-email-1.2.jar
 * </pre>
 * 
 * @author 박종영
 * @see http://commons.apache.org/proper/commons-email/index.html
 */
public class SendMail {
    /**
     * Logger
     */
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public static void main( String args[] ) {
        SendMail mail = new SendMail();
        String serial = DevFreeUtils.makeJobID();
        
        Map contents = new HashMap();
        
        contents.put("subject", "경비처리 미결알림");    // 메일제목
        
        String[] addAddr = new String[1];                // 한사람에게 보낼 때( 배열의 갯수는 같아야 합니다. )
        String[] addUser = new String[1];                // 한사람에게 보낼 때( 배열의 갯수는 같아야 합니다. )
        
        addAddr[0] = "hermeswing@gmail.com";
        addUser[0] = "박종영";
        
        //String[] addAddr = new String[2];                // 여러사람에게 보낼 때( 배열의 갯수는 같아야 합니다. )
        //String[] addUser = new String[2];                // 여러사람에게 보낼 때( 배열의 갯수는 같아야 합니다. )
        
        //addAddr[0] = "jeong.yijin@joins.com";
        //addAddr[1] = "kim.juyoung1@joins.com";
        
        //addUser[0] = "정이진";
        //addUser[1] = "김주영";
        
        contents.put("addAddr", addAddr);
        contents.put("addUser", addUser);
        
        // 보내는 사람 정보
        String fromAddr = ConfigUtil.getString("common.mail.fromAddr", "hermeswing@foren.co.kr");
        String fromUser = ConfigUtil.getString("common.mail.fromUser", "관리자");
        contents.put("fromAddr", fromAddr);
        contents.put("fromUser", fromUser);
        
        // HTML에 들어갈 내용
        // 내용에 따라 변경될 수 있음.
        Map param = new HashMap();
        param.put("recv_yn", "N");                      // '메일수신여부' 확인 여부
        param.put("recv_url", "");                      // 메일확인여부 수신 URL ( 메일 수신자가 메일을 확인했는지 여부를 리턴하는 URL )
        // 메일확인여부 수신 웹서비스가 떠 있어야 한다.
        param.put("serial", serial);                    // 메일확인여부 수신 URL의 고유한 KEY
        param.put("htmlFile", "Mail01.html");           // 발송될 HTML 파일
        param.put("title", "경비처리 미결알림");        // HTML에 들어갈 제목
        param.put("msg", "내용");                       // HTML에 들어갈 내용
        
        try {
            contents.put("contents", mail.makeContents(param));
            
            System.out.println("contents :: " + contents);
            
            String rtnVal = mail.sendHtmlMail(contents);
            
            System.out.println("rtnVal :: " + rtnVal);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * HTML 메일 발송
     * 
     * @param contents
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public String sendHtmlMail( Map contents ) throws Exception {
        HtmlEmail email = new HtmlEmail();
        String rtnVal = null;
        
        // 기본 메일 정보를 생성합니다
        try {
//            String hostName = ConfigUtil.getString("common.mail.smtp", "");
//            String charset = ConfigUtil.getString("common.mail.charset", "utf-8");
//            int port = ConfigUtil.getIntValue("common.mail.port", 25);
            
//            email.setCharset(charset);
//            email.setHostName(hostName);
//            email.setSmtpPort(port);
            email.setCharset("utf-8");
            email.setHostName("smtp.kdg.co.kr");
            
            String[] addAddr = (String[])contents.get("addAddr");
            String[] addUser = (String[])contents.get("addUser");
            try {
                for (int i = 0; i < addAddr.length; i++) {
                    // addAddr :: 받는이 email 주소 ( xxxx@test.com )
                    // addUser :: 받는이 명 ( 홍길동 )
                    email.addTo(addAddr[i], addUser[i]);  // 여러사람에게 발송 시 addTo를 계속 추가하면 됨.
                }
            } catch (Exception e) {
                throw new Exception("받는사람 배열 수 오류.");
            }
            
            String fromAddr = (String)contents.get("fromAddr");
            String fromUser = (String)contents.get("fromUser");
            
            email.setFrom(fromAddr, fromUser);                        // 보내는 사람 정보
            email.setSubject((String)contents.get("subject"));
            
            // HTML 메세지를 설정합니다
            email.setHtmlMsg((String)contents.get("contents"));
            
            // HTML 이메일을 지원하지 않는 클라이언트라면 다음 메세지를 뿌려웁니다
            email.setTextMsg("Your email client does not support HTML messages");
            
            // 메일을 전송합니다
            email.send();
            
            rtnVal = "1";
            
        } catch (EmailException e) {
            logger.error(e.getMessage());
            e.printStackTrace();
            
            rtnVal = "9";
        } catch (Exception e) {
            logger.error(e.getMessage());
            e.printStackTrace();
            
            rtnVal = "9";
        }
        
        return rtnVal;
    }
    
    /**
     * <pre>
     * 발송될 메일내용이 담긴 HTML 파일을 읽어들입니다.
     * 변경될 내용은 '@'로 감싸져 있습니다.
     * </pre>
     * 
     * @param Map
     * @return
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String makeContents( Map param ) throws IOException, Exception {      
        String htmlFilePath = ConfigUtil.getString("common.mail.htmlFilePath", "");
        String htmlFile = param.get("htmlFile") == null ? "" : param.get("htmlFile").toString();
        
        BufferedReader br = null;
        StringBuilder sb = null;
        String rtnStr = "";
        
        try {
            if(htmlFilePath.equals("")) return "HTML 파일경로를 읽을 수 없습니다.";
            if(htmlFile.equals("")) return "파일명을 읽을 수 없습니다.";
            
            br = new BufferedReader(new FileReader(htmlFilePath + "/" + htmlFile));
            sb = new StringBuilder();
            
            char[] buf = new char[1024];
            while (br.read(buf) > 0) {
                sb.append(buf);
            }
            
            rtnStr = sb.toString();
            Set<String> keys = param.keySet();
            Iterator<String> iterator = keys.iterator();
            String key = null;
            String value = null;
            while (iterator.hasNext()) {
                key = iterator.next();
                value = (String)param.get(key);
                rtnStr = DevFreeUtils.replaceAll(rtnStr, "@" + key + "@", value);
            }
        } catch (IOException ioe) {
            throw ioe;
        } catch (Exception e) {
            throw e;
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return rtnStr;
    }
    
    public String makeJobID() {
        StringBuffer jobId = new StringBuffer(20);
        DateTime today = new DateTime();
        jobId.append(today.toString("yyyyMMddHHmmssSSS"));
        jobId.append(Math.round(Math.random() * 10000));
        return jobId.toString();
    }
    
}
