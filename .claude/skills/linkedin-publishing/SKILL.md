---
name: linkedin-publishing
description: "Pacote de publicação do LinkedIn sem automação — texto com as 2–3 linhas antes do \"ver mais\", link no corpo ou no comentário conforme a estratégia, documento PDF 1080×1350, alt text, destino (perfil ou página), agendamento nativo pelo usuário, checklist de confirmação e leitura de métricas exportadas. Use ao montar, conferir ou registrar uma publicação do LinkedIn e ao ler seus exports."
version: "1.0"
updated: "2026-10-20"
---

# LinkedIn Publishing — o pacote que o usuário publica

> Skill da squad LinkedIn: a RELAY (linkedin-publisher) monta e mede com ela; a STRATA (linkedin-strategist) a usa para julgar o pacote. Estratégia em `/linkedin-strategy`; dimensões gerais em `/social-format-specs`.

Na v1 não há MCP do LinkedIn na squad. Quem publica e agenda é o **usuário**, na interface nativa. O trabalho da RELAY é entregar um pacote em que publicar seja copiar, anexar, conferir e clicar — sem decisão pendente e sem risco.

## 1. Pré-condições (sem elas, não há pacote)

1. `social-media/linkedin/{id}/validation.md` contém `Aprovação: STRATA | {timestamp}` com veredicto PASS
2. O PASS é **desta** versão e **deste** destino (perfil pessoal ou página) — aprovação de outra plataforma ou da outra voz não vale
3. Os arquivos visuais vieram do estúdio social com o mesmo `id`

Faltou algo → bloquear, avisar o lead, parar.

## 2. Estrutura do pacote

```
social-media/linkedin/{id}/package/
├── README.md        # destino, horário sugerido, passo a passo, checklist
├── post.txt         # texto final, pronto para colar
├── comentario.txt   # 1º comentário (link ou complemento), se a estratégia pedir
├── documento.pdf    # se o formato for documento/carrossel
├── imagem-01.png    # se houver imagem
├── video.mp4 + legenda.srt  # se houver vídeo
└── alt-text.md      # texto alternativo de cada imagem
```

## 3. Texto

- **Abertura:** o que aparece antes do "ver mais" são, na prática, as 2–3 primeiras linhas; o corte exato varia com o dispositivo e o tamanho da tela e não é documentado. Marque no `README.md` a linha de corte provável e confira na pré-visualização antes de publicar.
- A abertura precisa funcionar sozinha: afirmação concreta, resultado, tensão. Nada de "Hoje quero falar sobre…".
- Limite do post: 3.000 caracteres (central de ajuda do LinkedIn — conferir a vigente). A referência editorial do corpo está em `/social-copywriting`.
- Parágrafos curtos, linha em branco entre blocos; emojis só se a voz da marca usa.
- Menções (@) só a pessoas e empresas que sabem que serão citadas — a STRATA conferiu no gate.
- Hashtags: poucas e específicas do tema, ou nenhuma; não decidem alcance.

## 4. Link: no corpo ou no comentário

Não existe regra pública da plataforma sobre link no corpo reduzir alcance. Trate como **hipótese** da estratégia:

- Se a estratégia definiu "link no comentário", o pacote traz `comentario.txt` e o passo a passo diz para comentar logo depois de publicar.
- Se definiu "link no corpo", o link vai no fim do texto, com o motivo para clicar antes dele.
- Cada escolha é registrada na agenda para a STRATA comparar no relatório.

## 5. Documento / carrossel PDF

- Formato do arquivo: PDF (o LinkedIn também aceita PPT, PPTX, DOC, DOCX — PDF garante fonte e layout)
- Página: **1080×1350** (4:5) — ocupa mais tela no celular; 1080×1080 é a alternativa
- Limites da plataforma: até 100 MB e 300 páginas (central de ajuda — conferir a vigente); na prática, 6–12 páginas
- O documento exige **título** ao publicar — o pacote traz o título pronto
- Texto do PDF legível no celular (corpo ≥ 24 pt na arte de 1080 px); a última página traz o CTA
- Conferir antes de entregar: número de páginas, fontes embutidas, peso do arquivo, nada cortado na borda

