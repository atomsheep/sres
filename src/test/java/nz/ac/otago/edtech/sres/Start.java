package nz.ac.otago.edtech.sres;

import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.webapp.WebAppContext;

/**
 * Start Jetty server.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 18/07/2014
 *         Time: 14:02:13
 */
public class Start {

    public static void main(String[] args) throws Exception {
        Server server = new Server();
        ServerConnector connector = new ServerConnector(server);
        // Set some timeout options to make debugging easier.
        connector.setIdleTimeout(1000 * 60 * 60);
        connector.setSoLingerTime(-1);
        connector.setHost("localhost");
        connector.setPort(8022);
        server.setConnectors(new Connector[]{connector});

        WebAppContext bb = new WebAppContext();
        bb.setServer(server);
        bb.setContextPath("/sres");
        bb.setWar("src/main/webapp");

        server.setHandler(bb);

        try {
            System.out.println(">>> STARTING EMBEDDED JETTY SERVER, PRESS ANY KEY TO STOP");
            server.start();
            System.in.read();
            System.out.println(">>> STOPPING EMBEDDED JETTY SERVER");
            //while (System.in.available() == 0) {
            //    Thread.sleep(5000);
            //}
            server.stop();
            server.join();
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(100);
        }
    }
}
