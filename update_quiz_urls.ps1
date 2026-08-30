# ==========================================
# KONFIGURASI REPO GITHUB
# Ganti BEY dengan username akun GitHub kamu yang sebenarnya jika berbeda
# ==========================================
$githubUsername = "kebol97"
$githubRepo     = "gametbcococue"
$githubBranch   = "main"

# URL CDN Base ke folder gambar_pemain
$baseUrl = "https://cdn.jsdelivr.net/gh/$githubUsername/$githubRepo@$githubBranch/gambar_pemain"

$jsonFile = "quiz.json"

if (!(Test-Path -Path $jsonFile)) {
    Write-Host "File $jsonFile tidak ditemukan! Pastikan file quiz.json berada di folder ini." -ForegroundColor Red
    exit
}

# Baca data JSON
$quizData = Get-Content -Path $jsonFile -Raw -Encoding UTF8 | ConvertFrom-Json

Write-Host "Memproses $($quizData.Count) data soal ke URL GitHub CDN..." -ForegroundColor Cyan

foreach ($item in $quizData) {
    # Ambil nama jawaban yang benar dari daftar options
    $correctName = $item.options[$item.correctAnswerIndex]
    
    # Format nama file lokal: 1_lionel_messi.jpg
    $safeName = ($correctName.ToLower() -replace '[^a-z0-9]', '_') -replace '_+', '_'
    $fileName = "$($item.id)_$safeName.jpg"
    
    # Update field imageUrl
    $item.imageUrl = "$baseUrl/$fileName"
}

# Simpan langsung menimpa quiz.json atau ke file baru
$outputJson = "quiz_github_ready.json"
$quizData | ConvertTo-Json -Depth 5 | Out-File -FilePath $outputJson -Encoding utf8

Write-Host "`nSELESAI!" -ForegroundColor Green
Write-Host "File baru yang sudah diperbarui: $outputJson"