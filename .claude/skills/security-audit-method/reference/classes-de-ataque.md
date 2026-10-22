# Classes de ataque que costumam faltar

Complemento do `security-audit-method` (§3a e §5). Cada classe entra no ledger de cobertura como linha própria — coberta, fora do escopo ou adiada. Toda classe passa pelo filtro do candidato: sem os seis elos, não é achado.

## Injeção indireta (segunda ordem)

O dado foi **salvo com segurança** e vira perigoso **depois**, num lugar que confia nele: o nome de campo que vira caminho de JSON, o slug que vira caminho de arquivo, o texto escapado que entra em renderização crua, a string salva que vira URL, regex, template ou filtro de consulta.
- Siga o dado do ponto de gravação até **cada** ponto de leitura — inclusive job em fila, relatório, e-mail e painel de admin.
- O achado nomeia as duas pontas: quem grava (menos confiança) e onde o valor é usado sem a codificação daquele destino.
- Escapar na entrada não protege o destino: cada destino (HTML, SQL, shell, URL) exige a própria codificação.

## Isolamento entre clientes, export e backup

O filtro por cliente (tenant) está na tela principal e falta num caminho paralelo.
- Confira o filtro **na própria consulta** e em cada chave de cache, busca, índice e analytics — campo `tenant_id` no registro não é controle se a consulta alternativa o omite.
- Export, snapshot e backup: um usuário de menor privilégio dispara export com dado acima do acesso dele? O arquivo inclui rascunho, apagado ou dado de outro cliente? O link do export é adivinhável ou não expira?
- Import e restore: respeitam a mesma permissão da tela, ou recriam registro em coleção alheia e restauram dado que já tinha sido apagado?
- Busca, filtro e ordenação que revelam a existência de registro alheio também cruzam a fronteira.

## Supply chain e CI

O código que roda não é só o do repositório: dependência, script de instalação, workflow de CI e passo de release também executam.
- Dependência: lockfile presente e usado no build; pacote com script `postinstall`; versão sem fixar; pacote abandonado ou com nome parecido com o oficial.
- CI: workflow disparado por pull request de fork com acesso a segredo (`pull_request_target`, `workflow_run`); action de terceiro sem fixar por hash; segredo impresso em log; permissão do token maior que a tarefa.
- Release: quem pode publicar, assinar ou promover; artefato gerado fora do CI.
- Só leitura do repositório e da configuração — nunca rodar workflow, publicar pacote ou mexer em registro.

## Exaustão de recursos e gasto do operador

Uma requisição barata para quem ataca gera trabalho caro para quem opera: CPU, memória, disco, fila, conexões e **dinheiro**.
- Apps com LLM: rota que chama o modelo sem autenticação, sem limite por usuário e sem teto de tokens ou de chamadas por pedido; agente em laço que pode repetir tool paga; upload grande que vira embedding.
- Também: consulta sem paginação, regex sobre entrada livre, upload sem limite de tamanho, envio de e-mail/SMS sem limite.
- Prova só pela leitura do código e um laço local limitado — **nunca** estressar serviço real nem gastar cota paga.
- Gasto do operador é impacto real: nomeie o custo por requisição e quem paga.

## IA — memória envenenada

Conteúdo de quem tem menos confiança (ou um resumo feito pelo modelo) é gravado numa memória que depois molda a tarefa de **outro** usuário ou de uma sessão privilegiada.
- Quem pode criar, atualizar, mesclar e apagar memória? Ela é separada por usuário e por cliente? Observação de baixa confiança vira instrução ou "fato" durável?
- O achado cita as duas pontas: a gravação controlada pelo atacante e a leitura posterior por outro principal ou numa decisão privilegiada.
- Memória que o próprio usuário salvou e usa só para os próprios pedidos não cruza fronteira.

## IA — vínculo entre ação e tool

O usuário aprovou uma ação, mas a execução usa outro argumento, outro recurso, outra pessoa ou um turno posterior do modelo. Também: conteúdo de terceiro (e-mail, página, documento) faz o agente agir com a autoridade da vítima sem ela ter pedido aquela ação.
- A confirmação amarra o nome da tool, **todos** os argumentos já normalizados, quem pediu, o alvo, o valor e a validade? Retry ou sessão retomada reaproveitam a aprovação para outra ação?
- O handler da tool checa de novo a permissão de quem pediu sobre aquele recurso, ou usa a credencial ampla do serviço?
- Autorização genérica não prova intenção: "o usuário podia fazer isso" não basta se ele não pediu.

## IA — identidade de MCP e de sub-agente

Chamadas e respostas são roteadas por nome de servidor, nome de tool, id de requisição ou alias escolhido pelo modelo, em vez da conexão autenticada.
- Dois servidores MCP podem declarar a mesma tool ou recurso? Reconectar troca o vínculo? A resposta de um servidor pode atender a chamada pendente de outro?
- Descrição de tool, metadado e schema vindos do servidor MCP orientam o modelo, mas **não concedem permissão**: ache a allowlist e a checagem no handler que valem mesmo quando o metadado mente.
- Sub-agente recebe a sessão, a credencial ou a memória inteira em vez do mínimo da tarefa? O resultado que ele devolve é tratado como entrada não confiável?
- Identidade externa ou roteamento de implantação que não estão no repositório → `precisa_validar`.

Adaptado, com texto próprio, de cloudflare/security-audit-skill (MIT).
