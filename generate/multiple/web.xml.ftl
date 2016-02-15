[#ftl]
[#assign filename]src/main/webapp/WEB-INF/web.xml[/#assign]
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5" xmlns="http://java.sun.com/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">

    <display-name>${application.projectDescription}</display-name>
    <description>
        ${application.projectDescription}
    </description>

    <context-param>
        <param-name>casServerLoginUrl</param-name>
        <param-value>https://zita.otago.ac.nz/zita/login</param-value>
    </context-param>

    <context-param>
        <param-name>casServerUrlPrefix</param-name>
        <param-value>https://zita.otago.ac.nz/zita</param-value>
    </context-param>

    <context-param>
        <param-name>serverName</param-name>
        <param-value>richard.otago.ac.nz</param-value>
    </context-param>

    <filter>
        <filter-name>characterEncodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
    </filter>

    <filter>
        <filter-name>AuthenticationFilter</filter-name>
        <filter-class>nz.ac.otago.edtech.auth.filter.AuthenticationFilter</filter-class>
        <init-param>
            <param-name>nz.ac.otago.edtech.auth.filter.allowAccessWithoutLogin</param-name>
            <param-value>false</param-value>
        </init-param>
        <init-param>
            <param-name>nz.ac.otago.edtech.auth.filter.usingEmbeddedAuthentication</param-name>
            <param-value>false</param-value>
        </init-param>
        <init-param>
            <param-name>nz.ac.otago.edtech.auth.filter.usingCAS</param-name>
            <param-value>true</param-value>
        </init-param>
        <init-param>
            <param-name>nz.ac.otago.edtech.auth.filter.communicationUrl</param-name>
            <param-value>https://zita.otago.ac.nz/edmedia-data/user/{username}</param-value>
        </init-param>
        <init-param>
            <param-name>edu.yale.its.tp.cas.client.filter.logoutUrl</param-name>
            <param-value>https://zita.otago.ac.nz/zita/logout</param-value>
        </init-param>
        <init-param>
            <param-name>nz.ac.otago.edtech.auth.filter.instructors</param-name>
            <param-value>mosad06p,motbe48p,zenyi45p</param-value>
        </init-param>
        <init-param>
            <param-name>nz.ac.otago.edtech.auth.filter.administrators</param-name>
            <param-value>mosad06p,motbe48p,zenyi45p</param-value>
        </init-param>
    </filter>

    <filter>
        <filter-name>CAS Validation Filter</filter-name>
        <filter-class>org.jasig.cas.client.validation.Cas20ProxyReceivingTicketValidationFilter</filter-class>
    </filter>

    <filter>
        <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
        <filter-class>nz.ac.otago.edtech.auth.filter.HttpServletRequestWrapperFilter</filter-class>
    </filter>

    <filter>
        <filter-name>InstructorOnlyFilter</filter-name>
        <filter-class>nz.ac.otago.edtech.auth.filter.AuthorizationFilter</filter-class>
        <init-param>
            <param-name>instructorAccess</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>

    <filter>
        <filter-name>AdministratorOnlyFilter</filter-name>
        <filter-class>nz.ac.otago.edtech.auth.filter.AuthorizationFilter</filter-class>
        <init-param>
            <param-name>administratorAccess</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>

    <filter-mapping>
        <filter-name>characterEncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>AuthenticationFilter</filter-name>
        <url-pattern>/user/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>AuthenticationFilter</filter-name>
        <url-pattern>/instructor/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>AuthenticationFilter</filter-name>
        <url-pattern>/admin/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS Validation Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>InstructorOnlyFilter</filter-name>
        <url-pattern>/instructor/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>AdministratorOnlyFilter</filter-name>
        <url-pattern>/admin/*</url-pattern>
    </filter-mapping>

    <listener>
        <listener-class>nz.ac.otago.edtech.spring.listener.CommonServletListener</listener-class>
    </listener>

    <servlet>
        <servlet-name>${application.projectName}</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>${application.projectName}</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
    </welcome-file-list>

    <error-page>
        <error-code>500</error-code>
        <location>/error.jsp</location>
    </error-page>

</web-app>
