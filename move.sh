#!/bin/sh

mv src/main/webapp/WEB-INF/spring-servlet.xml src/main/webapp/WEB-INF/sres-servlet.xml

mkdir src/main/java/nz/ac/otago/edtech/sres/controller/
mv src/main/java/nz/ac/otago/edtech/sres/Common.java src/main/java/nz/ac/otago/edtech/sres/controller/
