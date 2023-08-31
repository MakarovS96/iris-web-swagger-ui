## IRIS Swagger UI
[![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-web-swagger-ui&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-web-swagger-ui) 

It is a tool to generate interactive documentation for your REST API.

## Install
The tool is available as a ZPM module. You can install the tool easy:
```objectscript
USER> zpm
ZPM: USER> install swagger-ui
```

## Getting started in 3 steps
1. Create REST API
2. Provide Swagger Spec url for your REST API
3. Open browser and go to SwaggerUI page (http://localhost:52773/swagger-ui/index.html) and enter your Swagger Spec url

## Demo
![swagger-ui](https://user-images.githubusercontent.com/27987608/79063723-86cdde00-7ccd-11ea-9914-b8cd7077f6e7.png)

## Contribute
Any contribution is welcome.
To start you can clone the repository and up the project in Docker.
```bash
$ git clone https://github.com/atygaev/iris-web-swagger-ui.git
$ cd iris-web-swagger-ui
$ docker-compose up -d
```

For your convenience the project contains simple REST API ([src/Sample/PersonREST.cls](https://github.com/atygaev/iris-web-swagger-ui/blob/master/src/Sample/PersonREST.cls)).

Swagger documentation for the REST API is available at [http://localhost:52773/swagger-ui/index.html](http://localhost:52773/swagger-ui/index.html)
