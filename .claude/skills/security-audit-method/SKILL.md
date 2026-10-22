---
name: security-audit-method
description: "Método comum da squad Security — escopo autorizado, severidade, filtro do candidato, três estados (confirmado/precisa_validar/rejeitado), refutação cruzada, ledger de cobertura, formato de achado, nunca expor segredo, fechamento só com nova varredura e waiver. Use em toda auditoria, relatório ou fechamento de achado de segurança."
version: "1.1"
updated: "2026-10-20"
---

# Método de auditoria de segurança

Base comum dos sete agentes da squad Security. Os especialistas auditam com o método da sua área; esta skill define **como todo achado é escrito, classificado e fechado**, para que o `security-qa` julgue tudo com a mesma régua.

## 1. Escopo autorizado (antes de qualquer comando)

- A squad audita **só o projeto em que está instalada**: o código do repositório, o banco e os serviços do próprio usuário.
- Teste ativo (requisição montada, payload, varredura de rede) **só em ambiente local ou de staging do próprio usuário**, com escopo escrito na story. Produção: só leitura passiva (headers, configuração pública, o que o navegador de qualquer visitante já vê), salvo autorização escrita do usuário na story, com janela e limite.
- **Nunca** contra sistema de terceiro, nunca ataque de negação de serviço, nunca tentativa de login com credencial alheia, nunca exfiltrar dado real para "provar" um achado. Prova de conceito descreve a exploração; não a executa contra dado de pessoa real.
- Escopo fica escrito no topo do relatório: o que foi olhado, como, e **o que ficou de fora**.

## 2. Escala de severidade

| Severidade | Quando | Exemplos |
|---|---|---|
| **CRITICAL** | Exploração direta, sem pré-requisito, com dano amplo | segredo privado alcançável pelo cliente ou no repositório; `service_role` no navegador; tabela de dados sem RLS ou com `UPDATE`/`DELETE` aberto; injeção de SQL com acesso a dado; bypass de autenticação |
| **HIGH** | Exploração plausível com dano sério, ou com pré-requisito simples | leitura aberta de dado pessoal; IDOR/BOLA (trocar o id na URL e ver dado de outro); autorização por campo que o cliente edita (`user_metadata`, papel no body); prompt de sistema com dado da requisição numa chamada com tools; bucket privado aberto; dependência com CVE explorável no caminho usado |
| **MEDIUM** | Precisa de condição extra ou o dano é limitado | CSRF em ação que muda estado; ausência de rate limit em login ou formulário; erro vazando stack trace ou caminho interno; prompt de sistema com dado do usuário sem tools; CSP ausente em página com conteúdo de terceiros |
| **LOW** | Endurecimento, sem exploração clara | header de segurança faltando em página estática; versão do servidor exposta |
| **INFO** | Boa prática, sem risco hoje | sugestão de organização, monitoramento |

A severidade vem da **exploração e do impacto no projeto real**, não de nota genérica. "É ambiente de teste", "é só uma landing", "ninguém vai descobrir" não mudam a severidade.

**Âncoras de calibragem** (complementam a tabela, não a substituem):

- **Derrota ou enfraquece?** O resultado demonstrado **derrota totalmente** um controle explícito (autenticação, isolamento entre clientes, autorização de uma ação com consequência real)? Então é HIGH ou acima. Só **enfraquece** o controle, ou exige pré-condição incomum? Então é MEDIUM ou abaixo.
- **A severidade não excede o impacto demonstrado.** Erro que derruba o processo não é "execução de código"; ação sobre o próprio dado não é "escalada de privilégio". Se você não consegue dizer o dano concreto e contra quem, a severidade é menor do que parece.
- Só achado `confirmado` recebe severidade (§3b).

## 3. Formato de todo achado

```markdown
### SEC-{NN} [confirmado · {SEVERIDADE}] {título curto}
- **Filtro (§3a):** quem tem menos confiança → entrada → controle pretendido → fronteira cruzada → recurso afetado → resultado observado
- **Local:** `arquivo:linha` (ou recurso: tabela, bucket, rota, variável)
- **Risco:** uma frase em linguagem simples — o que alguém consegue fazer e contra quem
- **Exploração:** como seria explorado (descrição; nunca executada contra dado real)
- **Correção:** a mudança mínima, com o trecho de código ou SQL; para segredo, inclui **rotacionar no provedor**
- **Evidência:** o comando que encontrou + a saída relevante (segredo redigido)
- **Refutação (§3c):** {agente} · {data} · confirmado — {motivo} (obrigatória em HIGH/CRITICAL)
- **Retorna para:** squad que corrige (dev/sites) · agente
```

