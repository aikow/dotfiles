#!/usr/bin/env nu

def main [] {
  table -l
  | each { |it| 
      echo $it
      nu -m $it -c $"open ~/Downloads/firefox/reservations.csv | first 2"
    }

  $nothing
}

