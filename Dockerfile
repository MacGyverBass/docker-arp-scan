FROM	alpine:3.12 AS compile

RUN	apk --no-cache add	\
		autoconf	\
		automake	\
		g++	\
		libpcap-dev	\
		make

WORKDIR	/arp-scan/

RUN	wget "https://github.com/royhills/arp-scan/tarball/master" -O- |tar zxv --strip-components=1

RUN	autoreconf --install

RUN	CFLAGS="-Os -static -no-pie" ./configure

RUN	make

RUN	strip -s arp-scan


FROM	scratch

COPY	--from=compile	\
		/arp-scan/ieee-iab.txt	\
		/arp-scan/ieee-oui.txt	\
		/arp-scan/mac-vendor.txt	\
		/arp-scan/arp-scan	\
		/

ENTRYPOINT	["/arp-scan"]

