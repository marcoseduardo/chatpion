# Guia de implantação e desempenho (OVH + RunCloud + LiteSpeed)

Este guia resume como configurar o ChatPion em uma VPS da OVH usando LiteSpeed + RunCloud, com MySQL 8 hospedado em um servidor separado e suporte opcional a Redis para sessões e cache.

## Configuração básica da aplicação
1. **Base URL**: defina a variável de ambiente `APP_BASE_URL` com o domínio/URL público (por exemplo, `https://exemplo.com/`). O CodeIgniter usará automaticamente esse valor no `config.php`.
2. **Logs**: defina `APP_LOG_THRESHOLD` para controlar o nível de log (0 desliga, 1-4 ativa). Para produção, use 1 ou 2.

## Banco de dados MySQL em servidor dedicado
1. No painel da RunCloud, crie as credenciais de banco ou reutilize as existentes no servidor de banco de dados.
2. Exporte variáveis de ambiente no host da aplicação (RunCloud → *Environment Variables* ou via `~/.bashrc`):
   ```bash
   export DB_HOST="<ip_ou_fqdn_do_mysql>"
   export DB_PORT=3306
   export DB_NAME="<nome_do_banco>"
   export DB_USERNAME="<usuario>"
   export DB_PASSWORD="<senha>"
   # Opcional
   export DB_PERSISTENT=1          # Conexões persistentes
   export DB_CACHE=1               # Cache de consultas do CI (requer diretório gravável)
   export DB_SAVE_QUERIES=0        # Desative em produção para economizar memória
   ```
3. Reinicie o PHP (ou o serviço LiteSpeed/LSAPI) para aplicar as variáveis.
4. Garanta que o firewall do servidor do banco permita conexões apenas do IP do servidor de aplicação.

## Redis (opcional, recomendado)
1. Ative uma instância Redis no servidor de aplicação ou em outro host dedicado.
2. Instale a extensão PHP `redis` (RunCloud → *PHP Extensions* ou `apt install php-redis`).
3. Adicione variáveis de ambiente:
   ```bash
   export REDIS_HOST="127.0.0.1"
   export REDIS_PORT=6379
   export REDIS_PASSWORD="<senha_se_houver>"
   ```
4. No CodeIgniter, configure sessões e cache para usar Redis:
   - No `application/config/config.php`, defina:
     ```php
     $config['sess_driver'] = 'redis';
     $config['sess_save_path'] = "tcp://" . getenv('REDIS_HOST') . ":" . getenv('REDIS_PORT') . (getenv('REDIS_PASSWORD') ? "?auth=" . getenv('REDIS_PASSWORD') : '');
     ```
   - Ative cache de saída/fragmentos quando possível para páginas estáticas.

## Ajustes de desempenho recomendados
- **LiteSpeed Cache**: habilite o LSCache no RunCloud com regras para páginas que podem ser servidas a usuários não autenticados. Evite cache para rotas de APIs autenticadas.
- **PHP-FPM/LSAPI**: configure *max children*, *memory limit* e *request timeout* conforme a carga esperada. Monitore uso de memória ao ativar conexões persistentes.
- **Compressão e headers**: garanta que gzip/brotli estejam ativos e que headers de cache para assets estáticos (`assets/`, `js/`, `plugins/`, etc.) usem expiração longa.
- **Banco de dados**: use índices adequados (verifique consultas lentas no log do MySQL). Desative `DB_SAVE_QUERIES` em produção para economizar memória.
- **Logs**: mantenha `APP_LOG_THRESHOLD` baixo em produção para reduzir I/O.
- **Segurança**: limite acesso ao Redis e ao MySQL por firewall; use senha no Redis.

## Checklist de funcionamento
- [ ] Variáveis de ambiente definidas (`APP_BASE_URL`, `DB_*`, opcionais `REDIS_*`).
- [ ] Serviço PHP/LSAPI reiniciado após alterações de ambiente.
- [ ] Permissões de escrita para diretórios `application/cache/` e `application/logs/` se cache de consultas ou logs estiverem ativos.
- [ ] Rede liberada entre servidor de aplicação e banco de dados (porta 3306) e entre aplicação e Redis (6379, se usado).
