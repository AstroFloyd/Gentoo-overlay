# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils depend.apache

DESCRIPTION="Redmine is a flexible project management web application written using Ruby on Rails framework"
HOMEPAGE="http://www.redmine.org/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="apache2 cvs darcs git imagemagick mercurial openid subversion"

#DEPEND=">=dev-ruby/rails-2.1.2:2.1
#		dev-ruby/activerecord:2.1[mysql?,postgres?,sqlite3?]
DEPEND="imagemagick? ( dev-ruby/rmagick )
	openid? ( dev-ruby/ruby-openid )"

RDEPEND="${DEPEND}
	>=dev-ruby/coderay-0.7.6.227
	>=dev-ruby/ruby-net-ldap-0.0.4
	apache2? ( www-apache/passenger )
	cvs? ( >=dev-util/cvs-1.12 )
	darcs? ( dev-util/darcs )
	git? ( dev-util/git )
	mercurial? ( dev-util/mercurial )
	subversion? ( >=dev-util/subversion-1.3 )"

REDMINE_DIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup redmine
	# home directory is required for SCM.
	enewuser  redmine -1 -1 "${REDMINE_DIR}" redmine
}

src_prepare() {
	rm -fr log files/delete.me || die
	rm -fr vendor/plugins/coderay-0.7.6.227 || die
	rm -fr vendor/plugins/ruby-net-ldap-0.0.4 || die
	# rm -fr vendor/rails || die
	echo "CONFIG_PROTECT=\"${REDMINE_DIR}/config\"" > "${T}/50${PN}"
}

src_install() {
	dodoc doc/{CHANGELOG,INSTALL,README_FOR_APP,RUNNING_TESTS,UPGRADING} || die
	rm -fr doc || die

	keepdir /var/log/${PN} || die
	dosym /var/log/${PN}/ "${REDMINE_DIR}/log" || die

	insinto "${REDMINE_DIR}"
	# This avoid cp warning with symbolic link
	rm "vendor/rails/actionpack/test/fixtures/layout_tests/layouts/symlinked" || die
	doins -r . || die
	dosym ../../symlink_parent "${REDMINE_DIR}/vendor/rails/actionpack/test/fixtures/layout_tests/layouts/symlinked" || die
	keepdir "${REDMINE_DIR}/files" || die
	keepdir "${REDMINE_DIR}/public/plugin_assets" || die

	fowners -R redmine:redmine \
		"${REDMINE_DIR}/config/environment.rb" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/public/plugin_assets" \
		"${REDMINE_DIR}/tmp" \
		/var/log/${PN} || die
	# for SCM
	fowners redmine:redmine "${REDMINE_DIR}" || die

	if use apache2 ; then
		has_apache
		insinto "${APACHE_VHOSTS_CONFDIR}"
		doins "${FILESDIR}/10_redmine_vhost.conf" || die
	else
		newconfd "${FILESDIR}/${P}.confd" ${PN} || die
		newinitd "${FILESDIR}/${P}.initd" ${PN} || die
	fi
	doenvd "${T}/50${PN}" || die
}

pkg_postinst() {
	einfo
	if [ -e "${ROOT}${REDMINE_DIR}/config/initializers/session_store.rb" ] ; then
		elog "Execute the following command to upgrade environment:"
		elog
		elog "# emerge --config =${CATEGORY}/${PF}"
		elog
		elog "For upgrade instructions take a look at:"
		elog "http://www.redmine.org/wiki/redmine/RedmineUpgrade"
	else
		elog "Execute the following command to initlize environment:"
		elog
		elog "# cd ${REDMINE_DIR}"
		elog "# cp config/database.yml.example config/database.yml"
		elog "# \${EDITOR} config/database.yml"
		elog "# emerge --config =${CATEGORY}/${PF}"
		elog
		elog "Installation notes are at official site"
		elog "http://www.redmine.org/wiki/redmine/RedmineInstall"
	fi
	einfo
}

pkg_config() {
	if [ ! -e "${REDMINE_DIR}/config/database.yml" ] ; then
		eerror "Copy ${REDMINE_DIR}/config/database.yml.example to ${REDMINE_DIR}/config/database.yml and edit this file in order to configure your database settings for \"production\" environment."
		die
	fi

	local RAILS_ENV=${RAILS_ENV:-production}

	cd "${REDMINE_DIR}"
	if [ -e "${REDMINE_DIR}/config/initializers/session_store.rb" ] ; then
		einfo
		einfo "Upgrade database."
		einfo

		einfo "Migrate database."
		RAILS_ENV="${RAILS_ENV}" rake db:migrate || die
		einfo "Clear the cache and the existing sessions."
		rake tmp:cache:clear || die
		rake tmp:sessions:clear || die
	else
		einfo
		einfo "Initialize database."
		einfo

		einfo "Generate a session store secret."
		rake config/initializers/session_store.rb || die
		einfo "Create the database structure."
		RAILS_ENV="${RAILS_ENV}" rake db:migrate || die
		einfo "Insert default configuration data in database."
		RAILS_ENV="${RAILS_ENV}" rake redmine:load_default_data || die
	fi

	if [ ! -e "${REDMINE_DIR}/config/email.yml" ] ; then
		ewarn
		ewarn "Copy ${REDMINE_DIR}/config/email.yml.example to ${REDMINE_DIR}/config/email.yml and edit this file to adjust your SMTP settings."
		ewarn
	fi
}
