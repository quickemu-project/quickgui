* bump the version number in pubspec.yaml (ex: version: 1.0.5)
* push to github
* create and push version tag (ex: v1.0.5)
* create a release on GitHub
* build the tarball (`make`)
* upload the tarball to github

* `cd /mnt/data/dev/debianpackages/quickgui.deb/quickgui`
* `head debian/changelog` to check the latest changelog
* `dch -v a.b.c "New changelog message"`
* `nano debian/changelog` to change the release (ex: 1.0.5-1~focal1.0 focal)
* `uscan --noconf --force-download --rename --download-current-version --destdir=.. --verbose` to download the tarball properly
* `dpkg-buildpackage -d -S -sa -kyannick.mauray@gmail.com` to build the changes file.
* `nano debian/changelog` to change the release (ex: 1.0.5-1~hirsute1.0 hirsute)
* `dpkg-buildpackage -d -S -sa -kyannick.mauray@gmail.com`
* `nano debian/changelog` to change the release (ex: 1.0.5-1~impish1.0 impish)
* `dpkg-buildpackage -d -S -sa -kyannick.mauray@gmail.com`
* `nano debian/changelog` to change the release (ex: 1.0.5-1~jammy.0 jammy)
* `dpkg-buildpackage -d -S -sa -kyannick.mauray@gmail.com`
* `dput ppa:yannick-mauray/quicksync ../quicksync_0.6.4-1~focal1.0_source.changes`
* `dput ppa:yannick-mauray/quicksync ../quicksync_0.6.4-1~hirsute1.0_source.changes`
* `dput ppa:yannick-mauray/quicksync ../quicksync_0.6.4-1~impish1.0_source.changes`
* `dput ppa:yannick-mauray/quicksync ../quicksync_0.6.4-1~jammy1.0_source.changes`
