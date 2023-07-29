Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$form = New-Object System.Windows.Forms.Form
$form.Text = 'Enter Random Number Length'
$form.Width = 300
$form.Height = 150
$form.StartPosition = 'CenterScreen'
$form.Add_Load({
    $form.Activate()
  }
)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Enter Random Number length to generate:'
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(130, 50)
$textBox.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($textBox)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(100, 80)
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = 'Generate'
$button.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.Controls.Add($button)

$form.AcceptButton = $button

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $length = $textBox.Text

    function Get-RandomAlphanumericString {
        [CmdletBinding()]
        Param (
            [int]$length
        )
        Begin {}
        Process {
            Write-Output (-join ((0x21..0x2F) + (0x3A..0x40) + (0x5B..0x60) + (0x7B..0x7E) + (0x30..0x39) + (0x41..0x5A) + (0x61..0x7A) | Get-Random -Count $length | ForEach-Object {[char]$_}))
        }
    }

    Get-RandomAlphanumericString -length $length | clip

    [System.Windows.Forms.MessageBox]::Show("Random string of length $length has been copied to clipboard.")
}