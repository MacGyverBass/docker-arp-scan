FROM	alpine:3.12 AS compile

RUN	apk --no-cache add	\
		autoconf	\
		automake	\
		g++	\
		libpcap-dev	\
		make

RUN	wget "https://github.com/royhills/arp-scan/tarball/master" -O- |tar zxv	\
	&& mv -iv royhills-arp-scan-* /arp-scan

WORKDIR	/arp-scan/

RUN	autoreconf --install

RUN	CFLAGS="-Os -static -no-pie" ./configure

RUN	make


FROM	scratch

COPY	--from=compile	\
		/arp-scan/ieee-iab.txt	\
		/arp-scan/ieee-oui.txt	\
		/arp-scan/mac-vendor.txt	\
		/arp-scan/arp-scan	\
		/

ENTRYPOINT	["/arp-scan"]

