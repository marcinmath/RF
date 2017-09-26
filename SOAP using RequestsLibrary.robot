*** Settings ***
Library           Collections
Library           BuiltIn
Library           RequestsLibrary

*** Test Cases ***
GetSupplierByCity 200
    [Tags]    1.0..3    adduser    REST_API
    ${headers}    Create Dictionary    content-type=text/xml
    ${url}    Set Variable    http://www.webservicex.net/medicareSupplier.asmx?WSDL
    Create Session    GetSupplierByCity    ${url}
    ${body}    Set Variable    <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:web="http://www.webservicex.net/"> \ \ \ <soap:Header/> \ \ \ <soap:Body> \ \ \ \ \ \ <GetSupplierByCity xmlns="http://www.webservicex.net/"> \ \ \ \ \ \ \ \ \ <City>New York</City> \ \ \ \ \ \ </GetSupplierByCity> \ \ \ </soap:Body> </soap:Envelope>
    ${response}    Post Request    GetSupplierByCity    uri=${EMPTY}    data=${body}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    log    ${response.content}
