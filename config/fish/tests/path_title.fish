# Run with: fish --no-config config/fish/tests/path_title.fish
set -l functions_dir (path dirname -- (status filename))/../functions
source "$functions_dir/__fish_path_title.fish"
source "$functions_dir/__fish_ssh_title.fish"
source "$functions_dir/fish_title.fish"
source "$functions_dir/__fish_format_title.fish"
set -e SSH_TTY
set -e SSH_CONNECTION

set -l leaf (string repeat -n 47 x)
set -l deep (string repeat -n 30 longdirectory/)
set -l long_leaf (string repeat -n 170 x)
set -l cases \
    / / \
    /var/log /var/log \
    "$HOME" '~' \
    "$HOME/Downloads" '~/Downloads' \
    "$HOME/meeting notes" '~/meeting notes' \
    "$HOME-other/Downloads" "$HOME-other/Downloads" \
    "/a/$leaf" "/a/$leaf" \
    "/alpha/$leaf" "/a/$leaf" \
    "$HOME/workspace/a-very-long-directory-name/another-long-name/meeting-notes" '~/w/a/another-long-name/meeting-notes' \
    "$HOME/workspace/$deep"'experiments/meeting-notes' '~/workspace/…/experiments/meeting-notes' \
    "/workspace/$deep"'experiments/meeting-notes' '/workspace/…/experiments/meeting-notes' \
    "/.veryveryverylonghiddendirectory/$leaf" "/…/$leaf" \
    "/$long_leaf" "/$long_leaf" \
    "$HOME/$long_leaf" "~/$long_leaf" \
    "$HOME/workspace/deep/$long_leaf" "~/…/$long_leaf" \
    (printf '/unsafe\033]2;name\007/folder') fish

for index in (seq 1 2 (count $cases))
    set -l expected $cases[(math $index + 1)]
    set -l actual (__fish_path_title "$cases[$index]")
    if test "$actual" != "$expected"
        printf 'FAIL case %s: expected <%s>, got <%s>\n' "$index" "$expected" "$actual"
        exit 1
    end
end

# Exercise the complete title function in a real non-repository folder.
set -l fixture (mktemp -d /tmp/title-path.XXXXXX); or exit 1
cd "$fixture"; or exit 1
set -l expected "$PWD"
set -l actual (fish_title)
set -l command_cases \
    'nvim private.txt' nvim \
    '/usr/bin/sleep 10' sleep \
    'command exec /usr/bin/sleep 10' sleep \
    'curl --header "Authorization: secret" https://example.com' curl \
    'abcdefghijklmnopqrstuvwxyz' 'abcdefghijklmnopqrstuvw…'
for index in (seq 1 2 (count $command_cases))
    set -l command_title (fish_title "$command_cases[$index]")
    set -l command_name $command_cases[(math $index + 1)]
    if test "$command_title" != "$expected · $command_name"
        echo 'FAIL: running command title'
        exit 1
    end
end
for unsafe in '$(touch /tmp/title-must-not-execute)' (printf 'bad\033]2;injected\007')
    if test (fish_title "$unsafe") != "$expected"
        echo 'FAIL: unsafe command title'
        exit 1
    end
end
if test (fish_title) != "$expected"
    echo 'FAIL: idle title was not restored'
    exit 1
end
set -l long_folder (string repeat -n 170 x)
mkdir "$fixture/$long_folder"
cd "$fixture/$long_folder"; or exit 1
set -l long_actual (fish_title)
set -l long_expected "/…/$long_folder"
cd /; or exit 1
rm -rf -- "$fixture"
if test "$actual" != "$expected"; or test "$long_actual" != "$long_expected"
    echo 'FAIL: non-repository title did not preserve the path/final folder'
    exit 1
end
echo 'PASS: full paths, home prefix, abbreviation, middle collapse and intact final folders'
