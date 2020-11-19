
---
# CURRENT BUILD VERSION = 1.3.9
---
# docker-signservice

This repo contains build and deploy scripts for the SUNET electronic signature service. The following build and deployment steps should be followed:

1. Building a docker image
2. Setting up key files and configuration data.
3. Deploying the docker image as docker container.
4. Bootstrap CA instances
5. Bootstrap Sign Service instances

The signservice application is provided as a signed war file which is deployed to the maven repo at: [https://maven.eidastest.se](https://maven.eidastest.se/artifactory/webapp/#/home)

## 1. Building docker file

The docker build script "build.sh" builds a docker image for the signature service by performing the following actions:

- Downloading the executable .war file from maven repository
- Downloading the signature (asc) on the metadata validator executable
- Verifying the signature on the downloaded .jar file.
- Building the Tomcat appication server with depedencies, scripts and installed web applications
- Building the docker image.

```
Usage: build.sh [options...]

   -u, --user             Username for Maven repository (default is eidasuser)
   -p, --passwd           Password for Maven repository (will be prompted for if not given)
   -v, --version          Version for artifact to download
   -i, --image            Name of image to create (default is cs-sigserver)
   -t, --tag              Optional docker tag for image
   -c, --clear            Clears the target directory after a successful build (default is to keep it)
   -h, --help             Prints this help
```

## 2. Configuration
The resources folder contains sample configuration data. The content of the `signservice` folder illustrates a working example file structure to be placed in a directory specified in a suitable location reflected in the settings of the environment variable `SIGNSERVICE_DATALOCATION`. This environment variable is set in the docker run command to define datastorage location inside the docker container.

The following folders and files are present in `signservice`:

Folder | Description
--- | ---
`CA` | Contains autogenerated CA instances issuing signer certificates
`conf`  |  Holds general configuration data for the sign service
`instances`  |  Configured instances of the signing service. Each instance may represent a unique organization this instance belongs to. All instances share the same CA but have unique SP keys and entityID for authentication and communication with requesting services
`keystores` | auto generated keystores holding RSA signer keys. These are pre-generated in order to provide faster signing process.
`publish`  | This folder is used by the signing service to store published data such as Metadata and certificate revocation lists
`RootCA`  | Contains an autogenerated root CA instance
`sigTasks`  |   Contains the database for storing sign request session data
`temp_keystores`  |  used by the system for temporary storage of signer keystores between the moment it is selected for a particular signer, until it is used and destroyed.

The following configuration files are present in the conf directory:

File | Description
--- | ---
sig-config.json | Main configuration file
rootCaConf.json  | Configuration for the autogenerated RootCA instance


### 2.1 Configuration settings
The `sig-config.json` file in the resources folder illustrates sensible defaults. This file contains 2 categories of paramters:

- General configuration parameters
- Configuration of autogenerated CA

The rootCaConf.json file contains configuration of autogenerated Root CA

#### 2.1.1 General configuration parameters

Parameter | Value
--- | ---
`sigServiceBaseUrl`  |  The signservice applicatin is exposed in the deployed docker container under the service path `/cs-sigserver`. This parameter contains the public URL pointing to this service location.
`crlValidityHours`  |  the number of hours the CRL for the signer certificate is made valid
`metadataLocation`  |  The URL to IdP metadata.
`metadataCertLocation`  | Path to the metadata validation certificate. This is either a complete path (with a leading "/" character) or a relative path, relative to the main configuration location determined by the environment variable `SIGNSERVICE_DATALOCATION`
`metadataRefreshMinutes`  |  Number of minutes before metadata is refreshed

Other general parameters are set to default values that should not be changed.

#### 2.1.2 CA configuration paremeters
These parameters influences generation and use of the CA used to issue signer certificates.

Parameter | Value
--- | ---
`caKeyLength`  | The key length of the generated CA key
`caCountry`  |  The 2 lettter country code for the CA identity
`caOrgName` | Organization name for the CA
`caOrgUnitName`  |  Organization unit name for the CA
`caSerialNumber`  | Unique ID for the CA
`caCommonName`  | A descriptive common name for the CA
`caKsPassword`  |  Password for the CA keystore
`caKsAlias`  |  Alias for the CA key

Other parameters are set to default values that should not be changed.

#### 2.1.3 Root CA configuration parameters

The rootCaConf.json file should be set with regard to the following values


Parameter | Value
--- | ---
`keyLength` | key length for the root CA
`validityYears`  |  The number of years the root certificate should be valid
`commonName`  |  Common name of the root CA
`organizationName`  |  Organization name for the root CA
`orgUnitName`  |  Organization Unit name of the root CA
`serialNumber`  |  Unique identifier for the root CA organization
`country`  |  2 letter country code


## 3. Sign Service instances
The Sign Service is designed to host multiple instances, where each instance represents a separate entity.
All configuration related to a speicific entity is located in the `instances` folder of the sample configuration.

The items in this folder are common to all instances. These are:

- The main instance configuration file `instances.json`
- The keystore for signing metadata for sign service instances
- configuration folders for each instance with folder name equal to the instance name.

Each instance folder (such as edusign in the sample data) contains the configuration data unique to this instance.
This folder contains the following files:

File | description
--- | ---
`instance.json`  |  The instance configuration file. This file determines the name of the following items below as well as metadata parameters for the instance.
`instance.jks`  |  The instance keystore according to the instance.json configuration
`logo file`  |  The instance logo file according to the instance.json configuration
`trustStore.jks`  |  The instance trust keystore. This keystore must contain the certificates of all trusted SP services authorized to send requests to this instance. The alias for each trusted certificate MUST be the EntityID of that SP entity.


## 4. TLS configuration

### 1.3.1
TLS access to the docker container is exposed on port 8443
Configuration is controlled by the following environment variables set at docker run, used to loacate the necessary key and certificates.

Variable | Default value
--- | ---
TOMCAT_TLS_SERVER_KEY | $SIGNSERVICE_DATALOCATION/tomcat/tomcat-key.pem
TOMCAT_TLS_SERVER_CERTIFICATE |  $SIGNSERVICE_DATALOCATION/tomcat/tomcat-cert.pem
TOMCAT_TLS_SERVER_CERTIFICATE_CHAIN | $SIGNSERVICE_DATALOCATION/tomcat/tomcat-chain.pem
TOMCAT_TLS_SERVER_KEY_TYPE | RSA

A folder with sample keys and certificates are located in the default location in the signservice folder in the resources folder.


## 5. Logging

### 5.1 Log level
Log level is set by the env variable LOGLEVEL_SIGSERVER at docker run. For debug loggning set:

> -e “LOGLEVEL_SIGSERVER=FINE”

### 5.2 Audit logging
Signservice export audit logs to a separate file in the tomcat logs folder.
The name of the audit log file is:

> cs-sigserver-audit.{YYY-MM-DD}.log

By default, audit logs are stored in 7 days before being removed from the log directory. The number of days all logs are retained before being delated can be changed by setting the environment variable `MAXLOGDAYS` at docker run. E.g:

> -e "MAXLOGDAYS=90"

## 6. Running the docker container

The samples folder contains a sample docker deploy script `deploy.sh`:

```
#!/bin/bash

echo Deploying docker containter cs-sigserver
docker run -d --name cs-sigserver --restart=always \
  -p 8080:8080 \
  -e "SIGNSERVICE_DATALOCATION=/opt/signservice" \
  -v /etc/localtime:/etc/localtime:ro \
  -v /opt/docker/signservice:/opt/signservice \
  cs-sigserver

echo Done!
```
