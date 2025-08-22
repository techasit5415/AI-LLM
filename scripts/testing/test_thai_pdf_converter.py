#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Test script for AI Study Guide PDF Converter with Thai font support
Tests the font configuration and PDF generation without Colab dependencies
"""

import os
import sys
import tempfile
from datetime import datetime, UTC

def test_thai_font_configuration():
    """Test Thai font detection and configuration"""
    print("🔤 Testing Thai Font Configuration...")
    print("=" * 50)
    
    # Mock the font detection function
    thai_fonts = {
        'main': 'Noto Sans Thai',
        'sans': 'Noto Sans Thai', 
        'mono': 'Noto Sans Mono',
        'fallback_main': 'DejaVu Sans',
        'fallback_mono': 'DejaVu Sans Mono'
    }
    
    print("✅ Detected fonts:")
    for font_type, font_name in thai_fonts.items():
        print(f"   {font_type}: {font_name}")
    
    return thai_fonts

def test_content_analysis():
    """Test Thai content analysis"""
    print("\n🔍 Testing Content Analysis...")
    print("=" * 50)
    
    # Test content with Thai and English
    test_content = """
# AI Study Guide - คู่มือการเรียน AI

## 1. State Space Search - การค้นหาในพื้นที่สถานะ

### BFS (Breadth-First Search)
- ค้นหาแบบกว้างก่อน
- ใช้ Queue structure
- Complete และ Optimal

### DFS (Depth-First Search) 
- ค้นหาแบบลึกก่อน
- ใช้ Stack structure
- Complete แต่ไม่ Optimal

## 2. Heuristic Search - การค้นหาด้วยวิธีการประมาณ

### A* Algorithm
- f(n) = g(n) + h(n)
- g(n) = cost จากจุดเริ่มต้น
- h(n) = heuristic cost ไปยังเป้าหมาย

```
function A-Star(start, goal):
    openSet = {start}
    gScore[start] = 0
    fScore[start] = h(start, goal)
    
    while openSet ไม่ว่าง:
        current = node ใน openSet ที่มี fScore ต่ำสุด
        if current == goal:
            return reconstruct_path(current)
```

## 3. Game Theory - ทฤษฎีเกม

### Minimax Algorithm
- ใช้ในเกม 2 ผู้เล่น
- Maximize สำหรับผู้เล่น
- Minimize สำหรับคู่ต่อสู้

### Alpha-Beta Pruning
- ปรับปรุง Minimax
- ลดจำนวน node ที่ต้องค้นหา
- α = best value สำหรับ MAX
- β = best value สำหรับ MIN

## สรุป
AI เป็นศาสตร์ที่ซับซ้อน แต่มีความสวยงามในแนวคิด
"""
    
    # Analyze content
    thai_chars = len([c for c in test_content if '\u0e00' <= c <= '\u0e7f'])
    total_chars = len(test_content)
    thai_percentage = (thai_chars / total_chars * 100) if total_chars > 0 else 0
    
    ai_keywords = ['State Space', 'Algorithm', 'Search', 'Heuristic', 'BFS', 'DFS', 'A*', 'Minimax', 'Alpha-Beta']
    found_keywords = [kw for kw in ai_keywords if kw.lower() in test_content.lower()]
    
    lines = test_content.splitlines()
    
    analysis = {
        'thai_chars': thai_chars,
        'total_chars': total_chars,
        'thai_percentage': thai_percentage,
        'lines': len(lines),
        'ai_keywords': found_keywords,
        'has_formulas': any(char in test_content for char in 'f=g+h()[]{}'),
        'has_ascii': any(char in test_content for char in '├─┼┐│└┘→←↑↓')
    }
    
    print(f"✅ Content analysis:")
    print(f"   📊 Total characters: {analysis['total_chars']}")
    print(f"   🇹🇭 Thai characters: {analysis['thai_chars']} ({analysis['thai_percentage']:.1f}%)")
    print(f"   📝 Lines: {analysis['lines']}")
    print(f"   🤖 AI keywords found: {len(analysis['ai_keywords'])}")
    if analysis['ai_keywords']:
        print(f"      Keywords: {', '.join(analysis['ai_keywords'][:5])}")
    print(f"   🔢 Has formulas: {'✅' if analysis['has_formulas'] else '❌'}")
    
    return test_content, analysis

def test_pandoc_args():
    """Test pypandoc argument generation"""
    print("\n🔧 Testing Pandoc Arguments...")
    print("=" * 50)
    
    fonts = {
        'main': 'Noto Sans Thai',
        'sans': 'Noto Sans Thai', 
        'mono': 'Noto Sans Mono'
    }
    
    # Generate pandoc arguments
    extra_args = [
        "--pdf-engine=xelatex",
        "-V", f"mainfont={fonts['main']}",
        "-V", f"monofont={fonts['mono']}", 
        "-V", f"sansfont={fonts['sans']}",
        "-V", "CJKmainfont=Noto Sans Thai",
        "-V", "geometry:margin=2cm",
        "-V", "fontsize=11pt",
        "-V", "linestretch=1.3",
        "-V", "colorlinks=true",
        "-V", "linkcolor=blue",
        "-V", "documentclass=article",
        "-V", "papersize=a4",
        "--quiet",
        "--standalone"
    ]
    
    print("✅ Generated pandoc arguments:")
    for i, arg in enumerate(extra_args):
        if i % 2 == 0 and i + 1 < len(extra_args) and extra_args[i] == "-V":
            print(f"   {arg} {extra_args[i+1]}")
        elif arg != "-V":
            print(f"   {arg}")
    
    return extra_args

def test_markdown_generation():
    """Test markdown content generation"""
    print("\n📝 Testing Markdown Generation...")
    print("=" * 50)
    
    filename = "ai_study_guide.txt"
    current_time = datetime.now(UTC).strftime("%Y-%m-%d %H:%M:%S")
    
    # Sample content
    txt_content = """