## 6. Imagem e vídeo

- Imagem: 1080×1350 ou 1080×1080 (specs completas em `/social-format-specs`)
- Vídeo: legenda queimada ou `.srt` — boa parte do público assiste sem som; a primeira imagem precisa fazer sentido parada
- Vídeo vindo de outra rede: sem marca d'água de outra plataforma e reeditado para o formato

## 7. Alt text

Toda imagem leva texto alternativo — o campo aparece ao editar a imagem antes de publicar. Descreva o que importa para entender o post (texto da imagem, gráfico e o que ele mostra), não "imagem de…". Documento PDF: o conteúdo essencial também precisa estar no texto do post ou em páginas com texto real, não só em imagem.

## 8. Destino e agendamento nativo

- `README.md` diz o destino exato: **perfil de {pessoa}** ou **página {empresa}** (o usuário publica como admin da página)
- O usuário pode publicar na hora ou usar o **agendamento nativo** do LinkedIn (ícone de relógio no compositor; disponibilidade e prazo máximo conferidos na central de ajuda na data do uso)
- Horário sugerido vem da estratégia e é hipótese até a série própria de métricas confirmar
- Nunca ferramenta não oficial que publique, conecte, curta ou comente — viola os termos do LinkedIn

## 9. Checklist de confirmação (vai no `README.md`)

```
[ ] PASS da STRATA desta versão e deste destino: {timestamp}
[ ] Destino: perfil {pessoa} | página {empresa}
[ ] Texto colado de post.txt; abertura conferida na pré-visualização
[ ] Arquivo anexado ({documento.pdf | imagem | vídeo}); título do documento preenchido
[ ] Alt text em cada imagem
[ ] Link: {no corpo | no 1º comentário — colar comentario.txt logo após publicar}
[ ] Menções conferidas
[ ] Publicar agora | agendar para {data hora}
[ ] Depois de publicar: mandar a URL para a RELAY registrar
```

A RELAY envia o pacote ao lead pedindo a confirmação do usuário. **Sem confirmação explícita, nada acontece** — timeout nunca vira publicação.

## 10. Registro

Com a URL enviada pelo usuário, a RELAY escreve `social-media/linkedin/{id}/published.md` (URL, data/hora, destino, link no corpo ou no comentário, "confirmado pelo usuário em {timestamp}") e muda a agenda para `publicado`.

## 11. Leitura de métricas exportadas

O usuário exporta, onde a interface oferecer:

- **Perfil pessoal:** analytics do post e do perfil (conteúdo, público, seguidores) — exportação disponível conforme o tipo de conta
- **Página:** analytics da página (publicações, visitantes, seguidores) — admins exportam em planilha

Se não houver export, print com período visível e data anotada. Sem período e fonte, o número não entra.

Relatório (`docs/smart-memory/agents/linkedin/publisher/metrics/{AAAA-MM}.md`):

```markdown
# Métricas LinkedIn — {AAAA-MM}
Fonte: {arquivo do export} · Período: {de–até} · Exportado em: {data}
| Peça | Destino | Formato | Pilar | Impressões | Não seguidores | Salvamentos | Comentários qualificados | Cliques no perfil | Leads |
Mediana da conta por formato: {…}
Observações (fatos): {…}
Hipóteses para a STRATA (porquês, a testar): {…}
```

Separe observação de hipótese. Um post isolado não prova nada sobre o algoritmo. Comentário qualificado = de alguém do público-alvo com conteúdo; conte à parte dos genéricos. Leads vêm do registro de conversas do usuário, não do export.

## 12. Nunca

- Publicar, agendar ou montar pacote sem PASS
- Ferramenta de automação de conexão, DM em massa, curtida ou comentário
- Afirmar regra do algoritmo sem fonte pública
- Misturar números orgânicos com pagos (pagos = squad traffic)
