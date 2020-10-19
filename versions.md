# Sign Service versions

**Latest Current version: 1.3.8**

Version | Comment | Date
---|---|---
1.3.0 | Initial release | 2020-04-24
1.3.1 | Updated with TLS support | 2020-04-30
1.3.2 | Metadata cahe in daemon process. Improved logging | 2020-05-01
1.3.3 | Support for audit logging | 2020-05-14
1.3.4 | Extended logging of user mismatch | 2020-05-14
1.3.5 | Fixed possible Audit log error | 2020-05-16
1.3.6 | Allow storage of SP entityID as service ID in AuthnContextExt | 2020-05-18
1.3.7 | Fixed issue with malformed IssuerSerial in XAdES signatures  | 2020-08-17
1.3.8 | Support for multiple requested LoA and new protocol version  | 2020-10-19

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
Se section 5.1 for information on how to set logging level by env variable.

### 1.3.3
Added support for audit logging to separate file as specified in section 5.2
