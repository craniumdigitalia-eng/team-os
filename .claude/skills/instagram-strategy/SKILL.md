---
name: instagram-strategy
description: "Método de estratégia orgânica no Instagram — pilares, papel de cada formato (Reels, carrossel, Stories, feed), mix e cadência sustentável, pauta/calendário com ângulo por slot, rodada de interação e leitura de outliers pela mediana da conta; Facebook e Threads como extensões. Use ao planejar a conta, montar a pauta da semana ou do mês ou revisar a estratégia com base em resultado."
version: "1.0"
updated: "2026-10-20"
---

# Instagram Strategy — da tese da conta à pauta da semana

Usada por VERA (instagram-strategist), que decide e aprova a pauta, e por LYRIS (instagram-content), que escreve dentro do ângulo aprovado. Esta skill não escreve peça nem publica: ela decide **o que entra**, **em que formato** e **por quê**.

## 0. Antes de começar: o que ler

1. **Marca:** squad brand se instalada (plataforma, voz, mensagens); senão `docs/smart-memory/project/marketing-context.md`. Sem nenhum dos dois, pergunte as quatro coisas da seção 1 e registre.
2. **Histórico da conta:** relatório mais recente do instagram-publisher em `docs/smart-memory/agents/instagram/publisher/` (múltiplos sobre a mediana, envios/alcance).
3. **Pauta anterior:** a das últimas duas semanas, para não repetir ângulo.

## 1. A tese da conta (uma vez, revisada por trimestre)

Responda por escrito, em `docs/smart-memory/agents/instagram/strategy/`:

1. **O que a conta vende e para quem** — uma frase, sem adjetivo.
2. **Por que alguém segue** — o que a pessoa ganha por ver os posts (aprender X, ver Y acontecendo, rir de Z).
3. **Pilares** — 3 a 5 temas pelos quais a conta quer ser lembrada. Cada pilar liga a algo que a conta vende ou defende; pilar que não liga a nada é hobby.
4. **De onde vêm as histórias** — o que acontece de verdade na semana (cliente, número, erro, coisa construída). Pauta sem matéria-prima real vira opinião genérica.

## 2. O papel de cada formato

| Formato | Trabalho principal | Quando usar |
|---|---|---|
| **Reels** | Alcance — chegar em quem não segue | Maioria da pauta de crescimento; uma ideia por Reel |
| **Carrossel** | Profundidade e salvamento — aprofundar com quem já segue | Passo a passo, comparação, checklist, bastidor com dado |
| **Stories** | Relação diária — manter quem segue por perto | Todo dia, 3 a 5 quadros; enquete, caixa de pergunta, bastidor |
| **Post estático (feed)** | Anúncio, marco, citação | Pouco; quando a imagem sozinha carrega a ideia |
| **DM** | Conversa e conversão | Sempre atrás de uma palavra-chave ou de uma resposta — nunca fria (`/instagram-dm-flows`) |
| **Live / Collab** | Confiança e alcance em dobro | Collab aparece nas duas contas; usar com parceiro de público vizinho |

## 3. Mix e cadência

Ponto de partida para uma conta que quer crescer (ajuste ao tamanho do time):

- **4 a 5 posts por semana**, pelo menos 3 em Reels.
- **Stories todos os dias.**
- Nunca dois posts do mesmo tipo seguidos.

Tipos de post para distribuir na semana:

| Tipo | Frequência sugerida | O que é |
|---|---|---|
| **Prova** | 1 por semana | algo que aconteceu, com número de fonte conhecida |
| **Ensino** | 1 a 2 por semana | uma coisa que a pessoa consegue fazer hoje |
| **Opinião** | 1 por semana | uma posição clara, que alguém pode discordar |
| **História** | 1 a cada 15 dias | uma cena com custo, conflito e virada |
| **Oferta** | 1 a cada 15 dias | o que a conta vende, dito sem rodeio |

**Cadência sustentável vence cadência ambiciosa.** Se o time produz 3 por semana com qualidade, a pauta tem 3. Pauta que o time não cumpre é pauta falsa: a VERA reprova a cadência antes de reprovar a peça.

## 4. A pauta (calendário)

Cada slot tem **cinco campos** — sem eles, não é pauta:

1. **Pilar**
2. **Ângulo concreto** — não "IA", e sim "a proposta que perdemos por causa de um travessão". Tema não é pauta; ângulo é.
3. **Formato** (Reel, carrossel, Stories, estático) e **plataforma** (Instagram; Facebook/Threads só se o projeto usa)
4. **Objetivo** (alcance, salvamento, conversa, clique, venda) e **CTA único**
5. **Gancho previsto** — a fórmula escolhida em `/social-scriptwriting` (`reference/ganchos.md`)

Modelo:

```
SEMANA DE {dd/mm}
SEG  só interação (20 min, lista abaixo)
TER  19h30  REEL       PROVA    gancho #{n} — {ângulo}             CTA: comenta {PALAVRA}
QUA  Stories + interação
QUI  19h00  CARROSSEL  ENSINO   {ângulo}                            CTA: salva
SEX  19h30  REEL       OPINIÃO  gancho #{n} — {ângulo}             CTA: compartilha
DOM  18h00  REEL       HISTÓRIA gancho #{n} — {ângulo}             CTA: segue
STORIES  todo dia, 3 a 5 quadros; caixa de pergunta na quinta
```

