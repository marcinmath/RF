*** Settings ***
Library           Collections
Library           BuiltIn
Library           RequestsLibrary
Resource          resources/resource.txt
Resource          resources/${ENV}_resource.txt

*** Variables ***
${ENV}            test

*** Test Cases ***
GetAddress 200
    [Tags]    1.0..3    getaddress    REST_API
    Create Session    rest_api    ${url_test}
    ${address}    Set Variable    Polska, Gdańsk, Bzowa
    ${params}    Create Dictionary    address=${address}    sensor=false
    ${response}    RequestsLibrary.Get Request    rest_api    uri=/maps/api/geocode/json    params=${params}
    #walidacja response!
    log    ${response.status_code}
    Should Be Equal As Integers    200    ${response.status_code}
    Run Keyword If    '200' !='${response.status_code}'    Log To Console    Expected 200 but got '${response.status_code}' for status code.

GetAddress 400
    [Tags]    1.0..3    getaddress
    Create Session    rest_api    http://maps.googleapis.com
    ${address}    Set Variable    polska
    ${params}    Create Dictionary    adress=${address}    sensor=false
    ${response}    RequestsLibrary.Get Request    rest_api    uri=/maps/api/geocode/xml    params=${params}
    #walidacja response!
    log    ${response.status_code}
    Should Be Equal As Integers    ${response.status_code}    400
    Run Keyword If    '${response.status_code}' !='400'    Log To Console    '${response.status_code}' from get request is different \ 400

GetAddress 404
    [Tags]    1.0.3    getaddress    DISABLED
    #SOAP MOCK
    Create Session    rest_api    http://m-VirtualBox:8089
    ${address}    Set Variable    afasdfasdfasdfafda
    ${params}    Create Dictionary    adress=${address}    sensor=false
    ${response}    RequestsLibrary.Get Request    rest_api    uri=/maps/api/geocode/xml/404    params=${params}
    #walidacja response!
    log    ${response.status_code}
    Should Be Equal As Integers    ${response.status_code}    404
    Run Keyword If    '${response.status_code}' !='404'    Log To Console    '${response.status_code}' from get request is different \ 404

GetAddress 200 - keyword
    [Tags]    1.0.3    getaddress    REST_API
    ${address}    Set Variable    Polska
    ${params}    Create Dictionary    address=${address}    sensor=false
    ${content}    ${code}    Resource.post request with params    http://maps.googleapis.com    /maps/api/geocode/xml    ${params}
    #walidacja response!
    Should Be Equal As Integers    ${code}    200
    Run Keyword If    '${code}' =='200'    Log To Console    Expected 200 but got '${code}' for status code.

GetAddress 200 - mock
    [Tags]    1.0..3    getaddress    DISABLED
    ${response}    get request with parms    http://maps.googleapis.com    /maps/api/geocode/xml
    #walidacja response!
    Should Be Equal As Integers    200    ${response.status_code}

*** Keywords ***
get request with parms
    [Arguments]    ${url}    ${uri}
    Create Session    rest_api    ${url}
    ${address}    Set Variable    Polska, Gdańsk, Bzowa
    ${params}    Create Dictionary    address=${address}    sensor=false
    ${response}    RequestsLibrary.Get Request    rest_api    uri=${uri}    params=${params}
    [Return]    ${response}
