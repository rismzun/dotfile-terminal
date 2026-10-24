fastfetch
Write-Host ""
oh-my-posh init pwsh --config "C:\Users\ACER\Downloads\honukai.omp.json" | Invoke-Expression

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

# สั่งลบคำสั่ง ls ดั้งเดิมของ Windows
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue

# ปรับแต่งคำสั่ง ls ให้สวยงามด้วย eza
function ls {
    # เช็คว่าพิมพ์ตัวเลขตามหลังมาหรือไม่
    if ($args.Count -gt 0 -and $args[0] -match '^[0-9]+$') {
        $level = $args[0]
        
        # ถ้ามีการพิมพ์ Path ตามหลังตัวเลขมาด้วย (เช่น ls 2 D:\Projects)
        if ($args.Count -gt 1) {
            $remainingArgs = $args[1..($args.Count-1)]
            eza --tree --level=$level --icons $remainingArgs
        } 
        # ถ้าพิมพ์แค่ ls แล้วตามด้วยเลขเฉยๆ (เช่น ls 2)
        else {
            eza --tree --level=$level --icons
        }
    } 
    else {
        # ถ้าไม่ได้พิมพ์ตัวเลข ให้รันแบบตารางละเอียดปกติ
        eza -la --icons --git $args
    }
  Write-Host ""
}

# สั่งลบ Alias คำว่า cd ดั้งเดิมของ Windows ออกก่อน
Remove-Item Alias:cd -Force -ErrorAction SilentlyContinue

# สร้างฟังก์ชัน cd ใหม่ให้ทำงานแบบอัจฉริยะ
function cd {
    if ($args.Count -eq 0) {
        # 1. พิมพ์ cd เฉยๆ ถอย 1 ขั้น
        Set-Location ..
    } 
    else {
        # 2. เช็คว่าสิ่งที่พิมพ์ตามหลังมา เป็น "ตัวเลข" ล้วนๆ หรือไม่
        if ($args[0] -match '^[0-9]+$') {
            $level = [int]$args[0]
            
            # ถ้าตัวเลขมากกว่า 0 ให้ถอยตามจำนวนนั้น
            if ($level -gt 0) {
                $backPath = "..\" * $level
                Set-Location $backPath
            }
        } 
        else {
            # 3. ถ้าไม่ใช่ตัวเลข (เป็นชื่อโฟลเดอร์หรือ Path) ให้เข้าไปตามปกติ
            Set-Location $args[0]
        }
    }
    
    # เช็คว่าคำสั่งย้ายโฟลเดอร์ด้านบนทำงานสำเร็จหรือไม่ (ไม่มี Error)
    if ($?) {
        # เว้น 1 บรรทัดเพื่อให้ดูสบายตา
        Write-Host ""
        
        # เรียกใช้ฟังก์ชัน ls (eza) ของเรา
        ls
    }
}

function home {
    cd "$Home\Desktop"
}

Remove-Item Alias:cls -Force -ErrorAction SilentlyContinue

function cls {
    Clear-Host
    fastfetch
    Write-Host ""
}

Set-Alias -Name new -Value New-Item
Set-Alias -Name m -Value Micro
Set-Alias -Name ff -Value fastfetch
