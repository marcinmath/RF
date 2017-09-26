*** Settings ***
Library           SudsLibrary
Library           Collections
Library           BuiltIn
Library           XML

*** Test Cases ***
GetStatistics loop
    [Tags]    1.0..3    disabled
    Create Soap Client    http://www.webservicex.net/Statistics.asmx?WSDL
    ${dbl array}=    Create Wsdl Object    ArrayOfDouble
    Append To List    ${dbl array.double}    2.0
    Append To List    ${dbl array.double}    3.0
    ${result}=    Call Soap Method    GetStatistics    ${dbl array}
    ${keys}    Create List    Average    Sums    StandardDeviation    skewness    Kurtosis
    @{values}    Create List    2.5    5.0    0.5    0.5    -2.5
    : FOR    ${i}    IN RANGE    0    5
    \    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${result.${keys[${i}]}}    ${values[${i}]}

GetStatistics WSDL from xml
    [Tags]    1.0..3    disabled
    Create Soap Client    ${CURDIR}${/}Statistics.asmx.xml
    ${dbl array}=    Create Wsdl Object    ArrayOfDouble
    Append To List    ${dbl array.double}    2.0
    Append To List    ${dbl array.double}    3.0
    ${result}=    Call Soap Method    GetStatistics    ${dbl array}
    ${keys}    Create List    Average    Sums    StandardDeviation    skewness    Kurtosis
    @{values}    Create List    2.5    5.0    0.5    0.5    -2.5
    : FOR    ${i}    IN RANGE    0    5
    \    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${result.${keys[${i}]}}    ${values[${i}]}

GetStatistics with xml
    [Tags]    1.0..3    disabled
    Create Soap Client    ${CURDIR}${/}Statistics.asmx.xml
    ${dbl array}=    Create Wsdl Object    ArrayOfDouble
    Append To List    ${dbl array.double}    2.0
    Append To List    ${dbl array.double}    3.0
    ${response}    Call Soap Method    GetStatistics    ${dbl array}
    ${srednia}    Get Element Text    ${response}    .//Average
    ${odchyleniestd}    Get Element Text    ${response}    .//StandardDeviation
    Should Be Equal As Numbers    2    ${srednia}
    Should Be Equal As Numbers    0.5    ${odchyleniestd}
