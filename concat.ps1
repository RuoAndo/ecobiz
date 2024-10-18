# 変数の設定
$targetDir = "D:\py_sample"  # 検索するディレクトリのパス
$tempDir = "D:\py_temp"  # 変換後の .py ファイルを保存するディレクトリ
$outputFile = "D:\kabu-all.txt"  # 結合結果の出力ファイル

# 一時ディレクトリが存在しない場合は作成
if (!(Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir
}

# 出力ファイルが既に存在する場合、削除
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# .ipynb ファイルを再帰的に検索して .py に変換し保存
Get-ChildItem -Path $targetDir -Filter *.ipynb -Recurse | ForEach-Object {
    $ipynbPath = $_.FullName
    $pyPath = Join-Path $tempDir ($_.BaseName + ".py")

    try {
        # Pythonコマンドで .ipynb を .py に変換
        Write-Host "変換中: $ipynbPath -> $pyPath"
        python -m nbconvert --to script $ipynbPath --output $pyPath
    } catch {
        Write-Host "変換エラー: $ipynbPath"
    }
}

Write-Host "すべての.ipynbファイルが変換され、$tempDir に保存されました。"

# 変換された .py ファイルを結合
Get-ChildItem -Path $tempDir -Filter *.py.txt | ForEach-Object {
    Write-Host "結合中のファイル: $($_.FullName)"

    try {
        # ファイル名のセパレータを追加
        Add-Content -Path $outputFile -Value "`n`n### FILE: $($_.FullName) ###`n" -Encoding UTF8

        # 各Pythonファイルの内容をUTF-8で結合
        Get-Content -Path $_.FullName -Encoding UTF8 | ForEach-Object {
            $_ | Add-Content -Path $outputFile -Encoding UTF8
        }
    } catch {
        Write-Host "結合エラー: $($_.FullName)"
    }
}

if (Test-Path $outputFile) {
    Write-Host "結合が完了しました。出力ファイル: $outputFile"
} else {
    Write-Host "結合に失敗しました。kabu-all.txt が生成されていません。"
}

