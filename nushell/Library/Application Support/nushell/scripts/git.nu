# Git aliases for Nushell
# Ported from https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git

# Helper functions
def git_current_branch [] {
  git rev-parse --abbrev-ref HEAD | str trim
}

def git_main_branch [] {
  let branches = ["main" "trunk" "mainline" "default" "stable" "master"]
  for branch in $branches {
    let result = (do { git show-ref --verify $"refs/heads/($branch)" } | complete)
    if $result.exit_code == 0 {
      return $branch
    }
  }
  # Fallback: try remote HEAD
  for remote in ["origin" "upstream"] {
    let result = (do { git rev-parse --abbrev-ref $"($remote)/HEAD" } | complete)
    if $result.exit_code == 0 {
      let ref = ($result.stdout | str trim)
      if ($ref | str starts-with $"($remote)/") {
        return ($ref | str replace $"($remote)/" "")
      }
    }
  }
  "master"
}

def git_develop_branch [] {
  let branches = ["dev" "devel" "develop" "development"]
  for branch in $branches {
    let result = (do { git show-ref --verify $"refs/heads/($branch)" } | complete)
    if $result.exit_code == 0 {
      return $branch
    }
  }
  "develop"
}

# Go to git root
def grt [] { cd (git rev-parse --show-toplevel | str trim) }

# Basic git
alias g = git
alias ga = git add
alias gaa = git add --all
alias gapa = git add --patch
alias gau = git add --update
alias gav = git add --verbose

# Apply / AM
alias gam = git am
alias gama = git am --abort
alias gamc = git am --continue
alias gamscp = git am --show-current-patch
alias gams = git am --skip
alias gap = git apply
alias gapt = git apply --3way

# Bisect
alias gbs = git bisect
alias gbsb = git bisect bad
alias gbsg = git bisect good
alias gbsn = git bisect new
alias gbso = git bisect old
alias gbsr = git bisect reset
alias gbss = git bisect start

# Blame
alias gbl = git blame -w

# Branch
alias gb = git branch
alias gba = git branch --all
alias gbd = git branch --delete
alias gbD = git branch --delete --force
alias gbm = git branch --move
alias gbnm = git branch --no-merged
alias gbr = git branch --remote

def ggsup [] {
  git branch $"--set-upstream-to=origin/(git_current_branch)"
}

def gbgd [] {
  git branch --no-color -vv | lines | where ($it =~ ": gone]") | each { |line| $line | str trim | split row " " | first } | each { |b| git branch -d $b }
}

def gbgD [] {
  git branch --no-color -vv | lines | where ($it =~ ": gone]") | each { |line| $line | str trim | split row " " | first } | each { |b| git branch -D $b }
}

# Checkout
alias gco = git checkout
alias gcor = git checkout --recurse-submodules
alias gcb = git checkout -b
alias gcB = git checkout -B

def gcd [] { git checkout (git_develop_branch) }
def gcm [] { git checkout (git_main_branch) }

# Cherry-pick
alias gcp = git cherry-pick
alias gcpa = git cherry-pick --abort
alias gcpc = git cherry-pick --continue

# Clean
alias gclean = git clean --interactive -d

# Clone
alias gcl = git clone --recurse-submodules
alias gclf = git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules

# Commit
alias gcmsg = git commit --message
alias gc = git commit --verbose
alias gca = git commit --verbose --all
def "gca!" [] { git commit --verbose --all --amend }
def "gcan!" [] { git commit --verbose --all --no-edit --amend }
def "gcans!" [] { git commit --verbose --all --signoff --no-edit --amend }
def "gcann!" [] { git commit --verbose --all --date=now --no-edit --amend }
def "gc!" [] { git commit --verbose --amend }
alias gcn = git commit --verbose --no-edit
def "gcn!" [] { git commit --verbose --no-edit --amend }
alias gcam = git commit --all --message
alias gcas = git commit --all --signoff
alias gcasm = git commit --all --signoff --message
alias gcs = git commit --gpg-sign
alias gcss = git commit --gpg-sign --signoff
alias gcssm = git commit --gpg-sign --signoff --message
alias gcsm = git commit --signoff --message
alias gcfu = git commit --fixup

# Config
alias gcf = git config --list

# Describe
def gdct [] { git describe --tags (git rev-list --tags --max-count=1 | str trim) }

# Diff
alias gd = git diff
alias gdca = git diff --cached
alias gdcw = git diff --cached --word-diff
alias gds = git diff --staged
alias gdw = git diff --word-diff
alias gdup = git diff @{upstream}
alias gdt = git diff-tree --no-commit-id --name-only -r

# Fetch
alias gf = git fetch
alias gfo = git fetch origin

# GUI
alias gg = git gui citool
alias gga = git gui citool --amend

# Help
alias ghh = git help

# Log
alias glgg = git log --graph
alias glgga = git log --graph --decorate --all
alias glgm = git log --graph --max-count=10
alias glo = git log --oneline --decorate
alias glog = git log --oneline --decorate --graph
alias gloga = git log --oneline --decorate --graph --all
alias glg = git log --stat
alias glgp = git log --stat --patch

