[#ftl]
[#assign filename]src/main/webapp/WEB-INF/${application.projectName}-servlet.xml[/#assign]
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.0.xsd
        http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-3.0.xsd">

    <context:component-scan base-package="nz.ac.otago.edtech.${application.projectName}.controller"/>

    <import resource="spring/dataSource.xml"/>
    <import resource="main.xml"/>

    <mvc:annotation-driven/>

    <mvc:interceptors>
        <bean name="openSessionInViewInterceptor"
              class="org.springframework.orm.hibernate4.support.OpenSessionInViewInterceptor">
            <property name="sessionFactory" ref="mySessionFactory"/>
        </bean>
    </mvc:interceptors>

    <mvc:resources mapping="/assets/**" location="/assets/"/>

</beans>