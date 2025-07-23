#!/usr/bin/env python3
"""
Script para criar ícone do app "Relatório de Peças" 
Tema: Peças de manutenção, ferramentas, componentes mecânicos
Cores: Tons de azul (#2196F3, #1976D2, #0D47A1) com detalhes metálicos
"""

from PIL import Image, ImageDraw, ImageFont
import math
import os

def create_maintenance_parts_icon():
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
    
    # Centro da imagem
    center_x, center_y = size // 2, size // 2
    
    # === ENGRENAGEM PRINCIPAL (CENTRO) ===
    gear_radius = 120
    gear_color = "#37474F"  # Cinza escuro metálico
    gear_highlight = "#607D8B"  # Cinza mais claro
    
    # Engrenagem principal
    draw_gear(draw, center_x, center_y, gear_radius, 12, gear_color, gear_highlight)
    
    # === PARAFUSOS NOS CANTOS ===
    screw_positions = [
        (center_x - 140, center_y - 140),  # Superior esquerdo
        (center_x + 140, center_y - 140),  # Superior direito
        (center_x - 140, center_y + 140),  # Inferior esquerdo
        (center_x + 140, center_y + 140),  # Inferior direito
    ]
    
    for screw_x, screw_y in screw_positions:
        draw_screw(draw, screw_x, screw_y, 35, "#424242", "#616161")
    
    # === CHAVE INGLESA ===
    # Posição diagonal (superior direita para inferior esquerda)
    wrench_start_x = center_x + 60
    wrench_start_y = center_y - 80
    wrench_end_x = center_x - 80
    wrench_end_y = center_y + 60
    
    draw_wrench(draw, wrench_start_x, wrench_start_y, wrench_end_x, wrench_end_y, "#FFB74D", "#FF9800")
    
    # === PEQUENAS ENGRENAGENS ===
    small_gear_positions = [
        (center_x - 80, center_y - 200, 40),  # Topo esquerda
        (center_x + 200, center_y - 80, 35),  # Direita
        (center_x + 80, center_y + 200, 45),  # Baixo direita
        (center_x - 200, center_y + 80, 38),  # Esquerda
    ]
    
    for gear_x, gear_y, gear_size in small_gear_positions:
        draw_gear(draw, gear_x, gear_y, gear_size, 8, "#546E7A", "#78909C")
    
    # === PORCAS HEXAGONAIS ===
    nut_positions = [
        (center_x - 180, center_y - 60),
        (center_x + 180, center_y + 60),
        (center_x - 60, center_y + 180),
        (center_x + 60, center_y - 180),
    ]
    
    for nut_x, nut_y in nut_positions:
        draw_hex_nut(draw, nut_x, nut_y, 25, "#795548", "#8D6E63")
    
    # === ROLAMENTO ===
    bearing_x = center_x + 160
    bearing_y = center_y - 160
    draw_bearing(draw, bearing_x, bearing_y, 30, "#37474F", "#607D8B")
    
    # === MOLA/SPRING ===
    spring_x = center_x - 160
    spring_y = center_y + 160
    draw_spring(draw, spring_x, spring_y, 20, 60, "#607D8B", "#78909C")
    
    return img

def draw_gear(draw, center_x, center_y, radius, teeth, color, highlight_color):
    """Desenha uma engrenagem"""
    # Círculo principal
    draw.ellipse([center_x - radius, center_y - radius,
                 center_x + radius, center_y + radius], 
                fill=color)
    
    # Dentes da engrenagem
    tooth_height = radius * 0.2
    for i in range(teeth):
        angle = (2 * math.pi * i) / teeth
        # Ponto externo do dente
        outer_x = center_x + (radius + tooth_height) * math.cos(angle)
        outer_y = center_y + (radius + tooth_height) * math.sin(angle)
        
        # Desenhar dente como pequeno retângulo
        tooth_width = 8
        draw.ellipse([outer_x - tooth_width, outer_y - tooth_width,
                     outer_x + tooth_width, outer_y + tooth_width], 
                    fill=color)
    
    # Círculo interno (furo central)
    inner_radius = radius * 0.3
    draw.ellipse([center_x - inner_radius, center_y - inner_radius,
                 center_x + inner_radius, center_y + inner_radius], 
                fill=highlight_color)
    
    # Furo central menor
    hole_radius = radius * 0.15
    draw.ellipse([center_x - hole_radius, center_y - hole_radius,
                 center_x + hole_radius, center_y + hole_radius], 
                fill="#263238")

