# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Pro Git: an open-source book on Git by Scott Chacon and Ben Straub (English HTML version)"
HOMEPAGE="https://progit.org/"
SRC_URI="https://progit2.s3.amazonaws.com/en/2015-10-27-6c452/progit-en.904.zip"

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="~*"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"
src_prepare() {
	# Get rid of unneeded files:
	rm -rf *.json Gemfile* diagram-source Rakefile theme/epub  theme/mobi  theme/pdf

	# Fix some HTML brackets:
	sed -i -e 's:<code class="p">\&amp;<\/code>lt<code class="p">;:\&lt;:g' *.html || die "sed failed"
	sed -i -e 's:<code class="p">\&amp;<\/code>gt<code class="p">;:\&gt;:g' *.html || die "sed failed"
	sed -i -e 's:\&amp;lt;:\&lt;:g' *.html || die "sed failed"
	sed -i -e 's:\&amp;gt;:\&gt;:g' *.html || die "sed failed"
}

# Install the data files as well as the libraries:
src_install() {
	insinto /usr/share/doc/pro-git
	doins -r "${WORKDIR}"/*
}
