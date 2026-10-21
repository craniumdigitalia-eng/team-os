---
name: sites-page-cro
description: "Otimização de conversão para páginas web — estrutura de landing page, hierarquia, trust signals e redução de fricção. Use ao montar ou revisar landing pages, melhorar taxa de conversão, posicionar CTAs e provas sociais ou diagnosticar páginas que não convertem."
version: "1.1"
updated: "2026-10-20"
---

# Sites Page CRO — Conversion Rate Optimisation

## Estrutura de landing page de alta conversão

```
1. Hero (acima do fold)
   - Headline clara (proposta de valor)
   - Subheadline (clarificação)
   - CTA primário
   - Prova social (logos, rating)

2. Problema/Contexto
   - Nomear a dor do cliente
   - Validar a frustração

3. Solução
   - Como funciona (3 passos)
   - Features → Benefits

4. Prova Social
   - Testimonials com foto e nome real
   - Resultados específicos (números)
   - Logos de clientes reconhecíveis

5. Objecções
   - FAQ que antecipa dúvidas
   - Garantia (reduz risco percebido)

6. CTA Final
   - Repetir proposta de valor
   - CTA com urgência ou escassez (se real)
```

## Trust signals essenciais
- Número de clientes ou usuários
- Anos de experiência
- Certificações relevantes
- Press mentions
- Garantia de devolução

## Redução de fricção
- Formulários: mínimo de campos
- CTA: sem "grátis" se não for grátis
- Preços: sempre visíveis, sem surpresas
- Processo: explicar os passos (3 no máximo)

## Teste A/B de página

Teste A/B serve para decidir entre duas versões com dado, não com gosto. Mal feito, ele "prova" o que você já queria acreditar. Antes de subir qualquer variante, cumpra os passos abaixo e registre tudo em `docs/smart-memory/` (área de CRO do projeto).

**1. Hipótese escrita, no formato porque / se / então**
```
Porque [o que observamos — dado de analytics, gravação, mapa de calor, pesquisa],
se [mudança concreta na página],
então [métrica primária] vai [subir/cair] para [público], medido por [evento].
```
Exemplo fraco: "trocar a cor do botão pode melhorar". Exemplo bom: "Porque 60% dos visitantes no celular não rolam até o formulário (mapa de rolagem), se subirmos o formulário para logo abaixo do hero, então a taxa de envio do formulário no celular sobe."

**2. Uma mudança por teste.** Se a variante B troca headline, imagem e CTA ao mesmo tempo, o resultado não diz qual delas funcionou. Mudança única, mas grande o bastante para fazer diferença — ajuste cosmético raramente aparece no número.

**3. Métricas definidas antes de começar**
- **Primária** — uma só, ligada à hipótese; é ela que decide o teste.
- **Secundárias** — ajudam a explicar o porquê (cliques no CTA, rolagem, tempo até o envio).
- **Guardrail** — o que não pode piorar (taxa de lead qualificado, reembolso, erro de formulário). Se piorar de forma clara, o teste para.

**4. Tamanho de amostra calculado antes de começar.** O número de visitantes necessário depende de três coisas: a taxa de conversão atual, o menor efeito que vale a pena detectar e o nível de confiança. Quanto menor a taxa atual e menor o efeito procurado, mais visitantes por variante. Não existe número mágico ("100 conversões bastam") — use uma calculadora de tamanho de amostra de teste A/B (há várias gratuitas), anote as entradas e o resultado na hipótese e só então suba o teste.

**5. Duração mínima em semanas completas.** Rode pelo menos um ciclo semanal inteiro (de preferência dois), mesmo que a amostra chegue antes: comportamento de segunda-feira não é o de sábado. Não mude a variante, a divisão de tráfego nem as fontes de tráfego no meio do teste.

**6. Não espiar e parar cedo.** Olhar o painel todo dia e parar quando "deu significância" produz falso positivo — o placar oscila muito no começo. Defina a regra de parada no início (amostra + duração) e só leia o resultado quando ela for cumprida. Acompanhar no meio é permitido apenas para checar erro técnico ou guardrail.

**7. Registro do resultado — inclusive negativo e empate**
| Campo | Conteúdo |
|---|---|
| Hipótese | o texto do passo 1 |
| Variantes | descrição + print de cada uma |
| Amostra e duração | planejado × realizado |
| Resultado | métrica primária por variante, tamanho do efeito e intervalo, secundárias, guardrails |
| Decisão | implementar / manter controle / novo teste |
| Aprendizado | o que isso ensina sobre o público |

Teste que perdeu ou empatou também é aprendizado; apagar o registro faz a equipe repetir o mesmo teste meses depois. Segmento que "ganhou" sem estar no plano (só tablet, só domingo) é exploratório — vira hipótese de um teste novo, não decisão.

**8. Quando NÃO fazer A/B.** Com tráfego baixo, a amostra necessária leva meses e o teste nunca conclui. Nesse caso use teste qualitativo: 5 a 8 sessões de usuário observado, gravações de sessão, mapa de calor, pesquisa curta na página ou teste de 5 segundos — e aplique a melhoria direto, comparando antes × depois com cautela. Também não teste o óbvio quebrado (link morto, formulário com erro): corrija.

O número que decide o teste vem da fonte de analytics do projeto (`traffic-analytics-tracking` define eventos e UTMs); o teste em si sobe com PASS da sites-qa.

---

Seção "Teste A/B de página" adaptada de coreyhaines31/marketingskills → skill `ab-testing` (MIT) — 2026-10-20.
