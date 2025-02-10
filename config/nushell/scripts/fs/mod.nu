use std iter scan

export def traverse-up [] {
  $in
  | path split
  | scan --noinit '' { |acc,it| $acc | path join $it }
  | reverse
}

export def search-up [file: string] {
  $in
  | traverse-up
  | where { |it| 
      $it | path join $file | path exists
    }
  | first
}
