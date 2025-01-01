# kzenlab
Kzenlab (pronouns: kaizen lab) is a DryLab and Dev Environment OS with intended to run on UFD Only. Kzenlab used in Codeijoe Mentorship. Kzenlab comes with some variants.
1. kzenlab-base
2. kzenlab-localdev   (32GB)
3. kzenlab-remotedev  (32GB)
4. kzenlab-eval-retro (64GB) 
5. kzenlab-eval-osx
6. kzenlab-eval-win
7. kzenlab-eval-linux


## Motivations
When a mentee join the mentorship, no matter the have they own laptop or not but tools should be standardize.

## How to build ?

```
bash setup.sh -sc
bash setup.sh -br

# download or copy
## copy to build/
cp debian-12.tar.gz build/

bash setup.sh --set-base-os
bash setup.sh --mount-dvd1
bash setup.sh --set-kernel

```