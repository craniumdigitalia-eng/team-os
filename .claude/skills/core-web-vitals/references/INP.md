# INP — referência detalhada

Leia quando o campo reprova INP, um trace mostra interação lenta ou o código tem trabalho pesado ligado a clique/tecla que precisa ser confirmado em runtime.

## Três fases — descubra qual domina antes de mexer

| Fase | O que olhar no trace | Correção típica |
|---|---|---|
| Atraso de entrada | Long tasks ocupando a thread antes do callback começar (inicialização, hidratação, terceiros) | Reduzir trabalho de inicialização, quebrar tarefas, adiar terceiros, hidratar sob demanda |
| Processamento | Callbacks do evento e trabalho síncrono que disparam | Tirar trabalho desnecessário, simplificar handler, Web Worker para CPU pesada |
| Apresentação | Estilo, layout, pintura antes do próximo quadro | Menos DOM invalidado, evitar layout forçado, `content-visibility` |

## Ceder a thread em trabalho longo

```javascript
// ruim: um bloco único trava a thread
function processar(itens) { itens.forEach(operacaoCara); }

// melhor: fatia e cede entre as fatias
async function processar(itens) {
  for (let i = 0; i < itens.length; i += 100) {
    itens.slice(i, i + 100).forEach(operacaoCara);
    if (globalThis.scheduler?.yield) await scheduler.yield();
    else await new Promise((r) => setTimeout(r, 0));
  }
}
```

O tamanho da fatia vem do trace num aparelho representativo — "100 itens" não garante tarefa curta.

## Feedback visível antes do trabalho

```javascript
botao.addEventListener('click', async () => {
  botao.classList.add('carregando');                 // o usuário vê na hora
  if (globalThis.scheduler?.yield) await scheduler.yield(); // deixa pintar
  atualizarTela(calcular());
  (globalThis.requestIdleCallback ?? setTimeout)(() => registrarEvento('click'));
});
```

Só ajuda se o feedback pintar antes do resto — confirme o quadro no trace.

## Causas comuns

- **Terceiros:** atribua cada long task à URL do script. Adie widgets não essenciais até visibilidade/interação, mas sem fazer a primeira interação pagar a inicialização inteira sem feedback.
- **Hidratação:** a página parece pronta e o primeiro clique espera a hidratação terminar. Grave o trace clicando *durante* o carregamento. Reduza o que hidrata no cliente.
- **Re-render do framework:** perfile a transição de estado afetada. Memoização só onde remove trabalho repetido medido — não em tudo.
- **DOM grande:** menos nós invalidados; não intercale leitura e escrita de geometria (layout forçado).
- **CPU pesada:** Web Worker, medindo o custo de serialização.

## Observer da sessão atual (não é INP de campo)

```javascript
new PerformanceObserver((lista) => {
  for (const e of lista.getEntries()) {
    if (e.duration > 200) console.warn('Interação lenta', {
      tipo: e.name, duracao: e.duration,
      inicioProc: e.processingStart, fimProc: e.processingEnd, alvo: e.target,
    });
  }
}).observe({ type: 'event', buffered: true, durationThreshold: 40 });
```

Em produção, prefira `onINP()` do build `web-vitals/attribution`: traz alvo, tipo de evento e evidência de Long Animation Frame/script das visitas reais.

## Checklist

- [ ] Interação importante reproduzida em aparelho ou CPU representativos
- [ ] Fase dominante identificada
- [ ] Tarefa responsável atribuída (código próprio ou terceiro)
- [ ] Feedback visível antes do trabalho adiado, quando couber
- [ ] Mesma interação e condições repetidas depois do fix
- [ ] Melhora de campo só depois de novas visitas (RUM/CrUX)

Fontes: web.dev "Optimize INP", "Optimize long tasks"; GoogleChrome/web-vitals (build de atribuição).