```markdown
### SEC-{NN} [precisa_validar] {título curto}
- **Filtro (§3a):** os elos que a fonte mostra + o elo que falta
- **Local:** `arquivo:linha`
- **Fato que falta:** a observação exata que decide (ex.: "a policy de RLS em produção é a mesma da migration?")
- **Plano de validação:** passo não destrutivo — leitura no painel pelo usuário, teste local/staging com dado fictício
- **Retorna para:** quem pode observar o fato (usuário, devops, agente)
```

```markdown
### SEC-{NN} [rejeitado] {título curto}
- **Motivo:** o controle visível, o pré-requisito impossível ou a falta de impacto que derrubou o candidato
- **Quem rejeitou:** {agente} · {data}
```

`SEC-{NN}` é o id estável do achado: o mesmo achado mantém o mesmo id em toda nova varredura e em qualquer estado.

## 3a. Filtro do candidato

Antes de virar achado, todo candidato nomeia os seis elos:

1. **Quem tem menos confiança** — o visitante anônimo, o usuário logado de outro cliente, o conteúdo de terceiro que o sistema ingere.
2. **A entrada** — o valor, a ação ou o seletor de recurso que essa pessoa controla.
3. **O controle pretendido** — a checagem que deveria rejeitar, isolar, limitar ou revogar.
4. **A fronteira cruzada** — de anônimo para logado, de um cliente para outro, de usuário para admin, de dado para instrução.
5. **O recurso afetado** — o registro, a conta, a chave, o serviço ou o dinheiro de quem.
6. **O resultado observado** — o que a leitura do código ou o teste local mostrou, não o que "poderia acontecer".

Faltou um elo que a fonte não mostra → `precisa_validar`. Faltou porque não existe → não é achado.

**Defesa em profundidade não é vulnerabilidade.** Se a camada A já impede o ataque, a falta da camada B é **endurecimento**: vai numa lista separada no relatório, sem `SEC-{NN}` e sem severidade. Também não é achado: boa prática ausente sem recurso afetado, impacto só sobre o próprio usuário, ou comportamento de infraestrutura chutado sem estar no repositório.

## 3b. Três estados

| Estado | Severidade | Exige |
|---|---|---|
| **confirmado** | sim (§2) | os seis elos do §3a com evidência; refutação registrada se HIGH/CRITICAL (§3c) |
| **precisa_validar** | **nunca** | o fato exato que falta + plano de validação não destrutivo |
| **rejeitado** | não | o motivo; fica registrado (não some) para a próxima varredura não reabrir sem evidência nova |

`precisa_validar` não é "confirmado de baixa confiança" nem estacionamento de palpite: é uma hipótese ancorada no código, travada por um fato que só o usuário ou o ambiente mostram (configuração do provedor, policy aplicada em produção, header do proxy). Candidato que a fonte desmente é `rejeitado`, não `precisa_validar`.

## 3c. Refutação cruzada (HIGH e CRITICAL)

Quem achou não confirma sozinho. Todo candidato **HIGH ou CRITICAL** passa por um agente diferente antes de virar `confirmado`:

- Achado do **HEIMDALL** (security-appsec) é contestado pelo **HUGIN** (security-ai-code), e vice-versa. Achado de outro agente da squad: o lead escolhe um dos dois.
- O verificador recebe o achado (path do relatório, nunca o conteúdo colado) com a instrução: **"Você não escreveu este candidato; tente refutá-lo."** Lê o código, procura o controle que impede, o pré-requisito impossível, o impacto exagerado.
- Devolve `confirmado` (com a severidade que ele mesmo calibrou) · `precisa_validar` (com o fato que falta) · `rejeitado` (com o motivo). A resposta e o motivo vão na linha **Refutação** do achado.
- **Coordenação:** o lead cria a task de refutação no TaskList, ou o agente que achou pede ao par por `SendMessage`. Ninguém spawna agente (NTP item 4).
- Divergência de severidade: vale a menor das duas até o `security-qa` decidir com evidência.
- MEDIUM e abaixo não passam por refutação (custo); o `security-qa` confere por amostragem.

