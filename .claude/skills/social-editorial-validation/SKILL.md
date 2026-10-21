---
name: social-editorial-validation
description: "Validação editorial de conteúdo social comum às plataformas — checklist de qualidade, alinhamento estratégico, compliance, valor original × repetitivo, divulgação de mídia sintética e direitos de mídia. Use ao revisar conteúdo antes de publicar, validar alinhamento com a estratégia da marca, checar compliance ou emitir aprovação editorial de posts e campanhas."
version: "1.3"
updated: "2026-10-20"
---

# Social Editorial Validation — checklist comum das plataformas

> Checklist comum ao estrategista de cada plataforma (instagram, youtube, tiktok, linkedin). Cada plataforma soma o gate próprio dela; aprovação não se transfere entre plataformas.

## Checklist completo de validação

### 1. Alinhamento estratégico
- [ ] Conteúdo serve o objetivo da campanha (awareness/engagement/conversão)
- [ ] Mensagem alinha com posicionamento da marca
- [ ] Tom de voz consistente com guidelines
- [ ] Público-alvo correto para o conteúdo

### 2. Qualidade de copy
- [ ] Hook eficaz (para-scroll nos primeiros 3 segundos/linhas)
- [ ] Sem erros ortográficos ou gramaticais
- [ ] CTA claro e específico
- [ ] Hashtags: 3–5 relevantes e específicas, ou nenhuma (regra provisória até haver fonte oficial datada da plataforma — revisar)
- [ ] Emojis usados estrategicamente (não decorativamente)
- [ ] Comprimento adequado à plataforma

### 3. Qualidade visual
- [ ] Resolução adequada para a plataforma
- [ ] Identidade de marca presente e correta
- [ ] Contraste de texto legível (WCAG AA mínimo)
- [ ] Zona segura respeitada (elementos importantes fora das bordas)
- [ ] Consistência com KV da campanha

### 4. Compliance e risco
- [ ] Sem claims não substantiados ("o melhor", "o único")
- [ ] Sem comparações diretas com concorrentes sem dados
- [ ] Direitos de imagem verificados
- [ ] Direitos musicais verificados (para vídeo)
- [ ] Sem conteúdo potencialmente ofensivo
- [ ] Políticas da plataforma respeitadas

### 5. Valor original × repetitivo (todas as plataformas)
- [ ] A peça tem algo próprio: ângulo, dado, demonstração, caso real ou opinião fundamentada — dá para dizer em 1 frase o que ela traz que as 10 primeiras de mesmo tema não trazem
- [ ] Não é o mesmo molde com outro tema (mesmo roteiro, mesma narração, mesmas imagens genéricas em série)
- [ ] Material de terceiros só com transformação real (comentário, análise, crítica) — compilação pura não passa
- [ ] Cadência sustentada com revisão humana, não volume por automação
> Plataformas penalizam conteúdo produzido em massa e repetitivo (no YouTube: risco de perder a monetização do YPP). Em dúvida → CONCERNS com o ângulo novo a acrescentar.

### 6. Mídia sintética (divulgação)
- [ ] Toda mídia gerada ou alterada por IA está listada (imagem, vídeo, avatar, voz)
- [ ] Conteúdo **realista** que pode ser confundido com real — voz TTS/clonada realista, avatar realista, rosto ou cena alterados, cena que não aconteceu — tem a divulgação exigida pela plataforma marcada (YouTube `containsSyntheticMedia`, rótulo de IA no Instagram/TikTok/LinkedIn)
- [ ] Animação ou efeito obviamente fantasioso não precisa de rótulo, mas fica registrado
- [ ] Na dúvida, divulga — esconder é risco de política e de confiança
- [ ] Nenhuma métrica, depoimento, tela ou resultado simulado apresentado como real

### 7. Direitos de mídia
- [ ] Cada música, efeito sonoro, foto, vídeo, fonte e trecho de terceiro tem origem e licença registradas (banco, contrato, autoria própria)
- [ ] Licença cobre o uso (comercial, plataforma, anúncio se for impulsionar) — "música grátis" sem licença verificada não passa
- [ ] Pessoas identificáveis com autorização de uso de imagem
- [ ] Marca/logotipo de terceiro só em uso informativo, sem sugerir parceria inexistente

### 8. Plataforma específica
- [ ] Formato correto para a plataforma
- [ ] Specs técnicas verificadas
- [ ] Horário de publicação otimizado

## Veredictos possíveis

| Veredicto | Critério | Próximo passo |
|---|---|---|
| **APROVADO** | Todos os itens ok | → o publisher da plataforma pode publicar (após confirmação explícita do usuário) |
| **APROVADO COM RESSALVAS** | Pequenos ajustes necessários | Ajustar e publicar sem nova validação |
| **REJEITADO** | Falhas críticas | Devolver ao agente responsável com feedback específico |

## Template de output

```markdown
## Validação {estrategista da plataforma} — [Campanha] — [dd/mm/yyyy hh:mm]

**Veredicto:** [APROVADO | APROVADO COM RESSALVAS | REJEITADO]

**Copy:** [ok | problema: ...]
**Visual:** [ok | problema: ...]
**Estratégia:** [ok | problema: ...]
**Compliance:** [ok | problema: ...]
**Valor original / mídia sintética / direitos:** [ok | problema: ...]

**Ações requeridas antes de publicar:**
1. [se houver]

**Aprovado por:** {persona} ({plataforma}-strategist) — [timestamp]
```

## Critérios de rejeição automática
- Erros ortográficos não corrigidos
- Imagem, música ou trecho sem direitos verificados
- Mídia sintética realista sem divulgação
- Peça repetitiva sem valor original
- Claim não substantiado
- Fora dos specs técnicos da plataforma
- Tom completamente inconsistente com a marca
