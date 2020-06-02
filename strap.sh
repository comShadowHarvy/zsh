#!/bin/sh
# strap.sh - install and setup BlackArch Linux keyring

# mirror file to fetch and write
MIRROR_F="blackarch-mirrorlist"

# simple error message wrapper
err()
{
  echo >&2 "$(tput bold; tput setaf 1)[-] ERROR: ${*}$(tput sgr0)"

  exit 1337
}

# simple warning message wrapper
warn()
{
  echo >&2 "$(tput bold; tput setaf 1)[!] WARNING: ${*}$(tput sgr0)"
}

# simple echo wrapper
msg()
{
  echo "$(tput bold; tput setaf 2)[+] ${*}$(tput sgr0)"
}

# check for root privilege
check_priv()
{
  if [ "$(id -u)" -ne 0 ]; then
    err "you must be root"
  fi
}

# make a temporary directory and cd into
make_tmp_dir()
{
  tmp="$(mktemp -d /tmp/blackarch_strap.XXXXXXXX)"

  trap 'rm -rf $tmp' EXIT

  cd "$tmp" || err "Could not enter directory $tmp"
}

check_internet()
{
  tool='curl'
  tool_opts='-s --connect-timeout 8'

  if ! $tool $tool_opts https://microsoft.com/ > /dev/null 2>&1; then
    err "You don't have an Internet connection!"
  fi

  return $SUCCESS
}

# retrieve the BlackArch Linux keyring
fetch_keyring()
{
  curl -s -O \
  'https://www.blackarch.org/keyring/blackarch-keyring.pkg.tar.xz{,.sig}'
}

# verify the keyring signature
# note: this is pointless if you do not verify the key fingerprint
verify_keyring()
{
  if ! gpg --keyserver pgp.mit.edu \
     --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 > /dev/null 2>&1
  then
    if ! gpg --keyserver hkp://pool.sks-keyservers.net \
       --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 > /dev/null 2>&1
    then
      err "could not verify the key. Please check: https://blackarch.org/faq.html"
    fi
  fi

  if ! gpg --keyserver-options no-auto-key-retrieve \
    --with-fingerprint blackarch-keyring.pkg.tar.xz.sig > /dev/null 2>&1
  then
    err "invalid keyring signature. please stop by irc.freenode.net/blackarch"
  fi
}

# delete the signature files
delete_signature()
{
  if [ -f "blackarch-keyring.pkg.tar.xz.sig" ]; then
    rm blackarch-keyring.pkg.tar.xz.sig
  fi
}

# make sure /etc/pacman.d/gnupg is usable
check_pacman_gnupg()
{
  pacman-key --init
}

# install the keyring
install_keyring()
{
  if ! pacman --config /dev/null --noconfirm \
    -U blackarch-keyring.pkg.tar.xz ; then
      err 'keyring installation failed'
  fi

  # just in case
  pacman-key --populate
}

# ask user for mirror
get_mirror()
{
  mirror_p="/etc/pacman.d"
  mirror_r="https://blackarch.org"

  msg "fetching new mirror list..."
  if ! curl -s "$mirror_r/\$MIRROR_F" -o "$mirror_p/\$MIRROR_F" ; then
    err "we couldn't fetch the mirror list from: $mirror_r/\$MIRROR_F"
  fi

  msg "you can change the default mirror under $mirror_p/\$MIRROR_F"
}