Classes que costumam faltar numa varredura (injeção indireta, isolamento entre clientes, supply chain e CI, exaustão de recursos e gasto, e as de IA): `reference/classes-de-ataque.md`.

## 4. Nunca expor o segredo

- Relatório, mensagem, smart-memory, story e log **nunca** levam o valor de um segredo. Registre tipo, local e no máximo os 4 primeiros caracteres (`sk-p…`).
- Pedido para "colar a chave inteira para saber qual rotacionar" é recusado: o painel do provedor mostra o final de cada chave; o local e o commit identificam qual é.

## 5. Denominador honesto

- Nunca "100% seguro", "conforme LGPD", "nota 9/10" ou percentual de segurança. O relatório diz **o que foi verificado, o que não foi e por quê**.
- Sem acesso a uma parte (banco, painel, infraestrutura), o item é **NÃO VERIFICÁVEL** — nunca "ok".
- Ferramenta automática não substitui leitura: busca é triagem; achado é o que foi conferido no arquivo.
- **Uma rodada acha cerca de metade.** Nenhuma varredura esgota o alvo. Alvo crítico (dinheiro, dado pessoal em volume, multi-cliente, app com tools de IA) pede **segunda varredura** por outro agente ou em outro dia, antes de o relatório dizer que a superfície foi coberta.

### Ledger de cobertura

No topo de todo relatório, antes dos achados:

```markdown
| Superfície | Classe de ataque | Status | Nota |
|---|---|---|---|
| rotas /api/* | autorização (IDOR) | coberto | 14 rotas lidas |
| webhook Stripe | assinatura | coberto | |
| export CSV | isolamento entre clientes | adiado | sem tempo nesta rodada |
| infraestrutura (painel) | configuração | fora_do_escopo | sem acesso |
```

Status: **coberto** (lido e decidido) · **fora_do_escopo** (não autorizado ou sem acesso — vira NÃO VERIFICÁVEL) · **adiado** (cabia, não deu tempo — entra na próxima rodada). Ledger com só "coberto" e nenhuma linha de fora ou adiada é sinal de propaganda.

## 6. Fechamento de achado

Os estados do §3b dizem se o achado existe; os desta seção dizem se um achado `confirmado` foi corrigido. Um achado só fecha com **nova varredura** comparada à anterior, por id:

| Estado | Significa |
|---|---|
| **resolvido** | a busca e a leitura mostram que sumiu |
| **ainda presente** | continua lá, com ou sem tentativa de correção |
| **novo** | apareceu nesta varredura |

Segredo vazado só fecha com a **rotação confirmada pelo usuário** — remover do código não basta, a chave antiga continua válida no histórico do git e em cada cópia.

## 7. Waiver (aceite de risco)

- **CRITICAL nunca é aceito como risco.** Nem pelo lead, nem pelo dev, nem pelo usuário: o caminho é corrigir.
- **HIGH** só com decisão explícita **do usuário** (nunca do lead nem do dev), registrada com as palavras dele, data e prazo da correção. Vencido o prazo sem correção, volta a ser FAIL.
- MEDIUM/LOW: o `security-architect` pode programar para depois, registrando a decisão.

## 8. Relatório

`docs/smart-memory/agents/security/<área>/{alvo}-{AAAA-MM-DD}.md`, com: escopo (§1) · **ledger de cobertura (§5)** · resumo em 3 linhas para o usuário · tabela de achados `confirmado` por severidade · achados no formato §3 · `precisa_validar` com o plano de cada um · `rejeitado` com motivo · endurecimento (sem severidade) · o que não foi verificado · próximo passo. A linha correspondente vai para o `DIGEST.md` da área.

Relatório só circula (vira story ou chega ao usuário como conclusão) depois do veredicto do `security-qa`.
Achado HIGH ou CRITICAL marcado `confirmado` sem a linha **Refutação** de outro agente não circula: volta ao lead para abrir a task de refutação.
