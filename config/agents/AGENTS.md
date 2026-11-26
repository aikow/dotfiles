## Version control

- Before any version-control mutation, detect whether the workspace belongs to a Jujutsu repository. Check ancestor directories for .jj; a .git directory alone does not establish that Git should be used.
- In Jujutsu repositories, read the jujutsu skill and use jj for commits, squashing, rebasing, bookmarks, and remote operations.
- Do not run mutating Git commands in Jujutsu repositories unless I explicitly request Git.
- After rewriting history, verify the working-copy revision, bookmark targets, and absence of unintended divergent changes.
