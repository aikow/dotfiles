export def ls [
  --all (-a) # Show all containers (default shows just running)
  --filter (-f): string # Filter output based on conditions provided
  --format: string # Pretty-print containers using a Go template
  --last (-n) # Show n last created containers (includes all states)
  --latest (-l) # Show the latest created container (includes all states)
  --no-trunc # Don't truncate output
  --quiet (-q) # Only display container IDs
  --size (-s) # Display total file sizes
] {
  docker container $all
}