def draw_screw(draw, center_x, center_y, radius, color, highlight_color):
    """Desenha um parafuso"""
    # Cabeça do parafuso
    draw.ellipse([center_x - radius, center_y - radius,
                 center_x + radius, center_y + radius], 
                fill=color)
    
    # Brilho metálico
    highlight_radius = radius * 0.7
    draw.ellipse([center_x - highlight_radius, center_y - highlight_radius,
                 center_x + highlight_radius, center_y + highlight_radius], 
                fill=highlight_color)
    
    # Fenda do parafuso (cruz)
    slot_width = 4
    slot_length = radius * 1.2
    # Horizontal
    draw.rectangle([center_x - slot_length, center_y - slot_width,
                   center_x + slot_length, center_y + slot_width], 
                  fill="#263238")
    # Vertical
    draw.rectangle([center_x - slot_width, center_y - slot_length,
                   center_x + slot_width, center_y + slot_length], 
                  fill="#263238")

def draw_wrench(draw, start_x, start_y, end_x, end_y, color, highlight_color):
    """Desenha uma chave inglesa"""
    # Calcular ângulo e comprimento
    dx = end_x - start_x
    dy = end_y - start_y
    length = math.sqrt(dx*dx + dy*dy)
    angle = math.atan2(dy, dx)
    
    # Largura da chave
    width = 20
    
    # Pontos do corpo da chave
    cos_a = math.cos(angle)
    sin_a = math.sin(angle)
    
    # Corpo principal (retângulo rotacionado)
    points = []
    for i, (x_offset, y_offset) in enumerate([(-width/2, 0), (width/2, 0), (width/2, length), (-width/2, length)]):
        x = start_x + x_offset * (-sin_a) + y_offset * cos_a
        y = start_y + x_offset * cos_a + y_offset * sin_a
        points.append((x, y))
    
    draw.polygon(points, fill=color)
    
    # Cabeça da chave (círculo)
    head_radius = 25
    draw.ellipse([start_x - head_radius, start_y - head_radius,
                 start_x + head_radius, start_y + head_radius], 
                fill=color)
    
    # Abertura da chave
    opening_width = 15
    opening_height = 30
    draw.ellipse([start_x - opening_width, start_y - opening_height,
                 start_x + opening_width, start_y + opening_height], 
                fill="#2196F3")  # Mesma cor do fundo

def draw_hex_nut(draw, center_x, center_y, radius, color, highlight_color):
    """Desenha uma porca hexagonal"""
    # Hexágono
    points = []
    for i in range(6):
        angle = (2 * math.pi * i) / 6
        x = center_x + radius * math.cos(angle)
        y = center_y + radius * math.sin(angle)
        points.append((x, y))
    
    draw.polygon(points, fill=color)
    
    # Furo central
    hole_radius = radius * 0.4
    draw.ellipse([center_x - hole_radius, center_y - hole_radius,
                 center_x + hole_radius, center_y + hole_radius], 
                fill="#263238")
    
    # Brilho metálico
    highlight_radius = radius * 0.8
    highlight_points = []
    for i in range(6):
        angle = (2 * math.pi * i) / 6
        x = center_x + highlight_radius * math.cos(angle)
        y = center_y + highlight_radius * math.sin(angle)
        highlight_points.append((x, y))
    
    draw.polygon(highlight_points, fill=highlight_color)

