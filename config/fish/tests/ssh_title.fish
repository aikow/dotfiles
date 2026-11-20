# Run with: fish --no-config config/fish/tests/ssh_title.fish
set -l functions_dir (path dirname -- (status filename))/../functions
source "$functions_dir/__fish_ssh_title.fish"
source "$functions_dir/__fish_path_title.fish"
source "$functions_dir/fish_title.fish"
set -e SSH_TTY
set -e SSH_CONNECTION

set -l cases \
    'ssh scl-c32-r16-svr01' scl-c32-r16-svr01 \
    'ssh user@staging' staging \
    'ssh -p 2222 -i "/tmp/key with spaces" -J jump staging' staging \
    'ssh -vvAp2222 staging' staging \
    'ssh -o ProxyCommand="ssh jump nc %h %p" staging' staging \
    'command ssh -- staging' staging \
    'exec /usr/bin/ssh staging' staging \
    'ssh staging echo remote-command' staging \
    'ssh ssh://user@staging:2222/' staging \
    'ssh ssh://user@[2001:db8::1]:2222/' 2001:db8::1 \
    'ssh 2001:db8::1' 2001:db8::1

for index in (seq 1 2 (count $cases))
    set -l expected $cases[(math $index + 1)]
    set -l actual (fish_title "$cases[$index]")
    if test "$actual" != "$expected"
        printf 'FAIL case %s: expected <%s>, got <%s>\n' "$index" "$expected" "$actual"
        exit 1
    end
end

set -l invalid_index 0
for invalid in '' ssh 'ssh -p' 'ssh -G staging' 'ssh -Q cipher' \
    'ssh -V' 'ssh -O check staging' 'echo ssh staging' \
    'ssh $SERVER' 'ssh (printf injected)' \
    (printf 'ssh bad\033]2;injected\007')
    set invalid_index (math $invalid_index + 1)
    if __fish_ssh_title "$invalid" >/dev/null
        printf 'FAIL: accepted incomplete, non-connection or unsafe command %s\n' $invalid_index
        exit 1
    end
end

set -l local_title (fish_title)
fish_title 'ssh staging' >/dev/null
if test (fish_title) != "$local_title"
    echo 'FAIL: local title was not restored after SSH'
    exit 1
end
echo 'PASS: SSH destinations, options, safe parsing and local title restoration'
