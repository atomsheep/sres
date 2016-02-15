[#ftl]
[#assign filename]src/main/resources/hibernate.xml[/#assign]
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">

<hibernate-configuration>

    <session-factory>

        <!-- Database connection settings -->
        <property name="connection.driver_class">org.postgresql.Driver</property>
        <property name="connection.url">jdbc:postgresql://localhost/db</property>
        <property name="connection.username">username</property>
        <property name="connection.password">password</property>
        <!--
        <property name="connection.driver_class">org.hsqldb.jdbcDriver</property>
        <property name="connection.url">jdbc:hsqldb:hsql://localhost:9001/xdb</property>
        <property name="connection.username">sa</property>
        <property name="connection.password"></property>
        -->

        <!-- JDBC connection pool (use the built-in) -->
        <property name="connection.pool_size">1</property>

        <!-- CHANGE THIS TO RIGHT DIALECT -->
        <!-- SQL dialect -->
        <property name="dialect">org.hibernate.dialect.PostgreSQLDialect</property>
        <!--
        <property name="dialect">org.hibernate.dialect.HSQLDialect</property>
        <property name="dialect">org.hibernate.dialect.SQLServerDialect</property>
        -->

        <!-- Enable Hibernate's automatic session context management -->
        <!--
        <property name="current_session_context_class">thread</property>
        -->

        <!-- Disable the second-level cache  -->
        <property name="cache.provider_class">org.hibernate.cache.NoCacheProvider</property>

        <!-- Echo all executed SQL to stdout -->
        <property name="show_sql">true</property>

        <property name="format_sql">true</property>

        <!-- Mapping files -->
[#list tables.list?sort_by("name") as table]
        <mapping resource="${table.name?cap_first}.hbm.xml"/>
[/#list]
        <mapping resource="User.hbm.xml"/>

    </session-factory>

</hibernate-configuration>