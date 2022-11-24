# MacOS

## Fixes

### Remap keys

On the magic keyboard for Mac, the `~` and paragraph keys are switched from the
standard US keyboard layout. However, you can remap keys using the `hidutil`
command as follows

```shell
hidutil property --set '
  {
    "UserKeyMapping": [
      {
        "HIDKeyboardModifierMappingSrc": 0x700000064,
        "HIDKeyboardModifierMappingDst": 0x700000035
      },
      {
        "HIDKeyboardModifierMappingSrc": 0x700000035,
        "HIDKeyboardModifierMappingDst": 0x700000064
      }
    ]
  }
'
```

[Reference](https://jonnyzzz.com/blog/2017/12/04/macos-keys/)