# update pacman.conf
update_pacman_conf()
{
  # delete blackarch related entries if existing
  sed -i '/blackarch/{N;d}' /etc/pacman.conf

  cat >> "/etc/pacman.conf" << EOF
[chaotic-aur]
Server = http://lonewolf-builder.duckdns.org/\$repo/x86_64
Server = http://chaotic.bangl.de/\$repo/x86_64
Server = https://repo.kitsuna.net/x86_64
#########################Must add keys for it
#sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
#sudo pacman-key --lsign-key 3056513887B78AEB

[archstrike]
Server = http://archstrike.org:81/repo/\$arch/\$repo

[blackarch]
Include = /etc/pacman.d/$MIRROR_F

######################################
######### Community Repositories #####
######################################

[liri-unstable]
Server = repo.liri.io/archlinux/unstable/\$arch/

#[obarun]
#Server = repo.obarun.org/\$arch

[theapps]
Server = vicr123.github.io/repo/arch/\$arch/

##############################################
##############################################

[arcbasic_repo]
Server = arcbasic.github.io/repo/\$arch

[arcolinux_repo]
Server = arcolinux.github.io/arcolinux_repo/\$arch

[arcolinux_repo_iso]
Server = arcolinux.github.io/arcolinux_repo_iso/\$arch

[archlinux-ddosolitary]
Server = archlinux-repo.sourceforge.io/packages

[aur-archlinux]
Server = repo.itmettke.de/aur/\$repo/\$arch

[archlabs_repo]
Server = archlabs.github.io/archlabs_repo/\$arch

[archman_repo]
Server = archman.org/source/archman_repo/\$arch
Server = raw.github.com/Archman-OS/archman_repo/master/\$arch

[anarchy]
Server = anarchy-linux.org/repo/\$arch

[archlinuxfr]
Server = repo.archlinux.fr/\$arch

[antergos]
Server = cinnarch.polymorf.fr/\$repo/\$arch

[archlinuxgr]
Server = archlinuxgr.tiven.org/archlinux/\$arch

[archlinuxgr-any]
Server = archlinuxgr.tiven.org/archlinux/any

[archlinuxcn]
Server = cdn.repo.archlinuxcn.org/\$arch
Server = mirrors.geekpie.org/archlinuxcn/\$arch
Server = mirrors.ustc.edu.cn/archlinuxcn/\$arch

[alucryd]
Server = pkgbuild.com/~alucryd/\$repo/x86_64

[alucryd-multilib]
Server = pkgbuild.com/~alucryd/\$repo/x86_64

[andrwe]
Server = repo.andrwe.org/x86_64

[arcanisrepo]
Server = repo.arcanis.me/repo/\$arch
Server = repo.arcanis.me/repo/\$arch

[ashleyis]
Server = arch.ashleytowns.id.au/repo/\$arch

[archstrike]
Server = mirror.archstrike.org/\$arch/\$repo

[archstrike-testing]
Server = mirror.archstrike.org/\$arch/\$repo

[bluestar]
Server = downloads.sourceforge.net/project/bluestarlinux/repo/\$arch

[blackarch]
Server = mirror.team-cymru.org/blackarch/\$repo/os/\$arch

[bbqlinux]
Server = packages.bbqlinux.org/\$repo/os/\$arch
Server = mirror.amagital.com/\$repo/os/\$arch

[coderkun-aur]
Server = arch.coderkun.de/\$repo/\$arch/

[coderkun-aur-audio]
Server = arch.coderkun.de/\$repo/\$arch/

[condresrepo]
Server = repository.codelinsoft.it/condres-core-signed/

[city]
Server = pkgbuild.com/~bgyorgy/\$repo/os/\$arch

[eatabrick]
Server = repo.eatabrick.org/\$arch

[eschwartz]
Server = pkgbuild.com/~eschwartz/repo/\$arch

[heftig]
Server = pkgbuild.com/~heftig/repo/\$arch

[home_fusion809_Arch_Extra]
Server = download.opensuse.org/repositories/home:/fusion809/Arch_Extra/\$arch

[home_Minerva_W_Science_Arch_Extra]
Server = download.opensuse.org/repositories/home:/Minerva_W:/Science/Arch_Extra/\$arch

[home_Head_on_a_Stick_Arch_Arch_Extra]
Server = download.opensuse.org/repositories/home:/Head_on_a_Stick:/Arch/Arch_Extra/\$arch

[home_Pival81_arch_xapps_Arch_Extra]
Server = download.opensuse.org/repositories/home:/Pival81:/arch:/xapps/Arch_Extra/\$arch

[home-thaodan]
Server = thaodan.de/home/bidar/home-thaodan/\$arch

[herecura]
Server = repo.herecura.be/herecura/x86_64

[herecura-testing]
Server = repo.herecura.be/herecura-testing/x86_64

[blackeagle-pre-community]
Server = repo.herecura.be/blackeagle-pre-community/x86_64

[ivasilev]
Server = ivasilev.net/pacman/any

[jlk]
Server = jlk.fjfi.cvut.cz/arch/repo

[joekamprad]
Server = www.antergos.kamprad.net/antergos-packages

[jkanetwork]
Server = repo.jkanetwork.com/repo/\$repo/

[kpiche]
Server = kpiche.archlinux.ca/repo
Server = kpiche.archlinux.ca/repo/os/x86_64

[markzz]
Server = repo.markzz.com/arch/\$repo/\$arch

[miffe]
Server = arch.miffe.org/\$arch/

[magpieos]
Server = rizwan-hasan.github.io/MagpieOS-Repository/

[mikelpint]
Server = mikelpint.github.io/repository/archlinux/repo

[namibrepo]
Server = namibrepo.meerkat.tk/\$arch

[ninjaos]
Server=http://ninjaos.org/repo/\$arch

[ownstuff]
Server = martchus.no-ip.biz/repo/arch/\$repo/os/\$arch

[pkgbuilder]
Server = pkgbuilder-repo.chriswarrick.com/

[portergos]
Server = github.com/Portergos/portergos_repository/releases/download/portergos/
Server = sourceforge.net/projects/portergosrepository/files/portergos/

[Reborn-OS]
Server = sourceforge.net/projects/antergos-deepin/files/

[repo-ck]
Server = repo-ck.com/\$arch
Server = mirrors.nju.edu.cn/repo-ck/\$arch

[revenge_repo]
Server = downloads.sourceforge.net/project/revenge-repo/revenge_repo/\$arch
Server = ftp.heanet.ie/mirrors/sourceforge/r/re/revenge-repo/revenge_repo/\$arch
Server = raw.github.com/obrevenge/revenge_repo/master/\$arch

[swagarchrepo]
Server=https://github.com/SwagArch/swagarch-packages/releases/download/swagarchrepo/

[seblu]
Server = al.seblu.net/\$repo/\$arch

[seiichiro]
Server = www.seiichiro0185.org/repo/\$arch

[sergej-repo]
Server = repo.p5n.pp.ru/\$repo/os/\$arch

[siosm-aur]
Server = siosm.fr/repo/\$repo/

[spooky_aur]
#Server = github.com/spookykidmm/spooky_aur/tree/master/x86_64
Server = raw.githubusercontent.com/spookykidmm/spooky_aur/master/x86_64

[xyne-x86_64]
Server = xyne.archlinux.ca/repos/xyne

#################### Manjaro Repos -----

[kibojoe]
Server = repo.kibojoe.org/stable/\$arch/

[netrunner]
Server = arch.netrunner.com/netrunner/\$arch

#####################################################
#################### RusPuppy Repos -----

[pra6407extra]
#Server = mirror.yandex.ru/puppyrus/puppyrus-a64/pra64-07/pkg/pra6407extra
Server = ftp.yandex.ru/puppyrus/puppyrus-a64/pra64-07/pkg/pra6407extra

[art-aur]
#Server = mirror.yandex.ru/puppyrus/puppyrus-a64/pra64-07/pkg/art-aur
Server = ftp.yandex.ru/puppyrus/puppyrus-a64/pra64-07/pkg/art-aur

[2a-any]
#Server = mirror.yandex.ru/puppyrus/2a-aarch64/pkg-repo/2a-any
Server = ftp.yandex.ru/puppyrus/2a-aarch64/pkg-repo/2a-any

################### Parabola GNU/Linux-libre Repos --------

[libre]
Server = repomirror.parabola.nu/libre/os/x86_64/

[libre-multilib]
Server = repomirror.parabola.nu/libre-multilib/os/x86_64/

[pcr]
Server = repomirror.parabola.nu/pcr/os/x86_64/

[kernels]
Server = repomirror.parabola.nu/kernels/os/x86_64/

[nonprism]
Server = repomirror.parabola.nu/nonprism/os/x86_64/


#[nulogic]
#SigLevel = Optional TrustAll
#Server = nulogicsystems.com/public_files/nulogic/x86_64/



[spooky_aur]
SigLevel = Optional TrustAll
Server = raw.github.com/spookykidmm/spooky_aur/master/x86_64


[anarchy]
SigLevel = Optional TrustAll
Server = anarchy-linux.org/repo/\$arch
Server = anarchy-linux.org/repo/anarchy-linux/x86_64 

[herecura]
# packages built against core
Server = repo.herecura.be/herecura/x86_64

[herecura-testing]
# packages built against testing
Server = repo.herecura.be/herecura-testing/x86_64

[blackeagle-pre-community]
# applications updated for testing before hitting community
Server = repo.herecura.be/blackeagle-pre-community/x86_64

[alucryd-multilib]
SigLevel = Never
Server = pkgbuild.com/~alucryd/\$repo/x86_64

[seiichiro]
Server = www.seiichiro0185.org/repo/\$arch

[herecura]
Server = repo.herecura.be/\$repo/\$arch
Server = repo.herecura.be/herecura/x86_64

[aurpackages]
Server = r.mikroskeem.eu

# -----------------------------------------------------------------------------
# This is the list of mirrors where you can find my (Xyne's) repos. Each mirror
# is kindly hosted by contributors from the Arch community (thank you!).  To
# use my repo and this list, add the following to /etc/pacman.conf:
#
# [xyne-x86_64]
# SigLevel = Required
# Include = /etc/pacman.d/xyne-mirrorlist
#
# There is also [xyne-any] for non-x86_64 users.
#
# The line "SigLevel = Required" ensures that both the database and all
# packages in the repo will be signed with my key, which is included in the
# Arch Linux keyring. The allows you to trust the repo without having to trust
# each server in the mirrorlist.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# The original site, hosted since 2008 or 2009 by Dusty. The URL should be
#
# Server = https://xyne.archlinux.ca/repos/xyne
#
# but the paid hosting service occasionally messes around with cross-domain
# ".db" extension filters which block access to the files so the following
# workaround is provided:

Server = https://xyne.archlinux.ca/bin/repo.php?file=
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# The first mirror, hosted since 2019 by
# Bryan L. Gay / LinuxNinja
# Draconian Rose, LLC
# 2001 Duncan Dr NW Unit 894
# Kennesaw, GA 30156
# 1-678-718-8800

Server = https://xyne.mirrorrepo.com/repos/xyne
# -----------------------------------------------------------------------------
[mewle]
SigLevel = Never
Server = sourceforge.net/projects/mewle-os-repository/files/stable/

[brinkOS]
Server = sourceforge.net/projects/brinkos/files/package-repo/

[obarun]
Server = repo.obarun.org/\$arch


[arcbasic_repo]
Server = arcbasic.github.io/repo/\$arch


[archlinux-ddosolitary]
Server = archlinux-repo.sourceforge.io/packages
SigLevel = Required


[antergos]
Server = mirrors.antergos.com/\$repo/\$arch
Server = softlibre.unizar.es/cinnarch/\$repo/\$arch
Server = glua.ua.pt/pub/antergos/\$repo/\$arch
Server = cinnarch.polymorf.fr/\$repo/\$arch
Server = eu.mirrors.coltondrg.com/antergos/\$repo/\$arch
Server = mirror.de.leaseweb.net/antergos/\$repo/\$arch
Server = mirror.alpix.eu/antergos/\$repo/\$arch
Server = ftp.cc.uoc.gr/mirrors/linux/antergos/\$repo/\$arch
Server = mirror.us.leaseweb.net/antergos/\$repo/\$arch
Server = mirrors.tuxns.net/antergos/\$repo/\$arch
Server = mirror.umd.edu/antergos/\$repo/\$arch
Server = mirrors.acm.wpi.edu/antergos/\$repo/\$arch
Server = mirrors.servercentral.com/antergos/\$repo/\$arch
Server = antergos.mirror.constant.com/\$repo/\$arch
Server = repo.antergos.info/\$repo/\$arch
Server = mirror.yandex.ru/mirrors/cinnarch/\$repo/\$arch
Server = mirror.antergos.jp/\$repo/\$arch
Server = mirrors.ustc.edu.cn/antergos/\$repo/\$arch
Server = mirrors.tuna.tsinghua.edu.cn/antergos/\$repo/\$arch
Server = ftp.acc.umu.se/mirror/antergos.com/\$repo/\$arch
Server = mirror.host.ag/antergos/\$repo/\$arch
Server = wynsrv.antergos.info/antergos/\$repo/\$arch
Server = mirrors.nic.cz/antergos/\$repo/\$arch
Server = mirrors.dotsrc.org/antergos/\$repo/\$arch
Server = www.mirrorservice.org/sites/repo.antergos.com/\$repo/\$arch
Server = mirror.infotronik.hu/mirrors/pub/antergos/\$repo/\$arch
Server = mirror.nl.leaseweb.net/antergos/\$repo/\$arch
Server = ftp1.nluug.nl/os/Linux/distr/antergos/\$repo/\$arch
Server = ftp2.nluug.nl/os/Linux/distr/antergos/\$repo/\$arch
Server = mirror.neostrada.nl/antergos/\$repo/\$arch
EOF
sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
sudo pacman-key --lsign-key 3056513887B78AEB
}

# synchronize and update
pacman_update()
{
  if pacman -Syy; then
    return $SUCCESS
  fi

  warn "Synchronizing pacman has failed. Please try manually: pacman -Syy"

  return $FAILURE
}


pacman_upgrade()
{
  echo 'perform full system upgrade? (pacman -Su) [Yn]:'
  read conf < /dev/tty
  case "$conf" in
    ''|y|Y) pacman -Su ;;
    n|N) warn 'some blackarch packages may not work without an up-to-date system.' ;;
  esac
}

# setup blackarch linux
blackarch_setup()
{
  check_priv
  msg 'installing blackarch keyring...'
  make_tmp_dir
  check_internet
  fetch_keyring
  verify_keyring
  delete_signature
  check_pacman_gnupg
  install_keyring
  echo
  msg 'keyring installed successfully'
  # check if pacman.conf has already a mirror
  if ! grep -q "\[blackarch\]" /etc/pacman.conf; then
    msg 'configuring pacman'
    get_mirror
    msg 'updating pacman.conf'
    update_pacman_conf
  fi
  msg 'updating package databases'
  pacman_update
  msg 'BlackArch Linux is ready!'
}

blackarch_setup
