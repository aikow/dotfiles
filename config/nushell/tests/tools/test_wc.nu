use std assert

use ~/.dotfiles/config/nushell/modules/tools/wc.nu

#[test]
def test_wc_list [] {
  assert equal ([a b c] | wc).words 3
}
