# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=WYANT
MODULE_VERSION=0.067
inherit perl-module

DESCRIPTION="A Perl module to compute satellite passages for a given observing location"

SLOT="0"
LICENSE="Artistic-2"
KEYWORDS="~amd64 ~x86"
IUSE="json"

DEPEND="dev-perl/Module-Build"
RDEPEND="json? ( dev-perl/JSON )"
