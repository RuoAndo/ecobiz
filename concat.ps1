# 変数の設定
$targetDir = "D:\py_sample"  # 検索するディレクトリのパス
$outputFile = "D:\kabu-all.txt"  # 出力ファイル名

# 出力ファイルが既に存在する場合、削除
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# ディレクトリ内の全ての .ipynb ファイルを再帰的に検索し、内容を結合
Get-ChildItem -Path $targetDir -Filter *.ipynb -Recurse | ForEach-Object {
    # ファイル名を表示
    Write-Host "処理中のファイル: $($_.FullName)"
    
    # ファイル名のセパレータを追加（UTF-8で保存）
    Add-Content -Path $outputFile -Value "`n`n### FILE: $($_.FullName) ###`n" -Encoding UTF8

    # 各.ipynbファイルの内容をUTF-8で結合
    Get-Content -Path $_.FullName -Encoding UTF8 | ForEach-Object { 
        $_ | Add-Content -Path $outputFile -Encoding UTF8
    }
}

Write-Host "結合が完了しました。出力ファイル: $outputFile"