Salve em `social-media/campaigns/{id}/brief.md` (ou `docs/smart-memory/agents/instagram/strategy/pauta-{periodo}.md`) e emita o veredicto da pauta em `validation.md`. **Só depois do PASS da pauta** a LYRIS escreve e o estúdio produz.

## 5. Rodada de interação (não é opcional)

20 minutos por dia, **antes** de publicar. Lista de 10 contas, revista por semana:

- **5 de alcance** — contas com o público que a conta quer; comentar cedo, com substância.
- **3 pares** — mesmo tamanho, mesmo campo; o grupo que retribui.
- **2 compradores** — pessoas que podem comprar; comentar por semanas antes de qualquer DM, nunca vender em comentário.

A LYRIS pode redigir comentários; quem comenta é o usuário.

## 6. Horário

Comece pelos insights da própria conta (quando a audiência está online, no fuso dela). Tabelas genéricas são ponto de partida sem fonte datada. **O horário importa muito menos que os 2 primeiros segundos**: se os ganchos não seguram, otimizar horário é polir a coisa errada — diga isso.

## 7. Leitura de resultado: outliers pela mediana

Método completo em `/social-analytics`. Resumo do que a VERA usa para decidir:

- **Múltiplo de outlier = views do post ÷ mediana de views da própria conta** (últimos ~12 posts do mesmo formato). Mediana, não média — um viral distorce a média.
- **≥ 3×** é sinal; **≥ 10×** é padrão a investigar e repetir com ângulo novo. Abaixo de 1× por 3 posts seguidos no mesmo pilar → rever o ângulo, não o horário.
- Compare **topo × fundo** (5 melhores × 5 piores) por gancho, duração, formato, tema. Conclusão só com diferença consistente — um post isolado não é padrão.
- Envios e salvamentos por alcance pesam mais que curtidas.
- Os números vêm do instagram-publisher (orgânico). Pagos são do traffic-bi — nunca misture sem rótulo.

Revisão mensal: o que repetir (formato + fórmula de gancho que deu múltiplo alto), o que aposentar, que pilar está sem matéria-prima.

## 8. Facebook e Threads (extensões)

Entram na pauta só quando o projeto declarou que usa. Cada um tem slot próprio e gate próprio.

- **Facebook (página):** público geralmente mais velho e local; link clicável no post funciona. Reels podem ser cruzados, mas a legenda é revista para a plataforma. Bom para evento, comunidade, oferta local.
- **Threads:** conversa em texto. Opinião curta, pergunta, bastidor. Não é a legenda do Reel colada; cadência própria (pode ser diária) e baixo custo de produção.
- Peça adaptada para Facebook ou Threads = nova versão = novo PASS da VERA para aquela plataforma.

## 9. Reaproveitamento entre plataformas (modelo PUXAR)

- A estrategista de origem (TikTok, YouTube, LinkedIn) marca a peça como "reaproveitável".
- A VERA decide se entra no Instagram, em que slot e com que adaptação (corte, legenda, capa, CTA).
- **Aprovação não se transfere**: a versão Instagram passa pelo gate inteiro da VERA, mesmo que seja o mesmo arquivo.

## 10. Checklist da pauta (gate da VERA)

- [ ] Todo slot tem os cinco campos da seção 4
- [ ] Nenhum ângulo repete as duas últimas semanas
- [ ] Mix respeita a seção 3 e a cadência cabe no time
- [ ] Todo número previsto tem fonte (se não tem, o slot muda)
- [ ] Palavras-chave de DM da semana sem colisão entre si (`/instagram-dm-flows`)
- [ ] Facebook/Threads só se o projeto usa, com slot próprio

## 11. Erros comuns (e o que a VERA faz)

| Erro | Correção |
|---|---|
| Pauta com tema ("produtividade") em vez de ângulo | FAIL do slot; pedir a cena ou o número concreto |
| Mesmo formato três dias seguidos | Redistribuir pelo mix da seção 3 |
| Cadência copiada de conta grande | Reduzir ao que o time entrega com qualidade |
| Julgar post por views brutas | Reler pelo múltiplo sobre a mediana (seção 7) |
| Otimizar horário com gancho fraco | Voltar para o gancho; horário depois |
| CTA múltiplo ("salva, comenta e segue") | Um CTA por peça, ligado ao objetivo do slot |
| Peça do TikTok/YouTube "igual" no Instagram | Puxar e fazer o gate da versão Instagram (seção 9) |

## Skills relacionadas

- `/social-analytics` — múltiplo sobre a mediana, retenção, envios/alcance, rubrica de perfil
- `/social-scriptwriting` — fórmulas de gancho e roteiro
- `/social-copywriting` — legenda e CTA
- `/instagram-dm-flows` — palavra-chave, ManyChat e triagem de comentários
- `/social-editorial-validation` — checklist do veredicto
