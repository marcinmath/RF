*** Settings ***
Resource          ../resources/resource.txt
Resource          wsb resource.tsv
Resource          ../resources/${ENV}_resource.txt
Library           RequestsLibrary

*** Variables ***
${ENV}            qa

*** Test Cases ***
REST call 1
    [Tags]    STABLE    1.0.4    SANITY
    ${stdout}    Wsb Resource.Log To Console    test WSB
    Should Contain    ${stdout}    test WSB
    Should Match Regexp    ${stdout}    test WSB\\d{3}
    BuiltIn.Log To Console    ${RestAPIport}

REST call 2
    [Tags]    DISABLE
    ${stdout}    Wsb Resource.Log To Console    test WSB
    Should Contain    ${stdout}    test WSB
    Should Match Regexp    ${stdout}    test WSB\\d{3}
    BuiltIn.Log To Console    ${RestAPIport}

REST call 200 google rest api
    [Tags]
    ${url}    Set Variable    http://maps.googleapis.com
    ${resource}    Set Variable    /maps/api/geocode/json
    ${address}    Set Variable    Gdynia,Poland
    RequestsLibrary.Create Session    GoogleRest    ${url_test}
    ${params}    Create Dictionary    address=${address}    sensor=false
    ${response}    RequestsLibrary.Get Request    GoogleRest    ${resource}    params=${params}
    ${code}    Set Variable    ${response.status_code}
    #&{response}[status_code]
    Run Keyword And Continue On Failure    Should Be Equal As Integers    200    ${code}
    ${content}    To Json    ${response.content}
    ${status}    Set Variable    &{content}[status]
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${status}    OK
    @{list}    Set Variable    &{content}[results]
    Log Many    @{list}

REST call 400 google rest api
    [Tags]
    ${url}    Set Variable    http://maps.googleapis.com
    ${resource}    Set Variable    /maps/api/geocode/xml
    ${address}    Set Variable    Gdynia,Poland
    RequestsLibrary.Create Session    GoogleRest    ${url_test}
    ${params}    Create Dictionary    aaddress=${address}    sensor=false
    ${response}    RequestsLibrary.Get Request    GoogleRest    ${resource}    params=${params}
    ${code}    Set Variable    ${response.status_code}
    #&{response}[status_code]
    log    ${code}
    Run Keyword And Continue On Failure    Should Not Be Equal As Integers    200    ${code}
    Run Keyword And Continue On Failure    Should Be Equal As Integers    400    ${code}

REST call 200 POST httpbin
    [Tags]
    ${resource}    Set Variable    /post
    RequestsLibrary.Create Session    httpbin    ${httpbinurl}
    ${originIp}    Set Variable    213.192.95.26
    ${data}    Create Dictionary
    ${response}    RequestsLibrary.Post Request    httpbin    ${resource}    data=${data}
    ${code}    Set Variable    ${response.status_code}
    Run Keyword And Continue On Failure    Should Be Equal As Integers    200    ${code}
    ${content}    To Json    ${response.content}
    ${ActOrigIp}    Set Variable    &{content}[origin]
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${ActOrigIp}    ${originIp}
