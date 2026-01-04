import requests
import getpass
import json
import os
import glob

with open('textos_para_o_portal/config.json', 'r') as config_file:
    config = json.load(config_file)
# Configurações da API

usuario = config["usuario"]
site = config["site"]
url = f"{site}/wp-json/wp/v2/posts"
senha_aplicacao = config["senha_aplicacao"]

print("Opções disponíveis:\n 1 - Listar posts\n 2 - Criar posts automaticamente\n 3 - Deletar post")
opcao_escolhida = input("Selecione a opção desejada e pressione Enter para continuar: ")
padrao = os.path.join("textos_para_o_portal", "post.*.txt")
arquivos = [os.path.abspath(f) for f in glob.glob(padrao)]

def processar_linhas_arquivo(caminho_arquivo):
    try:
        with open(caminho_arquivo, 'r', encoding='utf-8') as arquivo:
            # Transforma cada linha do arquivo em um objeto string dentro de uma lista
            linhas = arquivo.readlines()

        total_linhas = len(linhas)

        if total_linhas >= 2:
            print(f"O arquivo possui título OK")
        else:
            print("O arquivo não possui uma segunda linha.")

        if total_linhas >= 4:
            print("Arquivo com conteúdo OK")
        else:
            print("\nO arquivo tem menos de 4 linhas.")

        novo_post = {
            "title": "",
            "content": "",
            "status": "publish"
        }

        novo_post["title"] = linhas[1].strip()
        novo_post["content"] = "".join(linhas[3:]).strip()
        print(novo_post)
        return novo_post

    except FileNotFoundError:
        print("Erro: Arquivo não encontrado.")
    except Exception as e:
        print(f"Ocorreu um erro: {e}")

if opcao_escolhida == "1":
    try:
        # Executa o comando GET com autenticação Basic Auth
        response = requests.get(url, auth=(usuario, senha_aplicacao))

        # Verifica se a requisição foi bem-sucedida (Status 200)
        response.raise_for_status()

        # Converte o resultado para JSON
        posts = response.json()

        # Exemplo: listar o título dos posts encontrados
        for post in posts:
            print(f"ID: {post['id']} - Título: {post['title']['rendered']}")

    except requests.exceptions.RequestException as e:
        print(f"Erro na requisição: {e}")

elif opcao_escolhida == "2":
    # Dados do novo post
    for item in arquivos:
        print(f"Criando post usando o conteúdo do arquivo {item}")
        
        novo_post = processar_linhas_arquivo(item)

        try:
            # Executa o comando POST com autenticação Basic Auth
            response = requests.post(url, json=novo_post, auth=(usuario, senha_aplicacao))

            # Verifica se a requisição foi bem-sucedida (Status 201)
            response.raise_for_status()

            # Converte o resultado para JSON
            post_criado = response.json()
            print(f"Post criado com sucesso! ID: {post_criado['id']} - Título: {post_criado['title']['rendered']}")

        except requests.exceptions.RequestException as e:
            print(f"Erro na requisição: {e}")

elif opcao_escolhida == "3":
    post_id = input("Digite o ID do post que deseja deletar: ")

    try:
        # Executa o comando DELETE com autenticação Basic Auth
        delete_url = f"{url}/{post_id}?force=true"
        response = requests.delete(delete_url, auth=(usuario, senha_aplicacao))
        if response.status_code == 404:
            print("Post não encontrado. Verifique o ID e tente novamente.")
            exit()
        elif response.status_code == 200:
            print(f"Post {post_id} deletado com sucesso!")

    except requests.exceptions.RequestException as e:
        print(f"Erro na requisição: {e}")

else:
    print("Opção inválida. Por favor, selecione uma opção válida.")