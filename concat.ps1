# �ϐ��̐ݒ�
$targetDir = "D:\py_sample"  # ��������f�B���N�g���̃p�X
$tempDir = "D:\py_temp"  # �ϊ���� .py �t�@�C����ۑ�����f�B���N�g��
$outputFile = "D:\kabu-all.txt"  # �������ʂ̏o�̓t�@�C��

# �ꎞ�f�B���N�g�������݂��Ȃ��ꍇ�͍쐬
if (!(Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir
}

# �o�̓t�@�C�������ɑ��݂���ꍇ�A�폜
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# .ipynb �t�@�C�����ċA�I�Ɍ������� .py �ɕϊ����ۑ�
Get-ChildItem -Path $targetDir -Filter *.ipynb -Recurse | ForEach-Object {
    $ipynbPath = $_.FullName
    $pyPath = Join-Path $tempDir ($_.BaseName + ".py")

    try {
        # Python�R�}���h�� .ipynb �� .py �ɕϊ�
        Write-Host "�ϊ���: $ipynbPath -> $pyPath"
        python -m nbconvert --to script $ipynbPath --output $pyPath
    } catch {
        Write-Host "�ϊ��G���[: $ipynbPath"
    }
}

Write-Host "���ׂĂ�.ipynb�t�@�C�����ϊ�����A$tempDir �ɕۑ�����܂����B"

# �ϊ����ꂽ .py �t�@�C��������
Get-ChildItem -Path $tempDir -Filter *.py.txt | ForEach-Object {
    Write-Host "�������̃t�@�C��: $($_.FullName)"

    try {
        # �t�@�C�����̃Z�p���[�^��ǉ�
        Add-Content -Path $outputFile -Value "`n`n### FILE: $($_.FullName) ###`n" -Encoding UTF8

        # �ePython�t�@�C���̓��e��UTF-8�Ō���
        Get-Content -Path $_.FullName -Encoding UTF8 | ForEach-Object {
            $_ | Add-Content -Path $outputFile -Encoding UTF8
        }
    } catch {
        Write-Host "�����G���[: $($_.FullName)"
    }
}

if (Test-Path $outputFile) {
    Write-Host "�������������܂����B�o�̓t�@�C��: $outputFile"
} else {
    Write-Host "�����Ɏ��s���܂����Bkabu-all.txt ����������Ă��܂���B"
}

