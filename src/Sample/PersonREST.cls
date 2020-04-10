Class Sample.PersonREST Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
<Route Url="/persons" Method="GET" Call="GetAllPersons"/>
<Route Url="/persons/:id" Method="GET" Call="GetPerson"/>
<Route Url="/persons/:id" Method="PUT" Call="UpdatePerson"/>
<Route Url="/persons/:id" Method="DELETE" Call="DeletePerson"/>
<Route Url="/persons" Method="POST" Call="CreatePerson"/>
<!-- Swagger specs -->
</Routes>
}

ClassMethod GetAllPersons() As %Status
{
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Set rset = ##class(Sample.Person).ExtentFunc()
    Write "["
    While rset.%Next() {
        Set person = ##class(Sample.Person).%OpenId(rset.ID)
        Do person.%JSONExport()
        if (rset.%Next()) {
            Write ","
        }
    }
    Write "]"
    Quit $$$OK
}

ClassMethod GetPerson(id As %Integer) As %Status
{
    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Set person = ##class(Sample.Person).%OpenId(id)

    If '$IsObject(person) Quit ..Http404()

    Do person.%JSONExport()

    Quit $$$OK
}

ClassMethod CreatePerson() As %Status
{
    #dim tSC As %Status = $$$OK
    Set person = ##class(Sample.Person).%New()
    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC, person.%JSONImport(data))
    $$$TOE(tSC, person.%Save())

    Set %response.Status = 201
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Do person.%JSONExport()
    Quit $$$OK
}

ClassMethod UpdatePerson(id As %Integer) As %Status
{
    #dim tSC As %Status = $$$OK
    Set person = ##class(Sample.Person).%OpenId(id)

    If '$IsObject(person) Return ..Http404()
    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC, person.%JSONImport(data))
    $$$TOE(tSC, person.%Save())

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Do person.%JSONExport()
    Quit tSC
}

ClassMethod DeletePerson(id As %Integer) As %Status
{
    #dim tSC As %Status = $$$OK
    Set person = ##class(Sample.Person).%OpenId(id)
    If '$IsObject(person) Return ..Http404()

    $$$TOE(tSC,person.%DeleteId(id))

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Quit tSC
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/crud"
  Set swagger.info.title = "InterSystems IRIS CRUD demo"
  Set swagger.info.version = "0.1"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

/// forms JSON error from status (if any) and sends it
/// or sends a JSON of different types
ClassMethod %ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
  #dim %response As %CSP.Response
  SET tSC = $$$OK
  IF $$$ISERR(pStatus) {
    SET %response.Status = 500
    SET tSC = ..StatusToJSON(pStatus, .tJSON)
    IF $isobject(tJSON) {
      SET pResult = tJSON
    } ELSE {
      SET pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
    }
  } 
  ELSEIF pStatus=1 {
    IF '$isobject(pResult){
      SET pResult = {
      }
    }
  }
  ELSE {
    SET %response.Status = pStatus
    SET error = $PIECE(pStatus, " ", 2, *)
    SET pResult = {
      "error": (error)
    }
  }
  
  IF pResult.%Extends("%Library.DynamicAbstractObject") {
    WRITE pResult.%ToJSON()
  }
  ELSEIF pResult.%Extends("%JSON.Adaptor") {
    DO pResult.%JSONExport()
  }
  ELSEIF pResult.%Extends("%Stream.Object") {
    DO pResult.OutputToDevice()
  }
  
  QUIT tSC
}

}
