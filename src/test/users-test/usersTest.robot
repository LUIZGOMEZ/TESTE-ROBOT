*** Settings ***
Resource        ../../resources/common/commonResource.robot
Library         BuiltIn
Library         Collections
Library         JSONLibrary
Library         RPA.JSON
Suite Setup        Conectar na API

*** Test Cases ***
PAM_01 - Deve cadastrar novo usuário quando todos os dados enviados na requisição são válidos
        [Documentation]        Caso de Teste pra validar cadastro positivo de usuário
        [Tags]        positivo        cadastroUsuario        smoke

        ${headers}=        Create Dictionary         content-type=application/json        Authorization=Bearer ${token}
            
        ${usuario_a_cadastrar}=        Gerar dados de usuário

        ${usuario_cadastro}=        Enviar uma requisição POST no endpoint de users        ${usuario_a_cadastrar}           ${headers}

        Status code deve ser        201       ${usuario_cadastro}
        Dictionary Should Contain Key    ${usuario_cadastro.json()}    id
        
        ## Peguei o valor, converti pra String e ai fiz a comparação. A keyword Should not be empty verifica 
        ## tamanho do valor do item que é passado pra ela, portanto precisa passar como String
        ${id}=       JSONLibrary.Get Value From Json    ${usuario_cadastro.json()}    id
        ${id}=       Convert To String    ${id[0]} 
        Should Not Be Empty    ${id}

        Dictionary Should Contain Item    ${usuario_cadastro.json()}    name    ${usuario_a_cadastrar["name"]}
        Should Be Equal As Strings    ${usuario_cadastro.json()["email"]}    ${usuario_a_cadastrar["email"]}
        Dictionary Should Contain Item    ${usuario_cadastro.json()}    gender    ${usuario_a_cadastrar["gender"]}
        Dictionary Should Contain Item    ${usuario_cadastro.json()}    status    ${usuario_a_cadastrar["status"]}

PAM_02 - Não deve cadastrar usuário com email que já esteja cadastrado na API
        [Documentation]        Caso de Teste pra validar que dois usuários não são cadastrados com mesmo email
        [Tags]        negativo        cadastroUsuario        smoke

        ${headers}=        Create Dictionary         content-type=application/json        Authorization=Bearer ${token}

        ${primeiro_usuario}=        Gerar dados de usuário

        ${email}=        JSONLibrary.Get Value From Json    ${primeiro_usuario}    email
        Log    ${email[0]}

        ${primeiro_cadastro}=        Enviar uma requisição POST no endpoint de users    ${primeiro_usuario}    ${headers}
        
        ${segundo_usuario}=        Gerar dados de usuário
        Log    ${segundo_usuario}
        ${segundo_usuario}=        JSONLibrary.Update Value To Json    ${segundo_usuario}    $.email    ${email[0]}
        Log    ${segundo_usuario}

        ${segundo_cadastro}=        Enviar uma requisição POST no endpoint de users    ${segundo_usuario}    ${headers}

        Status code deve ser    422    ${segundo_cadastro}

        ## body é retornado como um array body=[{"field":"email","message":"has already been taken"}] 
        ## por isso preciso descer mais um nível no json com o $.. e não somente $.
        ${campos}=        RPA.JSON.Get values from JSON    ${segundo_cadastro.json()}    $..field[*]
        Log    ${campos}
        List Should Contain Value    ${campos}    email

        ${mensagens}=       RPA.JSON.Get values from JSON    ${segundo_cadastro.json()}    $..message[*]
        Log    ${mensagens}
        List Should Contain Value    ${mensagens}    ${valor_duplicado}

PAM_03 - Deve retornar todos os usuários cadastrados na API
        [Documentation]        Caso de Teste pra validar que todos os usuários cadastrados na API são retornados
        [Tags]        positivo        buscaUsuario        smoke

        ${headers}=        Create Dictionary         content-type=application/json

        ${lista_usuarios}=        Enviar uma requisição GET no endpoint de users    ${EMPTY}    ${headers}
        ## O QUE VALIDAR? O QUE FALTA NO TESTE PARA GARANTIR QUE TERÁ LISTA DE USUÁRIOS?
