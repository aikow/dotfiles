"""Run with: python3 config/fish/tests/title_delay.py (requires Fish and a PTY)."""

import os
from pathlib import Path
import pty
import re
import select
import shutil
import signal
import time


def collect(fd, seconds):
    deadline = time.monotonic() + seconds
    data = b""
    while time.monotonic() < deadline:
        ready, _, _ = select.select([fd], [], [], max(0, deadline - time.monotonic()))
        if ready:
            try:
                data += os.read(fd, 65536)
            except OSError:
                break
    return data


def titles(data):
    return re.findall(rb"\x1b\][02];([^\x07\x1b]*)(?:\x07|\x1b\\)", data)


fish = shutil.which("fish")
assert fish, "Fish is required"
os.chdir(Path(__file__).resolve().parents[3])
pid, fd = pty.fork()
if pid == 0:
    os.environ.update(TERM_PROGRAM="ghostty", TERM="xterm-256color")
    init = """
        set fish_greeting
        set -p fish_function_path $PWD/config/fish/functions
        function fish_prompt; printf 'READY> '; end
        source config/fish/conf.d/title.fish
    """
    os.execv(fish, [fish, "--no-config", "--features=no-query-term", "--interactive", "--init-command", init])

try:
    assert b"READY>" in collect(fd, 0.8), "Shell did not start"
    os.write(fd, b"sleep 0.05\n")
    short = collect(fd, 0.65)
    assert not any("· sleep".encode() in t for t in titles(short)), "Short command changed title"
    os.write(fd, b"sleep 0.9\n")
    early = collect(fd, 0.18)
    assert not any("· sleep".encode() in t for t in titles(early)), "Title changed before delay"
    delayed = collect(fd, 0.4)
    assert any("· sleep".encode() in t for t in titles(delayed)), "Long command title missing"
    finished = collect(fd, 0.6)
    assert titles(finished) and "· sleep".encode() not in titles(finished)[-1], "Idle title missing"
    os.write(fd, b"sleep 0.1\nsleep 0.05\n")
    rapid = collect(fd, 0.7)
    assert not any("· sleep".encode() in t for t in titles(rapid)), "Stale worker changed title"
    os.write(fd, b"sleep 10\n")
    collect(fd, 0.1)
    os.write(fd, b"\x03")
    interrupted = collect(fd, 0.6)
    assert not any("· sleep".encode() in t for t in titles(interrupted)), "Interrupted worker changed title"
    for data in (short, early, delayed, finished, rapid, interrupted):
        assert b"has ended" not in data and b"terminated by signal" not in data, "Worker job notification"
    print("PASS: short commands, delayed titles, idle restoration, rapid commands, Ctrl-C, no job notifications")
finally:
    os.kill(pid, signal.SIGKILL)
    os.waitpid(pid, 0)
    os.close(fd)
