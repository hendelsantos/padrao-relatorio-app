#!/usr/bin/env python3
"""
Script para criar ícone inspirado no Telegram mas com parafuso
Tema: Design circular limpo do Telegram + parafuso central profissional
Cores: Gradiente azul similar ao Telegram (#2AABEE, #1DA1F2, #0088CC)
"""

from PIL import Image, ImageDraw, ImageFilter
import math
import os

def create_telegram_style_screw_icon():
    # Configurações
    size = 1024
    
    # Criar imagem base
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Centro da imagem
    center_x, center_y = size // 2, size // 2
    
    # === FUNDO CIRCULAR ESTILO TELEGRAM ===
    margin = 80
    circle_radius = (size - 2 * margin) // 2
    
    # Criar gradiente circular (simular o gradiente do Telegram)
    # Círculo externo (azul mais escuro)
    draw.ellipse([center_x - circle_radius, center_y - circle_radius,
                 center_x + circle_radius, center_y + circle_radius], 
                fill="#0088CC")  # Azul escuro estilo Telegram
    
    # Círculo médio (azul médio)
    medium_radius = circle_radius - 30
    draw.ellipse([center_x - medium_radius, center_y - medium_radius,
                 center_x + medium_radius, center_y + medium_radius], 
                fill="#1DA1F2")  # Azul médio
    
    # Círculo interno (azul claro)
    inner_radius = circle_radius - 60
    draw.ellipse([center_x - inner_radius, center_y - inner_radius,
                 center_x + inner_radius, center_y + inner_radius], 
                fill="#2AABEE")  # Azul claro estilo Telegram
    
    # === SOMBRA DO PARAFUSO (para profundidade) ===
    screw_radius = 180
    shadow_offset = 8
    
    # Sombra
    draw.ellipse([center_x - screw_radius + shadow_offset, center_y - screw_radius + shadow_offset,
                 center_x + screw_radius + shadow_offset, center_y + screw_radius + shadow_offset], 
                fill="#004466")  # Sombra azul escura
    
    # === PARAFUSO CENTRAL PROFISSIONAL ===
    
    # Base do parafuso (círculo principal)
    draw.ellipse([center_x - screw_radius, center_y - screw_radius,
                 center_x + screw_radius, center_y + screw_radius], 
                fill="#E8EAED")  # Cinza claro metálico
    
    # Anel metálico externo
    outer_ring_radius = screw_radius - 15
    draw.ellipse([center_x - outer_ring_radius, center_y - outer_ring_radius,
                 center_x + outer_ring_radius, center_y + outer_ring_radius], 
                fill="#F5F5F5")  # Branco metálico
    
    # Anel metálico interno
    inner_ring_radius = screw_radius - 30
    draw.ellipse([center_x - inner_ring_radius, center_y - inner_ring_radius,
                 center_x + inner_ring_radius, center_y + inner_ring_radius], 
                fill="#FFFFFF")  # Branco puro
    
    # Centro do parafuso
    center_radius = screw_radius - 45
    draw.ellipse([center_x - center_radius, center_y - center_radius,
                 center_x + center_radius, center_y + center_radius], 
                fill="#E0E0E0")  # Cinza claro
    
    # === FENDA DO PARAFUSO (CRUZ PHILLIPS) ===
    slot_width = 18
    slot_length = screw_radius - 20
    
    # Fenda horizontal
    draw.rectangle([center_x - slot_length, center_y - slot_width,
                   center_x + slot_length, center_y + slot_width], 
                  fill="#424242")  # Cinza escuro
    
    # Fenda vertical
    draw.rectangle([center_x - slot_width, center_y - slot_length,
                   center_x + slot_width, center_y + slot_length], 
                  fill="#424242")
    
    # === BRILHOS E REFLEXOS PROFISSIONAIS ===
    
    # Reflexo principal (superior esquerdo)
    reflection_radius = 40
    reflection_x = center_x - 60
    reflection_y = center_y - 60
    draw.ellipse([reflection_x - reflection_radius, reflection_y - reflection_radius,
                 reflection_x + reflection_radius, reflection_y + reflection_radius], 
                fill="#FFFFFF")
    
    # Reflexo secundário (direita)
    small_reflection_radius = 25
    small_reflection_x = center_x + 70
    small_reflection_y = center_y - 30
    draw.ellipse([small_reflection_x - small_reflection_radius, small_reflection_y - small_reflection_radius,
                 small_reflection_x + small_reflection_radius, small_reflection_y + small_reflection_radius], 
                fill="#F0F0F0")
    
    # === DETALHES DE PROFUNDIDADE ===
    
    # Sombra interna nas fendas (efeito 3D)
    shadow_width = 4
    
    # Sombra fenda horizontal (inferior)
    draw.rectangle([center_x - slot_length, center_y + slot_width - shadow_width,
                   center_x + slot_length, center_y + slot_width], 
                  fill="#616161")
    
    # Sombra fenda vertical (direita)
    draw.rectangle([center_x + slot_width - shadow_width, center_y - slot_length,
                   center_x + slot_width, center_y + slot_length], 
                  fill="#616161")
    
    # === ANEL DE ACABAMENTO (estilo premium) ===
    finish_ring_radius = screw_radius - 8
    draw.arc([center_x - finish_ring_radius, center_y - finish_ring_radius,
             center_x + finish_ring_radius, center_y + finish_ring_radius], 
            start=225, end=45, fill="#BDBDBD", width=3)
    
    # === PEQUENOS DETALHES DE ROSCA ===
    thread_count = 12
    thread_radius = screw_radius - 20
    
    for i in range(thread_count):
        angle = (2 * math.pi * i) / thread_count
        thread_x = center_x + thread_radius * math.cos(angle)
        thread_y = center_y + thread_radius * math.sin(angle)
        
        # Pequenos pontos de rosca
        draw.ellipse([thread_x - 2, thread_y - 2, thread_x + 2, thread_y + 2], 
                    fill="#D0D0D0")
    
    return img

