package test.net;

import foren.framework.web.interceptor.IpFilterService;

public class IPFilterTest {

    public static void main(String args[]) throws Exception {
        IpFilterService ipFilter = new IpFilterService();

        String[] ips =  {"192.168.0.10",
                        "192.168.0.11",
                        "127.0.0.1"};
        String[] ips2 = {"192.168.0.11"};
        System.out.printf("\n");
        for (String ipaddress : ips) {
            boolean chk = ipFilter.hasAccessAuth(ipaddress);
            System.out.printf("IP Address:\t\t\t\t%s in %s\t\n", ipaddress, chk?"ALLOW":"BLOCKED");
        }
    }
}
