# Empurrar rankings a partir do Search Console

A auditoria acha o que está quebrado. Esta referência cobre o passo seguinte: levar para a primeira página o que **já ranqueia** e lançar página nova já com o necessário para ser encontrada. As duas coisas custam menos do que ganhar uma query do zero, porque o Google já considera o site relevante para o tema.

**Quem faz o quê:**
- **SESHAT** (`seo-google`) é dona dos números: puxa o GSC, monta a lista de candidatos e grava cada linha na ficha `docs/smart-memory/agents/seo/numeros.md` com `#id` (posição, impressões, CTR, período).
- **HORUS** (`seo-sxo`) faz o diagnóstico contra o top 3 (seção "Diagnóstico contra o top 3" da skill `seo-sxo`).
- **THOTH** (`seo-architect`) transforma os candidatos priorizados em stories com critério de aceite.
- **MAAT** (`seo-qa`) dá o veredicto antes de a lista ou a recomendação chegar ao cliente.

## 1. Achar os candidatos

No Search Console, puxe pares query + página dos **últimos 28 dias** e compare com os 28 dias anteriores, para descartar picos (`gsc_query.py`, ver `/seo google gsc`).

| Faixa | Filtro | Tipo de correção |
|---|---|---|
| **Distância de ataque** | Posição média 8–20 e impressões acima de um piso que faça sentido para o site (definido com o usuário e registrado na ficha) | Conteúdo e links |
| **CTR fraco** | Posição 1–5 e CTR bem abaixo das outras páginas do mesmo site em posições parecidas | Só title e meta description |
| **Perto do topo** | Posição 4–7 em query ligada a receita (demo, orçamento, compra) | Conteúdo, links e formato de featured snippet |

**Prioridade por valor de negócio, não por volume.** Uma query na posição 11 que gera pedidos de demonstração vale mais do que um termo de glossário na posição 9 com o triplo de impressões. O valor de negócio vem do usuário ou da squad do canal; SESHAT não o inventa.

**Antes de mexer, cheque canibalização.** Se duas páginas do site ranqueiam para a mesma query, a posição costuma alternar entre elas e nenhuma sobe. Escolha uma dona, leve para ela o que a outra tem de útil e redirecione (a implementação é da squad sites).

Saída da SESHAT: tabela com `#id` por linha (query, página, faixa, posição, impressões, CTR, período), status `CONFIRMADO` quando veio do GSC.

## 2. Diagnosticar contra o top 3

Feito por HORUS, com as cinco causas da seção "Diagnóstico contra o top 3" em `seo-sxo/SKILL.md`: intenção, seção ausente, frescor, formato e links. **Se não dá para nomear a causa, não reescreva:** a diferença tende a ser autoridade, e o caminho é link (skill `seo-backlinks`, agente ANUBIS), não conteúdo.

## 3. Fazer a menor mudança que fecha a diferença

- **Responda a query nas duas primeiras frases** e depois aprofunde. É também o trecho que AI Overviews e assistentes costumam citar.
- **Acrescente a seção que falta**, sem reescrever a página inteira. Página que já ranqueia tem sinais que valem ser preservados.
- **Query no title e no H1** se ficar natural. Se já está alinhado, não mexa.
- **Links internos para a página** a partir das páginas mais fortes do mesmo tema, com âncora que descreve o destino. Costuma ser a maior alavanca isolada e a mais esquecida.
- **Atualize o que envelheceu:** dados, prints, ano, links quebrados.
- **Na faixa CTR fraco, mude só title e meta description**, nada mais, para o efeito ser atribuível. Regras de title e meta em `seo-page`.

## 4. Disciplina de atribuição

1. **Antes da mudança**, SESHAT registra posição, impressões e CTR iniciais da query + página, com `#id` e período.
2. **Uma mudança por vez** por página. Na faixa CTR fraco, só title/meta.
3. **Espere 3–4 semanas** antes de julgar ou mexer de novo. Ranking leva tempo para assentar, e mudanças empilhadas impedem saber o que funcionou.
4. **Leia o depois** com a mesma janela e o mesmo filtro; a comparação vira nova linha na ficha.
5. **Pare depois de 2 rodadas sem efeito.** A página provavelmente está limitada por intenção (o Google quer outro tipo de página: caso para HORUS) ou por autoridade (caso para ANUBIS). Mais ajuste on-page não resolve nenhum dos dois.

## 5. Checklist de página nova

Página nova deve nascer com o que precisa para ser encontrada, em vez de passar meses órfã:

- [ ] Links internos de pelo menos **3 páginas relevantes** já existentes, com âncora descritiva
- [ ] Title e meta description únicos, alinhados à query-alvo
- [ ] Um único H1, alinhado ao title
- [ ] **Canonical** apontando para ela mesma
- [ ] Incluída no **sitemap XML** (`seo-sitemap`)
- [ ] Dados estruturados quando o tipo de página suporta (`seo-schema`)
- [ ] Conteúdo principal presente no **HTML entregue pelo servidor**, não só depois de o JavaScript rodar (`seo-technical`)
- [ ] Indexável: sem `noindex` perdido, sem bloqueio no robots.txt
- [ ] Ligada ao caminho de conversão certo (`sites-page-cro`)

Depois de publicada, peça indexação **uma vez** no Search Console (ou via `/seo google index` quando o tipo de página é elegível à Indexing API). **Não reenvie:** pedir de novo não acelera nada. Se em algumas semanas a página não estiver indexada, SESHAT roda a inspeção de URL (`/seo google inspect`) e a causa vai para PTAH (`seo-technical`), em vez de reenviar.

## 6. Cadência

THOTH decide se o empurrão vira rotina (por exemplo, leitura mensal das três faixas) e a coloca no roadmap da squad. Cada rodada repete: lista da SESHAT com `#id` → diagnóstico da HORUS → story da THOTH → veredicto da MAAT → leitura do depois após 3–4 semanas.

---

Adaptado de `seo-audit/references/rankings-push.md`, coreyhaines31/marketingskills (MIT).
