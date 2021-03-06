@jboss-eap-7-tech-preview/eap-cd-openshift
Feature: Openshift EAP CD basic tests

  # https://issues.jboss.org/browse/CLOUD-180
  Scenario: Check if image version and release is printed on boot
    When container is ready
    Then container log should contain Running jboss-eap-7-tech-preview/eap-cd-openshift image, version

  Scenario: Check that the labels are correctly set
    Given image is built
    Then the image should contain label com.redhat.component with value jboss-eap-7-eap-cd-openshift-container
     And the image should contain label name with value jboss-eap-7-tech-preview/eap-cd-openshift
     And the image should contain label io.openshift.expose-services with value 8080:http
     And the image should contain label io.openshift.tags with value builder,javaee,eap,eap7

  Scenario: Check for add-user failures
    When container is ready
    Then container log should contain Running jboss-eap-7-tech-preview/eap-cd-openshift image
     And available container log should not contain AddUserFailedException

  Scenario: Cloud-1784, make the Access Log Valve configurable
    When container is started with env
      | variable          | value                 |
      | ENABLE_ACCESS_LOG | true                  |
    Then file /opt/eap/standalone/configuration/standalone-openshift.xml should contain <access-log use-server-log="true" pattern="%h %l %u %t %{i,X-Forwarded-Host} &quot;%r&quot; %s %b"/>
