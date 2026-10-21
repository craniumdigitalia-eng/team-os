---
name: social-video-editing
description: "Edição de vídeo para redes sociais com ffmpeg puro — regras de correção de corte, corte por fala e silêncio, legenda .srt com transcrição local opcional, áudio (ducking e loudnorm), fluxo com lista de cortes e autoavaliação, capítulos e vídeo de lançamento. Use ao editar Reels, TikToks, Shorts ou vídeo 16:9, cortar, legendar, mixar ou exportar por plataforma."
version: "2.0"
updated: "2026-10-20"
---

# Social Video Editing — método com ffmpeg

> Skill do agente FLUX (social-video). Só ffmpeg/ffprobe: sem script Python, sem chave de API, sem `.venv`. Vídeo de lançamento de produto: `reference/launch-video.md`.

## 1. Regras de correção (valem para todo render)

1. **Legenda por último.** Queime `subtitles=` depois de overlays, cor e texto — senão o overlay cobre a legenda.
2. **Extrair e concatenar.** Cada trecho é extraído com corte preciso (reencode) e os trechos, já com os mesmos parâmetros, são unidos com o demuxer `concat` e `-c copy`. Cortar direto com `-c copy` só cai em keyframe e erra o ponto.
3. **`afade` de 30 ms em toda borda de corte** — sem isso cada corte dá estalo: `afade=t=in:st=0:d=0.03,afade=t=out:st={dur-0.03}:d=0.03` (`dur` = duração do trecho).
4. **Overlay começa do frame 0:** `setpts=PTS-STARTPTS` no overlay (some `+T/TB` para deslocá-lo até o início da janela, junto com `enable='between(t,T,T2)'`).
5. **SRT no tempo da saída:** `tempo_saida = palavra.inicio − trecho.inicio + offset_do_trecho_na_timeline`. Legenda tirada do bruto desalinha depois do concat.
6. **Nunca cortar dentro de palavra:** padding de 30–200 ms antes da primeira e depois da última palavra do trecho.

```bash
# trecho preciso com afade (dur = 12.4 s neste exemplo)
ffmpeg -ss 15.32 -to 27.72 -i bruto.mp4 -c:v libx264 -crf 18 -preset medium \
  -af "afade=t=in:st=0:d=0.03,afade=t=out:st=12.37:d=0.03" -c:a aac -b:a 192k t01.mp4
# concat sem reencode
printf "file 't01.mp4'\nfile 't02.mp4'\n" > lista.txt
ffmpeg -f concat -safe 0 -i lista.txt -c copy montado.mp4
```

## 2. Corte por fala e silêncio

1. Detectar silêncio: `ffmpeg -i bruto.mp4 -af silencedetect=noise=-30dB:d=0.4 -f null - 2>&1 | grep silence_` — o complemento dos silêncios é a lista de faixas de fala.
2. Classificar cada pausa: **≥400 ms** corte limpo; **150–400 ms** só com checagem visual do frame; **<150 ms** não serve (meio de frase).
3. Extrair as faixas com padding (regra 6) e `afade` (regra 3) → concat (regra 2).
4. Com transcrição (seção 3), leia um **transcrito empacotado**, não o JSON bruto: uma linha por frase com `[início-fim]`, quebrando em silêncio ≥0,5 s ou troca de locutor. Dá precisão de palavra com uma fração dos tokens.

```
[002.10-006.84] Hoje eu vou te mostrar três plugins
[007.52-011.90] que mudaram o jeito que eu trabalho
```

Ajuste `noise` (−35 dB em sala silenciosa, −25 dB com ruído de fundo) se a lista vier picada demais ou grudada.

## 3. Gerar legenda .srt

1. **Transcrição local, opcional.** Pergunte ao usuário qual ferramenta ele tem instalada: whisper.cpp (`whisper-cli`, saída JSON com tokens) ou faster-whisper / whisper (`--word_timestamps True`). Áudio para transcrever: `ffmpeg -i bruto.mp4 -vn -ar 16000 -ac 1 audio.wav`.
2. **Nunca** exija chave de API nem envie áudio a serviço de terceiro sem OK explícito do usuário no chat. Sem ferramenta local, peça o .srt ou a transcrição a ele.
3. Precisa de **timestamp por palavra** — é ele que permite cortar sem picar palavra e montar blocos curtos.
4. **Reels/TikTok/Shorts:** blocos de ~2 palavras em CAIXA ALTA, quebra em pontuação e pausa ≥0,3 s; nenhuma deixa abaixo de 0,35 s (junte uma 3ª palavra em vez de piscar). Vídeo 16:9 narrativo: 4–7 palavras, caixa normal.
5. Offsets da timeline de saída (regra 5) e legenda por último (regra 1).

```bash
ffmpeg -i montado.mp4 -vf "subtitles=legenda.srt:force_style='FontName=Helvetica,FontSize=18,Bold=1,PrimaryColour=&HFFFFFF,OutlineColour=&H000000,Outline=2,Alignment=2,MarginV=35'" \
  -c:a copy legendado.mp4
```

