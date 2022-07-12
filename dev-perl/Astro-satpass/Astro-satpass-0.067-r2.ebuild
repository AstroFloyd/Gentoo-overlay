# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=WYANT
DIST_VERSION=0.067
inherit perl-module

DESCRIPTION="A Perl module to compute satellite passages for a given observing location"

SLOT="0"
LICENSE="Artistic-2"
KEYWORDS="~amd64 ~x86"
IUSE="json"

BDEPEND="dev-perl/Module-Build"
RDEPEND="json? ( dev-perl/JSON )"
