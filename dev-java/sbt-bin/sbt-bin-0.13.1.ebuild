# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit java-utils-2

DESCRIPTION="sbt is a build tool for Scala and Java projects that aims to do the basics well"
HOMEPAGE="http://github.com/sbt/sbt"
SRC_URI="http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${PV}/sbt-launch.jar"

LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.6"

S=${WORKDIR}

src_unpack() {
    cp "${DISTDIR}/sbt-launch.jar" "${WORKDIR}/sbt-launch.jar"
}

src_install() {
    java-pkg_dojar sbt-launch.jar
    java-pkg_dolauncher sbt --main xsbt.boot.Boot --java_args "-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M"
}
