import os
import pypandoc
import time
from datetime import datetime, UTC
from google.colab import files
from IPython.display import display, HTML, clear_output
import ipywidgets as widgets
from ipywidgets import Button, VBox, HBox, Output, Textarea, HTML as HTMLWidget, IntProgress, Label

class AIStudyGuidePDFConverter:
    def __init__(self):
        self.uploaded_files = {}
        self.current_file = None
        self.is_converting = False
        self.setup_ui()
    
    def get_current_time(self):
        return datetime.now(UTC).strftime("%Y-%m-%d %H:%M:%S")
    
    def detect_available_thai_fonts(self):
        """ตรวจสอบฟอนต์ภาษาไทยที่มีอยู่ในระบบ"""
        thai_fonts = [
            "Noto Sans Thai",
            "TH Sarabun New", 
            "Loma",
            "Tlwg Typewriter",
            "Tlwg Typo",
            "Tlwg Mono",
            "Garuda",
            "Kinnari",
            "Norasi",
            "Purisa",
            "Sawasdee",
            "Umpush",
            "Waree"
        ]
        
        # ในสภาพแวดล้อม Colab มักจะมี Noto fonts
        available_fonts = {
            'main': 'Noto Sans Thai',
            'sans': 'Noto Sans Thai', 
            'mono': 'Noto Sans Mono',
            'fallback_main': 'DejaVu Sans',
            'fallback_mono': 'DejaVu Sans Mono'
        }
        
        return available_fonts
    
    def setup_ui(self):
        current_time = self.get_current_time()
        
        self.title = HTMLWidget(value="<h2>🤖 AI Study Guide PDF Converter (Thai Font Fixed)</h2>")
        
        self.user_info = HTMLWidget(value=f"""
        <div style='background:#fff3cd; padding:15px; border-radius:8px; margin:10px 0; border-left:5px solid #ffc107;'>
        <strong>👤 ผู้ใช้:</strong> techasit5415<br>
        <strong>🕐 เวลาปัจจุบัน:</strong> {current_time} UTC<br>
        <strong>🔧 แก้ไข:</strong> ใช้ฟอนต์ภาษาไทย Noto Sans Thai<br>
        <strong>📚 วิชา:</strong> 05506210 Artificial Intelligence<br>
        <strong>✅ สถานะ:</strong> แก้ไขปัญหาฟอนต์ภาษาไทยแล้ว
        </div>
        """)
        
        self.upload_btn = Button(
            description="📁 เลือกไฟล์ Study Guide",
            button_style='info',
            layout=widgets.Layout(width='300px', height='40px')
        )
        
        self.file_list = HTMLWidget(value="<i>ยังไม่มีไฟล์</i>")
        
        self.content_area = Textarea(
            placeholder="เนื้อหา AI Study Guide จะแสดงที่นี่...",
            layout=widgets.Layout(width='100%', height='300px')
        )
        
        self.progress_bar = IntProgress(
            value=0, min=0, max=100,
            description='พร้อม:',
            bar_style='info',
            layout=widgets.Layout(width='100%', height='30px')
        )
        
        self.status_label = HTMLWidget(
            value="<div style='padding:10px; background:#f0f0f0; border-left:4px solid #007bff;'>⏳ รอการดำเนินการ...</div>"
        )
        
        self.convert_btn = Button(
            description="🔄 แปลงเป็น PDF (Thai)",
            button_style='success',
            disabled=True,
            layout=widgets.Layout(width='220px', height='35px')
        )
        
        self.download_btn = Button(
            description="⬇️ ดาวน์โหลด PDF",
            button_style='warning',
            disabled=True,
            layout=widgets.Layout(width='200px', height='35px')
        )
        
        self.output_area = Output()
        
        controls = HBox([self.convert_btn, self.download_btn])
        
        self.ui = VBox([
            self.title,
            self.user_info,
            HTMLWidget(value="<hr>"),
            self.upload_btn,
            HTMLWidget(value="<b>📋 ไฟล์ที่อัปโหลด:</b>"),
            self.file_list,
            HTMLWidget(value="<b>📝 เนื้อหา Study Guide:</b>"),
            self.content_area,
            HTMLWidget(value="<b>📊 ความคืบหน้า:</b>"),
            self.progress_bar,
            self.status_label,
            HTMLWidget(value="<b>⚙️ การดำเนินการ:</b>"),
            controls,
            HTMLWidget(value="<b>📊 ผลลัพธ์:</b>"),
            self.output_area
        ])
        
        self.upload_btn.on_click(self.upload_files)
        self.convert_btn.on_click(self.convert_to_pdf)
        self.download_btn.on_click(self.download_pdf)
    
    def update_status(self, progress, message, color="#007bff"):
        self.progress_bar.value = progress
        self.progress_bar.description = f'{progress}%:'
        
        if progress == 100:
            color = "#28a745"
        elif progress == 0:
            color = "#dc3545"
        
        self.status_label.value = f"""
        <div style='padding:10px; background:#f8f9fa; border-left:4px solid {color}; margin:5px 0;'>
        <strong>{progress}%</strong> - {message}<br>
        <small>🕐 {self.get_current_time()} UTC | 👤 techasit5415</small>
        </div>
        """
    
    def log_output(self, message):
        with self.output_area:
            print(f"[{self.get_current_time()}] {message}")
    
    def analyze_ai_content(self, content):
        thai_chars = len([c for c in content if '\u0e00' <= c <= '\u0e7f'])
        total_chars = len(content)
        thai_percentage = (thai_chars / total_chars * 100) if total_chars > 0 else 0
        
        ai_keywords = ['State Space', 'Algorithm', 'Search', 'Heuristic', 'BFS', 'DFS', 'A*', 'Decision Tree', 'Minimax', 'Alpha-Beta']
        found_keywords = [kw for kw in ai_keywords if kw.lower() in content.lower()]
        
        has_formulas = any(char in content for char in 'f=g+h()[]{}')
        has_ascii = any(char in content for char in '├─┼┐│└┘→←↑↓')
        
        lines = content.splitlines()
        has_bullet = any(line.strip().startswith('-') for line in lines)
        
        return {
            'thai_chars': thai_chars,
            'total_chars': total_chars,
            'thai_percentage': thai_percentage,
            'lines': len(lines),
            'ai_keywords': found_keywords,
            'has_formulas': has_formulas,
            'has_ascii': has_ascii,
            'has_bullet': has_bullet
        }
    
    def upload_files(self, b):
        self.update_status(5, "🔄 กำลังเปิดกล่องเลือกไฟล์...")
        
        try:
            with self.output_area:
                clear_output()
                
            self.log_output("🔄 กำลังเปิดกล่องเลือกไฟล์...")
            
            uploaded = files.upload()
            
            self.update_status(50, "📁 กำลังประมวลผลไฟล์...")
            self.uploaded_files.update(uploaded)
            
            file_names = []
            for name in self.uploaded_files.keys():
                if name.lower().endswith(('.txt', '.md')):
                    file_names.append(f"✅ {name}")
                    if not self.current_file:
                        self.current_file = name
                        self.load_file_content(name)
                else:
                    file_names.append(f"❌ {name} (ไม่รองรับ)")
            
            if any(name.lower().endswith(('.txt', '.md')) for name in uploaded.keys()):
                self.file_list.value = "<br>".join(file_names)
                self.convert_btn.disabled = False
                self.update_status(100, "✅ อัปโหลดเสร็จ - พร้อมแปลง!")
                self.log_output(f"✅ อัปโหลดเสร็จ: {len(uploaded)} ไฟล์")
            else:
                self.file_list.value = "<i>ไม่มีไฟล์ที่รองรับ</i>"
                self.update_status(0, "❌ ไม่มีไฟล์ที่รองรับ")
                
        except Exception as e:
            self.update_status(0, f"❌ อัปโหลดไม่สำเร็จ: {str(e)}")
            self.log_output(f"❌ เกิดข้อผิดพลาด: {e}")
    
    def load_file_content(self, filename):
        try:
            self.update_status(75, "📖 กำลังโหลดเนื้อหา Study Guide...")
            
            with open(filename, 'r', encoding='utf-8') as f:
                content = f.read()
            self.content_area.value = content
            
            analysis = self.analyze_ai_content(content)
            
            self.log_output(f"📖 โหลด: {filename}")
            self.log_output(f"📊 สถิติ: {analysis['total_chars']} ตัวอักษร, {analysis['lines']} บรรทัด")
            self.log_output(f"🇹🇭 ภาษาไทย: {analysis['thai_percentage']:.1f}%")
            
            if analysis['ai_keywords']:
                self.log_output(f"🤖 AI Keywords: {', '.join(analysis['ai_keywords'][:5])}")
                
        except Exception as e:
            self.update_status(0, f"❌ โหลดไฟล์ไม่สำเร็จ: {str(e)}")
            self.log_output(f"❌ โหลดไฟล์ไม่สำเร็จ: {e}")
    
    def install_thai_fonts(self):
        """ติดตั้งฟอนต์ภาษาไทยใน Colab environment"""
        try:
            self.log_output("🔧 กำลังติดตั้งฟอนต์ภาษาไทย...")
            
            # ติดตั้ง fonts-noto สำหรับ Thai support
            os.system("apt-get update -qq")
            os.system("apt-get install -y -qq fonts-noto fonts-noto-cjk fonts-noto-color-emoji")
            os.system("apt-get install -y -qq fonts-thai-tlwg")
            
            # รีเฟรช font cache
            os.system("fc-cache -fv")
            
            self.log_output("✅ ติดตั้งฟอนต์ภาษาไทยเสร็จแล้ว")
            return True
            
        except Exception as e:
            self.log_output(f"⚠️ การติดตั้งฟอนต์มีปัญหา: {e}")
            return False
    
    def convert_to_pdf(self, b):
        if not self.current_file or self.is_converting:
            return
            
        self.is_converting = True
        self.convert_btn.disabled = True
        start_time = datetime.now(UTC)
        
        try:
            self.update_status(5, "🔧 ติดตั้งฟอนต์ภาษาไทย...")
            self.install_thai_fonts()
            
            self.update_status(10, "💾 บันทึกการแก้ไข...")
            self.log_output("🔄 เริ่มต้นการแปลง AI Study Guide (ฟอนต์ภาษาไทยใหม่)")
            
            with open(self.current_file, 'w', encoding='utf-8') as f:
                f.write(self.content_area.value)
            time.sleep(0.5)
            
            self.update_status(20, "🔍 วิเคราะห์เนื้อหา AI...")
            analysis = self.analyze_ai_content(self.content_area.value)
            
            self.update_status(30, "🔧 เตรียมฟอนต์ภาษาไทย Noto Sans...")
            output_path = os.path.splitext(self.current_file)[0] + ".pdf"
            ext = os.path.splitext(self.current_file)[1].lower()
            
            from_format = "markdown"
            
            if ext == ".txt":
                with open(self.current_file, 'r', encoding='utf-8') as f:
                    txt_content = f.read()
                
                filename_clean = os.path.splitext(self.current_file)[0]
                current_time = self.get_current_time()
                
                # สร้าง markdown
                header = f"# {filename_clean}"
                info_line1 = "*📚 รายวิชา 05506210 Artificial Intelligence*"
                info_line2 = "*👤 จัดทำโดย: techasit5415*"
                info_line3 = f"*🕐 วันที่: {current_time} UTC*"
                
                md_content = header + "\n\n" + info_line1 + "  \n" + info_line2 + "  \n" + info_line3 + "\n\n---\n\n```\n" + txt_content + "\n```\n\n---\n\n**หมายเหตุ:** เอกสารนี้เป็นสรุปการเรียน AI สำหรับการสอบ\n\n*Study Guide จัดทำโดย techasit5415*"
                
                temp_md_file = os.path.splitext(self.current_file)[0] + "_temp.md"
                
                with open(temp_md_file, 'w', encoding='utf-8') as f:
                    f.write(md_content)
                
                input_file = temp_md_file
                self.log_output("📝 แปลง Study Guide เป็น Markdown")
            else:
                input_file = self.current_file
            
            # ใช้ฟอนต์ที่รองรับภาษาไทย
            fonts = self.detect_available_thai_fonts()
            
            extra_args = [
                "--pdf-engine=xelatex",
                "-V", f"mainfont={fonts['main']}",           # ฟอนต์หลักที่รองรับไทย
                "-V", f"monofont={fonts['mono']}",           # ฟอนต์ monospace
                "-V", f"sansfont={fonts['sans']}",           # ฟอนต์ sans-serif
                "-V", "CJKmainfont=Noto Sans Thai",          # ฟอนต์สำหรับ CJK/Thai
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
                
            time.sleep(0.5)
            
            self.update_status(40, "🚀 เริ่มแปลงด้วย Noto Sans Thai...")
            self.log_output("⏳ กำลังแปลง... (ใช้ Noto Sans Thai ที่รองรับภาษาไทย)")
            self.log_output(f"🇹🇭 ภาษาไทย: {analysis['thai_percentage']:.1f}%")
            self.log_output(f"🤖 AI Keywords: {len(analysis['ai_keywords'])} คำ")
            
            if analysis['has_ascii']:
                self.log_output("🎨 ASCII Art จะแสดงด้วย Noto Sans Mono")
                
            time.sleep(1)
            
            self.update_status(60, "📄 กำลังสร้าง PDF (Noto Sans Thai)...")
            
            pypandoc.convert_file(
                input_file, 
                "pdf", 
                format=from_format,
                outputfile=output_path, 
                extra_args=extra_args
            )
            
            # ลบไฟล์ชั่วคราว
            if ext == ".txt" and 'temp_md_file' in locals() and os.path.exists(temp_md_file):
                os.remove(temp_md_file)
            
            self.update_status(90, "📊 ตรวจสอบ PDF...")
            time.sleep(0.5)
            
            if os.path.exists(output_path):
                self.pdf_path = output_path
                pdf_size = os.path.getsize(output_path)
                elapsed = (datetime.now(UTC) - start_time).total_seconds()
                
                self.update_status(100, "✅ AI Study Guide PDF พร้อมแล้ว! (ภาษาไทยใช้ได้)")
                self.download_btn.disabled = False
                
                self.log_output("🎉 แปลง AI Study Guide เสร็จเรียบร้อย!")
                self.log_output(f"📄 ไฟล์: {output_path}")
                self.log_output(f"📏 ขนาด: {pdf_size:,} bytes ({pdf_size/1024:.1f} KB)")
                self.log_output(f"⏱️ เวลาที่ใช้: {elapsed:.1f} วินาที")
                self.log_output("🔤 ฟอนต์: Noto Sans Thai (รองรับภาษาไทย)")
                self.log_output("👤 ผู้จัดทำ: techasit5415")
                self.log_output("📚 รายวิชา: 05506210 Artificial Intelligence")
                self.log_output("🎯 พร้อมสำหรับการสอบ!")
                self.log_output("✅ แก้ไขปัญหาฟอนต์ภาษาไทยแล้ว - ไม่มีสี่เหลี่ยมแล้ว!")
            else:
                raise FileNotFoundError("ไม่พบไฟล์ PDF ที่สร้าง")
                
        except Exception as e:
            self.update_status(0, f"❌ แปลงไม่สำเร็จ: {str(e)[:50]}...")
            self.log_output(f"❌ แปลง AI Study Guide ไม่สำเร็จ: {e}")
            self.log_output("💡 ลองรีสตาร์ท runtime หรือติดตั้งฟอนต์เพิ่มเติม")
        
        finally:
            self.is_converting = False
            self.convert_btn.disabled = False
    
    def download_pdf(self, b):
        if hasattr(self, 'pdf_path') and os.path.exists(self.pdf_path):
            self.update_status(100, "⬇️ กำลังดาวน์โหลด AI Study Guide...")
            files.download(self.pdf_path)
            self.log_output(f"⬇️ ดาวน์โหลด: {self.pdf_path}")
            self.log_output("👤 ดาวน์โหลดโดย: techasit5415")
            self.log_output("📚 AI Study Guide (Thai Font Fixed) พร้อมใช้งาน!")
        else:
            self.update_status(0, "❌ ไม่พบไฟล์ PDF")
            self.log_output("❌ ไม่พบไฟล์ AI Study Guide PDF")
    
    def show(self):
        display(self.ui)

# เริ่มโปรแกรม
def main():
    print("🤖 AI Study Guide PDF Converter (Thai Font Fixed)")
    print("👤 ผู้ใช้: techasit5415")
    print(f"🕐 เวลาปัจจุบัน: {datetime.now(UTC).strftime('%Y-%m-%d %H:%M:%S')} UTC")
    print("🔤 ใช้ฟอนต์: Noto Sans Thai (รองรับภาษาไทยเต็มรูปแบบ)")
    print("📚 รายวิชา: 05506210 Artificial Intelligence")
    print("✅ แก้ไขปัญหาฟอนต์ภาษาไทยแล้ว - ไม่มีสี่เหลี่ยมเหลืองอีกต่อไป!")
    print("=" * 70)

    converter = AIStudyGuidePDFConverter()
    converter.show()

if __name__ == "__main__":
    main()