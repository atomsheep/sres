[#ftl]
[#assign filename]src/main/resources/log4j.properties[/#assign]
# -------------------------------------------------------------------
# log4j.properties
# -------------------------------------------------------------------
log4j.rootLogger=WARN, console, file

log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss.SSS} %-5p [%c] - %m%n
#log4j.appender.console.Threshold=DEBUG

log4j.appender.file=org.apache.log4j.DailyRollingFileAppender
log4j.appender.file.File=/Users/richard/app/logs/${application.projectName}.log
log4j.appender.file.DatePattern='.'yyyy-MM-dd
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss.SSS} %r [%t] %-5p %c:%L - %m%n

log4j.logger.org.springframework=INFO
#log4j.logger.nz.ac.otago.edtech=DEBUG
log4j.logger.nz.ac.otago.edtech=INFO
#log4j.logger.nz.ac.otago.edtech.auth=DEBUG
log4j.logger.nz.ac.otago.edtech.${application.projectName}=DEBUG
#log4j.logger.nz.ac.otago.edtech.${application.projectName}.controller=INFO