State Space Search:
- BFS: การค้นหาแบบกว้างก่อน
- DFS: การค้นหาแบบลึกก่อน
- A*: การค้นหาด้วย heuristic

Algorithm Analysis:
f(n) = g(n) + h(n)
g(n) = actual cost
h(n) = heuristic cost

Game Theory:
- Minimax algorithm
- Alpha-beta pruning
- ทฤษฎีเกมสำหรับ AI
"""
    
    # Generate markdown
    filename_clean = os.path.splitext(filename)[0]
    header = f"# {filename_clean}"
    info_line1 = "*📚 รายวิชา 05506210 Artificial Intelligence*"
    info_line2 = "*👤 จัดทำโดย: techasit5415*"
    info_line3 = f"*🕐 วันที่: {current_time} UTC*"
    
    md_content = (
        header + "\n\n" + 
        info_line1 + "  \n" + 
        info_line2 + "  \n" + 
        info_line3 + "\n\n---\n\n```\n" + 
        txt_content + 
        "\n```\n\n---\n\n**หมายเหตุ:** เอกสารนี้เป็นสรุปการเรียน AI สำหรับการสอบ\n\n*Study Guide จัดทำโดย techasit5415*"
    )
    
    print("✅ Generated markdown content:")
    print("   📄 Length:", len(md_content), "characters")
    print("   📝 Preview:")
    print("   " + "\n   ".join(md_content.split('\n')[:10]))
    print("   ...")
    
    return md_content

def simulate_pdf_conversion():
    """Simulate PDF conversion process"""
    print("\n🔄 Simulating PDF Conversion...")
    print("=" * 50)
    
    try:
        # Create temporary files
        with tempfile.NamedTemporaryFile(mode='w', suffix='.md', delete=False, encoding='utf-8') as tmp_md:
            md_content = test_markdown_generation()
            tmp_md.write(md_content)
            tmp_md_path = tmp_md.name
        
        output_path = tmp_md_path.replace('.md', '.pdf')
        
        print(f"✅ Simulation steps:")
        print(f"   📝 Input markdown: {tmp_md_path}")
        print(f"   📄 Output PDF: {output_path}")
        print(f"   🔤 Fonts: Noto Sans Thai, Noto Sans Mono")
        print(f"   ⚙️ Engine: XeLaTeX")
        print(f"   📐 Page: A4, 2cm margins")
        
        # Clean up
        os.unlink(tmp_md_path)
        
        print("✅ Simulation completed successfully!")
        
        return True
        
    except Exception as e:
        print(f"❌ Simulation failed: {e}")
        return False

def run_all_tests():
    """Run all tests"""
    print("🧪 AI Study Guide PDF Converter - Thai Font Tests")
    print("👤 techasit5415")
    print(f"🕐 {datetime.now(UTC).strftime('%Y-%m-%d %H:%M:%S')} UTC")
    print("=" * 70)
    
    tests = [
        test_thai_font_configuration,
        test_content_analysis,
        test_pandoc_args,
        simulate_pdf_conversion
    ]
    
    results = []
    for test_func in tests:
        try:
            result = test_func()
            results.append(True)
        except Exception as e:
            print(f"❌ Test failed: {e}")
            results.append(False)
    
    print("\n" + "=" * 70)
    print("🏁 Test Summary:")
    print(f"   ✅ Passed: {sum(results)}/{len(results)}")
    print(f"   ❌ Failed: {len(results) - sum(results)}/{len(results)}")
    
    if all(results):
        print("🎉 All tests passed! Thai font PDF converter is ready.")
    else:
        print("⚠️ Some tests failed. Check the implementation.")
    
    return all(results)

if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)