def draw_bearing(draw, center_x, center_y, radius, color, highlight_color):
    """Desenha um rolamento"""
    # Anel externo
    draw.ellipse([center_x - radius, center_y - radius,
                 center_x + radius, center_y + radius], 
                fill=color)
    
    # Anel interno
    inner_radius = radius * 0.6
    draw.ellipse([center_x - inner_radius, center_y - inner_radius,
                 center_x + inner_radius, center_y + inner_radius], 
                fill=highlight_color)
    
    # Furo central
    hole_radius = radius * 0.3
    draw.ellipse([center_x - hole_radius, center_y - hole_radius,
                 center_x + hole_radius, center_y + hole_radius], 
                fill="#263238")
    
    # Esferas do rolamento
    ball_radius = 4
    ball_count = 8
    ball_orbit = radius * 0.8
    for i in range(ball_count):
        angle = (2 * math.pi * i) / ball_count
        ball_x = center_x + ball_orbit * math.cos(angle)
        ball_y = center_y + ball_orbit * math.sin(angle)
        draw.ellipse([ball_x - ball_radius, ball_y - ball_radius,
                     ball_x + ball_radius, ball_y + ball_radius], 
                    fill="#CFD8DC")

def draw_spring(draw, center_x, center_y, radius, height, color, highlight_color):
    """Desenha uma mola"""
    # Base da mola
    base_height = 8
    draw.ellipse([center_x - radius, center_y + height//2 - base_height,
                 center_x + radius, center_y + height//2 + base_height], 
                fill=color)
    
    # Espiras da mola
    coils = 6
    coil_height = height // coils
    for i in range(coils):
        y = center_y - height//2 + i * coil_height
        # Espira esquerda
        draw.arc([center_x - radius, y, center_x, y + coil_height], 
                start=0, end=180, fill=color, width=6)
        # Espira direita
        draw.arc([center_x, y + coil_height//2, center_x + radius, y + coil_height + coil_height//2], 
                start=180, end=360, fill=color, width=6)

def create_foreground_icon():
    """Criar ícone adaptativo (foreground) simplificado"""
    size = 432
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    center_x, center_y = size // 2, size // 2
    
    # Engrenagem principal simplificada
    gear_radius = 80
    draw_gear(draw, center_x, center_y, gear_radius, 10, "#37474F", "#607D8B")
    
    # Chave inglesa simplificada
    wrench_start_x = center_x + 40
    wrench_start_y = center_y - 50
    wrench_end_x = center_x - 50
    wrench_end_y = center_y + 40
    draw_wrench(draw, wrench_start_x, wrench_start_y, wrench_end_x, wrench_end_y, "#FFB74D", "#FF9800")
    
    # Parafusos nos cantos
    screw_positions = [
        (center_x - 80, center_y - 80),
        (center_x + 80, center_y - 80),
        (center_x - 80, center_y + 80),
        (center_x + 80, center_y + 80),
    ]
    
    for screw_x, screw_y in screw_positions:
        draw_screw(draw, screw_x, screw_y, 20, "#424242", "#616161")
    
    return img

# Criar os ícones
if __name__ == "__main__":
    print("Criando ícone 'Relatório de Peças de Manutenção'...")
    
    # Ícone principal
    main_icon = create_maintenance_parts_icon()
    main_icon.save("/home/hendel/Documentos/Padrão_Relatório_app/assets/icon/app_icon.png")
    print("✅ Ícone principal criado: app_icon.png")
    
    # Ícone foreground (adaptativo)
    foreground_icon = create_foreground_icon()
    foreground_icon.save("/home/hendel/Documentos/Padrão_Relatório_app/assets/icon/app_icon_foreground.png")
    print("✅ Ícone foreground criado: app_icon_foreground.png")
    
    print("\n🔧 Conceito do ícone:")
    print("- Engrenagem principal central (peça mecânica)")
    print("- Parafusos nos cantos (fixadores)")
    print("- Chave inglesa (ferramenta de manutenção)")
    print("- Porcas hexagonais (conectores)")
    print("- Rolamento (componente mecânico)")
    print("- Mola (elemento elástico)")
    print("- Cores azuis e metálicas para aspecto industrial")
    print("- Design que remete diretamente a peças de manutenção")
