*** Settings ***
Resource        ../../resources/common/commonResource.robot
Library         RequestsLibrary

*** Variables ***

*** Keywords ***
Enviar uma requisição POST no endpoint de users
        [Arguments]        ${usuario}        ${headers}        
        ${response}=        POST On Session        alias=goRestAPI        url=${ENDPOINT_USERS}        
        ...                                        json=${usuario}        headers=${headers}        expected_status=any
        [Return]        ${response}

Enviar uma requisição GET no endpoint de users
        [Arguments]        ${id_usuario}        ${headers}
        ${response}=        GET On Session        alias=goRestAPI        url=${ENDPOINT_USERS}/${id_usuario}
        ...                                       headers=${headers}        expected_status=any
        [Return]        ${response}

Enviar uma requisição PUT no endpoint de users
        [Arguments]        ${id_usuario}        ${request_body}        ${headers}
        ${response}=        PUT On Session        alias=goRestAPI        url=${ENDPOINT_USERS}/${id_usuario}        
        ...                                        json=${request_body}        headers=${headers}        expected_status=any
        [Return]        ${response}

Enviar uma requisição DELETE no endpoint de users
        [Arguments]        ${id_usuario}        ${headers}
        ${response}=        DELETE On Session        alias=goRestAPI        url=${ENDPOINT_USERS}/${id_usuario}
        ...                                       headers=${headers}        expected_status=any
        [Return]        ${response}