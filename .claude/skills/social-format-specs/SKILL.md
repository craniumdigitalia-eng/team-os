---
name: social-format-specs
description: "Especificações técnicas de formatos para todas as plataformas sociais — dimensões, duração, tamanho de arquivo, codecs e zonas seguras. Use ao exportar ou validar vídeo/foto para Instagram, TikTok, YouTube (longo e Shorts), Facebook ou LinkedIn antes de publicar."
version: "1.2"
updated: "2026-10-20"
---

# Social Format Specs — Especificações por Plataforma

Usada pelo estúdio (social-video, social-design) e pelos publishers de cada plataforma.

> **Specs verificadas em 2026-09; se `updated` > 6 meses, confirmar nas docs oficiais antes de bloquear entrega.**

## Instagram

### Feed (Foto/Vídeo)
| Formato | Dimensões | Aspect Ratio | Máx arquivo |
|---|---|---|---|
| Quadrado | 1080x1080 | 1:1 | 30MB (foto) |
| Portrait | 1080x1350 | 4:5 | 30MB (foto) |
| Landscape | 1080x566 | 1.91:1 | 30MB (foto) |

**Vídeo feed:** até 60 min (recomendado <90s para engajamento), H.264, 30fps, AAC

### Reels
| Dimensões | Aspect Ratio | Duração | Recomendado |
|---|---|---|---|
| 1080x1920 | 9:16 | até 3 min | 15-90s para alcance |

**Codec:** H.264, 30fps, AAC 128kbps

### Stories
- **Dimensões:** 1080x1920 (9:16)
- **Duração:** 60s por card (foto: 7s automático)
- **Zona segura:** 250px top e bottom (UI da plataforma)

## TikTok

| Dimensões | Aspect Ratio | Duração | Máx arquivo |
|---|---|---|---|
| 1080x1920 | 9:16 | 15s - 10min | 287.6MB |
| 1080x1080 | 1:1 | 15s - 10min | 287.6MB |

**Codec:** H.264/H.265, 30fps mínimo (60fps recomendado), AAC

## YouTube (vídeo longo)

| Dimensões | Aspect Ratio | Recomendado |
|---|---|---|
| 1920x1080 (ou 3840x2160) | 16:9 | 1080p mínimo; 4K se a captação permitir |

**Codec:** H.264 (MP4), 24/25/30/60fps (manter o da captação), AAC 48kHz estéreo
**Thumb:** 1280x720 (16:9), largura mínima 640, JPG/PNG, dentro do limite de arquivo do Studio (conferir); texto ≤5 palavras fora do canto inferior direito (carimbo de duração)
**Capítulos:** do corte final, primeiro em 00:00, mínimo 3, cada um ≥10s (método em `/youtube-packaging`)

## YouTube Shorts

| Dimensões | Aspect Ratio | Duração |
|---|---|---|
| 1080x1920 | 9:16 | até 3 min |

**Codec:** H.264, 30-60fps, AAC 128kbps+

## Facebook

### Feed
- **Foto:** 1200x630 (link) ou 1080x1080 (post)
- **Vídeo:** 1280x720 mínimo, 30fps, máx 240min, 4GB

### Stories
- **Dimensões:** 1080x1920 (9:16)
- **Duração:** 20s foto, 60s vídeo

## LinkedIn

### Feed
- **Foto:** 1080x1350 (4:5, post — padrão do pack), 1080x1080 (1:1) ou 1200x627 (link/artigo) — conferir a vigente na central de ajuda
- **Vídeo:** 1920x1080 ou 1080x1080, máx 10min, 5GB — conferir a vigente
- **Alt text:** preencher em toda imagem ao anexar

### Documento (Carousel)
- **Formato:** PDF (preferido), PPT/PPTX ou DOC/DOCX; até 100 MB e até 300 páginas — conferir a vigente na central de ajuda
- **Título do documento:** obrigatório no upload (aparece sobre o documento no feed); escreva um título que funcione sozinho
- **Dimensões:** 1080x1350 (4:5, padrão do pack) ou 1080x1080 por página

**Padrão do pack:** documento/carrossel PDF em 1080x1350 (4:5); vídeo no feed em 1:1 (1080x1080) ou 4:5 (1080x1350) — ocupam mais tela no celular que 16:9.

## Checklist de exportação

```
[ ] Resolução correta para plataforma
[ ] Aspect ratio verificado
[ ] Arquivo dentro do limite de tamanho
[ ] Codec compatível (H.264 padrão)
[ ] Frame rate adequado (30fps mínimo)
[ ] Áudio: AAC, sem clipping
[ ] Legendas incluídas (.srt ou burned-in)
```
