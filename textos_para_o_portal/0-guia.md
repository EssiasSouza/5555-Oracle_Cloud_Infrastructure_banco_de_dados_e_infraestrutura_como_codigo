# Instruções para teste de API fazendo Posts Automatizados no WordPress (Python & cURL)

Este projeto demonstra como **listar, criar e deletar posts no WordPress** utilizando a **WordPress REST API**, de duas formas:

- ✅ Automação via **script Python**
- ✅ Execução manual via **comandos `curl`**

O objetivo é permitir a publicação de conteúdo **sem acesso ao WP-ADMIN**, usando autenticação segura por **Application Password**.

---

## 📁 Estrutura do Projeto

```
.
├── textos_para_o_portal/
│   ├── 0-guia.md
│   ├── autopost.py
│   ├── config.json
│   ├── post.001.txt
│   ├── post.002.txt
│   └── ...
```

---

## Pré-requisitos

### Ambiente local

* Python 3.8+
* Biblioteca `requests`
* `curl` (opcional, para uso manual)

Instalação da dependência Python:

```
pip install requests
```

---

## 📄 Arquivo de Configuração

Crie o arquivo `textos_para_o_portal/config.json`:

```json
{
  "site": "http://seusite.com",
  "usuario": "SEU_USUARIO",
  "senha_aplicacao": "SENHA_DE_APLICACAO"
}
```

⚠️ **Nunca versionar este arquivo em repositórios públicos.**

---

## 📝 Padrão dos Arquivos de Post

Os arquivos devem seguir o formato:

```
Linha 1 → ignorada
Linha 2 → Título do post
Linha 3 → ignorada
Linha 4+ → Conteúdo do post
```

Exemplo (`post.001.txt`):

```
TÍTULO DO POST
Meu primeiro post via API
CONTEÚDO
Este é o conteúdo do post.
Pode conter múltiplas linhas.
```

---

## 🐍 Uso via Script Python

Execute o script:

```
python autopost.py
```

Menu disponível:

```
1 - Listar posts
2 - Criar posts automaticamente
3 - Deletar post
```

### ✔ Listar posts

Exibe ID e título dos posts existentes.

### ✔ Criar posts

* Lê todos os arquivos `post.*.txt`
* Publica automaticamente no WordPress
* Status padrão: `publish`

### ✔ Deletar post

* Solicita o ID do post
* Remove definitivamente (`force=true`)

---

## Uso via cURL (sem Python)

### 🔎 Listar posts (GET)

```
curl -X GET https://SEU_SITE/wp-json/wp/v2/posts \
  -u "SEU_USUARIO:SENHA_DE_APLICACAO"
```

---

### ➕ Criar post (POST)

```
curl -X POST https://SEU_SITE/wp-json/wp/v2/posts \
  -u "SEU_USUARIO:SENHA_DE_APLICACAO" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Título do Post",
    "content": "Conteúdo do post criado via cURL",
    "status": "publish"
  }'
```

---

### ❌ Deletar post (DELETE)

```
curl -X DELETE https://SEU_SITE/wp-json/wp/v2/posts/ID_DO_POST?force=true \
  -u "SEU_USUARIO:SENHA_DE_APLICACAO"
```

---

## 🚀 Possíveis Evoluções

* Publicar posts como `draft`
* Agendamento automático
* Integração com CI/CD
* Execução em OCI Functions ou GitHub Actions
* Validação de HTML e SEO

---

## 📚 Referências

* WordPress REST API
  [https://developer.wordpress.org/rest-api/](https://developer.wordpress.org/rest-api/)

---
## 📄 Licença

Este projeto é distribuído apenas para fins educacionais, conforme os termos da plataforma Alura.