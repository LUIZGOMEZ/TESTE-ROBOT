*** Settings ***
Resource        mapAPIs.robot
Resource        ../../resources/massa-de-dados/massaDeDados.robot
Resource        ../../resources/user-resources/userResources.robot
Resource        ../../resources/common/helpers.robot
Resource        ../../resources/common/mensagens.robot
Library         RequestsLibrary
Library         BuiltIn

*** Variables ***


*** Keywords ***
## Setup
Conectar na API
        ${headers}=        Create Dictionary        content-type=application/json                

        Create Session    alias=goRestAPI    url=${BASE_URL}        headers=${headers}        verify=true        disable_warnings=1        proxies=htpps

Status code deve ser
    [Arguments]        ${status_code_esperado}        ${response}
    Should Be Equal As Integers    ${status_code_esperado}    ${response.status_code}
    Log Many        Status code esperado: ${status_code_esperado} - Status code obtido: ${response.status_code}