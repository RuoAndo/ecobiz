# �ϐ��̐ݒ�
$targetDir = "D:\py_sample"  # ��������f�B���N�g���̃p�X
$outputFile = "D:\kabu-all.txt"  # �o�̓t�@�C����

# �o�̓t�@�C�������ɑ��݂���ꍇ�A�폜
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# �f�B���N�g�����̑S�Ă� .ipynb �t�@�C�����ċA�I�Ɍ������A���e������
Get-ChildItem -Path $targetDir -Filter *.ipynb -Recurse | ForEach-Object {
    # �t�@�C������\��
    Write-Host "�������̃t�@�C��: $($_.FullName)"
    
    # �t�@�C�����̃Z�p���[�^��ǉ��iUTF-8�ŕۑ��j
    Add-Content -Path $outputFile -Value "`n`n### FILE: $($_.FullName) ###`n" -Encoding UTF8

    # �e.ipynb�t�@�C���̓��e��UTF-8�Ō���
    Get-Content -Path $_.FullName -Encoding UTF8 | ForEach-Object { 
        $_ | Add-Content -Path $outputFile -Encoding UTF8
    }
}

Write-Host "�������������܂����B�o�̓t�@�C��: $outputFile"

