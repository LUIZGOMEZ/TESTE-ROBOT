*** Settings ***
Library        FakerLibrary
Library        BuiltIn
Resource    ../user-resources/userResources.robot

*** Variables ***
@{generos}=        male        female
@{status_validos_usuario}=        active    inactive
@{status_validos_todos}=        pending        completed

*** Keywords ***
Gerar dados de usuário
    ${nome}=        Gerar nome
    ${email}=       Gerar email
    ${genero}=      Gerar gênero
    ${status}=      Gerar status de usuário

    ${usuario}=        Create Dictionary        name=${nome}       email=${email}        gender=${genero}        status=${status} 
    [Return]        ${usuario}

Gerar nome
    ${nome}=        FakerLibrary.Name
    [Return]        ${nome}

Gerar email
    ${email}=        FakerLibrary.Email
    [Return]    ${email}

Gerar gênero
    ${genero}=        Evaluate        random.choice(${generos})        random
    [Return]        ${genero}

Gerar status de usuário
    ${status_usuario}=        Evaluate    random.choice(${status_validos_usuario})        random
    [Return]        ${status_usuario}

Gerar título
    ${titulo}=        FakerLibrary.Text        max_nb_chars=50
    [Return]        ${titulo}

Gerar texto para body
    ${texto_body}=        FakerLibrary.Text        max_nb_chars=200
    [Return]        ${texto_body}

Gerar status de todo
    ${status_todo}=        Evaluate    random.choice(${status_validos_todos})    random
    [Return]        ${status_todo}

Cadastrar usuário
    [Arguments]        ${usuario}
    ${headers}=        Create Dictionary         content-type=application/json        Authorization=Bearer ${token}
    ${usuario_cadastrado}=        Enviar uma requisição POST no endpoint de users        ${usuario}        ${headers}        
    [Return]        ${usuario_cadastrado}