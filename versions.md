# Proxy Service versions

**Latest Current version: 1.0.0**

Version | Comment | Date
---|---|---
1.3.0 | Initial release | 2020-04-24
1.3.1 | Updated with TLS support | 2020-04-30
1.3.2 | Metadata cahe in daemon process. Improved logging | 2020-05-01

## Important Release Notes

### 1.3.1
Added support for configuration of TLS access to embedded tomcat on port 8443

Configuration is controlled by the following environment variables set at docker run.

Variable | Default value
--- | ---
TOMCAT_TLS_SERVER_KEY | $SIGNSERVICE_DATALOCATION/tomcat/tomcat-key.pem
TOMCAT_TLS_SERVER_CERTIFICATE |  $SIGNSERVICE_DATALOCATION/tomcat/tomcat-cert.pem
TOMCAT_TLS_SERVER_CERTIFICATE_CHAIN | $SIGNSERVICE_DATALOCATION/tomcat/tomcat-chain.pem
TOMCAT_TLS_SERVER_KEY_TYPE | RSA

A new tomcat folder with sample keys and certificates are located in the resources folder.

### 1.3.2
Se section 5 for information on how to set logging level by env variable.
