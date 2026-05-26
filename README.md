# dotfiles

This repo contains various dotfiles I use on Linux.

## Setup

For initial setup, clone with submodules and run `create_symlinks.sh` for the first time.

```bash 
git clone git@github.com:PeterPavicic/dotfiles.git --recurse-submodules
./create_symlinks.sh
```

To make sure symlinks are always up-to-date run the following to add `create_symlinks.sh` as a post-merge hook:

```bash
cat > .git/hooks/post-merge << 'EOF'
#!/bin/bash
"$(git rev-parse --show-toplevel)/create_symlinks.sh"
EOF

chmod +x .git/hooks/post-merge
```
