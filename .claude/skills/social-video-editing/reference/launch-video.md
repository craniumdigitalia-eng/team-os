# Vídeo de lançamento de produto — método

> Referência da skill `social-video-editing`. Vídeo curto (15–60 s) que apresenta um produto, site ou ferramenta a partir do próprio projeto. Render com ffmpeg puro; Hyperframes (composição HTML → vídeo) é opcional, nunca obrigatório.

## 1. Ler o projeto

Fontes, nesta ordem: site público (home, página de preço/recursos), `README`, docs de produto, changelog, material de marca já aprovado na smart-memory.

**Nunca ler:** `.env` e `.env.*`, `.pem`, `.key`, `id_rsa`, JSON de service account, qualquer coisa em `secrets/` ou `credentials/`, config local que guarda token, saída de build (`dist/`, `.next/`, `build/`), lock files, `.git/` e o que o `.gitignore` exclui por esses motivos. Se um arquivo útil parecer conter segredo, pare e pergunte.

## 2. Plano

Uma tela de texto: o que o produto faz em 1 frase, para quem, 3 provas visuais (telas, números reais, depoimento autorizado), tom, duração, formato (9:16 / 16:9 / 1:1), CTA final. Confirmar com o usuário antes de produzir.

## 3. Brief

Roteiro cena a cena: `cena | duração | o que aparece | texto na tela | áudio`. Gancho nos 3 primeiros segundos; uma ideia por cena; texto legível no celular (nada abaixo de ~48 px em 1080 de largura).

## 4. Stills e captura

- Telas do produto por captura headless (navegador embutido ou Playwright) em resolução do formato final, com dados de demonstração.
- Animação de interface: gravar a tela em headless ou montar a cena em HTML (Hyperframes, se o usuário já usa) e renderizar para `.mp4`/`.webm`.
- Key Visual e fotos vêm de AEON (social-design) e IRIS (social-photo) quando houver.

## 5. Checagem dos stills (antes do render)

Abra cada still e confira: nenhum segredo, token, URL interna ou painel de admin; nenhum nome, e-mail, telefone ou dado real de cliente (troque por dado fictício óbvio); fonte carregada (não caiu em fallback); texto inteiro dentro da área segura.

## 6. Render

Pipeline da `SKILL.md`: EDL → trechos com `afade` → concat → overlays com `setpts=PTS-STARTPTS` → legenda por último → loudnorm −14 LUFS / −1 dBTP → autoavaliação (máx. 3 passes).

## 7. Entrega

- **Poster como frame 0:** escolha o frame mais forte e *assentado* (texto já parado, fora de transição), salve como `poster.jpg` e substitua o frame 0 do vídeo por ele — substituir, não acrescentar, para não mexer em duração e sincronia.
- **Texto para postar:** legenda curta + CTA, na voz aprovada, para LYRIS (social-content) revisar.
- Arquivos em `social-media/campaigns/{id}/assets/videos/exports/` e aviso a VERA.

## Proibições

- Segredo, chave, token ou URL interna no vídeo — nem desfocado.
- Nome, e-mail ou qualquer dado real de cliente sem autorização escrita.
- **Métrica inventada** ("+300% de conversão") — todo número vem de fonte citada no plano ou não entra.
- **Música só com licença confirmada:** gerada do zero ou trilha licenciada com o comprovante registrado na smart-memory. Na dúvida, sem música.
