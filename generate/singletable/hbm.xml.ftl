[#ftl]
[#assign filename]src/main/resources/${table.name?cap_first}.hbm.xml[/#assign]
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-mapping PUBLIC
        "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">

[#import "functions.fff" as functions]
<hibernate-mapping package="nz.ac.otago.edtech.${application.projectName}.bean">

    <class name="${table.name?cap_first}" table="${application.tablePrefix}_${table.name?lower_case}">

[#list table.fields.list as field]
        [#if field.name == "id"]
        <id name="${field.name}">
            <column name="[#if (field.hibernate.column)??]${field.hibernate.column}[#else]${field.name?lower_case}[/#if]" not-null="true"/>
            <generator class="native"/>
        </id>

        [#else]
        [#if field.tableReference??]
            [#switch field.mapping]
                [#case "MANYTOONE"]
        <!-- ${field.description} -->
        <many-to-one name="${field.name?uncap_first}" column="[#if (field.hibernate.column)??]${field.hibernate.column}[#else]${field.name?lower_case}id[/#if]"[#if (field.hibernate["notNull"])??] not-null="${field.hibernate["notNull"]?string}"[/#if][#if (field.hibernate["lazy"])??] lazy="${field.hibernate["lazy"]?string}"[/#if]/>
                [#break]
                [#case "MANYTOMANY"]
                [#break]
                [#case "ONETOMANY"]
[#assign association = functions.getTable(field.tableReference)]
        <!-- ${field.description} -->
        <set name="${field.name?uncap_first}"[#if (field.hibernate.cascade)??] cascade="${field.hibernate.cascade}"[/#if][#if (field.hibernate["orderBy"])??] order-by="${field.hibernate["orderBy"]}"[/#if][#if (field.hibernate.inverse)??] inverse="${field.hibernate.inverse?string}"[#else] inverse="true"[/#if][#if (field.hibernate["lazy"])??] lazy="${field.hibernate["lazy"]?string}"[/#if]>
            <key column="[#if (field.hibernate.column)??]${field.hibernate.column}[#else]${table.name?lower_case}id[/#if]"/>
            <one-to-many class="${field.tableReference?cap_first}"/>
        </set>
                [#break]
                [#case "ONETOONE"]
        <one-to-one name="${field.name?lower_case}" constrained="true"[#if (field.hibernate.cascade)??] cascade="${field.hibernate.cascade}"[/#if]/>
                [#break]
            [/#switch]
        [#elseif field.component = true]
        <!-- ${field.description}-->
        <component name="${field.name?uncap_first}">
            [#list classes.list as class]
                [#if class.name = "${field.type}"]
                    [#list class.properties.list as property]
            <property name="${property.name}"[#if property.hibernatetype??] type="${property.hibernatetype}"[/#if]/>
                    [/#list]
                [/#if]
            [/#list]
        </component>
        [#else]
            [#if field.formType = "FILE"]
        <!-- ${field.description} -->
        <property name="${field.name?uncap_first}UserName">
            <column name="${field.name?lower_case}username"/>
        </property>
            [#else]
        <!-- ${field.description} -->
        <property name="${field.name?uncap_first}"[#if (field.hibernate.type)??] type="${field.hibernate.type}"[/#if]>
            <column name="[#if (field.hibernate.column)??]${field.hibernate.column}[#else]${field.name?lower_case}[/#if]"[#if (field.hibernate.length)??] length="${field.hibernate.length}"[/#if][#if (field.hibernate["notNull"])??] not-null="${field.hibernate["notNull"]?string}"[/#if][#if (field.hibernate["unique"])??] unique="${field.hibernate["unique"]?string}"[/#if][#if (field.hibernate.precision)??] precision="${field.hibernate.precision}"[/#if][#if (field.hibernate.scale)??] scale="${field.hibernate.scale}"[/#if]/>
        </property>
            [/#if]
        [/#if]

    [/#if]
[/#list]
    </class>

</hibernate-mapping>