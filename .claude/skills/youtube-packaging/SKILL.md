---
name: youtube-packaging
description: "Método do pacote de vídeo do YouTube — título (máx. 100, ideal 60–70), texto de thumb (≤5 palavras, 1280×720), descrição (máx. 5000, 125 visíveis), capítulos do corte final a partir de 00:00 (≥3), tags (≤30 e ≤500 caracteres), categoryId, idioma e 2–3 variantes para A/B. Use ao montar, revisar ou aprovar o pacote de um vídeo antes do upload."
version: "1.0"
updated: "2026-10-20"
---

# YouTube Packaging — título, thumb e descrição como um pacote só

O espectador decide em um segundo, olhando **thumb + título juntos**. Pacote bom não repete a mesma frase nos dois: a thumb mostra, o título explica, a descrição confirma. E todo o pacote promete só o que o vídeo entrega.

Usada por: youtube-content (escreve), youtube-strategist (julga), youtube-publisher (valida antes do upload).

## 1. Limites (validar antes de entregar)

| Campo | Limite | Ideal / regra do método |
|---|---|---|
| Título | 100 caracteres | 60–70; palavra-chave nos primeiros ~40 |
| Descrição | 5.000 caracteres | 125 primeiros autoexplicativos (é o que aparece na busca e antes do "mais") |
| Tags | até 30 tags e 500 caracteres somados | trabalhar com folga (~450); sem `#`, sem aspas, sem duplicata |
| Thumb | 1280×720 (16:9), largura mínima 640 | ≤5 palavras; legível em tamanho de celular; arquivo dentro do limite do Studio (conferir) |
| categoryId | número da categoria | 27 Educação, 28 Ciência e Tecnologia, 26 Guias e Estilo, 22 Pessoas e Blogs, 24 Entretenimento |
| Idioma | `defaultLanguage` e `defaultAudioLanguage` | `pt-BR` para canal brasileiro |
| Capítulos | começam em 00:00, ≥3, cada um ≥10 s | só do **corte final** |

Remover caracteres de controle e quebras estranhas de título e tags. Limites mudam: se `updated` desta skill tiver mais de 6 meses, conferir na Central de Ajuda do YouTube antes de bloquear entrega.

## 2. Título

- Promessa clara, específica, que **o vídeo paga** (o gancho de `/youtube-scriptwriting` confirma o título)
- Palavra-chave de busca no começo quando o vídeo é de busca; curiosidade quando é de navegação/sugestão — declare qual
- Número só se for real e estiver na lista de claims
- Sem CAIXA ALTA inteira, sem "(CHOCANTE)", sem promessa que o vídeo não cumpre
- Ano no título só se o conteúdo envelhece de verdade

## 3. Thumb (brief para o estúdio)

O texto e a ideia são seus; a arte é do social-design / social-photo, sob brief.

- **≤5 palavras**, complementar ao título (nunca a mesma frase)
- Um foco visual (rosto com emoção real, objeto, antes/depois, resultado)
- Contraste legível em miniatura; sem texto na zona do carimbo de duração (canto inferior direito)
- Nada que não está no vídeo (cena, pessoa, resultado)
- Imagem gerada por IA na thumb entra na avaliação de mídia sintética (`/youtube-publishing`)

Brief:
```
Thumb {id} — variante A
Texto (≤5 palavras): …
Foco visual: …
Emoção/tensão: …
Relação com o título: complementa {como}
Proibido: …
```

## 4. Descrição

Estrutura:
1. **125 primeiros caracteres:** o que a pessoa ganha assistindo, com a palavra-chave. Sem link, sem "neste vídeo"
2. 2–4 linhas de contexto (para quem é, o que tem de original)
3. **Capítulos** (do corte final)
4. Fontes dos claims citados (link da fonte primária)
5. Links úteis (material, vídeo relacionado, playlist) — só os que existem
6. Divulgação obrigatória quando houver: patrocínio, link de afiliado, mídia sintética relevante
7. 0–3 hashtags no fim (as primeiras aparecem acima do título)

## 5. Capítulos

- Gerados a partir do **arquivo final exportado** — nunca do roteiro (a edição muda a minutagem)
- Primeiro capítulo em `00:00`; mínimo 3; cada um com pelo menos 10 s
- Rótulo = o que a pessoa encontra ali ("Configurando o webhook"), não "Parte 2"
- Os rótulos devem bater com as cenas do roteiro (a retenção por cena usa esses nomes)

```
00:00 O erro que trava 90% das automações   ← só se o 90% estiver na lista de claims
00:42 O que você precisa antes de começar
02:15 Passo 1 — conectar a conta
```

## 6. Tags

- Complemento, não estratégia: título e descrição pesam mais
- Ordem: termo principal → variações → erros de digitação comuns → termo do nicho
- Sem tags de outros canais/marcas sem relação (enganoso)

## 7. Variantes para A/B (2–3)

- Variar **uma** coisa por variante (só o título, ou só a thumb, ou o par inteiro com hipótese única)
- Cada variante com hipótese escrita: "B troca promessa por curiosidade porque {motivo}"
- Todas passam pelo gate — variante não aprovada não entra no teste
- Quem conduz e julga o teste é a youtube-publisher (`/youtube-analytics`, z ≥1,96); troca ao vivo só com confirmação do usuário

## 8. Formato de entrega

`social-media/youtube/{id}/pacote.md`:
```markdown
## Pacote — vídeo {id} — corte final: {arquivo} ({duração})
Tipo de descoberta: busca | navegação/sugestão
Título A (n caracteres): …
Título B (n caracteres): …
Thumb A: texto … | brief: …
Thumb B: texto … | brief: …
Descrição: (texto completo, 125 iniciais marcados)
Capítulos: (do corte final)
Tags (n tags / n caracteres): …
categoryId: 27 | defaultLanguage: pt-BR | defaultAudioLanguage: pt-BR
Claims citados na descrição: #1, #4 (ver claims.md)
```

## 9. Checklist do gate

- [ ] Título ≤100 (ideal 60–70) e pago pelo vídeo
- [ ] Thumb ≤5 palavras, 1280×720, complementar ao título, nada que não está no vídeo
- [ ] 125 primeiros caracteres autoexplicativos; descrição ≤5000
- [ ] Capítulos do corte final, 00:00, ≥3, ≥10 s cada
- [ ] Tags ≤30 e ≤500 caracteres; sem duplicata
- [ ] categoryId numérico e idiomas preenchidos
- [ ] Todo número do pacote está na lista de claims com fonte
- [ ] 2–3 variantes com hipótese, todas aprovadas

> Método adaptado de darkzOGx/youtube-automation-agent (MIT) — limites de metadados, descrição com 125 visíveis e capítulos; reescrito para o fluxo de squad.