def glol [] { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" }
def glols [] { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat }
def glola [] { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all }
def glod [] { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" }
def glods [] { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short }

# ls-files
def gignored [] { git ls-files -v | lines | where ($it =~ "^[a-z]") }
def gfg [pattern: string] { git ls-files | lines | where ($it =~ $pattern) }

# Merge
alias gm = git merge
alias gma = git merge --abort
alias gmc = git merge --continue
alias gms = git merge --squash
alias gmff = git merge --ff-only
alias gmtl = git mergetool --no-prompt
alias gmtlvim = git mergetool --no-prompt --tool=vimdiff

def gmom [] { git merge $"origin/(git_main_branch)" }
def gmum [] { git merge $"upstream/(git_main_branch)" }

# Pull
alias gl = git pull
alias gpr = git pull --rebase
alias gprv = git pull --rebase -v
alias gpra = git pull --rebase --autostash
alias gprav = git pull --rebase --autostash -v

def gprom [] { git pull --rebase origin (git_main_branch) }
def gpromi [] { git pull --rebase=interactive origin (git_main_branch) }
def gprum [] { git pull --rebase upstream (git_main_branch) }
def gprumi [] { git pull --rebase=interactive upstream (git_main_branch) }
def ggpull [] { git pull origin (git_current_branch) }
def gluc [] { git pull upstream (git_current_branch) }
def glum [] { git pull upstream (git_main_branch) }

# Push
alias gp = git push
alias gpd = git push --dry-run
def "gpf!" [] { git push --force }
alias gpv = git push --verbose
alias gpu = git push upstream

def gpf [] { git push --force-with-lease --force-if-includes }
def gpsup [] { git push --set-upstream origin (git_current_branch) }
def gpoat [] { git push origin --all; git push origin --tags }
def gpod [...args] { git push origin --delete ...$args }
def ggpush [] { git push origin (git_current_branch) }

# Rebase
alias grb = git rebase
alias grba = git rebase --abort
alias grbc = git rebase --continue
alias grbi = git rebase --interactive
alias grbo = git rebase --onto
alias grbs = git rebase --skip

def grbd [] { git rebase (git_develop_branch) }
def grbm [] { git rebase (git_main_branch) }
def grbom [] { git rebase $"origin/(git_main_branch)" }
def grbum [] { git rebase $"upstream/(git_main_branch)" }

# Reflog
alias grf = git reflog

# Remote
alias gr = git remote
alias grv = git remote --verbose
alias gra = git remote add
alias grrm = git remote remove
alias grmv = git remote rename
alias grset = git remote set-url
alias grup = git remote update

# Reset
alias grh = git reset
alias gru = git reset --
alias grhh = git reset --hard
alias grhk = git reset --keep
alias grhs = git reset --soft

def gpristine [] { git reset --hard; git clean --force -dfx }
def gwipe [] { git reset --hard; git clean --force -df }
def groh [] { git reset $"origin/(git_current_branch)" --hard }

# Restore
alias grs = git restore
alias grss = git restore --source
alias grst = git restore --staged

# Revert
alias grev = git revert
alias greva = git revert --abort
alias grevc = git revert --continue

# Remove
alias grm = git rm
alias grmc = git rm --cached

# Shortlog
alias gcount = git shortlog --summary --numbered

# Show
alias gsh = git show
alias gsps = git show --pretty=short --show-signature

# Stash
alias gsta = git stash
alias gstall = git stash --all
alias gstaa = git stash apply
alias gstc = git stash clear
alias gstd = git stash drop
alias gstl = git stash list
alias gstp = git stash pop
alias gsts = git stash show --patch
alias gstu = git stash --include-untracked

# Status
alias gst = git status
alias gss = git status --short
alias gsb = git status --short --branch

# Submodule
alias gsi = git submodule init
alias gsu = git submodule update

# SVN
alias gsd = git svn dcommit
alias gsr = git svn rebase

# Switch
alias gsw = git switch
alias gswc = git switch --create

def gswd [] { git switch (git_develop_branch) }
def gswm [] { git switch (git_main_branch) }

# Tag
alias gta = git tag --annotate
alias gts = git tag --sign
def gtv [] { git tag | lines | sort -n }
def gtl [pattern?: string] {
  if ($pattern | is-empty) {
    git tag --sort=-v:refname -n --list
  } else {
    git tag --sort=-v:refname -n --list $"($pattern)*"
  }
}

# Update-index
alias gignore = git update-index --assume-unchanged
alias gunignore = git update-index --no-assume-unchanged

# Whatchanged
alias gwch = git log --patch --abbrev-commit --pretty=medium --raw

# Worktree
alias gwt = git worktree
alias gwta = git worktree add
alias gwtls = git worktree list
alias gwtmv = git worktree move
alias gwtrm = git worktree remove

# WIP
def gwip [] {
  git add -A
  do { git rm (git ls-files --deleted) } | ignore
  git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"
}

def gunwip [] {
  let msg = (git rev-list --max-count=1 --format="%s" HEAD | str trim)
  if ($msg =~ "--wip--") {
    git reset HEAD~1
  }
}

# Rename branch
def grename [old: string, new: string] {
  git branch -m $old $new
  git push origin $":($old)"
  git push --set-upstream origin $new
}