def create_telegram_style_foreground():
    """Criar ícone adaptativo (foreground) estilo Telegram"""
    size = 432
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    center_x, center_y = size // 2, size // 2
    
    # Parafuso simplificado para foreground
    screw_radius = 120
    
    # Base do parafuso
    draw.ellipse([center_x - screw_radius, center_y - screw_radius,
                 center_x + screw_radius, center_y + screw_radius], 
                fill="#FFFFFF")
    
    # Anel interno
    inner_radius = screw_radius - 15
    draw.ellipse([center_x - inner_radius, center_y - inner_radius,
                 center_x + inner_radius, center_y + inner_radius], 
                fill="#F0F0F0")
    
    # Fenda do parafuso (cruz)
    slot_width = 12
    slot_length = screw_radius - 10
    
    # Fenda horizontal
    draw.rectangle([center_x - slot_length, center_y - slot_width,
                   center_x + slot_length, center_y + slot_width], 
                  fill="#424242")
    
    # Fenda vertical
    draw.rectangle([center_x - slot_width, center_y - slot_length,
                   center_x + slot_width, center_y + slot_length], 
                  fill="#424242")
    
    # Reflexo
    reflection_radius = 25
    reflection_x = center_x - 40
    reflection_y = center_y - 40
    draw.ellipse([reflection_x - reflection_radius, reflection_y - reflection_radius,
                 reflection_x + reflection_radius, reflection_y + reflection_radius], 
                fill="#FFFFFF")
    
    return img

# Criar os ícones
if __name__ == "__main__":
    print("Criando ícone estilo Telegram com parafuso profissional...")
    
    # Ícone principal
    main_icon = create_telegram_style_screw_icon()
    main_icon.save("/home/hendel/Documentos/Padrão_Relatório_app/assets/icon/app_icon.png")
    print("✅ Ícone principal criado: app_icon.png")
    
    # Ícone foreground (adaptativo)
    foreground_icon = create_telegram_style_foreground()
    foreground_icon.save("/home/hendel/Documentos/Padrão_Relatório_app/assets/icon/app_icon_foreground.png")
    print("✅ Ícone foreground criado: app_icon_foreground.png")
    
    print("\n📱 Conceito do ícone estilo Telegram:")
    print("- Design circular limpo inspirado no Telegram")
    print("- Gradiente azul (#2AABEE, #1DA1F2, #0088CC)")
    print("- Parafuso branco/metálico no centro (profissional)")
    print("- Fenda Phillips bem definida")
    print("- Reflexos e brilhos para efeito premium")
    print("- Sombras sutis para profundidade")
    print("- Visual moderno e reconhecível")
    print("- Perfeito para app de manutenção profissional")
