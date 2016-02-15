[#ftl]
[#assign filename]src/main/webapp/WEB-INF/spring/dataSource.xml[/#assign]
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

    <bean id="myDataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
        <property name="driverClassName" value="${r"${"}jdbc.driverClassName}"/>
        <property name="url" value="${r"${"}jdbc.url}"/>
        <property name="username" value="${r"${"}jdbc.username}"/>
        <property name="password" value="${r"${"}jdbc.password}"/>
    </bean>

    <bean id="mySessionFactory" class="org.springframework.orm.hibernate4.LocalSessionFactoryBean">
        <property name="dataSource" ref="myDataSource"/>
        <property name="mappingResources">
            <list>
[#list tables.list?sort_by("name") as table]
                <value>${table.name?cap_first}.hbm.xml</value>
[/#list]
                <value>User.hbm.xml</value>
            </list>
        </property>
        <property name="hibernateProperties">
            <props>
                <prop key="hibernate.dialect">${r"${"}hibernate.dialect}</prop>
                <prop key="hibernate.cache.region.factory_class">org.hibernate.cache.ehcache.EhCacheRegionFactory</prop>
                <prop key="hibernate.cache.use_second_level_cache">true</prop>
                <prop key="hibernate.cache.use_query_cache">true</prop>
                <prop key="hibernate.show_sql">${r"${"}hibernate.show_sql}</prop>
                <prop key="hibernate.hbm2ddl.auto">${r"${"}hibernate.hbm2ddl.auto}</prop>
            </props>
        </property>
    </bean>

</beans>
