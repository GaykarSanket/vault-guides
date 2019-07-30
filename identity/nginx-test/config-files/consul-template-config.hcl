vault {
      renew_token = false
      vault_agent_token_file = "/home/vault/.vault-token"
      retry {
        backoff = "1s"
      }
    }

    template {
      destination = "/etc/secrets/config.template.ini"
      contents = <<EOH

      [DATABASE]
      Database={{ .Values.dbname}}
      {{"{{- with secret \"secret/dev/test/config\" }}"}}
      PostGresUser={{"{{ .Data.username }}"}}
      PostGresPassword={{"{{ .Data.password }}"}}
      {{"{{ end }}"}}

      EOH
    }

    template {
      destination = "/etc/secrets/index.html"
      contents = <<EOH
      <html>
      <body>
      <p>Some secrets:</p>
      {{"{{- with secret \"secret/dev/test/config\" }}"}}
      <ul>
      <li><pre>username: {{"{{ .Data.username }}"}}</pre></li>
      <li><pre>password: {{"{{ .Data.password }}"}}</pre></li>
      </ul>
      {{"{{ end }}"}}
      </body>
      </html>
      EOH
    }
