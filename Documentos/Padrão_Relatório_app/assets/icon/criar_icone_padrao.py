#!/usr/bin/env python3
"""
Script para criar ícone do app "Padrão Relatório" 
Tema: Padronização, organização, relatórios
Cores: Tons de azul (#2196F3, #1976D2, #0D47A1)
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_standard_report_icon():
    # Configurações
    size = 1024
    bg_color = "#2196F3"  # Azul Material Design
    
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
    
    # Elementos do design
    center_x, center_y = size // 2, size // 2
    
    # === DOCUMENTO/RELATÓRIO ===
    # Documento principal (retângulo branco)
    doc_width = 280
    doc_height = 360
    doc_x = center_x - doc_width // 2
    doc_y = center_y - doc_height // 2 - 20
    
    # Sombra do documento
    shadow_offset = 8
    draw.rounded_rectangle([doc_x + shadow_offset, doc_y + shadow_offset, 
                           doc_x + doc_width + shadow_offset, doc_y + doc_height + shadow_offset], 
                          radius=20, fill="#0D47A1", outline=None)
    
    # Documento principal
    draw.rounded_rectangle([doc_x, doc_y, doc_x + doc_width, doc_y + doc_height], 
                          radius=20, fill="#FFFFFF", outline=None)
    
    # === ELEMENTOS DE PADRONIZAÇÃO ===
    
    # Linhas de texto padronizadas (simulando um formulário)
    line_color = "#E3F2FD"  # Azul muito claro
    line_spacing = 45
    line_width = doc_width - 60
    line_start_x = doc_x + 30
    line_start_y = doc_y + 60
    
    # Linhas horizontais (campos do formulário)
    for i in range(6):
        y = line_start_y + i * line_spacing
        draw.rectangle([line_start_x, y, line_start_x + line_width, y + 6], 
                      fill=line_color)
    
    # === SÍMBOLO DE PADRONIZAÇÃO ===
    # Checkbox/checkmarks (indicando padrão/conformidade)
    check_size = 24
    check_color = "#4CAF50"  # Verde para aprovado/padrão
    
    for i in range(3):
        check_y = line_start_y + i * line_spacing * 2 - 12
        check_x = line_start_x + line_width - 40
        
        # Quadrado do checkbox
        draw.rectangle([check_x, check_y, check_x + check_size, check_y + check_size], 
                      fill="#FFFFFF", outline="#BBBBBB", width=2)
        
        # Checkmark
        draw.line([check_x + 6, check_y + 12, check_x + 10, check_y + 16], 
                 fill=check_color, width=3)
        draw.line([check_x + 10, check_y + 16, check_x + 18, check_y + 8], 
                 fill=check_color, width=3)
    
    # === CABEÇALHO DO DOCUMENTO ===
    # Título simulado
    title_height = 25
    draw.rectangle([line_start_x, doc_y + 20, line_start_x + line_width, doc_y + 20 + title_height], 
                  fill="#1976D2")
    
    # === CÓDIGO QR SIMULADO ===
    qr_size = 60
    qr_x = doc_x + doc_width - qr_size - 20
    qr_y = doc_y + doc_height - qr_size - 20
    
    # Fundo do QR Code
    draw.rectangle([qr_x - 5, qr_y - 5, qr_x + qr_size + 5, qr_y + qr_size + 5], 
                  fill="#FFFFFF")
    
    # Padrão QR simplificado
    qr_pattern_size = 8
    for row in range(7):
        for col in range(7):
            if (row + col) % 2 == 0:
                pattern_x = qr_x + col * qr_pattern_size
                pattern_y = qr_y + row * qr_pattern_size
                draw.rectangle([pattern_x, pattern_y, 
                              pattern_x + qr_pattern_size - 1, pattern_y + qr_pattern_size - 1], 
                              fill="#000000")
    
    # === ÍCONE DE ENGRENAGEM (PADRONIZAÇÃO) ===
    # Pequena engrenagem no canto para simbolizar padronização
    gear_center_x = center_x + 120
    gear_center_y = center_y + 180
    gear_radius = 35
    
    # Círculo da engrenagem
    draw.ellipse([gear_center_x - gear_radius, gear_center_y - gear_radius,
                 gear_center_x + gear_radius, gear_center_y + gear_radius], 
                fill="#0D47A1")
    
    # Dentes da engrenagem
    import math
    teeth = 8
    for i in range(teeth):
        angle = (2 * math.pi * i) / teeth
        tooth_x = gear_center_x + (gear_radius + 8) * math.cos(angle)
        tooth_y = gear_center_y + (gear_radius + 8) * math.sin(angle)
        draw.ellipse([tooth_x - 6, tooth_y - 6, tooth_x + 6, tooth_y + 6], 
                    fill="#0D47A1")
    
    # Centro da engrenagem
    draw.ellipse([gear_center_x - 15, gear_center_y - 15,
                 gear_center_x + 15, gear_center_y + 15], 
                fill="#FFFFFF")
    draw.ellipse([gear_center_x - 8, gear_center_y - 8,
                 gear_center_x + 8, gear_center_y + 8], 
                fill="#0D47A1")
    
    return img

def create_foreground_icon():
    """Criar ícone adaptativo (foreground)"""
    size = 432
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    center_x, center_y = size // 2, size // 2
    
    # Documento simplificado para o foreground
    doc_width = 140
    doc_height = 180
    doc_x = center_x - doc_width // 2
    doc_y = center_y - doc_height // 2
    
    # Documento principal
    draw.rounded_rectangle([doc_x, doc_y, doc_x + doc_width, doc_y + doc_height], 
                          radius=12, fill="#FFFFFF", outline="#1976D2", width=4)
    
    # Cabeçalho
    draw.rectangle([doc_x + 4, doc_y + 4, doc_x + doc_width - 4, doc_y + 20], 
                  fill="#1976D2")
    
    # Linhas do formulário
    line_spacing = 22
    line_width = doc_width - 20
    line_start_x = doc_x + 10
    line_start_y = doc_y + 35
    
    for i in range(5):
        y = line_start_y + i * line_spacing
        draw.rectangle([line_start_x, y, line_start_x + line_width, y + 3], 
                      fill="#E3F2FD")
    
    # Checkmarks
    for i in range(2):
        check_y = line_start_y + i * line_spacing * 2 - 8
        check_x = line_start_x + line_width - 20
        
        # Checkmark verde
        draw.line([check_x, check_y + 6, check_x + 4, check_y + 10], 
                 fill="#4CAF50", width=3)
        draw.line([check_x + 4, check_y + 10, check_x + 12, check_y + 2], 
                 fill="#4CAF50", width=3)
    
    return img

# Criar os ícones
if __name__ == "__main__":
    print("Criando ícone 'Padrão Relatório'...")
    
    # Ícone principal
    main_icon = create_standard_report_icon()
    main_icon.save("/home/hendel/Documentos/Padrão_Relatório_app/assets/icon/app_icon.png")
    print("✅ Ícone principal criado: app_icon.png")
    
    # Ícone foreground (adaptativo)
    foreground_icon = create_foreground_icon()
    foreground_icon.save("/home/hendel/Documentos/Padrão_Relatório_app/assets/icon/app_icon_foreground.png")
    print("✅ Ícone foreground criado: app_icon_foreground.png")
    
    print("\n🎨 Conceito do ícone:")
    print("- Documento/formulário representando relatórios")
    print("- Checkmarks verdes indicando padronização/conformidade")
    print("- QR Code simulado referenciando a funcionalidade")
    print("- Engrenagem simbolizando processo padronizado")
    print("- Cores azuis (#2196F3, #1976D2, #0D47A1) para profissionalismo")
    print("- Design limpo e organizado refletindo 'padrão'")
