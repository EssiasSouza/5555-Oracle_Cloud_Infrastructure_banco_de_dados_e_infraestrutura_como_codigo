# Oracle Cloud Infrastructure: Banco de Dados e Infraestrutura como Código

Este repositório contém os códigos, exemplos e materiais de apoio utilizados no curso **Oracle Cloud Infrastructure: Banco de Dados e Infraestrutura como Código**, da plataforma **Alura**.

O objetivo do curso é apresentar, de forma prática, como provisionar e gerenciar recursos de **banco de dados na OCI**, aplicando conceitos de **Infraestrutura como Código (IaC)**, automação e boas práticas de cloud computing.

---

## 🗂 Estrutura do repositório

A organização dos arquivos acompanha a evolução das aulas:

```
├── portal-cloud-wp-theme/
│   └── assets/
│       └── js/
│           └── preloader.js
│   └── footer.php
│   └── functions.php
│   └── header.php
│   └── index.php
│   └── single.php
│   └── style.css
├── textos_para_o_portal/
│   └── 0-guia.md # Guia de utilização da aplicação que consome a API do WordPress
│   └── autopost.py
│   └── config.json
│   └── post_automatico.txt
│   └── post.1.txt
│   └── post.2.txt
│   └── post.3.txt
├── wp-plugins/
│   └── enable-app-passwords-dev.php
├── .gitignore
├── portal-cloud-wp-theme.zip
├── README.md
└── requirements.txt
```
## 🧰 Tecnologias e serviços utilizados

- Oracle Cloud Infrastructure (OCI)
- Bancos de dados gerenciados da OCI
- Infraestrutura como Código (IaC)
- Conceitos de Cloud Computing
- Automação de infraestrutura

---

## 🚀 Pré-requisitos

Para aproveitar melhor o curso, é recomendável que você tenha:

- Noções básicas de computação em nuvem
- Familiaridade com linha de comando
- Conhecimentos básicos sobre bancos de dados
- Conta ativa na **Oracle Cloud Infrastructure** (Free Tier é suficiente)
- E ter completado o curso `5247 - Oracle Cloud Infrastructure implantação de uma aplicação na nuvem`.

---

## Comandos e códigos necessários
```
sudo rm /etc/apache2/sites-available/000-default.conf
sudo nano /etc/apache2/sites-available/000-default.conf
```
```
<VirtualHost *:80>
    ServerName seu_dominio.com.br
    ServerAlias www.seu_dominio.com.brr

    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/www/html/seu_dominio.com.br_error.log
    CustomLog /var/www/html/seu_dominio.com.br.log combined
</VirtualHost>
```
### Forçar o WordPress responder no endereço desejado
```
sudo nano /var/www/html/wp-config.php
```
```
define('WP_HOME', 'https://site.com');
define('WP_SITEURL', 'https://site.com');

/* That's all, stop editing! Happy publishing. */
```
### Forçar o WordPress enviar os caminhos como https
```
sudo nano /var/www/html/wp-config.php
```
```
define('FORCE_SSL_ADMIN', true);
define('FORCE_SSL_LOGIN', true);

// Reconhecer HTTPS atrás do Load Balancer (OCI)
if (
    isset($_SERVER['HTTP_X_FORWARDED_PROTO']) &&
    $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https'
) {
    $_SERVER['HTTPS'] = 'on';
}
```

### Forçar o Rewrite no .htaccess

```
sudo rm /var/www/html/.htaccess
sudo nano /var/www/html/.htaccess
```
```
# REST API fix
RewriteEngine On

RewriteRule ^wp-json/?$ index.php?rest_route=/ [QSA,L]
RewriteRule ^wp-json/(.*)$ index.php?rest_route=/$1 [QSA,L]

# WordPress padrão
RewriteRule ^index\.php$ - [L]

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]

# BEGIN WordPress
# The directives (lines) between "BEGIN WordPress" and "END WordPress" are
# dynamically generated, and should only be modified via WordPress filters.
# Any changes to the directives between these markers will be overwritten.
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>

# END WordPress
```
## Comandos cURL
- Listar posts
```
curl -i http://seusite.com.br/wp-json/wp/v2/posts/ \
  -u "USUÁRIO_WP:SENHA_DA_APLICACAO"
```
- Criar posts
```
curl -X POST http://seusite.com.br/wp-json/wp/v2/posts \
  -u "USUÁRIO_WP:SENHA_DA_APLICACAO" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "First post via API",
    "content": "Este conteúdo foi publicado usando a API do WordPress sem usar o WP-ADMIN.",
    "status": "publish"
  }'
```
- Deletar posts
```
curl -X DELETE http://seusite.com.br/wp-json/wp/v2/posts/NUMBER_ID_OF_YOUR_POST?force=true \
  -u "USUÁRIO_WP:SENHA_DA_APLICACAO" \
```

## 📝 Observações importantes

- Este repositório é **educacional** e acompanha exclusivamente o curso.
- Os exemplos foram criados com foco em aprendizado e **não devem ser utilizados diretamente em produção** sem adaptações.
- Custos podem ser gerados caso recursos sejam criados fora do Free Tier.

---

## 📖 Sobre a Alura

A **Alura** é uma plataforma de ensino online focada em tecnologia, com cursos atualizados e voltados para o mercado de trabalho.

👉 https://www.alura.com.br

---

## 📄 Licença

Este projeto é distribuído apenas para fins educacionais, conforme os termos da plataforma Alura.
