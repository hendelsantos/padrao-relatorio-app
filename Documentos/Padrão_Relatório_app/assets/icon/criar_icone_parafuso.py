#!/usr/bin/env python3
"""
Script para criar ícone do app "Relatório de Peças" 
Tema: Parafuso grande central - símbolo direto de manutenção
Cores: Tons de azul (#2196F3, #1976D2, #0D47A1) com parafuso metálico
"""

from PIL import Image, ImageDraw, ImageFont
import math
import os

def create_large_screw_icon():
    # Configurações
    size = 1024
    
    # Criar imagem base
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Fundo circular com gradiente azul
    margin = 80
    circle_size = size - 2 * margin
    
    # Círculo principal (azul mais escuro)
    draw.ellipse([margin, margin, margin + circle_size, margin + circle_size], 
                 fill="#1976D2", outline=None)
    
    # Círculo interno (azul mais claro)
    inner_margin = margin + 40
    inner_size = circle_size - 80
    draw.ellipse([inner_margin, inner_margin, inner_margin + inner_size, inner_margin + inner_size], 
                 fill="#2196F3", outline=None)
    
    # Centro da imagem
    center_x, center_y = size // 2, size // 2
    
    # === PARAFUSO GRANDE CENTRAL ===
    screw_radius = 200  # Parafuso bem grande
    
    # Sombra do parafuso (para dar profundidade)
    shadow_offset = 12
    draw.ellipse([center_x - screw_radius + shadow_offset, center_y - screw_radius + shadow_offset,
                 center_x + screw_radius + shadow_offset, center_y + screw_radius + shadow_offset], 
                fill="#0D47A1", outline=None)
    
    # Cabeça do parafuso (círculo principal - cor metálica)
    draw.ellipse([center_x - screw_radius, center_y - screw_radius,
                 center_x + screw_radius, center_y + screw_radius], 
                fill="#37474F", outline=None)
    
    # Anel metálico (brilho)
    highlight_radius = screw_radius - 20
    draw.ellipse([center_x - highlight_radius, center_y - highlight_radius,
                 center_x + highlight_radius, center_y + highlight_radius], 
                fill="#546E7A", outline=None)
    
    # Anel interno mais claro
    inner_highlight_radius = screw_radius - 40
    draw.ellipse([center_x - inner_highlight_radius, center_y - inner_highlight_radius,
                 center_x + inner_highlight_radius, center_y + inner_highlight_radius], 
                fill="#607D8B", outline=None)
    
    # === FENDA DO PARAFUSO (CRUZ GRANDE) ===
    slot_width = 20  # Fenda bem larga
    slot_length = screw_radius * 1.4  # Atravessa toda a cabeça
    
    # Fenda horizontal
    draw.rectangle([center_x - slot_length, center_y - slot_width,
                   center_x + slot_length, center_y + slot_width], 
                  fill="#263238")
    
    # Fenda vertical
    draw.rectangle([center_x - slot_width, center_y - slot_length,
                   center_x + slot_width, center_y + slot_length], 
                  fill="#263238")
    
    # Brilho nas fendas (para dar efeito 3D)
    brilho_width = 6
    # Brilho horizontal superior
    draw.rectangle([center_x - slot_length, center_y - slot_width,
                   center_x + slot_length, center_y - slot_width + brilho_width], 
                  fill="#455A64")
    
    # Brilho vertical esquerdo
    draw.rectangle([center_x - slot_width, center_y - slot_length,
                   center_x - slot_width + brilho_width, center_y + slot_length], 
                  fill="#455A64")
    
    # === ROSCA DO PARAFUSO (DETALHES) ===
    # Adicionar linhas de rosca na lateral do parafuso
    thread_lines = 8
    thread_radius_start = screw_radius - 60
    thread_radius_end = screw_radius - 10
    
    for i in range(thread_lines):
        angle = (2 * math.pi * i) / thread_lines
        # Linha de rosca externa
        start_x = center_x + thread_radius_start * math.cos(angle)
        start_y = center_y + thread_radius_start * math.sin(angle)
        end_x = center_x + thread_radius_end * math.cos(angle)
        end_y = center_y + thread_radius_end * math.sin(angle)
        
        draw.line([start_x, start_y, end_x, end_y], fill="#455A64", width=4)
    
    # === REFLEXOS METÁLICOS ===
    # Reflexo principal (superior esquerdo)
    reflection_radius = screw_radius - 80
    reflection_center_x = center_x - 60
    reflection_center_y = center_y - 60
    
    draw.ellipse([reflection_center_x - reflection_radius//3, reflection_center_y - reflection_radius//3,
                 reflection_center_x + reflection_radius//3, reflection_center_y + reflection_radius//3], 
                fill="#78909C")
    
    # Pequenos reflexos adicionais
    small_reflections = [
        (center_x + 80, center_y - 100, 25),
        (center_x - 120, center_y + 70, 20),
        (center_x + 100, center_y + 90, 18),
    ]
    
    for refl_x, refl_y, refl_size in small_reflections:
        draw.ellipse([refl_x - refl_size, refl_y - refl_size,
                     refl_x + refl_size, refl_y + refl_size], 
                    fill="#90A4AE")
    
    # === TEXTO "RELATÓRIO DE PEÇAS" (OPCIONAL - SUTIL) ===
    # Adicionar pequeno texto curvado ao redor do parafuso
    text_radius = screw_radius + 60
    text_angles = [-2.5, -1.8, -1.1, -0.4, 0.3, 1.0, 1.7, 2.4]  # Posições para cada letra
    text_letters = "RELATÓRIO"
    
    for i, letter in enumerate(text_letters):
        if i < len(text_angles):
            angle = text_angles[i]
            text_x = center_x + text_radius * math.cos(angle)
            text_y = center_y + text_radius * math.sin(angle)
            
            # Simular texto com pequenos retângulos (já que não temos fonte)
            draw.rectangle([text_x - 8, text_y - 12, text_x + 8, text_y + 12], 
                          fill="#FFFFFF")
    
    return img

def create_foreground_screw_icon():
    """Criar ícone adaptativo (foreground) com parafuso simplificado"""
    size = 432
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    center_x, center_y = size // 2, size // 2
    
    # Parafuso simplificado para foreground
    screw_radius = 120
    
    # Cabeça do parafuso
    draw.ellipse([center_x - screw_radius, center_y - screw_radius,
                 center_x + screw_radius, center_y + screw_radius], 
                fill="#37474F", outline=None)
    
    # Anel metálico
    highlight_radius = screw_radius - 15
    draw.ellipse([center_x - highlight_radius, center_y - highlight_radius,
                 center_x + highlight_radius, center_y + highlight_radius], 
                fill="#607D8B", outline=None)
    
    # Fenda do parafuso (cruz)
    slot_width = 12
    slot_length = screw_radius * 1.2
    
    # Fenda horizontal
    draw.rectangle([center_x - slot_length, center_y - slot_width,
                   center_x + slot_length, center_y + slot_width], 
                  fill="#263238")
    
    # Fenda vertical
    draw.rectangle([center_x - slot_width, center_y - slot_length,
                   center_x + slot_width, center_y + slot_length], 
                  fill="#263238")
    
    # Reflexo metálico
    reflection_radius = 30
    reflection_x = center_x - 40
    reflection_y = center_y - 40
    draw.ellipse([reflection_x - reflection_radius, reflection_y - reflection_radius,
                 reflection_x + reflection_radius, reflection_y + reflection_radius], 
                fill="#78909C")
    
    return img

# Criar os ícones
if __name__ == "__main__":
    print("Criando ícone 'Parafuso Grande' para Relatório de Peças...")
    
    # Ícone principal
    main_icon = create_large_screw_icon()
    main_icon.save("/home/hendel/Documentos/Padrão_Relatório_app/assets/icon/app_icon.png")
    print("✅ Ícone principal criado: app_icon.png")
    
    # Ícone foreground (adaptativo)
    foreground_icon = create_foreground_screw_icon()
    foreground_icon.save("/home/hendel/Documentos/Padrão_Relatório_app/assets/icon/app_icon_foreground.png")
    print("✅ Ícone foreground criado: app_icon_foreground.png")
    
    print("\n🔩 Conceito do ícone:")
    print("- Parafuso GRANDE no centro (símbolo universal de manutenção)")
    print("- Fenda em cruz bem visível (característica marcante)")
    print("- Cores metálicas realistas (#37474F, #607D8B)")
    print("- Reflexos e brilhos para efeito 3D")
    print("- Detalhes de rosca nas bordas")
    print("- Fundo azul profissional (#2196F3, #1976D2)")
    print("- Design simples mas muito reconhecível")
    print("- Perfeito para técnicos de manutenção identificarem!")
