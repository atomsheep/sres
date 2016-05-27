package nz.ac.otago.edtech.sres.util;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.AuthenticationException;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import java.util.Hashtable;

/**
 * Ldap utility functions.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 16/04/16
 *         Time: 7:12 AM
 */
public class LdapUtil {
    private static final Logger log = LoggerFactory.getLogger(LdapUtil.class);


    public static boolean ldapAuthentication(String ldapUrl, String baseDN, String username, String password) {
        if (StringUtils.isBlank(ldapUrl) || StringUtils.isBlank(baseDN) || StringUtils.isBlank(username) || StringUtils.isBlank(password))
            throw new IllegalArgumentException("empty ldap argument.");
        boolean result = false;
        log.info("Authenticate user \"{}\" from LDAP {} base DN {}", username, ldapUrl, baseDN);
        // Set up the environment for creating the initial context
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, ldapUrl);
        // Specify timeout to be 5 seconds
        env.put("com.sun.jndi.ldap.connect.timeout", "5000");
        // Enable connection pooling
        env.put("com.sun.jndi.ldap.connect.pool", "true");
        String ldapPrincipal = baseDN.replace("%u", username);
        // set to simple for username and password bind
        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        // hardcoded username and password
        env.put(Context.SECURITY_PRINCIPAL, ldapPrincipal);
        env.put(Context.SECURITY_CREDENTIALS, password);
        DirContext ctx = null;
        try {
            ctx = new InitialDirContext(env);
            if (ctx != null) {
                log.debug("ctx = {}", ctx);
                result = true;
            }
        } catch (AuthenticationException e) {
            log.error("AuthenticationException when authenticating " + ldapPrincipal + " from LDAP", e);
        } catch (NamingException e) {
            log.error("NamingException when authenticating " + ldapPrincipal + " from LDAP", e);
        } finally {
            try {
                if (ctx != null)
                    ctx.close();
            } catch (NamingException ne) {
                log.error("NameException when closing context.", ne);
            }
        }
        return result;
    }

    public static void main(String args[]) {

        String ldapUrl = "ldaps://ovd.otago.ac.nz";
        String baseDN = "cn=%u,cn=Users,dc=registry,dc=otago,dc=ac,dc=nz";
        String username = "test";
        String password = "test";
        System.out.println("result = " + LdapUtil.ldapAuthentication(ldapUrl, baseDN, username, password));
    }

}
