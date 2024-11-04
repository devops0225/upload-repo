sed -i 's|<property name="javax.net.ssl.keyStoreAlias" value="wcase-api.dev1.td.com"/>|<property name="javax.net.ssl.keyStoreAlias" value="wcase.dev.td.com"/>|' /opt/jboss/standalone/configuration/standalone-full-ha.xml-test


sed -i 's|wcase-api.dev1.td.com.jks|wcase.dev.td.com.jks|g' /opt/jboss/instances/WCASE_0000/configuration/standalone-full-ha.xml
sed -i 's|wcase-api.dev1.td.com|wcase.dev.td.com|g' /opt/jboss/instances/WCASE_0000/configuration/standalone-full-ha.xml
