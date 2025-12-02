Param([parameter(mandatory = $true)][string]$id, [parameter(mandatory = $true)][string]$url)

. "./setting.ps1"

$fullid = $fullid_prefix + $id.ToLower()
$repo_path = "$repo_basepath$fullid"

$title = (Invoke-WebRequest $url).ParsedHtml.getElementsByTagName("title")[0].innerText
$env:GLAB_NO_PROMPT = "1"
glab repo create $fullid --skipGitInit --description "$title $url"

if (Test-Path "$repo_path/.git") {
    Write-Output "repo cloned"
}
else {
    git clone $template_repo $repo_path
}
Set-Location $repo_path
git remote rename origin upstream
git remote add origin "$origin_prefix$fullid.git"
git push --set-upstream origin $default_branch
GitExtensions.exe openrepo $repo_path
