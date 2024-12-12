if not status is-interactive
    exit
end

if not command -q fzf
    exit
end

# Install the default bindings, which are mnemonic and minimally conflict with fish's preset bindings
fzf_configure_bindings