`MarginV` 35 em vertical (acima da UI da rede); 60–80 em 16:9. Fonte por caminho/nome explícito — fonte ausente cai em fallback sem erro.

## 4. Áudio

- **Ducking:** trilha −12 a −15 dB abaixo da voz enquanto há fala. Fixo: `volume=-14dB` na trilha; dinâmico: `sidechaincompress` com a voz como sidechain.
- **Loudnorm em 2 passes** no mix final, alvo **−14 LUFS / −1 dBTP**. Meça antes e depois com `ebur128`.

```bash
# ducking dinâmico
ffmpeg -i voz.mp4 -i trilha.mp3 -filter_complex \
 "[1:a]volume=-6dB[m];[m][0:a]sidechaincompress=threshold=0.03:ratio=8:attack=20:release=300[d];[0:a][d]amix=inputs=2:duration=first[a]" \
 -map 0:v -map "[a]" -c:v copy mix.mp4
# passe 1 — medir
ffmpeg -i mix.mp4 -af loudnorm=I=-14:TP=-1:LRA=11:print_format=json -f null -
# passe 2 — aplicar com os valores medidos
ffmpeg -i mix.mp4 -af loudnorm=I=-14:TP=-1:LRA=11:measured_I=<I>:measured_TP=<TP>:measured_LRA=<LRA>:measured_thresh=<thr>:offset=<off>:linear=true \
  -c:v copy -c:a aac -b:a 192k final.mp4
# conferir
ffmpeg -i final.mp4 -af ebur128 -f null - 2>&1 | tail -12
```

Música só com licença confirmada (ver `reference/launch-video.md`).

## 5. Fluxo de edição

1. **Estratégia em 4–8 frases** (objetivo, gancho, o que sai, ritmo, formato, duração-alvo) → confirmar com o usuário antes de cortar.
2. **Lista de cortes (EDL) em JSON simples**, salva junto dos assets:
   ```json
   {"fonte":"raw/bruto.mp4","formato":"9:16","trechos":[
     {"id":"t01","inicio":15.32,"fim":27.72,"motivo":"gancho"},
     {"id":"t02","inicio":41.10,"fim":58.40,"motivo":"prova"}],
    "overlays":[{"arquivo":"kv.png","inicio_saida":3.0,"fim_saida":6.0}],
    "legenda":"subtitles/legenda.srt"}
   ```
3. **Render** seguindo as regras da seção 1.
4. **Autoavaliação** no arquivo renderizado (não no bruto): frames a ±1,5 s de cada corte (`ffmpeg -ss <t> -i final.mp4 -frames:v 1 c01.jpg`) procurando palavra cortada, salto visual, overlay errado, legenda escondida; `ffprobe -v error -show_entries format=duration -of csv=p=0 final.mp4` contra a EDL; `ebur128` contra −14 LUFS. Errou → corrige → renderiza → reavalia, **no máximo 3 passes**; o que restar vai como pendência ao usuário.
5. **Aprovação** de VERA (social-strategist) ou do estrategista da plataforma antes de qualquer publicação.

## 6. Vídeo 16:9 longo e capítulos

- Capítulos saem do **corte final**, nunca da duração planejada: some as durações dos trechos da EDL renderizada (confira com `ffprobe`) para achar o início de cada bloco.
- Formato na descrição: primeira linha `00:00`, **no mínimo 3** capítulos, em ordem crescente, um por linha (`02:14 Instalação`).
- Mudou um corte → recalcule todos os capítulos seguintes.

## 7. Receitas rápidas

```bash
# 16:9 → 9:16
ffmpeg -i in.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1" -c:a copy out_9x16.mp4
# crop central 1:1
ffmpeg -i in.mp4 -vf "crop=ih:ih,scale=1080:1080" out_1x1.mp4
# fade de vídeo 0,5 s (vídeo de 30 s, 30 fps)
ffmpeg -i in.mp4 -vf "fade=t=in:st=0:d=0.5,fade=t=out:st=29.5:d=0.5" out_fade.mp4
# export Reel
ffmpeg -i in.mp4 -c:v libx264 -crf 23 -preset medium -pix_fmt yuv420p -c:a aac -b:a 128k -movflags +faststart out_reel.mp4
# export TikTok
ffmpeg -i in.mp4 -c:v libx264 -crf 20 -preset slow -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart out_tiktok.mp4
```

## 8. Especificações por plataforma

| Plataforma | Resolução | FPS | Codec | Máx |
|---|---|---|---|---|
| Instagram Reel | 1080x1920 | 30 | H.264 | 100MB |
| TikTok | 1080x1920 | 30 | H.264 | 287.6MB |
| YouTube Shorts | 1080x1920 | 30/60 | H.264 | 256GB |
| YouTube 16:9 | 1920x1080 | 30/60 | H.264 | 256GB |
| Facebook | 1080x1920 | 30 | H.264 | 4GB |

Specs completas e atualizadas: `/social-format-specs`.
