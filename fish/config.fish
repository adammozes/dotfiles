fish_add_path -P /opt/homebrew/bin ~/.cargo/bin ~/.local/bin /bin /usr/bin
set -gx GPG_TTY (tty)
set -l uname "(uname)"
set -gx RUSTFLAGS "-Ctarget-cpu=native"

set -U FZF_COMPLETE 2
set -U FZF_PREVIEW_FILE_CMD "bat --color=always"

if status --is-interactive
  source (starship init fish --print-full-init | psub)

  if which lvim
      set -gx EDITOR lvim
      set -gx VISUAL lvim
  else if which nvim
      set -gx EDITOR nvim
      set -gx VISUAL nvim
  end

  if which bat
    abbr --add --global cat bat
  end

  if which rg
    abbr --add --global grep rg
  end

  if which eza
    abbr --add --global ls   eza
  end

  if which sccache
    set -gx RUSTC_WRAPPER sccache
  end

  if which zoxide
    zoxide init --cmd=cd fish | source
  end

  if which git
    abbr -a -- ga    'git add'
    abbr -a -- gcp   'git cherry-pick'
    abbr -a -- gcpa  'git cherry-pick --abort'
    abbr -a -- gcpc  'git cherry-pick --continue'
    abbr -a -- gf    'git fetch --all --prune'
    abbr -a -- gl    'git log'
    abbr -a -- glp   'git log --patch'
    abbr -a -- gmt   'git mergetool'
    abbr -a -- gpf   'git push --force-with-lease'
    abbr -a -- gp    'git push'
    abbr -a -- gpd   'git push --delete origin (git rev-parse --abbrev-ref HEAD)'
    abbr -a -- gpm   'git push origin HEAD:master'
    abbr -a -- gra   'git rebase --abort'
    abbr -a -- gras  'git rebase --interactive --autosquash --keep-base origin/HEAD'
    abbr -a -- grc   'git rebase --continue'
    abbr -a -- grhh  'git reset --hard HEAD'
    abbr -a -- grhu  git\ reset\ --hard\ \'@\{upstream\}\'
    abbr -a -- grhoh 'git reset --hard origin/HEAD'
    abbr -a -- gr    'git rebase'
    abbr -a -- gri   'git rebase --interactive'
  end

  abbr -a -- j     'journalctl --no-hostname -oshort-iso-precise --follow'
  abbr -a -- r     'rsync --verbose --progress --recursive -z -z'
  abbr -a -- s     sudo
  abbr -a -- se    sudoedit
  abbr -a -- syu   'sudo pacman -Syyuu --noconfirm; sudo pacman -Sc --noconfirm'

  fortune | ponysay --wrap i
  thefuck --alias | source

  if ! set -q SSH_CONNECTION
    echo "starting gpg"
    set -e SSH_AUTH_SOCK; set -U -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpg-connect-agent updatestartuptty /bye >/dev/null
  end

  fish_vi_key_bindings

  tmux attach; or tmux
end
